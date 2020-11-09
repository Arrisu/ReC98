#pragma option -3 -Z-
#pragma codeseg SHARED

extern "C" {
#include <dos.h>
#include <stddef.h>
#include "platform.h"
#include "pc98.h"
#include "planar.h"
#include "decomp.h"
#include "master.hpp"
#include "th03/formats/hfliplut.h"
}

#include "th03/formats/mrs.hpp"

#undef grcg_off
#define grcg_off() { \
	_AL ^= _AL; \
	__asm	out 0x7C, al; \
}

static const vram_byte_amount_t MRS_BYTE_W = (MRS_W / BYTE_DOTS);
static const vram_dword_amount_t MRS_DWORD_W = (MRS_BYTE_W / sizeof(dots32_t));

struct mrs_plane_t {
	dots32_t dots[MRS_DWORD_W][MRS_H];
};

// On-disk per-image structure
struct mrs_t {
	mrs_plane_t alpha;
	Planar<mrs_plane_t> planes;
};

extern mrs_t far *mrs_images[MRS_SLOT_COUNT];

// Decompilation workarounds
// -------------------------

// Points [reg_sgm]:[reg_off] to the alpha plane of the .MRS image in the
// given [slot].
#define mrs_slot_assign(reg_sgm, reg_off, slot) { \
	_BX = slot; \
	_BX <<= 2; \
	__asm { l##reg_sgm reg_off, mrs_images[bx]; } \
}

// Single iteration across [row_dword_w] 32-dot units of a .MRS image, from
// bottom to top. _DI is assumed to point at the bottom left target position,
// while [body] is responsible to increment _DI by [MRS_BYTE_W].
#define mrs_put_rows(row_dword_w, body) \
	do { \
		_CX = row_dword_w; \
		body \
		_DI -= (ROW_SIZE + MRS_BYTE_W); \
	} while(!FLAGS_CARRY);

// ZUN optimized mrs_put_noalpha_8() to blit 3 out of the 4 bitplanes within a
// single loop. Annoyingly, he does this by first moving the source pointer to
// the beginning of the G plane within a mrs_t instance, and then accesses the
// earlier planes with *negative* offsets, rather than, y'know, just using
// positive ones like a sane person.
// These offsets are encoded as immediates within the instructions that read
// the dot patterns. Subtracting the raw values wouldn't decompile correctly,
// but thankfully, pointer arithmetic does, and is also a lot cleaner...
// conceptually, at least. It also inlines perfectly, allowing us to give some
// meaningful names to these horrifying expressions.
struct mrs_at_G_t : public mrs_plane_t {
	dots32_t dots_from_alpha(void) const { return *(*((this - 3)->dots)); }
	dots32_t dots_from_B(void) const     { return *(*((this - 2)->dots)); }
	dots32_t dots_from_R(void) const     { return *(*((this - 1)->dots)); }
};

static inline mrs_at_G_t near* mrs_at_G(void) {
	return reinterpret_cast<mrs_at_G_t near *>(offsetof(mrs_t, planes.G));
}

// At least mrs_put_8() is somewhat sane.
struct mrs_at_B_t : public mrs_plane_t {
	dots32_t dots_from_alpha(void) const  { return *(*((this + 0)->dots)); }
	dots32_t dots_from_B(void) const      { return *(*((this + 1)->dots)); }
	dots32_t dots_from_R(void) const      { return *(*((this + 2)->dots)); }
	dots32_t dots_from_G(void) const      { return *(*((this + 3)->dots)); }
	dots32_t dots_from_E(void) const      { return *(*((this + 4)->dots)); }
};
// -------------------------

inline uint16_t to_bottom_left_8(const screen_x_t &left) {
	return ((left >> 3) + ((MRS_H - 1) * ROW_SIZE));
}

inline seg_t to_segment(const uscreen_y_t &top) {
	_AX = (top / 2); // screen_y_t -> vram_y_t...
	_DX = _AX;
	return ((_AX << 2) + _DX); // ... and -> segment
}

void pascal mrs_put_8(screen_x_t left, uscreen_y_t top, int slot)
{
	#define _SI	reinterpret_cast<mrs_at_B_t near *>(_SI)

	grcg_setcolor(GC_RMW, 0);
	_DI = to_bottom_left_8(left);
	_AX = to_segment(top);

	// "I've spent good money on that Intel 386 CPU, so let's actually use
	// *all* its segment registers!" :zunpet: :zunpet: :zunpet:
	_ES = (_AX += SEG_PLANE_B);       	// = B
	_FS = (_AX += SEG_PLANE_DIST_BRG);	// = R
	_GS = (_AX += SEG_PLANE_DIST_BRG);	// = G

	__asm { push ds; }
	mrs_slot_assign(ds, si, slot);

	_DX = MRS_DWORD_W;
	__asm { nop; }
	mrs_put_rows(_DX, REP MOVSD);
	grcg_off();

	// Reset to bottom left
	_SI = 0;
	_DI += (MRS_H * ROW_SIZE);

	_BX = (_GS + SEG_PLANE_DIST_E); // = E
	_DX = MRS_DWORD_W;
	mrs_put_rows(_DX, { put:
		_EAX = _SI->dots_from_alpha();
		_EAX |= _EAX;
		if(!FLAGS_ZERO) {
			poke_or_d(_ES, _DI, _SI->dots_from_B());
			poke_or_d(_FS, _DI, _SI->dots_from_R());
			poke_or_d(_GS, _DI, _SI->dots_from_G());
			_GS = _BX;
			poke_or_d(_GS, _DI, _SI->dots_from_E());
			_GS = (_BX - SEG_PLANE_DIST_E);
		}
		reinterpret_cast<uint16_t>(_SI) += sizeof(dots32_t);
		_DI += sizeof(dots32_t);
		__asm { loop put; }
	});

	__asm { pop	ds; }

	#undef _SI
}

#pragma codestring "\x90"

void pascal mrs_put_noalpha_8(
	screen_x_t left, uscreen_y_t top, int slot, bool altered_colors
)
{
	#define _SI	reinterpret_cast<mrs_at_G_t near *>(_SI)
	#define at_bottom_left	_DX // *Not* rooted at (0, 0)!

	__asm { push ds; }
	_DI = to_bottom_left_8(left);
	_AX = to_segment(top);
	mrs_slot_assign(ds, si, slot);
	_SI = mrs_at_G();

	_FS = (_AX += SEG_PLANE_B);       	// = B
	_GS = (_AX += SEG_PLANE_DIST_BRG);	// = R
	_ES = (_AX += SEG_PLANE_DIST_BRG);	// = G
	// At this point though, we're out of segment registers. That's why this
	// approach of not changing destination segments within a blitting loop
	// only works for 3 out of the 4 bitplanes, and why we need a second loop
	// for the final one after all.
	_BX = (_AX += SEG_PLANE_DIST_E);  	// = E
	at_bottom_left = _DI;
	if(altered_colors) {
		mrs_put_rows(MRS_DWORD_W, { put_altered:
			poked(_FS, _DI, (~_SI->dots_from_alpha() | _SI->dots_from_B()));
			poked(_GS, _DI, _SI->dots_from_R());
			MOVSD;
			__asm { loop put_altered; }
		});
		// SI is now at the beginning of the E plane. Blit it in its own loop
		_DI = at_bottom_left;
		_ES = _BX;
		mrs_put_rows(MRS_DWORD_W, REP MOVSD);
	} else {
		mrs_put_rows(MRS_DWORD_W, { put_regular:
			poked(_FS, _DI, _SI->dots_from_B());
			poked(_GS, _DI, _SI->dots_from_R());
			MOVSD;
			_asm { loop put_regular; }
		});
		// SI is now at the beginning of the E plane. Blit it in its own loop
		_DI = at_bottom_left;
		_ES = _BX;
		mrs_put_rows(MRS_DWORD_W, REP MOVSD);
	}
	__asm { pop	ds; }

	#undef at_bottom_left
	#undef _SI
}

#pragma codestring "\x90"

void pascal mrs_hflip(int slot)
{
	_CX = sizeof(mrs_t);
	mrs_slot_assign(es, di, slot);
	reinterpret_cast<dots8_t near *>(_BX) = hflip_lut;

	flip_dots_within_bytes: __asm {
		mov 	al, es:[di];
		xlat;
		mov 	es:[di], al;
		inc 	di;
		loop	flip_dots_within_bytes;
	}

	_CX = (sizeof(mrs_t) / MRS_BYTE_W);
	/* vram_byte_amount_t offset_y */ _BX = 0;

	flip_bytes: {
		// Assumes that the offset part of all image pointers is 0. Storing
		// segment pointers in [mrs_images] would have been clearer in this
		// case...
		/* vram_byte_amount_t offset_left  */ _DI = 0;
		/* vram_byte_amount_t offset_right */ _SI = (MRS_BYTE_W - 1);
		do {
			__asm {
				mov al, es:[bx+di]
				mov dl, es:[bx+si]
				mov es:[bx+si], al
				mov es:[bx+di], dl
			}
			_SI--;
			_DI++;
		} while(_DI <= ((MRS_BYTE_W / 2) - 1));
		_BX += MRS_BYTE_W;
		__asm { loop flip_bytes; }
	}
}

#pragma codestring "\x90"

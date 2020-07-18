#include "th01/main/vars.hpp"
#include "th01/formats/ptn.hpp"
#include "th01/main/playfld.hpp"
#include "th01/main/player/player.hpp"
#include "th01/sprites/main_ptn.h"
#include "th01/main/hud/hud.hpp"

/// Constants
/// ---------
static const int SCORE_LEFT = 256;
static const int MAX_TOP = 0;
static const int CUR_TOP = 16;

static const int MAX_FX = FX(7, 2, 0);
static const int CUR_FX = FX(7, 3, 0);

#if (PTN_QUARTER_W < GLYPH_FULL_W)
	#error Original code assumes PTN_QUARTER_W >= GLYPH_FULL_W
#endif
static const int COL_W = PTN_QUARTER_W;

static const int SCORE_W = (SCORE_DIGITS * COL_W);

static const int CARDCOMBO_LEFT = (SCORE_LEFT + ((SCORE_DIGITS + 2) * COL_W));
static const int CARDCOMBO_W = (CARDCOMBO_DIGITS * COL_W);
static const int CARDCOMBO_RIGHT = (CARDCOMBO_LEFT + CARDCOMBO_W);

static const int SCORE_AND_CARDCOMBO_W = (CARDCOMBO_RIGHT - SCORE_LEFT);
/// ---------

/// Globals
/// -------
// Forces re-rendering of all full-width numbers on the HUD, even if they
// haven't changed since the last render call.
extern unsigned char fwnum_force_rerender;

extern unsigned char hud_cardcombo_max; // Why a separate variable???
/// -------

/// Functions
/// ---------
inline int col_left(int first_left, int col) {
	return (first_left + (col * COL_W));
}

#define bg_put(first_left, col, top, ptn_id, quarter) \
	ptn_put_quarter_noalpha_8(col_left(first_left, col), top, ptn_id, quarter)

#define bg_snap(first_left, col, top, ptn_id, quarter) \
	ptn_snap_quarter_8(col_left(first_left, col), top, ptn_id, quarter)

#define ptn_id_and_quarter_from_i(func, first_left, col, top, ptn_id_base, i) \
	func(first_left, col, top, (ptn_id_base + (i / 4)), (i % 4))

#define digit_changed(var, var_prev, divisor) \
	((var_prev / divisor) % 10) != ((var / divisor) % 10) || \
	(fwnum_force_rerender == 1)

// Copies the (⌊[w]/16⌋*16)×[ROW_H] pixels starting at (⌊left/8⌋*8, top) from
// VRAM page 0 to VRAM page 1.
void graph_copy_hud_row_0_to_1_8(int left, int top, int w);
/// ---------
}

template <class T1, class T2> inline void fwnum_put(
	int left, int top, int fx, int digits, const T1 &val, const T2 &val_prev
) {
	graph_putfwnum_fx(
		left, top, fx, digits, val,
		(fwnum_force_rerender == true) ? 0 : val_prev, true
	);
}

#define score_bg(func, digit, top, ptn_id_base) \
	ptn_id_and_quarter_from_i(func, SCORE_LEFT, digit, top, ptn_id_base, digit)

#define score_max_bg(func, digit) \
	score_bg(func, digit, MAX_TOP, PTN_BG_MAX_SCORE)

inline void score_put(int top, int fx, const long &prev) {
	fwnum_put(SCORE_LEFT, top, fx, SCORE_DIGITS, score, prev);
}

#define cardcombo_bg(func, digit, top, ptn_id) \
	func(CARDCOMBO_LEFT, digit, top, ptn_id, digit)

#define cardcombo_max_bg(func, digit) \
	cardcombo_bg(func, digit, MAX_TOP, PTN_BG_MAX_CARDCOMBO)

inline void cardcombo_put(int top, int fx, const int &prev) {
	fwnum_put(CARDCOMBO_LEFT, top, fx, CARDCOMBO_DIGITS, cardcombo_cur, prev);
}

extern "C" {

void hiscore_update_and_render(void)
{
	// TODO: Should just be `static` once the variable can be declared here
	#define prev score_prev
	extern long prev;
	long divisor = 1000000; // Must match SCORE_DIGITS!
	unsigned long hiscore = resident->hiscore;

	if(hiscore >= score) {
		return;
	}
	for(int i = 0; i < SCORE_DIGITS; i++) {
		if(digit_changed(score, prev, divisor)) {
			graph_accesspage_func(1);	score_max_bg(bg_put, i);
			graph_accesspage_func(0);	score_max_bg(bg_put, i);
		}
		divisor /= 10;
	}
	graph_accesspage_func(1);	score_put(MAX_TOP, MAX_FX, prev);
	graph_accesspage_func(0);	score_put(MAX_TOP, MAX_FX, prev);

	prev = score;
	resident->hiscore = score;
	#undef prev
}

void cardcombo_max_render(void)
{
	// TODO: Should just be `static` once the variable can be declared here
	#define prev cardcombo_max_prev
	extern int prev;
	int divisor = 10; // Must match CARDCOMBO_DIGITS!

	for(int i = 0; i < CARDCOMBO_DIGITS; i++) {
		if(digit_changed(cardcombo_cur, prev, divisor)) {
			graph_accesspage_func(1);	cardcombo_max_bg(bg_put, i);
			graph_accesspage_func(0);	cardcombo_max_bg(bg_put, i);
		}
		divisor /= 10;
	}
	graph_accesspage_func(1);	cardcombo_put(MAX_TOP, MAX_FX, prev);
	graph_accesspage_func(0);	cardcombo_put(MAX_TOP, MAX_FX, prev);

	prev = cardcombo_cur;
	#undef prev
}

void hud_score_and_cardcombo_render(void)
{
	// TODO: Should just be `static` once the variable can be declared here
	#define score_prev score_cur_prev
	#define cardcombo_prev cardcombo_cur_prev
	extern long score_prev;
	extern int cardcombo_prev;

	int digit;
	int page;
	int cardcombo_divisor;
	long score_divisor;

	score_divisor = 1000000; // Must match SCORE_DIGITS!
	cardcombo_divisor = 10; // Must match CARDCOMBO_DIGITS!
	for(page = 1; page >= 0; page--) {
		graph_accesspage_func(page);
		score_divisor = 1000000; // Must match SCORE_DIGITS!
		cardcombo_divisor = 10; // Must match CARDCOMBO_DIGITS!

		for(digit = 0; digit < SCORE_DIGITS; digit++) {
			if(digit_changed(score, score_prev, score_divisor)) {
				score_bg(bg_put, digit, CUR_TOP, PTN_BG_CUR_SCORE);
			}
			score_divisor /= 10;
		}
		score_put(CUR_TOP, CUR_FX, score_prev);

		for(digit = 0; digit < CARDCOMBO_DIGITS; digit++) {
			if(digit_changed(cardcombo_cur, cardcombo_prev, cardcombo_divisor)) {
				cardcombo_bg(bg_put, digit, CUR_TOP, PTN_BG_CUR_CARDCOMBO);
			}
			cardcombo_divisor /= 10;
		}
		cardcombo_put(CUR_TOP, CUR_FX, cardcombo_prev);
	}

	score_prev = score;
	cardcombo_prev = cardcombo_cur;
	hiscore_update_and_render();
	if(hud_cardcombo_max < cardcombo_cur) {
		hud_cardcombo_max = cardcombo_cur;
		cardcombo_max_render();
	}
}

#define cardcombo_bg_loop(func, digit, top, ptn_id) \
	for(digit = 0; digit < CARDCOMBO_DIGITS; digit++) { \
		cardcombo_bg(func, digit, top, ptn_id); \
	} \

inline void cardcombo_put_initial(int top, int fx) {
	graph_putfwnum_fx(CARDCOMBO_LEFT, top, fx, CARDCOMBO_DIGITS, 0, 99, true);
}

#define score_snap_bg_and_put(digit, top, ptn_id, fx, score) \
	graph_accesspage_func(1); \
	for(digit = 0; digit < SCORE_DIGITS; digit++) { \
		score_bg(bg_snap, digit, top, ptn_id); \
	} \
	graph_accesspage_func(0); \
	graph_putfwnum_fx(SCORE_LEFT, top, fx, SCORE_DIGITS, score, 0, true);

// Setting [first_run] to false will only reset the card combo display.
void score_and_cardcombo_put_initial(bool16 first_run)
{
	int digit;

	// Spot the difference… :(
	if(first_run) {
		score_snap_bg_and_put(digit, CUR_TOP, PTN_BG_CUR_SCORE, CUR_FX, score);
		graph_accesspage_func(1);
		cardcombo_bg_loop(bg_snap, digit, CUR_TOP, PTN_BG_CUR_CARDCOMBO);
	} else {
		cardcombo_bg_loop(bg_put, digit, CUR_TOP, PTN_BG_CUR_CARDCOMBO);
	}
	graph_accesspage_func(0);
	cardcombo_put_initial(CUR_TOP, CUR_FX);

	if(first_run) {
		score_snap_bg_and_put(
			digit, MAX_TOP, PTN_BG_MAX_SCORE, MAX_FX, resident->hiscore
		);
		graph_accesspage_func(1);
		cardcombo_bg_loop(bg_snap, digit, MAX_TOP, PTN_BG_MAX_CARDCOMBO);
		graph_accesspage_func(0);
	} else {
		cardcombo_bg_loop(bg_put, digit, MAX_TOP, PTN_BG_MAX_CARDCOMBO);
	}
	cardcombo_put_initial(MAX_TOP, MAX_FX);

	/* TODO: Replace with the decompiled calls
	 * 	graph_copy_hud_row_0_to_1_8(SCORE_LEFT, MAX_TOP, SCORE_AND_CARDCOMBO_W);
	 * 	graph_copy_hud_row_0_to_1_8(SCORE_LEFT, CUR_TOP, SCORE_AND_CARDCOMBO_W);
	 * once that function is part of this translation unit */
	#define call(top) __asm { \
		db  	0x66, 0x68, top, 0x00, SCORE_AND_CARDCOMBO_W, 0x00; \
		push	SCORE_LEFT; \
		nop; \
		push	cs; \
		call	near ptr graph_copy_hud_row_0_to_1_8; \
		add 	sp, 6; \
	}
	call(MAX_TOP);
	call(CUR_TOP);

	hud_cardcombo_max = 0;
}

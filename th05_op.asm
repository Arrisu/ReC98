;
; +-------------------------------------------------------------------------+
; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |        Copyright (c) 2009 by Hex-Rays, <support@hex-rays.com>           |
; +-------------------------------------------------------------------------+
;
; Input	MD5   :	F97D1B72F01476639E9D33E361F57330

; File Name   :	th05/OP.EXE
; Format      :	MS-DOS executable (EXE)
; Base Address:	0h Range: 0h-14240h Loaded length: 1280Ah
; Entry	Point :	0:0
; OS type	  :  MS	DOS
; Application type:  Executable	16bit

		.386
		.model use16 large _TEXT

BINARY = 'O'

include ReC98.inc
include th05/th05.inc
include th04/hardware/grppsafx.inc
include th04/sprites/op_cdg.inc
include th05/op/music.inc
include th05/op/piano.inc

op_01 group OP_SETUP_TEXT, op_01_TEXT, HI_VIEW_TEXT

; ===========================================================================

_TEXT	segment	word public 'CODE' use16
	extern PALETTE_BLACK_IN:proc
	extern PALETTE_BLACK_OUT:proc
	extern FILE_CLOSE:proc
	extern FILE_CREATE:proc
	extern FILE_EXIST:proc
	extern FILE_READ:proc
	extern FILE_ROPEN:proc
	extern FILE_SEEK:proc
	extern FILE_WRITE:proc
	extern GRCG_BYTEBOXFILL_X:proc
	extern GRCG_POLYGON_C:proc
	extern GRCG_SETCOLOR:proc
	extern GRAPH_CLEAR:proc
	extern GRAPH_COPY_PAGE:proc
	extern PALETTE_SHOW:proc
	extern IRAND:proc
	extern TEXT_CLEAR:proc
	extern HMEM_ALLOCBYTE:proc
	extern HMEM_FREE:proc
	extern SUPER_FREE:proc
	extern SUPER_ENTRY_BFNT:proc
	extern SUPER_PUT_RECT:proc
	extern SUPER_PUT:proc
	extern GRAPH_GAIJI_PUTS:proc
	extern GRAPH_GAIJI_PUTC:proc
	extern PFSTART:proc
	extern PFEND:proc
_TEXT	ends

; ===========================================================================

; Segment type:	Pure code
OP_SETUP_TEXT segment byte public 'CODE' use16
		assume cs:op_01
		assume es:nothing, ss:nothing, ds:_DATA, fs:nothing, gs:nothing

include th04/zunsoft.asm
OP_SETUP_TEXT ends

op_01_TEXT segment byte public 'CODE' use16
	@TRACK_UNPUT_OR_PUT$QUCI procdesc pascal near \
		track_sel:byte, boot:word
	@TRACKLIST_PUT$QUC procdesc pascal near \
		sel:byte

include th02/op/music.asm
include th05/op/music_cmt_load.asm

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame
public DRAW_CMT_LINES
draw_cmt_lines	proc pascal near
		local @@y:word

		push	si
		push	di
		call	graph_putsa_fx pascal, (320 shl 16) or 32, 7, ds, offset _music_cmt
		mov	si, offset _music_cmt + MUSIC_CMT_LINE_LEN
		mov	di, 1
		mov	@@y, 180
		jmp	short loc_C36D
; ---------------------------------------------------------------------------

loc_C351:
		cmp	byte ptr [si], ';'
		jz	short loc_C365
		call	graph_putsa_fx pascal, 320, @@y, 7, ds, si

loc_C365:
		inc	di
		add	@@y, 16
		add	si, MUSIC_CMT_LINE_LEN

loc_C36D:
		cmp	di, MUSIC_CMT_LINE_COUNT
		jl	short loc_C351
		pop	di
		pop	si
		ret
draw_cmt_lines	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_C376	proc near
		push	bp
		mov	bp, sp
		push	si
		mov	si, FX_MASK
		jmp	short loc_C390
; ---------------------------------------------------------------------------

loc_C37F:
		mov	_graph_putsa_fx_func, si
		call	draw_cmt_lines
		call	music_flip
		call	draw_cmt_lines
		call	music_flip
		inc	si

loc_C390:
		cmp	si, FX_MASK_END
		jl	short loc_C37F
		mov	_graph_putsa_fx_func, FX_WEIGHT_BOLD
		call	draw_cmt_lines
		call	music_flip
		call	draw_cmt_lines
		pop	si
		pop	bp
		retn
sub_C376	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_C3A7	proc near
		push	bp
		mov	bp, sp
		mov	_graph_putsa_fx_func, FX_WEIGHT_BOLD
		call	bgimage_put_rect_16 pascal, (320 shl 16) or  32, (320 shl 16) or  16
		call	bgimage_put_rect_16 pascal, (320 shl 16) or 180, (320 shl 16) or 144
		call	music_flip
		call	bgimage_put_rect_16 pascal, (320 shl 16) or  32, (320 shl 16) or  16
		call	bgimage_put_rect_16 pascal, (320 shl 16) or 180, (320 shl 16) or 144
		pop	bp
		retn
sub_C3A7	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame
public DRAW_CMT
draw_cmt	proc near

@@track		= word ptr  4

		push	bp
		mov	bp, sp
		cmp	byte_13E96, 0
		jz	short loc_C406
		call	sub_C3A7

loc_C406:
		call	music_cmt_load pascal, [bp+@@track]
		call	screen_back_B_put
		call	bgimage_put_rect_16 pascal, (320 shl 16) or 64, (320 shl 16) or 256
		cmp	byte_13E96, 0
		jz	short loc_C42C
		call	sub_C376
		jmp	short loc_C43A
; ---------------------------------------------------------------------------

loc_C42C:
		mov	byte_13E96, 1
		call	draw_cmt_lines
		call	music_flip
		call	draw_cmt_lines

loc_C43A:
		call	screen_back_B_put
		pop	bp
		retn	2
draw_cmt	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_C441	proc near

arg_0		= word ptr  4

		push	bp
		mov	bp, sp
		push	si
		mov	si, [bp+arg_0]
		call	bgimage_put_rect_16 pascal, large (0 shl 16) or 32, (320 shl 16) or  16
		call	bgimage_put_rect_16 pascal, large (0 shl 16) or 96, (320 shl 16) or 192
		call	@tracklist_put$quc pascal, si
		call	music_flip
		call	bgimage_put_rect_16 pascal, large (0 shl 16) or 32, (320 shl 16) or  16
		call	bgimage_put_rect_16 pascal, large (0 shl 16) or 96, (320 shl 16) or 192
		call	@tracklist_put$quc pascal, si
		pop	si
		pop	bp
		retn	2
sub_C441	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame
public _musicroom
_musicroom	proc near

@@sel		= byte ptr -1

		enter	2, 0
		push	si
		xor	si, si
		mov	_track_id_at_top, 0
		mov	_track_playing, 0
		mov	_music_sel, 0
		mov	bx, _game_sel
		add	bx, bx
		mov	ax, _TRACK_COUNT[bx]
		mov	_track_count_cur, ax
		mov	byte_13E96, 0
		call	cdg_free_all
		call	text_clear
		mov	_music_page, 1
		mov	PaletteTone, 0
		call	far ptr	palette_show
		graph_showpage 0
		graph_accesspage al
		call	graph_clear
		graph_accesspage 1
		call	pi_load pascal, 0, ds, offset aMusic_pi
		call	pi_palette_apply pascal, 0
		call	pi_put_8 pascal, large 0, 0
		call	pi_free pascal, 0
		call	@piano_setup_and_put_initial$qv
		call	screen_back_B_snap
		call	_bgimage_snap
		call	@tracklist_put$quc pascal, word ptr _music_sel
		call	graph_copy_page pascal, 0
		graph_accesspage 1
		graph_showpage 0
		call	pfend
		call	pfstart pascal, ds, offset aMusic_dat ; "music.dat"
		mov	al, _music_sel
		mov	ah, 0
		call	draw_cmt pascal, ax
		mov	PaletteTone, 100
		call	far ptr	palette_show

loc_C555:
		call	_input_reset_sense_held
		cmp	_key_det, INPUT_NONE
		jz	short loc_C57F
		cmp	si, 18h
		jl	short loc_C579
		cmp	_key_det, INPUT_UP
		jz	short loc_C574
		cmp	_key_det, INPUT_DOWN
		jnz	short loc_C579

loc_C574:
		mov	si, 14h
		jmp	short loc_C57F
; ---------------------------------------------------------------------------

loc_C579:
		inc	si
		call	music_flip
		jmp	short loc_C555
; ---------------------------------------------------------------------------

loc_C57F:
		call	_input_reset_sense_held
		test	_key_det.lo, low INPUT_UP
		jz	short loc_C5EB
		mov	al, _music_sel
		mov	[bp+@@sel], al
		cmp	_music_sel, 0
		jbe	short loc_C5D5
		dec	_music_sel
		mov	al, _music_sel
		mov	ah, 0
		cmp	ax, _track_id_at_top
		jge	short loc_C5AE
		mov	al, _music_sel
		mov	ah, 0
		jmp	short loc_C61C
; ---------------------------------------------------------------------------

loc_C5AE:
		call	@track_unput_or_put$quci pascal, word ptr [bp+@@sel], 0
		call	@track_unput_or_put$quci pascal, word ptr _music_sel, 1
		call	music_flip
		call	@track_unput_or_put$quci pascal, word ptr [bp+@@sel], 0
		call	@track_unput_or_put$quci pascal, word ptr _music_sel, 1
		jmp	short loc_C5EB
; ---------------------------------------------------------------------------

loc_C5D5:
		mov	al, byte ptr _track_count_cur
		mov	_music_sel, al
		mov	ax, _track_count_cur
		add	ax, -11
		mov	_track_id_at_top, ax
		push	_track_count_cur
		call	sub_C441

loc_C5EB:
		test	_key_det.lo, low INPUT_DOWN
		jz	short loc_C666
		mov	al, _music_sel
		mov	[bp+@@sel], al
		mov	ah, 0
		cmp	ax, _track_count_cur
		jge	short loc_C652
		inc	_music_sel
		mov	al, _music_sel
		mov	ah, 0
		mov	dx, _track_id_at_top
		add	dx, 12
		cmp	ax, dx
		jl	short loc_C62B
		mov	al, _music_sel
		mov	ah, 0
		add	ax, -11

loc_C61C:
		mov	_track_id_at_top, ax
		mov	al, _music_sel
		mov	ah, 0
		push	ax
		call	sub_C441
		jmp	loc_C6E3
; ---------------------------------------------------------------------------

loc_C62B:
		call	@track_unput_or_put$quci pascal, word ptr [bp+@@sel], 0
		call	@track_unput_or_put$quci pascal, word ptr _music_sel, 1
		call	music_flip
		call	@track_unput_or_put$quci pascal, word ptr [bp+@@sel], 0
		call	@track_unput_or_put$quci pascal, word ptr _music_sel, 1
		jmp	short loc_C666
; ---------------------------------------------------------------------------

loc_C652:
		mov	_music_sel, 0
		mov	_track_id_at_top, 0
		mov	al, _music_sel
		mov	ah, 0
		push	ax
		call	sub_C441

loc_C666:
		test	_key_det.lo, low INPUT_LEFT
		jz	short loc_C680
		dec	_game_sel
		cmp	_game_sel, 0
		jge	short loc_C698
		mov	_game_sel, 4
		jmp	short loc_C698
; ---------------------------------------------------------------------------

loc_C680:
		test	_key_det.lo, low INPUT_RIGHT
		jz	short loc_C6E3
		inc	_game_sel
		cmp	_game_sel, 5
		jl	short loc_C698
		mov	_game_sel, 0

loc_C698:
		mov	_music_sel, 0
		mov	_track_playing, 0
		mov	_track_id_at_top, 0
		mov	bx, _game_sel
		add	bx, bx
		mov	ax, _TRACK_COUNT[bx]
		mov	_track_count_cur, ax
		push	0
		call	sub_C441
		kajacall	KAJA_SONG_FADE, 32
		call	draw_cmt pascal, 0
		mov	bx, _game_sel
		imul	bx, 78h
		call	snd_load pascal, dword ptr _MUSIC_FILES[bx], SND_LOAD_SONG
		kajacall	KAJA_SONG_PLAY

loc_C6E3:
		test	_key_det.lo, low INPUT_SHOT
		jnz	short loc_C6F1
		test	_key_det.hi, high INPUT_OK
		jz	short loc_C767

loc_C6F1:
		mov	al, _music_sel
		mov	ah, 0
		cmp	ax, _track_count_cur
		jz	loc_C77F
		kajacall	KAJA_SONG_FADE, 32
		mov	al, byte ptr _track_playing
		mov	[bp+@@sel], al
		mov	al, _music_sel
		mov	ah, 0
		mov	_track_playing, ax
		call	@track_unput_or_put$quci pascal, word ptr [bp+@@sel], 0
		call	@track_unput_or_put$quci pascal, word ptr _music_sel, 1
		call	music_flip
		call	@track_unput_or_put$quci pascal, word ptr [bp+@@sel], 0
		call	@track_unput_or_put$quci pascal, word ptr _music_sel, 1
		mov	al, _music_sel
		mov	ah, 0
		call	draw_cmt pascal, ax
		mov	bx, _game_sel
		imul	bx, 78h
		mov	al, _music_sel
		mov	ah, 0
		shl	ax, 2
		add	bx, ax
		call	snd_load pascal, dword ptr _MUSIC_FILES[bx], SND_LOAD_SONG
		kajacall	KAJA_SONG_PLAY

loc_C767:
		test	_key_det.hi, high INPUT_CANCEL
		jnz	short loc_C77F
		cmp	_key_det, INPUT_NONE
		jnz	loc_C555
		xor	si, si
		call	music_flip
		jmp	loc_C57F
; ---------------------------------------------------------------------------

loc_C77F:
		call	_input_reset_sense_held
		cmp	_key_det, INPUT_NONE
		jz	short loc_C790
		call	music_flip
		jmp	short loc_C77F
; ---------------------------------------------------------------------------

loc_C790:
		call	pfend
		call	pfstart pascal, ds, offset aKaikidan1_dat1
		kajacall	KAJA_SONG_FADE, 16
		call	screen_back_B_free
		graph_showpage 0
		graph_accesspage al
		push	1
		call	palette_black_out
		call	_bgimage_free
		call	snd_load pascal, ds, offset aH_op+2, SND_LOAD_SONG
		kajacall	KAJA_SONG_PLAY
		pop	si
		leave
		retn
_musicroom	endp

include th04/formats/scoredat_decode_both.asm
include th04/formats/scoredat_encode.asm
include th05/formats/scoredat_recreate_op.asm
include th05/formats/scoredat_load_for.asm

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_CA1B	proc near

var_2		= word ptr -2
arg_0		= word ptr  4
@@y		= word ptr  6
arg_4		= word ptr  8

		enter	2, 0
		push	si
		push	di
		mov	si, [bp+arg_4]
		mov	di, [bp+arg_0]
		mov	bx, di
		shl	bx, 3
		mov	al, _hi.score.g_score[bx][SCORE_DIGITS - 1]
		mov	ah, 0
		add	ax, -gb_0_
		cmp	ax, 10
		jl	short loc_CA5B
		lea	ax, [si-16]
		push	ax
		push	[bp+@@y]
		mov	bx, di
		shl	bx, 3
		mov	al, _hi.score.g_score[bx][SCORE_DIGITS - 1]
		mov	ah, 0
		add	ax, -gb_0_
		mov	bx, 10
		cwd
		idiv	bx
		push	ax
		call	super_put

loc_CA5B:
		push	si
		push	[bp+@@y]
		mov	bx, di
		shl	bx, 3
		mov	al, _hi.score.g_score[bx][SCORE_DIGITS - 1]
		mov	ah, 0
		add	ax, -gb_0_
		mov	bx, 10
		cwd
		idiv	bx
		push	dx
		call	super_put
		add	si, 16
		mov	[bp+var_2], 6
		jmp	short loc_CAA4
; ---------------------------------------------------------------------------

loc_CA83:
		push	si
		push	[bp+@@y]
		mov	bx, di
		shl	bx, 3
		add	bx, [bp+var_2]
		mov	al, _hi.score.g_score[bx]
		mov	ah, 0
		add	ax, -gb_0_
		push	ax
		call	super_put
		dec	[bp+var_2]
		add	si, 16

loc_CAA4:
		cmp	[bp+var_2], 0
		jge	short loc_CA83
		pop	di
		pop	si
		leave
		retn	6
sub_CA1B	endp

include th04/hiscore/hiscore_stage_put.asm

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_CB00	proc near

@@color		= word ptr -2
arg_0		= word ptr  4
arg_2		= word ptr  6

		enter	2, 0
		push	si
		push	di
		cmp	[bp+arg_0], 0
		jnz	short loc_CB3A
		mov	bx, [bp+arg_2]
		cmp	bx, 3
		ja	short loc_CB33
		add	bx, bx
		jmp	cs:off_CBD4[bx]

loc_CB1B:
		mov	si, 8
		jmp	short loc_CB23
; ---------------------------------------------------------------------------

loc_CB20:
		mov	si, 328

loc_CB23:
		mov	di, 88
		jmp	short loc_CB33
; ---------------------------------------------------------------------------

loc_CB28:
		mov	si, 8
		jmp	short loc_CB30
; ---------------------------------------------------------------------------

loc_CB2D:
		mov	si, 328

loc_CB30:
		mov	di, 224

loc_CB33:
		mov	[bp+@@color], 7
		jmp	short loc_CB74
; ---------------------------------------------------------------------------

loc_CB3A:
		mov	bx, [bp+arg_2]
		cmp	bx, 3
		ja	short loc_CB6F
		add	bx, bx
		jmp	cs:off_CBCC[bx]

loc_CB49:
		mov	si, 8
		jmp	short loc_CB51
; ---------------------------------------------------------------------------

loc_CB4E:
		mov	si, 328

loc_CB51:
		mov	ax, [bp+arg_0]
		shl	ax, 4
		add	ax, 96
		jmp	short loc_CB6D
; ---------------------------------------------------------------------------

loc_CB5C:
		mov	si, 8
		jmp	short loc_CB64
; ---------------------------------------------------------------------------

loc_CB61:
		mov	si, 328

loc_CB64:
		mov	ax, [bp+arg_0]
		shl	ax, 4
		add	ax, 232

loc_CB6D:
		mov	di, ax

loc_CB6F:
		mov	[bp+@@color], 2

loc_CB74:
		lea	ax, [si+2]
		push	ax
		lea	ax, [di+2]
		push	ax
		push	GAIJI_W
		mov	ax, [bp+arg_0]
		imul	ax, (SCOREDAT_NAME_LEN + 1)
		add	ax, offset _hi.score.g_name
		push	ds
		push	ax
		push	14
		call	graph_gaiji_puts
		push	si
		push	di
		push	GAIJI_W
		mov	ax, [bp+arg_0]
		imul	ax, (SCOREDAT_NAME_LEN + 1)
		add	ax, offset _hi.score.g_name
		push	ds
		push	ax
		push	[bp+@@color]
		call	graph_gaiji_puts
		lea	ax, [si+150]
		call	sub_CA1B pascal, ax, di, [bp+arg_0]
		lea	ax, [si+286]
		push	ax
		push	di
		mov	bx, [bp+arg_0]
		mov	al, _hi.score.g_stage[bx]
		mov	ah, 0
		push	ax
		call	hiscore_stage_put
		pop	di
		pop	si
		leave
		retn	4
sub_CB00	endp

; ---------------------------------------------------------------------------
off_CBCC	dw offset loc_CB49
		dw offset loc_CB4E
		dw offset loc_CB5C
		dw offset loc_CB61
off_CBD4	dw offset loc_CB1B
		dw offset loc_CB20
		dw offset loc_CB28
		dw offset loc_CB2D

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame
public _score_render
_score_render proc near
		push	bp
		mov	bp, sp
		push	si
		push	di
		graph_accesspage 1
		call	pi_palette_apply pascal, 0
		call	pi_put_8 pascal, large 0, 0
		graph_accesspage 0
		call	pi_palette_apply pascal, 0
		call	pi_put_8 pascal, large 0, 0
		xor	si, si
		jmp	short loc_CC27
; ---------------------------------------------------------------------------

loc_CC13:
		call	scoredat_load_for pascal, si
		xor	di, di
		jmp	short loc_CC21
; ---------------------------------------------------------------------------

loc_CC1B:
		push	si
		push	di
		call	sub_CB00
		inc	di

loc_CC21:
		cmp	di, 5
		jl	short loc_CC1B
		inc	si

loc_CC27:
		cmp	si, 4
		jl	short loc_CC13
		push	(496 shl 16) or 376
		mov	al, _rank
		mov	ah, 0
		add	ax, ax
		add	ax, 20
		push	ax
		call	super_put
		push	(560 shl 16) or 376
		mov	al, _rank
		mov	ah, 0
		add	ax, ax
		add	ax, 21
		push	ax
		call	super_put
		pop	di
		pop	si
		pop	bp
		retn
_score_render endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame
public _regist_view_menu
_regist_view_menu proc near
		push	bp
		mov	bp, sp
		kajacall	KAJA_SONG_STOP
		call	snd_load pascal, ds, offset aName, SND_LOAD_SONG
		kajacall	KAJA_SONG_PLAY
		kajacall	KAJA_SONG_FADE, -128
		push	1
		call	palette_black_out
		les	bx, _resident
		mov	al, es:[bx+resident_t.rank]
		mov	_rank, al
		call	pi_load pascal, 0, ds, offset aHi01_pi

loc_CC9F:
		call	_score_render
		call	palette_black_in pascal, 1

loc_CCA9:
		call	_input_reset_sense_held
		call	@frame_delay$qi pascal, 1
		test	_key_det.hi, high INPUT_OK
		jnz	short loc_CD17
		test	_key_det.lo, low INPUT_SHOT
		jnz	short loc_CD17
		test	_key_det.hi, high INPUT_CANCEL
		jnz	short loc_CD17
		test	_key_det.hi, high INPUT_OK
		jnz	short loc_CD17
		test	_key_det.lo, low INPUT_LEFT
		jz	short loc_CCF8
		cmp	_rank, RANK_EASY
		jz	short loc_CCF8
		dec	_rank
		mov	PaletteTone, 0
		call	far ptr	palette_show
		call	_score_render
		call	palette_black_in pascal, 1

loc_CCF8:
		test	_key_det.lo, low INPUT_RIGHT
		jz	short loc_CCA9
		cmp	_rank, RANK_EXTRA
		jnb	short loc_CCA9
		inc	_rank
		mov	PaletteTone, 0
		call	far ptr	palette_show
		jmp	short loc_CC9F
; ---------------------------------------------------------------------------

loc_CD17:
		kajacall	KAJA_SONG_FADE, 1
		call	palette_black_out pascal, 1
		call	pi_free pascal, 0
		graph_accesspage 1
		call	pi_load pascal, 0, ds, offset aOp1_pi_1
		call	pi_palette_apply pascal, 0
		call	pi_put_8 pascal, large 0, 0
		call	pi_free pascal, 0
		call	graph_copy_page pascal, 0
		call	palette_black_in pascal, 1

loc_CD64:
		call	_input_reset_sense_held
		call	@frame_delay$qi pascal, 1
		cmp	_key_det, INPUT_NONE
		jnz	short loc_CD64
		kajacall	KAJA_SONG_STOP
		call	snd_load pascal, ds, offset aOp_1, SND_LOAD_SONG
		kajacall	KAJA_SONG_PLAY
		pop	bp
		retn
_regist_view_menu endp
op_01_TEXT ends

HI_VIEW_TEXT segment byte public 'CODE' use16
	_cleardata_and_regist_view_sprite procdesc near
HI_VIEW_TEXT ends

; ===========================================================================

SHARED	segment	word public 'CODE' use16
include th02/snd/snd.inc
	extern GRAPH_PUTSA_FX:proc
	extern SND_SE_PLAY:proc
	extern _snd_se_update:proc
	extern _bgimage_snap:proc
	extern _bgimage_put:proc
	extern _bgimage_free:proc
	extern @POLAR$QIII:proc
	extern @piano_render$qv:proc
	extern @piano_setup_and_put_initial$qv:proc
	extern BGIMAGE_PUT_RECT_16:proc
	extern SND_LOAD:proc
	extern SND_KAJA_INTERRUPT:proc
	extern PI_LOAD:proc
	extern PI_PUT_8:proc
	extern PI_PALETTE_APPLY:proc
	extern PI_FREE:proc
	extern _input_reset_sense_held:proc
	extern SND_DELAY_UNTIL_MEASURE:proc
	extern @FRAME_DELAY$QI:proc
	extern CDG_FREE_ALL:proc
SHARED	ends

	.data

	; libs/master.lib/pal[data].asm
	extern PaletteTone:word

	; libs/master.lib/sin8[data].asm
	extern _SinTable8:word:256
	extern _CosTable8:word:256

	; th04/hardware/grppsafx[data].asm
	extern _graph_putsa_fx_func:word

	; th05/hardware/vram_planes[data].asm
	extern _VRAM_PLANE_B:dword

include th04/zunsoft[data].asm

	extern _MUSIC_FILES:dword
	extern _game_sel:word
	extern _TRACK_COUNT:word:5
	extern _polygons_initialized:byte
	aH_op = ($ - 530)

include th05/op/music_cmt_load[data].asm
aMusic_pi	db 'music.pi',0
aMusic_dat	db 'music.dat',0
aKaikidan1_dat1	db '���Y�k1.dat',0
		db 0
include th05/formats/scoredat_load_for[data].asm
aName		db 'name',0
aHi01_pi	db 'hi01.pi',0
aOp1_pi_1	db 'op1.pi',0
aOp_1		db 'op',0

	.data?

	extern _resident:dword

	; libs/master.lib/pal[bss].asm
	extern Palettes:byte:48

	; libs/master.lib/vs[bss].asm
	extern vsync_Count1:word

	; th02/hardware/input_sense[bss].asm
	extern _key_det:word

include th04/zunsoft[bss].asm
		db 104 dup(?)
include th02/op/music[bss].asm
byte_13E96	db ?
		db ?
include th03/op/cmt_back[bss].asm
include th02/op/music_cmt[bss].asm
public _track_id_at_top, _track_playing, _track_count_cur
_track_id_at_top	dw ?
_track_playing  	dw ?
_track_count_cur	dw ?
	extern _hi:scoredat_section_t
	extern _hi2:scoredat_section_t
	extern _rank:byte

		end

;
; +-------------------------------------------------------------------------+
; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |        Copyright (c) 2009 by Hex-Rays, <support@hex-rays.com>           |
; +-------------------------------------------------------------------------+
;
; Input	MD5   :	AD4E53E1F1A042FBDA82F86B9BD6728C

; File Name   :	th01/OP.EXE
; Format      :	MS-DOS executable (EXE)
; Base Address:	0h Range: 0h-14040h Loaded length: 13418h
; Entry	Point :	0:0
; OS type	  :  MS	DOS
; Application type:  Executable	16bit

		.386
		.model use16 large _TEXT

BINARY = 'O'

include ReC98.inc
include th01/th01.inc
include th01/hardware/grppsafx.inc
include th01/formats/cfg.inc

	extern SCOPY@:proc
	extern __setargv__:proc ; main() needs both to be set
	extern __setenvp__:proc
	extern _atol:proc
	extern _execl:proc
	extern _int86:proc
	extern _memcmp:proc
	extern _printf:proc

op_01 group op_01_TEXT, op_01__TEXT

; ===========================================================================

; Segment type:	Pure code
_TEXT		segment	word public 'CODE' use16
		assume cs:_TEXT
		assume es:nothing, ds:DGROUP, fs:nothing, gs:nothing

include libs/master.lib/graph_400line.asm
include libs/master.lib/graph_clear.asm
include libs/master.lib/graph_show.asm
include libs/master.lib/graph_start.asm
include libs/master.lib/palette_show.asm
include libs/master.lib/palette_init.asm
include libs/master.lib/respal_exist.asm
include libs/master.lib/respal_free.asm
include libs/master.lib/resdata.asm
include libs/master.lib/file_read.asm
include libs/master.lib/file_close.asm
include libs/master.lib/file_ropen.asm
include libs/master.lib/file_seek.asm
include libs/master.lib/dos_free.asm
include libs/master.lib/keystart.asm
include libs/master.lib/keybios.asm
include libs/master.lib/dos_ropen.asm
include libs/master.lib/egc.asm
include libs/master.lib/random.asm
_TEXT		ends

; ---------------------------------------------------------------------------
; ===========================================================================

; Segment type:	Pure code
op_01_TEXT	segment	byte public 'CODE' use16
op_01_TEXT	ends

op_01__TEXT	segment	byte public 'CODE' use16
		assume cs:op_01
		;org 4
		assume es:nothing, ss:nothing, ds:_DATA, fs:nothing, gs:nothing

	extern @cfg_load$qv:proc
	extern @cfg_save$qv:proc
	extern @main_input_sense$qv:proc
	extern @option_input_sense$qv:proc
	extern @whitelines_animate$qv:proc

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A719	proc far
		push	bp
		mov	bp, sp
		push	ds
		push	offset aReimu_mdt ; "reimu.mdt"
		call	@mdrv2_bgm_load$qnxc
		add	sp, 4
		call	@mdrv2_bgm_play$qv
		push	1
		call	@graph_accesspage_func$qi
		pop	cx
		call	@grp_put_palette_show$qnxc c, offset aReiiden2_grp, ds ; "REIIDEN2.grp"
		call	@z_palette_black$qv
		call	@graph_copy_accessed_page_to_othe$qv
		call	@grp_put$qnxc c, offset aReiiden3_grp, ds ; "REIIDEN3.grp"
		push	0
		call	@graph_accesspage_func$qi
		pop	cx
		call	@z_palette_black_in$qv
		push	64h ; 'd'
		call	@frame_delay$qui
		pop	cx
		call	@whitelines_animate$qv
		pop	bp
		retf
sub_A719	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A772	proc far
		push	bp
		mov	bp, sp
		push	1
		call	@graph_accesspage_func$qi
		pop	cx
		call	@graph_copy_accessed_page_to_othe$qv
		push	0
		call	@graph_accesspage_func$qi
		pop	cx
		call	@grp_put_colorkey$qnxc c, offset aOp_win_grp, ds ; "op_win.grp"
		call	@graph_copy_accessed_page_to_othe$qv
		pop	bp
		retf
sub_A772	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A79D	proc far
		push	bp
		mov	bp, sp
		mov	al, byte_1232F
		cbw
		cmp	ax, 1
		jnz	short loc_A7AE
		call	@resident_free$qv

loc_A7AE:
		call	key_end
		pop	bp
		retf
sub_A79D	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A7B5	proc far
		push	bp
		mov	bp, sp
		push	si
		call	@cfg_save$qv
		call	@resident_stuff_set$qccccl c, word ptr _opts.O_rank, word ptr _opts.O_bgm_mode, word ptr _opts.O_bombs, word ptr _opts.O_lives_extra, large [_rand]
		call	sub_A79D
		call	@mdrv2_bgm_fade_out_nonblock$qv
		call	@game_switch_binary$qv
		mov	al, _mode
		cbw
		cmp	ax, 2
		jnz	short loc_A7FC
		les	bx, _resident
		mov	es:[bx+reiidenconfig_t.debug_mode], DM_TEST
		jmp	short loc_A820
; ---------------------------------------------------------------------------

loc_A7FC:
		mov	al, _mode
		cbw
		cmp	ax, 3
		jnz	short loc_A810
		les	bx, _resident
		mov	es:[bx+reiidenconfig_t.debug_mode], DM_FULL
		jmp	short loc_A820
; ---------------------------------------------------------------------------

loc_A810:
		cmp	_mode, 0
		jnz	short loc_A820
		les	bx, _resident
		mov	es:[bx+reiidenconfig_t.debug_mode], DM_OFF

loc_A820:
		les	bx, _resident
		mov	es:[bx+reiidenconfig_t.route], 0
		mov	es:[bx+reiidenconfig_t.stage], 0
		mov	al, _opts.O_lives_extra
		add	al, 2
		mov	es:[bx+reiidenconfig_t.rem_lives], al
		mov	es:[bx+reiidenconfig_t.p_value], 0
		xor	si, si
		jmp	short loc_A867
; ---------------------------------------------------------------------------

loc_A842:
		mov	ax, si
		add	ax, ax
		les	bx, _resident
		add	bx, ax
		mov	es:[bx+reiidenconfig_t.continues_per_scene], 0
		mov	ax, si
		shl	ax, 2
		mov	bx, word ptr _resident
		add	bx, ax
		mov	es:[bx+reiidenconfig_t.bonus_per_stage], 0
		inc	si

loc_A867:
		cmp	si, 4
		jl	short loc_A842
		les	bx, _resident
		mov	es:[bx+reiidenconfig_t.score_highest], 0
		mov	es:[bx+reiidenconfig_t.continues_total], 0
		mov	es:[bx+reiidenconfig_t.end_flag], 0
		mov	es:[bx+reiidenconfig_t.unused_1], 0
		mov	es:[bx+reiidenconfig_t.snd_need_init], 1
		mov	es:[bx+reiidenconfig_t.bullet_speed], -4
		pushd	0
		push	ds
		push	offset aReiiden_0 ; "reiiden"
		push	ds
		push	offset aReiiden_0 ; "reiiden"
		call	_execl
		add	sp, 0Ch
		pop	si
		pop	bp
		retf
sub_A7B5	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A8AD	proc far
		push	bp
		mov	bp, sp
		call	@cfg_save$qv
		call	@resident_stuff_set$qccccl c, word ptr _opts.O_rank, word ptr _opts.O_bgm_mode, word ptr _opts.O_bombs, word ptr _opts.O_lives_extra, large [_rand]
		les	bx, _resident
		cmp	es:[bx+reiidenconfig_t.stage], 0
		jnz	short loc_A8E1
		mov	ax, seg	op_01
		mov	es, ax
		assume es:op_01

loc_A8E1:
		call	sub_A79D
		call	@mdrv2_bgm_fade_out_nonblock$qv
		call	@game_switch_binary$qv
		les	bx, _resident
		assume es:nothing
		mov	es:[bx+reiidenconfig_t.debug_mode], DM_OFF
		mov	es:[bx+reiidenconfig_t.snd_need_init], 1
		mov	al, _opts.O_lives_extra
		add	al, 2
		mov	es:[bx+reiidenconfig_t.rem_lives], al
		mov	es:[bx+reiidenconfig_t.unused_1], 0
		mov	es:[bx+reiidenconfig_t.bullet_speed], -4
		mov	es:[bx+reiidenconfig_t.p_value], 0
		call	_execl c, offset _REIIDEN, ds, offset _REIIDEN, ds, large 0
		pop	bp
		retf
sub_A8AD	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A92C	proc far

arg_0		= word ptr  6

		push	bp
		mov	bp, sp
		mov	ax, [bp+arg_0]
		mov	bx, 70
		cwd
		idiv	bx
		cmp	dx, 50
		jge	short loc_A954
		call	@graph_putsa_fx$qiiinxuc c, 244, ((15 or FX_WEIGHT_BOLD) shl 16) or 306, offset aVgvhvsb@vjvdvx, ds ; " ＨＩＴ　ＫＥＹ"
		pop	bp
		retf
; ---------------------------------------------------------------------------

loc_A954:
		call	@egc_copy_rect_1_to_0_16$qiiii c, large (306 shl 16) or 244, large (16 shl 16) or 128
		pop	bp
		retf
sub_A92C	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A96A	proc far

var_14		= byte ptr -14h
@@y		= word ptr -4
@@x		= word ptr -2
arg_0		= word ptr  6
arg_2		= word ptr  8

		enter	14h, 0
		push	si
		mov	si, [bp+arg_0]
		lea	ax, [bp+var_14]
		push	ss
		push	ax
		push	ds
		push	offset off_124CD
		mov	cx, 10h
		call	SCOPY@
		mov	[bp+@@x], 244
		mov	ax, si
		imul	ax, 14h
		add	ax, 276
		mov	[bp+@@y], ax
		mov	bx, si
		shl	bx, 2
		lea	ax, [bp+var_14]
		add	bx, ax
		pushd	dword ptr ss:[bx]
		mov	ax, [bp+arg_2]
		or	ax, FX_WEIGHT_BLACK
		push	ax
		push	[bp+@@y]
		push	[bp+@@x]
		call	@graph_putsa_fx$qiiinxuc
		add	sp, 0Ah
		pop	si
		leave
		retf
sub_A96A	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_A9B9	proc far

var_42		= byte ptr -42h
var_2E		= byte ptr -2Eh
var_1E		= byte ptr -1Eh
var_A		= word ptr -0Ah
var_8		= byte ptr -8
arg_0		= word ptr  6
arg_2		= word ptr  8

		enter	42h, 0
		push	si
		push	di
		mov	si, [bp+arg_0]
		lea	ax, [bp+var_1E]
		push	ss
		push	ax
		push	ds
		push	offset off_124DD
		mov	cx, 14h
		call	SCOPY@
		lea	ax, [bp+var_2E]
		push	ss
		push	ax
		push	ds
		push	offset off_124F1
		mov	cx, 10h
		call	SCOPY@
		lea	ax, [bp+var_8]
		push	ss
		push	ax
		push	ds
		push	offset off_12501
		mov	cx, 8
		call	SCOPY@
		lea	ax, [bp+var_42]
		push	ss
		push	ax
		push	ds
		push	offset off_12509
		mov	cx, 14h
		call	SCOPY@
		mov	di, 228
		mov	ax, si
		imul	ax, 20
		add	ax, 266
		mov	[bp+var_A], ax
		call	@egc_copy_rect_1_to_0_16$qiiii c, di, ax, large (16 shl 16) or 176
		or	si, si
		jnz	short loc_AA34
		mov	al, _opts.O_rank
		cbw
		shl	ax, 2
		lea	dx, [bp+var_2E]
		jmp	short loc_AA54
; ---------------------------------------------------------------------------

loc_AA34:
		cmp	si, 1
		jnz	short loc_AA45
		mov	al, _opts.O_bgm_mode
		cbw
		shl	ax, 2
		lea	dx, [bp+var_8]
		jmp	short loc_AA54
; ---------------------------------------------------------------------------

loc_AA45:
		cmp	si, 2
		jnz	short loc_AA83
		mov	al, _opts.O_lives_extra
		cbw
		shl	ax, 2
		lea	dx, [bp+var_42]

loc_AA54:
		add	ax, dx
		mov	bx, ax
		pushd	dword ptr ss:[bx]
		mov	bx, si
		shl	bx, 2
		lea	ax, [bp+var_1E]
		add	bx, ax
		pushd	dword ptr ss:[bx]	; arglist
		push	ds
		push	offset aSS	; "%s%s"
		mov	ax, [bp+arg_2]
		or	ax, 30h
		push	ax		; int
		push	[bp+var_A]	; int
		push	di		; int
		call	@graph_printf_fx$qiiinxuce
		add	sp, 12h
		jmp	short loc_AAB2
; ---------------------------------------------------------------------------

loc_AA83:
		cmp	si, 3
		jz	short loc_AA8D
		cmp	si, 4
		jnz	short loc_AAB2

loc_AA8D:
		mov	bx, si
		shl	bx, 2
		lea	ax, [bp+var_1E]
		add	bx, ax
		pushd	dword ptr ss:[bx]	; arglist
		push	ds
		push	(offset	aSS+2)	; format
		mov	ax, [bp+arg_2]
		or	ax, 30h
		push	ax		; int
		push	[bp+var_A]	; int
		push	di		; int
		call	@graph_printf_fx$qiiinxuce
		add	sp, 0Eh

loc_AAB2:
		pop	di
		pop	si
		leave
		retf
sub_A9B9	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_AAB6	proc far

var_46		= byte ptr -46h
var_A		= word ptr -0Ah
var_8		= byte ptr -8
arg_0		= word ptr  6
arg_2		= word ptr  8

		enter	46h, 0
		push	si
		push	di
		mov	si, [bp+arg_0]
		lea	ax, [bp+var_8]
		push	ss
		push	ax
		push	ds
		push	offset off_1251E
		mov	cx, 8
		call	SCOPY@
		lea	ax, [bp+var_46]
		push	ss
		push	ax
		push	ds
		push	offset off_12526
		mov	cx, 3Ch	; '<'
		call	SCOPY@
		mov	di, 228
		mov	ax, si
		imul	ax, 40
		add	ax, 286
		mov	[bp+var_A], ax
		call	@egc_copy_rect_1_to_0_16$qiiii c, di, ax, large (16 shl 16) or 176
		or	si, si
		jnz	short loc_AB69
		push	(16 shl 16) or 192
		mov	ax, [bp+var_A]
		add	ax, 20
		push	ax
		push	di
		call	@egc_copy_rect_1_to_0_16$qiiii
		add	sp, 8
		mov	al, byte_1251D
		cbw
		push	ax
		mov	bx, si
		shl	bx, 2
		lea	ax, [bp+var_8]
		add	bx, ax
		pushd	dword ptr ss:[bx]	; arglist
		push	ds
		push	offset aS_2d	; "%s%.2d"
		mov	ax, [bp+arg_2]
		or	ax, 30h
		push	ax		; int
		push	[bp+var_A]	; int
		push	di		; int
		call	@graph_printf_fx$qiiinxuce
		add	sp, 10h
		mov	al, byte_1251D
		cbw
		shl	ax, 2
		lea	dx, [bp+var_46]
		add	ax, dx
		mov	bx, ax
		pushd	dword ptr ss:[bx]
		push	ds
		push	(offset	aSS+2)
		mov	ax, [bp+arg_2]
		or	ax, 30h
		push	ax
		mov	ax, [bp+var_A]
		add	ax, 14h
		push	ax
		jmp	short loc_AB8A
; ---------------------------------------------------------------------------

loc_AB69:
		cmp	si, 1
		jnz	short loc_AB93
		mov	bx, si
		shl	bx, 2
		lea	ax, [bp+var_8]
		add	bx, ax
		pushd	dword ptr ss:[bx]	; arglist
		push	ds
		push	(offset	aSS+2)	; format
		mov	ax, [bp+arg_2]
		or	ax, 30h
		push	ax		; int
		push	[bp+var_A]	; int

loc_AB8A:
		push	di		; int
		call	@graph_printf_fx$qiiinxuce
		add	sp, 0Eh

loc_AB93:
		pop	di
		pop	si
		leave
		retf
sub_AAB6	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_AB97	proc far
		push	bp
		mov	bp, sp
		cmp	word_12564, 0
		jnz	short loc_AC04
		call	@egc_copy_rect_1_to_0_16$qiiii c, large (266 shl 16) or 220, large (100 shl 16) or 176
		push	50000h
		call	sub_A96A
		add	sp, 4
		push	50001h
		call	sub_A96A
		add	sp, 4
		push	50002h
		call	sub_A96A
		add	sp, 4
		push	50003h
		call	sub_A96A
		add	sp, 4
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_A96A
		add	sp, 4
		mov	word_12564, 1
		mov	al, _menu_sel
		cbw
		mov	word_12562, ax

loc_AC04:
		mov	al, _menu_sel
		cbw
		cmp	ax, word_12562
		jz	short loc_AC30
		push	5
		push	word_12562
		call	sub_A96A
		add	sp, 4
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_A96A
		add	sp, 4
		mov	al, _menu_sel
		cbw
		mov	word_12562, ax

loc_AC30:
		cmp	_input_ok, 0
		jnz	short loc_AC3E
		cmp	_input_shot, 0
		jz	short loc_AC6E

loc_AC3E:
		mov	al, _menu_sel
		cbw
		mov	bx, ax
		cmp	bx, 3
		ja	short loc_AC6E
		add	bx, bx
		jmp	cs:off_AC7C[bx]

loc_AC50:
		call	sub_A7B5
		jmp	short loc_AC6E
; ---------------------------------------------------------------------------

loc_AC56:
		call	sub_A8AD
		jmp	short loc_AC6E
; ---------------------------------------------------------------------------

loc_AC5C:
		mov	byte_1232A, 1
		mov	word_12564, 0
		jmp	short loc_AC6E
; ---------------------------------------------------------------------------

loc_AC69:
		mov	byte_1232C, 1

loc_AC6E:
		cmp	_input_cancel, 0
		jz	short loc_AC7A
		mov	byte_1232C, 1

loc_AC7A:
		pop	bp
		retf
sub_AB97	endp

; ---------------------------------------------------------------------------
off_AC7C	dw offset loc_AC50
		dw offset loc_AC56
		dw offset loc_AC5C
		dw offset loc_AC69

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_AC84	proc far
		push	bp
		mov	bp, sp
		cmp	word_12566, 0
		jnz	short loc_ACF9
		mov	_menu_sel, 0
		mov	word_12568, 0
		mov	word_12566, 1
		mov	_option_rows, 4
		call	@egc_copy_rect_1_to_0_16$qiiii c, large (276 shl 16) or 220, large (80 shl 16) or 176
		push	0F0000h
		call	sub_A9B9
		add	sp, 4
		push	50001h
		call	sub_A9B9
		add	sp, 4
		push	50002h
		call	sub_A9B9
		add	sp, 4
		push	50003h
		call	sub_A9B9
		add	sp, 4
		push	50004h
		call	sub_A9B9
		add	sp, 4

loc_ACF9:
		mov	al, _menu_sel
		cbw
		cmp	ax, word_12568
		jz	short loc_AD25
		push	5
		push	word_12568
		call	sub_A9B9
		add	sp, 4
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_A9B9
		add	sp, 4
		mov	al, _menu_sel
		cbw
		mov	word_12568, ax

loc_AD25:
		mov	al, _input_left
		cbw
		cmp	ax, 1
		jnz	short loc_AD96
		cmp	word_1256A, 0
		jnz	short loc_AD9C
		mov	al, _menu_sel
		cbw
		or	ax, ax
		jz	short loc_AD49
		cmp	ax, 1
		jz	short loc_AD5C
		cmp	ax, 2
		jz	short loc_AD6F
		jmp	short loc_AD80
; ---------------------------------------------------------------------------

loc_AD49:
		dec	_opts.O_rank
		mov	al, _opts.O_rank
		cbw
		or	ax, ax
		jge	short loc_AD80
		mov	_opts.O_rank, RANK_LUNATIC
		jmp	short loc_AD80
; ---------------------------------------------------------------------------

loc_AD5C:
		dec	_opts.O_bgm_mode
		mov	al, _opts.O_bgm_mode
		cbw
		or	ax, ax
		jge	short loc_AD80
		mov	_opts.O_bgm_mode, 1
		jmp	short loc_AD80
; ---------------------------------------------------------------------------

loc_AD6F:
		dec	_opts.O_lives_extra
		mov	al, _opts.O_lives_extra
		cbw
		or	ax, ax
		jge	short loc_AD80
		mov	_opts.O_lives_extra, CFG_LIVES_EXTRA_MAX

loc_AD80:
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_A9B9
		add	sp, 4
		mov	word_1256A, 1
		jmp	short loc_AD9C
; ---------------------------------------------------------------------------

loc_AD96:
		mov	word_1256A, 0

loc_AD9C:
		mov	al, _input_right
		cbw
		cmp	ax, 1
		jnz	short loc_AE10
		cmp	word_1256C, 0
		jnz	short loc_AE16
		mov	al, _menu_sel
		cbw
		or	ax, ax
		jz	short loc_ADC0
		cmp	ax, 1
		jz	short loc_ADD4
		cmp	ax, 2
		jz	short loc_ADE8
		jmp	short loc_ADFA
; ---------------------------------------------------------------------------

loc_ADC0:
		inc	_opts.O_rank
		mov	al, _opts.O_rank
		cbw
		cmp	ax, RANK_LUNATIC
		jle	short loc_ADFA
		mov	_opts.O_rank, RANK_EASY
		jmp	short loc_ADFA
; ---------------------------------------------------------------------------

loc_ADD4:
		inc	_opts.O_bgm_mode
		mov	al, _opts.O_bgm_mode
		cbw
		cmp	ax, 1
		jle	short loc_ADFA
		mov	_opts.O_bgm_mode, 0
		jmp	short loc_ADFA
; ---------------------------------------------------------------------------

loc_ADE8:
		inc	_opts.O_lives_extra
		mov	al, _opts.O_lives_extra
		cbw
		cmp	ax, CFG_LIVES_EXTRA_MAX
		jle	short loc_ADFA
		mov	_opts.O_lives_extra, 0

loc_ADFA:
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_A9B9
		add	sp, 4
		mov	word_1256C, 1
		jmp	short loc_AE16
; ---------------------------------------------------------------------------

loc_AE10:
		mov	word_1256C, 0

loc_AE16:
		cmp	_input_ok, 0
		jnz	short loc_AE24
		cmp	_input_shot, 0
		jz	short loc_AE2D

loc_AE24:
		mov	al, _menu_sel
		cbw
		cmp	ax, 4
		jz	short loc_AE34

loc_AE2D:
		cmp	_input_cancel, 0
		jz	short loc_AE44

loc_AE34:
		mov	byte_1232A, 3
		mov	word_12566, 0
		mov	_menu_sel, 2

loc_AE44:
		cmp	_input_ok, 0
		jnz	short loc_AE52
		cmp	_input_shot, 0
		jz	short loc_AE6B

loc_AE52:
		mov	al, _menu_sel
		cbw
		cmp	ax, 3
		jnz	short loc_AE6B
		mov	byte_1232A, 2
		mov	word_12566, 0
		mov	_menu_sel, 0

loc_AE6B:
		pop	bp
		retf
sub_AC84	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_AE6D	proc far

var_3C		= byte ptr -3Ch

		enter	3Ch, 0
		lea	ax, [bp+var_3C]
		push	ss
		push	ax
		push	ds
		push	offset off_1256E
		mov	cx, 3Ch	; '<'
		call	SCOPY@
		call	@mdrv2_bgm_stop$qv
		mov	al, byte_1251D
		cbw
		shl	ax, 2
		lea	dx, [bp+var_3C]
		add	ax, dx
		mov	bx, ax
		pushd	dword ptr ss:[bx]	; path
		call	@mdrv2_bgm_load$qnxc
		add	sp, 4
		call	@mdrv2_bgm_play$qv
		leave
		retf
sub_AE6D	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

sub_AEA8	proc far
		push	bp
		mov	bp, sp
		cmp	word_125AA, 0
		jnz	short loc_AF00
		mov	_menu_sel, 0
		mov	word_125AC, 0
		mov	word_125AA, 1
		mov	_input_ok, 0
		mov	_input_shot, 0
		mov	_option_rows, 1
		call	@egc_copy_rect_1_to_0_16$qiiii c, large (266 shl 16) or 220, large (100 shl 16) or 176
		push	0F0000h
		call	sub_AAB6
		add	sp, 4
		push	50001h
		call	sub_AAB6
		add	sp, 4

loc_AF00:
		mov	al, _menu_sel
		cbw
		cmp	ax, word_125AC
		jz	short loc_AF2C
		push	5
		push	word_125AC
		call	sub_AAB6
		add	sp, 4
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_AAB6
		add	sp, 4
		mov	al, _menu_sel
		cbw
		mov	word_125AC, ax

loc_AF2C:
		mov	al, _input_left
		cbw
		cmp	ax, 1
		jnz	short loc_AF69
		cmp	word_125AE, 0
		jnz	short loc_AF6F
		cmp	_menu_sel, 0
		jnz	short loc_AF53
		dec	byte_1251D
		cmp	byte_1251D, 0
		jge	short loc_AF53
		mov	byte_1251D, 0Eh

loc_AF53:
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_AAB6
		add	sp, 4
		mov	word_125AE, 1
		jmp	short loc_AF6F
; ---------------------------------------------------------------------------

loc_AF69:
		mov	word_125AE, 0

loc_AF6F:
		mov	al, _input_right
		cbw
		cmp	ax, 1
		jnz	short loc_AFAC
		cmp	word_125B0, 0
		jnz	short loc_AFB2
		cmp	_menu_sel, 0
		jnz	short loc_AF96
		inc	byte_1251D
		cmp	byte_1251D, 0Fh
		jl	short loc_AF96
		mov	byte_1251D, 0

loc_AF96:
		push	0Fh
		mov	al, _menu_sel
		cbw
		push	ax
		call	sub_AAB6
		add	sp, 4
		mov	word_125B0, 1
		jmp	short loc_AFB2
; ---------------------------------------------------------------------------

loc_AFAC:
		mov	word_125B0, 0

loc_AFB2:
		cmp	_input_ok, 0
		jnz	short loc_AFC0
		cmp	_input_shot, 0
		jz	short loc_AFC9

loc_AFC0:
		mov	al, _menu_sel
		cbw
		cmp	ax, 1
		jz	short loc_AFD0

loc_AFC9:
		cmp	_input_cancel, 0
		jz	short loc_AFE0

loc_AFD0:
		mov	byte_1232A, 4
		mov	word_125AA, 0
		mov	_menu_sel, 3

loc_AFE0:
		cmp	_input_ok, 0
		jnz	short loc_AFEE
		cmp	_input_shot, 0
		jz	short loc_AFF9

loc_AFEE:
		cmp	_menu_sel, 0
		jnz	short loc_AFF9
		call	sub_AE6D

loc_AFF9:
		pop	bp
		retf
sub_AEA8	endp


; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

; int __cdecl main(int argc, const char	**argv,	const char **envp)
public _main
_main		proc far

outregs		= REGS ptr -2Ch
inregs		= REGS ptr -1Ch
@@kb_buf		= word ptr -0Ch
var_9		= byte ptr -9
var_8		= dword	ptr -8
var_4		= dword	ptr -4
_argc		= word ptr  4
_argv		= dword	ptr  6
_envp		= dword	ptr  0Ah

		enter	2Ch, 0
		push	si
		push	di
		xor	si, si
		xor	di, di
		call	@mdrv2_resident$qv
		or	ax, ax
		jnz	short loc_B015
		push	ds
		push	offset aGogbgGtg@gcglv ; "バッチファイルから起動してよ"
		jmp	loc_B25D
; ---------------------------------------------------------------------------

loc_B015:
		mov	byte_1232D, 0
		mov	dword_12330, 0
		mov	byte_1232E, 0
		cmp	word ptr [bp+_argv], 1
		jle	loc_B0D6
		les	bx, [bp+_argv+2]
		les	bx, es:[bx+4]
		mov	al, es:[bx]
		cbw
		cmp	ax, 73h	; 's'
		jnz	short loc_B045
		mov	_mode, 1

loc_B045:
		les	bx, [bp+_argv+2]
		les	bx, es:[bx+4]
		mov	al, es:[bx]
		cbw
		cmp	ax, 74h	; 't'
		jnz	short loc_B05A
		mov	_mode, 2

loc_B05A:
		les	bx, [bp+_argv+2]
		les	bx, es:[bx+4]
		mov	al, es:[bx]
		cbw
		cmp	ax, 64h	; 'd'
		jnz	short loc_B06F
		mov	_mode, 3

loc_B06F:
		push	3		; n
		push	ds
		push	offset aCon	; "CON"
		les	bx, [bp+_argv+2]
		pushd	dword ptr es:[bx+4] ; s1
		call	_memcmp
		add	sp, 0Ah
		or	ax, ax
		jnz	short loc_B0D6
		les	bx, [bp+_argv+2]
		mov	eax, es:[bx+8]
		mov	[bp+var_4], eax
		pushd	[bp+var_4]
		call	_atol
		add	sp, 4
		mov	byte_1232D, al
		les	bx, [bp+_argv+2]
		pushd	dword ptr es:[bx+0Ch]
		call	_atol
		add	sp, 4
		mov	word ptr dword_12330+2,	dx
		mov	word ptr dword_12330, ax
		les	bx, [bp+_argv+2]
		mov	eax, es:[bx+10h]
		mov	[bp+var_8], eax
		pushd	[bp+var_8]
		call	_atol
		add	sp, 4
		mov	byte_1232E, al

loc_B0D6:
		call	@mdrv2_check_board$qv
		call	@game_init$qv
		call	@cfg_load$qv
		mov	al, _opts.O_bgm_mode
		cbw
		mov	si, ax
		mov	byte ptr [bp+inregs+1],	3
		push	ss
		lea	ax, [bp+outregs]
		push	ax		; outregs
		push	ss
		lea	ax, [bp+inregs]
		push	ax		; inregs
		push	18h		; intno
		call	_int86
		add	sp, 0Ah
		call	key_start
		call	sub_A719
		xor	ax, ax
		mov	es, ax
		mov	al, es:((50h shl 4) + 00h) ; BIOS_FLAG
		or	al, 20h ; Do not beep when key buffer overflows
		mov	[bp+var_9], al
		xor	ax, ax
		mov	dl, [bp+var_9]
		mov	es, ax
		mov	es:((50h shl 4) + 00h), dl  ; BIOS_FLAG
		jmp	short loc_B135
; ---------------------------------------------------------------------------

loc_B126:
		push	1
		call	@frame_delay$qui
		pop	cx
		push	di
		call	sub_A92C
		pop	cx
		inc	di

loc_B135:
		call	key_sense_bios
		or	ax, ax
		jz	short loc_B126
		call	sub_A772
		mov	eax, _rand
		mov	random_seed, eax
		jmp	loc_B21A
; ---------------------------------------------------------------------------

loc_B14D:
		cmp	byte_1232A, 0
		jnz	short loc_B15F
		call	@main_input_sense$qv
		call	sub_AB97
		jmp	loc_B1EE
; ---------------------------------------------------------------------------

loc_B15F:
		mov	al, byte_1232A
		cbw
		cmp	ax, 1
		jnz	short loc_B172
		call	@option_input_sense$qv
		call	sub_AC84
		jmp	short loc_B1EE
; ---------------------------------------------------------------------------

loc_B172:
		mov	al, byte_1232A
		cbw
		cmp	ax, 2
		jnz	short loc_B185
		call	@option_input_sense$qv
		call	sub_AEA8
		jmp	short loc_B1EE
; ---------------------------------------------------------------------------

loc_B185:
		mov	al, byte_1232A
		cbw
		cmp	ax, 3
		jnz	short loc_B1D8
		mov	al, _opts.O_bgm_mode
		cbw
		cmp	ax, si
		jz	short loc_B1C9
		cmp	_opts.O_bgm_mode, 0
		jnz	short loc_B1A4
		call	@mdrv2_bgm_stop$qv
		jmp	short loc_B1C3
; ---------------------------------------------------------------------------

loc_B1A4:
		mov	al, _opts.O_bgm_mode
		cbw
		cmp	ax, 1
		jnz	short loc_B1C3
		call	@mdrv2_bgm_stop$qv
		push	ds
		push	offset aReimu_mdt ; "reimu.mdt"
		call	@mdrv2_bgm_load$qnxc
		add	sp, 4
		call	@mdrv2_bgm_play$qv

loc_B1C3:
		mov	al, _opts.O_bgm_mode
		cbw
		mov	si, ax

loc_B1C9:
		push	0Fh
		call	@frame_delay$qui
		pop	cx
		mov	byte_1232A, 0
		jmp	short loc_B1EE
; ---------------------------------------------------------------------------

loc_B1D8:
		mov	al, byte_1232A
		cbw
		cmp	ax, 4
		jnz	short loc_B1EE
		push	0Fh
		call	@frame_delay$qui
		pop	cx
		mov	byte_1232A, 1

loc_B1EE:
		xor	ax, ax
		mov	es, ax
		mov	ax, word ptr es:[((50h shl 4) + 24h)] ; KB_BUF_HEAD
		mov	[bp+@@kb_buf], ax
		xor	ax, ax
		mov	dx, [bp+@@kb_buf]
		mov	es, ax
		mov	word ptr es:[((50h shl 4) + 26h)], dx ; KB_BUF_TAIL
		mov	es, ax
		mov	byte ptr es:[((50h shl 4) + 28h)], 0 ; KB_COUNT
		inc	_rand
		push	1
		call	@frame_delay$qui
		pop	cx

loc_B21A:
		cmp	byte_1232C, 0
		jz	loc_B14D
		call	@cfg_save$qv
		mov	byte_1232F, 1
		call	@mdrv2_bgm_stop$qv
		call	sub_A79D
		push	1
		call	@graph_accesspage_func$qi
		pop	cx
		call	@z_graph_clear$qv
		push	0
		call	@graph_accesspage_func$qi
		pop	cx
		call	@z_graph_clear$qv
		call	@game_exit$qv
		call	@mdrv2_bgm_stop$qv
		push	ds
		push	offset format	; "おつかれさまでした！！\n"

loc_B25D:
		call	_printf
		add	sp, 4
		pop	di
		pop	si
		leave
		retf
_main		endp
op_01__TEXT	ends

; ===========================================================================

; Segment type:	Pure code
frmdelay_TEXT	segment	byte public 'CODE' use16
	extern @frame_delay$qui:proc
frmdelay_TEXT	ends

; ===========================================================================

; Segment type:	Pure code
vsync_TEXT	segment	byte public 'CODE' use16
vsync_TEXT	ends

; ===========================================================================

ztext_TEXT	segment	byte public 'CODE' use16
ztext_TEXT	ends

; ===========================================================================

; Segment type:	Pure code
initexit_TEXT	segment	byte public 'CODE' use16
	extern @game_init$qv:proc
	extern @game_exit$qv:proc
	extern @game_switch_binary$qv:proc
initexit_TEXT	ends

; ---------------------------------------------------------------------------
; ===========================================================================

; Segment type:	Pure code
graph_TEXT	segment	byte public 'CODE' use16
	extern @graph_accesspage_func$qi:proc
	extern @z_graph_clear$qv:proc
	extern @graph_copy_accessed_page_to_othe$qv:proc
	extern @z_palette_black$qv:proc
	extern @z_palette_black_in$qv:proc
	extern @graph_putsa_fx$qiiinxuc:proc
graph_TEXT	ends

; ---------------------------------------------------------------------------
; ===========================================================================

; Segment type:	Pure code
SHARED	segment	byte public 'CODE' use16
	extern @egc_copy_rect_1_to_0_16$qiiii:proc
SHARED	ends

; ===========================================================================

; Segment type:	Pure code
grppffx_TEXT	segment	byte public 'CODE' use16
	extern @graph_printf_fx$qiiinxuce:proc
grppffx_TEXT	ends

; ===========================================================================

; Segment type:	Pure code
PTN_GRP_GRZ	segment	byte public 'CODE' use16
	extern @grp_put_palette_show$qnxc:proc
	extern @grp_put$qnxc:proc
	extern @grp_put_colorkey$qnxc:proc
PTN_GRP_GRZ	ends

; ===========================================================================

; Segment type:	Pure code
resstuff_TEXT	segment	byte public 'CODE' use16
	extern @resident_stuff_set$qccccl:proc
	extern @resident_free$qv:proc
resstuff_TEXT	ends

; ===========================================================================

; Segment type:	Pure code
mdrv2_TEXT	segment	byte public 'CODE' use16
	extern @mdrv2_resident$qv:proc
	extern @mdrv2_bgm_load$qnxc:proc
	extern @mdrv2_bgm_play$qv:proc
	extern @mdrv2_bgm_stop$qv:proc
	extern @mdrv2_bgm_fade_out_nonblock$qv:proc
	extern @mdrv2_check_board$qv:proc
mdrv2_TEXT	ends

; ===========================================================================

op_12_TEXT	segment	byte public 'CODE' use16
op_12_TEXT	ends

; ===========================================================================

	.data

	extern _opts:cfg_options_t
	extern _mode:byte
	extern _menu_sel:byte
	extern _input_left:byte
	extern _input_ok:byte
	extern _input_shot:byte
	extern _input_cancel:byte
	extern byte_1232A:byte
	extern _input_right:byte
	extern byte_1232C:byte
	extern byte_1232D:byte
	extern byte_1232E:byte
	extern byte_1232F:byte
	extern dword_12330:dword
	extern _option_rows:byte

		db 0

off_124CD	dd aVrvsvVqvs
					; "   ＳＴＡＲＴ   "
		dd aVbvnvmvsvhvmvt	; "ＣＯＮＴＩＮＵＥ"
		dd aB@vnvovsvhvnvm	; "　ＯＰＴＩＯＮ　"
		dd aB@b@vpvtvhvsb@	; "　　ＱＵＩＴ　　"
off_124DD	dd aB@vqvVmvjb@
					; "　ＲＡＮＫ　	"
		dd aVlvtvrvhvb		; " ＭＵＳＩＣ	"
		dd aVovkvVxvdvq		; "ＰＬＡＹＥＲ	"
		dd aVlbdvsvdvrvs	; "Ｍ．ＴＥＳＴ	"
		dd aB@vpvtvhvsb@	; "　ＱＵＩＴ　	"
off_124F1	dd aEasy
					; " EASY "
		dd aNormal		; "NORMAL"
		dd aHard		; " HARD "
		dd aLunatic		; "LUNATIC"
off_12501	dd aOff
					; "  OFF "
		dd aFm			; "  FM	 "
off_12509	dd a3
					; "   3	 "
		dd a4			; "   4	 "
		dd a5			; "   5	 "
		dd a6			; "   6	 "
		dd a7			; "   7	 "
byte_1251D	db 0
off_1251E	dd aVlvtvrvhvbb@vm
					; "ＭＵＳＩＣ　Ｎｏ．"
		dd aB@b@vpvxvivf	; "　　Ｑｕｉｔ	     "
off_12526	dd aASacretLot
					; "    A Sacret	Lot"
		dd aXcvR_o		; "	 風の神社     "
		dd aIiiuvIPc		; "	永遠の巫女    "
		dd aHighlyResponsi	; "  Highly Responsive"
		dd aUmx
		dd aOrientalMagici	; "  Oriental Magician"
		dd aB@FjoVPmsUbb@	; "　  破邪の小太刀　 "
		dd aTheLegendOfKag	; " The	Legend of KAGE"
		dd aPositiveAndNeg	; "Positive and	Negative"
		dd aB@b@UvoguRrb@b	; "　　	 天使伝説　　 "
		dd aB@b@b@CvlB@b@b	; "　　　  魔鏡　　　 "
		dd aVvvUVRVnvVOuvV	; "いざ倒れ逝くその時まで"
		dd aB@b@oavVVrvivV	; "　　死なばもろとも　　"
		dd aB@b@Rpchmxom	; "　　	 星幽剣士"
		dd aB@b@b@gagcgkgx	; "　　　アイリス"
word_12562	dw 63h
word_12564	dw 0
word_12566	dw 0
word_12568	dw 0
word_1256A	dw 0
word_1256C	dw 0
off_1256E	dd aReimu_mdt
					; "reimu.mdt"
		dd aZipangu_mdt		; "ZIPANGU.mdt"
		dd aSt0_mdt		; "st0.mdt"
		dd aSt1_mdt		; "st1.mdt"
		dd aSt2_mdt		; "st2.mdt"
		dd aSt3_mdt		; "st3.mdt"
		dd aSt4_mdt		; "st4.mdt"
		dd aSt5_mdt		; "st5.mdt"
		dd aPositive_mdt	; "positive.mdt"
		dd aLegend_mdt		; "legend.mdt"
		dd aKami_mdt		; "kami.mdt"
		dd aTensi_mdt		; "tensi.mdt"
		dd aSyugen_mdt		; "syugen.mdt"
		dd aAlice_mdt		; "alice.mdt"
		dd aIris_mdt		; "iris.mdt"
word_125AA	dw 0
word_125AC	dw 0
word_125AE	dw 0
word_125B0	dw 0
include th01/formats/cfg[data].asm
; char aReimu_mdt[]
aReimu_mdt	db 'reimu.mdt',0
aReiiden2_grp	db 'REIIDEN2.grp',0
aReiiden3_grp	db 'REIIDEN3.grp',0
aOp_win_grp	db 'op_win.grp',0
; char aReiiden_0[]
aReiiden_0	db 'reiiden',0
aVgvhvsb@vjvdvx	db ' ＨＩＴ　ＫＥＹ',0
aVrvsvVqvs	db '   ＳＴＡＲＴ   ',0
aVbvnvmvsvhvmvt	db 'ＣＯＮＴＩＮＵＥ',0
aB@vnvovsvhvnvm	db '　ＯＰＴＩＯＮ　',0
aB@b@vpvtvhvsb@	db '　　ＱＵＩＴ　　',0
aB@vqvVmvjb@	db '　ＲＡＮＫ　 ',0
aVlvtvrvhvb	db ' ＭＵＳＩＣ  ',0
aVovkvVxvdvq	db 'ＰＬＡＹＥＲ ',0
aVlbdvsvdvrvs	db 'Ｍ．ＴＥＳＴ ',0
aB@vpvtvhvsb@	db '　ＱＵＩＴ　 ',0
aEasy		db ' EASY ',0
aNormal		db 'NORMAL',0
aHard		db ' HARD ',0
aLunatic	db 'LUNATIC',0
aOff		db '  OFF ',0
aFm		db '  FM  ',0
a3		db '   3  ',0
a4		db '   4  ',0
a5		db '   5  ',0
a6		db '   6  ',0
a7		db '   7  ',0
; char aSS[]
aSS		db '%s%s',0
aVlvtvrvhvbb@vm	db 'ＭＵＳＩＣ　Ｎｏ．',0
aB@b@vpvxvivf	db '　　Ｑｕｉｔ      ',0
aASacretLot	db '    A Sacret Lot',0
aXcvR_o		db '      風の神社     ',0
aIiiuvIPc	db '     永遠の巫女    ',0
aHighlyResponsi	db '  Highly Responsive',0
aUmx		db '     東方怪奇談    ',0
aOrientalMagici	db '  Oriental Magician',0
aB@FjoVPmsUbb@	db '　  破邪の小太刀　 ',0
aTheLegendOfKag	db ' The Legend of KAGE',0
aPositiveAndNeg	db 'Positive and Negative',0
aB@b@UvoguRrb@b	db '　　  天使伝説　　 ',0
aB@b@b@CvlB@b@b	db '　　　  魔鏡　　　 ',0
aVvvUVRVnvVOuvV	db 'いざ倒れ逝くその時まで',0
aB@b@oavVVrvivV	db '　　死なばもろとも　　',0
aB@b@Rpchmxom	db '　　  星幽剣士',0
aB@b@b@gagcgkgx	db '　　　アイリス',0
; char aS_2d[]
aS_2d		db '%s%.2d',0
aZipangu_mdt	db 'ZIPANGU.mdt',0
aSt0_mdt	db 'st0.mdt',0
aSt1_mdt	db 'st1.mdt',0
aSt2_mdt	db 'st2.mdt',0
aSt3_mdt	db 'st3.mdt',0
aSt4_mdt	db 'st4.mdt',0
aSt5_mdt	db 'st5.mdt',0
aPositive_mdt	db 'positive.mdt',0
aLegend_mdt	db 'legend.mdt',0
aKami_mdt	db 'kami.mdt',0
aTensi_mdt	db 'tensi.mdt',0
aSyugen_mdt	db 'syugen.mdt',0
aAlice_mdt	db 'alice.mdt',0
aIris_mdt	db 'iris.mdt',0
aGogbgGtg@gcglv	db 'バッチファイルから起動してよ',0
aCon		db 'CON',0
; char format[]
format		db 'おつかれさまでした！！',0Ah,0

	; libs/master.lib/grp[data].asm
	extern graph_VramSeg:word
	extern graph_VramWords:word
	extern graph_VramLines:word
	extern graph_VramZoom:word

	; libs/master.lib/pal[data].asm
	extern PaletteTone:word
	extern PalettesInit:rgb_t:COLOR_COUNT
	extern PaletteNote:word
	extern ResPalSeg:word

	; libs/master.lib/respal_exist[data].asm
IDLEN EQU 10
	extern ResPalID:byte:IDLEN

	; libs/master.lib/fil[data].asm
	extern file_BufferSize:word
	extern file_Handle:word

	; libs/master.lib/keytable[data].asm
	extern key_table_normal:word
	extern key_table_shift:word
	extern key_table_ctrl:word
	extern key_table_alt:word

	; libs/master.lib/keystart[data].asm
	extern key_started:word

	; libs/master.lib/keyback[data].asm
	extern key_back_buffer:word

	; libs/master.lib/dos_ropen[data].asm
	extern file_sharingmode:word

	; libs/master.lib/clip[data].asm
	extern ClipXL:word
	extern ClipXW:word
	extern ClipXR:word
	extern ClipYT:word
	extern ClipYH:word
	extern ClipYB:word
	extern ClipYT_seg:word
	extern ClipYB_adr:word

	; libs/master.lib/rand[data].asm
	extern random_seed:dword

	.data?

public _rand
_rand	dd ?
public _columns
_columns	dd ROW_SIZE dup (?)

	; libs/master.lib/pal[bss].asm
	extern Palettes:rgb_t:COLOR_COUNT

	; libs/master.lib/fil[bss].asm
	extern file_Buffer:dword
	extern file_BufferPos:dword
	extern file_BufPtr:word
	extern file_InReadBuf:word
	extern file_Eof:word
	extern file_ErrorStat:word

	; libs/master.lib/keystart[bss].asm
	extern key_backup:byte:786
	extern keywork:byte:10

	extern _resident:dword

		end

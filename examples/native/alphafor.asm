; Assembly for alphafor.bas
; compiled with mcbasic -native

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
DP_TIMR	.equ	$09	; value of MC6801/6803 counter
DP_DATA	.equ	$AD	; pointer to where READ gets next value
DP_LNUM	.equ	$E2	; current line in BASIC
DP_TABW	.equ	$E4	; current tab width on console
DP_LTAB	.equ	$E5	; current last tab column
DP_LPOS	.equ	$E6	; current line position on console
DP_LWID	.equ	$E7	; current line width of console
DP_DEVN	.equ	$E8	; current device number
; 
; Memory equates
M_KBUF	.equ	$4231	; keystrobe buffer (8 bytes)
M_PMSK	.equ	$423C	; pixel mask for SET, RESET and POINT
M_FLEN	.equ	$4256	; filename len
M_FNAM	.equ	$4257	; filename (8 bytes)
M_FTYP	.equ	$4267	; cassette filetype
M_LDSZ	.equ	$426C	; load addr / array size
M_CBEG	.equ	$426F	; cassette beginning address
M_CEND	.equ	$4271	; address after cassette ending
M_IKEY	.equ	$427F	; key code for INKEY$
M_CRSR	.equ	$4280	; cursor location
M_LBUF	.equ	$42B2	; line input buffer (130 chars)
M_MSTR	.equ	$4334	; buffer for small string moves
M_CODE	.equ	$4346	; start of program space
; 
; ROM equates
R_MCXBT	.equ	$E047	; MCX BASIC 3.x target ('10' for an MC-10)
R_BKMSG	.equ	$E1C1	; 'BREAK' string location
R_ERROR	.equ	$E238	; generate error and restore direct mode
R_BREAK	.equ	$E266	; generate break and restore direct mode
R_RESET	.equ	$E3EE	; setup stack and disable CONT
R_ENTER	.equ	$E766	; emit carriage return to console
R_SPACE	.equ	$E7B9	; emit " " to console
R_QUEST	.equ	$E7BC	; emit "?" to console
R_REDO	.equ	$E7C1	; emit "?REDO" to console
R_EXTRA	.equ	$E8AB	; emit "?EXTRA IGNORED" to console
R_DMODE	.equ	$F7AA	; display OK prompt and restore direct mode
R_KPOLL	.equ	$F879	; if key is down, do KEYIN, else set Z CCR flag
R_KEYIN	.equ	$F883	; poll key for key-down transition set Z otherwise
R_PUTC	.equ	$F9C6	; write ACCA to console
R_MKTAB	.equ	$FA7B	; setup tabs for console
R_GETLN	.equ	$FAA4	; get line, returning with X pointing to M_BUF-1
R_SETPX	.equ	$FB44	; write pixel character to X
R_CLRPX	.equ	$FB59	; clear pixel character in X
R_MSKPX	.equ	$FB7C	; get pixel screen location X and mask in R_PMSK
R_CLSN	.equ	$FBC4	; clear screen with color code in ACCB
R_CLS	.equ	$FBD4	; clear screen with space character
R_WBLKS	.equ	$FC5D	; write blocks M_CBEG up to before M_CEND
R_WFNAM	.equ	$FC8E	; write filename block + silence + post-leader
R_RBLKS	.equ	$FDC5	; read data blocks into M_CBEG
R_RCLDM	.equ	$FE1B	; read machine language blocks offset by X
R_SFNAM	.equ	$FE37	; search for filename
R_SOUND	.equ	$FFAB	; play sound with pitch in ACCA and duration in ACCB
R_MCXID	.equ	$FFDA	; ID location for MCX BASIC
R_RSLDR	.equ	$FF4E	; read leader preceding data blocks

; Equate(s) for MCBASIC constants
charpage	.equ	$1B00	; single-character string page.

; direct page registers
	.org	$80
strtcnt	.block	1
strbuf	.block	2
strend	.block	2
strfree	.block	2
strstop	.block	2
inptptr	.block	2
redoptr	.block	2
letptr	.block	2
rvseed	.block	2
	.org	$a3
tmp1	.block	2
tmp2	.block	2
tmp3	.block	2
tmp4	.block	2
tmp5	.block	2
	.org	$af
r1	.block	5
r2	.block	5
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_0

	; GOTO 68

	ldx	#LINE_68
	jsr	goto_ix

LINE_1

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_2

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_3

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_4

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_5

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_6

	; ON RND(V) GOTO 1,3,5,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_1, LINE_3, LINE_5, LINE_5

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_7
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_7

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_8

	; ON RND(V) GOTO 1,2,3,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_1, LINE_2, LINE_3, LINE_5

	; IF Y(T)<Y THEN

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_9
	jsr	jmpeq_ir1_ix

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_9

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_10
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_10

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_11

	; ON RND(V) GOTO 2,3,5,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_2, LINE_3, LINE_5, LINE_5

	; IF X(T)>X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ix_fr1

	ldx	#LINE_12
	jsr	jmpeq_ir1_ix

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_12

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_13

	; ON RND(V) GOTO 3,4,5,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_3, LINE_4, LINE_5, LINE_5

	; IF Y(T)<Y THEN

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_14
	jsr	jmpeq_ir1_ix

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_14

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_15

	; ON RND(V) GOTO 1,3,4,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_1, LINE_3, LINE_4, LINE_5

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_16
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_16

	; IF Y(T)<Y THEN

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_17
	jsr	jmpeq_ir1_ix

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_17

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_18

	; ON RND(V) GOTO 1,2,3,4,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_1, LINE_2, LINE_3, LINE_4, LINE_5

	; IF Y(T)<Y THEN

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_19
	jsr	jmpeq_ir1_ix

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_19

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_20
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_20

	; IF X(T)>X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ix_fr1

	ldx	#LINE_21
	jsr	jmpeq_ir1_ix

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_21

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_23

	; ON RND(V) GOTO 2,2,3,4,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_2, LINE_2, LINE_3, LINE_4, LINE_5

	; IF X(T)>X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ix_fr1

	ldx	#LINE_24
	jsr	jmpeq_ir1_ix

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_24

	; IF Y(T)<Y THEN

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_25
	jsr	jmpeq_ir1_ix

	; Y(T)+=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_25

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_26

	; ON RND(V) GOTO 1,4,5,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_1, LINE_4, LINE_5, LINE_5

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_27
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_27

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_28

	; ON RND(V) GOTO 1,2,5,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_1, LINE_2, LINE_5, LINE_5

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_29
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_29

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_30

	; ON RND(V) GOTO 1,2,4,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_1, LINE_2, LINE_4, LINE_5

	; IF X(T)<X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_31
	jsr	jmpeq_ir1_ix

	; X(T)+=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	inc_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_31

	; IF X(T)>X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ix_fr1

	ldx	#LINE_32
	jsr	jmpeq_ir1_ix

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_32

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_33

	; ON RND(V) GOTO 2,4,5,5

	ldx	#INTVAR_V
	jsr	rnd_fr1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_2, LINE_4, LINE_5, LINE_5

	; IF X(T)>X THEN

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ix_fr1

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; X(T)-=1

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	jsr	dec_fp_fp

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_34

	; Y(T)-=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	dec_ip_ip

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_35

	; POKE (Q*Y)+X+M,Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; X+=G(X-1,Y)>0

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldx	#INTARR_G
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#INTVAR_X
	jsr	add_ix_ix_ir1

	; POKE (Q*Y)+X+M,0

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldab	#0
	jsr	poke_ir1_pb

	; U=-1

	ldx	#INTVAR_U
	jsr	true_ix

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_36

	; POKE (Q*Y)+X+M,Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; X-=G(X+1,Y)>0

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTARR_G
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#INTVAR_X
	jsr	sub_ix_ix_ir1

	; POKE (Q*Y)+X+M,0

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldab	#0
	jsr	poke_ir1_pb

	; U=1

	ldx	#INTVAR_U
	jsr	one_ix

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_37

	; POKE (Q*Y)+X+M,Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; Y+=G(X,Y-1)>0

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	dec_ir2_ix

	ldx	#INTARR_G
	jsr	arrval2_ir1_ix_ir2

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#INTVAR_Y
	jsr	add_ix_ix_ir1

	; POKE (Q*Y)+X+M,0

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldab	#0
	jsr	poke_ir1_pb

	; U=-Q

	ldx	#INTVAR_Q
	jsr	neg_ir1_ix

	ldx	#INTVAR_U
	jsr	ld_ix_ir1

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_38

	; POKE (Q*Y)+X+M,Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; Y-=G(X,Y+1)>0

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	inc_ir2_ix

	ldx	#INTARR_G
	jsr	arrval2_ir1_ix_ir2

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#INTVAR_Y
	jsr	sub_ix_ix_ir1

	; POKE (Q*Y)+X+M,0

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldab	#0
	jsr	poke_ir1_pb

	; U=Q

	ldd	#INTVAR_U
	ldx	#INTVAR_Q
	jsr	ld_id_ix

LINE_39

	; FOR T=F TO 4

	ldd	#FLTVAR_T
	ldx	#INTVAR_F
	jsr	for_fd_ix

	ldab	#4
	jsr	to_fp_pb

	; S+=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ix_ix_ir1

	; IF (PEEK(S)<>Q) OR (PEEK(S+J)<>Q) THEN

	ldx	#INTVAR_S
	jsr	peek_ir1_ix

	ldx	#INTVAR_Q
	jsr	ldne_ir1_ir1_ix

	ldx	#INTVAR_S
	ldd	#INTVAR_J
	jsr	add_ir2_ix_id

	jsr	peek_ir2_ir2

	ldx	#INTVAR_Q
	jsr	ldne_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_40
	jsr	jmpeq_ir1_ix

	; WHEN PEEK(S)<>Q GOTO 45

	ldx	#INTVAR_S
	jsr	peek_ir1_ix

	ldx	#INTVAR_Q
	jsr	ldne_ir1_ir1_ix

	ldx	#LINE_45
	jsr	jmpne_ir1_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; S+=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ix_ix_ir1

	; GOTO 45

	ldx	#LINE_45
	jsr	goto_ix

LINE_40

	; GOSUB 500

	ldx	#LINE_500
	jsr	gosub_ix

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,Q

	ldd	#FLTVAR_C
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; ON G(X(T),Y(T)) GOTO 6,8,11,13,15,18,23,26,28,30,33

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_fx_id

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	ldx	#INTARR_G
	jsr	arrval2_ir1_ix_ir2

	jsr	ongoto_ir1_is
	.byte	11
	.word	LINE_6, LINE_8, LINE_11, LINE_13, LINE_15, LINE_18, LINE_23, LINE_26, LINE_28, LINE_30, LINE_33

	; C=(Y(T)*Q)+X(T)+M

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; POKE C,T

	ldd	#FLTVAR_C
	ldx	#FLTVAR_T
	jsr	poke_id_ix

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

LINE_41

	; S=M

	ldd	#INTVAR_S
	ldx	#INTVAR_M
	jsr	ld_id_ix

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; I=Q

	ldd	#INTVAR_I
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; WHEN PEEK((Q*Y)+X+M) GOTO 55

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#LINE_55
	jsr	jmpne_ir1_ix

LINE_42

	; FOR Z2=1 TO Z3

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldx	#FLTVAR_Z3
	jsr	to_ip_ix

	; NEXT

	jsr	next

	; GOSUB 600

	ldx	#LINE_600
	jsr	gosub_ix

	; ON Z2 GOTO 35,36,37,38,43

	ldx	#INTVAR_Z2
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_35, LINE_36, LINE_37, LINE_38, LINE_43

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_43

	; K-=1

	ldx	#INTVAR_K
	jsr	dec_ix_ix

	; WHEN K=48 GOTO 67

	ldx	#INTVAR_K
	ldab	#48
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_67
	jsr	jmpne_ir1_ix

LINE_44

	; POKE M+443,K

	ldx	#INTVAR_M
	ldd	#443
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_K
	jsr	poke_ir1_ix

	; S=(Q*Y)+X+M

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; J=U

	ldd	#INTVAR_J
	ldx	#INTVAR_U
	jsr	ld_id_ix

	; I=42

	ldx	#INTVAR_I
	ldab	#42
	jsr	ld_ix_pb

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_45

	; Z=PEEK(S)

	ldx	#INTVAR_S
	jsr	peek_ir1_ix

	ldx	#INTVAR_Z
	jsr	ld_ix_ir1

	; IF Z>0 THEN

	ldab	#0
	ldx	#INTVAR_Z
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_46
	jsr	jmpeq_ir1_ix

	; WHEN Z<5 GOTO 48

	ldx	#INTVAR_Z
	ldab	#5
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_48
	jsr	jmpne_ir1_ix

	; WHEN Z=43 GOTO 300

	ldx	#INTVAR_Z
	ldab	#43
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_300
	jsr	jmpne_ir1_ix

LINE_46

	; WHEN Z=0 GOTO 51

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#LINE_51
	jsr	jmpeq_ir1_ix

LINE_47

	; S=M+446

	ldx	#INTVAR_M
	ldd	#446
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; I=Q

	ldd	#INTVAR_I
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; GOTO 40

	ldx	#LINE_40
	jsr	goto_ix

LINE_48

	; POKE (Y(Z)*Q)+X(Z)+M,255

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldab	#255
	jsr	poke_ir1_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE (Y(Z)*Q)+X(Z)+M,Q

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; X(Z)=Z+26

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_fx_id

	ldx	#INTVAR_Z
	ldab	#26
	jsr	add_ir1_ix_pb

	jsr	ld_fp_ir1

	; Y(Z)=1

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

	; POKE (Y(Z)*Q)+X(Z)+M,Z

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#INTVAR_Z
	jsr	poke_ir1_ix

	; SOUND 20,2

	ldab	#20
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SC+=1

	ldx	#INTVAR_SC
	jsr	inc_ix_ix

	; GOSUB 59

	ldx	#LINE_59
	jsr	gosub_ix

	; GOSUB 310

	ldx	#LINE_310
	jsr	gosub_ix

LINE_49

	; E+=1

	ldx	#INTVAR_E
	jsr	inc_ix_ix

	; WHEN E=4 GOTO 54

	ldx	#INTVAR_E
	ldab	#4
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_54
	jsr	jmpne_ir1_ix

LINE_50

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; S=M+446

	ldx	#INTVAR_M
	ldd	#446
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; I=Q

	ldd	#INTVAR_I
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_51

	; POKE (Y(Z)*Q)+X(Z)+M,255

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldab	#255
	jsr	poke_ir1_pb

	; SOUND 1,3

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE (Y(Z)*Q)+X(Z)+M,Q

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; X(Z)=1

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_fx_id

	jsr	one_fp

	; Y(Z)=1

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

LINE_52

	; SH-=1

	ldx	#INTVAR_SH
	jsr	dec_ix_ix

	; GOSUB 58

	ldx	#LINE_58
	jsr	gosub_ix

	; IF SH=0 THEN

	ldx	#INTVAR_SH
	jsr	ld_ir1_ix

	ldx	#LINE_53
	jsr	jmpne_ir1_ix

	; T=4

	ldx	#FLTVAR_T
	ldab	#4
	jsr	ld_fx_pb

	; NEXT

	jsr	next

	; GOTO 61

	ldx	#LINE_61
	jsr	goto_ix

LINE_53

	; POKE (Y(Z)*Q)+X(Z)+M,T

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#FLTARR_X
	ldd	#INTVAR_Z
	jsr	arrval1_ir2_fx_id

	jsr	add_fr1_ir1_fr2

	ldx	#INTVAR_M
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_T
	jsr	poke_ir1_ix

	; SOUND 100,2

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE S,Q

	ldd	#INTVAR_S
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; S=M

	ldd	#INTVAR_S
	ldx	#INTVAR_M
	jsr	ld_id_ix

	; I=Q

	ldd	#INTVAR_I
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; NEXT

	jsr	next

	; GOTO 41

	ldx	#LINE_41
	jsr	goto_ix

LINE_54

	; T=4

	ldx	#FLTVAR_T
	ldab	#4
	jsr	ld_fx_pb

	; NEXT

	jsr	next

	; E=0

	ldx	#INTVAR_E
	jsr	clr_ix

	; GOTO 77

	ldx	#LINE_77
	jsr	goto_ix

LINE_55

	; POKE M+443,K

	ldx	#INTVAR_M
	ldd	#443
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_K
	jsr	poke_ir1_ix

	; FOR T=1 TO 4

	ldx	#FLTVAR_T
	jsr	forone_fx

	ldab	#4
	jsr	to_fp_pb

	; POKE 49151,64

	ldab	#64
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; FOR Z=1 TO 150

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#150
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; X=25

	ldx	#INTVAR_X
	ldab	#25
	jsr	ld_ix_pb

	; Y=13

	ldx	#INTVAR_Y
	ldab	#13
	jsr	ld_ix_pb

	; U=-1

	ldx	#INTVAR_U
	jsr	true_ix

	; K=57

	ldx	#INTVAR_K
	ldab	#57
	jsr	ld_ix_pb

	; POKE M+443,K

	ldx	#INTVAR_M
	ldd	#443
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_K
	jsr	poke_ir1_ix

LINE_56

	; SH-=1

	ldx	#INTVAR_SH
	jsr	dec_ix_ix

	; GOSUB 58

	ldx	#LINE_58
	jsr	gosub_ix

	; WHEN SH=0 GOTO 61

	ldx	#INTVAR_SH
	jsr	ld_ir1_ix

	ldx	#LINE_61
	jsr	jmpeq_ir1_ix

LINE_57

	; T=(Q*Y)+X+M

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#FLTVAR_T
	jsr	ld_fx_ir1

	; POKE T,0

	ldx	#FLTVAR_T
	ldab	#0
	jsr	poke_ix_pb

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_58

	; PRINT @123, "SHIP";

	ldab	#123
	jsr	prat_pb

	jsr	pr_ss
	.text	4, "SHIP"

	; PRINT @155, MID$(STR$(SH)+"   ",2,4);

	ldab	#155
	jsr	prat_pb

	ldx	#INTVAR_SH
	jsr	str_sr1_ix

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	3, "   "

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#4
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_59

	; PRINT @219, "SCOR";

	ldab	#219
	jsr	prat_pb

	jsr	pr_ss
	.text	4, "SCOR"

	; PRINT @251, MID$(STR$(SC)+"   ",2,4);

	ldab	#251
	jsr	prat_pb

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	3, "   "

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#4
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_60

	; PRINT @315, "HIGH";

	ldd	#315
	jsr	prat_pw

	jsr	pr_ss
	.text	4, "HIGH"

	; PRINT @347, MID$(STR$(HS)+"   ",2,4);

	ldd	#347
	jsr	prat_pw

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	3, "   "

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#4
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_61

	; POKE M+443,48

	ldx	#INTVAR_M
	ldd	#443
	jsr	add_ir1_ix_pw

	ldab	#48
	jsr	poke_ir1_pb

	; IF SC>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_62
	jsr	jmpeq_ir1_ix

	; HS=SC

	ldd	#INTVAR_HS
	ldx	#INTVAR_SC
	jsr	ld_id_ix

	; GOSUB 60

	ldx	#LINE_60
	jsr	gosub_ix

	; PRINT @315, "HIGH";

	ldd	#315
	jsr	prat_pw

	jsr	pr_ss
	.text	4, "HIGH"

	; FOR Z=1 TO 10

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND 2,1

	ldab	#2
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; GOSUB 60

	ldx	#LINE_60
	jsr	gosub_ix

LINE_62

	; PRINT @480, "ALPHA FORCE   PLAY AGAIN (Y/N)?";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	31, "ALPHA FORCE   PLAY AGAIN (Y/N)?"

LINE_63

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 63

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_63
	jsr	jmpne_ir1_ix

LINE_64

	; WHEN M$="Y" GOTO 76

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_76
	jsr	jmpne_ir1_ix

LINE_65

	; IF M$="N" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_66
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_66

	; GOTO 63

	ldx	#LINE_63
	jsr	goto_ix

LINE_67

	; POKE (Q*Y)+X+M,Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; GOTO 55

	ldx	#LINE_55
	jsr	goto_ix

LINE_68

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; PRINT @6, "MISSION: DEFEAT THE";

	ldab	#6
	jsr	prat_pb

	jsr	pr_ss
	.text	19, "MISSION: DEFEAT THE"

	; PRINT @69, "A L P H A   F O R C E";

	ldab	#69
	jsr	prat_pb

	jsr	pr_ss
	.text	21, "A L P H A   F O R C E"

	; PRINT @137, "BY JIM GERRIE";

	ldab	#137
	jsr	prat_pb

	jsr	pr_ss
	.text	13, "BY JIM GERRIE"

LINE_69

	; DIM T,X,Y,M,C,X(4),Y(4),G(31,14),Q,V,U,S,J,I,F,Z,E,K

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#FLTARR_X
	jsr	arrdim1_ir1_fx

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldab	#31
	jsr	ld_ir1_pb

	ldab	#14
	jsr	ld_ir2_pb

	ldx	#INTARR_G
	jsr	arrdim2_ir1_ix

	; M=16384

	ldx	#INTVAR_M
	ldd	#16384
	jsr	ld_ix_pw

	; Q=32

	ldx	#INTVAR_Q
	ldab	#32
	jsr	ld_ix_pb

	; POKE 16925,0

	ldab	#0
	jsr	ld_ir1_pb

	ldd	#16925
	jsr	poke_pw_ir1

	; POKE 16926,1

	ldab	#1
	jsr	ld_ir1_pb

	ldd	#16926
	jsr	poke_pw_ir1

LINE_70

	; T=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_T
	jsr	ld_fx_fr1

LINE_71

	; PRINT @224, "USE: wasd TO STEER\r";

	ldab	#224
	jsr	prat_pb

	jsr	pr_ss
	.text	19, "USE: wasd TO STEER\r"

	; PRINT @256, "     space TO FIRE\r";

	ldd	#256
	jsr	prat_pw

	jsr	pr_ss
	.text	19, "     space TO FIRE\r"

	; PRINT "BUT AVOID HITTING YOUR ALLY '@'\r";

	jsr	pr_ss
	.text	32, "BUT AVOID HITTING YOUR ALLY '@'\r"

LINE_72

	; PRINT "SHOOTING '+' SYMBOLS = 10 POINTS";

	jsr	pr_ss
	.text	32, "SHOOTING '+' SYMBOLS = 10 POINTS"

	; PRINT "BONUS SHIP EVERY 50 POINTS\r";

	jsr	pr_ss
	.text	27, "BONUS SHIP EVERY 50 POINTS\r"

LINE_73

	; FOR Y=0 TO 14

	ldx	#INTVAR_Y
	jsr	forclr_ix

	ldab	#14
	jsr	to_ip_pb

	; FOR X=0 TO 31

	ldx	#INTVAR_X
	jsr	forclr_ix

	ldab	#31
	jsr	to_ip_pb

	; READ G(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_G
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	read_ip

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_74

	; PRINT @484, "ENTER DIFFICULTY (1-3)";

	ldd	#484
	jsr	prat_pw

	jsr	pr_ss
	.text	22, "ENTER DIFFICULTY (1-3)"

LINE_75

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 75

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_75
	jsr	jmpne_ir1_ix

	; Z3=VAL(M$)

	ldx	#STRVAR_M
	jsr	val_fr1_sx

	ldx	#FLTVAR_Z3
	jsr	ld_fx_fr1

	; WHEN (Z3<1) OR (Z3>3) GOTO 75

	ldx	#FLTVAR_Z3
	ldab	#1
	jsr	ldlt_ir1_fx_pb

	ldab	#3
	ldx	#FLTVAR_Z3
	jsr	ldlt_ir2_pb_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_75
	jsr	jmpne_ir1_ix

	; Z3=800-(Z3*200)

	ldx	#FLTVAR_Z3
	jsr	ld_fr1_fx

	ldab	#200
	jsr	mul_fr1_fr1_pb

	ldd	#800
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_Z3
	jsr	ld_fx_fr1

LINE_76

	; CLS

	jsr	cls

	; PRINT @480, "ALPHA FORCE";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	11, "ALPHA FORCE"

	; V=7

	ldx	#INTVAR_V
	ldab	#7
	jsr	ld_ix_pb

	; E=0

	ldx	#INTVAR_E
	jsr	clr_ix

	; SH=4

	ldx	#INTVAR_SH
	ldab	#4
	jsr	ld_ix_pb

	; LV=0

	ldx	#INTVAR_LV
	jsr	clr_ix

	; SC=0

	ldx	#INTVAR_SC
	jsr	clr_ix

	; TT=50

	ldx	#INTVAR_TT
	ldab	#50
	jsr	ld_ix_pb

	; F=0

	ldx	#INTVAR_F
	jsr	clr_ix

LINE_77

	; E=0

	ldx	#INTVAR_E
	jsr	clr_ix

	; X=0

	ldx	#INTVAR_X
	jsr	clr_ix

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

	; C=0

	ldx	#FLTVAR_C
	jsr	clr_fx

	; U=0

	ldx	#INTVAR_U
	jsr	clr_ix

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; I=0

	ldx	#INTVAR_I
	jsr	clr_ix

	; Z=0

	ldx	#INTVAR_Z
	jsr	clr_ix

	; S=M+446

	ldx	#INTVAR_M
	ldd	#446
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; I=Q

	ldd	#INTVAR_I
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; V+=1

	ldx	#INTVAR_V
	jsr	inc_ix_ix

	; IF V>16 THEN

	ldab	#16
	ldx	#INTVAR_V
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_78
	jsr	jmpeq_ir1_ix

	; V=8

	ldx	#INTVAR_V
	ldab	#8
	jsr	ld_ix_pb

LINE_78

	; K=57

	ldx	#INTVAR_K
	ldab	#57
	jsr	ld_ix_pb

	; LV+=1

	ldx	#INTVAR_LV
	jsr	inc_ix_ix

	; PRINT @496, "               ";

	ldd	#496
	jsr	prat_pw

	jsr	pr_ss
	.text	15, "               "

	; PRINT @496, "LEVEL";STR$(LV);" ";

	ldd	#496
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "LEVEL"

	ldx	#INTVAR_LV
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_79

	; T=SHIFT(RND(6),4)+143

	ldab	#6
	jsr	irnd_ir1_pb

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	ldx	#FLTVAR_T
	jsr	ld_fx_ir1

	; WHEN PEEK(M)=T GOTO 79

	ldx	#INTVAR_M
	jsr	peek_ir1_ix

	ldx	#FLTVAR_T
	jsr	ldeq_ir1_ir1_fx

	ldx	#LINE_79
	jsr	jmpne_ir1_ix

LINE_80

	; FOR Y=0 TO 14

	ldx	#INTVAR_Y
	jsr	forclr_ix

	ldab	#14
	jsr	to_ip_pb

	; FOR X=0 TO 31

	ldx	#INTVAR_X
	jsr	forclr_ix

	ldab	#31
	jsr	to_ip_pb

	; IF G(X,Y) THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_G
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldx	#LINE_81
	jsr	jmpeq_ir1_ix

	; POKE (Q*Y)+X+M,Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 82

	ldx	#LINE_82
	jsr	goto_ix

LINE_81

	; POKE (Q*Y)+X+M,T

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#FLTVAR_T
	jsr	poke_ir1_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOSUB 700

	ldx	#LINE_700
	jsr	gosub_ix

LINE_82

	; GOSUB 58

	ldx	#LINE_58
	jsr	gosub_ix

	; GOSUB 59

	ldx	#LINE_59
	jsr	gosub_ix

	; GOSUB 60

	ldx	#LINE_60
	jsr	gosub_ix

	; POKE S,I

	ldd	#INTVAR_S
	ldx	#INTVAR_I
	jsr	poke_id_ix

	; PRINT @411, "shot";

	ldd	#411
	jsr	prat_pw

	jsr	pr_ss
	.text	4, "shot"

	; POKE M+443,K

	ldx	#INTVAR_M
	ldd	#443
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_K
	jsr	poke_ir1_ix

	; POKE M+444,Q

	ldx	#INTVAR_M
	ldd	#444
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; POKE M+445,Q

	ldx	#INTVAR_M
	ldd	#445
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

LINE_84

	; FOR T=0 TO 4

	ldx	#FLTVAR_T
	jsr	forclr_fx

	ldab	#4
	jsr	to_fp_pb

	; X(T)=SHIFT(T+1,2)

	ldx	#FLTARR_X
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_T
	jsr	inc_fr1_fx

	ldab	#2
	jsr	shift_fr1_fr1_pb

	jsr	ld_fp_fr1

	; Y(T)=1

	ldx	#INTARR_Y
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

	; NEXT

	jsr	next

LINE_85

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

	; X=25

	ldx	#INTVAR_X
	ldab	#25
	jsr	ld_ix_pb

	; Y=13

	ldx	#INTVAR_Y
	ldab	#13
	jsr	ld_ix_pb

	; U=-1

	ldx	#INTVAR_U
	jsr	true_ix

	; T=(Q*Y)+X+M

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldx	#FLTVAR_T
	jsr	ld_fx_ir1

	; POKE T,0

	ldx	#FLTVAR_T
	ldab	#0
	jsr	poke_ix_pb

	; GOTO 39

	ldx	#LINE_39
	jsr	goto_ix

LINE_86

LINE_87

LINE_88

LINE_89

LINE_90

LINE_91

LINE_92

LINE_93

LINE_94

LINE_95

LINE_96

LINE_97

LINE_98

LINE_99

LINE_100

LINE_200

	; FOR T=1 TO 4

	ldx	#FLTVAR_T
	jsr	forone_fx

	ldab	#4
	jsr	to_fp_pb

LINE_205

	; X=RND(24)+1

	ldab	#24
	jsr	irnd_ir1_pb

	jsr	inc_ir1_ir1

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=RND(12)+1

	ldab	#12
	jsr	irnd_ir1_pb

	jsr	inc_ir1_ir1

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; WHEN PEEK((Q*Y)+X+M)<>32 GOTO 205

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldab	#32
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_205
	jsr	jmpne_ir1_ix

LINE_210

	; POKE (Q*Y)+X+M,43

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldab	#43
	jsr	poke_ir1_pb

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_300

	; POKE S,255

	ldx	#INTVAR_S
	ldab	#255
	jsr	poke_ix_pb

	; SOUND 179,1

	ldab	#179
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 198,1

	ldab	#198
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; K+=1

	ldx	#INTVAR_K
	jsr	inc_ix_ix

	; IF K>57 THEN

	ldab	#57
	ldx	#INTVAR_K
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_301
	jsr	jmpeq_ir1_ix

	; K=57

	ldx	#INTVAR_K
	ldab	#57
	jsr	ld_ix_pb

LINE_301

	; POKE M+443,K

	ldx	#INTVAR_M
	ldd	#443
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_K
	jsr	poke_ir1_ix

	; SC+=10

	ldx	#INTVAR_SC
	ldab	#10
	jsr	add_ix_ix_pb

	; GOSUB 59

	ldx	#LINE_59
	jsr	gosub_ix

	; POKE S,32

	ldx	#INTVAR_S
	ldab	#32
	jsr	poke_ix_pb

	; S=M+446

	ldx	#INTVAR_M
	ldd	#446
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; I=Q

	ldd	#INTVAR_I
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; GOSUB 310

	ldx	#LINE_310
	jsr	gosub_ix

	; GOTO 40

	ldx	#LINE_40
	jsr	goto_ix

LINE_310

	; IF SC>=TT THEN

	ldx	#INTVAR_SC
	ldd	#INTVAR_TT
	jsr	ldge_ir1_ix_id

	ldx	#LINE_320
	jsr	jmpeq_ir1_ix

	; TT+=50

	ldx	#INTVAR_TT
	ldab	#50
	jsr	add_ix_ix_pb

	; SH+=1

	ldx	#INTVAR_SH
	jsr	inc_ix_ix

	; GOSUB 58

	ldx	#LINE_58
	jsr	gosub_ix

	; PRINT @123, "ship";

	ldab	#123
	jsr	prat_pb

	jsr	pr_ss
	.text	4, "ship"

	; FOR Z=1 TO 10

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; GOSUB 58

	ldx	#LINE_58
	jsr	gosub_ix

LINE_320

	; RETURN

	jsr	return

LINE_500

	; POKE S,I

	ldd	#INTVAR_S
	ldx	#INTVAR_I
	jsr	poke_id_ix

	; FOR Z2=1 TO 100

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#100
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_600

	; Z2=0

	ldx	#INTVAR_Z2
	jsr	clr_ix

	; IF PEEK(2) AND NOT PEEK(16952) AND 4 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	and_ir1_ir1_pb

	ldx	#LINE_684
	jsr	jmpeq_ir1_ix

	; Z2=3

	ldx	#INTVAR_Z2
	ldab	#3
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_684

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16946
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_685
	jsr	jmpeq_ir1_ix

	; Z2=1

	ldx	#INTVAR_Z2
	jsr	one_ix

	; RETURN

	jsr	return

LINE_685

	; IF PEEK(2) AND NOT PEEK(16948) AND 4 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16948
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	and_ir1_ir1_pb

	ldx	#LINE_686
	jsr	jmpeq_ir1_ix

	; Z2=4

	ldx	#INTVAR_Z2
	ldab	#4
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_686

	; IF PEEK(2) AND NOT PEEK(16949) AND 1 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16949
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_687
	jsr	jmpeq_ir1_ix

	; Z2=2

	ldx	#INTVAR_Z2
	ldab	#2
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_687

	; IF PEEK(2) AND NOT PEEK(16952) AND 8 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#8
	jsr	and_ir1_ir1_pb

	ldx	#LINE_689
	jsr	jmpeq_ir1_ix

	; Z2=5

	ldx	#INTVAR_Z2
	ldab	#5
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_689

	; RETURN

	jsr	return

LINE_700

	; IF F=0 THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#LINE_710
	jsr	jmpne_ir1_ix

	; F=1

	ldx	#INTVAR_F
	jsr	one_ix

	; GOTO 720

	ldx	#LINE_720
	jsr	goto_ix

LINE_710

	; IF F=1 THEN

	ldx	#INTVAR_F
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_720
	jsr	jmpeq_ir1_ix

	; F=0

	ldx	#INTVAR_F
	jsr	clr_ix

LINE_720

	; RETURN

	jsr	return

LLAST

	; END

	jsr	progend

	.module	mdalloc
; alloc D bytes in array memory.
; then relink strings.
alloc
	std	tmp1
	ldx	strfree
	addd	strfree
	std	strfree
	ldd	strend
	addd	tmp1
	std	strend
	sts	tmp2
	subd	tmp2
	blo	_ok
	ldab	#OM_ERROR
	jmp	error
_ok
	lds	strfree
	des
_again
	dex
	dex
	ldd	,x
	pshb
	psha
	cpx	strbuf
	bhi	_again
	lds	tmp2
	ldx	strbuf
	ldd	strbuf
	addd	tmp1
	std	strbuf
	clra
_nxtz
	staa	,x
	inx
	cpx	strbuf
	blo	_nxtz
	ldx	strbuf
; relink permanent strings
; ENTRY:  X points to offending link word in strbuf
; EXIT:   X points to strend
strlink
	cpx	strend
	bhs	_rts
	stx	tmp1
	ldd	tmp1
	addd	#2
	ldx	,x
	std	1,x
	ldab	0,x
	ldx	1,x
	abx
	bra	strlink
_rts
	rts

	.module	mddivflt
; divide X by Y
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   X/Y in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
divflt
	ldaa	#8*5
	bsr	divmod
	tst	tmp4
	bmi	_add1
_com
	ldd	8,x
	coma
	comb
	std	3,x
	ldd	6,x
	coma
	comb
	std	1,x
	ldab	5,x
	comb
	stab	0,x
	rts
_add1
	ldd	8,x
	addd	#1
	std	3,x
	ldd	6,x
	adcb	#0
	adca	#0
	std	1,x
	ldab	5,x
	adcb	#0
	stab	0,x
	rts
divuflt
	clr	tmp4
	ldab	#8*5
	stab	tmp1
	bsr	divumod
	bra	_com

	.module	mddivmod
; divide/modulo X by Y with remainder
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;          #shifts in ACCA (24 for modulus, 40 for division
;   EXIT   for division:
;            NOT ABS(X)/ABS(Y) in (5,x 6,x 7,x 8,x 9,x)
;   EXIT   for modulus:
;            NOT INT(ABS(X)/ABS(Y)) in (7,x 8,x 9,x)
;            FMOD(X,Y) in (0,x 1,x 2,x 3,x 4,x)
;          result sign in tmp4.(0 = pos, -1 = neg).
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
divmod
	staa	tmp1
	clr	tmp4
	tst	0,x
	bpl	_posX
	com	tmp4
	jsr	negx
_posX
	tst	0+argv
	bpl	divumod
	com	tmp4
	jsr	negargv
divumod
	ldd	3,x
	std	6,x
	ldd	1,x
	std	4,x
	ldab	0,x
	stab	3,x
	clra
	clrb
	std	8,x
	std	1,x
	stab	0,x
_nxtdiv
	rol	7,x
	rol	6,x
	rol	5,x
	rol	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	bcc	_trialsub
	; force subtraction
	ldd	3,x
	subd	3+argv
	std	3,x
	ldd	1,x
	sbcb	2+argv
	sbca	1+argv
	std	1,x
	ldab	0,x
	sbcb	0+argv
	stab	0,x
	clc
	bra	_shift
_trialsub
	ldd	3,x
	subd	3+argv
	std	tmp3
	ldd	1,x
	sbcb	2+argv
	sbca	1+argv
	std	tmp2
	ldab	0,x
	sbcb	0+argv
	stab	tmp1+1
	blo	_shift
	ldd	tmp3
	std	3,x
	ldd	tmp2
	std	1,x
	ldab	tmp1+1
	stab	0,x
_shift
	rol	9,x
	rol	8,x
	dec	tmp1
	bne	_nxtdiv
	rol	7,x
	rol	6,x
	rol	5,x
	rts

	.module	mdgeteq
geteq
	beq	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetge
getge
	bge	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetlt
getlt
	blt	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetlw
; fetch lower word from integer variable descriptor
;  ENTRY: D holds integer variable descriptor
;  EXIT: D holds lower word of integer variable
getlw
	std	tmp1
	stx	tmp2
	ldx	tmp1
	ldd	1,x
	ldx	tmp2
	rts

	.module	mdgetne
getne
	bne	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdidivb
; fast integer division by three or five
; ENTRY+EXIT:  int in tmp1+1,tmp2,tmp2+1
;         ACCB contains:
;            $CC for div-5
;            $AA for div-3
;         tmp3,tmp3+1,tmp4 used for storage
idivb
	stab	tmp4
	ldab	tmp1+1
	pshb
	ldd	tmp2
	psha
	ldaa	tmp4
	mul
	std	tmp3
	addd	tmp2
	std	tmp2
	ldab	tmp1+1
	adcb	tmp3+1
	stab	tmp1+1
	ldd	tmp1+1
	addd	tmp3
	std	tmp1+1
	pulb
	ldaa	tmp4
	mul
	stab	tmp3+1
	addd	tmp1+1
	std	tmp1+1
	pulb
	ldaa	tmp4
	mul
	addb	tmp1+1
	addb	tmp3+1
	stab	tmp1+1
	rts

	.module	mdimodb
; fast integer modulo operation by three or five
; ENTRY:  int in tmp1+1,tmp2,tmp2+1
;         ACCB contains modulus (3 or 5)
; EXIT:  result in ACCA
imodb
	pshb
	ldaa	tmp1+1
	bpl	_ok
	deca
_ok
	adda	tmp2
	adca	tmp2+1
	adca	#0
	adca	#0
	tab
	lsra
	lsra
	lsra
	lsra
	andb	#$0F
	aba
	pulb
_dec
	sba
	bhs	_dec
	aba
	rts

	.module	mdmul12
; multiply words in TMP1 and TMP2
; result in TMP3
mul12
	ldaa	tmp1+1
	ldab	tmp2+1
	mul
	std	tmp3
	ldaa	tmp1
	ldab	tmp2+1
	mul
	addb	tmp3
	stab	tmp3
	ldaa	tmp1+1
	ldab	tmp2
	mul
	tba
	adda	tmp3
	ldab	tmp3+1
	rts

	.module	mdmulbytf
; multiply X with ACCB
; result in X
; clobbers TMP1+1...TMP3+1
mulbytf
	bsr	mulbyti
	ldaa	4,x
	ldab	tmp1
	mul
	std	tmp3
	ldaa	3,x
	ldab	tmp1
	mul
	addd	tmp2+1
	std	tmp2+1
	ldd	tmp1+1
	adcb	#0
	adca	#0
	std	tmp1+1
	rts

	.module	mdmulbyti
; multiply X with ACCB
; result in TMP1+1...TMP2+1
; clobbers TMP1
mulbyti
	stab	tmp1
	ldaa	2,x
	mul
	std	tmp2
	ldaa	0,x
	ldab	tmp1
	mul
	stab	tmp1+1
	ldaa	1,x
	ldab	tmp1
	mul
	addd	tmp1+1
	std	tmp1+1
	rts

	.module	mdmulint
mulint
	ldaa	2+argv
	ldab	2,x
	mul
	std	tmp2
	ldaa	1+argv
	ldab	1,x
	mul
	stab	tmp1+1
	ldaa	2+argv
	ldab	1,x
	mul
	addd	tmp1+1
	std	tmp1+1
	ldaa	1+argv
	ldab	2,x
	mul
	addd	tmp1+1
	std	tmp1+1
	ldaa	2+argv
	ldab	0,x
	mul
	addb	tmp1+1
	stab	tmp1+1
	ldaa	0+argv
	ldab	2,x
	mul
	addb	tmp1+1
	stab	tmp1+1
	rts
mulintx
	bsr	mulint
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

	.module	mdnegargv
negargv
	neg	4+argv
	bcs	_com3
	neg	3+argv
	bcs	_com2
	neg	2+argv
	bcs	_com1
	neg	1+argv
	bcs	_com0
	neg	0+argv
	rts
_com3
	com	3+argv
_com2
	com	2+argv
_com1
	com	1+argv
_com0
	com	0+argv
	rts

	.module	mdnegtmp
negtmp
	neg	tmp3+1
	bcs	_com3
	neg	tmp3
	bcs	_com2
	neg	tmp2+1
	bcs	_com1
	neg	tmp2
	bcs	_com0
	neg	tmp1+1
	rts
_com3
	com	tmp3
_com2
	com	tmp2+1
_com1
	com	tmp2
_com0
	com	tmp1+1
	rts

	.module	mdnegx
negx
	neg	4,x
	bcs	_com3
	neg	3,x
	bcs	_com2
negxi
	neg	2,x
	bcs	_com1
	neg	1,x
	bcs	_com0
	neg	0,x
	rts
_com3
	com	3,x
_com2
	com	2,x
_com1
	com	1,x
_com0
	com	0,x
	rts

	.module	mdpeek
; perform PEEK(X), emulating keypolling
;   ENTRY: X holds storage byte
;   EXIT:  ACCB holds peeked byte
peek
	cpx	#M_KBUF
	blo	_peek
	cpx	#M_IKEY
	bhi	_peek
	beq	_poll
	cpx	#M_KBUF+7
	bhi	_peek
_poll
	jsr	R_KPOLL
	beq	_peek
	staa	M_IKEY
_peek
	ldab	,x
	rts

	.module	mdprat
prat
	bita	#$FE
	bne	_fcerror
	anda	#$01
	oraa	#$40
	std	M_CRSR
	rts
_fcerror
	ldab	#FC_ERROR
	jmp	error

	.module	mdprint
print
_loop
	ldaa	,x
	jsr	R_PUTC
	inx
	decb
	bne	_loop
	rts

	.module	mdref1
; validate offset from 1D descriptor X and argv
; if empty desc, then alloc D bytes in array memory and 11 elements.
; return word offset in D and byte offset in tmp1
ref1
	std	tmp1
	ldd	,x
	bne	_preexist
	ldd	strbuf
	std	,x
	ldd	#11
	std	2,x
	ldd	tmp1
	pshx
	jsr	alloc
	pulx
_preexist
	ldd	0+argv
	std	tmp1
	subd	2,x
	bhs	_err
	ldd	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

	.module	mdref2
; get offset from 2D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref2
	ldd	,x
	beq	_err
	ldd	2+argv
	std	tmp1
	subd	4,x
	bhs	_err
	ldd	2,x
	std	tmp2
	subd	0+argv
	bls	_err
	jsr	mul12
	addd	0+argv
	std	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

	.module	mdrefflt
; return flt array reference in D/tmp1
refflt
	lsld
	addd	tmp1
	addd	0,x
	std	tmp1
	rts

	.module	mdrefint
; return int/str array reference in D/tmp1
refint
	addd	tmp1
	addd	0,x
	std	tmp1
	rts

	.module	mdrnd
rnd
	ldab	tmp1+1
	bpl	gornd
	orab	#1
	pshb
	ldaa	tmp2
	mul
	std	rvseed
	ldaa	tmp2+1
	pulb
	mul
	addd	rvseed
	std	rvseed
gornd
	ldaa	rvseed
	ldab	#-2
	mul
	std	tmp3
	ldaa	rvseed+1
	ldab	#-2
	mul
	addb	#-2
	adca	tmp3+1
	sbcb	tmp3
	sbca	#0
	adcb	#0
	adca	#0
	std	rvseed
	rts
irnd
	bsr	rnd
	ldaa	tmp2+1
	ldab	rvseed+1
	mul
	staa	tmp3+1
	ldaa	tmp2+1
	ldab	rvseed
	mul
	addb	tmp3+1
	adca	#0
	std	tmp3
	ldaa	tmp2
	ldab	rvseed+1
	mul
	addd	tmp3
	staa	tmp3+1
	ldaa	#0
	adca	#0
	staa	tmp3
	ldaa	tmp2
	ldab	rvseed
	mul
	addd	tmp3
	std	tmp3
	ldaa	#0
	adca	#0
	staa	tmp1
	ldaa	tmp1+1
	beq	_done
	ldab	rvseed+1
	mul
	addb	tmp3
	stab	tmp3
	adca	tmp1
	staa	tmp1
	ldaa	tmp1+1
	ldab	rvseed
	mul
	addb	tmp1
	stab	tmp1
_done
	ldd	tmp3
	addd	#1
	bcc	_rts
	inc	tmp1
_rts
	rts

	.module	mdrnstrng
; read numeric DATA when records are pure strings
; EXIT:  flt in tmp1+1, tmp2, tmp3
rnstrng
	pshx
	jsr	rpstrng
	ldx	#tmp1+1
	jsr	strval
	pulx
	rts

	.module	mdrpstrng
; read string DATA when records are pure strings
; EXIT:  data string descriptor in tmp1+1, tmp2
rpstrng
	pshx
	ldx	DP_DATA
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldab	,x
	stab	tmp1+1
	inx
	stx	tmp2
	abx
	stx	DP_DATA
	pulx
	rts

	.module	mdshlflt
; multiply X by 2^ACCB for positive ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1
shlflt
	cmpb	#8
	blo	_shlbit
	stab	tmp1
	ldd	1,x
	std	0,x
	ldd	3,x
	std	2,x
	clr	4,x
	ldab	tmp1
	subb	#8
	bne	shlflt
	rts
_shlbit
	lsl	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	decb
	bne	_shlbit
	rts

	.module	mdshlint
; multiply X by 2^ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x)
;          uses tmp1
shlint
	cmpb	#8
	blo	_shlbit
	stab	tmp1
	ldd	1,x
	std	0,x
	clr	2,x
	ldab	tmp1
	subb	#8
	bne	shlint
	rts
_shlbit
	lsl	2,x
	rol	1,x
	rol	0,x
	decb
	bne	_shlbit
	rts

	.module	mdstrdel
; remove a permanent string
; then re-link trailing strings
strdel
	ldd	1,x
	subd	strbuf
	blo	_rts
	ldd	1,x
	subd	strend
	bhs	_rts
	ldd	strend
	subd	#2
	subb	0,x
	sbca	#0
	std	strend
	ldab	0,x
	ldx	1,x
	dex
	dex
	stx	tmp1
	abx
	inx
	inx
	sts	tmp2
	txs
	ldx	tmp1
_nxtwrd
	pula
	pulb
	std	,x
	inx
	inx
	cpx	strend
	blo	_nxtwrd
	lds	tmp2
	ldx	tmp1
	jmp	strlink
_rts
	rts

	.module	mdstreqs
; compare string against stack
; ENTRY: top of stack is return to caller (ld<ne/eq>_ir1_sr1_ss)
;        next two bytes address of string length+payload
; EXIT:  we modify those two bytes to point to code beyond payload so caller can just RTS
;        we return correct Z flag for caller
streqs
	ldx	tmp2
	jsr	strrel
	sts	tmp3
	tsx
	ldx	2,x
	ldab	,x
	cmpb	tmp1+1
	bne	_ne
	tstb
	beq	_eq
	tsx
	ldx	2,x
	inx
	txs
	ldx	tmp2
_nxtchr
	pula
	cmpa	,x
	bne	_ne
	inx
	decb
	bne	_nxtchr
_eq
	lds	tmp3
	bsr	_fudge
	clra
	rts
_ne
	lds	tmp3
	bsr	_fudge
	rts
_fudge
	tsx
	ldd	4,x
	ldx	4,x
	sec
	adcb	,x
	adca	#0
	tsx
	std	4,x
	rts

	.module	mdstrflt
strflt
	inc	strtcnt
	pshx
	tst	tmp1+1
	bmi	_neg
	ldab	#' '
	bra	_wdigs
_neg
	jsr	negtmp
	ldab	#'-'
_wdigs
	ldx	tmp3
	pshx
	ldx	strfree
	stab	,x
	clr	tmp1
_nxtwdig
	inc	tmp1
	lsr	tmp1+1
	ror	tmp2
	ror	tmp2+1
	ror	tmp3
	ldab	#5
	jsr	imodb
	staa	tmp3+1
	lsl	tmp3
	rola
	adda	#'0'
	psha
	ldd	tmp2
	subb	tmp3+1
	sbca	#0
	std	tmp2
	ldab	tmp1+1
	sbcb	#0
	stab	tmp1+1
	ldab	#$CC
	jsr	idivb
	bne	_nxtwdig
	ldd	tmp2
	bne	_nxtwdig
	ldab	tmp1
_nxtc
	pula
	inx
	staa	,x
	decb
	bne	_nxtc
	inx
	inc	tmp1
	pula
	pulb
	subd	#0
	bne	_fdo
	jmp	_fdone
_fdo
	std	tmp2
	ldab	#'.'
	stab	,x
	inc	tmp1
	inx
	ldd	#6
	staa	tmp1+1
	stab	tmp3
_nxtf
	ldd	tmp2
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	addd	tmp2
	std	tmp2
	ldab	tmp1+1
	adcb	#0
	stab	tmp1+1
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	ldd	tmp1
	addb	#'0'
	stab	,x
	inx
	inc	tmp1
	clrb
	stab	tmp1+1
	dec	tmp3
	bne	_nxtf
	tst	tmp2
	bmi	_nxtrnd
_nxtzero
	dex
	dec	tmp1
	ldaa	,x
	cmpa	#'0'
	beq	_nxtzero
	bra	_zdone
_nxtrnd
	dex
	dec	tmp1
	ldaa	,x
	cmpa	#'.'
	beq	_dot
	inca
	cmpa	#'9'
	bhi	_nxtrnd
	bra	_rdone
_dot
	ldaa	#'0'
	staa	,x
	ldab	tmp1
_ndot
	decb
	beq	_dzero
	dex
	ldaa	,x
	inca
	cmpa	#'9'
	bls	_ddone
	bra	_ndot
_ddone
	staa	,x
	ldx	strfree
	ldab	tmp1
	abx
	bra	_fdone
_dzero
	ldaa	#'1'
	staa	,x
	ldx	strfree
	ldab	tmp1
	abx
	ldaa	#'0'
_rdone
	staa	,x
_zdone
	inx
	inc	tmp1
_fdone
	ldd	strfree
	stx	strfree
	pulx
	rts

	.module	mdstrrel
; release a temporary string
; ENTRY: X holds string start
; EXIT:  <all reg's preserved>
; sttrel should be called from:
;  - ASC, VAL, LEN, PRINT
;  - right hand side of strcat
;  - relational operators
;  - when LEFT$, MID$, RIGHT$ return null
strrel
	cpx	strend
	bls	_rts
	cpx	strstop
	bhs	_rts
	tst	strtcnt
	beq	_panic
	dec	strtcnt
	beq	_restore
	stx	strfree
_rts
	rts
_restore
	pshx
	ldx	strend
	inx
	inx
	stx	strfree
	pulx
	rts
_panic
	ldab	#1
	jmp	error

	.module	mdstrtmp
; make a temporary clone of a string
; ENTRY: X holds string start
;        B holds string length
; EXIT:  D holds new string pointer
strtmp
	cpx	strfree
	bls	_reserve
	stx	tmp1
	ldd	tmp1
	rts
_reserve
	inc	strtcnt
strcat
	tstb
	beq	_null
	sts	tmp1
	txs
	ldx	strfree
_nxtcp
	pula
	staa	,x
	inx
	decb
	bne	_nxtcp
	lds	tmp1
	ldd	strfree
	stx	strfree
	rts
_null
	ldd	strfree
	rts

	.module	mdstrval
strval
	ldab	0,x
	ldx	1,x
	jsr	strrel
inptval
	clr	tmp1
	bsr	_getsgn
	jsr	_getint
	tstb
	beq	_dosign
	ldaa	,x
	cmpa	#'.'
	bne	_dosign
	inx
	decb
	beq	_dosign
	stab	tmp5
	ldd	tmp2
	pshb
	psha
	ldd	tmp1
	pshb
	psha
	ldab	tmp5
	bsr	_getint
	stx	tmp5
	ldab	tmp4
	ldx	#_tblten
	abx
	abx
	abx
	ldab	,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	sts	tmp4
	ldd	tmp4
	subd	#10
	std	tmp4
	lds	tmp4
	tsx
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	#0
	std	3,x
	stab	tmp4
	jsr	divuflt
	ldd	3,x
	std	tmp3
	ldab	#10
	tsx
	abx
	txs
	pula
	pulb
	std	tmp1
	pula
	pulb
	std	tmp2
	ldx	tmp5
_dosign
	tst	tmp1
	beq	_srts
	jmp	negtmp
_getsgn
	tstb
	beq	_srts
	ldaa	,x
	cmpa	#' '
	bne	_trysgn
	inx
	decb
	bra	_getsgn
_trysgn
	cmpa	#'+'
	beq	_prts
	cmpa	#'-'
	bne	_srts
	dec	tmp1
_prts
	inx
	decb
_srts
	rts
_getint
	clra
	staa	tmp1+1
	staa	tmp2
	staa	tmp2+1
	staa	tmp4
_nxtdig
	tstb
	beq	_crts
	ldaa	,x
	suba	#'0'
	blo	_crts
	cmpa	#10
	bhs	_crts
	inx
	decb
	pshb
	psha
	ldd	tmp2
	std	tmp3
	ldab	tmp1+1
	stab	tmp4+1
	bsr	_dbl
	bsr	_dbl
	ldd	tmp3
	addd	tmp2
	std	tmp2
	ldab	tmp4+1
	adcb	tmp1+1
	stab	tmp1+1
	bsr	_dbl
	pulb
	clra
	addd	tmp2
	std	tmp2
	ldab	tmp1+1
	adcb	#0
	stab	tmp1+1
	inc	tmp4
	ldd	tmp1+1
	subd	#$0CCC
	pulb
	blo	_nxtdig
	ldaa	tmp2+1
	cmpa	#$CC
	blo	_nxtdig
_crts
	clra
	staa	tmp3
	staa	tmp3+1
	rts
_dbl
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	rts
_tblten
	.byte	$00,$00,$01
	.byte	$00,$00,$0A
	.byte	$00,$00,$64
	.byte	$00,$03,$E8
	.byte	$00,$27,$10
	.byte	$01,$86,$A0
	.byte	$0F,$42,$40
	.byte	$98,$96,$80

	.module	mdtmp2xf
; copy fixedpt tmp to [X]
;   ENTRY  Y in tmp1+1,tmp2,tmp3
;   EXIT   Y copied to 0,x 1,x 2,x 3,x 4,x
tmp2xf
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts

	.module	mdtonat
; push for-loop record on stack
; ENTRY:  ACCB  contains size of record
;         r1    contains stopping variable
;               and is always fixedpoint.
;         r1+3  must contain zero when both:
;               1. loop var is integral.
;               2. STEP is missing
to
	clra
	std	tmp3
	pulx
	stx	tmp1
	tsx
	clrb
_nxtfor
	abx
	ldd	1,x
	subd	letptr
	beq	_oldfor
	ldab	,x
	cmpb	#3
	bhi	_nxtfor
	sts	tmp2
	ldd	tmp2
	subd	tmp3
	std	tmp2
	lds	tmp2
	tsx
	ldab	tmp3+1
	stab	0,x
	ldd	letptr
	std	1,x
_oldfor
	ldd	tmp1
	std	3,x
	ldab	r1
	stab	5,x
	ldd	r1+1
	std	6,x
	ldd	r1+3
	std	8,x
	ldab	tmp3+1
	cmpb	#15
	beq	_flt
	inca
	staa	10,x
	bra	_done
_flt
	ldd	#0
	std	10,x
	std	13,x
	inca
	staa	12,x
_done
	ldx	tmp1
	jmp	,x

add_fr1_fr1_ix			; numCalls = 41
	.module	modadd_fr1_fr1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_ir1_fr2			; numCalls = 41
	.module	modadd_fr1_ir1_fr2
	ldd	r2+3
	std	r1+3
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 34
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 1
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_pb			; numCalls = 1
	.module	modadd_ir1_ix_pb
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir1_ix_pw			; numCalls = 12
	.module	modadd_ir1_ix_pw
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ix_id			; numCalls = 1
	.module	modadd_ir2_ix_id
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ix_ix_ir1			; numCalls = 4
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 2
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 5
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir1_ir1_pb			; numCalls = 5
	.module	modand_ir1_ir1_pb
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

arrdim1_ir1_fx			; numCalls = 1
	.module	modarrdim1_ir1_fx
	ldd	,x
	beq	_ok
	ldab	#DD_ERROR
	jmp	error
_ok
	ldd	strbuf
	std	,x
	ldd	r1+1
	addd	#1
	std	2,x
	lsld
	lsld
	addd	2,x
	jmp	alloc

arrdim1_ir1_ix			; numCalls = 1
	.module	modarrdim1_ir1_ix
	ldd	,x
	beq	_ok
	ldab	#DD_ERROR
	jmp	error
_ok
	ldd	strbuf
	std	,x
	ldd	r1+1
	addd	#1
	std	2,x
	lsld
	addd	2,x
	jmp	alloc

arrdim2_ir1_ix			; numCalls = 1
	.module	modarrdim2_ir1_ix
	ldd	,x
	beq	_ok
	ldab	#DD_ERROR
	jmp	error
_ok
	ldd	strbuf
	std	,x
	ldd	r1+1
	addd	#1
	std	2,x
	std	tmp1
	ldd	r2+1
	addd	#1
	std	4,x
	std	tmp2
	jsr	mul12
	std	tmp3
	lsld
	addd	tmp3
	jmp	alloc

arrref1_ir1_fx_id			; numCalls = 19
	.module	modarrref1_ir1_fx_id
	jsr	getlw
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	std	letptr
	rts

arrref1_ir1_ix_id			; numCalls = 19
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix_id			; numCalls = 1
	.module	modarrref2_ir1_ix_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_fx_id			; numCalls = 13
	.module	modarrval1_ir1_fx_id
	jsr	getlw
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	std	r1+3
	rts

arrval1_ir1_ix_id			; numCalls = 46
	.module	modarrval1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval1_ir2_fx_id			; numCalls = 41
	.module	modarrval1_ir2_fx_id
	jsr	getlw
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	ldd	3,x
	std	r2+3
	rts

arrval1_ir2_ix_id			; numCalls = 1
	.module	modarrval1_ir2_ix_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval2_ir1_ix_id			; numCalls = 3
	.module	modarrval2_ir1_ix_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval2_ir1_ix_ir2			; numCalls = 3
	.module	modarrval2_ir1_ix_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

clear			; numCalls = 1
	.module	modclear
	clra
	ldx	#bss
	bra	_start
_again
	staa	,x
	inx
_start
	cpx	#bes
	bne	_again
	stx	strbuf
	stx	strend
	inx
	inx
	stx	strfree
	ldx	#$8FFF
	stx	strstop
	ldx	#startdata
	stx	DP_DATA
	rts

clr_fx			; numCalls = 1
	.module	modclr_fx
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

clr_ix			; numCalls = 20
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 1
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

com_ir2_ir2			; numCalls = 5
	.module	modcom_ir2_ir2
	com	r2+2
	com	r2+1
	com	r2
	rts

dec_fp_fp			; numCalls = 8
	.module	moddec_fp_fp
	ldx	letptr
	ldd	3,x
	std	3,x
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

dec_ip_ip			; numCalls = 8
	.module	moddec_ip_ip
	ldx	letptr
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

dec_ir1_ix			; numCalls = 1
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 1
	.module	moddec_ir2_ix
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 3
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_fd_ix			; numCalls = 1
	.module	modfor_fd_ix
	std	letptr
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	ldx	letptr
	std	1,x
	ldab	tmp1+1
	stab	0,x
	ldd	#0
	std	3,x
	rts

forclr_fx			; numCalls = 1
	.module	modforclr_fx
	stx	letptr
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

forclr_ix			; numCalls = 4
	.module	modforclr_ix
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_fx			; numCalls = 2
	.module	modforone_fx
	stx	letptr
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

forone_ix			; numCalls = 5
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 17
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 52
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_fp_fp			; numCalls = 8
	.module	modinc_fp_fp
	ldx	letptr
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inc_fr1_fx			; numCalls = 1
	.module	modinc_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ip_ip			; numCalls = 8
	.module	modinc_ip_ip
	ldx	letptr
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inc_ir1_ir1			; numCalls = 2
	.module	modinc_ir1_ir1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 1
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir2_ix			; numCalls = 1
	.module	modinc_ir2_ix
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 6
	.module	modinc_ix_ix
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 2
	.module	modinkey_sx
	pshx
	jsr	strdel
	pulx
	clr	strtcnt
	ldd	#$0100+(charpage>>8)
	std	0,x
	ldaa	M_IKEY
	bne	_gotkey
	jsr	R_KEYIN
_gotkey
	clr	M_IKEY
	staa	2,x
	bne	_rts
	staa	0,x
_rts
	rts

irnd_ir1_pb			; numCalls = 3
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 33
	.module	modjmpeq_ir1_ix
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	ins
	ins
	jmp	,x
_rts
	rts

jmpne_ir1_ix			; numCalls = 14
	.module	modjmpne_ir1_ix
	ldd	r1+1
	bne	_go
	ldaa	r1
	bne	_go
	rts
_go
	ins
	ins
	jmp	,x

ld_fp_fr1			; numCalls = 1
	.module	modld_fp_fr1
	ldx	letptr
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fp_ir1			; numCalls = 1
	.module	modld_fp_ir1
	ldx	letptr
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fr1_fx			; numCalls = 1
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 38
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 3
	.module	modld_fx_ir1
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_pb			; numCalls = 2
	.module	modld_fx_pb
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
	rts

ld_id_ix			; numCalls = 11
	.module	modld_id_ix
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 28
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 16
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 14
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 9
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 17
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ldeq_ir1_ir1_fx			; numCalls = 1
	.module	modldeq_ir1_ir1_fx
	ldd	3,x
	bne	_done
	ldd	r1+1
	subd	1,x
	bne	_done
	ldab	r1
	cmpb	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ix_pb			; numCalls = 4
	.module	modldeq_ir1_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 4
	.module	modldeq_ir1_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldge_ir1_ix_id			; numCalls = 1
	.module	modldge_ir1_ix_id
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fr1_ix			; numCalls = 7
	.module	modldlt_ir1_fr1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_pb			; numCalls = 1
	.module	modldlt_ir1_fx_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 5
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_fr1			; numCalls = 5
	.module	modldlt_ir1_ix_fr1
	ldd	#0
	subd	r1+3
	ldd	1,x
	sbcb	r1+2
	sbca	r1+1
	ldab	0,x
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_id			; numCalls = 1
	.module	modldlt_ir1_ix_id
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_pb			; numCalls = 1
	.module	modldlt_ir1_ix_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ir1			; numCalls = 4
	.module	modldlt_ir1_pb_ir1
	clra
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ix			; numCalls = 3
	.module	modldlt_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_pb_fx			; numCalls = 1
	.module	modldlt_ir2_pb_fx
	clra
	std	tmp1
	clrb
	subd	3,x
	ldd	tmp1
	sbcb	2,x
	sbca	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_ix			; numCalls = 2
	.module	modldne_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	bne	_done
	ldab	r1
	cmpb	0,x
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_ir1_pb			; numCalls = 1
	.module	modldne_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir2_ir2_ix			; numCalls = 1
	.module	modldne_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	getne
	std	r2+1
	stab	r2
	rts

midT_sr1_sr1_pb			; numCalls = 3
	.module	modmidT_sr1_sr1_pb
	clra
	std	tmp1
	ldd	5+r1
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	5+r1+2
	beq	_fc_error
	ldab	r1
	subb	5+r1+2
	blo	_zero
	incb
	stab	r1
	ldd	5+r1+1
	subd	#1
	addd	r1+1
	std	r1+1
	ldab	tmp1+1
	cmpb	r1
	bhs	_rts
	stab	r1
	rts
_zero
	pshx
	ldx	r1+1
	jsr	strrel
	pulx
	ldd	#$0100
	std	r1+1
	stab	r1
_rts
	rts
_fc_error
	ldab	#FC_ERROR
	jmp	error

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_ix			; numCalls = 58
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

neg_ir1_ix			; numCalls = 1
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

next			; numCalls = 52
	.module	modnext
	pulx
	stx	tmp1
	tsx
	ldab	,x
	cmpb	#3
	bhi	_ok
	ldab	#NF_ERROR
	jmp	error
_ok
	cmpb	#11
	bne	_flt
	ldab	8,x
	stab	r1
	ldd	9,x
	ldx	1,x
	addd	1,x
	std	r1+1
	std	1,x
	ldab	r1
	adcb	,x
	stab	r1
	stab	,x
	tsx
	tst	8,x
	bpl	_iopp
	ldd	r1+1
	subd	6,x
	ldab	r1
	sbcb	5,x
	blt	_done
	ldx	3,x
	jmp	,x
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	jmp	,x
_done
	ldab	0,x
	abx
	txs
	ldx	tmp1
	jmp	,x
_flt
	ldab	10,x
	stab	r1
	ldd	11,x
	std	r1+1
	ldd	13,x
	ldx	1,x
	addd	3,x
	std	r1+3
	std	3,x
	ldd	1,x
	adcb	r1+2
	adca	r1+1
	std	r1+1
	std	1,x
	ldab	r1
	adcb	,x
	stab	r1
	stab	,x
	tsx
	tst	10,x
	bpl	_fopp
	ldd	r1+3
	subd	8,x
	ldd	r1+1
	sbcb	7,x
	sbca	6,x
	ldab	r1
	sbcb	5,x
	blt	_done
	ldx	3,x
	jmp	,x
_fopp
	ldd	8,x
	subd	r1+3
	ldd	6,x
	sbcb	r1+2
	sbca	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	jmp	,x

one_fp			; numCalls = 1
	.module	modone_fp
	ldx	letptr
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

one_ip			; numCalls = 3
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 3
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongoto_ir1_is			; numCalls = 13
	.module	modongoto_ir1_is
	pulx
	ldd	r1
	bne	_fail
	ldab	r1+2
	decb
	cmpb	0,x
	bhs	_fail
	abx
	abx
	ldx	1,x
	jmp	,x
_fail
	ldab	,x
	abx
	abx
	jmp	1,x

or_ir1_ir1_ir2			; numCalls = 2
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_ir1			; numCalls = 2
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ix			; numCalls = 4
	.module	modpeek_ir1_ix
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pb			; numCalls = 5
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_ir2			; numCalls = 1
	.module	modpeek_ir2_ir2
	ldx	r2+1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir2_pw			; numCalls = 5
	.module	modpeek_ir2_pw
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_id_ix			; numCalls = 74
	.module	modpoke_id_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ir1_ix			; numCalls = 18
	.module	modpoke_ir1_ix
	ldab	2,x
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 8
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_ix_pb			; numCalls = 4
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

poke_pw_ir1			; numCalls = 3
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 4
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 20
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_pb			; numCalls = 9
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 10
	.module	modprat_pw
	jmp	prat

progbegin			; numCalls = 1
	.module	modprogbegin
	ldx	R_MCXID
	cpx	#'h'*256+'C'
	beq	_ok
	ldx	R_MCXBT
	cpx	#'1'*256+'0'
	bne	_mcbasic
_ok
	clrb
	ldx	#charpage
_again
	stab	,x
	inx
	incb
	bne	_again
	pulx
	pshb
	pshb
	pshb
	stab	strtcnt
	jmp	,x
_reqmsg	.text	"?UNSUPPORTED ROM"
_mcbasic
	ldx	#_reqmsg
	ldab	#30
	jsr	print
	pulx
	rts

progend			; numCalls = 2
	.module	modprogend
	pulx
	pula
	pula
	pula
	jsr	R_RESET
	jmp	R_DMODE
NF_ERROR	.equ	0
RG_ERROR	.equ	4
OD_ERROR	.equ	6
FC_ERROR	.equ	8
OV_ERROR	.equ	10
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
D0_ERROR	.equ	20
LS_ERROR	.equ	28
IO_ERROR	.equ	34
FM_ERROR	.equ	36
error
	jmp	R_ERROR

read_ip			; numCalls = 1
	.module	modread_ip
	ldx	letptr
	jsr	rnstrng
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

return			; numCalls = 13
	.module	modreturn
	pulx
	tsx
	clrb
_nxt
	abx
	ldab	,x
	bne	_ok
	ldab	#RG_ERROR
	jmp	error
_ok
	cmpb	#3
	bne	_nxt
	inx
	txs
	rts

rnd_fr1_ir1			; numCalls = 1
	.module	modrnd_fr1_ir1
	ldab	r1
	stab	tmp1+1
	bmi	_neg
	ldd	r1+1
	std	tmp2
	beq	_flt
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	ldd	#0
	std	r1+3
	rts
_neg
	ldd	r1+1
	std	tmp2
_flt
	jsr	rnd
	std	r1+3
	ldd	#0
	std	r1+1
	stab	r1
	rts

rnd_fr1_ix			; numCalls = 11
	.module	modrnd_fr1_ix
	ldab	0,x
	stab	tmp1+1
	bmi	_neg
	ldd	1,x
	std	tmp2
	beq	_flt
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	ldd	#0
	std	r1+3
	rts
_neg
	ldd	1,x
	std	tmp2
_flt
	jsr	rnd
	std	r1+3
	ldd	#0
	std	r1+1
	stab	r1
	rts

rsub_fr1_fr1_pw			; numCalls = 1
	.module	modrsub_fr1_fr1_pw
	std	tmp1
	ldd	#0
	subd	r1+3
	std	r1+3
	ldd	tmp1
	sbcb	r1+2
	sbca	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

shift_fr1_fr1_pb			; numCalls = 1
	.module	modshift_fr1_fr1_pb
	ldx	#r1
	jmp	shlflt

shift_ir1_ir1_pb			; numCalls = 1
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 10
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

str_sr1_ix			; numCalls = 4
	.module	modstr_sr1_ix
	ldd	1,x
	std	tmp2
	ldab	0,x
	stab	tmp1+1
	ldd	#0
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

strcat_sr1_sr1_ss			; numCalls = 3
	.module	modstrcat_sr1_sr1_ss
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	tsx
	ldx	,x
	ldab	,x
	addb	r1
	bcs	_lserror
	stab	r1
	ldab	,x
	inx
	jsr	strcat
	pulx
	ldab	,x
	abx
	jmp	1,x
_lserror
	ldab	#LS_ERROR
	jmp	error

strinit_sr1_sr1			; numCalls = 3
	.module	modstrinit_sr1_sr1
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

sub_ix_ix_ir1			; numCalls = 2
	.module	modsub_ix_ix_ir1
	ldd	1,x
	subd	r1+1
	std	1,x
	ldab	0,x
	sbcb	r1
	stab	0,x
	rts

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_fp_pb			; numCalls = 4
	.module	modto_fp_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_ix			; numCalls = 1
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 8
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

true_ix			; numCalls = 3
	.module	modtrue_ix
	ldd	#-1
	stab	0,x
	std	1,x
	rts

val_fr1_sx			; numCalls = 1
	.module	modval_fr1_sx
	jsr	strval
	ldab	tmp1+1
	stab	r1
	ldd	tmp2
	std	r1+1
	ldd	tmp3
	std	r1+3
	rts

; data table
startdata
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "1"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "2"
	.text	1, "9"
	.text	1, "3"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "5"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "7"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "5"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "7"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "5"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "7"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "5"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "7"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "5"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "6"
	.text	1, "9"
	.text	1, "7"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	1, "4"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	1, "8"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "10"
	.text	1, "9"
	.text	2, "11"
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
	.text	0, ""
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_HS	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_Q	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_SH	.block	3
INTVAR_TT	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
INTVAR_Z2	.block	3
FLTVAR_C	.block	5
FLTVAR_T	.block	5
FLTVAR_Z3	.block	5
; String Variables
STRVAR_M	.block	3
; Numeric Arrays
INTARR_G	.block	6	; dims=2
INTARR_Y	.block	4	; dims=1
FLTARR_X	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

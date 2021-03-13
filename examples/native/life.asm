; Assembly for life.bas
; compiled with mcbasic -native

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
DP_LNUM	.equ	$E2	; current line in BASIC
DP_TABW	.equ	$E4	; current tab width on console
DP_LPOS	.equ	$E6	; current line position on console
DP_LWID	.equ	$E7	; current line width of console
; 
; Memory equates
M_KBUF	.equ	$4231	; keystrobe buffer (8 bytes)
M_PMSK	.equ	$423C	; pixel mask for SET, RESET and POINT
M_IKEY	.equ	$427F	; key code for INKEY$
M_CRSR	.equ	$4280	; cursor location
M_LBUF	.equ	$42B2	; line input buffer (130 chars)
M_MSTR	.equ	$4334	; buffer for small string moves
M_CODE	.equ	$4346	; start of program space
; 
; ROM equates
R_BKMSG	.equ	$E1C1	; 'BREAK' string location
R_ERROR	.equ	$E238	; generate error and restore direct mode
R_BREAK	.equ	$E266	; generate break and restore direct mode
R_RESET	.equ	$E3EE	; setup stack and disable CONT
R_SPACE	.equ	$E7B9	; emit " " to console
R_QUEST	.equ	$E7BC	; emit "?" to console
R_REDO	.equ	$E7C1	; emit "?REDO" to console
R_EXTRA	.equ	$E8AB	; emit "?EXTRA IGNORED" to console
R_DMODE	.equ	$F7AA	; display OK prompt and restore direct mode
R_KPOLL	.equ	$F879	; if key is down, do KEYIN, else set Z CCR flag
R_KEYIN	.equ	$F883	; poll key for key-down transition set Z otherwise
R_PUTC	.equ	$F9C9	; write ACCA to console
R_MKTAB	.equ	$FA7B	; setup tabs for console
R_GETLN	.equ	$FAA4	; get line, returning with X pointing to M_BUF-1
R_SETPX	.equ	$FB44	; write pixel character to X
R_CLRPX	.equ	$FB59	; clear pixel character in X
R_MSKPX	.equ	$FB7C	; get pixel screen location X and mask in R_PMSK
R_CLSN	.equ	$FBC4	; clear screen with color code in ACCB
R_CLS	.equ	$FBD4	; clear screen with space character
R_SOUND	.equ	$FFAB	; play sound with pitch in ACCA and duration in ACCB
R_MCXID	.equ	$FFDA	; ID location for MCX BASIC

; direct page registers
	.org	$80
strtcnt	.block	1
strbuf	.block	2
strend	.block	2
strfree	.block	2
strstop	.block	2
dataptr	.block	2
inptptr	.block	2
redoptr	.block	2
letptr	.block	2
	.org	$a3
r1	.block	5
r2	.block	5
rend
rvseed	.block	2
tmp1	.block	2
tmp2	.block	2
tmp3	.block	2
tmp4	.block	2
tmp5	.block	2
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_100

	; CLS

	jsr	cls

	; PRINT "PLEASE WAIT..."

	jsr	pr_ss
	.text	15, "PLEASE WAIT...\r"

LINE_110

	; DIM A(29,63),X,Y,XL,XP,YL,YP,NO,HX,LX,HY,LY,WN,ZE,MX,MY,N1,T2,T3,GN,PA

	ldab	#29
	jsr	ld_ir1_pb

	ldab	#63
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrdim2_ir1_ix

LINE_115

	; DIM L(1,8),NY,NX,P2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#INTARR_L
	jsr	arrdim2_ir1_ix

LINE_120

	; GOTO 500

	ldx	#LINE_500
	jsr	goto_ix

LINE_124

	; A(Y,X)=WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_126

	; A(Y,X)=ZE

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_128

	; SET(X,Y,WN)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_WN
	jsr	setc_ir1_ir2_ix

	; RETURN

	jsr	return

LINE_150

	; XL=X-WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_fr1

	; IF XL=N1 THEN

	ldx	#FLTVAR_XL
	jsr	ld_fr1_fx

	ldx	#INTVAR_N1
	jsr	ldeq_ir1_fr1_ix

	ldx	#LINE_160
	jsr	jmpeq_ir1_ix

	; XL=HX

	ldx	#INTVAR_HX
	jsr	ld_ir1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_ir1

LINE_160

	; XP=X+WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_fr1

	; IF XP=MX THEN

	ldx	#FLTVAR_XP
	jsr	ld_fr1_fx

	ldx	#INTVAR_MX
	jsr	ldeq_ir1_fr1_ix

	ldx	#LINE_170
	jsr	jmpeq_ir1_ix

	; XP=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_ir1

LINE_170

	; YL=Y-WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_fr1

	; IF YL=N1 THEN

	ldx	#FLTVAR_YL
	jsr	ld_fr1_fx

	ldx	#INTVAR_N1
	jsr	ldeq_ir1_fr1_ix

	ldx	#LINE_180
	jsr	jmpeq_ir1_ix

	; YL=HY

	ldx	#INTVAR_HY
	jsr	ld_ir1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_ir1

LINE_180

	; YP=Y+WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_fr1

	; IF YP=MY THEN

	ldx	#FLTVAR_YP
	jsr	ld_fr1_fx

	ldx	#INTVAR_MY
	jsr	ldeq_ir1_fr1_ix

	ldx	#LINE_190
	jsr	jmpeq_ir1_ix

	; YP=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_ir1

LINE_190

	; NO=POINT(XL,YL)+POINT(X,YL)+POINT(XP,YL)+POINT(XL,Y)+POINT(XP,Y)+POINT(XL,YP)+POINT(X,YP)+POINT(XP,YP)

	ldx	#FLTVAR_XL
	jsr	ld_ir1_ix

	ldx	#FLTVAR_YL
	jsr	point_ir1_ir1_ix

	ldx	#FLTVAR_X
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YL
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XP
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YL
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XL
	jsr	ld_ir2_ix

	ldx	#FLTVAR_Y
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XP
	jsr	ld_ir2_ix

	ldx	#FLTVAR_Y
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XL
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YP
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_X
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YP
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XP
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YP
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_NO
	jsr	ld_ix_ir1

LINE_200

	; ON L(POINT(X,Y),NO) GOSUB 124,126

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	point_ir1_ir1_ix

	ldx	#INTVAR_NO
	jsr	ld_ir2_ix

	ldx	#INTARR_L
	jsr	arrval2_ir1_ix

	jsr	ongosub_ir1_is
	.byte	2
	.word	LINE_124, LINE_126

LINE_210

	; RETURN

	jsr	return

LINE_230

	; I$="GENERATION: 0              À"

	jsr	ld_sr1_ss
	.text	28, "GENERATION: 0              \xC0"

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; PRINT @P2, I$;

	ldx	#INTVAR_P2
	jsr	prat_ix

	ldx	#STRVAR_I
	jsr	pr_sx

LINE_240

	; X=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	ld_fx_ir1

	; XL=HX

	ldx	#INTVAR_HX
	jsr	ld_ir1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_ir1

	; XP=X+WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_fr1

	; FOR Y=WN TO NY

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	for_fx_ir1

	ldx	#INTVAR_NY
	jsr	to_fp_ix

	; YL=Y-WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_fr1

	; YP=Y+WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_fr1

	; GOSUB 190

	ldx	#LINE_190
	jsr	gosub_ix

	; NEXT Y

	ldx	#FLTVAR_Y
	jsr	nextvar_fx

	jsr	next

LINE_250

	; X=HX

	ldx	#INTVAR_HX
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	ld_fx_ir1

	; XL=X-WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_fr1

	; XP=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_ir1

	; FOR Y=WN TO NY

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	for_fx_ir1

	ldx	#INTVAR_NY
	jsr	to_fp_ix

	; YL=Y-WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_fr1

	; YP=Y+WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_fr1

	; GOSUB 190

	ldx	#LINE_190
	jsr	gosub_ix

	; NEXT Y

	ldx	#FLTVAR_Y
	jsr	nextvar_fx

	jsr	next

LINE_260

	; Y=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_fx_ir1

	; YL=HY

	ldx	#INTVAR_HY
	jsr	ld_ir1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_ir1

	; YP=Y+WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_fr1

	; FOR X=WN TO NX

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	for_fx_ir1

	ldx	#INTVAR_NX
	jsr	to_fp_ix

	; XL=X-WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_fr1

	; XP=X+WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_fr1

	; GOSUB 190

	ldx	#LINE_190
	jsr	gosub_ix

	; NEXT X

	ldx	#FLTVAR_X
	jsr	nextvar_fx

	jsr	next

LINE_270

	; Y=HY

	ldx	#INTVAR_HY
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_fx_ir1

	; YL=Y-WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_fr1

	; YP=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_ir1

	; FOR X=WN TO NX

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	for_fx_ir1

	ldx	#INTVAR_NX
	jsr	to_fp_ix

	; XL=X-WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_fr1

	; XP=X+WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_fr1

	; GOSUB 190

	ldx	#LINE_190
	jsr	gosub_ix

	; NEXT X

	ldx	#FLTVAR_X
	jsr	nextvar_fx

	jsr	next

LINE_280

	; X=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	ld_fx_ir1

	; Y=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_fx_ir1

	; GOSUB 150

	ldx	#LINE_150
	jsr	gosub_ix

	; Y=HY

	ldx	#INTVAR_HY
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_fx_ir1

	; GOSUB 150

	ldx	#LINE_150
	jsr	gosub_ix

	; X=HX

	ldx	#INTVAR_HX
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	ld_fx_ir1

	; GOSUB 150

	ldx	#LINE_150
	jsr	gosub_ix

	; Y=ZE

	ldx	#INTVAR_ZE
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_fx_ir1

	; GOSUB 150

	ldx	#LINE_150
	jsr	gosub_ix

LINE_290

	; FOR Y=WN TO NY

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	for_fx_ir1

	ldx	#INTVAR_NY
	jsr	to_fp_ix

	; FOR X=WN TO NX

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	for_fx_ir1

	ldx	#INTVAR_NX
	jsr	to_fp_ix

	; XL=X-WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_XL
	jsr	ld_fx_fr1

	; XP=X+WN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_XP
	jsr	ld_fx_fr1

	; YL=Y-WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	sub_fr1_fr1_ix

	ldx	#FLTVAR_YL
	jsr	ld_fx_fr1

	; YP=Y+WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_WN
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_YP
	jsr	ld_fx_fr1

LINE_300

	; NO=POINT(XL,YL)+POINT(X,YL)+POINT(XP,YL)+POINT(XL,Y)+POINT(XP,Y)+POINT(XL,YP)+POINT(X,YP)+POINT(XP,YP)

	ldx	#FLTVAR_XL
	jsr	ld_ir1_ix

	ldx	#FLTVAR_YL
	jsr	point_ir1_ir1_ix

	ldx	#FLTVAR_X
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YL
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XP
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YL
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XL
	jsr	ld_ir2_ix

	ldx	#FLTVAR_Y
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XP
	jsr	ld_ir2_ix

	ldx	#FLTVAR_Y
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XL
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YP
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_X
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YP
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#FLTVAR_XP
	jsr	ld_ir2_ix

	ldx	#FLTVAR_YP
	jsr	point_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_NO
	jsr	ld_ix_ir1

LINE_320

	; ON L(POINT(X,Y),NO) GOSUB 124,126

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	point_ir1_ir1_ix

	ldx	#INTVAR_NO
	jsr	ld_ir2_ix

	ldx	#INTARR_L
	jsr	arrval2_ir1_ix

	jsr	ongosub_ir1_is
	.byte	2
	.word	LINE_124, LINE_126

LINE_410

	; NEXT X

	ldx	#FLTVAR_X
	jsr	nextvar_fx

	jsr	next

	; POKE PA+Y,PEEK(PA+Y)-MX

	ldx	#INTVAR_PA
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	add_fr1_ir1_fx

	ldx	#INTVAR_PA
	jsr	ld_ir2_ix

	ldx	#FLTVAR_Y
	jsr	add_fr2_ir2_fx

	jsr	peek_ir2_ir2

	ldx	#INTVAR_MX
	jsr	sub_ir2_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT Y

	ldx	#FLTVAR_Y
	jsr	nextvar_fx

	jsr	next

LINE_420

	; CLS ZE

	ldx	#INTVAR_ZE
	jsr	clsn_ix

	; PRINT @P2, I$;

	ldx	#INTVAR_P2
	jsr	prat_ix

	ldx	#STRVAR_I
	jsr	pr_sx

	; PRINT @P2, "GENERATION:";STR$(GN);" ";

	ldx	#INTVAR_P2
	jsr	prat_ix

	jsr	pr_ss
	.text	11, "GENERATION:"

	ldx	#INTVAR_GN
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; GN+=WN

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	ldx	#INTVAR_GN
	jsr	add_ix_ix_ir1

LINE_430

	; FOR Y=LY TO HY

	ldx	#INTVAR_LY
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	for_fx_ir1

	ldx	#INTVAR_HY
	jsr	to_fp_ix

	; FOR X=LX TO HX

	ldx	#INTVAR_LX
	jsr	ld_ir1_ix

	ldx	#FLTVAR_X
	jsr	for_fx_ir1

	ldx	#INTVAR_HX
	jsr	to_fp_ix

LINE_440

	; ON A(Y,X) GOSUB 128

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	jsr	ongosub_ir1_is
	.byte	1
	.word	LINE_128

LINE_450

	; NEXT X,Y

	ldx	#FLTVAR_X
	jsr	nextvar_fx

	jsr	next

	ldx	#FLTVAR_Y
	jsr	nextvar_fx

	jsr	next

	; GOTO 240

	ldx	#LINE_240
	jsr	goto_ix

LINE_500

	; HX=63

	ldx	#INTVAR_HX
	ldab	#63
	jsr	ld_ix_pb

	; LX=0

	ldx	#INTVAR_LX
	ldab	#0
	jsr	ld_ix_pb

	; HY=29

	ldx	#INTVAR_HY
	ldab	#29
	jsr	ld_ix_pb

	; LY=0

	ldx	#INTVAR_LY
	ldab	#0
	jsr	ld_ix_pb

	; WN=1

	ldx	#INTVAR_WN
	ldab	#1
	jsr	ld_ix_pb

	; N1=-1

	ldx	#INTVAR_N1
	ldab	#-1
	jsr	ld_ix_nb

	; ZE=0

	ldx	#INTVAR_ZE
	ldab	#0
	jsr	ld_ix_pb

	; MX=64

	ldx	#INTVAR_MX
	ldab	#64
	jsr	ld_ix_pb

	; MY=30

	ldx	#INTVAR_MY
	ldab	#30
	jsr	ld_ix_pb

LINE_505

	; NY=28

	ldx	#INTVAR_NY
	ldab	#28
	jsr	ld_ix_pb

	; NX=62

	ldx	#INTVAR_NX
	ldab	#62
	jsr	ld_ix_pb

LINE_510

	; T2=2

	ldx	#INTVAR_T2
	ldab	#2
	jsr	ld_ix_pb

	; T3=3

	ldx	#INTVAR_T3
	ldab	#3
	jsr	ld_ix_pb

	; GN=1

	ldx	#INTVAR_GN
	ldab	#1
	jsr	ld_ix_pb

	; PA=16863

	ldx	#INTVAR_PA
	ldd	#16863
	jsr	ld_ix_pw

	; P2=480

	ldx	#INTVAR_P2
	ldd	#480
	jsr	ld_ix_pw

LINE_520

	; FOR X=0 TO 1

	ldx	#FLTVAR_X
	ldab	#0
	jsr	for_fx_pb

	ldab	#1
	jsr	to_fp_pb

	; FOR Y=0 TO 8

	ldx	#FLTVAR_Y
	ldab	#0
	jsr	for_fx_pb

	ldab	#8
	jsr	to_fp_pb

	; READ NO

	ldx	#INTVAR_NO
	jsr	read_ix

	; L(X,Y)=NO

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldx	#INTARR_L
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_NO
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_525

	; NEXT Y,X

	ldx	#FLTVAR_Y
	jsr	nextvar_fx

	jsr	next

	ldx	#FLTVAR_X
	jsr	nextvar_fx

	jsr	next

LINE_530

	; CLS

	jsr	cls

	; PRINT TAB(6);"JOHN CONWAY'S LIFE"

	ldab	#6
	jsr	prtab_pb

	jsr	pr_ss
	.text	19, "JOHN CONWAY'S LIFE\r"

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "RUN THE R PENTOMINO (Y/N)?"

	jsr	pr_ss
	.text	27, "RUN THE R PENTOMINO (Y/N)?\r"

LINE_540

	; I$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; WHEN I$="" GOTO 540

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_540
	jsr	jmpne_ir1_ix

LINE_550

	; IF I$="Y" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_560
	jsr	jmpeq_ir1_ix

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; FOR NO=1 TO 5

	ldx	#INTVAR_NO
	ldab	#1
	jsr	for_ix_pb

	ldab	#5
	jsr	to_ip_pb

	; READ X,Y

	ldx	#FLTVAR_X
	jsr	read_fx

	ldx	#FLTVAR_Y
	jsr	read_fx

	; SET(X,Y,WN)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_WN
	jsr	setc_ir1_ir2_ix

	; A(Y,X)=WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT NO

	ldx	#INTVAR_NO
	jsr	nextvar_ix

	jsr	next

	; GOTO 230

	ldx	#LINE_230
	jsr	goto_ix

LINE_560

	; WHEN I$<>"N" GOTO 540

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldne_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_540
	jsr	jmpne_ir1_ix

LINE_565

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "RUN THE GLIDER (Y/N)?"

	jsr	pr_ss
	.text	22, "RUN THE GLIDER (Y/N)?\r"

LINE_570

	; I$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; WHEN I$="" GOTO 570

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_570
	jsr	jmpne_ir1_ix

LINE_575

	; IF I$="Y" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_580
	jsr	jmpeq_ir1_ix

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; FOR NO=1 TO 5

	ldx	#INTVAR_NO
	ldab	#1
	jsr	for_ix_pb

	ldab	#5
	jsr	to_ip_pb

	; READ X,Y

	ldx	#FLTVAR_X
	jsr	read_fx

	ldx	#FLTVAR_Y
	jsr	read_fx

	; NEXT NO

	ldx	#INTVAR_NO
	jsr	nextvar_ix

	jsr	next

	; FOR NO=1 TO 5

	ldx	#INTVAR_NO
	ldab	#1
	jsr	for_ix_pb

	ldab	#5
	jsr	to_ip_pb

	; READ X,Y

	ldx	#FLTVAR_X
	jsr	read_fx

	ldx	#FLTVAR_Y
	jsr	read_fx

	; SET(X,Y,WN)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_WN
	jsr	setc_ir1_ir2_ix

	; A(Y,X)=WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT NO

	ldx	#INTVAR_NO
	jsr	nextvar_ix

	jsr	next

	; GOTO 230

	ldx	#LINE_230
	jsr	goto_ix

LINE_580

	; WHEN I$="N" GOTO 600

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_600
	jsr	jmpne_ir1_ix

LINE_585

	; GOTO 570

	ldx	#LINE_570
	jsr	goto_ix

LINE_587

LINE_588

LINE_590

LINE_600

	; CLS 0

	ldab	#0
	jsr	clsn_pb

LINE_610

	; PRINT @448, "";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	0, ""

LINE_620

	; INPUT "X,Y:"; X,Y

	jsr	pr_ss
	.text	4, "X,Y:"

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

LINE_630

	; IF X=-1 THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	ldeq_ir1_fr1_nb

	ldx	#LINE_640
	jsr	jmpeq_ir1_ix

	; PRINT @448, "";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	0, ""

	; FOR X=1 TO 32

	ldx	#FLTVAR_X
	ldab	#1
	jsr	for_fx_pb

	ldab	#32
	jsr	to_fp_pb

	; PRINT "€";

	jsr	pr_ss
	.text	1, "\x80"

	; NEXT X

	ldx	#FLTVAR_X
	jsr	nextvar_fx

	jsr	next

	; GOTO 230

	ldx	#LINE_230
	jsr	goto_ix

LINE_640

	; SET(X,Y,WN)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_WN
	jsr	setc_ir1_ir2_ix

	; A(Y,X)=WN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_WN
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_650

	; PRINT @452, "       ";

	ldd	#452
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "       "

LINE_660

	; GOTO 610

	ldx	#LINE_610
	jsr	goto_ix

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

	.module	mdgetne
getne
	bne	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdinput
inputqqs
	jsr	R_QUEST
inputqs
	jsr	R_QUEST
	jsr	R_SPACE
	jsr	R_GETLN
	ldaa	#','
	staa	,x
_done
	stx	inptptr
	rts
rdinit
	ldx	inptptr
	ldaa	,x
	inx
	cmpa	#','
	beq	_skpspc
	jsr	inputqqs
	bra	rdinit
_skpspc
	ldaa	,x
	cmpa	#' '
	bne	_done
	inx
	bra	_skpspc
rdredo
	ldx	inptptr
	bsr	_skpspc
	tsta
	beq	_rts
	cmpa	#','
	beq	_rts
	ldx	#R_REDO
	ldab	#6
	jsr	print
	ldx	redoptr
_rts
	rts

	.module	mdmul12
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

	.module	mdpoint
; get pixel color
; ENTRY: ACCA holds X, ACCB holds Y
; EXIT: ACCD holds color
point
	jsr	getxym
	ldab	,x
	bpl	_text
	clra
	bitb	M_PMSK
	beq	_unset
	andb	#$70
	lsrb
	lsrb
	lsrb
	lsrb
	incb
	rts
_text
	ldd	#-1
	rts
_unset
	tab
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

	.module	mdprtab
prtab
	jsr	R_MKTAB
	subb	DP_LPOS
	bls	_rts
_again
	jsr	R_SPACE
	decb
	bne	_again
_rts
	rts

	.module	mdref2
; get offset from 2D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref2
	ldd	2,x
	std	tmp1
	subd	0+argv
	bls	_err
	ldd	2+argv
	std	tmp2
	subd	4,x
	bhs	_err
	jsr	mul12
	addd	0+argv
	std	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

	.module	mdrefint
; return int/str array reference in D/tmp1
refint
	addd	tmp1
	addd	0,x
	std	tmp1
	rts

	.module	mdrpubyte
; read DATA when records are purely unsigned bytes
; EXIT:  int in tmp1+1 and tmp2
rpubyte
	pshx
	ldx	dataptr
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldaa	,x
	inx
	stx	dataptr
	staa	tmp2+1
	ldd	#0
	std	tmp1+1
	std	tmp3
	pulx
	rts

	.module	mdset
; set pixel with existing color
; ENTRY: ACCA holds X, ACCB holds Y
set
	bsr	getxym
	ldab	,x
	bmi	doset
	clrb
doset
	andb	#$70
	ldaa	$82
	psha
	stab	$82
	jsr	R_SETPX
	pula
	staa	$82
	rts
getxym
	anda	#$1f
	andb	#$3f
	pshb
	tab
	jmp	R_MSKPX

	.module	mdsetc
; set pixel with color
; ENTRY: X holds byte-to-modify, ACCB holds color
setc
	decb
	bmi	_loadc
	lslb
	lslb
	lslb
	lslb
	bra	_ok
_loadc
	ldab	,x
	bmi	_ok
	clrb
_ok
	bra	doset

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
	ldaa	tmp1+1
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
_dec
	suba	#5
	bhs	_dec
	adda	#5
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
	pshb
	ldd	tmp2
	psha
	ldaa	#$CC
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
	ldaa	#$CC
	mul
	stab	tmp3+1
	addd	tmp1+1
	std	tmp1+1
	pulb
	ldaa	#$CC
	mul
	addb	tmp1+1
	addb	tmp3+1
	stab	tmp1+1
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

	.module	mdstrprm
; make a permanent string
; ENTRY: argv -  input string descriptor
;          X  - output string descriptor
strprm
	stx	tmp1
	ldab	0+argv
	beq	_null
	decb
	beq	_char
	ldx	1+argv
	cpx	#M_LBUF
	blo	_const
	cpx	#M_MSTR
	blo	_trans
	cpx	strbuf
	blo	_const
_trans
	ldx	tmp1
	ldab	0,x
	ldx	1,x
	cpx	strbuf
	blo	_nalloc
	cmpb	0+argv
	beq	_copyip
_nalloc
	cpx	1+argv
	bhs	_notmp
	ldx	1+argv
	cpx	strend
	bhs	_notmp
	ldx	strend
	inx
	inx
	stx	strfree
	bsr	_copy
	ldd	strfree
	std	1+argv
_notmp
	ldx	tmp1
	pshx
	jsr	strdel
	pulx
	stx	tmp1
	ldx	strend
	ldd	tmp1
	std	,x
	inx
	inx
	stx	strfree
	cpx	argv+1
	beq	_nocopy
	bsr	_copy
	bra	_ready
_nocopy
	ldab	0+argv
	abx
_ready
	stx	strend
	ldd	strfree
	inx
	inx
	stx	strfree
	clr	strtcnt
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts
_char
	ldaa	#1
	ldx	1+argv
	ldab	,x
_null
	ldaa	#1
	std	1+argv
_const
	ldx	tmp1
	pshx
	jsr	strdel
	pulx
	ldab	0+argv
	stab	0,x
	ldd	1+argv
	std	1,x
	clr	strtcnt
	rts
_copyip
	dex
	dex
	ldd	tmp1
	std	,x
	inx
	inx
_copy
	sts	tmp2
	ldab	0+argv
	lds	1+argv
	des
_nxtchr
	pula
	staa	,x
	inx
	decb
	bne	_nxtchr
	lds	tmp2
	clr	strtcnt
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

	.module	mdtonat
; push for-loop record on stack
; ENTRY:  ACCB  contains size of record
;         r1    contains stopping variable
;               and is always fixedpoint.
;         r1+3  must contain zero if an integer.
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

add_fr1_fr1_ix			; numCalls = 10
	.module	modadd_fr1_fr1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_ir1_fx			; numCalls = 1
	.module	modadd_fr1_ir1_fx
	ldd	3,x
	std	r1+3
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr2_ir2_fx			; numCalls = 1
	.module	modadd_fr2_ir2_fx
	ldd	3,x
	std	r2+3
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ir1_ir1_ir2			; numCalls = 14
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ix_ix_ir1			; numCalls = 1
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

arrdim2_ir1_ix			; numCalls = 2
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

arrref2_ir1_ix			; numCalls = 6
	.module	modarrref2_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval2_ir1_ix			; numCalls = 3
	.module	modarrval2_ir1_ix
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
	stx	dataptr
	rts

cls			; numCalls = 2
	.module	modcls
	jmp	R_CLS

clsn_ix			; numCalls = 1
	.module	modclsn_ix
	ldd	0,x
	bne	_fcerror
	ldab	2,x
	jmp	R_CLSN
_fcerror
	ldab	#FC_ERROR
	jmp	error

clsn_pb			; numCalls = 3
	.module	modclsn_pb
	jmp	R_CLSN

for_fx_ir1			; numCalls = 8
	.module	modfor_fx_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	ldd	#0
	std	3,x
	rts

for_fx_pb			; numCalls = 3
	.module	modfor_fx_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
	rts

for_ix_pb			; numCalls = 3
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 8
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 7
	.module	modgoto_ix
	ins
	ins
	jmp	,x

ignxtra			; numCalls = 1
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inkey_sr1			; numCalls = 2
	.module	modinkey_sr1
	ldd	#$0101
	std	r1
	ldaa	M_IKEY
	bne	_gotkey
	jsr	R_KEYIN
_gotkey
	clr	M_IKEY
	staa	r1+2
	bne	_rts
	staa	r1
_rts
	rts

input			; numCalls = 1
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

jmpeq_ir1_ix			; numCalls = 7
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

jmpne_ir1_ix			; numCalls = 4
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

ld_fr1_fx			; numCalls = 32
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 7
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 20
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 17
	.module	modld_fx_ir1
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_ir1			; numCalls = 6
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 41
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 2
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 21
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 2
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 2
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 1
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 13
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 2
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sr1_ss			; numCalls = 1
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 6
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 3
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_fr1_ix			; numCalls = 4
	.module	modldeq_ir1_fr1_ix
	ldd	r1+3
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

ldeq_ir1_fr1_nb			; numCalls = 1
	.module	modldeq_ir1_fr1_nb
	cmpb	r1+2
	bne	_done
	ldd	r1+3
	bne	_done
	ldd	r1
	subd	#-1
	bne	_done
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 5
	.module	modldeq_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqs
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldne_ir1_sr1_ss			; numCalls = 1
	.module	modldne_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqs
	jsr	getne
	std	r1+1
	stab	r1
	rts

next			; numCalls = 14
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
	ldd	9,x
	std	r1+1
	ldab	8,x
	stab	r1
	ldx	1,x
	ldd	r1+1
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
	blt	_idone
	ldx	3,x
	jmp	,x
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_idone
	ldx	3,x
	jmp	,x
_idone
	ldab	#11
	bra	_done
_flt
	ldd	13,x
	std	r1+3
	ldd	11,x
	std	r1+1
	ldab	10,x
	stab	r1
	ldx	1,x
	ldd	r1+3
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
	blt	_fdone
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
	blt	_fdone
	ldx	3,x
	jmp	,x
_fdone
	ldab	#15
_done
	abx
	txs
	ldx	tmp1
	jmp	,x

nextvar_fx			; numCalls = 11
	.module	modnextvar_fx
	stx	letptr
	pulx
	stx	tmp1
	tsx
	clrb
_nxtvar
	abx
	ldd	1,x
	subd	letptr
	beq	_ok
	ldab	,x
	cmpb	#3
	bhi	_nxtvar
_ok
	txs
	ldx	tmp1
	jmp	,x

nextvar_ix			; numCalls = 3
	.module	modnextvar_ix
	stx	letptr
	pulx
	stx	tmp1
	tsx
	clrb
_nxtvar
	abx
	ldd	1,x
	subd	letptr
	beq	_ok
	ldab	,x
	cmpb	#3
	bhi	_nxtvar
_ok
	txs
	ldx	tmp1
	jmp	,x

ongosub_ir1_is			; numCalls = 3
	.module	modongosub_ir1_is
	pulx
	ldd	r1
	bne	_fail
	ldab	r1+2
	decb
	cmpb	0,x
	bhs	_fail
	stx	tmp1
	stab	tmp2
	ldab	,x
	abx
	abx
	inx
	pshx
	ldaa	#3
	psha
	ldx	tmp1
	ldab	tmp2
	abx
	abx
	ldx	1,x
	jmp	,x
_fail
	ldab	,x
	abx
	abx
	jmp	1,x

peek_ir2_ir2			; numCalls = 1
	.module	modpeek_ir2_ir2
	ldx	r2+1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

point_ir1_ir1_ix			; numCalls = 4
	.module	modpoint_ir1_ir1_ix
	ldaa	2,x
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

point_ir2_ir2_ix			; numCalls = 14
	.module	modpoint_ir2_ir2_ix
	ldaa	2,x
	ldab	r2+2
	jsr	point
	stab	r2+2
	tab
	std	r2
	rts

poke_ir1_ir2			; numCalls = 1
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

pr_sr1			; numCalls = 1
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 13
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 2
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jsr	print
_rts
	rts

prat_ix			; numCalls = 3
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pw			; numCalls = 3
	.module	modprat_pw
	jmp	prat

progbegin			; numCalls = 1
	.module	modprogbegin
	ldx	R_MCXID
	cpx	#'h'*256+'C'
	bne	_mcbasic
	pulx
	clrb
	pshb
	pshb
	pshb
	stab	strtcnt
	jmp	,x
_reqmsg	.text	"?MICROCOLOR BASIC ROM REQUIRED"
_mcbasic
	ldx	#_reqmsg
	ldab	#30
	jsr	print
	pulx
	rts

progend			; numCalls = 1
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jmp	prtab

read_fx			; numCalls = 6
	.module	modread_fx
	jsr	rpubyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts

read_ix			; numCalls = 1
	.module	modread_ix
	jsr	rpubyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

readbuf_fx			; numCalls = 2
	.module	modreadbuf_fx
	stx	letptr
	jsr	rdinit
	ldab	#128
	jsr	inptval
	stx	inptptr
	ldaa	,x
	ldx	letptr
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	jsr	rdredo
	beq	_rts
	pulx
	jmp	,x
_rts
	rts

return			; numCalls = 4
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

setc_ir1_ir2_ix			; numCalls = 4
	.module	modsetc_ir1_ir2_ix
	ldab	2,x
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

str_sr1_ix			; numCalls = 1
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

sub_fr1_fr1_ix			; numCalls = 10
	.module	modsub_fr1_fr1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir2_ir2_ix			; numCalls = 1
	.module	modsub_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

to_fp_ix			; numCalls = 8
	.module	modto_fp_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#15
	jmp	to

to_fp_pb			; numCalls = 3
	.module	modto_fp_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_pb			; numCalls = 3
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
	.byte	0, 0, 0, 1, 0, 0
	.byte	0, 0, 0, 2, 2, 0
	.byte	0, 2, 2, 2, 2, 2
	.byte	31, 10, 32, 10, 31, 11
	.byte	30, 11, 31, 12, 32, 25
	.byte	33, 26, 33, 27, 32, 27
	.byte	31, 27
enddata

symstart

; block started by symbol
bss

; Numeric Variables
INTVAR_GN	.block	3
INTVAR_HX	.block	3
INTVAR_HY	.block	3
INTVAR_LX	.block	3
INTVAR_LY	.block	3
INTVAR_MX	.block	3
INTVAR_MY	.block	3
INTVAR_N1	.block	3
INTVAR_NO	.block	3
INTVAR_NX	.block	3
INTVAR_NY	.block	3
INTVAR_P2	.block	3
INTVAR_PA	.block	3
INTVAR_T2	.block	3
INTVAR_T3	.block	3
INTVAR_WN	.block	3
INTVAR_ZE	.block	3
FLTVAR_X	.block	5
FLTVAR_XL	.block	5
FLTVAR_XP	.block	5
FLTVAR_Y	.block	5
FLTVAR_YL	.block	5
FLTVAR_YP	.block	5
; String Variables
STRVAR_I	.block	3
; Numeric Arrays
INTARR_A	.block	6	; dims=2
INTARR_L	.block	6	; dims=2
; String Arrays

; block ended by symbol
bes
	.end

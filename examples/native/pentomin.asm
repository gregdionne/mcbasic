; Assembly for pentomin.bas
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

	; PRINT TAB(11);"PENTOMINOS"

	ldab	#11
	jsr	prtab_pb

	jsr	pr_ss
	.text	11, "PENTOMINOS\r"

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_110

LINE_120

LINE_130

LINE_140

LINE_150

LINE_160

LINE_170

LINE_180

LINE_190

LINE_200

LINE_210

LINE_220

LINE_230

LINE_240

LINE_250

LINE_260

LINE_270

LINE_280

LINE_290

LINE_300

LINE_310

LINE_320

LINE_330

LINE_340

LINE_350

LINE_360

LINE_370

LINE_380

LINE_390

LINE_400

LINE_410

LINE_420

LINE_430

LINE_440

LINE_450

LINE_460

LINE_470

LINE_480

LINE_490

LINE_500

LINE_510

LINE_520

LINE_530

LINE_540

LINE_550

LINE_560

LINE_570

LINE_580

LINE_590

LINE_600

LINE_610

LINE_620

LINE_630

LINE_640

LINE_650

LINE_660

LINE_670

LINE_680

LINE_690

LINE_700

LINE_710

LINE_720

LINE_730

LINE_740

LINE_750

LINE_760

LINE_770

LINE_780

LINE_790

LINE_800

LINE_810

LINE_820

LINE_830

LINE_840

LINE_850

LINE_860

LINE_1000

	; DIM X(63,4),Y(63,4),P(64),P$(13),S(13),T(13),B(6,20)

	ldab	#63
	jsr	ld_ir1_pb

	ldab	#4
	jsr	ld_ir2_pb

	ldx	#INTARR_X
	jsr	arrdim2_ir1_ix

	ldab	#63
	jsr	ld_ir1_pb

	ldab	#4
	jsr	ld_ir2_pb

	ldx	#INTARR_Y
	jsr	arrdim2_ir1_ix

	ldab	#64
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrdim1_ir1_ix

	ldab	#13
	jsr	ld_ir1_pb

	ldx	#STRARR_P
	jsr	arrdim1_ir1_sx

	ldab	#13
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrdim1_ir1_ix

	ldab	#13
	jsr	ld_ir1_pb

	ldx	#INTARR_T
	jsr	arrdim1_ir1_ix

	ldab	#6
	jsr	ld_ir1_pb

	ldab	#20
	jsr	ld_ir2_pb

	ldx	#INTARR_B
	jsr	arrdim2_ir1_ix

LINE_1001

	; DIM X1(5),Y1(5),X2(12),Y2(12),U(12)

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_X1
	jsr	arrdim1_ir1_ix

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_Y1
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_X2
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_Y2
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_U
	jsr	arrdim1_ir1_ix

LINE_1010

	; READ P$,N

	ldx	#STRVAR_P
	jsr	read_sx

	ldx	#INTVAR_N
	jsr	read_ix

	; WHEN N=0 GOTO 1070

	ldx	#INTVAR_N
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1070
	jsr	jmpne_ir1_ix

LINE_1020

	; T+=1

	ldx	#INTVAR_T
	ldab	#1
	jsr	add_ix_ix_pb

	; P$(T)=P$

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_P
	jsr	arrref1_ir1_sx

	ldx	#STRVAR_P
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

	; S(T)=V+1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

LINE_1030

	; FOR J=V+1 TO V+N

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	for_ix_ir1

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_N
	jsr	add_ir1_ir1_ix

	jsr	to_ip_ir1

	; P(J)=T

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_P
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_1040

	; FOR K=0 TO 3

	ldx	#INTVAR_K
	ldab	#0
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; READ X(J,K),Y(J,K)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_K
	jsr	ld_ir2_ix

	ldx	#INTARR_X
	jsr	arrref2_ir1_ix

	jsr	read_ip

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_K
	jsr	ld_ir2_ix

	ldx	#INTARR_Y
	jsr	arrref2_ir1_ix

	jsr	read_ip

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_1050

	; V+=N

	ldx	#INTVAR_N
	jsr	ld_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ix_ix_ir1

	; PRINT P$;

	ldx	#STRVAR_P
	jsr	pr_sx

LINE_1060

	; GOTO 1010

	ldx	#LINE_1010
	jsr	goto_ix

LINE_1070

	; PRINT @64, "CHOOSE:"

	ldab	#64
	jsr	prat_pb

	jsr	pr_ss
	.text	8, "CHOOSE:\r"

LINE_1080

	; FOR J=3 TO 6

	ldx	#INTVAR_J
	ldab	#3
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

	; PRINT STR$(J);"  BY";STR$(60/J);" "

	ldx	#INTVAR_J
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	4, "  BY"

	ldab	#60
	jsr	ld_ir1_pb

	ldx	#INTVAR_J
	jsr	div_fr1_ir1_ix

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

LINE_1090

	; INPUT "SELECT 3 THRU 6"; W1

	jsr	pr_ss
	.text	15, "SELECT 3 THRU 6"

	jsr	input

	ldx	#FLTVAR_W1
	jsr	readbuf_fx

	jsr	ignxtra

LINE_1100

	; WHEN (W1<3) OR (W1>6) OR (W1<>INT(W1)) GOTO 1070

	ldx	#FLTVAR_W1
	jsr	ld_fr1_fx

	ldab	#3
	jsr	ldlt_ir1_fr1_pb

	ldab	#6
	jsr	ld_ir2_pb

	ldx	#FLTVAR_W1
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_W1
	jsr	ld_fr2_fx

	ldx	#FLTVAR_W1
	jsr	ldne_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_1070
	jsr	jmpne_ir1_ix

LINE_1110

	; W2=60/W1

	ldab	#60
	jsr	ld_ir1_pb

	ldx	#FLTVAR_W1
	jsr	div_fr1_ir1_fx

	ldx	#FLTVAR_W2
	jsr	ld_fx_fr1

LINE_1120

	; CLS

	jsr	cls

	; FOR X=1 TO W2

	ldx	#INTVAR_X
	ldab	#1
	jsr	for_ix_pb

	ldx	#FLTVAR_W2
	jsr	to_ip_ix

	; FOR Y=1 TO W1

	ldx	#INTVAR_Y
	ldab	#1
	jsr	for_ix_pb

	ldx	#FLTVAR_W1
	jsr	to_ip_ix

	; PRINT @SHIFT(Y+2,5)+X, "ß";

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\xDF"

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_2000

	; REM FIND NEW SPACE TO FILL

LINE_2010

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; P=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; GOSUB 3200

	ldx	#LINE_3200
	jsr	gosub_ix

	; WHEN X1>W2 GOTO 2170

	ldx	#FLTVAR_W2
	jsr	ld_fr1_fx

	ldx	#INTVAR_X1
	jsr	ldlt_ir1_fr1_ix

	ldx	#LINE_2170
	jsr	jmpne_ir1_ix

LINE_2020

	; REM GET A NEW PIECE

LINE_2030

	; T(P)=S(P)

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	jsr	ld_ip_ir1

LINE_2040

	; PRINT @33, P$(P)

	ldab	#33
	jsr	prat_pb

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#STRARR_P
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_2050

	; REM TRY FITTING PIECE

LINE_2060

	; C$=P$(P)

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#STRARR_P
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; X1(0)=X1

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_X1
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y1(0)=Y1

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_Y1
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y1
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; FOR J=1 TO 4

	ldx	#INTVAR_J
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

LINE_2070

	; X=X(T(P),J-1)+X1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	ldx	#INTARR_X
	jsr	arrval2_ir1_ix

	ldx	#INTVAR_X1
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y(T(P),J-1)+Y1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	ldx	#INTARR_Y
	jsr	arrval2_ir1_ix

	ldx	#INTVAR_Y1
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; X1(J)=X

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_X1
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y1(J)=Y

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_Y1
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_2080

	; WHEN (X<1) OR (Y<1) OR (X>W2) OR (Y>W1) GOTO 2260

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_W2
	jsr	ld_fr2_fx

	ldx	#INTVAR_X
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_W1
	jsr	ld_fr2_fx

	ldx	#INTVAR_Y
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_2260
	jsr	jmpne_ir1_ix

LINE_2090

	; WHEN B(Y,X) GOTO 2260

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#LINE_2260
	jsr	jmpne_ir1_ix

LINE_2100

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

LINE_2110

	; REM IT FITS - PUT PIECE IN PLACE

LINE_2120

	; B=P

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; FOR J=0 TO 4

	ldx	#INTVAR_J
	ldab	#0
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

LINE_2130

	; X=X1(J)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_X1
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y1(J)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_Y1
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 3500

	ldx	#LINE_3500
	jsr	gosub_ix

LINE_2140

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

LINE_2150

	; X2(P)=X1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_X2
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y2(P)=Y1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_Y2
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y1
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; P1+=1

	ldx	#INTVAR_P1
	ldab	#1
	jsr	add_ix_ix_pb

	; U(P1)=P

	ldx	#INTVAR_P1
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; GOTO 2010

	ldx	#LINE_2010
	jsr	goto_ix

LINE_2160

	; REM BOARD FILLED

LINE_2170

	; PRINT @385, "SOLUTION"

	ldd	#385
	jsr	prat_pw

	jsr	pr_ss
	.text	9, "SOLUTION\r"

	; END

	jsr	progend

LINE_2180

	; REM UNDRAW LAST ONE

LINE_2190

	; P=U(P1)

	ldx	#INTVAR_P1
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; U(P1)=0

	ldx	#INTVAR_P1
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; P1-=1

	ldx	#INTVAR_P1
	ldab	#1
	jsr	sub_ix_ix_pb

	; IF P1<0 THEN

	ldx	#INTVAR_P1
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_2200
	jsr	jmpeq_ir1_ix

	; PRINT "THAT'S ALL"

	jsr	pr_ss
	.text	11, "THAT'S ALL\r"

	; END

	jsr	progend

LINE_2200

	; B=0

	ldx	#INTVAR_B
	ldab	#0
	jsr	ld_ix_pb

	; X=X2(P)

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_X2
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y2(P)

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_Y2
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; C$="ß"

	jsr	ld_sr1_ss
	.text	1, "\xDF"

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; GOSUB 3500

	ldx	#LINE_3500
	jsr	gosub_ix

LINE_2210

	; X1=X

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_X1
	jsr	ld_ix_ir1

	; Y1=Y

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y1
	jsr	ld_ix_ir1

	; FOR J=1 TO 4

	ldx	#INTVAR_J
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

LINE_2220

	; X=X(T(P),J-1)+X1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	ldx	#INTARR_X
	jsr	arrval2_ir1_ix

	ldx	#INTVAR_X1
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y(T(P),J-1)+Y1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	ldx	#INTARR_Y
	jsr	arrval2_ir1_ix

	ldx	#INTVAR_Y1
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; X1(J)=X

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_X1
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y1(J)=Y

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_Y1
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_2230

	; GOSUB 3500

	ldx	#LINE_3500
	jsr	gosub_ix

LINE_2240

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

LINE_2250

	; REM ROTATE THE PIECE

LINE_2260

	; T(P)+=1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	add_ip_ip_pb

	; WHEN P(T(P))=P GOTO 2060

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#INTARR_P
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_P
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_2060
	jsr	jmpne_ir1_ix

LINE_2270

	; REM GIVE UP ON PIECE

LINE_2280

	; T(P)=0

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

LINE_2290

	; REM LOOK FOR NEW PIECE 

LINE_2300

	; P+=1

	ldx	#INTVAR_P
	ldab	#1
	jsr	add_ix_ix_pb

	; WHEN P>12 GOTO 2190

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_2190
	jsr	jmpne_ir1_ix

LINE_2310

	; WHEN T(P) GOTO 2300

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#LINE_2300
	jsr	jmpne_ir1_ix

LINE_2320

	; GOTO 2030

	ldx	#LINE_2030
	jsr	goto_ix

LINE_3000

	; FOR J=1 TO 12

	ldx	#INTVAR_J
	ldab	#1
	jsr	for_ix_pb

	ldab	#12
	jsr	to_ip_pb

	; IF T(J) THEN

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_T
	jsr	arrval1_ir1_ix

	ldx	#LINE_3010
	jsr	jmpeq_ir1_ix

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

LINE_3010

	; RETURN

	jsr	return

LINE_3200

	; FOR X1=1 TO W2

	ldx	#INTVAR_X1
	ldab	#1
	jsr	for_ix_pb

	ldx	#FLTVAR_W2
	jsr	to_ip_ix

	; FOR Y1=1 TO W1

	ldx	#INTVAR_Y1
	ldab	#1
	jsr	for_ix_pb

	ldx	#FLTVAR_W1
	jsr	to_ip_ix

	; WHEN B(Y1,X1)=0 GOTO 3230

	ldx	#INTVAR_Y1
	jsr	ld_ir1_ix

	ldx	#INTVAR_X1
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_3230
	jsr	jmpne_ir1_ix

LINE_3220

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_3230

	; RETURN

	jsr	return

LINE_3500

	; PRINT @SHIFT(Y+2,5)+X, C$;

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; B(Y,X)=B

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_3510

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

	.module	mddivmod
; divide/modulo X by Y with remainder
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;          #shifts in ACCA (24 for modulus, 40 for division
;   EXIT   ~|X|/|Y| in (5,x 6,x 7,x 8,x 9,x) when dividing
;           |X|%|Y| in (0,x 1,x 2,x 3,x 4,x) when modulo
;          result sign in tmp4.(0 = pos, -1 = neg).
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1
divmod
	staa	tmp1
	clr	tmp4
	tst	0,x
	bpl	_posX
	com	tmp4
	bsr	negx
_posX
	tst	0+argv
	bpl	_posA
	com	tmp4
	bsr	negargv
divufl
_posA
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
	rol	6,x
	rol	5,x
	rol	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
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
	rol	7,x
	dec	tmp1
	bne	_nxtdiv
	rol	6,x
	rol	5,x
	rol	4,x
	rts
negx
	neg	4,x
	ngc	3,x
	ngc	2,x
	ngc	1,x
	ngc	0,x
	rts
negargv
	neg	4+argv
	ngc	3+argv
	ngc	2+argv
	ngc	1+argv
	ngc	0+argv
	rts

	.module	mdgeteq
geteq
	beq	_1
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
	cmpa	','
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
	subd	2,x
	bhi	_err
	ldd	0+argv
	std	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

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

	.module	mdrnstrng
; read numerc DATA when records are pure strings
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
	ldx	dataptr
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
	stx	dataptr
	pulx
	rts

	.module	mdrsstrng
; read string DATA when records are pure strings
; ENTRY: X holds destination string descriptor
; EXIT:  data table read, and perm string created in X
rsstrng
	jsr	strrel
	jsr	rpstrng
	ldab	tmp1+1
	stab	0,X
	ldd	tmp2
	std	1,X
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

	.module	mdstrflt
strflt
	pshx
	tst	tmp1+1
	bmi	_neg
	ldab	' '
	bra	_wdigs
_neg
	neg	tmp3+1
	ngc	tmp3
	ngc	tmp2+1
	ngc	tmp2
	ngc	tmp1+1
	ldab	'-'
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
	rts

	.module	mdstrrel
; release a temporary string
; ENTRY: X holds string start
; EXIT:  X holds new end of string space
strrel
	cpx	strend
	bls	_rts
	cpx	strstop
	bhs	_rts
	stx	strfree
_rts
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
	jsr	divufl
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
	beq	_rts
	neg	tmp3+1
	ngc	tmp3
	ngc	tmp2+1
	ngc	tmp2
	ngc	tmp1+1
_rts
	rts
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
	pulb
	ldaa	tmp4
	inca
	staa	tmp4
	cmpa	#6
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
	.byte	$00,$86,$80
	.byte	$0F,$42,$40

	.module	mdtonat
; push for-loop record on stack
; ENTRY:  ACCB  contains size of record
;         r1    contains stopping variable and is always float.
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

add_ip_ip_pb			; numCalls = 1
	.module	modadd_ip_ip_pb
	ldx	letptr
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

add_ir1_ir1_ix			; numCalls = 7
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 4
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
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

add_ix_ix_pb			; numCalls = 3
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

arrdim1_ir1_ix			; numCalls = 8
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

arrdim1_ir1_sx			; numCalls = 1
	.module	modarrdim1_ir1_sx
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

arrdim2_ir1_ix			; numCalls = 3
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

arrref1_ir1_ix			; numCalls = 15
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx			; numCalls = 1
	.module	modarrref1_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix			; numCalls = 3
	.module	modarrref2_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 14
	.module	modarrval1_ir1_ix
	ldd	r1+1
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

arrval1_ir1_sx			; numCalls = 2
	.module	modarrval1_ir1_sx
	ldd	r1+1
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

arrval2_ir1_ix			; numCalls = 6
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

div_fr1_ir1_fx			; numCalls = 1
	.module	moddiv_fr1_ir1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#0
	std	r1+3
	ldx	#r1
	jmp	divflt

div_fr1_ir1_ix			; numCalls = 1
	.module	moddiv_fr1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	std	r1+3
	ldx	#r1
	jmp	divflt

for_ix_ir1			; numCalls = 1
	.module	modfor_ix_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 10
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 5
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 3
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

input			; numCalls = 1
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

jmpeq_ir1_ix			; numCalls = 2
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

jmpne_ir1_ix			; numCalls = 9
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

ld_fr1_fx			; numCalls = 2
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 3
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 1
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_ir1			; numCalls = 13
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 2
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 58
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 17
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 10
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 4
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 13
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_sp_sr1			; numCalls = 1
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 1
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 1
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 2
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ix			; numCalls = 1
	.module	modldeq_ir1_ir1_ix
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

ldeq_ir1_ir1_pb			; numCalls = 2
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fr1_ix			; numCalls = 1
	.module	modldlt_ir1_fr1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fr1_pb			; numCalls = 1
	.module	modldlt_ir1_fr1_pb
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 1
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 2
	.module	modldlt_ir1_ir1_pb
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_fr2_ix			; numCalls = 2
	.module	modldlt_ir2_fr2_ix
	ldd	r2+1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_fx			; numCalls = 1
	.module	modldlt_ir2_ir2_fx
	ldd	#0
	subd	3,x
	ldd	r2+1
	sbcb	2,x
	sbca	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_pb			; numCalls = 1
	.module	modldlt_ir2_ir2_pb
	clra
	std	tmp1
	ldd	r2+1
	subd	tmp1
	ldab	r2
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir2_fr2_ix			; numCalls = 1
	.module	modldne_ir2_fr2_ix
	ldd	r2+3
	bne	_done
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

next			; numCalls = 11
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

nextvar_ix			; numCalls = 5
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

or_ir1_ir1_ir2			; numCalls = 5
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

pr_sr1			; numCalls = 3
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 10
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

prat_ir1			; numCalls = 2
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 2
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 1
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
	jmp	,x
_reqmsg	.text	"?MICROCOLOR BASIC ROM REQUIRED"
_mcbasic
	ldx	#_reqmsg
	ldab	#30
	jsr	print
	pulx
	rts

progend			; numCalls = 3
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
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
error
	jmp	R_ERROR

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jmp	prtab

read_ip			; numCalls = 2
	.module	modread_ip
	ldx	letptr
	jsr	rnstrng
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

read_ix			; numCalls = 1
	.module	modread_ix
	jsr	rnstrng
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

read_sx			; numCalls = 1
	.module	modread_sx
	jmp	rsstrng

readbuf_fx			; numCalls = 1
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

return			; numCalls = 3
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

shift_ir1_ir1_pb			; numCalls = 2
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

str_sr1_fr1			; numCalls = 1
	.module	modstr_sr1_fr1
	ldd	r1+1
	std	tmp2
	ldab	r1
	stab	tmp1+1
	ldd	r1+3
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

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

sub_ir2_ir2_pb			; numCalls = 4
	.module	modsub_ir2_ir2_pb
	stab	tmp1
	ldd	r2+1
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	r2
	sbcb	#0
	stab	r2
	rts

sub_ix_ix_pb			; numCalls = 1
	.module	modsub_ix_ix_pb
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_ix			; numCalls = 4
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 6
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
	.text	1, "i"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "4"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "4"
	.text	1, "0"
	.text	1, "x"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "v"
	.text	1, "4"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "2"
	.text	2, "-2"
	.text	1, "t"
	.text	1, "4"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	2, "-2"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "w"
	.text	1, "4"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-2"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "u"
	.text	1, "4"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "f"
	.text	1, "8"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	2, "-2"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "l"
	.text	1, "8"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "3"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	2, "-3"
	.text	1, "1"
	.text	2, "-2"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "3"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "3"
	.text	1, "y"
	.text	1, "8"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-2"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "z"
	.text	1, "4"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	2, "-2"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-2"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "p"
	.text	1, "8"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "r"
	.text	1, "8"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "3"
	.text	2, "-1"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "0"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	2, "-1"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	2, "-1"
	.text	1, "1"
	.text	2, "-2"
	.text	1, "1"
	.text	2, "-1"
	.text	1, "1"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "a"
	.text	1, "0"
enddata

symstart

; block started by symbol
bss

; Numeric Variables
INTVAR_B	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_N	.block	3
INTVAR_P	.block	3
INTVAR_P1	.block	3
INTVAR_T	.block	3
INTVAR_V	.block	3
INTVAR_X	.block	3
INTVAR_X1	.block	3
INTVAR_Y	.block	3
INTVAR_Y1	.block	3
FLTVAR_W1	.block	5
FLTVAR_W2	.block	5
; String Variables
STRVAR_C	.block	3
STRVAR_P	.block	3
; Numeric Arrays
INTARR_B	.block	6	; dims=2
INTARR_P	.block	4	; dims=1
INTARR_S	.block	4	; dims=1
INTARR_T	.block	4	; dims=1
INTARR_U	.block	4	; dims=1
INTARR_X	.block	6	; dims=2
INTARR_X1	.block	4	; dims=1
INTARR_X2	.block	4	; dims=1
INTARR_Y	.block	6	; dims=2
INTARR_Y1	.block	4	; dims=1
INTARR_Y2	.block	4	; dims=1
; String Arrays
STRARR_P	.block	4	; dims=1

; block ended by symbol
bes
	.end

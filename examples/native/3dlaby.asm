; Assembly for 3dlaby.bas
; compiled with mcbasic -native

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
DP_DATA	.equ	$AD	; pointer to where READ gets next value
DP_LNUM	.equ	$E2	; current line in BASIC
DP_TABW	.equ	$E4	; current tab width on console
DP_LTAB	.equ	$E5	; current last tab column
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
r3	.block	5
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_6

	; CLS

	jsr	cls

LINE_7

	; REM 

LINE_10

	; GOTO 7000

	ldx	#LINE_7000
	jsr	goto_ix

LINE_100

	; INPUT "LARGEST X-VALUE:"; WX

	jsr	pr_ss
	.text	16, "LARGEST X-VALUE:"

	jsr	input

	ldx	#FLTVAR_WX
	jsr	readbuf_fx

	jsr	ignxtra

LINE_101

	; IF (WX<4) OR (WX>30) THEN

	ldx	#FLTVAR_WX
	jsr	ld_fr1_fx

	ldab	#4
	jsr	ldlt_ir1_fr1_pb

	ldab	#30
	jsr	ld_ir2_pb

	ldx	#FLTVAR_WX
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_102
	jsr	jmpeq_ir1_ix

	; PRINT "BETWEEN 4 AND 30 \r";

	jsr	pr_ss
	.text	18, "BETWEEN 4 AND 30 \r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_102

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_103

	; FOR K=1 TO WX

	ldx	#FLTVAR_K
	ldab	#1
	jsr	for_fx_pb

	ldx	#FLTVAR_WX
	jsr	to_fp_ix

	; Q=RND(9)

	ldab	#9
	jsr	irnd_ir1_pb

	ldx	#FLTVAR_Q
	jsr	ld_fx_ir1

	; NEXT

	jsr	next

LINE_104

	; INPUT "LARGEST Y-VALUE:"; WY

	jsr	pr_ss
	.text	16, "LARGEST Y-VALUE:"

	jsr	input

	ldx	#FLTVAR_WY
	jsr	readbuf_fx

	jsr	ignxtra

LINE_105

	; IF (WY<4) OR (WY>15) THEN

	ldx	#FLTVAR_WY
	jsr	ld_fr1_fx

	ldab	#4
	jsr	ldlt_ir1_fr1_pb

	ldab	#15
	jsr	ld_ir2_pb

	ldx	#FLTVAR_WY
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_106
	jsr	jmpeq_ir1_ix

	; PRINT "BETWEEN 4 AND 15 \r";

	jsr	pr_ss
	.text	18, "BETWEEN 4 AND 15 \r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; GOTO 104

	ldx	#LINE_104
	jsr	goto_ix

LINE_106

	; IF INT(SHIFT(WX,-1))<>SHIFT(WX,-1) THEN

	ldx	#FLTVAR_WX
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#FLTVAR_WX
	jsr	ld_fr2_fx

	ldab	#-1
	jsr	shift_fr2_fr2_nb

	jsr	ldne_ir1_ir1_fr2

	ldx	#LINE_107
	jsr	jmpeq_ir1_ix

	; WX+=1

	ldx	#FLTVAR_WX
	ldab	#1
	jsr	add_fx_fx_pb

LINE_107

	; IF INT(SHIFT(WY,-1))<>SHIFT(WY,-1) THEN

	ldx	#FLTVAR_WY
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#FLTVAR_WY
	jsr	ld_fr2_fx

	ldab	#-1
	jsr	shift_fr2_fr2_nb

	jsr	ldne_ir1_ir1_fr2

	ldx	#LINE_120
	jsr	jmpeq_ir1_ix

	; WY+=1

	ldx	#FLTVAR_WY
	ldab	#1
	jsr	add_fx_fx_pb

LINE_120

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; INPUT "DIFFICULTY LEVEL 1-4"; S

	jsr	pr_ss
	.text	20, "DIFFICULTY LEVEL 1-4"

	jsr	input

	ldx	#FLTVAR_S
	jsr	readbuf_fx

	jsr	ignxtra

	; WHEN (S<1) OR (S>4) GOTO 120

	ldx	#FLTVAR_S
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#4
	jsr	ld_ir2_pb

	ldx	#FLTVAR_S
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_120
	jsr	jmpne_ir1_ix

LINE_200

	; DIM A(WX,WY),O,C,K,Q,A1,A3

	ldx	#FLTVAR_WX
	jsr	ld_fr1_fx

	ldx	#FLTVAR_WY
	jsr	ld_fr2_fx

	ldx	#INTARR_A
	jsr	arrdim2_ir1_ix

	; O=0.5

	ldx	#FLT_0p50000
	jsr	ld_fr1_fx

	ldx	#FLTVAR_O
	jsr	ld_fx_fr1

LINE_220

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "PLEASE WAIT...\r";

	jsr	pr_ss
	.text	15, "PLEASE WAIT...\r"

	; X=INT(SHIFT(WX,-1))

	ldx	#FLTVAR_WX
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=INT(SHIFT(WY,-1))

	ldx	#FLTVAR_WY
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; A(X,Y)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldab	#1
	jsr	ld_ip_pb

LINE_230

	; IF RND(2)>1.1 THEN

	ldx	#FLT_1p10000
	jsr	ld_fr1_fx

	ldab	#2
	jsr	irnd_ir2_pb

	jsr	ldlt_ir1_fr1_ir2

	ldx	#LINE_240
	jsr	jmpeq_ir1_ix

	; XS=SGN(RND(2)-1.1)

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#FLT_1p10000
	jsr	sub_fr1_ir1_fx

	jsr	sgn_ir1_fr1

	ldx	#INTVAR_XS
	jsr	ld_ix_ir1

	; YS=0

	ldx	#INTVAR_YS
	ldab	#0
	jsr	ld_ix_pb

	; GOTO 250

	ldx	#LINE_250
	jsr	goto_ix

LINE_240

	; XS=0

	ldx	#INTVAR_XS
	ldab	#0
	jsr	ld_ix_pb

	; YS=SGN(RND(2)-1.1)

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#FLT_1p10000
	jsr	sub_fr1_ir1_fx

	jsr	sgn_ir1_fr1

	ldx	#INTVAR_YS
	jsr	ld_ix_ir1

LINE_250

	; FOR I=0 TO 1

	ldx	#FLTVAR_I
	ldab	#0
	jsr	for_fx_pb

	ldab	#1
	jsr	to_fp_pb

	; X+=XS

	ldx	#INTVAR_XS
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ix_ix_ir1

	; Y+=YS

	ldx	#INTVAR_YS
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	add_ix_ix_ir1

	; A(X,Y)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix

	ldab	#1
	jsr	ld_ip_pb

LINE_255

	; IF F THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#LINE_260
	jsr	jmpeq_ir1_ix

	; WHEN (X=1) OR (X=(WX-1)) OR (Y=1) OR (Y=1) OR (Y=(WY-1)) GOTO 280

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#FLTVAR_WX
	jsr	ld_fr3_fx

	ldab	#1
	jsr	sub_fr3_fr3_pb

	jsr	ldeq_ir2_ir2_fr3

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#FLTVAR_WY
	jsr	ld_fr3_fx

	ldab	#1
	jsr	sub_fr3_fr3_pb

	jsr	ldeq_ir2_ir2_fr3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_280
	jsr	jmpne_ir1_ix

LINE_260

	; WHEN (X=0) OR (X=WX) OR (Y=0) OR (Y=WY) GOTO 280

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#FLTVAR_WX
	jsr	ldeq_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#FLTVAR_WY
	jsr	ldeq_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_280
	jsr	jmpne_ir1_ix

LINE_270

	; NEXT

	jsr	next

	; GOTO 230

	ldx	#LINE_230
	jsr	goto_ix

LINE_280

	; F+=1

	ldx	#INTVAR_F
	ldab	#1
	jsr	add_ix_ix_pb

	; WHEN F<S GOTO 220

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#FLTVAR_S
	jsr	ldlt_ir1_ir1_fx

	ldx	#LINE_220
	jsr	jmpne_ir1_ix

LINE_2000

	; CLS 0

	ldab	#0
	jsr	clsn_pb

LINE_2010

	; X=INT(SHIFT(WX,-1))

	ldx	#FLTVAR_WX
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=INT(SHIFT(WY,-1))

	ldx	#FLTVAR_WY
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

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

	; R=0

	ldx	#INTVAR_R
	ldab	#0
	jsr	ld_ix_pb

LINE_2020

	; X(0)=1

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	ld_ip_pb

	; Y(0)=0

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; X(1)=0

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; Y(1)=-1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#-1
	jsr	ld_ip_nb

	; X(2)=-1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldab	#-1
	jsr	ld_ip_nb

	; Y(2)=0

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; X(3)=0

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; Y(3)=1

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	ld_ip_pb

LINE_2030

	; RR=R+1

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_RR
	jsr	ld_ix_ir1

	; IF RR>3 THEN

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTVAR_RR
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_2035
	jsr	jmpeq_ir1_ix

	; RR=0

	ldx	#INTVAR_RR
	ldab	#0
	jsr	ld_ix_pb

LINE_2035

	; XR=X(RR)

	ldx	#INTVAR_RR
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_XR
	jsr	ld_ix_ir1

	; YR=Y(RR)

	ldx	#INTVAR_RR
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_YR
	jsr	ld_ix_ir1

LINE_2040

	; SOUND 3,1

	ldab	#3
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

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

	; I=1.5

	ldx	#FLT_1p50000
	jsr	ld_fr1_fx

	ldx	#FLTVAR_I
	jsr	ld_fx_fr1

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

LINE_2045

	; FOR C=4 TO 59

	ldx	#INTVAR_C
	ldab	#4
	jsr	for_ix_pb

	ldab	#59
	jsr	to_ip_pb

	; SET(C,4,6)

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#4
	jsr	ld_ir2_pb

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; SET(C,27,6)

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#27
	jsr	ld_ir2_pb

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

LINE_2046

	; FOR C=4 TO 27

	ldx	#INTVAR_C
	ldab	#4
	jsr	for_ix_pb

	ldab	#27
	jsr	to_ip_pb

	; SET(4,C,6)

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTVAR_C
	jsr	ld_ir2_ix

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; SET(59,C,6)

	ldab	#59
	jsr	ld_ir1_pb

	ldx	#INTVAR_C
	jsr	ld_ir2_ix

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

LINE_2050

	; I+=0.5

	ldx	#FLT_0p50000
	jsr	ld_fr1_fx

	ldx	#FLTVAR_I
	jsr	add_fx_fx_fr1

	; X1+=X(R)

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_X1
	jsr	add_ix_ix_ir1

	; Y1+=Y(R)

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Y1
	jsr	add_ix_ix_ir1

LINE_2051

	; IF (X1<0) OR (X1>WX) OR (Y1<0) OR (Y1>WY) THEN

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#FLTVAR_WX
	jsr	ld_fr2_fx

	ldx	#INTVAR_X1
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y1
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_WY
	jsr	ld_fr2_fx

	ldx	#INTVAR_Y1
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_2052
	jsr	jmpeq_ir1_ix

	; GOSUB 3300

	ldx	#LINE_3300
	jsr	gosub_ix

	; GOTO 2065

	ldx	#LINE_2065
	jsr	goto_ix

LINE_2052

	; WHEN A(X1,Y1)=0 GOTO 2065

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y1
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_2065
	jsr	jmpne_ir1_ix

LINE_2055

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

LINE_2060

	; GOTO 2050

	ldx	#LINE_2050
	jsr	goto_ix

LINE_2065

	; GOSUB 4000

	ldx	#LINE_4000
	jsr	gosub_ix

LINE_2070

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_2075

	; IF A$="X" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "X"

	ldx	#LINE_2080
	jsr	jmpeq_ir1_ix

	; GOSUB 5000

	ldx	#LINE_5000
	jsr	gosub_ix

	; GOTO 2040

	ldx	#LINE_2040
	jsr	goto_ix

LINE_2080

	; IF A$="A" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "A"

	ldx	#LINE_2085
	jsr	jmpeq_ir1_ix

	; R-=1

	ldx	#INTVAR_R
	ldab	#1
	jsr	sub_ix_ix_pb

	; GOTO 2200

	ldx	#LINE_2200
	jsr	goto_ix

LINE_2085

	; IF A$="S" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "S"

	ldx	#LINE_2090
	jsr	jmpeq_ir1_ix

	; R+=1

	ldx	#INTVAR_R
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 2200

	ldx	#LINE_2200
	jsr	goto_ix

LINE_2090

	; WHEN A$="W" GOTO 2100

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "W"

	ldx	#LINE_2100
	jsr	jmpne_ir1_ix

LINE_2095

	; GOTO 2070

	ldx	#LINE_2070
	jsr	goto_ix

LINE_2100

	; X1=X(R)+X

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_X1
	jsr	ld_ix_ir1

	; Y1=Y(R)+Y

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Y
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Y1
	jsr	ld_ix_ir1

	; WHEN (X1<0) OR (X1>WX) OR (Y1<0) OR (Y1>WY) GOTO 6000

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#FLTVAR_WX
	jsr	ld_fr2_fx

	ldx	#INTVAR_X1
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y1
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_WY
	jsr	ld_fr2_fx

	ldx	#INTVAR_Y1
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_6000
	jsr	jmpne_ir1_ix

LINE_2110

	; WHEN A(X1,Y1)=0 GOTO 2070

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y1
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_2070
	jsr	jmpne_ir1_ix

LINE_2115

	; X=X1

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y1

	ldx	#INTVAR_Y1
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOTO 2030

	ldx	#LINE_2030
	jsr	goto_ix

LINE_2200

	; SOUND 31,1

	ldab	#31
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; IF R<0 THEN

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_2210
	jsr	jmpeq_ir1_ix

	; R=3

	ldx	#INTVAR_R
	ldab	#3
	jsr	ld_ix_pb

	; GOTO 2030

	ldx	#LINE_2030
	jsr	goto_ix

LINE_2210

	; IF R>3 THEN

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTVAR_R
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_2220
	jsr	jmpeq_ir1_ix

	; R=0

	ldx	#INTVAR_R
	ldab	#0
	jsr	ld_ix_pb

LINE_2220

	; GOTO 2030

	ldx	#LINE_2030
	jsr	goto_ix

LINE_3000

	; A1=(59/I)+60

	ldab	#59
	jsr	ld_ir1_pb

	ldx	#FLTVAR_I
	jsr	div_fr1_ir1_fx

	ldab	#60
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_A1
	jsr	ld_fx_fr1

	; B1=(24/I)+25

	ldab	#24
	jsr	ld_ir1_pb

	ldx	#FLTVAR_I
	jsr	div_fr1_ir1_fx

	ldab	#25
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_B1
	jsr	ld_fx_fr1

	; B2=60-B1

	ldab	#60
	jsr	ld_ir1_pb

	ldx	#FLTVAR_B1
	jsr	sub_fr1_ir1_fx

	ldx	#FLTVAR_B2
	jsr	ld_fx_fr1

	; A3=127-A1

	ldab	#127
	jsr	ld_ir1_pb

	ldx	#FLTVAR_A1
	jsr	sub_fr1_ir1_fx

	ldx	#FLTVAR_A3
	jsr	ld_fx_fr1

LINE_3001

	; B3=B1

	ldx	#FLTVAR_B1
	jsr	ld_fr1_fx

	ldx	#FLTVAR_B3
	jsr	ld_fx_fr1

	; B4=B2

	ldx	#FLTVAR_B2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_B4
	jsr	ld_fx_fr1

LINE_3010

	; C1=(59/(I-0.5))+60

	ldab	#59
	jsr	ld_ir1_pb

	ldx	#FLTVAR_I
	jsr	ld_fr2_fx

	ldx	#FLT_0p50000
	jsr	sub_fr2_fr2_fx

	jsr	div_fr1_ir1_fr2

	ldab	#60
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_C1
	jsr	ld_fx_fr1

	; D1=(24/(I-0.5))+25

	ldab	#24
	jsr	ld_ir1_pb

	ldx	#FLTVAR_I
	jsr	ld_fr2_fx

	ldx	#FLT_0p50000
	jsr	sub_fr2_fr2_fx

	jsr	div_fr1_ir1_fr2

	ldab	#25
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_D1
	jsr	ld_fx_fr1

	; D2=60-D1

	ldab	#60
	jsr	ld_ir1_pb

	ldx	#FLTVAR_D1
	jsr	sub_fr1_ir1_fx

	ldx	#FLTVAR_D2
	jsr	ld_fx_fr1

	; C3=127-C1

	ldab	#127
	jsr	ld_ir1_pb

	ldx	#FLTVAR_C1
	jsr	sub_fr1_ir1_fx

	ldx	#FLTVAR_C3
	jsr	ld_fx_fr1

LINE_3011

	; D3=D1

	ldx	#FLTVAR_D1
	jsr	ld_fr1_fx

	ldx	#FLTVAR_D3
	jsr	ld_fx_fr1

	; D4=D2

	ldx	#FLTVAR_D2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_D4
	jsr	ld_fx_fr1

LINE_3015

	; XT=X1+XR

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldx	#INTVAR_XR
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_XT
	jsr	ld_ix_ir1

	; YT=Y1+YR

	ldx	#INTVAR_Y1
	jsr	ld_ir1_ix

	ldx	#INTVAR_YR
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_YT
	jsr	ld_ix_ir1

	; WHEN (XT<0) OR (XT>WX) OR (YT<0) OR (YT>WY) GOTO 3040

	ldx	#INTVAR_XT
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#FLTVAR_WX
	jsr	ld_fr2_fx

	ldx	#INTVAR_XT
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_YT
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_WY
	jsr	ld_fr2_fx

	ldx	#INTVAR_YT
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_3040
	jsr	jmpne_ir1_ix

LINE_3020

	; WHEN A(XT,YT)=1 GOTO 3040

	ldx	#INTVAR_XT
	jsr	ld_ir1_ix

	ldx	#INTVAR_YT
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_3040
	jsr	jmpne_ir1_ix

LINE_3029

	; BA=B1

	ldx	#FLTVAR_B1
	jsr	ld_fr1_fx

	ldx	#FLTVAR_BA
	jsr	ld_fx_fr1

	; BB=B2

	ldx	#FLTVAR_B2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_BB
	jsr	ld_fx_fr1

	; FOR K=A1 TO C1 STEP 2

	ldx	#FLTVAR_A1
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	for_fx_fr1

	ldx	#FLTVAR_C1
	jsr	to_fp_fx

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_fp_ir1

LINE_3030

	; FOR Q=BB TO BA STEP 2

	ldx	#FLTVAR_BB
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_BA
	jsr	to_fp_fx

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_fp_ir1

	; SET(O*K,Q*O,6)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldx	#FLTVAR_O
	jsr	mul_fr2_fr2_fx

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

	; BB-=1

	ldx	#FLTVAR_BB
	ldab	#1
	jsr	sub_fx_fx_pb

	; BA+=1

	ldx	#FLTVAR_BA
	ldab	#1
	jsr	add_fx_fx_pb

	; NEXT

	jsr	next

LINE_3031

	; GOTO 3050

	ldx	#LINE_3050
	jsr	goto_ix

LINE_3040

	; FOR K=A1 TO C1

	ldx	#FLTVAR_A1
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	for_fx_fr1

	ldx	#FLTVAR_C1
	jsr	to_fp_fx

	; FOR Q=B2 TO B1 STEP 2

	ldx	#FLTVAR_B2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_B1
	jsr	to_fp_fx

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_fp_ir1

	; SET(O*K,Q*O,3)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldx	#FLTVAR_O
	jsr	mul_fr2_fr2_fx

	ldab	#3
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_3050

	; FOR Q=B2 TO B1

	ldx	#FLTVAR_B2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_B1
	jsr	to_fp_fx

	; RESET(O*A1,SHIFT(Q,-1))

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_A1
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldab	#-1
	jsr	shift_fr2_fr2_nb

	jsr	reset_ir1_ir2

	; NEXT

	jsr	next

LINE_3090

	; XT=X1-XR

	ldx	#INTVAR_X1
	jsr	ld_ir1_ix

	ldx	#INTVAR_XR
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_XT
	jsr	ld_ix_ir1

	; YT=Y1-YR

	ldx	#INTVAR_Y1
	jsr	ld_ir1_ix

	ldx	#INTVAR_YR
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_YT
	jsr	ld_ix_ir1

	; WHEN (XT<0) OR (XT>WX) OR (YT<0) OR (YT>WY) GOTO 3140

	ldx	#INTVAR_XT
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#FLTVAR_WX
	jsr	ld_fr2_fx

	ldx	#INTVAR_XT
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_YT
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_WY
	jsr	ld_fr2_fx

	ldx	#INTVAR_YT
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_3140
	jsr	jmpne_ir1_ix

LINE_3100

	; WHEN A(XT,YT)=1 GOTO 3140

	ldx	#INTVAR_XT
	jsr	ld_ir1_ix

	ldx	#INTVAR_YT
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_3140
	jsr	jmpne_ir1_ix

LINE_3129

	; BB=B4

	ldx	#FLTVAR_B4
	jsr	ld_fr1_fx

	ldx	#FLTVAR_BB
	jsr	ld_fx_fr1

	; BA=B3

	ldx	#FLTVAR_B3
	jsr	ld_fr1_fx

	ldx	#FLTVAR_BA
	jsr	ld_fx_fr1

	; FOR K=A3 TO C3 STEP -2

	ldx	#FLTVAR_A3
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	for_fx_fr1

	ldx	#FLTVAR_C3
	jsr	to_fp_fx

	ldab	#-2
	jsr	ld_ir1_nb

	jsr	step_fp_ir1

LINE_3130

	; FOR Q=BB TO BA STEP 2

	ldx	#FLTVAR_BB
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_BA
	jsr	to_fp_fx

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_fp_ir1

	; SET(O*K,Q*O,6)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldx	#FLTVAR_O
	jsr	mul_fr2_fr2_fx

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

	; BB-=1

	ldx	#FLTVAR_BB
	ldab	#1
	jsr	sub_fx_fx_pb

	; BA+=1

	ldx	#FLTVAR_BA
	ldab	#1
	jsr	add_fx_fx_pb

LINE_3131

	; NEXT

	jsr	next

	; GOTO 3150

	ldx	#LINE_3150
	jsr	goto_ix

LINE_3140

	; FOR K=A3 TO C3 STEP -2

	ldx	#FLTVAR_A3
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	for_fx_fr1

	ldx	#FLTVAR_C3
	jsr	to_fp_fx

	ldab	#-2
	jsr	ld_ir1_nb

	jsr	step_fp_ir1

	; FOR Q=B4 TO B3

	ldx	#FLTVAR_B4
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_B3
	jsr	to_fp_fx

	; SET(O*K,Q*O,3)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldx	#FLTVAR_O
	jsr	mul_fr2_fr2_fx

	ldab	#3
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_3150

	; FOR Q=B4 TO B3

	ldx	#FLTVAR_B4
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_B3
	jsr	to_fp_fx

	; RESET(O*A3,SHIFT(Q,-1))

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_A3
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldab	#-1
	jsr	shift_fr2_fr2_nb

	jsr	reset_ir1_ir2

	; NEXT

	jsr	next

LINE_3200

	; RETURN

	jsr	return

LINE_3300

	; REM 

LINE_3310

	; FOR K=B2 TO B1

	ldx	#FLTVAR_B2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	for_fx_fr1

	ldx	#FLTVAR_B1
	jsr	to_fp_fx

	; SET(O*62,K*O,4)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldab	#62
	jsr	mul_fr1_fr1_pb

	ldx	#FLTVAR_K
	jsr	ld_fr2_fx

	ldx	#FLTVAR_O
	jsr	mul_fr2_fr2_fx

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; NEXT K

	ldx	#FLTVAR_K
	jsr	nextvar_fx

	jsr	next

	; FOR Q=A3 TO A1

	ldx	#FLTVAR_A3
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_A1
	jsr	to_fp_fx

	; SET(O*Q,30*O,4)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	mul_fr1_fr1_fx

	ldab	#30
	jsr	ld_ir2_pb

	ldx	#FLTVAR_O
	jsr	mul_fr2_ir2_fx

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

LINE_3320

	; RETURN

	jsr	return

LINE_4000

	; REM 

LINE_4010

	; FOR K=A3 TO A1+0.5 STEP 4

	ldx	#FLTVAR_A3
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	for_fx_fr1

	ldx	#FLTVAR_A1
	jsr	ld_fr1_fx

	ldx	#FLT_0p50000
	jsr	add_fr1_fr1_fx

	jsr	to_fp_fr1

	ldab	#4
	jsr	ld_ir1_pb

	jsr	step_fp_ir1

	; FOR Q=B2 TO B1 STEP 2

	ldx	#FLTVAR_B2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldx	#FLTVAR_B1
	jsr	to_fp_fx

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_fp_ir1

	; SET(O*K,Q*O,6)

	ldx	#FLTVAR_O
	jsr	ld_fr1_fx

	ldx	#FLTVAR_K
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_Q
	jsr	ld_fr2_fx

	ldx	#FLTVAR_O
	jsr	mul_fr2_fr2_fx

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_4020

	; RETURN

	jsr	return

LINE_5000

	; CLS

	jsr	cls

	; FOR Z=0 TO WY

	ldx	#INTVAR_Z
	ldab	#0
	jsr	for_ix_pb

	ldx	#FLTVAR_WY
	jsr	to_ip_ix

	; FOR Q=WX TO 0 STEP -1

	ldx	#FLTVAR_WX
	jsr	ld_fr1_fx

	ldx	#FLTVAR_Q
	jsr	for_fx_fr1

	ldab	#0
	jsr	to_fp_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_fp_ir1

LINE_5005

	; IF Q=X THEN

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#INTVAR_X
	jsr	ldeq_ir1_fr1_ix

	ldx	#LINE_5010
	jsr	jmpeq_ir1_ix

	; IF Z=Y THEN

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_5010
	jsr	jmpeq_ir1_ix

	; PRINT "O";

	jsr	pr_ss
	.text	1, "O"

	; GOTO 5050

	ldx	#LINE_5050
	jsr	goto_ix

LINE_5010

	; WHEN A(Q,Z)=0 GOTO 5040

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_5040
	jsr	jmpne_ir1_ix

LINE_5015

	; IF A(Q,Z)=1 THEN

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_5020
	jsr	jmpeq_ir1_ix

	; PRINT " ";

	jsr	pr_ss
	.text	1, " "

	; GOTO 5050

	ldx	#LINE_5050
	jsr	goto_ix

LINE_5020

	; IF (Q=X) AND (Z=Y) THEN

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#INTVAR_X
	jsr	ldeq_ir1_fr1_ix

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#INTVAR_Y
	jsr	ldeq_ir2_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_5040
	jsr	jmpeq_ir1_ix

	; PRINT "*";

	jsr	pr_ss
	.text	1, "*"

	; GOTO 5050

	ldx	#LINE_5050
	jsr	goto_ix

LINE_5040

	; PRINT "Ä";

	jsr	pr_ss
	.text	1, "\x80"

LINE_5050

	; NEXT

	jsr	next

	; WHEN Z>=16 GOTO 5051

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#16
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_5051
	jsr	jmpne_ir1_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_5051

	; NEXT

	jsr	next

LINE_5055

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_5060

	; IF A$="X" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "X"

	ldx	#LINE_5070
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_5070

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; GOTO 5060

	ldx	#LINE_5060
	jsr	goto_ix

LINE_6000

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_6002

	; PRINT "    ÄååååååååååååååÄ\r";

	jsr	pr_ss
	.text	21, "    \x80\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x80\r"

LINE_6004

	; PRINT "    ÄüüüüüüüüüüüüüüÄ\r";

	jsr	pr_ss
	.text	21, "    \x80\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x80\r"

LINE_6006

	; PRINT "     ÄüüüütheüüüüüÄ\r";

	jsr	pr_ss
	.text	20, "     \x80\x9F\x9F\x9F\x9Fthe\x9F\x9F\x9F\x9F\x9F\x80\r"

LINE_6008

	; PRINT "      ÄüüüüüüüüüüÄ\r";

	jsr	pr_ss
	.text	19, "      \x80\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x9F\x80\r"

LINE_6010

	; PRINT "       ÄüwinnerüÄ\r";

	jsr	pr_ss
	.text	18, "       \x80\x9Fwinner\x9F\x80\r"

LINE_6012

	; PRINT "        ÄüüüüüüÄ\r";

	jsr	pr_ss
	.text	17, "        \x80\x9F\x9F\x9F\x9F\x9F\x9F\x80\r"

LINE_6014

	; PRINT "         îúúúúò          ÄÄÄ\r";

	jsr	pr_ss
	.text	29, "         \x94\x9C\x9C\x9C\x9C\x98          \x80\x80\x80\r"

LINE_6016

	; PRINT "           ïö            Ä1Ä\r";

	jsr	pr_ss
	.text	29, "           \x95\x9A            \x801\x80\r"

LINE_6018

	; PRINT "           ïö         ÄÄÄÄÄÄÄÄÄ\r";

	jsr	pr_ss
	.text	32, "           \x95\x9A         \x80\x80\x80\x80\x80\x80\x80\x80\x80\r"

LINE_6020

	; PRINT "          ëóõí        Ä2ÄÄÄÄÄ3Ä\r";

	jsr	pr_ss
	.text	32, "          \x91\x97\x9B\x92        \x802\x80\x80\x80\x80\x803\x80\r"

LINE_6021

	; POKE 16794,49

	ldab	#49
	jsr	ld_ir1_pb

	ldd	#16794
	jsr	poke_pw_ir1

	; POKE 16855,50

	ldab	#50
	jsr	ld_ir1_pb

	ldd	#16855
	jsr	poke_pw_ir1

	; POKE 16861,51

	ldab	#51
	jsr	ld_ir1_pb

	ldd	#16861
	jsr	poke_pw_ir1

LINE_6022

	; PRINT "         ÄúúúúÄ\r";

	jsr	pr_ss
	.text	16, "         \x80\x9C\x9C\x9C\x9C\x80\r"

LINE_6029

	; G=250

	ldx	#INTVAR_G
	ldab	#250
	jsr	ld_ix_pb

LINE_6030

	; PRINT @G, "‚";

	ldx	#INTVAR_G
	jsr	prat_ix

	jsr	pr_ss
	.text	1, "\xE2"

	; PRINT @G+31, "âÄÜ";

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#31
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\x89\x80\x86"

	; PRINT @G+64, "Ä";

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#64
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x80"

LINE_6032

	; PRINT @G+95, "â Ü";

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#95
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\x89 \x86"

LINE_6033

	; SOUND 189,2

	ldab	#189
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 206,2

	ldab	#206
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 181,2

	ldab	#181
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 229,2

	ldab	#229
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 215,2

	ldab	#215
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 242,6

	ldab	#242
	jsr	ld_ir1_pb

	ldab	#6
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 229,3

	ldab	#229
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 242,3

	ldab	#242
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 229,3

	ldab	#229
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 242,3

	ldab	#242
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 229,1

	ldab	#229
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_6040

	; FOR X=1 TO 20

	ldx	#INTVAR_X
	ldab	#1
	jsr	for_ix_pb

	ldab	#20
	jsr	to_ip_pb

	; PRINT @G+31, "ÉÄÉ";

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#31
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\x83\x80\x83"

	; FOR Z=1 TO 400

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldd	#400
	jsr	to_ip_pw

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

LINE_6041

	; PRINT @G+31, "âÄÜ";

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#31
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\x89\x80\x86"

	; FOR Z=1 TO 400

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldd	#400
	jsr	to_ip_pw

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_6050

	; PRINT @480,

	ldd	#480
	jsr	prat_pw

	; INPUT "PLAY AGAIN (Y/N)"; A$

	jsr	pr_ss
	.text	16, "PLAY AGAIN (Y/N)"

	jsr	input

	ldx	#STRVAR_A
	jsr	readbuf_sx

	jsr	ignxtra

	; IF A$="Y" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_6055
	jsr	jmpeq_ir1_ix

	; RUN

	jsr	clear

	ldx	#LINE_6
	jsr	goto_ix

LINE_6055

	; CLS

	jsr	cls

	; PRINT @480, "B Y E ! !\r";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	10, "B Y E ! !\r"

	; END

	jsr	progend

LINE_7000

	; REM 

LINE_7005

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_7010

	; PRINT " ÅÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÇ\r";

	jsr	pr_ss
	.text	32, " \x81\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x82\r"

LINE_7020

	; GOSUB 7500

	ldx	#LINE_7500
	jsr	gosub_ix

LINE_7030

	; PRINT " Ö        3D LABYRINTH        ä\r";

	jsr	pr_ss
	.text	32, " \x85        3D LABYRINTH        \x8A\r"

	; GOSUB 7500

	ldx	#LINE_7500
	jsr	gosub_ix

LINE_7040

	; PRINT " Ñåååååååbyådieteråfryerååååååà\r";

	jsr	pr_ss
	.text	32, " \x84\x8C\x8C\x8C\x8C\x8C\x8C\x8Cby\x8Cdieter\x8Cfryer\x8C\x8C\x8C\x8C\x8C\x8C\x88\r"

LINE_7100

	; RESTORE

	jsr	restore

	; FOR X=1 TO 9

	ldx	#INTVAR_X
	ldab	#1
	jsr	for_ix_pb

	ldab	#9
	jsr	to_ip_pb

	; READ A

	ldx	#FLTVAR_A
	jsr	read_fx

	; READ B

	ldx	#INTVAR_B
	jsr	read_ix

	; SOUND A,B

	ldx	#FLTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ir2_ix

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_7120

	; CLS

	jsr	cls

	; PRINT "THE GOAL OF THE GAME IS TO\r";

	jsr	pr_ss
	.text	27, "THE GOAL OF THE GAME IS TO\r"

LINE_7130

	; PRINT "ESCAPE FROM THE LABYRINTH IN\r";

	jsr	pr_ss
	.text	29, "ESCAPE FROM THE LABYRINTH IN\r"

LINE_7140

	; PRINT "WHICH YOU NOW FIND YOURSELF.\r";

	jsr	pr_ss
	.text	29, "WHICH YOU NOW FIND YOURSELF.\r"

LINE_7150

	; PRINT "USE THE KEYS <A>, <S>, AND <W>\r";

	jsr	pr_ss
	.text	31, "USE THE KEYS <A>, <S>, AND <W>\r"

LINE_7160

	; PRINT "TO MOVE LEFT, RIGHT OR STRAIGHT.";

	jsr	pr_ss
	.text	32, "TO MOVE LEFT, RIGHT OR STRAIGHT."

LINE_7170

	; PRINT "THE <X> KEY SHOWS THE LABYRINTH\r";

	jsr	pr_ss
	.text	32, "THE <X> KEY SHOWS THE LABYRINTH\r"

LINE_7190

	; PRINT "FROM ABOVE. PRESS <X> AGAIN\r";

	jsr	pr_ss
	.text	28, "FROM ABOVE. PRESS <X> AGAIN\r"

LINE_7200

	; PRINT "TO RETURN TO THE LABYRINTH.\r";

	jsr	pr_ss
	.text	28, "TO RETURN TO THE LABYRINTH.\r"

LINE_7210

	; PRINT "A CROSS MARKS THE WAY OUT.\r";

	jsr	pr_ss
	.text	27, "A CROSS MARKS THE WAY OUT.\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_7220

	; PRINT "have fun playing!\r";

	jsr	pr_ss
	.text	18, "have fun playing!\r"

LINE_7250

	; PRINT @480, "press enter to begin";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	20, "press enter to begin"

	; INPUT A

	jsr	input

	ldx	#FLTVAR_A
	jsr	readbuf_fx

	jsr	ignxtra

LINE_7300

	; CLS

	jsr	cls

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_7500

	; FOR X=1 TO 3

	ldx	#INTVAR_X
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; PRINT " Ö";TAB(30);"ä\r";

	jsr	pr_ss
	.text	2, " \x85"

	ldab	#30
	jsr	prtab_pb

	jsr	pr_ss
	.text	2, "\x8A\r"

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_8000

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

	.module	mdmulflt
mulfltx
	bsr	mulfltt
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts
mulfltt
	jsr	mulhlf
	clr	tmp4
_4_3
	ldaa	4+argv
	beq	_3_4
	ldab	3,x
	bsr	_m43
_4_1
	ldaa	4+argv
	ldab	1,x
	bsr	_m41
_4_2
	ldaa	4+argv
	ldab	2,x
	bsr	_m42
_4_0
	ldaa	4+argv
	ldab	0,x
	bsr	_m40
	ldab	0,x
	bpl	_4_4
	ldd	tmp1+1
	subb	4+argv
	sbca	#0
	std	tmp1+1
_4_4
	ldaa	4+argv
	ldab	4,x
	beq	_rndup
	mul
	lslb
	adca	tmp4
	staa	tmp4
	bsr	mulflt3
_3_4
	ldab	4,x
	beq	_rndup
	ldaa	3+argv
	bsr	_m43
_1_4
	ldab	4,x
	ldaa	1+argv
	bsr	_m41
_2_4
	ldab	4,x
	ldaa	2+argv
	bsr	_m42
_0_4
	ldab	4,x
	ldaa	0+argv
	bsr	_m40
	ldaa	0+argv
	bpl	_rndup
	ldd	tmp1+1
	subb	4,x
	sbca	#0
	std	tmp1+1
_rndup
	ldaa	tmp4
	lsla
mulflt3
	ldd	tmp3
	adcb	#0
	adca	#0
	std	tmp3
	ldd	tmp2
	adcb	#0
	adca	#0
	jmp	mulhlf2
_m43
	mul
	addd	tmp3+1
	std	tmp3+1
	rol	tmp4+1
	rts
_m41
	mul
	lsr	tmp4+1
	adcb	tmp3
	adca	tmp2+1
	std	tmp2+1
	ldd	tmp1+1
	adcb	#0
	adca	#0
	std	tmp1+1
	rts
_m42
	mul
	addd	tmp3
	std	tmp3
	rol	tmp4+1
	rts
_m40
	mul
	lsr	tmp4+1
	adcb	tmp2+1
	adca	tmp2
	bra	mulhlf2

	.module	mdmulhlf
mulhlf
	bsr	mulint
	ldd	#0
	std	tmp3
	stab	tmp4+1
_3_2
	ldaa	3+argv
	beq	_2_3
	ldab	2,x
	bsr	_m32
_3_0
	ldaa	3+argv
	ldab	0,x
	bsr	_m30
	ldab	0,x
	bpl	_3_3
	ldab	tmp1+1
	subb	3+argv
	stab	tmp1+1
_3_3
	ldaa	3+argv
	ldab	3,x
	mul
	adda	tmp3
	std	tmp3
	rol	tmp4+1
_3_1
	ldaa	3+argv
	ldab	1,x
	bsr	_m31
_2_3
	ldab	3,x
	beq	_rts
	ldaa	2+argv
	bsr	_m32
_0_3
	ldab	3,x
	ldaa	0+argv
	bsr	_m30
	ldaa	0+argv
	bpl	_1_3
	ldab	tmp1+1
	subb	3,x
	stab	tmp1+1
_1_3
	ldab	3,x
	ldaa	1+argv
	clr	tmp4+1
_m31
	mul
	lsr	tmp4+1
	adcb	tmp2+1
	adca	tmp2
mulhlf2
	std	tmp2
	ldab	tmp1+1
	adcb	#0
	stab	tmp1+1
	rts
_m32
	mul
	addd	tmp2+1
	std	tmp2+1
	rol	tmp4+1
	rts
_m30
	mul
	lsr	tmp4+1
	adcb	tmp2
	adca	tmp1+1
	std	tmp1+1
_rts
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
	addb	tmp2
	adca	tmp1+1
	std	tmp1+1
	ldaa	1+argv
	ldab	2,x
	mul
	addb	tmp2
	adca	tmp1+1
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

	.module	mdrpubyte
; read DATA when records are purely unsigned bytes
; EXIT:  int in tmp1+1 and tmp2
rpubyte
	pshx
	ldx	DP_DATA
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldaa	,x
	inx
	stx	DP_DATA
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

	.module	mdshrflt
; divide X by 2^ACCB for positive ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1
shrint
	clr	3,x
	clr	4,x
shrflt
	cmpb	#8
	blo	_shrbit
	stab	tmp1
	ldd	2,x
	std	3,x
	ldd	0,x
	std	1,x
	clrb
	lsla
	sbcb	#0
	stab	0,x
	ldab	tmp1
	subb	#8
	bne	shrflt
	rts
_shrbit
	asr	0,x
	ror	1,x
	ror	2,x
	ror	3,x
	ror	4,x
	decb
	bne	_shrbit
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
	ldx	1+argv
	ldab	,x
_null
	ldaa	#charpage>>8
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

add_fr1_fr1_fx			; numCalls = 1
	.module	modadd_fr1_fr1_fx
	ldd	r1+3
	addd	3,x
	std	r1+3
	ldd	r1+1
	adcb	2,x
	adca	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 4
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fx_fx_fr1			; numCalls = 1
	.module	modadd_fx_fx_fr1
	ldd	3,x
	addd	r1+3
	std	3,x
	ldd	1,x
	adcb	r1+2
	adca	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_fx_fx_pb			; numCalls = 4
	.module	modadd_fx_fx_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

add_ir1_ir1_ix			; numCalls = 4
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 6
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
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

and_ir1_ir1_ir2			; numCalls = 1
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

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

arrref1_ir1_ix			; numCalls = 8
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix			; numCalls = 2
	.module	modarrref2_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 6
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

clear			; numCalls = 2
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

cls			; numCalls = 5
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 2
	.module	modclsn_pb
	jmp	R_CLSN

div_fr1_ir1_fr2			; numCalls = 2
	.module	moddiv_fr1_ir1_fr2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldd	r2+3
	std	3+argv
	ldd	#0
	std	r1+3
	ldx	#r1
	jmp	divflt

div_fr1_ir1_fx			; numCalls = 2
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

for_fx_fr1			; numCalls = 15
	.module	modfor_fx_fr1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	ldd	r1+3
	std	3,x
	rts

for_fx_pb			; numCalls = 2
	.module	modfor_fx_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
	rts

for_ix_pb			; numCalls = 8
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 7
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 22
	.module	modgoto_ix
	ins
	ins
	jmp	,x

ignxtra			; numCalls = 5
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inkey_sr1			; numCalls = 3
	.module	modinkey_sr1
	ldd	#$0100+(charpage>>8)
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

input			; numCalls = 5
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

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

irnd_ir2_pb			; numCalls = 1
	.module	modirnd_ir2_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r2+1
	ldab	tmp1
	stab	r2
	rts

jmpeq_ir1_ix			; numCalls = 19
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

ld_fr1_fx			; numCalls = 51
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 21
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fr3_fx			; numCalls = 2
	.module	modld_fr3_fx
	ldd	3,x
	std	r3+3
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_fx_fr1			; numCalls = 18
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 1
	.module	modld_fx_ir1
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_nb			; numCalls = 2
	.module	modld_ip_nb
	ldx	letptr
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ip_pb			; numCalls = 8
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 44
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_nb			; numCalls = 3
	.module	modld_ir1_nb
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ir1_pb			; numCalls = 42
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 23
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 19
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 21
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 7
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

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

ldeq_ir1_fr1_ix			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 8
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 6
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

ldeq_ir2_ir2_fr3			; numCalls = 2
	.module	modldeq_ir2_ir2_fr3
	ldd	r3+3
	bne	_done
	ldd	r2+1
	subd	r3+1
	bne	_done
	ldab	r2
	cmpb	r3
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_fx			; numCalls = 2
	.module	modldeq_ir2_ir2_fx
	ldd	3,x
	bne	_done
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_ix			; numCalls = 1
	.module	modldeq_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_pb			; numCalls = 3
	.module	modldeq_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldge_ir1_ir1_pb			; numCalls = 1
	.module	modldge_ir1_ir1_pb
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fr1_ir2			; numCalls = 1
	.module	modldlt_ir1_fr1_ir2
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fr1_pb			; numCalls = 3
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

ldlt_ir1_ir1_fx			; numCalls = 1
	.module	modldlt_ir1_ir1_fx
	ldd	#0
	subd	3,x
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 2
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 5
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

ldlt_ir2_fr2_ix			; numCalls = 8
	.module	modldlt_ir2_fr2_ix
	ldd	r2+1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_fx			; numCalls = 3
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

ldlt_ir2_ir2_pb			; numCalls = 4
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

ldne_ir1_ir1_fr2			; numCalls = 2
	.module	modldne_ir1_ir1_fr2
	ldd	r2+3
	bne	_done
	ldd	r1+1
	subd	r2+1
	bne	_done
	ldab	r1
	cmpb	r2
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

mul_fr1_fr1_fx			; numCalls = 8
	.module	modmul_fr1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr2_fr2_fx			; numCalls = 6
	.module	modmul_fr2_fr2_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r2
	jmp	mulfltx

mul_fr2_ir2_fx			; numCalls = 1
	.module	modmul_fr2_ir2_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#0
	std	r2+3
	ldx	#r2
	jmp	mulfltx

next			; numCalls = 25
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

nextvar_fx			; numCalls = 1
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

or_ir1_ir1_ir2			; numCalls = 22
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

poke_pw_ir1			; numCalls = 3
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_ss			; numCalls = 62
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_ir1			; numCalls = 5
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 1
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jmp	prtab

read_fx			; numCalls = 1
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

readbuf_fx			; numCalls = 4
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

readbuf_sx			; numCalls = 1
	.module	modreadbuf_sx
	stx	letptr
	jsr	rdinit
	ldaa	#','
	staa	tmp1
	ldaa	,x
	beq	_null
	cmpa	#'"'
	bne	_unquoted
	staa	tmp1
	inx
_unquoted
	stx	tmp3
	clrb
_nxtchr
	incb
	inx
	ldaa	,x
	beq	_done
	cmpa	tmp1
	bne	_nxtchr
_done
	stx	inptptr
	stab	0+argv
	ldd	tmp3
	std	1+argv
	ldx	letptr
	jsr	strprm
_rdredo
	jsr	rdredo
	beq	_rts
	pulx
	jmp	,x
_rts
	rts
_null
	ldx	letptr
	jsr	strdel
	ldd	#$0100
	ldx	letptr
	stab	0,x
	std	1,x
	bra	_rdredo

reset_ir1_ir2			; numCalls = 2
	.module	modreset_ir1_ir2
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

restore			; numCalls = 1
	.module	modrestore
	ldx	#startdata
	stx	DP_DATA
	rts

return			; numCalls = 5
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

setc_ir1_ir2_pb			; numCalls = 11
	.module	modsetc_ir1_ir2_pb
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

sgn_ir1_fr1			; numCalls = 2
	.module	modsgn_ir1_fr1
	ldab	r1
	bmi	_neg
	bne	_pos
	ldd	r1+1
	bne	_pos
	ldd	r1+3
	bne	_pos
	ldd	#0
	stab	r1+2
	bra	_done
_pos
	ldd	#1
	stab	r1+2
	clrb
	bra	_done
_neg
	ldd	#-1
	stab	r1+2
_done
	std	r1
	rts

shift_fr1_fr1_nb			; numCalls = 6
	.module	modshift_fr1_fr1_nb
	ldx	#r1
	negb
	jmp	shrflt

shift_fr2_fr2_nb			; numCalls = 4
	.module	modshift_fr2_fr2_nb
	ldx	#r2
	negb
	jmp	shrflt

sound_ir1_ir2			; numCalls = 14
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_fp_ir1			; numCalls = 9
	.module	modstep_fp_ir1
	tsx
	ldab	r1
	stab	12,x
	ldd	r1+1
	std	13,x
	ldd	#0
	std	15,x
	ldd	,x
	std	5,x
	rts

sub_fr1_ir1_fx			; numCalls = 6
	.module	modsub_fr1_ir1_fx
	ldd	#0
	subd	3,x
	std	r1+3
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_fr2_fr2_fx			; numCalls = 2
	.module	modsub_fr2_fr2_fx
	ldd	r2+3
	subd	3,x
	std	r2+3
	ldd	r2+1
	sbcb	2,x
	sbca	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

sub_fr3_fr3_pb			; numCalls = 2
	.module	modsub_fr3_fr3_pb
	stab	tmp1
	ldd	r3+1
	subb	tmp1
	sbca	#0
	std	r3+1
	ldab	r3
	sbcb	#0
	stab	r3
	rts

sub_fx_fx_pb			; numCalls = 2
	.module	modsub_fx_fx_pb
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

sub_ir1_ir1_ix			; numCalls = 2
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
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

to_fp_fr1			; numCalls = 1
	.module	modto_fp_fr1
	ldab	#15
	jmp	to

to_fp_fx			; numCalls = 13
	.module	modto_fp_fx
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	std	r1+3
	ldab	#15
	jmp	to

to_fp_ix			; numCalls = 1
	.module	modto_fp_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#15
	jmp	to

to_fp_pb			; numCalls = 2
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

to_ip_pb			; numCalls = 5
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 2
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
	.byte	233, 4, 229, 4, 233, 4
	.byte	229, 4, 231, 4, 229, 4
	.byte	225, 4, 221, 2, 87, 8
enddata


; fixed-point constants
FLT_0p50000	.byte	$00, $00, $00, $80, $00
FLT_1p10000	.byte	$00, $00, $01, $19, $9a
FLT_1p50000	.byte	$00, $00, $01, $80, $00

; block started by symbol
bss

; Numeric Variables
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_R	.block	3
INTVAR_RR	.block	3
INTVAR_X	.block	3
INTVAR_X1	.block	3
INTVAR_XR	.block	3
INTVAR_XS	.block	3
INTVAR_XT	.block	3
INTVAR_Y	.block	3
INTVAR_Y1	.block	3
INTVAR_YR	.block	3
INTVAR_YS	.block	3
INTVAR_YT	.block	3
INTVAR_Z	.block	3
FLTVAR_A	.block	5
FLTVAR_A1	.block	5
FLTVAR_A3	.block	5
FLTVAR_B1	.block	5
FLTVAR_B2	.block	5
FLTVAR_B3	.block	5
FLTVAR_B4	.block	5
FLTVAR_BA	.block	5
FLTVAR_BB	.block	5
FLTVAR_C1	.block	5
FLTVAR_C3	.block	5
FLTVAR_D1	.block	5
FLTVAR_D2	.block	5
FLTVAR_D3	.block	5
FLTVAR_D4	.block	5
FLTVAR_I	.block	5
FLTVAR_K	.block	5
FLTVAR_O	.block	5
FLTVAR_Q	.block	5
FLTVAR_S	.block	5
FLTVAR_WX	.block	5
FLTVAR_WY	.block	5
; String Variables
STRVAR_A	.block	3
; Numeric Arrays
INTARR_A	.block	6	; dims=2
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

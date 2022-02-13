; Assembly for testexp-native.bas
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
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_10

	; INPUT "ENTER Y"; Y

	jsr	pr_ss
	.text	7, "ENTER Y"

	jsr	input

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

LINE_11

	; L=0.693147

	ldx	#FLT_0p69314
	jsr	ld_fr1_fx

	ldx	#FLTVAR_L
	jsr	ld_fx_fr1

LINE_12

	; Z=IDIV(Y,L)

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_L
	jsr	idiv_ir1_fr1_fx

	ldx	#INTVAR_Z
	jsr	ld_ix_ir1

LINE_13

	; X=Y-(Z*L)

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#FLTVAR_L
	jsr	mul_fr2_ir2_fx

	jsr	sub_fr1_fr1_fr2

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

LINE_14

	; PRINT STR$(Y);"  = ";STR$(Z);" L";STR$(X);" \r";

	ldx	#FLTVAR_Y
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	4, "  = "

	ldx	#INTVAR_Z
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " L"

	ldx	#FLTVAR_X
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_19

	; E0=(((((((((((6+X)*X)+30)*X)+120)*X)+360)*X)+720)*X)+720)/720

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#FLTVAR_X
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#30
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#120
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#360
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#720
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#720
	jsr	add_fr1_fr1_pw

	ldd	#720
	jsr	div_fr1_fr1_pw

	ldx	#FLTVAR_E0
	jsr	ld_fx_fr1

LINE_20

	; E1=(((((((((((((7+X)*X)+42)*X)+210)*X)+840)*X)+2520)*X)+5040)*X)+5040)/5040

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#FLTVAR_X
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#42
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#210
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#840
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#2520
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#5040
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#5040
	jsr	add_fr1_fr1_pw

	ldd	#5040
	jsr	div_fr1_fr1_pw

	ldx	#FLTVAR_E1
	jsr	ld_fx_fr1

LINE_21

	; S1=((((((((((((7+X)*X)+42)*X)+210)*X)+840)*X)+2520)*X)+5040)*X)+5040

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#FLTVAR_X
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#42
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#210
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#840
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#2520
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#5040
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#5040
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_S1
	jsr	ld_fx_fr1

LINE_30

	; E2=(((((((((((((((8+X)*X)+56)*X)+336)*X)+1680)*X)+6720)*X)+20160)*X)+40320)*X)+40320)/40320

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#FLTVAR_X
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#56
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#336
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#1680
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#6720
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#20160
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#40320
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#40320
	jsr	add_fr1_fr1_pw

	ldd	#40320
	jsr	div_fr1_fr1_pw

	ldx	#FLTVAR_E2
	jsr	ld_fx_fr1

LINE_40

	; E3=(((((((((((((((((9+X)*X)+72)*X)+504)*X)+3024)*X)+15120)*X)+60480)*X)+181440)*X)+362880)*X)+362880)/362880

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#FLTVAR_X
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldab	#72
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#504
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#3024
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#15120
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldd	#60480
	jsr	add_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldx	#INT_181440
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldx	#INT_362880
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_X
	jsr	mul_fr1_fr1_fx

	ldx	#INT_362880
	jsr	add_fr1_fr1_ix

	ldx	#INT_362880
	jsr	div_fr1_fr1_ix

	ldx	#FLTVAR_E3
	jsr	ld_fx_fr1

LINE_98

	; PRINT "S1=";STR$(S1);" \r";

	jsr	pr_ss
	.text	3, "S1="

	ldx	#FLTVAR_S1
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_99

	; E=E0

	ldx	#FLTVAR_E0
	jsr	ld_fr1_fx

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_100

	; E=E1

	ldx	#FLTVAR_E1
	jsr	ld_fr1_fx

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_110

	; E=E2

	ldx	#FLTVAR_E2
	jsr	ld_fr1_fx

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_120

	; E=E3

	ldx	#FLTVAR_E3
	jsr	ld_fr1_fx

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_160

	; PRINT "EXP(X) =";STR$(EXP(X));" \r";

	jsr	pr_ss
	.text	8, "EXP(X) ="

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	jsr	exp_fr1_fr1

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_170

	; PRINT "EXP(Y) =";STR$(EXP(Y));" \r";

	jsr	pr_ss
	.text	8, "EXP(Y) ="

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	jsr	exp_fr1_fr1

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_900

	; GOTO 10

	ldx	#LINE_10
	jsr	goto_ix

LINE_1000

	; PRINT STR$(E);" ->";

	ldx	#FLTVAR_E
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	3, " ->"

LINE_1015

	; IF Z>0 THEN

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_Z
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_1030
	jsr	jmpeq_ir1_ix

	; FOR I=1 TO Z

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldx	#INTVAR_Z
	jsr	to_ip_ix

	; E=SHIFT(E,1)

	ldx	#FLTVAR_E
	jsr	ld_fr1_fx

	ldab	#1
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; NEXT

	jsr	next

LINE_1030

	; IF Z<0 THEN

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_1040
	jsr	jmpeq_ir1_ix

	; FOR I=1 TO -Z

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldx	#INTVAR_Z
	jsr	neg_ir1_ix

	jsr	to_ip_ir1

	; E=SHIFT(E,-1)

	ldx	#FLTVAR_E
	jsr	ld_fr1_fx

	ldab	#-1
	jsr	shift_fr1_fr1_nb

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; NEXT

	jsr	next

LINE_1040

	; PRINT STR$(E);" \r";

	ldx	#FLTVAR_E
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_1050

	; RETURN

	jsr	return

LLAST

	; END

	jsr	progend

	.module	mdarg2x
; copy argv to [X]
;   ENTRY  Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   Y copied to 0,x 1,x 2,x 3,x 4,x
arg2x
	ldab	0+argv
	stab	0,x
	ldd	1+argv
	std	1,x
	ldd	3+argv
	std	3,x
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

	.module	mddivflti
; divide X by Y and mask off fraction
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   INT(X/Y) in (0,x 1,x 2,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
idivflt
	ldaa	#8*3
	bsr	divmod
	tst	tmp4
	bmi	_neg
	ldd	8,x
	comb
	coma
	std	1,x
	ldab	7,x
	comb
	stab	0,x
	rts
_neg
	ldd	3,x
	bne	_copy
	ldd	1,x
	bne	_copy
	ldab	,x
	bne	_copy
	ldd	8,x
	addd	#1
	std	1,x
	ldab	7,x
	adcb	#0
	stab	0,x
	rts
_copy
	ldd	8,x
	std	1,x
	ldab	7,x
	stab	0,x
	rts

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

	.module	mdexp
exp
; X = EXP(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   EXP(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses (5,x 6,x 7,x 8,x 9,x)
;          uses argv and tmp1-tmp4 (tmp4+1 unused)
	ldd	#exp_max
	bsr	dd2argv
	bsr	cmpxa
	bmi	_ok
	ble	_ok
	ldab	#OV_ERROR
	jmp	error
_ok
	ldd	#exp_min
	bsr	dd2argv
	bsr	cmpxa
	bge	_go
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts
cmpxa
	ldd	3,x
	subd	3+argv
	ldd	1,x
	sbcb	2+argv
	sbca	1+argv
	ldab	0,x
	sbcb	0+argv
	rts
dd2argv
	pshx
	pshb
	psha
	pulx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	pulx
	rts
_go
	ldd	#exp_ln2
	bsr	dd2argv
	jsr	modflt
	ldab	9,x
	pshb
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#8
	bsr	_addd
	ldd	#56
	bsr	_mac
	ldd	#336
	bsr	_mac
	ldd	#1680
	bsr	_mac
	ldd	#6720
	bsr	_mac
	ldd	#20160
	bsr	_mac
	ldd	#40320
	bsr	_mac
	ldd	#40320
	bsr	_mac
	ldd	#$A11A
	jsr	rmul315
	pulb
	jmp	shift
_mac
	pshb
	psha
	jsr	mulfltx
	pula
	pulb
_addd
	addd	1,x
	std	1,x
	ldab	0,x
	adcb	#0
	stab	0,x
_rts
	rts
exp_max	.byte	$00,$00,$0F,$F1,$3E
exp_min	.byte	$FF,$FF,$F4,$E8,$DE
exp_ln2	.byte	$00,$00,$00,$B1,$72

	.module	mdgetlt
getlt
	blt	_1
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
	tst	tmp1+1
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

	.module	mdmodflt
; modulo X by Y
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   X%Y in (0,x 1,x 2,x 3,x 4,x)
;          FIX(X/Y) in (7,x 8,x 9,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
modflt
	ldaa	#8*3
	jsr	divmod
	tst	tmp4
	bpl	_rts
	jsr	negx
	ldd	8,x
	addd	#1
	std	8,x
	ldab	7,x
	adcb	#0
	stab	7,x
	rts
_rts
	com	9,x
	com	8,x
	com	7,x
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

	.module	mdprint
print
_loop
	ldaa	,x
	jsr	R_PUTC
	inx
	decb
	bne	_loop
	rts

	.module	mdrmul315
; special routine to divide by 5040 or 40320
;   (reciprocal-multiply by 315 and shifting)
;               1/5040 = 256/315 >> 16
;              1/40320 = 128/315 >> 16
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;          0DD0 or A11A in ACCD
;   EXIT   result in (0,x 1,x 2,x 3,x 4,x)
;          result ~= X/5040 when D is $0DD0
;          result ~= X/40320 when D is $A11A
;          uses argv and tmp1-tmp4 (tmp4+1 unused)
rmul315
	stab	4+argv
	tab
	anda	#$0f
	andb	#$f0
	std	2+argv
	ldd	#0
	std	0+argv
	jsr	mulfltx
	ldd	1,x
	std	3,x
	ldab	0,x
	stab	2,x
	ldd	#0
	std	0,x
	rts

	.module	mdshift
; multiply X by 2^ACCB for ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1
shifti
	clr	3,x
	clr	4,x
shift
	tstb
	beq	_rts
	bpl	shlflt
	negb
	bra	shrflt
_rts
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

add_fr1_fr1_ix			; numCalls = 3
	.module	modadd_fr1_fr1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 8
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_fr1_pw			; numCalls = 21
	.module	modadd_fr1_fr1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_ir1_fx			; numCalls = 5
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

div_fr1_fr1_ix			; numCalls = 1
	.module	moddiv_fr1_fr1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r1
	jmp	divflt

div_fr1_fr1_pw			; numCalls = 3
	.module	moddiv_fr1_fr1_pw
	std	1+argv
	ldd	#0
	stab	0+argv
	std	3+argv
	ldx	#r1
	jmp	divflt

exp_fr1_fr1			; numCalls = 2
	.module	modexp_fr1_fr1
	ldx	#r1
	jmp	exp

for_ix_pb			; numCalls = 2
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 4
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 1
	.module	modgoto_ix
	ins
	ins
	jmp	,x

idiv_ir1_fr1_fx			; numCalls = 1
	.module	modidiv_ir1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	idivflt

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

ld_fr1_fx			; numCalls = 11
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 13
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 1
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 6
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 1
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ix_ir1			; numCalls = 1
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
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

ldlt_ir1_ir1_pb			; numCalls = 1
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

mul_fr1_fr1_fx			; numCalls = 32
	.module	modmul_fr1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
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

neg_ir1_ix			; numCalls = 1
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

next			; numCalls = 2
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

pr_sr1			; numCalls = 8
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 12
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

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

return			; numCalls = 1
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

shift_fr1_fr1_nb			; numCalls = 1
	.module	modshift_fr1_fr1_nb
	ldx	#r1
	negb
	jmp	shrflt

shift_fr1_fr1_pb			; numCalls = 1
	.module	modshift_fr1_fr1_pb
	ldx	#r1
	jmp	shlflt

str_sr1_fr1			; numCalls = 2
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

str_sr1_fx			; numCalls = 5
	.module	modstr_sr1_fx
	ldd	1,x
	std	tmp2
	ldab	0,x
	stab	tmp1+1
	ldd	3,x
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

sub_fr1_fr1_fr2			; numCalls = 1
	.module	modsub_fr1_fr1_fr2
	ldd	r1+3
	subd	r2+3
	std	r1+3
	ldd	r1+1
	sbcb	r2+2
	sbca	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
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

; data table
startdata
enddata


; large integer constants
INT_181440	.byte	$02, $c4, $c0
INT_362880	.byte	$05, $89, $80

; fixed-point constants
FLT_0p69314	.byte	$00, $00, $00, $b1, $72

; block started by symbol
bss

; Numeric Variables
INTVAR_I	.block	3
INTVAR_Z	.block	3
FLTVAR_E	.block	5
FLTVAR_E0	.block	5
FLTVAR_E1	.block	5
FLTVAR_E2	.block	5
FLTVAR_E3	.block	5
FLTVAR_L	.block	5
FLTVAR_S1	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

; Assembly for circle.bas
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

LINE_10

	; REM USING SIN AND COS

LINE_20

	; REM EACH TIME IN LOOP

LINE_30

	; CLS 0

	ldab	#0
	jsr	clsn_pb

LINE_40

	; FOR LO=1 TO 157

	ldx	#INTVAR_LO
	ldab	#1
	jsr	for_ix_pb

	ldab	#157
	jsr	to_ip_pb

LINE_50

	; A+=0.04

	ldx	#FLT_0p03999
	jsr	ld_fr1_fx

	ldx	#FLTVAR_A
	jsr	add_fx_fx_fr1

LINE_60

	; S=

	ldx	#FLTVAR_A
	jsr	ld_fr1_fx

	jsr	sin_fr1_fr1

	ldx	#FLTVAR_S
	jsr	ld_fx_fr1

LINE_70

	; C=

	ldx	#FLTVAR_A
	jsr	ld_fr1_fx

	jsr	cos_fr1_fr1

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

LINE_80

	; SET((25*S)+34,(15*C)+16,5)

	ldab	#25
	jsr	ld_ir1_pb

	ldx	#FLTVAR_S
	jsr	mul_fr1_ir1_fx

	ldab	#34
	jsr	add_fr1_fr1_pb

	ldab	#15
	jsr	ld_ir2_pb

	ldx	#FLTVAR_C
	jsr	mul_fr2_ir2_fx

	ldab	#16
	jsr	add_fr2_fr2_pb

	ldab	#5
	jsr	setc_ir1_ir2_pb

LINE_90

	; NEXT LO

	ldx	#INTVAR_LO
	jsr	nextvar_ix

	jsr	next

LINE_100

	; REM USING ANGLE ADDITION

LINE_110

	; REM FORMULAE FOR SIN AND COS

LINE_120

	; CLS 0

	ldab	#0
	jsr	clsn_pb

LINE_130

	; DS=0.0399893

	ldx	#FLT_0p03999
	jsr	ld_fr1_fx

	ldx	#FLTVAR_DS
	jsr	ld_fx_fr1

LINE_140

	; DC=0.9992

	ldx	#FLT_0p99920
	jsr	ld_fr1_fx

	ldx	#FLTVAR_DC
	jsr	ld_fx_fr1

LINE_150

	; S=DS

	ldx	#FLTVAR_DS
	jsr	ld_fr1_fx

	ldx	#FLTVAR_S
	jsr	ld_fx_fr1

	; C=DC

	ldx	#FLTVAR_DC
	jsr	ld_fr1_fx

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

LINE_160

	; FOR LO=1 TO 157

	ldx	#INTVAR_LO
	ldab	#1
	jsr	for_ix_pb

	ldab	#157
	jsr	to_ip_pb

LINE_170

	; SET((25*S)+34,(15*C)+16,5)

	ldab	#25
	jsr	ld_ir1_pb

	ldx	#FLTVAR_S
	jsr	mul_fr1_ir1_fx

	ldab	#34
	jsr	add_fr1_fr1_pb

	ldab	#15
	jsr	ld_ir2_pb

	ldx	#FLTVAR_C
	jsr	mul_fr2_ir2_fx

	ldab	#16
	jsr	add_fr2_fr2_pb

	ldab	#5
	jsr	setc_ir1_ir2_pb

LINE_180

	; ST=(S*DC)+(C*DS)

	ldx	#FLTVAR_S
	jsr	ld_fr1_fx

	ldx	#FLTVAR_DC
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_C
	jsr	ld_fr2_fx

	ldx	#FLTVAR_DS
	jsr	mul_fr2_fr2_fx

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_ST
	jsr	ld_fx_fr1

LINE_190

	; C=(C*DC)-(S*DS)

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#FLTVAR_DC
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_S
	jsr	ld_fr2_fx

	ldx	#FLTVAR_DS
	jsr	mul_fr2_fr2_fx

	jsr	sub_fr1_fr1_fr2

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

LINE_200

	; S=ST

	ldx	#FLTVAR_ST
	jsr	ld_fr1_fx

	ldx	#FLTVAR_S
	jsr	ld_fx_fr1

LINE_210

	; NEXT LO

	ldx	#INTVAR_LO
	jsr	nextvar_ix

	jsr	next

LINE_300

	; REM USING BRESENHAM'S CIRCLE

LINE_310

	; R=15

	ldx	#INTVAR_R
	ldab	#15
	jsr	ld_ix_pb

LINE_315

	; Y=R

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; X=0

	ldx	#INTVAR_X
	ldab	#0
	jsr	ld_ix_pb

	; A=3-SHIFT(R,1)

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTVAR_R
	jsr	ld_ir2_ix

	ldab	#1
	jsr	shift_ir2_ir2_pb

	jsr	sub_ir1_ir1_ir2

	ldx	#FLTVAR_A
	jsr	ld_fx_ir1

	; CLS 0

	ldab	#0
	jsr	clsn_pb

LINE_320

	; GOSUB 370

	ldx	#LINE_370
	jsr	gosub_ix

	; X+=1

	ldx	#INTVAR_X
	ldab	#1
	jsr	add_ix_ix_pb

	; B=A

	ldx	#FLTVAR_A
	jsr	ld_fr1_fx

	ldx	#FLTVAR_B
	jsr	ld_fx_fr1

	; A+=SHIFT(X,2)+6

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#2
	jsr	shift_ir1_ir1_pb

	ldab	#6
	jsr	add_ir1_ir1_pb

	ldx	#FLTVAR_A
	jsr	add_fx_fx_ir1

	; IF B>0 THEN

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#FLTVAR_B
	jsr	ldlt_ir1_ir1_fx

	ldx	#LINE_325
	jsr	jmpeq_ir1_ix

	; Y-=1

	ldx	#INTVAR_Y
	ldab	#1
	jsr	sub_ix_ix_pb

	; A=SHIFT(X-Y,2)+B+10

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	sub_ir1_ir1_ix

	ldab	#2
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_B
	jsr	add_fr1_ir1_fx

	ldab	#10
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_A
	jsr	ld_fx_fr1

LINE_325

	; WHEN Y>=X GOTO 320

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	ldge_ir1_ir1_ix

	ldx	#LINE_320
	jsr	jmpne_ir1_ix

LINE_330

	; END

	jsr	progend

LINE_370

	; SET(32+X,16+Y,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_Y
	jsr	add_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(32-X,16+Y,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_X
	jsr	sub_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_Y
	jsr	add_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(32+X,16-Y,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_Y
	jsr	sub_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(32-X,16-Y,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_X
	jsr	sub_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_Y
	jsr	sub_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

LINE_375

	; SET(32+Y,16-X,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	add_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_X
	jsr	sub_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(32-Y,16-X,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	sub_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_X
	jsr	sub_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(32+Y,16+X,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	add_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_X
	jsr	add_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(32-Y,16+X,5)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	sub_ir1_ir1_ix

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_X
	jsr	add_ir2_ir2_ix

	ldab	#5
	jsr	setc_ir1_ir2_pb

LINE_380

	; RETURN

	jsr	return

LLAST

	; END

	jsr	progend

	.module	mdcos
cos
	ldd	3,x
	addd	#$9220
	std	3,x
	ldd	1,x
	adcb	#$1
	adca	#0
	std	1,x
	ldab	0,x
	adcb	#0
	stab	0,x
	jmp	sin

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

	.module	mdmodflt
; modulo X by Y
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   X%Y in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
modflt
	ldaa	#8*3
	jsr	divmod
	tst	tmp4
	bpl	_rts
	jmp	negx
_rts
	rts

	.module	mdmulflt
mulfltx
	bsr	mulflt
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts
mulflt
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

	.module	mdprint
print
_loop
	ldaa	,x
	jsr	R_PUTC
	inx
	decb
	bne	_loop
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

	.module	mdsin
sin
	tst	0,x
	bpl	_sinpos
	jsr	negx
	bsr	_sinpos
	jmp	negx
_sinpos
	ldd	#0
	std	0+argv
	ldab	#$6
	stab	2+argv
	ldd	#$487F
	std	3+argv
	jsr	modflt
	bsr	_x2arg
	stx	tmp1
	ldx	#_tbl_pi1
	bsr	_cmptbl
	blo	_q12
	bsr	_subtbl
	bsr	_q12
	jmp	negx
_q12
	ldx	#_tbl_pi2
	bsr	_cmptbl
	blo	_q1
	ldx	#_tbl_pi1
	bsr	_rsubtbl
_q1
	ldx	#_tbl_pi4
	bsr	_cmptbl
	blo	_sin
	ldx	#_tbl_pi2
	bsr	_rsubtbl
	jmp	_cos
; copy x to argv
_x2arg
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	rts
; copy argv to x
_arg2x
	ldab	0+argv
	stab	0,x
	ldd	1+argv
	std	1,x
	ldd	3+argv
	std	3,x
	rts
; compare argv with *x
_cmptbl
	ldd	2+argv
	subd	,x
	bne	_rts
	ldab	4+argv
	subb	2,x
_rts
	rts
; subtract *x from argv
_subtbl
	ldd	3+argv
	subd	1,x
	std	3+argv
	ldab	2+argv
	sbcb	0,x
	stab	2+argv
	rts
; subtract *x from argv then negate
_rsubtbl
	ldd	1,x
	subd	3+argv
	std	3+argv
	ldab	0,x
	sbcb	2+argv
	stab	2+argv
	rts
; sin of angle less than pi/4
_sin
	ldx	tmp1
	bsr	_arg2x
	ldd	3,x
	pshb
	psha
	jsr	mulfltx
	bsr	_x2arg
	ldd	#42
	bsr	_rsubm
	ldd	#840
	bsr	_rsubm
	ldd	#5040
	bsr	_rsub
	pula
	pulb
	std	3+argv
	jsr	mulfltx
	ldd	#5040
	bra	_rdiv
; cos of angle less than pi/4
_cos
	ldx	tmp1
	bsr	_arg2x
	jsr	mulfltx
	bsr	_x2arg
	ldd	#56
	bsr	_rsubm
	ldd	#1680
	bsr	_rsubm
	ldd	#20160
	bsr	_rsubm
	ldd	#40320
	bsr	_rsub
	ldd	#40320
_rdiv
	std	1+argv
	ldd	#0
	stab	0+argv
	std	3+argv
	jmp	divflt
_rsubm
	bsr	_rsub
	jmp	mulfltx
_rsub
	neg	4,x
	ngc	3,x
	sbcb	2,x
	sbca	1,x
	std	1,x
	ngc	0,x
	rts
_tbl_pi1	.byte	$03,$24,$40
_tbl_pi2	.byte	$01,$92,$20
_tbl_pi4	.byte	$00,$C9,$10

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

add_fr1_fr1_fr2			; numCalls = 1
	.module	modadd_fr1_fr1_fr2
	ldd	r1+3
	addd	r2+3
	std	r1+3
	ldd	r1+1
	adcb	r2+2
	adca	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 3
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
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

add_fr2_fr2_pb			; numCalls = 2
	.module	modadd_fr2_fr2_pb
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
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

add_fx_fx_ir1			; numCalls = 1
	.module	modadd_fx_fx_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
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

add_ir1_ir1_pb			; numCalls = 1
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir2_ir2_ix			; numCalls = 4
	.module	modadd_ir2_ir2_ix
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ix_ix_pb			; numCalls = 1
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
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

clsn_pb			; numCalls = 3
	.module	modclsn_pb
	jmp	R_CLSN

cos_fr1_fr1			; numCalls = 1
	.module	modcos_fr1_fr1
	ldx	#r1
	jmp	cos

for_ix_pb			; numCalls = 2
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 1
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

jmpeq_ir1_ix			; numCalls = 1
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

jmpne_ir1_ix			; numCalls = 1
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

ld_fr1_fx			; numCalls = 11
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 2
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 11
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

ld_ir1_ix			; numCalls = 4
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 12
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

ld_ir2_pb			; numCalls = 10
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 1
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 2
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldge_ir1_ir1_ix			; numCalls = 1
	.module	modldge_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getge
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

mul_fr1_fr1_fx			; numCalls = 2
	.module	modmul_fr1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_ir1_fx			; numCalls = 2
	.module	modmul_fr1_ir1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#0
	std	r1+3
	ldx	#r1
	jmp	mulfltx

mul_fr2_fr2_fx			; numCalls = 2
	.module	modmul_fr2_fr2_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r2
	jmp	mulfltx

mul_fr2_ir2_fx			; numCalls = 2
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

nextvar_ix			; numCalls = 2
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
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
error
	jmp	R_ERROR

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

setc_ir1_ir2_pb			; numCalls = 10
	.module	modsetc_ir1_ir2_pb
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

shift_ir1_ir1_pb			; numCalls = 2
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

shift_ir2_ir2_pb			; numCalls = 1
	.module	modshift_ir2_ir2_pb
	ldx	#r2
	jmp	shlint

sin_fr1_fr1			; numCalls = 1
	.module	modsin_fr1_fr1
	ldx	#r1
	jmp	sin

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

sub_ir1_ir1_ir2			; numCalls = 1
	.module	modsub_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

sub_ir1_ir1_ix			; numCalls = 5
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir2_ir2_ix			; numCalls = 4
	.module	modsub_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
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

to_ip_pb			; numCalls = 2
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
enddata

symstart

; fixed-point constants
FLT_0p03999	.byte	$00, $00, $00, $0a, $3d
FLT_0p99920	.byte	$00, $00, $00, $ff, $cc

; block started by symbol
bss

; Numeric Variables
INTVAR_LO	.block	3
INTVAR_R	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
FLTVAR_A	.block	5
FLTVAR_B	.block	5
FLTVAR_C	.block	5
FLTVAR_DC	.block	5
FLTVAR_DS	.block	5
FLTVAR_S	.block	5
FLTVAR_ST	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

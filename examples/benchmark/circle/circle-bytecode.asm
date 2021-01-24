; Assembly for circle.bas
; compiled with mcbasic

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
curinst	.block	2
nxtinst	.block	2
tmp1	.block	2
tmp2	.block	2
tmp3	.block	2
tmp4	.block	2
tmp5	.block	2
argv	.block	10

	.org	M_CODE

	.module	mdmain
	ldx	#program
	stx	nxtinst
mainloop
	ldx	nxtinst
	stx	curinst
	ldab	,x
	ldx	#catalog
	abx
	abx
	ldx	,x
	jsr	0,x
	bra	mainloop

program

	.byte	bytecode_progbegin

	.byte	bytecode_clear

LINE_10

	; REM USING SIN AND COS

LINE_20

	; REM EACH TIME IN LOOP

LINE_30

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

LINE_40

	; FOR LO=1 TO 157

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_LO
	.byte	1

	.byte	bytecode_to_ip_pb
	.byte	157

LINE_50

	; A+=0.04

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLT_0p03999

	.byte	bytecode_add_fx_fx_fr1
	.byte	bytecode_FLTVAR_A

LINE_60

	; S=SIN(A)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_A

	.byte	bytecode_sin_fr1_fr1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_S

LINE_70

	; C=COS(A)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_A

	.byte	bytecode_cos_fr1_fr1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_C

LINE_80

	; SET((25*S)+34,(15*C)+16,5)

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_add_fr1_fr1_pb
	.byte	34

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_add_fr2_fr2_pb
	.byte	16

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

LINE_90

	; NEXT LO

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_LO

	.byte	bytecode_next

LINE_100

	; REM USING ANGLE ADDITION

LINE_110

	; REM FORMULAE FOR SIN AND COS

LINE_120

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

LINE_130

	; DS=0.0399893

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLT_0p03999

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_DS

LINE_140

	; DC=0.9992

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLT_0p99920

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_DC

LINE_150

	; S=DS

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_DS

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_S

	; C=DC

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_DC

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_C

LINE_160

	; FOR LO=1 TO 157

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_LO
	.byte	1

	.byte	bytecode_to_ip_pb
	.byte	157

LINE_170

	; SET((25*S)+34,(15*C)+16,5)

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_add_fr1_fr1_pb
	.byte	34

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_add_fr2_fr2_pb
	.byte	16

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

LINE_180

	; ST=(S*DC)+(C*DS)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_DC

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_mul_fr2_fr2_fx
	.byte	bytecode_FLTVAR_DS

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_ST

LINE_190

	; C=(C*DC)-(S*DS)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_DC

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_mul_fr2_fr2_fx
	.byte	bytecode_FLTVAR_DS

	.byte	bytecode_sub_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_C

LINE_200

	; S=ST

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_ST

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_S

LINE_210

	; NEXT LO

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_LO

	.byte	bytecode_next

LINE_300

	; REM USING BRESENHAM'S CIRCLE

LINE_310

	; R=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_R
	.byte	15

LINE_315

	; Y=R

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; X=0

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	0

	; A=3-SHIFT(R,1)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_shift_ir2_ir2_pb
	.byte	1

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_ld_fx_ir1
	.byte	bytecode_FLTVAR_A

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

LINE_320

	; GOSUB 370

	.byte	bytecode_gosub_ix
	.word	LINE_370

	; X+=1

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	1

	; B=A

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_A

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_B

	; A+=SHIFT(X,2)+6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	6

	.byte	bytecode_add_fx_fx_ir1
	.byte	bytecode_FLTVAR_A

	; IF B>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ldlt_ir1_ir1_fx
	.byte	bytecode_FLTVAR_B

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_325

	; Y-=1

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	1

	; A=SHIFT(X-Y,2)+B+10

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	2

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_B

	.byte	bytecode_add_fr1_fr1_pb
	.byte	10

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

LINE_325

	; WHEN Y>=X GOTO 320

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ldge_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_320

LINE_330

	; END

	.byte	bytecode_progend

LINE_370

	; SET(32+X,16+Y,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-X,16+Y,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32+X,16-Y,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_sub_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-X,16-Y,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_sub_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

LINE_375

	; SET(32+Y,16-X,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_sub_ir2_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-Y,16-X,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_sub_ir2_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32+Y,16+X,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-Y,16+X,5)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

LINE_380

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr1_fr1_fr2	.equ	0
bytecode_add_fr1_fr1_pb	.equ	1
bytecode_add_fr1_ir1_fx	.equ	2
bytecode_add_fr2_fr2_pb	.equ	3
bytecode_add_fx_fx_fr1	.equ	4
bytecode_add_fx_fx_ir1	.equ	5
bytecode_add_ir1_ir1_ix	.equ	6
bytecode_add_ir1_ir1_pb	.equ	7
bytecode_add_ir2_ir2_ix	.equ	8
bytecode_add_ix_ix_pb	.equ	9
bytecode_clear	.equ	10
bytecode_clsn_pb	.equ	11
bytecode_cos_fr1_fr1	.equ	12
bytecode_for_ix_pb	.equ	13
bytecode_gosub_ix	.equ	14
bytecode_jmpeq_ir1_ix	.equ	15
bytecode_jmpne_ir1_ix	.equ	16
bytecode_ld_fr1_fx	.equ	17
bytecode_ld_fr2_fx	.equ	18
bytecode_ld_fx_fr1	.equ	19
bytecode_ld_fx_ir1	.equ	20
bytecode_ld_ir1_ix	.equ	21
bytecode_ld_ir1_pb	.equ	22
bytecode_ld_ir2_ix	.equ	23
bytecode_ld_ir2_pb	.equ	24
bytecode_ld_ix_ir1	.equ	25
bytecode_ld_ix_pb	.equ	26
bytecode_ldge_ir1_ir1_ix	.equ	27
bytecode_ldlt_ir1_ir1_fx	.equ	28
bytecode_mul_fr1_fr1_fx	.equ	29
bytecode_mul_fr1_ir1_fx	.equ	30
bytecode_mul_fr2_fr2_fx	.equ	31
bytecode_mul_fr2_ir2_fx	.equ	32
bytecode_next	.equ	33
bytecode_nextvar_ix	.equ	34
bytecode_progbegin	.equ	35
bytecode_progend	.equ	36
bytecode_return	.equ	37
bytecode_setc_ir1_ir2_pb	.equ	38
bytecode_shift_ir1_ir1_pb	.equ	39
bytecode_shift_ir2_ir2_pb	.equ	40
bytecode_sin_fr1_fr1	.equ	41
bytecode_sub_fr1_fr1_fr2	.equ	42
bytecode_sub_ir1_ir1_ir2	.equ	43
bytecode_sub_ir1_ir1_ix	.equ	44
bytecode_sub_ir2_ir2_ix	.equ	45
bytecode_sub_ix_ix_pb	.equ	46
bytecode_to_ip_pb	.equ	47

catalog
	.word	add_fr1_fr1_fr2
	.word	add_fr1_fr1_pb
	.word	add_fr1_ir1_fx
	.word	add_fr2_fr2_pb
	.word	add_fx_fx_fr1
	.word	add_fx_fx_ir1
	.word	add_ir1_ir1_ix
	.word	add_ir1_ir1_pb
	.word	add_ir2_ir2_ix
	.word	add_ix_ix_pb
	.word	clear
	.word	clsn_pb
	.word	cos_fr1_fr1
	.word	for_ix_pb
	.word	gosub_ix
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	ld_fr1_fx
	.word	ld_fr2_fx
	.word	ld_fx_fr1
	.word	ld_fx_ir1
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ldge_ir1_ir1_ix
	.word	ldlt_ir1_ir1_fx
	.word	mul_fr1_fr1_fx
	.word	mul_fr1_ir1_fx
	.word	mul_fr2_fr2_fx
	.word	mul_fr2_ir2_fx
	.word	next
	.word	nextvar_ix
	.word	progbegin
	.word	progend
	.word	return
	.word	setc_ir1_ir2_pb
	.word	shift_ir1_ir1_pb
	.word	shift_ir2_ir2_pb
	.word	sin_fr1_fr1
	.word	sub_fr1_fr1_fr2
	.word	sub_ir1_ir1_ir2
	.word	sub_ir1_ir1_ix
	.word	sub_ir2_ir2_ix
	.word	sub_ix_ix_pb
	.word	to_ip_pb

	.module	mdbcode
noargs
	ldx	curinst
	inx
	stx	nxtinst
	rts
extend
	ldx	curinst
	inx
	ldab	,x
	inx
	stx	nxtinst
	ldx	#symstart
	abx
	rts
getaddr
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldx	1,x
	rts
getbyte
	ldx	curinst
	inx
	ldab	,x
	inx
	stx	nxtinst
	rts
getword
	ldx	curinst
	inx
	ldd	,x
	inx
	inx
	stx	nxtinst
	rts
extbyte
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	2,x
	pshb
	ldab	1,x
	ldx	#symstart
	abx
	pulb
	rts
extword
	ldd	curinst
	addd	#4
	std	nxtinst
	ldx	curinst
	ldd	2,x
	pshb
	ldab	1,x
	ldx	#symstart
	abx
	pulb
	rts
byteext
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	1,x
	pshb
	ldab	2,x
	ldx	#symstart
	abx
	pulb
	rts
wordext
	ldd	curinst
	addd	#4
	std	nxtinst
	ldx	curinst
	ldd	1,x
	pshb
	ldab	3,x
	ldx	#symstart
	abx
	pulb
	rts
immstr
	ldx	curinst
	inx
	ldab	,x
	inx
	pshx
	abx
	stx	nxtinst
	pulx
	rts

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
	ldd	#$0DD0
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
	ldd	#$A11A
; divide by 5040 or 40320
;  equivalent to multiplying by:
;  13.003174/65536 or 1.625397/65536
;  $0D.00D0/65536 or $01.A01A/65536
_rdiv
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

	.module	mdtobc
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
	ldd	nxtinst
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
	jsr	noargs
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
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_ir1_fx			; numCalls = 1
	.module	modadd_fr1_ir1_fx
	jsr	extend
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
	jsr	getbyte
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_fx_fx_fr1			; numCalls = 1
	.module	modadd_fx_fx_fr1
	jsr	extend
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
	jsr	extend
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ir1_ir1_ix			; numCalls = 4
	.module	modadd_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 1
	.module	modadd_ir1_ir1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir2_ir2_ix			; numCalls = 4
	.module	modadd_ir2_ir2_ix
	jsr	extend
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ix_ix_pb			; numCalls = 1
	.module	modadd_ix_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

clear			; numCalls = 1
	.module	modclear
	jsr	noargs
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
	jsr	getbyte
	jmp	R_CLSN

cos_fr1_fr1			; numCalls = 1
	.module	modcos_fr1_fr1
	jsr	noargs
	ldx	#r1
	jmp	cos

for_ix_pb			; numCalls = 2
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 1
	.module	modgosub_ix
	pulx
	jsr	getaddr
	ldd	nxtinst
	pshb
	psha
	ldab	#3
	pshb
	stx	nxtinst
	jmp	mainloop

jmpeq_ir1_ix			; numCalls = 1
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 1
	.module	modjmpne_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_go
	ldaa	r1
	beq	_rts
_go
	stx	nxtinst
_rts
	rts

ld_fr1_fx			; numCalls = 11
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 2
	.module	modld_fr2_fx
	jsr	extend
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 11
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 1
	.module	modld_fx_ir1
	jsr	extend
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 4
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 12
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 1
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 10
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 1
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 2
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldge_ir1_ir1_ix			; numCalls = 1
	.module	modldge_ir1_ir1_ix
	jsr	extend
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
	jsr	extend
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
	jsr	extend
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
	jsr	extend
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
	jsr	extend
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
	jsr	extend
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
	jsr	noargs
	pulx
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
	stx	nxtinst
	jmp	mainloop
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_idone
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
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
	stx	nxtinst
	jmp	mainloop
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
	stx	nxtinst
	jmp	mainloop
_fdone
	ldab	#15
_done
	abx
	txs
	jmp	mainloop

nextvar_ix			; numCalls = 2
	.module	modnextvar_ix
	jsr	extend
	stx	letptr
	pulx
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
	jmp	mainloop

progbegin			; numCalls = 1
	.module	modprogbegin
	jsr	noargs
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
	jsr	noargs
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
	pulx
	stx	nxtinst
	jmp	mainloop

setc_ir1_ir2_pb			; numCalls = 10
	.module	modsetc_ir1_ir2_pb
	jsr	getbyte
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

shift_ir1_ir1_pb			; numCalls = 2
	.module	modshift_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jmp	shlint

shift_ir2_ir2_pb			; numCalls = 1
	.module	modshift_ir2_ir2_pb
	jsr	getbyte
	ldx	#r2
	jmp	shlint

sin_fr1_fr1			; numCalls = 1
	.module	modsin_fr1_fr1
	jsr	noargs
	ldx	#r1
	jmp	sin

sub_fr1_fr1_fr2			; numCalls = 1
	.module	modsub_fr1_fr1_fr2
	jsr	noargs
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
	jsr	noargs
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

sub_ir1_ir1_ix			; numCalls = 5
	.module	modsub_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir2_ir2_ix			; numCalls = 4
	.module	modsub_ir2_ir2_ix
	jsr	extend
	ldd	r2+1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

sub_ix_ix_pb			; numCalls = 1
	.module	modsub_ix_ix_pb
	jsr	extbyte
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
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
enddata

; Bytecode equates

bytecode_FLT_0p03999	.equ	FLT_0p03999-symstart
bytecode_FLT_0p99920	.equ	FLT_0p99920-symstart

bytecode_INTVAR_LO	.equ	INTVAR_LO-symstart
bytecode_INTVAR_R	.equ	INTVAR_R-symstart
bytecode_INTVAR_X	.equ	INTVAR_X-symstart
bytecode_INTVAR_Y	.equ	INTVAR_Y-symstart
bytecode_FLTVAR_A	.equ	FLTVAR_A-symstart
bytecode_FLTVAR_B	.equ	FLTVAR_B-symstart
bytecode_FLTVAR_C	.equ	FLTVAR_C-symstart
bytecode_FLTVAR_DC	.equ	FLTVAR_DC-symstart
bytecode_FLTVAR_DS	.equ	FLTVAR_DS-symstart
bytecode_FLTVAR_S	.equ	FLTVAR_S-symstart
bytecode_FLTVAR_ST	.equ	FLTVAR_ST-symstart

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

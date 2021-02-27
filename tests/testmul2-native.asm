; Assembly for testmul2-native.bas
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

LINE_0

	; CLS

	jsr	cls

	; DIM W(383),S(7),T(7),E(6),F(6),X(6),Y(6),C(7),T,C,P,X,Y,L,P,Z,M,I$

	ldd	#383
	jsr	ld_ir1_pw

	ldx	#INTARR_W
	jsr	arrdim1_ir1_ix

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrdim1_ir1_ix

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTARR_T
	jsr	arrdim1_ir1_ix

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_E
	jsr	arrdim1_ir1_ix

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_F
	jsr	arrdim1_ir1_ix

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrdim1_ir1_ix

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTARR_C
	jsr	arrdim1_ir1_ix

LINE_10

	; P=1

	ldx	#INTVAR_P
	ldab	#1
	jsr	ld_ix_pb

LINE_20

	; SP=1

	ldx	#INTVAR_SP
	ldab	#1
	jsr	ld_ix_pb

	; TP=8

	ldx	#INTVAR_TP
	ldab	#8
	jsr	ld_ix_pb

	; EP=23

	ldx	#INTVAR_EP
	ldab	#23
	jsr	ld_ix_pb

	; FP=9

	ldx	#INTVAR_FP
	ldab	#9
	jsr	ld_ix_pb

	; XP=ABS(SP-EP)

	ldx	#INTVAR_SP
	jsr	ld_ir1_ix

	ldx	#INTVAR_EP
	jsr	sub_ir1_ir1_ix

	jsr	abs_ir1_ir1

	ldx	#INTVAR_XP
	jsr	ld_ix_ir1

	; YP=RND(40)+-10

	ldab	#40
	jsr	irnd_ir1_pb

	ldab	#-10
	jsr	add_ir1_ir1_nb

	ldx	#INTVAR_YP
	jsr	ld_ix_ir1

LINE_70

	; FOR T=0 TO 1 STEP 0.01

	ldx	#FLTVAR_T
	ldab	#0
	jsr	for_fx_pb

	ldab	#1
	jsr	to_fp_pb

	ldx	#FLT_0p00999
	jsr	ld_fr1_fx

	jsr	step_fp_fr1

LINE_75

	; T1=(1-T)*(1-T)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#FLTVAR_T
	jsr	sub_fr1_ir1_fx

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#FLTVAR_T
	jsr	sub_fr2_ir2_fx

	jsr	mul_fr1_fr1_fr2

	ldx	#FLTVAR_T1
	jsr	ld_fx_fr1

	; T2=SHIFT((1-T)*T,1)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#FLTVAR_T
	jsr	sub_fr1_ir1_fx

	ldx	#FLTVAR_T
	jsr	mul_fr1_fr1_fx

	ldab	#1
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_T2
	jsr	ld_fx_fr1

	; T3=T*T

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTVAR_T
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_T3
	jsr	ld_fx_fr1

LINE_76

	; U=(T1*SP)+(T2*XP)+(T3*EP)

	ldx	#FLTVAR_T1
	jsr	ld_fr1_fx

	ldx	#INTVAR_SP
	jsr	mul_fr1_fr1_ix

	ldx	#FLTVAR_T2
	jsr	ld_fr2_fx

	ldx	#INTVAR_XP
	jsr	mul_fr2_fr2_ix

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_T3
	jsr	ld_fr2_fx

	ldx	#INTVAR_EP
	jsr	mul_fr2_fr2_ix

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_U
	jsr	ld_fx_fr1

LINE_77

	; V=(T1*TP)+(T2*YP)+(T3*FP)

	ldx	#FLTVAR_T1
	jsr	ld_fr1_fx

	ldx	#INTVAR_TP
	jsr	mul_fr1_fr1_ix

	ldx	#FLTVAR_T2
	jsr	ld_fr2_fx

	ldx	#INTVAR_YP
	jsr	mul_fr2_fr2_ix

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_T3
	jsr	ld_fr2_fx

	ldx	#INTVAR_FP
	jsr	mul_fr2_fr2_ix

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_V
	jsr	ld_fx_fr1

LINE_80

	; X=((1-T)*(1-T)*SP)+SHIFT((1-T)*T*XP,1)+(T*T*EP)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#FLTVAR_T
	jsr	sub_fr1_ir1_fx

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#FLTVAR_T
	jsr	sub_fr2_ir2_fx

	jsr	mul_fr1_fr1_fr2

	ldx	#INTVAR_SP
	jsr	mul_fr1_fr1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#FLTVAR_T
	jsr	sub_fr2_ir2_fx

	ldx	#FLTVAR_T
	jsr	mul_fr2_fr2_fx

	ldx	#INTVAR_XP
	jsr	mul_fr2_fr2_ix

	ldab	#1
	jsr	shift_fr2_fr2_pb

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTVAR_T
	jsr	mul_fr2_fr2_fx

	ldx	#INTVAR_EP
	jsr	mul_fr2_fr2_ix

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

LINE_90

	; Y=((1-T)*(1-T)*TP)+SHIFT((1-T)*T*YP,1)+(T*T*FP)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#FLTVAR_T
	jsr	sub_fr1_ir1_fx

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#FLTVAR_T
	jsr	sub_fr2_ir2_fx

	jsr	mul_fr1_fr1_fr2

	ldx	#INTVAR_TP
	jsr	mul_fr1_fr1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#FLTVAR_T
	jsr	sub_fr2_ir2_fx

	ldx	#FLTVAR_T
	jsr	mul_fr2_fr2_fx

	ldx	#INTVAR_YP
	jsr	mul_fr2_fr2_ix

	ldab	#1
	jsr	shift_fr2_fr2_pb

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTVAR_T
	jsr	mul_fr2_fr2_fx

	ldx	#INTVAR_FP
	jsr	mul_fr2_fr2_ix

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_Y
	jsr	ld_fx_fr1

LINE_100

	; PRINT STR$(X);" ";STR$(Y);" "

	ldx	#FLTVAR_X
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_Y
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_105

	; PRINT STR$(U);" ";STR$(V);" "

	ldx	#FLTVAR_U
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_V
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_125

	; WHEN INKEY$="" GOTO 125

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_125
	jsr	jmpne_ir1_ix

LINE_130

	; NEXT

	jsr	next

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
	bsr	negx
_posX
	tst	0+argv
	bpl	divumod
	com	tmp4
	bsr	negargv
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

	.module	mdprint
print
_loop
	ldaa	,x
	jsr	R_PUTC
	inx
	decb
	bne	_loop
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
	neg	tmp3+1
	ngc	tmp3
	ngc	tmp2+1
	ngc	tmp2
	ngc	tmp1+1
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

abs_ir1_ir1			; numCalls = 1
	.module	modabs_ir1_ir1
	ldaa	r1
	bpl	_rts
	neg	r1+2
	ngc	r1+1
	ngc	r1
_rts
	rts

add_fr1_fr1_fr2			; numCalls = 8
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

add_ir1_ir1_nb			; numCalls = 1
	.module	modadd_ir1_ir1_nb
	ldaa	#-1
	addd	r1+1
	std	r1+1
	ldab	#-1
	adcb	r1
	stab	r1
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

cls			; numCalls = 1
	.module	modcls
	jmp	R_CLS

for_fx_pb			; numCalls = 1
	.module	modfor_fx_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
	rts

inkey_sr1			; numCalls = 1
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

irnd_ir1_pb			; numCalls = 1
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
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

ld_fr1_fx			; numCalls = 4
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 6
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 7
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

ld_ir1_pb			; numCalls = 11
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir1_pw			; numCalls = 1
	.module	modld_ir1_pw
	std	r1+1
	ldab	#0
	stab	r1
	rts

ld_ir2_pb			; numCalls = 5
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

ld_ix_pb			; numCalls = 5
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldeq_ir1_sr1_ss			; numCalls = 1
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

mul_fr1_fr1_fr2			; numCalls = 3
	.module	modmul_fr1_fr1_fr2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldd	r2+3
	std	3+argv
	ldx	#r1
	jmp	mulfltx

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

mul_fr1_fr1_ix			; numCalls = 4
	.module	modmul_fr1_fr1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr2_fr2_fx			; numCalls = 4
	.module	modmul_fr2_fr2_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r2
	jmp	mulfltx

mul_fr2_fr2_ix			; numCalls = 8
	.module	modmul_fr2_fr2_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r2
	jmp	mulfltx

next			; numCalls = 1
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

pr_ss			; numCalls = 4
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

shift_fr1_fr1_pb			; numCalls = 1
	.module	modshift_fr1_fr1_pb
	ldx	#r1
	jmp	shlflt

shift_fr2_fr2_pb			; numCalls = 2
	.module	modshift_fr2_fr2_pb
	ldx	#r2
	jmp	shlflt

step_fp_fr1			; numCalls = 1
	.module	modstep_fp_fr1
	tsx
	ldab	r1
	stab	12,x
	ldd	r1+1
	std	13,x
	ldd	r1+3
	std	15,x
	ldd	,x
	std	5,x
	rts

str_sr1_fx			; numCalls = 4
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

sub_fr1_ir1_fx			; numCalls = 4
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

sub_fr2_ir2_fx			; numCalls = 5
	.module	modsub_fr2_ir2_fx
	ldd	#0
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

sub_ir1_ir1_ix			; numCalls = 1
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

to_fp_pb			; numCalls = 1
	.module	modto_fp_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

; data table
startdata
enddata

symstart

; fixed-point constants
FLT_0p00999	.byte	$00, $00, $00, $02, $8f

; block started by symbol
bss

; Numeric Variables
INTVAR_C	.block	3
INTVAR_EP	.block	3
INTVAR_FP	.block	3
INTVAR_L	.block	3
INTVAR_M	.block	3
INTVAR_P	.block	3
INTVAR_SP	.block	3
INTVAR_TP	.block	3
INTVAR_XP	.block	3
INTVAR_YP	.block	3
INTVAR_Z	.block	3
FLTVAR_T	.block	5
FLTVAR_T1	.block	5
FLTVAR_T2	.block	5
FLTVAR_T3	.block	5
FLTVAR_U	.block	5
FLTVAR_V	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
STRVAR_I	.block	3
; Numeric Arrays
INTARR_C	.block	4	; dims=1
INTARR_E	.block	4	; dims=1
INTARR_F	.block	4	; dims=1
INTARR_S	.block	4	; dims=1
INTARR_T	.block	4	; dims=1
INTARR_W	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

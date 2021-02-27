; Assembly for testsqr-bytecode.bas
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
r3	.block	5
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

	; PRINT "ENTER SQ AND INIT SQR ESTIMATE"

	.byte	bytecode_pr_ss
	.text	31, "ENTER SQ AND INIT SQR ESTIMATE\r"

LINE_20

	; INPUT S,X

	.byte	bytecode_input

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ignxtra

LINE_30

	; GOSUB 100

	.byte	bytecode_gosub_ix
	.word	LINE_100

LINE_40

	; PRINT "SQRT=";STR$(SQR(S));" "

	.byte	bytecode_pr_ss
	.text	5, "SQRT="

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_sqr_fr1_fr1

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_50

	; GOTO 10

	.byte	bytecode_goto_ix
	.word	LINE_10

LINE_100

	; M=1024

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_M
	.word	1024

	; Y=M/X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_div_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_Y

	; PRINT "S=";STR$(S);" X=";STR$(X);" Y=";STR$(Y);" "

	.byte	bytecode_pr_ss
	.text	2, "S="

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	3, " X="

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	3, " Y="

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_110

	; FOR I=1 TO 10

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_I
	.byte	1

	.byte	bytecode_to_ip_pb
	.byte	10

LINE_120

	; X=SHIFT((S/X)+X,-1)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_div_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_shift_fr1_fr1_nb
	.byte	-1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_X

	; Y=SHIFT((3-(Y*Y*S/M/M))*Y,-1)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_mul_fr2_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_mul_fr2_fr2_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_div_fr2_fr2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_div_fr2_fr2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_sub_fr1_ir1_fr2

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_shift_fr1_fr1_nb
	.byte	-1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_Y

LINE_130

	; PRINT STR$(I);" ";STR$(X);" ";STR$(S*Y/M);" "

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_div_fr1_fr1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_140

	; NEXT I

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_next

LINE_150

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr1_fr1_fx	.equ	0
bytecode_clear	.equ	1
bytecode_div_fr1_fr1_fx	.equ	2
bytecode_div_fr1_fr1_ix	.equ	3
bytecode_div_fr1_ir1_fx	.equ	4
bytecode_div_fr2_fr2_ix	.equ	5
bytecode_for_ix_pb	.equ	6
bytecode_gosub_ix	.equ	7
bytecode_goto_ix	.equ	8
bytecode_ignxtra	.equ	9
bytecode_input	.equ	10
bytecode_ld_fr1_fx	.equ	11
bytecode_ld_fr2_fx	.equ	12
bytecode_ld_fx_fr1	.equ	13
bytecode_ld_ir1_ix	.equ	14
bytecode_ld_ir1_pb	.equ	15
bytecode_ld_ix_pw	.equ	16
bytecode_mul_fr1_fr1_fx	.equ	17
bytecode_mul_fr2_fr2_fx	.equ	18
bytecode_next	.equ	19
bytecode_nextvar_ix	.equ	20
bytecode_pr_sr1	.equ	21
bytecode_pr_ss	.equ	22
bytecode_progbegin	.equ	23
bytecode_progend	.equ	24
bytecode_readbuf_fx	.equ	25
bytecode_return	.equ	26
bytecode_shift_fr1_fr1_nb	.equ	27
bytecode_sqr_fr1_fr1	.equ	28
bytecode_str_sr1_fr1	.equ	29
bytecode_str_sr1_fx	.equ	30
bytecode_str_sr1_ix	.equ	31
bytecode_sub_fr1_ir1_fr2	.equ	32
bytecode_to_ip_pb	.equ	33

catalog
	.word	add_fr1_fr1_fx
	.word	clear
	.word	div_fr1_fr1_fx
	.word	div_fr1_fr1_ix
	.word	div_fr1_ir1_fx
	.word	div_fr2_fr2_ix
	.word	for_ix_pb
	.word	gosub_ix
	.word	goto_ix
	.word	ignxtra
	.word	input
	.word	ld_fr1_fx
	.word	ld_fr2_fx
	.word	ld_fx_fr1
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ix_pw
	.word	mul_fr1_fr1_fx
	.word	mul_fr2_fr2_fx
	.word	next
	.word	nextvar_ix
	.word	pr_sr1
	.word	pr_ss
	.word	progbegin
	.word	progend
	.word	readbuf_fx
	.word	return
	.word	shift_fr1_fr1_nb
	.word	sqr_fr1_fr1
	.word	str_sr1_fr1
	.word	str_sr1_fx
	.word	str_sr1_ix
	.word	sub_fr1_ir1_fr2
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

	.module	mdmsbit
; ACCA = MSBit(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   most siginficant bit in ACCA
;          0 = sign bit, 39 = LSB. 40 if zero
msbit
	pshx
	clra
_nxtbyte
	ldab	,x
	bne	_dobit
	adda	#8
	inx
	cmpa	#40
	blo	_nxtbyte
_rts
	pulx
	rts
_dobit
	lslb
	bcs	_rts
	inca
	bra	_dobit

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

	.module	mdsqr
; X = SQR(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   SQRT(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses ( 5,x  6,x  7,x  8,x  9,x)
;          uses (10,x 11,x 12,x 13,x 14,x)
;          uses (15,x 16,x 17,x 18,x 19,x)
;          uses argv for guess and tmp1-tmp4
sqr
	jsr	msbit
	cmpa	#40
	bne	_chkpos
	rts
_chkpos
	tsta
	bne	_pos
	ldab	#FC_ERROR
	jmp	error
_pos
	pshx
	eora	#1
	lsra
	rol	tmp1
	adda	#12
	ldx	#argv
	clrb
_nxtargv
	stab	,x
	inx
	suba	#8
	bhs	_nxtargv
	adda	#8
	dex
	lsr	tmp1
	rorb
	rorb
	orab	#$80
	tsta
	beq	_setargb
_nxtargb
	lsrb
	deca
	bne	_nxtargb
_setargb
	stab	,x
	clrb
_more
	inx
	stab	,x
	cpx	#5+argv
	blo	_more
	; Newton-Raphson step
	; WHILE AND(X/ARGV-X, NOT 1)
	;      X = (X/ARGV + X)/2
	; WEND
_newton
	pulx
	ldab	0,x
	stab	5,x
	ldd	1,x
	std	6,x
	ldd	3,x
	std	8,x
	pshx
	ldab	#5
	abx
	jsr	divflt
	ldd	0,x
	subd	0+argv
	bne	_avg
	ldd	2,x
	subd	2+argv
	bne	_avg
	ldab	4,x
	subb	4+argv
	andb	#$FE
	bne	_avg
	pulx
	ldab	0+argv
	stab	0,x
	ldd	1+argv
	std	1,x
	ldd	3+argv
	std	3,x
	rts
_avg
	ldd	3,x
	addd	3+argv
	std	3+argv
	ldd	1,x
	adcb	2+argv
	adca	1+argv
	std	1+argv
	ldab	0,x
	adcb	0+argv
	lsrb
	stab	0+argv
	ror	1+argv
	ror	2+argv
	ror	3+argv
	ror	4+argv
	bra	_newton

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

	.module	mdtobc
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

add_fr1_fr1_fx			; numCalls = 1
	.module	modadd_fr1_fr1_fx
	jsr	extend
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

div_fr1_fr1_fx			; numCalls = 1
	.module	moddiv_fr1_fr1_fx
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	divflt

div_fr1_fr1_ix			; numCalls = 1
	.module	moddiv_fr1_fr1_ix
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r1
	jmp	divflt

div_fr1_ir1_fx			; numCalls = 1
	.module	moddiv_fr1_ir1_fx
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
	jmp	divflt

div_fr2_fr2_ix			; numCalls = 2
	.module	moddiv_fr2_fr2_ix
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r2
	jmp	divflt

for_ix_pb			; numCalls = 1
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

goto_ix			; numCalls = 1
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

ignxtra			; numCalls = 1
	.module	modignxtra
	jsr	noargs
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
	jsr	noargs
	ldx	curinst
	stx	redoptr
	jmp	inputqs

ld_fr1_fx			; numCalls = 3
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 1
	.module	modld_fr2_fx
	jsr	extend
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 3
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 1
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 1
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
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

next			; numCalls = 1
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

nextvar_ix			; numCalls = 1
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

pr_sr1			; numCalls = 7
	.module	modpr_sr1
	jsr	noargs
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
	ldx	curinst
	inx
	ldab	,x
	beq	_null
	inx
	jsr	print
	stx	nxtinst
	rts
_null
	inx
	stx	nxtinst
	rts

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
OV_ERROR	.equ	10
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
LS_ERROR	.equ	28
error
	jmp	R_ERROR

readbuf_fx			; numCalls = 2
	.module	modreadbuf_fx
	jsr	extend
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
	stx	nxtinst
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
	pulx
	stx	nxtinst
	jmp	mainloop

shift_fr1_fr1_nb			; numCalls = 2
	.module	modshift_fr1_fr1_nb
	jsr	getbyte
	ldx	#r1
	negb
	jmp	shrflt

sqr_fr1_fr1			; numCalls = 1
	.module	modsqr_fr1_fr1
	jsr	noargs
	ldx	#r1
	jmp	sqr

str_sr1_fr1			; numCalls = 2
	.module	modstr_sr1_fr1
	jsr	noargs
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

str_sr1_fx			; numCalls = 4
	.module	modstr_sr1_fx
	jsr	extend
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
	jsr	extend
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

sub_fr1_ir1_fr2			; numCalls = 1
	.module	modsub_fr1_ir1_fr2
	jsr	noargs
	ldd	#0
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

to_ip_pb			; numCalls = 1
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


bytecode_INTVAR_I	.equ	INTVAR_I-symstart
bytecode_INTVAR_M	.equ	INTVAR_M-symstart
bytecode_FLTVAR_S	.equ	FLTVAR_S-symstart
bytecode_FLTVAR_X	.equ	FLTVAR_X-symstart
bytecode_FLTVAR_Y	.equ	FLTVAR_Y-symstart

symstart

; block started by symbol
bss

; Numeric Variables
INTVAR_I	.block	3
INTVAR_M	.block	3
FLTVAR_S	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

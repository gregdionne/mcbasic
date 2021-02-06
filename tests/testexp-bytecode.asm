; Assembly for testexp.bas
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

	; INPUT "ENTER Y"; Y

	.byte	bytecode_pr_ss
	.text	7, "ENTER Y"

	.byte	bytecode_input

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_ignxtra

LINE_11

	; L=0.693147

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLT_0p69314

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_L

LINE_12

	; Z=INT(Y/L)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_div_fr1_fr1_fx
	.byte	bytecode_FLTVAR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

LINE_13

	; X=Y-(Z*L)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_L

	.byte	bytecode_sub_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_X

LINE_14

	; PRINT STR$(Y);"  = ";STR$(Z);" L";STR$(X);" "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	4, "  = "

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " L"

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_19

	; E0=(((((((((((6+X)*X)+30)*X)+120)*X)+360)*X)+720)*X)+720)/720

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	30

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	120

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	360

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	720

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	720

	.byte	bytecode_div_fr1_fr1_pw
	.word	720

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E0

LINE_20

	; E1=(((((((((((((7+X)*X)+42)*X)+210)*X)+840)*X)+2520)*X)+5040)*X)+5040)/5040

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	42

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	210

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	840

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	2520

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	5040

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	5040

	.byte	bytecode_div_fr1_fr1_pw
	.word	5040

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E1

LINE_21

	; S1=((((((((((((7+X)*X)+42)*X)+210)*X)+840)*X)+2520)*X)+5040)*X)+5040

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	42

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	210

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	840

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	2520

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	5040

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	5040

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_S1

LINE_30

	; E2=(((((((((((((((8+X)*X)+56)*X)+336)*X)+1680)*X)+6720)*X)+20160)*X)+40320)*X)+40320)/40320

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	56

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	336

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	1680

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	6720

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	20160

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	40320

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	40320

	.byte	bytecode_div_fr1_fr1_pw
	.word	40320

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E2

LINE_40

	; E3=(((((((((((((((((9+X)*X)+72)*X)+504)*X)+3024)*X)+15120)*X)+60480)*X)+181440)*X)+362880)*X)+362880)/362880

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	72

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	504

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	3024

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	15120

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pw
	.word	60480

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INT_181440

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INT_362880

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INT_362880

	.byte	bytecode_div_fr1_fr1_ix
	.byte	bytecode_INT_362880

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E3

LINE_98

	; PRINT "S1=";STR$(S1);" "

	.byte	bytecode_pr_ss
	.text	3, "S1="

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_S1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_99

	; E=E0

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_E0

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_100

	; E=E1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_E1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_110

	; E=E2

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_E2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_120

	; E=E3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_E3

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_160

	; PRINT "EXP(X) =";STR$(EXP(X));" "

	.byte	bytecode_pr_ss
	.text	8, "EXP(X) ="

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_exp_fr1_fr1

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_170

	; PRINT "EXP(Y) =";STR$(EXP(Y));" "

	.byte	bytecode_pr_ss
	.text	8, "EXP(Y) ="

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_exp_fr1_fr1

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_900

	; GOTO 10

	.byte	bytecode_goto_ix
	.word	LINE_10

LINE_1000

	; PRINT STR$(E);" ->";

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_E

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	3, " ->"

LINE_1015

	; IF Z>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1030

	; FOR I=1 TO Z

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_I
	.byte	1

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_Z

	; E=SHIFT(E,1)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_E

	.byte	bytecode_shift_fr1_fr1_pb
	.byte	1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E

	; NEXT

	.byte	bytecode_next

LINE_1030

	; IF Z<0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1040

	; FOR I=1 TO -Z

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_I
	.byte	1

	.byte	bytecode_neg_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_ir1

	; E=SHIFT(E,-1)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_E

	.byte	bytecode_shift_fr1_fr1_nb
	.byte	1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_E

	; NEXT

	.byte	bytecode_next

LINE_1040

	; PRINT STR$(E);" "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_E

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_1050

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr1_fr1_ix	.equ	0
bytecode_add_fr1_fr1_pb	.equ	1
bytecode_add_fr1_fr1_pw	.equ	2
bytecode_add_fr1_ir1_fx	.equ	3
bytecode_clear	.equ	4
bytecode_div_fr1_fr1_fx	.equ	5
bytecode_div_fr1_fr1_ix	.equ	6
bytecode_div_fr1_fr1_pw	.equ	7
bytecode_exp_fr1_fr1	.equ	8
bytecode_for_ix_pb	.equ	9
bytecode_gosub_ix	.equ	10
bytecode_goto_ix	.equ	11
bytecode_ignxtra	.equ	12
bytecode_input	.equ	13
bytecode_jmpeq_ir1_ix	.equ	14
bytecode_ld_fr1_fx	.equ	15
bytecode_ld_fx_fr1	.equ	16
bytecode_ld_ir1_ix	.equ	17
bytecode_ld_ir1_pb	.equ	18
bytecode_ld_ir2_ix	.equ	19
bytecode_ld_ix_ir1	.equ	20
bytecode_ldlt_ir1_ir1_ix	.equ	21
bytecode_ldlt_ir1_ir1_pb	.equ	22
bytecode_mul_fr1_fr1_fx	.equ	23
bytecode_mul_fr2_ir2_fx	.equ	24
bytecode_neg_ir1_ix	.equ	25
bytecode_next	.equ	26
bytecode_pr_sr1	.equ	27
bytecode_pr_ss	.equ	28
bytecode_progbegin	.equ	29
bytecode_progend	.equ	30
bytecode_readbuf_fx	.equ	31
bytecode_return	.equ	32
bytecode_shift_fr1_fr1_nb	.equ	33
bytecode_shift_fr1_fr1_pb	.equ	34
bytecode_str_sr1_fr1	.equ	35
bytecode_str_sr1_fx	.equ	36
bytecode_str_sr1_ix	.equ	37
bytecode_sub_fr1_fr1_fr2	.equ	38
bytecode_to_ip_ir1	.equ	39
bytecode_to_ip_ix	.equ	40

catalog
	.word	add_fr1_fr1_ix
	.word	add_fr1_fr1_pb
	.word	add_fr1_fr1_pw
	.word	add_fr1_ir1_fx
	.word	clear
	.word	div_fr1_fr1_fx
	.word	div_fr1_fr1_ix
	.word	div_fr1_fr1_pw
	.word	exp_fr1_fr1
	.word	for_ix_pb
	.word	gosub_ix
	.word	goto_ix
	.word	ignxtra
	.word	input
	.word	jmpeq_ir1_ix
	.word	ld_fr1_fx
	.word	ld_fx_fr1
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ix_ir1
	.word	ldlt_ir1_ir1_ix
	.word	ldlt_ir1_ir1_pb
	.word	mul_fr1_fr1_fx
	.word	mul_fr2_ir2_fx
	.word	neg_ir1_ix
	.word	next
	.word	pr_sr1
	.word	pr_ss
	.word	progbegin
	.word	progend
	.word	readbuf_fx
	.word	return
	.word	shift_fr1_fr1_nb
	.word	shift_fr1_fr1_pb
	.word	str_sr1_fr1
	.word	str_sr1_fx
	.word	str_sr1_ix
	.word	sub_fr1_fr1_fr2
	.word	to_ip_ir1
	.word	to_ip_ix

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

add_fr1_fr1_ix			; numCalls = 3
	.module	modadd_fr1_fr1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 8
	.module	modadd_fr1_fr1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_fr1_pw			; numCalls = 21
	.module	modadd_fr1_fr1_pw
	jsr	getword
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_ir1_fx			; numCalls = 5
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

div_fr1_fr1_pw			; numCalls = 3
	.module	moddiv_fr1_fr1_pw
	jsr	getword
	std	1+argv
	ldd	#0
	stab	0+argv
	std	3+argv
	ldx	#r1
	jmp	divflt

exp_fr1_fr1			; numCalls = 2
	.module	modexp_fr1_fr1
	jsr	noargs
	ldx	#r1
	jmp	exp

for_ix_pb			; numCalls = 2
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 4
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

jmpeq_ir1_ix			; numCalls = 2
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
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

ld_fx_fr1			; numCalls = 13
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

ld_ir1_pb			; numCalls = 6
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

ld_ix_ir1			; numCalls = 1
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ldlt_ir1_ir1_ix			; numCalls = 1
	.module	modldlt_ir1_ir1_ix
	jsr	extend
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
	jsr	getbyte
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
	jsr	extend
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

neg_ir1_ix			; numCalls = 1
	.module	modneg_ir1_ix
	jsr	extend
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

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

pr_sr1			; numCalls = 8
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

pr_ss			; numCalls = 12
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

readbuf_fx			; numCalls = 1
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

shift_fr1_fr1_nb			; numCalls = 1
	.module	modshift_fr1_fr1_nb
	jsr	getbyte
	ldx	#r1
	jmp	shrflt

shift_fr1_fr1_pb			; numCalls = 1
	.module	modshift_fr1_fr1_pb
	jsr	getbyte
	ldx	#r1
	jmp	shlflt

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

str_sr1_fx			; numCalls = 5
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

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
	jsr	noargs
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_ix			; numCalls = 1
	.module	modto_ip_ix
	jsr	extend
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

; Bytecode equates

bytecode_INT_181440	.equ	INT_181440-symstart
bytecode_INT_362880	.equ	INT_362880-symstart
bytecode_FLT_0p69314	.equ	FLT_0p69314-symstart

bytecode_INTVAR_I	.equ	INTVAR_I-symstart
bytecode_INTVAR_Z	.equ	INTVAR_Z-symstart
bytecode_FLTVAR_E	.equ	FLTVAR_E-symstart
bytecode_FLTVAR_E0	.equ	FLTVAR_E0-symstart
bytecode_FLTVAR_E1	.equ	FLTVAR_E1-symstart
bytecode_FLTVAR_E2	.equ	FLTVAR_E2-symstart
bytecode_FLTVAR_E3	.equ	FLTVAR_E3-symstart
bytecode_FLTVAR_L	.equ	FLTVAR_L-symstart
bytecode_FLTVAR_S1	.equ	FLTVAR_S1-symstart
bytecode_FLTVAR_X	.equ	FLTVAR_X-symstart
bytecode_FLTVAR_Y	.equ	FLTVAR_Y-symstart

symstart

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

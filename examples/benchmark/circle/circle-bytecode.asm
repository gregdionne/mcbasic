; Assembly for circle-bytecode.bas
; compiled with mcbasic

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
R_PUTC	.equ	$F9C6	; write ACCA to console
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
curinst	.block	2
nxtinst	.block	2
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

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_LO

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

	; SET((S*25)+34,(C*15)+16,5)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	25

	.byte	bytecode_add_fr1_fr1_pb
	.byte	34

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_mul_fr2_fr2_pb
	.byte	15

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

	; DS=0.039989

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_DS
	.byte	bytecode_FLT_0p03999

LINE_140

	; DC=0.9992

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_DC
	.byte	bytecode_FLT_0p99920

LINE_150

	; S=DS

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_S
	.byte	bytecode_FLTVAR_DS

	; C=DC

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_C
	.byte	bytecode_FLTVAR_DC

LINE_160

	; FOR LO=1 TO 157

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_LO

	.byte	bytecode_to_ip_pb
	.byte	157

LINE_170

	; SET((S*25)+34,(C*15)+16,5)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_S

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	25

	.byte	bytecode_add_fr1_fr1_pb
	.byte	34

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_mul_fr2_fr2_pb
	.byte	15

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

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_S
	.byte	bytecode_FLTVAR_ST

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

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_R

	; X=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_X

	; A=3-SHIFT(R,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	3

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

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_X

	; B=A

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_B
	.byte	bytecode_FLTVAR_A

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

	.byte	bytecode_ldlt_ir1_pb_fx
	.byte	0
	.byte	bytecode_FLTVAR_B

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_325

	; Y-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_Y

	; A=SHIFT(X-Y,2)+B+10

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_X
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

	.byte	bytecode_ldge_ir1_ix_id
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_320

LINE_330

	; END

	.byte	bytecode_progend

LINE_370

	; SET(X+32,Y+16,5)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	32

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	16

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-X,Y+16,5)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	32
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	16

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(X+32,16-Y,5)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	32

	.byte	bytecode_sub_ir2_pb_ix
	.byte	16
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-X,16-Y,5)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	32
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sub_ir2_pb_ix
	.byte	16
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

LINE_375

	; SET(Y+32,16-X,5)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	32

	.byte	bytecode_sub_ir2_pb_ix
	.byte	16
	.byte	bytecode_INTVAR_X

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-Y,16-X,5)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	32
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_sub_ir2_pb_ix
	.byte	16
	.byte	bytecode_INTVAR_X

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(Y+32,X+16,5)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	32

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	16

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; SET(32-Y,X+16,5)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	32
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	16

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
bytecode_add_ir1_ir1_pb	.equ	6
bytecode_add_ir1_ix_pb	.equ	7
bytecode_add_ir2_ix_pb	.equ	8
bytecode_clear	.equ	9
bytecode_clr_ix	.equ	10
bytecode_clsn_pb	.equ	11
bytecode_cos_fr1_fr1	.equ	12
bytecode_dbl_ir1_ix	.equ	13
bytecode_dec_ix_ix	.equ	14
bytecode_forone_ix	.equ	15
bytecode_gosub_ix	.equ	16
bytecode_inc_ix_ix	.equ	17
bytecode_jmpeq_ir1_ix	.equ	18
bytecode_jmpne_ir1_ix	.equ	19
bytecode_ld_fd_fx	.equ	20
bytecode_ld_fr1_fx	.equ	21
bytecode_ld_fr2_fx	.equ	22
bytecode_ld_fx_fr1	.equ	23
bytecode_ld_fx_ir1	.equ	24
bytecode_ld_id_ix	.equ	25
bytecode_ld_ir1_ix	.equ	26
bytecode_ld_ix_pb	.equ	27
bytecode_ldge_ir1_ix_id	.equ	28
bytecode_ldlt_ir1_pb_fx	.equ	29
bytecode_mul_fr1_fr1_fx	.equ	30
bytecode_mul_fr1_fr1_pb	.equ	31
bytecode_mul_fr2_fr2_fx	.equ	32
bytecode_mul_fr2_fr2_pb	.equ	33
bytecode_next	.equ	34
bytecode_nextvar_ix	.equ	35
bytecode_progbegin	.equ	36
bytecode_progend	.equ	37
bytecode_return	.equ	38
bytecode_rsub_ir1_ir1_pb	.equ	39
bytecode_setc_ir1_ir2_pb	.equ	40
bytecode_shift_ir1_ir1_pb	.equ	41
bytecode_sin_fr1_fr1	.equ	42
bytecode_sub_fr1_fr1_fr2	.equ	43
bytecode_sub_ir1_ix_id	.equ	44
bytecode_sub_ir1_pb_ix	.equ	45
bytecode_sub_ir2_pb_ix	.equ	46
bytecode_to_ip_pb	.equ	47

catalog
	.word	add_fr1_fr1_fr2
	.word	add_fr1_fr1_pb
	.word	add_fr1_ir1_fx
	.word	add_fr2_fr2_pb
	.word	add_fx_fx_fr1
	.word	add_fx_fx_ir1
	.word	add_ir1_ir1_pb
	.word	add_ir1_ix_pb
	.word	add_ir2_ix_pb
	.word	clear
	.word	clr_ix
	.word	clsn_pb
	.word	cos_fr1_fr1
	.word	dbl_ir1_ix
	.word	dec_ix_ix
	.word	forone_ix
	.word	gosub_ix
	.word	inc_ix_ix
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	ld_fd_fx
	.word	ld_fr1_fx
	.word	ld_fr2_fx
	.word	ld_fx_fr1
	.word	ld_fx_ir1
	.word	ld_id_ix
	.word	ld_ir1_ix
	.word	ld_ix_pb
	.word	ldge_ir1_ix_id
	.word	ldlt_ir1_pb_fx
	.word	mul_fr1_fr1_fx
	.word	mul_fr1_fr1_pb
	.word	mul_fr2_fr2_fx
	.word	mul_fr2_fr2_pb
	.word	next
	.word	nextvar_ix
	.word	progbegin
	.word	progend
	.word	return
	.word	rsub_ir1_ir1_pb
	.word	setc_ir1_ir2_pb
	.word	shift_ir1_ir1_pb
	.word	sin_fr1_fr1
	.word	sub_fr1_fr1_fr2
	.word	sub_ir1_ix_id
	.word	sub_ir1_pb_ix
	.word	sub_ir2_pb_ix
	.word	to_ip_pb

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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
	pulb
	rts
extdex
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	2,x
	ldx	#symtbl
	abx
	abx
	ldd	,x
	pshb
	ldx	curinst
	ldab	1,x
	ldx	#symtbl
	abx
	abx
	ldx	,x
	pulb
	rts
dexext
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	1,x
	ldx	#symtbl
	abx
	abx
	ldd	,x
	pshb
	ldx	curinst
	ldab	2,x
	ldx	#symtbl
	abx
	abx
	ldx	,x
	pulb
	rts
eistr
	ldx	curinst
	inx
	pshx
	ldab	0,x
	ldx	#symtbl
	abx
	abx
	ldd	,x
	std	tmp3
	pulx
	inx
	ldab	,x
	inx
	pshx
	abx
	stx	nxtinst
	pulx
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
; X = COS(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   COS(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses (5,x 6,x 7,x 8,x 9,x)
;          uses argv and tmp1-tmp4
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
; X = SIN(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   SIN(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses (5,x 6,x 7,x 8,x 9,x)
;          uses argv and tmp1-tmp4 (tmp4+1 unused)
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
	jsr	x2arg
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
	jsr	arg2x
	ldd	3,x
	pshb
	psha
	jsr	mulfltx
	jsr	x2arg
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
	jmp	rmul315
	; cos of angle less than pi/4
_cos
	ldx	tmp1
	jsr	arg2x
	jsr	mulfltx
	jsr	x2arg
	ldd	#56
	bsr	_rsubm
	ldd	#1680
	bsr	_rsubm
	ldd	#20160
	bsr	_rsubm
	ldd	#40320
	bsr	_rsub
	ldd	#$A11A
	jmp	rmul315
_rsubm
	bsr	_rsub
	jmp	mulfltx
_rsub
	neg	4,x
	bcs	_ngc1
	neg	3,x
	bra	_ngc2
_ngc1
	com	3,x
_ngc2
	sbcb	2,x
	sbca	1,x
	std	1,x
	bcs	_ngc3
	neg	0,x
	rts
_ngc3
	com	0,x
	rts
_tbl_pi1	.byte	$03,$24,$40
_tbl_pi2	.byte	$01,$92,$20
_tbl_pi4	.byte	$00,$C9,$10

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

	.module	mdtobc
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

	.module	mdx2arg
; copy [X] to argv
;   ENTRY  Y in 0,x 1,x 2,x 3,x 4,x
;   EXIT   Y copied to 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
	; copy x to argv
x2arg
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	rts

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

add_ir1_ix_pb			; numCalls = 4
	.module	modadd_ir1_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ix_pb			; numCalls = 4
	.module	modadd_ir2_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r2+1
	ldab	#0
	adcb	0,x
	stab	r2
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
	stx	DP_DATA
	rts

clr_ix			; numCalls = 1
	.module	modclr_ix
	jsr	extend
	ldd	#0
	stab	0,x
	std	1,x
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

dbl_ir1_ix			; numCalls = 1
	.module	moddbl_ir1_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dec_ix_ix			; numCalls = 1
	.module	moddec_ix_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

forone_ix			; numCalls = 2
	.module	modforone_ix
	jsr	extend
	stx	letptr
	ldd	#1
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

inc_ix_ix			; numCalls = 1
	.module	modinc_ix_ix
	jsr	extend
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

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

ld_fd_fx			; numCalls = 6
	.module	modld_fd_fx
	jsr	dexext
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	ldx	tmp1
	std	3,x
	ldd	1+argv
	std	1,x
	ldab	0+argv
	stab	0,x
	rts

ld_fr1_fx			; numCalls = 7
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 4
	.module	modld_fr2_fx
	jsr	extend
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 5
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

ld_id_ix			; numCalls = 1
	.module	modld_id_ix
	jsr	dexext
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
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

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldge_ir1_ix_id			; numCalls = 1
	.module	modldge_ir1_ix_id
	jsr	extdex
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

ldlt_ir1_pb_fx			; numCalls = 1
	.module	modldlt_ir1_pb_fx
	jsr	byteext
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

mul_fr1_fr1_pb			; numCalls = 2
	.module	modmul_fr1_fr1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

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

mul_fr2_fr2_pb			; numCalls = 2
	.module	modmul_fr2_fr2_pb
	jsr	getbyte
	ldx	#r2
	jsr	mulbytf
	jmp	tmp2xf

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
	stx	nxtinst
	jmp	mainloop
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
_done
	ldab	0,x
	abx
	txs
	jmp	mainloop
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
	blt	_done
	ldx	3,x
	stx	nxtinst
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

rsub_ir1_ir1_pb			; numCalls = 1
	.module	modrsub_ir1_ir1_pb
	jsr	getbyte
	clra
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

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

sub_ir1_ix_id			; numCalls = 1
	.module	modsub_ir1_ix_id
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir1_pb_ix			; numCalls = 4
	.module	modsub_ir1_pb_ix
	jsr	byteext
	subb	2,x
	stab	r1+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r1
	rts

sub_ir2_pb_ix			; numCalls = 4
	.module	modsub_ir2_pb_ix
	jsr	byteext
	subb	2,x
	stab	r2+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r2
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

; Bytecode symbol lookup table

bytecode_FLT_0p03999	.equ	0
bytecode_FLT_0p99920	.equ	1

bytecode_INTVAR_LO	.equ	2
bytecode_INTVAR_R	.equ	3
bytecode_INTVAR_X	.equ	4
bytecode_INTVAR_Y	.equ	5
bytecode_FLTVAR_A	.equ	6
bytecode_FLTVAR_B	.equ	7
bytecode_FLTVAR_C	.equ	8
bytecode_FLTVAR_DC	.equ	9
bytecode_FLTVAR_DS	.equ	10
bytecode_FLTVAR_S	.equ	11
bytecode_FLTVAR_ST	.equ	12

symtbl
	.word	FLT_0p03999
	.word	FLT_0p99920

	.word	INTVAR_LO
	.word	INTVAR_R
	.word	INTVAR_X
	.word	INTVAR_Y
	.word	FLTVAR_A
	.word	FLTVAR_B
	.word	FLTVAR_C
	.word	FLTVAR_DC
	.word	FLTVAR_DS
	.word	FLTVAR_S
	.word	FLTVAR_ST


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

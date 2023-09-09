; Assembly for testidiv5s-bytecode.bas
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
DP_DEVN	.equ	$E8	; current device number
; 
; Memory equates
M_KBUF	.equ	$4231	; keystrobe buffer (8 bytes)
M_PMSK	.equ	$423C	; pixel mask for SET, RESET and POINT
M_FLEN	.equ	$4256	; filename len
M_FNAM	.equ	$4257	; filename (8 bytes)
M_FTYP	.equ	$4267	; cassette filetype
M_LDSZ	.equ	$426C	; load addr / array size
M_CBEG	.equ	$426F	; cassette beginning address
M_CEND	.equ	$4271	; address after cassette ending
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
R_WBLKS	.equ	$FC5D	; write blocks M_CBEG up to before M_CEND
R_WFNAM	.equ	$FC8E	; write filename block + silence + post-leader
R_RBLKS	.equ	$FDC5	; read data blocks into M_CBEG
R_RCLDM	.equ	$FE1B	; read machine language blocks offset by X
R_SFNAM	.equ	$FE37	; search for filename
R_SOUND	.equ	$FFAB	; play sound with pitch in ACCA and duration in ACCB
R_MCXID	.equ	$FFDA	; ID location for MCX BASIC
R_RSLDR	.equ	$FF4E	; read leader preceding data blocks

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

	; X=150

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	150

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

LINE_20

	; T=IDIV(X,10)=15

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	10

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	15

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_30

	; T=IDIV(X,15)=10

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	15

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	10

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_40

	; T=IDIV(X,25)=6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	25

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	6

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_50

	; T=IDIV(X,100)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	100

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_60

	; T=IDIV(Z,100)=0

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	100

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	0

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_110

	; X=-150

	.byte	bytecode_ld_ix_nb
	.byte	bytecode_INTVAR_X
	.byte	-150&$ff

LINE_120

	; T=IDIV(X,10)=-15

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	10

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-15

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_130

	; T=IDIV(X,15)=-10

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	15

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-10

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_140

	; T=IDIV(X,25)=-6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	25

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-6

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_150

	; T=IDIV(X,100)=-2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	100

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_200

	; X=-810

	.byte	bytecode_ld_ix_nw
	.byte	bytecode_INTVAR_X
	.word	-810

LINE_210

	; T=IDIV(X,9)=-90

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	9

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-90

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_220

	; T=IDIV(X,90)=-9

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	90

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-9

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_230

	; T=IDIV(X,135)=-6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_idiv5s_ir1_ir1_pb
	.byte	135

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-6

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_300

	; Y=15.5

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_Y
	.byte	bytecode_FLT_15p50000

LINE_310

	; T=IDIV(Y,15)=1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_idiv_ir1_fr1_pb
	.byte	15

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

LINE_999

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; END

	.byte	bytecode_progend

LINE_1000

	; IF T THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1010

	; PRINT "PASS ";

	.byte	bytecode_pr_ss
	.text	5, "PASS "

	; RETURN

	.byte	bytecode_return

LINE_1010

	; PRINT "fail ";

	.byte	bytecode_pr_ss
	.text	5, "fail "

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_clear	.equ	0
bytecode_clr_ix	.equ	1
bytecode_gosub_ix	.equ	2
bytecode_idiv5s_ir1_ir1_pb	.equ	3
bytecode_idiv_ir1_fr1_pb	.equ	4
bytecode_jmpeq_ir1_ix	.equ	5
bytecode_ld_fd_fx	.equ	6
bytecode_ld_fr1_fx	.equ	7
bytecode_ld_ir1_ix	.equ	8
bytecode_ld_ix_ir1	.equ	9
bytecode_ld_ix_nb	.equ	10
bytecode_ld_ix_nw	.equ	11
bytecode_ld_ix_pb	.equ	12
bytecode_ldeq_ir1_ir1_nb	.equ	13
bytecode_ldeq_ir1_ir1_pb	.equ	14
bytecode_pr_ss	.equ	15
bytecode_progbegin	.equ	16
bytecode_progend	.equ	17
bytecode_return	.equ	18

catalog
	.word	clear
	.word	clr_ix
	.word	gosub_ix
	.word	idiv5s_ir1_ir1_pb
	.word	idiv_ir1_fr1_pb
	.word	jmpeq_ir1_ix
	.word	ld_fd_fx
	.word	ld_fr1_fx
	.word	ld_ir1_ix
	.word	ld_ix_ir1
	.word	ld_ix_nb
	.word	ld_ix_nw
	.word	ld_ix_pb
	.word	ldeq_ir1_ir1_nb
	.word	ldeq_ir1_ir1_pb
	.word	pr_ss
	.word	progbegin
	.word	progend
	.word	return

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

	.module	mdgeteq
geteq
	beq	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdidiv35
; fast divide by 3 or 5
; ENTRY: X in tmp1+1,tmp2,tmp2+1
;        ACCD is $CC05 for divide by 5
;        ACCD is $AA03 for divide by 3
; EXIT:  INT(X/(3 or 5)) in tmp1+1,tmp2,tmp2+1
;   tmp3,tmp3+1,tmp4 used for storage
idiv35
	psha
	jsr	imodb
	tab
	ldaa	tmp2+1
	sba
	staa	tmp2+1
	bcc	_dodiv
	ldd	tmp1+1
	subd	#1
	std	tmp1+1
_dodiv
	pulb
	jmp	idivb

	.module	mdidiv5s
; fast divide when divisor is '5-smooth'
; (i.e. having factors only of 2, 3, 5)
; ENTRY: X holds dividend
;        ACCB holds divisor
; EXIT:  INT(X/ACCB) in X
;   tmp1-tmp4 used for storage
idiv5s
	; div by factors of 2?
	bitb	#1
	bne	_odd
	lsrb
	asr	,x
	ror	1,x
	ror	2,x
	bra	idiv5s
_odd
	cmpb	#1
	beq	_rts
	stab	tmp1
	ldab	,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
_do3
	ldab	tmp1
_by3
	ldaa	#$AB
	mul
	cmpb	#$55
	bhi	_do5
	stab	tmp1
	ldd	#$AA03
	jsr	idiv35
	ldab	tmp1
	cmpb	#1
	beq	_store
	bra	_by3
_do5
	ldab	tmp1
_by5
	ldaa	#$CD
	mul
	stab	tmp1
	ldd	#$CC05
	jsr	idiv35
	ldab	tmp1
	cmpb	#1
	bne	_by5
_store
	ldab	tmp1+1
	stab	,x
	ldd	tmp2
	std	1,x
_rts
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

gosub_ix			; numCalls = 13
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

idiv5s_ir1_ir1_pb			; numCalls = 12
	.module	modidiv5s_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jmp	idiv5s

idiv_ir1_fr1_pb			; numCalls = 1
	.module	modidiv_ir1_fr1_pb
	jsr	getbyte
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	idivflt

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

ld_fd_fx			; numCalls = 1
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

ld_fr1_fx			; numCalls = 1
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_ix			; numCalls = 13
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ix_ir1			; numCalls = 13
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 1
	.module	modld_ix_nb
	jsr	extbyte
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_nw			; numCalls = 1
	.module	modld_ix_nw
	jsr	extword
	std	1,x
	ldab	#-1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldeq_ir1_ir1_nb			; numCalls = 7
	.module	modldeq_ir1_ir1_nb
	jsr	getbyte
	cmpb	r1+2
	bne	_done
	ldd	r1
	subd	#-1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ir1_pb			; numCalls = 6
	.module	modldeq_ir1_ir1_pb
	jsr	getbyte
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

pr_ss			; numCalls = 3
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
D0_ERROR	.equ	20
LS_ERROR	.equ	28
IO_ERROR	.equ	34
FM_ERROR	.equ	36
error
	jmp	R_ERROR

return			; numCalls = 2
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

; data table
startdata
enddata

; Bytecode symbol lookup table

bytecode_FLT_15p50000	.equ	0

bytecode_INTVAR_T	.equ	1
bytecode_INTVAR_X	.equ	2
bytecode_INTVAR_Z	.equ	3
bytecode_FLTVAR_Y	.equ	4

symtbl
	.word	FLT_15p50000

	.word	INTVAR_T
	.word	INTVAR_X
	.word	INTVAR_Z
	.word	FLTVAR_Y


; fixed-point constants
FLT_15p50000	.byte	$00, $00, $0f, $80, $00

; block started by symbol
bss

; Numeric Variables
INTVAR_T	.block	3
INTVAR_X	.block	3
INTVAR_Z	.block	3
FLTVAR_Y	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

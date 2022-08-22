; Assembly for testfactor-native.bas
; compiled with mcbasic -native

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

	; A=1

	ldx	#INTVAR_A
	jsr	one_ix

	; B=2

	ldx	#INTVAR_B
	ldab	#2
	jsr	ld_ix_pb

	; C=3

	ldx	#INTVAR_C
	ldab	#3
	jsr	ld_ix_pb

	; D=4

	ldx	#INTVAR_D
	ldab	#4
	jsr	ld_ix_pb

LINE_20

	; PRINT STR$((C+D)*(A+B));" \r";

	ldx	#INTVAR_C
	ldd	#INTVAR_D
	jsr	add_ir1_ix_id

	ldx	#INTVAR_A
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	mul_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_30

	; PRINT STR$((C OR D) AND (A OR B));" \r";

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTVAR_D
	jsr	or_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#INTVAR_B
	jsr	or_ir2_ir2_ix

	jsr	and_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_40

	; PRINT STR$((C AND D) OR (A AND B));" \r";

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTVAR_D
	jsr	and_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#INTVAR_B
	jsr	and_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_45

	; REM THESE MAY IMPROVE LATER

LINE_50

	; PRINT STR$(((C+D)*A)+((-C-D)*B));" \r";

	ldx	#INTVAR_C
	ldd	#INTVAR_D
	jsr	add_ir1_ix_id

	ldx	#INTVAR_A
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_C
	ldd	#INTVAR_D
	jsr	add_ir2_ix_id

	jsr	neg_ir2_ir2

	ldx	#INTVAR_B
	jsr	mul_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_60

	; PRINT STR$(((-B-A)*C)+((A+B)*D));" \r";

	ldx	#INTVAR_B
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	jsr	neg_ir1_ir1

	ldx	#INTVAR_C
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	ldx	#INTVAR_D
	jsr	mul_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_70

	; PRINT STR$(((A+B)*C)+((-A-B)*D));" \r";

	ldx	#INTVAR_A
	ldd	#INTVAR_B
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	neg_ir2_ir2

	ldx	#INTVAR_D
	jsr	mul_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_80

	; PRINT STR$((-B-A)*(C+D));" \r";

	ldx	#INTVAR_B
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	jsr	neg_ir1_ir1

	ldx	#INTVAR_C
	ldd	#INTVAR_D
	jsr	add_ir2_ix_id

	jsr	mul_ir1_ir1_ir2

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LLAST

	; END

	jsr	progend

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

add_ir1_ir1_ir2			; numCalls = 3
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 5
	.module	modadd_ir1_ix_id
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir2_ix_id			; numCalls = 5
	.module	modadd_ir2_ix_id
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
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

and_ir1_ir1_ix			; numCalls = 1
	.module	modand_ir1_ir1_ix
	ldd	1,x
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	0,x
	andb	r1
	stab	r1
	rts

and_ir2_ir2_ix			; numCalls = 1
	.module	modand_ir2_ir2_ix
	ldd	1,x
	andb	r2+2
	anda	r2+1
	std	r2+1
	ldab	0,x
	andb	r2
	stab	r2
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

ld_ir1_ix			; numCalls = 2
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir2_ix			; numCalls = 2
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ix_pb			; numCalls = 3
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

mul_ir1_ir1_ir2			; numCalls = 2
	.module	modmul_ir1_ir1_ir2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_ix			; numCalls = 3
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir2_ir2_ix			; numCalls = 3
	.module	modmul_ir2_ir2_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r2
	jmp	mulintx

neg_ir1_ir1			; numCalls = 2
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

neg_ir2_ir2			; numCalls = 2
	.module	modneg_ir2_ir2
	ldx	#r2
	jmp	negxi

one_ix			; numCalls = 1
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

or_ir1_ir1_ir2			; numCalls = 1
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

or_ir1_ir1_ix			; numCalls = 1
	.module	modor_ir1_ir1_ix
	ldd	1,x
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	0,x
	orab	r1
	stab	r1
	rts

or_ir2_ir2_ix			; numCalls = 1
	.module	modor_ir2_ir2_ix
	ldd	1,x
	orab	r2+2
	oraa	r2+1
	std	r2+1
	ldab	0,x
	orab	r2
	stab	r2
	rts

pr_sr1			; numCalls = 7
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 7
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

str_sr1_ir1			; numCalls = 7
	.module	modstr_sr1_ir1
	ldd	r1+1
	std	tmp2
	ldab	r1
	stab	tmp1+1
	ldd	#0
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end
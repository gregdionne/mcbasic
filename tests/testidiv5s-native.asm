; Assembly for testidiv5s-native.bas
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

	; X=150

	ldx	#INTVAR_X
	ldab	#150
	jsr	ld_ix_pb

	; Z=0

	ldx	#INTVAR_Z
	jsr	clr_ix

LINE_20

	; T=IDIV(X,10)=15

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#10
	jsr	idiv5s_ir1_ir1_pb

	ldab	#15
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_30

	; T=IDIV(X,15)=10

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#15
	jsr	idiv5s_ir1_ir1_pb

	ldab	#10
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_40

	; T=IDIV(X,25)=6

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#25
	jsr	idiv5s_ir1_ir1_pb

	ldab	#6
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_50

	; T=IDIV(X,100)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#100
	jsr	idiv5s_ir1_ir1_pb

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_60

	; T=IDIV(Z,100)=0

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#100
	jsr	idiv5s_ir1_ir1_pb

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_110

	; X=-150

	ldx	#INTVAR_X
	ldab	#-150&$ff
	jsr	ld_ix_nb

LINE_120

	; T=IDIV(X,10)=-15

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#10
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-15
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_130

	; T=IDIV(X,15)=-10

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#15
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-10
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_140

	; T=IDIV(X,25)=-6

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#25
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-6
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_150

	; T=IDIV(X,100)=-2

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#100
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_200

	; X=-810

	ldx	#INTVAR_X
	ldd	#-810
	jsr	ld_ix_nw

LINE_210

	; T=IDIV(X,9)=-90

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#9
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-90
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_220

	; T=IDIV(X,90)=-9

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#90
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-9
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_230

	; T=IDIV(X,135)=-6

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#135
	jsr	idiv5s_ir1_ir1_pb

	ldab	#-6
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_300

	; Y=15.5

	ldd	#FLTVAR_Y
	ldx	#FLT_15p50000
	jsr	ld_fd_fx

LINE_310

	; T=IDIV(Y,15)=1

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#15
	jsr	idiv_ir1_fr1_pb

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_999

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; END

	jsr	progend

LINE_1000

	; IF T THEN

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#LINE_1010
	jsr	jmpeq_ir1_ix

	; PRINT "PASS ";

	jsr	pr_ss
	.text	5, "PASS "

	; RETURN

	jsr	return

LINE_1010

	; PRINT "fail ";

	jsr	pr_ss
	.text	5, "fail "

	; RETURN

	jsr	return

LLAST

	; END

	jsr	progend

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
	ldd	#0
	stab	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 13
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

idiv5s_ir1_ir1_pb			; numCalls = 12
	.module	modidiv5s_ir1_ir1_pb
	ldx	#r1
	jmp	idiv5s

idiv_ir1_fr1_pb			; numCalls = 1
	.module	modidiv_ir1_fr1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	idivflt

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

ld_fd_fx			; numCalls = 1
	.module	modld_fd_fx
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
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_ix			; numCalls = 13
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ix_ir1			; numCalls = 13
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 1
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_nw			; numCalls = 1
	.module	modld_ix_nw
	std	1,x
	ldab	#-1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldeq_ir1_ir1_nb			; numCalls = 7
	.module	modldeq_ir1_ir1_nb
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
	rts

; data table
startdata
enddata


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

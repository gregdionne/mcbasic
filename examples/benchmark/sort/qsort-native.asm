; Assembly for qsort-native.bas
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

LINE_10

	; DIM ST(50)

	ldab	#50
	jsr	ld_ir1_pb

	ldx	#INTARR_ST
	jsr	arrdim1_ir1_ix

LINE_20

	; SP=0

	ldx	#INTVAR_SP
	ldab	#0
	jsr	ld_ix_pb

	; L=16384

	ldx	#INTVAR_L
	ldd	#16384
	jsr	ld_ix_pw

	; H=16895

	ldx	#INTVAR_H
	ldd	#16895
	jsr	ld_ix_pw

	; GOSUB 100

	ldx	#LINE_100
	jsr	gosub_ix

LINE_30

	; END

	jsr	progend

LINE_100

	; A=PEEK(L)

	ldx	#INTVAR_L
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

LINE_110

	; B=PEEK(H)

	ldx	#INTVAR_H
	jsr	peek_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

LINE_120

	; IF A>B THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_A
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_130
	jsr	jmpeq_ir1_ix

	; POKE H,A

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_H
	jsr	poke_ix_ir1

	; POKE L,B

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_L
	jsr	poke_ix_ir1

LINE_130

	; Z=INT(SHIFT(H-L,-1))

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTVAR_L
	jsr	sub_ir1_ir1_ix

	ldab	#-1
	jsr	shift_fr1_ir1_nb

	ldx	#INTVAR_Z
	jsr	ld_ix_ir1

LINE_140

	; IF Z<1 THEN

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_150
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_150

	; Z+=L

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTVAR_Z
	jsr	add_ix_ix_ir1

LINE_160

	; A=PEEK(Z)

	ldx	#INTVAR_Z
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

LINE_170

	; IF A<PEEK(L) THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_L
	jsr	peek_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_180
	jsr	jmpeq_ir1_ix

	; A=PEEK(L)

	ldx	#INTVAR_L
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

LINE_180

	; IF A>PEEK(H) THEN

	ldx	#INTVAR_H
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_190
	jsr	jmpeq_ir1_ix

	; A=PEEK(H)

	ldx	#INTVAR_H
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

LINE_190

	; LP=L

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTVAR_LP
	jsr	ld_ix_ir1

	; HP=H

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTVAR_HP
	jsr	ld_ix_ir1

LINE_200

	; WHEN A<=PEEK(LP) GOTO 220

	ldx	#INTVAR_LP
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ldge_ir1_ir1_ix

	ldx	#LINE_220
	jsr	jmpne_ir1_ix

LINE_210

	; LP+=1

	ldx	#INTVAR_LP
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_220

	; WHEN LP=HP GOTO 270

	ldx	#INTVAR_LP
	jsr	ld_ir1_ix

	ldx	#INTVAR_HP
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_270
	jsr	jmpne_ir1_ix

LINE_230

	; WHEN A>PEEK(HP) GOTO 250

	ldx	#INTVAR_HP
	jsr	peek_ir1_ix

	ldx	#INTVAR_A
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_250
	jsr	jmpne_ir1_ix

LINE_240

	; HP-=1

	ldx	#INTVAR_HP
	ldab	#1
	jsr	sub_ix_ix_pb

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_250

	; WHEN LP=HP GOTO 270

	ldx	#INTVAR_LP
	jsr	ld_ir1_ix

	ldx	#INTVAR_HP
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_270
	jsr	jmpne_ir1_ix

LINE_260

	; T=PEEK(LP)

	ldx	#INTVAR_LP
	jsr	peek_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; POKE LP,PEEK(HP)

	ldx	#INTVAR_HP
	jsr	peek_ir1_ix

	ldx	#INTVAR_LP
	jsr	poke_ix_ir1

	; POKE HP,T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_HP
	jsr	poke_ix_ir1

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_270

	; WHEN (A<>PEEK(L)) OR (L=H) GOTO 290

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_L
	jsr	peek_ir2_ix

	jsr	ldne_ir1_ir1_ir2

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_H
	jsr	ldeq_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_290
	jsr	jmpne_ir1_ix

LINE_280

	; L+=1

	ldx	#INTVAR_L
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 270

	ldx	#LINE_270
	jsr	goto_ix

LINE_290

	; IF LP<L THEN

	ldx	#INTVAR_LP
	jsr	ld_ir1_ix

	ldx	#INTVAR_L
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_300
	jsr	jmpeq_ir1_ix

	; LP=L

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTVAR_LP
	jsr	ld_ix_ir1

LINE_300

	; ST(SP)=LP

	ldx	#INTVAR_SP
	jsr	ld_ir1_ix

	ldx	#INTARR_ST
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_LP
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; ST(SP+1)=H

	ldx	#INTVAR_SP
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTARR_ST
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; SP+=2

	ldx	#INTVAR_SP
	ldab	#2
	jsr	add_ix_ix_pb

LINE_310

	; H=LP

	ldx	#INTVAR_LP
	jsr	ld_ir1_ix

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; GOSUB 100

	ldx	#LINE_100
	jsr	gosub_ix

LINE_320

	; SP-=2

	ldx	#INTVAR_SP
	ldab	#2
	jsr	sub_ix_ix_pb

	; L=ST(SP)

	ldx	#INTVAR_SP
	jsr	ld_ir1_ix

	ldx	#INTARR_ST
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; H=ST(SP+1)

	ldx	#INTVAR_SP
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTARR_ST
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

LINE_330

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

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

	.module	mdgeteq
geteq
	beq	_1
	ldd	#0
	rts
_1
	ldd	#-1
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

	.module	mdgetne
getne
	bne	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdpeek
; perform PEEK(X), emulating keypolling
;   ENTRY: X holds storage byte
;   EXIT:  ACCB holds peeked byte
peek
	cpx	#M_KBUF
	blo	_peek
	cpx	#M_IKEY
	bhi	_peek
	beq	_poll
	cpx	#M_KBUF+7
	bhi	_peek
_poll
	jsr	R_KPOLL
	beq	_peek
	staa	M_IKEY
_peek
	ldab	,x
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

	.module	mdref1
; validate offset from 1D descriptor X and argv
; if empty desc, then alloc D bytes in array memory and 11 elements.
; return word offset in D and byte offset in tmp1
ref1
	std	tmp1
	ldd	,x
	bne	_preexist
	ldd	strbuf
	std	,x
	ldd	#11
	std	2,x
	ldd	tmp1
	pshx
	jsr	alloc
	pulx
_preexist
	ldd	0+argv
	subd	2,x
	bhi	_err
	ldd	0+argv
	std	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

	.module	mdrefint
; return int/str array reference in D/tmp1
refint
	addd	tmp1
	addd	0,x
	std	tmp1
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

add_ir1_ir1_pb			; numCalls = 2
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ix_ix_ir1			; numCalls = 1
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 3
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

arrdim1_ir1_ix			; numCalls = 1
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

arrref1_ir1_ix			; numCalls = 2
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 2
	.module	modarrval1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
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

gosub_ix			; numCalls = 2
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 5
	.module	modgoto_ix
	ins
	ins
	jmp	,x

jmpeq_ir1_ix			; numCalls = 5
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

jmpne_ir1_ix			; numCalls = 5
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

ld_ip_ir1			; numCalls = 2
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 22
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 1
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

ld_ix_ir1			; numCalls = 13
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 2
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ldeq_ir1_ir1_ix			; numCalls = 2
	.module	modldeq_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	bne	_done
	ldab	r1
	cmpb	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir2_ir2_ix			; numCalls = 1
	.module	modldeq_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
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

ldlt_ir1_ir1_ir2			; numCalls = 1
	.module	modldlt_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 4
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

ldne_ir1_ir1_ir2			; numCalls = 1
	.module	modldne_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	bne	_done
	ldab	r1
	cmpb	r2
_done
	jsr	getne
	std	r1+1
	stab	r1
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

peek_ir1_ix			; numCalls = 10
	.module	modpeek_ir1_ix
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_ix			; numCalls = 2
	.module	modpeek_ir2_ix
	ldx	1,x
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_ix_ir1			; numCalls = 4
	.module	modpoke_ix_ir1
	ldab	r1+2
	ldx	1,x
	stab	,x
	rts

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

shift_fr1_ir1_nb			; numCalls = 1
	.module	modshift_fr1_ir1_nb
	ldx	#r1
	negb
	jmp	shrint

sub_ir1_ir1_ix			; numCalls = 1
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ix_ix_pb			; numCalls = 2
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

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_H	.block	3
INTVAR_HP	.block	3
INTVAR_L	.block	3
INTVAR_LP	.block	3
INTVAR_SP	.block	3
INTVAR_T	.block	3
INTVAR_Z	.block	3
; String Variables
; Numeric Arrays
INTARR_ST	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

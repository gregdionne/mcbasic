; Assembly for bsort-bytecode.bas
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

	; FOR X=16894 TO 16385 STEP -1

	.byte	bytecode_for_ix_pw
	.byte	bytecode_INTVAR_X
	.word	16894

	.byte	bytecode_to_ip_pw
	.word	16385

	.byte	bytecode_ld_ir1_nb
	.byte	-1

	.byte	bytecode_step_ip_ir1

LINE_20

	; FOR Y=16384 TO X

	.byte	bytecode_for_ix_pw
	.byte	bytecode_INTVAR_Y
	.word	16384

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_X

LINE_30

	; A=PEEK(Y)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=PEEK(Y+1)

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

LINE_40

	; IF A>B THEN

	.byte	bytecode_ldlt_ir1_ix_id
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_50

	; POKE Y,B

	.byte	bytecode_poke_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_B

	; POKE Y+1,A

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_poke_ir1_ix
	.byte	bytecode_INTVAR_A

LINE_50

	; NEXT Y

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

LINE_60

	; NEXT X

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_next

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_clear	.equ	0
bytecode_for_ix_pw	.equ	1
bytecode_inc_ir1_ix	.equ	2
bytecode_jmpeq_ir1_ix	.equ	3
bytecode_ld_ir1_nb	.equ	4
bytecode_ld_ix_ir1	.equ	5
bytecode_ldlt_ir1_ix_id	.equ	6
bytecode_next	.equ	7
bytecode_nextvar_ix	.equ	8
bytecode_peek_ir1_ir1	.equ	9
bytecode_peek_ir1_ix	.equ	10
bytecode_poke_id_ix	.equ	11
bytecode_poke_ir1_ix	.equ	12
bytecode_progbegin	.equ	13
bytecode_progend	.equ	14
bytecode_step_ip_ir1	.equ	15
bytecode_to_ip_ix	.equ	16
bytecode_to_ip_pw	.equ	17

catalog
	.word	clear
	.word	for_ix_pw
	.word	inc_ir1_ix
	.word	jmpeq_ir1_ix
	.word	ld_ir1_nb
	.word	ld_ix_ir1
	.word	ldlt_ir1_ix_id
	.word	next
	.word	nextvar_ix
	.word	peek_ir1_ir1
	.word	peek_ir1_ix
	.word	poke_id_ix
	.word	poke_ir1_ix
	.word	progbegin
	.word	progend
	.word	step_ip_ir1
	.word	to_ip_ix
	.word	to_ip_pw

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

	.module	mdgetlt
getlt
	blt	_1
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

for_ix_pw			; numCalls = 2
	.module	modfor_ix_pw
	jsr	extword
	stx	letptr
	clr	0,x
	std	1,x
	rts

inc_ir1_ix			; numCalls = 2
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
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

ld_ir1_nb			; numCalls = 1
	.module	modld_ir1_nb
	jsr	getbyte
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ix_ir1			; numCalls = 2
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ldlt_ir1_ix_id			; numCalls = 1
	.module	modldlt_ir1_ix_id
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
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

peek_ir1_ir1			; numCalls = 1
	.module	modpeek_ir1_ir1
	jsr	noargs
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ix			; numCalls = 1
	.module	modpeek_ir1_ix
	jsr	extend
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

poke_id_ix			; numCalls = 1
	.module	modpoke_id_ix
	jsr	dexext
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ir1_ix			; numCalls = 1
	.module	modpoke_ir1_ix
	jsr	extend
	ldab	2,x
	ldx	r1+1
	stab	,x
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

step_ip_ir1			; numCalls = 1
	.module	modstep_ip_ir1
	jsr	noargs
	tsx
	ldd	10,x
	beq	_zero
	ldab	r1
	bpl	_nonzero
	ldd	8,x
	addd	#1
	std	8,x
	ldab	7,x
	adcb	#0
	stab	7,x
_zero
	ldab	r1
_nonzero
	stab	10,x
	ldd	r1+1
	std	11,x
	ldd	nxtinst
	std	5,x
	rts

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

to_ip_pw			; numCalls = 1
	.module	modto_ip_pw
	jsr	getword
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_A	.equ	0
bytecode_INTVAR_B	.equ	1
bytecode_INTVAR_X	.equ	2
bytecode_INTVAR_Y	.equ	3

symtbl

	.word	INTVAR_A
	.word	INTVAR_B
	.word	INTVAR_X
	.word	INTVAR_Y


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

; Assembly for testright.bas
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

	; X=3

	ldx	#INTVAR_X
	ldab	#3
	jsr	ld_ix_pb

LINE_10

	; PRINT RIGHT$("FRED",X)

	jsr	ld_sr1_ss
	.text	4, "FRED"

	ldx	#INTVAR_X
	jsr	right_sr1_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_20

	; PRINT RIGHT$("FRED",X-1)

	jsr	ld_sr1_ss
	.text	4, "FRED"

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	jsr	right_sr1_sr1_ir2

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_30

	; PRINT RIGHT$("FRED",X-2)

	jsr	ld_sr1_ss
	.text	4, "FRED"

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldab	#2
	jsr	sub_ir2_ir2_pb

	jsr	right_sr1_sr1_ir2

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_40

	; PRINT RIGHT$("FRED",X-3)

	jsr	ld_sr1_ss
	.text	4, "FRED"

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldab	#3
	jsr	sub_ir2_ir2_pb

	jsr	right_sr1_sr1_ir2

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_50

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_60

	; PRINT "D"

	jsr	pr_ss
	.text	2, "D\r"

LINE_70

	; PRINT "ED"

	jsr	pr_ss
	.text	3, "ED\r"

LINE_80

	; PRINT "RED"

	jsr	pr_ss
	.text	4, "RED\r"

LLAST

	; END

	jsr	progend

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
; EXIT:  X holds new end of string space
strrel
	cpx	strend
	bls	_rts
	cpx	strstop
	bhs	_rts
	stx	strfree
_rts
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

ld_ir2_ix			; numCalls = 3
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_sr1_ss			; numCalls = 4
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
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

pr_ss			; numCalls = 8
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
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
error
	jmp	R_ERROR

right_sr1_sr1_ir2			; numCalls = 3
	.module	modright_sr1_sr1_ir2
	ldd	r2
	bne	_rts
	ldab	r1
	subb	r2+2
	bls	_rts
	clra
	addd	r1+1
	std	r1+1
	ldab	r2+2
	beq	_zero
	cmpb	r1
	bhs	_rts
	stab	r1
	rts
_zero
	pshx
	ldx	r1+1
	jsr	strrel
	pulx
	ldd	#$0100
	std	r1+1
	stab	r1
_rts
	rts

right_sr1_sr1_ix			; numCalls = 1
	.module	modright_sr1_sr1_ix
	ldd	0,x
	bne	_rts
	ldab	r1
	subb	2,x
	bls	_rts
	clra
	addd	r1+1
	std	r1+1
	ldab	2,x
	beq	_zero
	cmpb	r1
	bhs	_rts
	stab	r1
	rts
_zero
	pshx
	ldx	r1+1
	jsr	strrel
	pulx
	ldd	#$0100
	std	r1+1
	stab	r1
_rts
	rts

sub_ir2_ir2_pb			; numCalls = 3
	.module	modsub_ir2_ir2_pb
	stab	tmp1
	ldd	r2+1
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	r2
	sbcb	#0
	stab	r2
	rts

; data table
startdata
enddata

symstart

; block started by symbol
bss

; Numeric Variables
INTVAR_X	.block	3
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

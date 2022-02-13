; Assembly for testdim3-bytecode.bas
; compiled with mcbasic

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
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
r3	.block	5
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

LINE_5

	; DIM X(4,2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrdim3_ir1_ix
	.byte	bytecode_INTARR_X

LINE_10

	; L=0

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_L
	.byte	0

LINE_20

	; FOR K=0 TO 1

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	0

	.byte	bytecode_to_ip_pb
	.byte	1

LINE_30

	; FOR J=0 TO 2

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	0

	.byte	bytecode_to_ip_pb
	.byte	2

LINE_40

	; FOR I=0 TO 4

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_I
	.byte	0

	.byte	bytecode_to_ip_pb
	.byte	4

LINE_50

	; L+=1

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_L
	.byte	1

LINE_66

	; X(I,J,K)=L

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ld_ip_ir1

LINE_70

	; NEXT

	.byte	bytecode_next

LINE_80

	; NEXT

	.byte	bytecode_next

LINE_90

	; NEXT

	.byte	bytecode_next

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_ix_ix_pb	.equ	0
bytecode_arrdim3_ir1_ix	.equ	1
bytecode_arrref3_ir1_ix	.equ	2
bytecode_clear	.equ	3
bytecode_for_ix_pb	.equ	4
bytecode_ld_ip_ir1	.equ	5
bytecode_ld_ir1_ix	.equ	6
bytecode_ld_ir1_pb	.equ	7
bytecode_ld_ir2_ix	.equ	8
bytecode_ld_ir2_pb	.equ	9
bytecode_ld_ir3_ix	.equ	10
bytecode_ld_ir3_pb	.equ	11
bytecode_ld_ix_pb	.equ	12
bytecode_next	.equ	13
bytecode_progbegin	.equ	14
bytecode_progend	.equ	15
bytecode_to_ip_pb	.equ	16

catalog
	.word	add_ix_ix_pb
	.word	arrdim3_ir1_ix
	.word	arrref3_ir1_ix
	.word	clear
	.word	for_ix_pb
	.word	ld_ip_ir1
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ir3_ix
	.word	ld_ir3_pb
	.word	ld_ix_pb
	.word	next
	.word	progbegin
	.word	progend
	.word	to_ip_pb

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

	.module	mdmul12
mul12
	ldaa	tmp1+1
	ldab	tmp2+1
	mul
	std	tmp3
	ldaa	tmp1
	ldab	tmp2+1
	mul
	addb	tmp3
	stab	tmp3
	ldaa	tmp1+1
	ldab	tmp2
	mul
	tba
	adda	tmp3
	ldab	tmp3+1
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

	.module	mdref3
; get offset from 3D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref3
	ldd	4,x
	std	tmp1
	subd	2+argv
	bls	_err
	ldd	4+argv
	std	tmp2
	subd	6,x
	bhs	_err
	jsr	mul12
	addd	2+argv
	std	tmp2
	ldd	2,x
	std	tmp1
	subd	0+argv
	bls	_err
	jsr	mul12
	addd	0+argv
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

add_ix_ix_pb			; numCalls = 1
	.module	modadd_ix_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

arrdim3_ir1_ix			; numCalls = 1
	.module	modarrdim3_ir1_ix
	jsr	extend
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
	std	tmp1
	ldd	r2+1
	addd	#1
	std	4,x
	std	tmp2
	jsr	mul12
	std	tmp1
	ldd	r3+1
	addd	#1
	std	6,x
	std	tmp2
	jsr	mul12
	std	tmp3
	lsld
	addd	tmp3
	jmp	alloc

arrref3_ir1_ix			; numCalls = 1
	.module	modarrref3_ir1_ix
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	std	letptr
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

for_ix_pb			; numCalls = 3
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

ld_ip_ir1			; numCalls = 1
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 2
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

ld_ir2_ix			; numCalls = 1
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 1
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 1
	.module	modld_ir3_ix
	jsr	extend
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ir3_pb			; numCalls = 1
	.module	modld_ir3_pb
	jsr	getbyte
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

next			; numCalls = 3
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

to_ip_pb			; numCalls = 3
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


bytecode_INTVAR_I	.equ	0
bytecode_INTVAR_J	.equ	1
bytecode_INTVAR_K	.equ	2
bytecode_INTVAR_L	.equ	3
bytecode_INTARR_X	.equ	4

symtbl

	.word	INTVAR_I
	.word	INTVAR_J
	.word	INTVAR_K
	.word	INTVAR_L
	.word	INTARR_X


; block started by symbol
bss

; Numeric Variables
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
; String Variables
; Numeric Arrays
INTARR_X	.block	8	; dims=3
; String Arrays

; block ended by symbol
bes
	.end

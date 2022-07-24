; Assembly for testpokew-bytecode.bas
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

LINE_0

	; DIM X(5),Y(5)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Y

LINE_10

	; X=TIMER+5

	.byte	bytecode_timer_ir1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	5

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

LINE_20

	; Y=X(3)+PEEKW(34)+44

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_peekw_ir2_pb
	.byte	34

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	44

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

LINE_30

	; Z=Y(2)+PEEKW(X)+7

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_peekw_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	7

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

LINE_40

	; ZZ=POS

	.byte	bytecode_pos_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_ZZ

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_ir1_ir1_ir2	.equ	0
bytecode_add_ir1_ir1_pb	.equ	1
bytecode_arrdim1_ir1_ix	.equ	2
bytecode_arrval1_ir1_ix	.equ	3
bytecode_clear	.equ	4
bytecode_ld_ir1_pb	.equ	5
bytecode_ld_ix_ir1	.equ	6
bytecode_peekw_ir2_ix	.equ	7
bytecode_peekw_ir2_pb	.equ	8
bytecode_pos_ir1	.equ	9
bytecode_progbegin	.equ	10
bytecode_progend	.equ	11
bytecode_timer_ir1	.equ	12

catalog
	.word	add_ir1_ir1_ir2
	.word	add_ir1_ir1_pb
	.word	arrdim1_ir1_ix
	.word	arrval1_ir1_ix
	.word	clear
	.word	ld_ir1_pb
	.word	ld_ix_ir1
	.word	peekw_ir2_ix
	.word	peekw_ir2_pb
	.word	pos_ir1
	.word	progbegin
	.word	progend
	.word	timer_ir1

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

add_ir1_ir1_ir2			; numCalls = 2
	.module	modadd_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 3
	.module	modadd_ir1_ir1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

arrdim1_ir1_ix			; numCalls = 2
	.module	modarrdim1_ir1_ix
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
	lsld
	addd	2,x
	jmp	alloc

arrval1_ir1_ix			; numCalls = 2
	.module	modarrval1_ir1_ix
	jsr	extend
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

ld_ir1_pb			; numCalls = 4
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ix_ir1			; numCalls = 4
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

peekw_ir2_ix			; numCalls = 1
	.module	modpeekw_ir2_ix
	jsr	extend
	ldx	1,x
	ldd	,x
	std	r2+1
	clrb
	stab	r2
	rts

peekw_ir2_pb			; numCalls = 1
	.module	modpeekw_ir2_pb
	jsr	getbyte
	ldx	#0
	abx
	ldd	,x
	std	r2+1
	clrb
	stab	r2
	rts

pos_ir1			; numCalls = 1
	.module	modpos_ir1
	jsr	noargs
	ldd	M_CRSR
	anda	#1
	std	r1+1
	clrb
	stab	r1
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

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	jsr	noargs
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

; data table
startdata
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_X	.equ	0
bytecode_INTVAR_Y	.equ	1
bytecode_INTVAR_Z	.equ	2
bytecode_INTVAR_ZZ	.equ	3
bytecode_INTARR_X	.equ	4
bytecode_INTARR_Y	.equ	5

symtbl

	.word	INTVAR_X
	.word	INTVAR_Y
	.word	INTVAR_Z
	.word	INTVAR_ZZ
	.word	INTARR_X
	.word	INTARR_Y


; block started by symbol
bss

; Numeric Variables
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
INTVAR_ZZ	.block	3
; String Variables
; Numeric Arrays
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end
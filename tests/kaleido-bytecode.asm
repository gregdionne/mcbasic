; Assembly for kaleido-bytecode.bas
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

LINE_1

	; REM KALEIDOSCOPE EXAMPLE PROGRAM

LINE_2

	; REM FROM PAGE 111 

LINE_3

	; REM TRS-80 MC-10 MICRO COLOR COMPUTER 

LINE_4

	; REM OPERATION AND LANGUAGE REFERENCE MANUAL

LINE_10

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

LINE_20

	; X=RND(32)-1

	.byte	bytecode_irnd_ir1_pb
	.byte	32

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

LINE_30

	; Y=RND(16)-1

	.byte	bytecode_irnd_ir1_pb
	.byte	16

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

LINE_40

	; Z=RND(9)-1

	.byte	bytecode_irnd_ir1_pb
	.byte	9

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

LINE_50

	; GOSUB 90

	.byte	bytecode_gosub_ix
	.word	LINE_90

LINE_60

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_90

	; WHEN (Z=0) OR (RND(7)=3) GOTO 150

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	0

	.byte	bytecode_irnd_ir2_pb
	.byte	7

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	3

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_150

LINE_100

	; SET(31-X,Y+16,Z)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	31
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	16

	.byte	bytecode_setc_ir1_ir2_ix
	.byte	bytecode_INTVAR_Z

LINE_110

	; SET(31-X,15-Y,Z)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	31
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sub_ir2_pb_ix
	.byte	15
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_ix
	.byte	bytecode_INTVAR_Z

	; REM BUGFIX '+' WITH '-'

LINE_120

	; SET(X+32,Y+16,Z)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	32

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	16

	.byte	bytecode_setc_ir1_ir2_ix
	.byte	bytecode_INTVAR_Z

LINE_130

	; SET(X+32,15-Y,Z)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	32

	.byte	bytecode_sub_ir2_pb_ix
	.byte	15
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_ix
	.byte	bytecode_INTVAR_Z

LINE_140

	; RETURN

	.byte	bytecode_return

LINE_150

	; RESET(31-X,Y+16)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	31
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	16

	.byte	bytecode_reset_ir1_ir2

LINE_160

	; RESET(31-X,15-Y)

	.byte	bytecode_sub_ir1_pb_ix
	.byte	31
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sub_ir2_pb_ix
	.byte	15
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_reset_ir1_ir2

LINE_170

	; RESET(X+32,Y+16)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	32

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	16

	.byte	bytecode_reset_ir1_ir2

LINE_180

	; RESET(X+32,15-Y)

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	32

	.byte	bytecode_sub_ir2_pb_ix
	.byte	15
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_reset_ir1_ir2

LINE_190

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_ir1_ix_pb	.equ	0
bytecode_add_ir2_ix_pb	.equ	1
bytecode_clear	.equ	2
bytecode_clsn_pb	.equ	3
bytecode_dec_ir1_ir1	.equ	4
bytecode_gosub_ix	.equ	5
bytecode_goto_ix	.equ	6
bytecode_irnd_ir1_pb	.equ	7
bytecode_irnd_ir2_pb	.equ	8
bytecode_jmpne_ir1_ix	.equ	9
bytecode_ld_ix_ir1	.equ	10
bytecode_ldeq_ir1_ix_pb	.equ	11
bytecode_ldeq_ir2_ir2_pb	.equ	12
bytecode_or_ir1_ir1_ir2	.equ	13
bytecode_progbegin	.equ	14
bytecode_progend	.equ	15
bytecode_reset_ir1_ir2	.equ	16
bytecode_return	.equ	17
bytecode_setc_ir1_ir2_ix	.equ	18
bytecode_sub_ir1_pb_ix	.equ	19
bytecode_sub_ir2_pb_ix	.equ	20

catalog
	.word	add_ir1_ix_pb
	.word	add_ir2_ix_pb
	.word	clear
	.word	clsn_pb
	.word	dec_ir1_ir1
	.word	gosub_ix
	.word	goto_ix
	.word	irnd_ir1_pb
	.word	irnd_ir2_pb
	.word	jmpne_ir1_ix
	.word	ld_ix_ir1
	.word	ldeq_ir1_ix_pb
	.word	ldeq_ir2_ir2_pb
	.word	or_ir1_ir1_ir2
	.word	progbegin
	.word	progend
	.word	reset_ir1_ir2
	.word	return
	.word	setc_ir1_ir2_ix
	.word	sub_ir1_pb_ix
	.word	sub_ir2_pb_ix

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

	.module	mdgeteq
geteq
	beq	_1
	ldd	#0
	rts
_1
	ldd	#-1
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

	.module	mdrnd
rnd
	ldab	tmp1+1
	bpl	gornd
	orab	#1
	pshb
	ldaa	tmp2
	mul
	std	rvseed
	ldaa	tmp2+1
	pulb
	mul
	addd	rvseed
	std	rvseed
gornd
	ldaa	rvseed
	ldab	#-2
	mul
	std	tmp3
	ldaa	rvseed+1
	ldab	#-2
	mul
	addb	#-2
	adca	tmp3+1
	sbcb	tmp3
	sbca	#0
	adcb	#0
	adca	#0
	std	rvseed
	rts
irnd
	bsr	rnd
	ldaa	tmp2+1
	ldab	rvseed+1
	mul
	staa	tmp3+1
	ldaa	tmp2+1
	ldab	rvseed
	mul
	addb	tmp3+1
	adca	#0
	std	tmp3
	ldaa	tmp2
	ldab	rvseed+1
	mul
	addd	tmp3
	staa	tmp3+1
	ldaa	#0
	adca	#0
	staa	tmp3
	ldaa	tmp2
	ldab	rvseed
	mul
	addd	tmp3
	std	tmp3
	ldaa	#0
	adca	#0
	staa	tmp1
	ldaa	tmp1+1
	beq	_done
	ldab	rvseed+1
	mul
	addb	tmp3
	stab	tmp3
	adca	tmp1
	staa	tmp1
	ldaa	tmp1+1
	ldab	rvseed
	mul
	addb	tmp1
	stab	tmp1
_done
	ldd	tmp3
	addd	#1
	bcc	_rts
	inc	tmp1
_rts
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

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jsr	getbyte
	jmp	R_CLSN

dec_ir1_ir1			; numCalls = 3
	.module	moddec_ir1_ir1
	jsr	noargs
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
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

goto_ix			; numCalls = 1
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

irnd_ir1_pb			; numCalls = 3
	.module	modirnd_ir1_pb
	jsr	getbyte
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

irnd_ir2_pb			; numCalls = 1
	.module	modirnd_ir2_pb
	jsr	getbyte
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r2+1
	ldab	tmp1
	stab	r2
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

ld_ix_ir1			; numCalls = 3
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ldeq_ir1_ix_pb			; numCalls = 1
	.module	modldeq_ir1_ix_pb
	jsr	extbyte
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir2_ir2_pb			; numCalls = 1
	.module	modldeq_ir2_ir2_pb
	jsr	getbyte
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

or_ir1_ir1_ir2			; numCalls = 1
	.module	modor_ir1_ir1_ir2
	jsr	noargs
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
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
D0_ERROR	.equ	20
LS_ERROR	.equ	28
IO_ERROR	.equ	34
FM_ERROR	.equ	36
error
	jmp	R_ERROR

reset_ir1_ir2			; numCalls = 4
	.module	modreset_ir1_ir2
	jsr	noargs
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

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

setc_ir1_ir2_ix			; numCalls = 4
	.module	modsetc_ir1_ir2_ix
	jsr	extend
	ldab	2,x
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

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

; data table
startdata
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_X	.equ	0
bytecode_INTVAR_Y	.equ	1
bytecode_INTVAR_Z	.equ	2

symtbl

	.word	INTVAR_X
	.word	INTVAR_Y
	.word	INTVAR_Z


; block started by symbol
bss

; Numeric Variables
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

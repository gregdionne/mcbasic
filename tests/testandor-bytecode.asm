; Assembly for testandor-bytecode.bas
; compiled with mcbasic

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
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
charpage	.equ	$0100	; single-character string page.

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
curinst	.block	2
nxtinst	.block	2
tmp1	.block	2
tmp2	.block	2
tmp3	.block	2
tmp4	.block	2
tmp5	.block	2
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

	; A=-1

	.byte	bytecode_ld_ix_nb
	.byte	bytecode_INTVAR_A
	.byte	-1

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; IF (B=2) AND A THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_15

	; PRINT "PASS\r";

	.byte	bytecode_pr_ss
	.text	5, "PASS\r"

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_15

	; PRINT "FAIL\r";

	.byte	bytecode_pr_ss
	.text	5, "FAIL\r"

LINE_20

	; IF (B=-1) OR A THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_or_ir1_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_25

	; PRINT "PASS\r";

	.byte	bytecode_pr_ss
	.text	5, "PASS\r"

	; GOTO 30

	.byte	bytecode_goto_ix
	.word	LINE_30

LINE_25

	; PRINT "FAIL\r";

	.byte	bytecode_pr_ss
	.text	5, "FAIL\r"

LINE_30

	; IF (B=-1) OR (A+0.01) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_add_fr2_ir2_fx
	.byte	bytecode_FLT_0p00999

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_35

	; PRINT "PASS\r";

	.byte	bytecode_pr_ss
	.text	5, "PASS\r"

	; GOTO 40

	.byte	bytecode_goto_ix
	.word	LINE_40

LINE_35

	; PRINT "FAIL\r";

	.byte	bytecode_pr_ss
	.text	5, "FAIL\r"

LINE_40

	; IF (B=2) AND (A+0.01) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_add_fr2_ir2_fx
	.byte	bytecode_FLT_0p00999

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_45

	; PRINT "PASS\r";

	.byte	bytecode_pr_ss
	.text	5, "PASS\r"

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_45

	; PRINT "FAIL\r";

	.byte	bytecode_pr_ss
	.text	5, "FAIL\r"

LINE_50

	; END

	.byte	bytecode_progend

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr2_ir2_fx	.equ	0
bytecode_and_ir1_ir1_ir2	.equ	1
bytecode_and_ir1_ir1_ix	.equ	2
bytecode_clear	.equ	3
bytecode_goto_ix	.equ	4
bytecode_jmpeq_ir1_ix	.equ	5
bytecode_ld_ir1_ix	.equ	6
bytecode_ld_ir2_ix	.equ	7
bytecode_ld_ix_nb	.equ	8
bytecode_ld_ix_pb	.equ	9
bytecode_ldeq_ir1_ir1_nb	.equ	10
bytecode_ldeq_ir1_ir1_pb	.equ	11
bytecode_or_ir1_ir1_ir2	.equ	12
bytecode_or_ir1_ir1_ix	.equ	13
bytecode_pr_ss	.equ	14
bytecode_progbegin	.equ	15
bytecode_progend	.equ	16

catalog
	.word	add_fr2_ir2_fx
	.word	and_ir1_ir1_ir2
	.word	and_ir1_ir1_ix
	.word	clear
	.word	goto_ix
	.word	jmpeq_ir1_ix
	.word	ld_ir1_ix
	.word	ld_ir2_ix
	.word	ld_ix_nb
	.word	ld_ix_pb
	.word	ldeq_ir1_ir1_nb
	.word	ldeq_ir1_ir1_pb
	.word	or_ir1_ir1_ir2
	.word	or_ir1_ir1_ix
	.word	pr_ss
	.word	progbegin
	.word	progend

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

add_fr2_ir2_fx			; numCalls = 2
	.module	modadd_fr2_ir2_fx
	jsr	extend
	ldd	3,x
	std	r2+3
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

and_ir1_ir1_ir2			; numCalls = 1
	.module	modand_ir1_ir1_ir2
	jsr	noargs
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
	jsr	extend
	ldd	1,x
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	0,x
	andb	r1
	stab	r1
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
	stx	dataptr
	rts

goto_ix			; numCalls = 4
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

jmpeq_ir1_ix			; numCalls = 4
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

ld_ir1_ix			; numCalls = 4
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir2_ix			; numCalls = 2
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ix_nb			; numCalls = 1
	.module	modld_ix_nb
	jsr	extbyte
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldeq_ir1_ir1_nb			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 2
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

or_ir1_ir1_ix			; numCalls = 1
	.module	modor_ir1_ir1_ix
	jsr	extend
	ldd	1,x
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	0,x
	orab	r1
	stab	r1
	rts

pr_ss			; numCalls = 8
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
	bne	_mcbasic
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
_reqmsg	.text	"?ORIGINAL MC-10 ROM REQUIRED"
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

; data table
startdata
enddata

; Bytecode symbol lookup table

bytecode_FLT_0p00999	.equ	0

bytecode_INTVAR_A	.equ	1
bytecode_INTVAR_B	.equ	2

symtbl
	.word	FLT_0p00999

	.word	INTVAR_A
	.word	INTVAR_B


; fixed-point constants
FLT_0p00999	.byte	$00, $00, $00, $02, $8f

; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

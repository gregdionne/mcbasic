; Assembly for testandor-native.bas
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

	; A=-1

	ldx	#INTVAR_A
	ldab	#-1
	jsr	ld_ix_nb

	; B=2

	ldx	#INTVAR_B
	ldab	#2
	jsr	ld_ix_pb

	; IF (B=2) AND A THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_A
	jsr	and_ir1_ir1_ix

	ldx	#LINE_15
	jsr	jmpeq_ir1_ix

	; PRINT "PASS"

	jsr	pr_ss
	.text	5, "PASS\r"

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_15

	; PRINT "FAIL"

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_20

	; IF (B=-1) OR A THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_A
	jsr	or_ir1_ir1_ix

	ldx	#LINE_25
	jsr	jmpeq_ir1_ix

	; PRINT "PASS"

	jsr	pr_ss
	.text	5, "PASS\r"

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_25

	; PRINT "FAIL"

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_30

	; IF (B=-1) OR (A+0.01) THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#FLT_0p00999
	jsr	add_fr2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_35
	jsr	jmpeq_ir1_ix

	; PRINT "PASS"

	jsr	pr_ss
	.text	5, "PASS\r"

	; GOTO 40

	ldx	#LINE_40
	jsr	goto_ix

LINE_35

	; PRINT "FAIL"

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_40

	; IF (B=2) AND (A+0.01) THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#FLT_0p00999
	jsr	add_fr2_ir2_fx

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_45
	jsr	jmpeq_ir1_ix

	; PRINT "PASS"

	jsr	pr_ss
	.text	5, "PASS\r"

	; GOTO 50

	ldx	#LINE_50
	jsr	goto_ix

LINE_45

	; PRINT "FAIL"

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_50

	; END

	jsr	progend

LLAST

	; END

	jsr	progend

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

goto_ix			; numCalls = 4
	.module	modgoto_ix
	ins
	ins
	jmp	,x

jmpeq_ir1_ix			; numCalls = 4
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

ld_ir1_ix			; numCalls = 4
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

ld_ix_nb			; numCalls = 1
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 1
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ldeq_ir1_ir1_nb			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 2
	.module	modldeq_ir1_ir1_pb
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

; data table
startdata
enddata

symstart

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

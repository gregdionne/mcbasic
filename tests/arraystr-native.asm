; Assembly for arraystr-native.bas
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
r2	.block	5
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_0

	; DIM C$(6)

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrdim1_ir1_sx

	; CLS

	jsr	cls

LINE_5

	; C$(0)=" "

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, " "

	jsr	ld_sp_sr1

LINE_10

	; C$(1)="A"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "A"

	jsr	ld_sp_sr1

LINE_20

	; C$(2)="B"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "B"

	jsr	ld_sp_sr1

LINE_30

	; C$(3)="C"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "C"

	jsr	ld_sp_sr1

LINE_40

	; C$(4)="D"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "D"

	jsr	ld_sp_sr1

LINE_50

	; C$(5)="E"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "E"

	jsr	ld_sp_sr1

LINE_60

	; C$(6)="F"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "F"

	jsr	ld_sp_sr1

LINE_100

	; D$=C$(1)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=C$(2)

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=C$(3)

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

LINE_111

	; WHEN INKEY$="" GOTO 111

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_111
	jsr	jmpne_ir1_ix

LINE_112

	; D$=D$+C$(1)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_C
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

LINE_113

	; WHEN INKEY$="" GOTO 113

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_113
	jsr	jmpne_ir1_ix

LINE_114

	; E$=E$+C$(2)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_C
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

LINE_115

	; WHEN INKEY$="" GOTO 115

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_115
	jsr	jmpne_ir1_ix

LINE_116

	; F$=F$+C$(3)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#STRARR_C
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

LINE_117

	; WHEN INKEY$="" GOTO 117

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_117
	jsr	jmpne_ir1_ix

LINE_122

	; D$=D$+C$(1)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_C
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

LINE_123

	; WHEN INKEY$="" GOTO 123

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_123
	jsr	jmpne_ir1_ix

LINE_124

	; E$=E$+C$(2)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_C
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

LINE_125

	; WHEN INKEY$="" GOTO 125

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_125
	jsr	jmpne_ir1_ix

LINE_126

	; F$=F$+C$(3)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#STRARR_C
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

LINE_127

	; WHEN INKEY$="" GOTO 127

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_127
	jsr	jmpne_ir1_ix

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
	std	tmp1
	subd	2,x
	bhs	_err
	ldd	tmp1
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

	.module	mdstrdel
; remove a permanent string
; then re-link trailing strings
strdel
	ldd	1,x
	subd	strbuf
	blo	_rts
	ldd	1,x
	subd	strend
	bhs	_rts
	ldd	strend
	subd	#2
	subb	0,x
	sbca	#0
	std	strend
	ldab	0,x
	ldx	1,x
	dex
	dex
	stx	tmp1
	abx
	inx
	inx
	sts	tmp2
	txs
	ldx	tmp1
_nxtwrd
	pula
	pulb
	std	,x
	inx
	inx
	cpx	strend
	blo	_nxtwrd
	lds	tmp2
	ldx	tmp1
	jmp	strlink
_rts
	rts

	.module	mdstreqs
; compare string against stack
; ENTRY: top of stack is return to caller (ld<ne/eq>_ir1_sr1_ss)
;        next two bytes address of string length+payload
; EXIT:  we modify those two bytes to point to code beyond payload so caller can just RTS
;        we return correct Z flag for caller
streqs
	ldx	tmp2
	jsr	strrel
	sts	tmp3
	tsx
	ldx	2,x
	ldab	,x
	cmpb	tmp1+1
	bne	_ne
	tstb
	beq	_eq
	tsx
	ldx	2,x
	inx
	txs
	ldx	tmp2
_nxtchr
	pula
	cmpa	,x
	bne	_ne
	inx
	decb
	bne	_nxtchr
_eq
	lds	tmp3
	bsr	_fudge
	clra
	rts
_ne
	lds	tmp3
	bsr	_fudge
	rts
_fudge
	tsx
	ldd	4,x
	ldx	4,x
	sec
	adcb	,x
	adca	#0
	tsx
	std	4,x
	rts

	.module	mdstrprm
; make a permanent string
; ENTRY: argv -  input string descriptor
;          X  - output string descriptor
strprm
	stx	tmp1
	ldab	0+argv
	beq	_null
	decb
	beq	_char
	ldx	1+argv
	cpx	#M_LBUF
	blo	_const
	cpx	#M_MSTR
	blo	_trans
	cpx	strbuf
	blo	_const
_trans
	ldx	tmp1
	ldab	0,x
	ldx	1,x
	cpx	strbuf
	blo	_nalloc
	cmpb	0+argv
	beq	_copyip
_nalloc
	cpx	1+argv
	bhs	_notmp
	ldx	1+argv
	cpx	strend
	bhs	_notmp
	ldx	strend
	inx
	inx
	stx	strfree
	bsr	_copy
	ldd	strfree
	std	1+argv
_notmp
	ldx	tmp1
	pshx
	jsr	strdel
	pulx
	stx	tmp1
	ldx	strend
	ldd	tmp1
	std	,x
	inx
	inx
	stx	strfree
	cpx	argv+1
	beq	_nocopy
	bsr	_copy
	bra	_ready
_nocopy
	ldab	0+argv
	abx
_ready
	stx	strend
	ldd	strfree
	inx
	inx
	stx	strfree
	clr	strtcnt
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts
_char
	ldx	1+argv
	ldab	,x
_null
	ldaa	#charpage>>8
	std	1+argv
_const
	ldx	tmp1
	pshx
	jsr	strdel
	pulx
	ldab	0+argv
	stab	0,x
	ldd	1+argv
	std	1,x
	clr	strtcnt
	rts
_copyip
	dex
	dex
	ldd	tmp1
	std	,x
	inx
	inx
_copy
	sts	tmp2
	ldab	0+argv
	lds	1+argv
	des
_nxtchr
	pula
	staa	,x
	inx
	decb
	bne	_nxtchr
	lds	tmp2
	clr	strtcnt
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

	.module	mdstrtmp
; make a temporary clone of a string
; ENTRY: X holds string start
;        B holds string length
; EXIT:  D holds new string pointer
strtmp
	cpx	strfree
	bls	_reserve
	stx	tmp1
	ldd	tmp1
	rts
_reserve
	inc	strtcnt
strcat
	tstb
	beq	_null
	sts	tmp1
	txs
	ldx	strfree
_nxtcp
	pula
	staa	,x
	inx
	decb
	bne	_nxtcp
	lds	tmp1
	ldd	strfree
	stx	strfree
	rts
_null
	ldd	strfree
	rts

arrdim1_ir1_sx			; numCalls = 1
	.module	modarrdim1_ir1_sx
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

arrref1_ir1_sx			; numCalls = 7
	.module	modarrref1_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_sx			; numCalls = 3
	.module	modarrval1_ir1_sx
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

arrval1_ir2_sx			; numCalls = 6
	.module	modarrval1_ir2_sx
	ldd	r2+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
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

cls			; numCalls = 1
	.module	modcls
	jmp	R_CLS

inkey_sr1			; numCalls = 7
	.module	modinkey_sr1
	ldd	#$0100+(charpage>>8)
	std	r1
	ldaa	M_IKEY
	bne	_gotkey
	jsr	R_KEYIN
_gotkey
	clr	M_IKEY
	staa	r1+2
	bne	_rts
	staa	r1
_rts
	rts

jmpne_ir1_ix			; numCalls = 7
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

ld_ir1_pb			; numCalls = 11
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 6
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_sp_sr1			; numCalls = 7
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 7
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sx_sr1			; numCalls = 9
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_sr1_ss			; numCalls = 7
	.module	modldeq_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqs
	jsr	geteq
	std	r1+1
	stab	r1
	rts

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

strcat_sr1_sr1_sr2			; numCalls = 6
	.module	modstrcat_sr1_sr1_sr2
	ldx	r2+1
	jsr	strrel
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	addb	r2
	bcs	_lserror
	stab	r1
	ldab	r2
	ldx	r2+1
	jmp	strcat
_lserror
	ldab	#LS_ERROR
	jmp	error

strinit_sr1_sx			; numCalls = 6
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
; String Variables
STRVAR_D	.block	3
STRVAR_E	.block	3
STRVAR_F	.block	3
; Numeric Arrays
; String Arrays
STRARR_C	.block	4	; dims=1

; block ended by symbol
bes
	.end

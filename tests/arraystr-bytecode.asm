; Assembly for arraystr-bytecode.bas
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

	; DIM C$(6)

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_C

	; CLS

	.byte	bytecode_cls

LINE_5

	; C$(0)=" "

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, " "

	.byte	bytecode_ld_sp_sr1

LINE_10

	; C$(1)="A"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, "A"

	.byte	bytecode_ld_sp_sr1

LINE_20

	; C$(2)="B"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, "B"

	.byte	bytecode_ld_sp_sr1

LINE_30

	; C$(3)="C"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, "C"

	.byte	bytecode_ld_sp_sr1

LINE_40

	; C$(4)="D"

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, "D"

	.byte	bytecode_ld_sp_sr1

LINE_50

	; C$(5)="E"

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, "E"

	.byte	bytecode_ld_sp_sr1

LINE_60

	; C$(6)="F"

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sr1_ss
	.text	1, "F"

	.byte	bytecode_ld_sp_sr1

LINE_100

	; D$=C$(1)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_D

	; E$=C$(2)

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_E

	; F$=C$(3)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_F

LINE_111

	; WHEN INKEY$="" GOTO 111

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_111

LINE_112

	; D$=D$+C$(1)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_D

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_D

LINE_113

	; WHEN INKEY$="" GOTO 113

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_113

LINE_114

	; E$=E$+C$(2)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_E

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_E

LINE_115

	; WHEN INKEY$="" GOTO 115

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_115

LINE_116

	; F$=F$+C$(3)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_F

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_F

LINE_117

	; WHEN INKEY$="" GOTO 117

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_117

LINE_122

	; D$=D$+C$(1)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_D

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_D

LINE_123

	; WHEN INKEY$="" GOTO 123

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_123

LINE_124

	; E$=E$+C$(2)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_E

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_E

LINE_125

	; WHEN INKEY$="" GOTO 125

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_125

LINE_126

	; F$=F$+C$(3)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_F

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_C

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_F

LINE_127

	; WHEN INKEY$="" GOTO 127

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_127

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_arrdim1_ir1_sx	.equ	0
bytecode_arrref1_ir1_sx	.equ	1
bytecode_arrval1_ir1_sx	.equ	2
bytecode_arrval1_ir2_sx	.equ	3
bytecode_clear	.equ	4
bytecode_cls	.equ	5
bytecode_inkey_sr1	.equ	6
bytecode_jmpne_ir1_ix	.equ	7
bytecode_ld_ir1_pb	.equ	8
bytecode_ld_ir2_pb	.equ	9
bytecode_ld_sp_sr1	.equ	10
bytecode_ld_sr1_ss	.equ	11
bytecode_ld_sx_sr1	.equ	12
bytecode_ldeq_ir1_sr1_ss	.equ	13
bytecode_progbegin	.equ	14
bytecode_progend	.equ	15
bytecode_strcat_sr1_sr1_sr2	.equ	16
bytecode_strinit_sr1_sx	.equ	17

catalog
	.word	arrdim1_ir1_sx
	.word	arrref1_ir1_sx
	.word	arrval1_ir1_sx
	.word	arrval1_ir2_sx
	.word	clear
	.word	cls
	.word	inkey_sr1
	.word	jmpne_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_pb
	.word	ld_sp_sr1
	.word	ld_sr1_ss
	.word	ld_sx_sr1
	.word	ldeq_ir1_sr1_ss
	.word	progbegin
	.word	progend
	.word	strcat_sr1_sr1_sr2
	.word	strinit_sr1_sx

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

	.module	mdstreqbs
; compare string against bytecode "stack"
; ENTRY: tmp1+1 holds length, tmp2 holds compare
; EXIT:  we return correct Z flag for caller
streqbs
	ldx	tmp2
	jsr	strrel
	jsr	immstr
	sts	tmp3
	cmpb	tmp1+1
	bne	_ne
	tstb
	beq	_eq
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
	clra
	rts
_ne
	lds	tmp3
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

arrref1_ir1_sx			; numCalls = 7
	.module	modarrref1_ir1_sx
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_sx			; numCalls = 3
	.module	modarrval1_ir1_sx
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

arrval1_ir2_sx			; numCalls = 6
	.module	modarrval1_ir2_sx
	jsr	extend
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

cls			; numCalls = 1
	.module	modcls
	jsr	noargs
	jmp	R_CLS

inkey_sr1			; numCalls = 7
	.module	modinkey_sr1
	jsr	noargs
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
	jsr	getaddr
	ldd	r1+1
	bne	_go
	ldaa	r1
	beq	_rts
_go
	stx	nxtinst
_rts
	rts

ld_ir1_pb			; numCalls = 11
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 6
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_sp_sr1			; numCalls = 7
	.module	modld_sp_sr1
	jsr	noargs
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 7
	.module	modld_sr1_ss
	ldx	curinst
	inx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	stx	nxtinst
	rts

ld_sx_sr1			; numCalls = 9
	.module	modld_sx_sr1
	jsr	extend
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
	jsr	streqbs
	jsr	geteq
	std	r1+1
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

strcat_sr1_sr1_sr2			; numCalls = 6
	.module	modstrcat_sr1_sr1_sr2
	jsr	noargs
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
	jsr	extend
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

; data table
startdata
enddata

; Bytecode symbol lookup table


bytecode_STRVAR_D	.equ	0
bytecode_STRVAR_E	.equ	1
bytecode_STRVAR_F	.equ	2
bytecode_STRARR_C	.equ	3

symtbl

	.word	STRVAR_D
	.word	STRVAR_E
	.word	STRVAR_F
	.word	STRARR_C


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

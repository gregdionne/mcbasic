; Assembly for teststrlt-native.bas
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
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_1

	; A$="LATER"

	jsr	ld_sr1_ss
	.text	5, "LATER"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_2

	; B$="EARLIER"

	jsr	ld_sr1_ss
	.text	7, "EARLIER"

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

LINE_10

	; IF A$+"A"<B$+"A" THEN

	ldx	#STRVAR_A
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "A"

	ldx	#STRVAR_B
	jsr	strinit_sr2_sx

	jsr	strcat_sr2_sr2_ss
	.text	1, "A"

	jsr	ldlt_ir1_sr1_sr2

	ldx	#LINE_20
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_20

	; IF A$+"A"<B$ THEN

	ldx	#STRVAR_A
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "A"

	ldx	#STRVAR_B
	jsr	ldlt_ir1_sr1_sx

	ldx	#LINE_30
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_30

	; IF A$+"A"<"EARLIER" THEN

	ldx	#STRVAR_A
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "A"

	jsr	ldlt_ir1_sr1_ss
	.text	7, "EARLIER"

	ldx	#LINE_40
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_40

	; IF B$+"A">A$ THEN

	ldx	#STRVAR_B
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "A"

	ldx	#STRVAR_A
	jsr	ldlt_ir1_sx_sr1

	ldx	#LINE_50
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_50

	; IF A$<B$ THEN

	ldx	#STRVAR_A
	ldd	#STRVAR_B
	jsr	ldlt_ir1_sx_sd

	ldx	#LINE_60
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_60

	; IF A$<"LATER" THEN

	ldx	#STRVAR_A
	jsr	ldlt_ir1_sx_ss
	.text	5, "LATER"

	ldx	#LINE_70
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_70

	; IF "LATER"<B$+"A" THEN

	ldx	#STRVAR_B
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "A"

	jsr	ldlt_ir1_ss_sr1
	.text	5, "LATER"

	ldx	#LINE_80
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_80

	; IF "LATER"<B$ THEN

	ldx	#STRVAR_B
	jsr	ldlt_ir1_ss_sx
	.text	5, "LATER"

	ldx	#LINE_90
	jsr	jmpeq_ir1_ix

	; PRINT "FAIL\r";

	jsr	pr_ss
	.text	5, "FAIL\r"

LINE_90

	; PRINT "DONE\r";

	jsr	pr_ss
	.text	5, "DONE\r"

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

	.module	mdgetlo
getlo
	blo	_1
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

	.module	mdstrlo
; compare A$ < B$ with string release
; ENTRY:  A$ = 0+argv (len) 1+argv (ptr)
;         B$ = tmp1+1 (len) tmp2   (ptr)
; EXIT: C flag set if A$ < B$
strlo
	ldx	1+argv
	jsr	strrel
	ldx	tmp2
	jsr	strrel
	ldab	tmp1+1
	cmpb	0+argv
	bls	_ok
	ldab	0+argv
_ok
	sts	tmp3
	lds	1+argv
	des
	ldx	tmp2
	tstb
	beq	_tie
	dex
_nxtchr
	inx
	pula
	cmpa	,x
	bne	_done
	decb
	bne	_nxtchr
_tie
	ldab	0+argv
	cmpb	tmp1+1
_done
	tpa
	lds	tmp3
	tap
	rts

	.module	mdstrlos
strlos
	tsx
	ldx	2,x
	ldab	,x
	stab	tmp1+1
	inx
	stx	tmp2
	abx
	stx	tmp3
	tsx
	ldd	tmp3
	std	2,x
	bra	strlo

	.module	mdstrlosr
strlosr
	tsx
	ldx	2,x
	ldab	,x
	stab	0+argv
	inx
	stx	1+argv
	abx
	stx	tmp3
	tsx
	ldd	tmp3
	std	2,x
	bra	strlo

	.module	mdstrlox
strlox
	ldab	,x
	stab	tmp1+1
	ldx	1,x
	stx	tmp2
	bra	strlo

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

jmpeq_ir1_ix			; numCalls = 8
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

ld_sr1_ss			; numCalls = 2
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sx_sr1			; numCalls = 2
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldlt_ir1_sr1_sr2			; numCalls = 1
	.module	modldlt_ir1_sr1_sr2
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	ldd	r2+1
	std	tmp2
	ldab	r2
	stab	tmp1+1
	jsr	strlo
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_sr1_ss			; numCalls = 1
	.module	modldlt_ir1_sr1_ss
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jsr	strlos
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_sr1_sx			; numCalls = 1
	.module	modldlt_ir1_sr1_sx
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jsr	strlox
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ss_sr1			; numCalls = 1
	.module	modldlt_ir1_ss_sr1
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	strlosr
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ss_sx			; numCalls = 1
	.module	modldlt_ir1_ss_sx
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	strlosr
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_sx_sd			; numCalls = 1
	.module	modldlt_ir1_sx_sd
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	tmp1
	jsr	strlox
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_sx_sr1			; numCalls = 1
	.module	modldlt_ir1_sx_sr1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	r1+1
	std	tmp2
	ldab	r1
	stab	tmp1+1
	jsr	strlo
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir1_sx_ss			; numCalls = 1
	.module	modldlt_ir1_sx_ss
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	jsr	strlos
	jsr	getlo
	std	r1+1
	stab	r1
	rts

pr_ss			; numCalls = 9
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
D0_ERROR	.equ	20
LS_ERROR	.equ	28
IO_ERROR	.equ	34
FM_ERROR	.equ	36
error
	jmp	R_ERROR

strcat_sr1_sr1_ss			; numCalls = 5
	.module	modstrcat_sr1_sr1_ss
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	tsx
	ldx	,x
	ldab	,x
	addb	r1
	bcs	_lserror
	stab	r1
	ldab	,x
	inx
	jsr	strcat
	pulx
	ldab	,x
	abx
	jmp	1,x
_lserror
	ldab	#LS_ERROR
	jmp	error

strcat_sr2_sr2_ss			; numCalls = 1
	.module	modstrcat_sr2_sr2_ss
	ldx	r2+1
	ldab	r2
	abx
	stx	strfree
	tsx
	ldx	,x
	ldab	,x
	addb	r2
	bcs	_lserror
	stab	r2
	ldab	,x
	inx
	jsr	strcat
	pulx
	ldab	,x
	abx
	jmp	1,x
_lserror
	ldab	#LS_ERROR
	jmp	error

strinit_sr1_sx			; numCalls = 5
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

strinit_sr2_sx			; numCalls = 1
	.module	modstrinit_sr2_sx
	ldab	0,x
	stab	r2
	ldx	1,x
	jsr	strtmp
	std	r2+1
	rts

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

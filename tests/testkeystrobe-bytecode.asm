; Assembly for testkeystrobe-bytecode.bas
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

LINE_5

	; CLS

	.byte	bytecode_cls

LINE_10

	; PRINT @1, "w";

	.byte	bytecode_prat_pb
	.byte	1

	.byte	bytecode_pr_ss
	.text	1, "w"

LINE_20

	; IF PEEK(2) AND NOT PEEK(16952) AND 4 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16952

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_30

	; PRINT @1, "W";

	.byte	bytecode_prat_pb
	.byte	1

	.byte	bytecode_pr_ss
	.text	1, "W"

LINE_30

	; PRINT @2, "a";

	.byte	bytecode_prat_pb
	.byte	2

	.byte	bytecode_pr_ss
	.text	1, "a"

LINE_40

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16946

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_50

	; PRINT @2, "A";

	.byte	bytecode_prat_pb
	.byte	2

	.byte	bytecode_pr_ss
	.text	1, "A"

LINE_50

	; PRINT @3, "s";

	.byte	bytecode_prat_pb
	.byte	3

	.byte	bytecode_pr_ss
	.text	1, "s"

LINE_60

	; IF PEEK(2) AND NOT PEEK(16948) AND 4 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16948

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_70

	; PRINT @3, "S";

	.byte	bytecode_prat_pb
	.byte	3

	.byte	bytecode_pr_ss
	.text	1, "S"

LINE_70

	; PRINT @4, "d";

	.byte	bytecode_prat_pb
	.byte	4

	.byte	bytecode_pr_ss
	.text	1, "d"

LINE_80

	; IF PEEK(2) AND NOT PEEK(16949) AND 1 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16949

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_90

	; PRINT @4, "D";

	.byte	bytecode_prat_pb
	.byte	4

	.byte	bytecode_pr_ss
	.text	1, "D"

LINE_90

	; PRINT @5, ",";

	.byte	bytecode_prat_pb
	.byte	5

	.byte	bytecode_pr_ss
	.text	1, ","

LINE_100

	; IF PEEK(2) AND NOT PEEK(16949) AND 32 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16949

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	32

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_110

	; PRINT @5, "<";

	.byte	bytecode_prat_pb
	.byte	5

	.byte	bytecode_pr_ss
	.text	1, "<"

LINE_110

	; PRINT @6, ".";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "."

LINE_120

	; IF PEEK(2) AND NOT PEEK(16951) AND 32 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16951

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	32

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_130

	; PRINT @6, ">";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, ">"

LINE_130

	; GOTO 10

	.byte	bytecode_goto_ix
	.word	LINE_10

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_and_ir1_ir1_ir2	.equ	0
bytecode_and_ir1_ir1_pb	.equ	1
bytecode_clear	.equ	2
bytecode_cls	.equ	3
bytecode_com_ir2_ir2	.equ	4
bytecode_goto_ix	.equ	5
bytecode_jmpeq_ir1_ix	.equ	6
bytecode_peek2_ir1	.equ	7
bytecode_peek_ir2_pw	.equ	8
bytecode_pr_ss	.equ	9
bytecode_prat_pb	.equ	10
bytecode_progbegin	.equ	11
bytecode_progend	.equ	12

catalog
	.word	and_ir1_ir1_ir2
	.word	and_ir1_ir1_pb
	.word	clear
	.word	cls
	.word	com_ir2_ir2
	.word	goto_ix
	.word	jmpeq_ir1_ix
	.word	peek2_ir1
	.word	peek_ir2_pw
	.word	pr_ss
	.word	prat_pb
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

and_ir1_ir1_ir2			; numCalls = 6
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

and_ir1_ir1_pb			; numCalls = 6
	.module	modand_ir1_ir1_pb
	jsr	getbyte
	andb	r1+2
	clra
	std	r1+1
	staa	r1
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

com_ir2_ir2			; numCalls = 6
	.module	modcom_ir2_ir2
	jsr	noargs
	com	r2+2
	com	r2+1
	com	r2
	rts

goto_ix			; numCalls = 1
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

jmpeq_ir1_ix			; numCalls = 6
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

peek2_ir1			; numCalls = 6
	.module	modpeek2_ir1
	jsr	noargs
	jsr	R_KPOLL
	ldab	2
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_pw			; numCalls = 6
	.module	modpeek_ir2_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

pr_ss			; numCalls = 12
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

prat_pb			; numCalls = 12
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
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

; data table
startdata
enddata

; Bytecode symbol lookup table



symtbl



; block started by symbol
bss

; Numeric Variables
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

; Assembly for testcmp-native.bas
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
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_10

	; PRINT "EQ\r";

	jsr	pr_ss
	.text	3, "EQ\r"

LINE_20

	; A=1

	ldx	#FLTVAR_A
	jsr	one_fx

	; B=1

	ldx	#FLTVAR_B
	jsr	one_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_30

	; A=1000

	ldx	#FLTVAR_A
	ldd	#1000
	jsr	ld_fx_pw

	; B=1000

	ldx	#FLTVAR_B
	ldd	#1000
	jsr	ld_fx_pw

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_40

	; A=100000

	ldd	#FLTVAR_A
	ldx	#INT_100000
	jsr	ld_fd_ix

	; B=100000

	ldd	#FLTVAR_B
	ldx	#INT_100000
	jsr	ld_fd_ix

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_50

	; A=-1

	ldx	#FLTVAR_A
	jsr	true_fx

	; B=-1

	ldx	#FLTVAR_B
	jsr	true_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_60

	; A=-1000

	ldx	#FLTVAR_A
	ldd	#-1000
	jsr	ld_fx_nw

	; B=-1000

	ldx	#FLTVAR_B
	ldd	#-1000
	jsr	ld_fx_nw

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_70

	; A=-100000

	ldd	#FLTVAR_A
	ldx	#INT_m100000
	jsr	ld_fd_ix

	; B=-100000

	ldd	#FLTVAR_B
	ldx	#INT_m100000
	jsr	ld_fd_ix

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_80

	; A=1.1

	ldd	#FLTVAR_A
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

	; B=1.1

	ldd	#FLTVAR_B
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_90

	; A=1000.1

	ldd	#FLTVAR_A
	ldx	#FLT_1000p10000
	jsr	ld_fd_fx

	; B=1000.1

	ldd	#FLTVAR_B
	ldx	#FLT_1000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_100

	; A=100000.1

	ldd	#FLTVAR_A
	ldx	#FLT_100000p10000
	jsr	ld_fd_fx

	; B=100000.1

	ldd	#FLTVAR_B
	ldx	#FLT_100000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_110

	; A=-1.1

	ldd	#FLTVAR_A
	ldx	#FLT_m1p10000
	jsr	ld_fd_fx

	; B=-1.1

	ldd	#FLTVAR_B
	ldx	#FLT_m1p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_120

	; A=-1000.1

	ldd	#FLTVAR_A
	ldx	#FLT_m1000p10000
	jsr	ld_fd_fx

	; B=-1000.1

	ldd	#FLTVAR_B
	ldx	#FLT_m1000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_130

	; A=-100000.1

	ldd	#FLTVAR_A
	ldx	#FLT_m100000p10000
	jsr	ld_fd_fx

	; B=-100000.1

	ldd	#FLTVAR_B
	ldx	#FLT_m100000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_140

	; A=0

	ldx	#FLTVAR_A
	jsr	clr_fx

	; B=0

	ldx	#FLTVAR_B
	jsr	clr_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_150

	; GOSUB 20000

	ldx	#LINE_20000
	jsr	gosub_ix

LINE_160

	; PRINT "LE\r";

	jsr	pr_ss
	.text	3, "LE\r"

LINE_170

	; A=-1

	ldx	#FLTVAR_A
	jsr	true_fx

	; B=1

	ldx	#FLTVAR_B
	jsr	one_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_180

	; A=-1000

	ldx	#FLTVAR_A
	ldd	#-1000
	jsr	ld_fx_nw

	; B=1000

	ldx	#FLTVAR_B
	ldd	#1000
	jsr	ld_fx_pw

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_190

	; A=-100000

	ldd	#FLTVAR_A
	ldx	#INT_m100000
	jsr	ld_fd_ix

	; B=100000

	ldd	#FLTVAR_B
	ldx	#INT_100000
	jsr	ld_fd_ix

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_200

	; A=1.1

	ldd	#FLTVAR_A
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

	; B=1.2

	ldd	#FLTVAR_B
	ldx	#FLT_1p19999
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_210

	; A=1000.1

	ldd	#FLTVAR_A
	ldx	#FLT_1000p10000
	jsr	ld_fd_fx

	; B=1000.2

	ldd	#FLTVAR_B
	ldx	#FLT_1000p19999
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_220

	; A=100000.1

	ldd	#FLTVAR_A
	ldx	#FLT_100000p10000
	jsr	ld_fd_fx

	; B=100000.2

	ldd	#FLTVAR_B
	ldx	#FLT_100000p19999
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_230

	; A=1

	ldx	#FLTVAR_A
	jsr	one_fx

	; B=1.1

	ldd	#FLTVAR_B
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_240

	; A=1000

	ldx	#FLTVAR_A
	ldd	#1000
	jsr	ld_fx_pw

	; B=1000.1

	ldd	#FLTVAR_B
	ldx	#FLT_1000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_250

	; A=100000

	ldd	#FLTVAR_A
	ldx	#INT_100000
	jsr	ld_fd_ix

	; B=100000.1

	ldd	#FLTVAR_B
	ldx	#FLT_100000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_251

	; PRINT STR$(A);" ";STR$(B);" \r";

	ldx	#FLTVAR_A
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_B
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_260

	; GOSUB 20000

	ldx	#LINE_20000
	jsr	gosub_ix

LINE_270

	; PRINT "GT\r";

	jsr	pr_ss
	.text	3, "GT\r"

LINE_280

	; B=-1

	ldx	#FLTVAR_B
	jsr	true_fx

	; A=1

	ldx	#FLTVAR_A
	jsr	one_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_290

	; B=-1000

	ldx	#FLTVAR_B
	ldd	#-1000
	jsr	ld_fx_nw

	; A=1000

	ldx	#FLTVAR_A
	ldd	#1000
	jsr	ld_fx_pw

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_300

	; B=-100000

	ldd	#FLTVAR_B
	ldx	#INT_m100000
	jsr	ld_fd_ix

	; A=100000

	ldd	#FLTVAR_A
	ldx	#INT_100000
	jsr	ld_fd_ix

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_310

	; B=1.1

	ldd	#FLTVAR_B
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

	; A=1.2

	ldd	#FLTVAR_A
	ldx	#FLT_1p19999
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_320

	; B=1000.1

	ldd	#FLTVAR_B
	ldx	#FLT_1000p10000
	jsr	ld_fd_fx

	; A=1000.2

	ldd	#FLTVAR_A
	ldx	#FLT_1000p19999
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_330

	; B=100000.1

	ldd	#FLTVAR_B
	ldx	#FLT_100000p10000
	jsr	ld_fd_fx

	; A=100000.2

	ldd	#FLTVAR_A
	ldx	#FLT_100000p19999
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_340

	; B=1

	ldx	#FLTVAR_B
	jsr	one_fx

	; A=1.1

	ldd	#FLTVAR_A
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_350

	; B=1000

	ldx	#FLTVAR_B
	ldd	#1000
	jsr	ld_fx_pw

	; A=1000.1

	ldd	#FLTVAR_A
	ldx	#FLT_1000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_360

	; B=100000

	ldd	#FLTVAR_B
	ldx	#INT_100000
	jsr	ld_fd_ix

	; A=100000.1

	ldd	#FLTVAR_A
	ldx	#FLT_100000p10000
	jsr	ld_fd_fx

	; GOSUB 10000

	ldx	#LINE_10000
	jsr	gosub_ix

LINE_361

	; PRINT STR$(A);" ";STR$(B);" \r";

	ldx	#FLTVAR_A
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_B
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_9999

	; END

	jsr	progend

LINE_10000

	; PRINT "<";STR$(A<B);" <=";STR$(A<=B);" =";STR$(A=B);" =>";STR$(A=>B);" >";STR$(A>B);" <>";STR$(A<>B);" \r";

	jsr	pr_ss
	.text	1, "<"

	ldx	#FLTVAR_A
	ldd	#FLTVAR_B
	jsr	ldlt_ir1_fx_fd

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	3, " <="

	ldx	#FLTVAR_B
	ldd	#FLTVAR_A
	jsr	ldge_ir1_fx_fd

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " ="

	ldx	#FLTVAR_A
	ldd	#FLTVAR_B
	jsr	ldeq_ir1_fx_fd

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	3, " =>"

	ldx	#FLTVAR_A
	ldd	#FLTVAR_B
	jsr	ldge_ir1_fx_fd

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " >"

	ldx	#FLTVAR_B
	ldd	#FLTVAR_A
	jsr	ldlt_ir1_fx_fd

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	3, " <>"

	ldx	#FLTVAR_A
	ldd	#FLTVAR_B
	jsr	ldne_ir1_fx_fd

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_10010

	; RETURN

	jsr	return

LINE_20000

	; PRINT "PRESS KEY\r";

	jsr	pr_ss
	.text	10, "PRESS KEY\r"

LINE_20010

	; WHEN INKEY$="" GOTO 20010

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_20010
	jsr	jmpne_ir1_ix

LINE_20020

	; RETURN

	jsr	return

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

	.module	mdgetge
getge
	bge	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetlt
getlt
	blt	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetne
getne
	bne	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdidivb
; fast integer division by three or five
; ENTRY+EXIT:  int in tmp1+1,tmp2,tmp2+1
;         ACCB contains:
;            $CC for div-5
;            $AA for div-3
;         tmp3,tmp3+1,tmp4 used for storage
idivb
	stab	tmp4
	ldab	tmp1+1
	pshb
	ldd	tmp2
	psha
	ldaa	tmp4
	mul
	std	tmp3
	addd	tmp2
	std	tmp2
	ldab	tmp1+1
	adcb	tmp3+1
	stab	tmp1+1
	ldd	tmp1+1
	addd	tmp3
	std	tmp1+1
	pulb
	ldaa	tmp4
	mul
	stab	tmp3+1
	addd	tmp1+1
	std	tmp1+1
	pulb
	ldaa	tmp4
	mul
	addb	tmp1+1
	addb	tmp3+1
	stab	tmp1+1
	rts

	.module	mdimodb
; fast integer modulo operation by three or five
; ENTRY:  int in tmp1+1,tmp2,tmp2+1
;         ACCB contains modulus (3 or 5)
; EXIT:  result in ACCA
imodb
	pshb
	ldaa	tmp1+1
	bpl	_ok
	deca
_ok
	adda	tmp2
	adca	tmp2+1
	adca	#0
	adca	#0
	tab
	lsra
	lsra
	lsra
	lsra
	andb	#$0F
	aba
	pulb
_dec
	sba
	bhs	_dec
	aba
	rts

	.module	mdnegtmp
negtmp
	neg	tmp3+1
	bcs	_com3
	neg	tmp3
	bcs	_com2
	neg	tmp2+1
	bcs	_com1
	neg	tmp2
	bcs	_com0
	neg	tmp1+1
	rts
_com3
	com	tmp3
_com2
	com	tmp2+1
_com1
	com	tmp2
_com0
	com	tmp1+1
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

	.module	mdstrflt
strflt
	inc	strtcnt
	pshx
	tst	tmp1+1
	bmi	_neg
	ldab	#' '
	bra	_wdigs
_neg
	jsr	negtmp
	ldab	#'-'
_wdigs
	ldx	tmp3
	pshx
	ldx	strfree
	stab	,x
	clr	tmp1
_nxtwdig
	inc	tmp1
	lsr	tmp1+1
	ror	tmp2
	ror	tmp2+1
	ror	tmp3
	ldab	#5
	jsr	imodb
	staa	tmp3+1
	lsl	tmp3
	rola
	adda	#'0'
	psha
	ldd	tmp2
	subb	tmp3+1
	sbca	#0
	std	tmp2
	ldab	tmp1+1
	sbcb	#0
	stab	tmp1+1
	ldab	#$CC
	jsr	idivb
	bne	_nxtwdig
	ldd	tmp2
	bne	_nxtwdig
	ldab	tmp1
_nxtc
	pula
	inx
	staa	,x
	decb
	bne	_nxtc
	inx
	inc	tmp1
	pula
	pulb
	subd	#0
	bne	_fdo
	jmp	_fdone
_fdo
	std	tmp2
	ldab	#'.'
	stab	,x
	inc	tmp1
	inx
	ldd	#6
	staa	tmp1+1
	stab	tmp3
_nxtf
	ldd	tmp2
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	addd	tmp2
	std	tmp2
	ldab	tmp1+1
	adcb	#0
	stab	tmp1+1
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	ldd	tmp1
	addb	#'0'
	stab	,x
	inx
	inc	tmp1
	clrb
	stab	tmp1+1
	dec	tmp3
	bne	_nxtf
	tst	tmp2
	bmi	_nxtrnd
_nxtzero
	dex
	dec	tmp1
	ldaa	,x
	cmpa	#'0'
	beq	_nxtzero
	bra	_zdone
_nxtrnd
	dex
	dec	tmp1
	ldaa	,x
	cmpa	#'.'
	beq	_dot
	inca
	cmpa	#'9'
	bhi	_nxtrnd
	bra	_rdone
_dot
	ldaa	#'0'
	staa	,x
	ldab	tmp1
_ndot
	decb
	beq	_dzero
	dex
	ldaa	,x
	inca
	cmpa	#'9'
	bls	_ddone
	bra	_ndot
_ddone
	staa	,x
	ldx	strfree
	ldab	tmp1
	abx
	bra	_fdone
_dzero
	ldaa	#'1'
	staa	,x
	ldx	strfree
	ldab	tmp1
	abx
	ldaa	#'0'
_rdone
	staa	,x
_zdone
	inx
	inc	tmp1
_fdone
	ldd	strfree
	stx	strfree
	pulx
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

clr_fx			; numCalls = 2
	.module	modclr_fx
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

gosub_ix			; numCalls = 33
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

inkey_sr1			; numCalls = 1
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

jmpne_ir1_ix			; numCalls = 1
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

ld_fd_fx			; numCalls = 30
	.module	modld_fd_fx
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	ldx	tmp1
	std	3,x
	ldd	1+argv
	std	1,x
	ldab	0+argv
	stab	0,x
	rts

ld_fd_ix			; numCalls = 10
	.module	modld_fd_ix
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	ldd	#0
	std	3,x
	rts

ld_fx_nw			; numCalls = 4
	.module	modld_fx_nw
	std	1,x
	ldd	#0
	std	3,x
	ldab	#-1
	stab	0,x
	rts

ld_fx_pw			; numCalls = 6
	.module	modld_fx_pw
	std	1,x
	ldd	#0
	std	3,x
	stab	0,x
	rts

ldeq_ir1_fx_fd			; numCalls = 1
	.module	modldeq_ir1_fx_fd
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	ldx	tmp1
	subd	3,x
	bne	_done
	ldd	r1+1
	subd	1,x
	bne	_done
	ldab	r1
	cmpb	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 1
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

ldge_ir1_fx_fd			; numCalls = 2
	.module	modldge_ir1_fx_fd
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	ldx	tmp1
	subd	3,x
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	ldab	r1
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_fd			; numCalls = 2
	.module	modldlt_ir1_fx_fd
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	ldx	tmp1
	subd	3,x
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldne_ir1_fx_fd			; numCalls = 1
	.module	modldne_ir1_fx_fd
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	ldx	tmp1
	subd	3,x
	bne	_done
	ldd	r1+1
	subd	1,x
	bne	_done
	ldab	r1
	cmpb	0,x
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

one_fx			; numCalls = 6
	.module	modone_fx
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

pr_sr1			; numCalls = 10
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 15
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
D0_ERROR	.equ	20
LS_ERROR	.equ	28
IO_ERROR	.equ	34
FM_ERROR	.equ	36
error
	jmp	R_ERROR

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
	rts

str_sr1_fx			; numCalls = 4
	.module	modstr_sr1_fx
	ldd	1,x
	std	tmp2
	ldab	0,x
	stab	tmp1+1
	ldd	3,x
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

str_sr1_ir1			; numCalls = 6
	.module	modstr_sr1_ir1
	ldd	r1+1
	std	tmp2
	ldab	r1
	stab	tmp1+1
	ldd	#0
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

true_fx			; numCalls = 4
	.module	modtrue_fx
	ldd	#0
	std	3,x
	ldd	#-1
	std	1,x
	stab	0,x
	rts

; data table
startdata
enddata


; large integer constants
INT_m100000	.byte	$fe, $79, $60
INT_100000	.byte	$01, $86, $a0

; fixed-point constants
FLT_m100000p10000	.byte	$fe, $79, $5f, $e6, $66
FLT_m1000p10000	.byte	$ff, $fc, $17, $e6, $66
FLT_m1p10000	.byte	$ff, $ff, $fe, $e6, $66
FLT_1p10000	.byte	$00, $00, $01, $19, $9a
FLT_1p19999	.byte	$00, $00, $01, $33, $33
FLT_1000p10000	.byte	$00, $03, $e8, $19, $9a
FLT_1000p19999	.byte	$00, $03, $e8, $33, $33
FLT_100000p10000	.byte	$01, $86, $a0, $19, $9a
FLT_100000p19999	.byte	$01, $86, $a0, $33, $33

; block started by symbol
bss

; Numeric Variables
FLTVAR_A	.block	5
FLTVAR_B	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

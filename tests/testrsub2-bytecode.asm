; Assembly for testrsub2-bytecode.bas
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
r3	.block	5
r4	.block	5
r5	.block	5
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

LINE_10

	; B=2.5

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_B
	.byte	bytecode_FLT_2p50000

	; C=5.2

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_C
	.byte	bytecode_FLT_5p19999

LINE_20

	; D=FRACT(C)

	.byte	bytecode_fract_fr1_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_D

LINE_40

	; D=C-SQR(C)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_sqr_fr1_fr1

	.byte	bytecode_rsub_fr1_fr1_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_D

LINE_60

	; D=-D+(C)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_rsub_fx_fx_fr1
	.byte	bytecode_FLTVAR_D

LINE_70

	; D=B-C

	.byte	bytecode_sub_fr1_fx_fd
	.byte	bytecode_FLTVAR_B
	.byte	bytecode_FLTVAR_C

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_D

LINE_80

	; PRINT STR$(D);" \r";

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_D

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_clear	.equ	0
bytecode_fract_fr1_fx	.equ	1
bytecode_ld_fd_fx	.equ	2
bytecode_ld_fr1_fx	.equ	3
bytecode_ld_fx_fr1	.equ	4
bytecode_pr_sr1	.equ	5
bytecode_pr_ss	.equ	6
bytecode_progbegin	.equ	7
bytecode_progend	.equ	8
bytecode_rsub_fr1_fr1_fx	.equ	9
bytecode_rsub_fx_fx_fr1	.equ	10
bytecode_sqr_fr1_fr1	.equ	11
bytecode_str_sr1_fx	.equ	12
bytecode_sub_fr1_fx_fd	.equ	13

catalog
	.word	clear
	.word	fract_fr1_fx
	.word	ld_fd_fx
	.word	ld_fr1_fx
	.word	ld_fx_fr1
	.word	pr_sr1
	.word	pr_ss
	.word	progbegin
	.word	progend
	.word	rsub_fr1_fr1_fx
	.word	rsub_fx_fx_fr1
	.word	sqr_fr1_fr1
	.word	str_sr1_fx
	.word	sub_fr1_fx_fd

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
	tst	tmp1+1
	rts

	.module	mdmsbit
; ACCA = MSBit(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   most siginficant bit in ACCA
;          0 = sign bit, 39 = LSB. 40 if zero
msbit
	pshx
	clra
_nxtbyte
	ldab	,x
	bne	_dobit
	adda	#8
	inx
	cmpa	#40
	blo	_nxtbyte
_rts
	pulx
	rts
_dobit
	lslb
	bcs	_rts
	inca
	bra	_dobit

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

	.module	mdsetbit
; SetBit
;   ENTRY  ACCA holds bit to set
;   ENTRY  X holds floating point reg
;   EXIT   bit set in register
;          0 = sign bit, 39 = LSB.
setbit
	suba	#8
	blo	_dobit
	inx
	bra	setbit
_dobit
	ldab	#$80
	adda	#8
	beq	_set
_nxtbit
	lsrb
	deca
	bne	_nxtbit
_set
	orab	,x
	stab	,x
	rts

	.module	mdsqr
; X = SQR(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   Y = SQRT(X) in (0,x 1,x 2,x 3,x 4,x)
;          Ysq   ( 5,x  6,x  7,x  8,x  9,x)
;          Yd    (10,x 11,x 12,x 13,x 14,x)
;          bit   (15,x 16,x 17,x 18,x 19,x)
;          bitsq (20,x 21,x 22,x 23,x 24,x)
;          uses argv for radicand and tmp1-tmp4
sqr
	jsr	msbit
	cmpa	#40
	bne	_chkpos
	rts
_chkpos
	tsta
	bne	_pos
	ldab	#FC_ERROR
	jmp	error
_pos
	staa	tmp1
	stx	tmp4
	jsr	x2arg
	ldab	#12
	stab	tmp1+1
	ldd	#0
_clrx
	std	,x
	inx
	inx
	dec	tmp1+1
	bne	_clrx
	std	tmp2
	std	tmp3
	; setup bitsq
	ldx	tmp4
	ldab	#20
	abx
	ldaa	tmp1
	oraa	#1
	jsr	setbit
	; setup bit
	ldx	tmp4
	ldab	#15
	abx
	ldaa	tmp1
	lsra
	adda	#12
	jsr	setbit
	ldx	tmp4
	; tmp = ysq + (yd=2*ysq*bitsq) + bitsq
_loop
	ldd	23,x
	addd	13,x
	rol	tmp1
	addd	8,x
	std	tmp3
	ldaa	tmp1
	ldab	22,x
	adcb	12,x
	rora
	adcb	7,x
	stab	tmp2+1
	ldab	21,x
	adcb	11,x
	rola
	adcb	6,x
	stab	tmp2
	ldab	20,x
	adcb	10,x
	rora
	adcb	5,x
	stab	tmp1+1
	; see if tmp <= x
	subb	0+argv
	bhi	_nogood
	blo	_good
	ldd	tmp2
	subd	1+argv
	bhi	_nogood
	blo	_good
	ldd	tmp3
	subd	3+argv
	bhi	_nogood
_good
	; ysq = tmp
	ldd	tmp3
	std	8,x
	ldd	tmp2
	std	6,x
	ldab	tmp1+1
	stab	5,x
	; y += bit
	ldd	3,x
	addd	18,x
	std	3,x
	ldd	1,x
	adcb	17,x
	adca	16,x
	std	1,x
	ldab	0,x
	adcb	15,x
	stab	0,x
	; yd = (yd + 2*bitsq)/2
	lsr	10,x
	ror	11,x
	ror	12,x
	ldd	13,x
	rora
	rorb
	addd	23,x
	std	13,x
	ldd	11,x
	adcb	22,x
	adca	21,x
	std	11,x
	ldab	10,x
	adcb	20,x
	stab	10,x
	bra	_shift
_nogood
	; yd = yd/2
	lsr	10,x
	ror	11,x
	ror	12,x
	ror	13,x
	ror	14,x
_shift
	; bitsq /= 4
	lsr	20,x
	ror	21,x
	ror	22,x
	ror	23,x
	ror	24,x
	lsr	20,x
	ror	21,x
	ror	22,x
	ror	23,x
	ror	24,x
	; bit /= 2
	lsr	15,x
	ror	16,x
	ror	17,x
	ror	18,x
	ror	19,x
	; loop while bit exists
	bne	_jloop
	ldd	17,x
	bne	_jloop
	ldd	15,x
	bne	_jloop
	rts
_jloop
	jmp	_loop

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

	.module	mdx2arg
; copy [X] to argv
;   ENTRY  Y in 0,x 1,x 2,x 3,x 4,x
;   EXIT   Y copied to 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
	; copy x to argv
x2arg
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
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

fract_fr1_fx			; numCalls = 1
	.module	modfract_fr1_fx
	jsr	extend
	ldd	#0
	stab	r1
	std	r1+1
	ldd	3,x
	std	r1+3
	rts

ld_fd_fx			; numCalls = 2
	.module	modld_fd_fx
	jsr	dexext
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

ld_fr1_fx			; numCalls = 2
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 3
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

pr_sr1			; numCalls = 1
	.module	modpr_sr1
	jsr	noargs
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 1
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

rsub_fr1_fr1_fx			; numCalls = 1
	.module	modrsub_fr1_fr1_fx
	jsr	extend
	ldd	3,x
	subd	r1+3
	std	r1+3
	ldd	1,x
	sbcb	r1+2
	sbca	r1+1
	std	r1+1
	ldab	0,x
	sbcb	r1
	stab	r1
	rts

rsub_fx_fx_fr1			; numCalls = 1
	.module	modrsub_fx_fx_fr1
	jsr	extend
	ldd	r1+3
	subd	3,x
	std	3,x
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	std	1,x
	ldab	r1
	sbcb	0,x
	stab	0,x
	rts

sqr_fr1_fr1			; numCalls = 1
	.module	modsqr_fr1_fr1
	jsr	noargs
	ldx	#r1
	jmp	sqr

str_sr1_fx			; numCalls = 1
	.module	modstr_sr1_fx
	jsr	extend
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

sub_fr1_fx_fd			; numCalls = 1
	.module	modsub_fr1_fx_fd
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	ldx	tmp1
	subd	3,x
	std	r1+3
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

; data table
startdata
enddata

; Bytecode symbol lookup table

bytecode_FLT_2p50000	.equ	0
bytecode_FLT_5p19999	.equ	1

bytecode_FLTVAR_B	.equ	2
bytecode_FLTVAR_C	.equ	3
bytecode_FLTVAR_D	.equ	4

symtbl
	.word	FLT_2p50000
	.word	FLT_5p19999

	.word	FLTVAR_B
	.word	FLTVAR_C
	.word	FLTVAR_D


; fixed-point constants
FLT_2p50000	.byte	$00, $00, $02, $80, $00
FLT_5p19999	.byte	$00, $00, $05, $33, $33

; block started by symbol
bss

; Numeric Variables
FLTVAR_B	.block	5
FLTVAR_C	.block	5
FLTVAR_D	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

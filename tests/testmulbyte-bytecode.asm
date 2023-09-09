; Assembly for testmulbyte-bytecode.bas
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

	; X=111111

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INT_111111

LINE_11

	; PRINT " 666666 =";STR$(X*6);" \r";

	.byte	bytecode_pr_ss
	.text	9, " 666666 ="

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	6

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_12

	; PRINT "-555555 =";STR$(X*-5);" \r";

	.byte	bytecode_pr_ss
	.text	9, "-555555 ="

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_mul_ir1_ir1_nb
	.byte	-5

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_13

	; PRINT " 333333 =";STR$(X*3);" \r";

	.byte	bytecode_pr_ss
	.text	9, " 333333 ="

	.byte	bytecode_mul3_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_14

	; PRINT " 666666 =";STR$((ABS(X)+X)*3);" \r";

	.byte	bytecode_pr_ss
	.text	9, " 666666 ="

	.byte	bytecode_abs_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_mul3_ir1_ir1

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_20

	; Y=111111.11111

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_Y
	.byte	bytecode_FLT_111111p11111

LINE_21

	; PRINT " 666666.66666 =";STR$(Y*6);" \r";

	.byte	bytecode_pr_ss
	.text	15, " 666666.66666 ="

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	6

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_22

	; PRINT "-555555.55555 =";STR$(Y*-5);" \r";

	.byte	bytecode_pr_ss
	.text	15, "-555555.55555 ="

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_mul_fr1_fr1_nb
	.byte	-5

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_23

	; PRINT " 333333.33333 =";STR$(Y*3);" \r";

	.byte	bytecode_pr_ss
	.text	15, " 333333.33333 ="

	.byte	bytecode_mul3_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_24

	; PRINT " 666666.66666 =";STR$((ABS(Y)+Y)*3);" \r";

	.byte	bytecode_pr_ss
	.text	15, " 666666.66666 ="

	.byte	bytecode_abs_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_mul3_fr1_fr1

	.byte	bytecode_str_sr1_fr1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_abs_fr1_fx	.equ	0
bytecode_abs_ir1_ix	.equ	1
bytecode_add_fr1_fr1_fx	.equ	2
bytecode_add_ir1_ir1_ix	.equ	3
bytecode_clear	.equ	4
bytecode_ld_fd_fx	.equ	5
bytecode_ld_fr1_fx	.equ	6
bytecode_ld_id_ix	.equ	7
bytecode_ld_ir1_ix	.equ	8
bytecode_mul3_fr1_fr1	.equ	9
bytecode_mul3_fr1_fx	.equ	10
bytecode_mul3_ir1_ir1	.equ	11
bytecode_mul3_ir1_ix	.equ	12
bytecode_mul_fr1_fr1_nb	.equ	13
bytecode_mul_fr1_fr1_pb	.equ	14
bytecode_mul_ir1_ir1_nb	.equ	15
bytecode_mul_ir1_ir1_pb	.equ	16
bytecode_pr_sr1	.equ	17
bytecode_pr_ss	.equ	18
bytecode_progbegin	.equ	19
bytecode_progend	.equ	20
bytecode_str_sr1_fr1	.equ	21
bytecode_str_sr1_ir1	.equ	22

catalog
	.word	abs_fr1_fx
	.word	abs_ir1_ix
	.word	add_fr1_fr1_fx
	.word	add_ir1_ir1_ix
	.word	clear
	.word	ld_fd_fx
	.word	ld_fr1_fx
	.word	ld_id_ix
	.word	ld_ir1_ix
	.word	mul3_fr1_fr1
	.word	mul3_fr1_fx
	.word	mul3_ir1_ir1
	.word	mul3_ir1_ix
	.word	mul_fr1_fr1_nb
	.word	mul_fr1_fr1_pb
	.word	mul_ir1_ir1_nb
	.word	mul_ir1_ir1_pb
	.word	pr_sr1
	.word	pr_ss
	.word	progbegin
	.word	progend
	.word	str_sr1_fr1
	.word	str_sr1_ir1

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

	.module	mdmul3f
; multiply X by 3
; result in X
; clobbers TMP1+1..TMP3+1
mul3f
	ldd	3,x
	lsld
	std	tmp3
	ldd	1,x
	rolb
	rola
	std	tmp2
	ldab	0,x
	rolb
	stab	tmp1+1
	ldd	3,x
	addd	tmp3
	std	3,x
	ldd	1,x
	adcb	tmp2+1
	adca	tmp2
	std	1,x
	ldab	0,x
	adcb	tmp1+1
	stab	0,x
	rts

	.module	mdmul3i
; multiply X by 3
; result in X
; clobbers TMP1+1
mul3i
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	lsld
	rol	tmp1+1
	addd	1,x
	std	1,x
	ldab	0,x
	adcb	tmp1+1
	stab	0,x
	rts

	.module	mdmulbytf
; multiply X with ACCB
; result in X
; clobbers TMP1+1...TMP3+1
mulbytf
	bsr	mulbyti
	ldaa	4,x
	ldab	tmp1
	mul
	std	tmp3
	ldaa	3,x
	ldab	tmp1
	mul
	addd	tmp2+1
	std	tmp2+1
	ldd	tmp1+1
	adcb	#0
	adca	#0
	std	tmp1+1
	rts

	.module	mdmulbyti
; multiply X with ACCB
; result in TMP1+1...TMP2+1
; clobbers TMP1
mulbyti
	stab	tmp1
	ldaa	2,x
	mul
	std	tmp2
	ldaa	0,x
	ldab	tmp1
	mul
	stab	tmp1+1
	ldaa	1,x
	ldab	tmp1
	mul
	addd	tmp1+1
	std	tmp1+1
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

	.module	mdntmp2xf
ntmp2xf
	ldd	#0
	subd	tmp3
	std	3,x
	ldd	#0
	sbcb	tmp2+1
	sbca	tmp2
	std	1,x
	ldab	#0
	sbcb	tmp1+1
	stab	0,x
	rts

	.module	mdntmp2xi
ntmp2xi
	ldd	#0
	subd	tmp2
	std	1,x
	ldab	#0
	sbcb	tmp1+1
	stab	0,x
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

	.module	mdtmp2xf
; copy fixedpt tmp to [X]
;   ENTRY  Y in tmp1+1,tmp2,tmp3
;   EXIT   Y copied to 0,x 1,x 2,x 3,x 4,x
tmp2xf
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts

	.module	mdtmp2xi
; copy integer tmp to [X]
;   ENTRY  Y in tmp1+1,tmp2
;   EXIT   Y copied to 0,x 1,x 2,x
tmp2xi
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

abs_fr1_fx			; numCalls = 1
	.module	modabs_fr1_fx
	jsr	extend
	ldaa	0,x
	bpl	_copy
	ldd	#0
	subd	3,x
	std	r1+3
	ldd	#0
	sbcb	2,x
	sbca	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts
_copy
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

abs_ir1_ix			; numCalls = 1
	.module	modabs_ir1_ix
	jsr	extend
	ldaa	0,x
	bpl	_copy
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts
_copy
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

add_fr1_fr1_fx			; numCalls = 1
	.module	modadd_fr1_fr1_fx
	jsr	extend
	ldd	r1+3
	addd	3,x
	std	r1+3
	ldd	r1+1
	adcb	2,x
	adca	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 1
	.module	modadd_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
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
	stx	DP_DATA
	rts

ld_fd_fx			; numCalls = 1
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

ld_id_ix			; numCalls = 1
	.module	modld_id_ix
	jsr	dexext
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 2
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

mul3_fr1_fr1			; numCalls = 1
	.module	modmul3_fr1_fr1
	jsr	noargs
	ldx	#r1
	jmp	mul3f

mul3_fr1_fx			; numCalls = 1
	.module	modmul3_fr1_fx
	jsr	extend
	ldd	3,x
	lsld
	std	tmp3
	ldd	1,x
	rolb
	rola
	std	tmp2
	ldab	0,x
	rolb
	stab	tmp1+1
	ldd	3,x
	addd	tmp3
	std	r1+3
	ldd	1,x
	adcb	tmp2+1
	adca	tmp2
	std	r1+1
	ldab	0,x
	adcb	tmp1+1
	stab	r1
	rts

mul3_ir1_ir1			; numCalls = 1
	.module	modmul3_ir1_ir1
	jsr	noargs
	ldx	#r1
	jmp	mul3i

mul3_ir1_ix			; numCalls = 1
	.module	modmul3_ir1_ix
	jsr	extend
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	lsld
	rol	tmp1+1
	addd	1,x
	std	r1+1
	ldab	0,x
	adcb	tmp1+1
	stab	r1
	rts

mul_fr1_fr1_nb			; numCalls = 1
	.module	modmul_fr1_fr1_nb
	jsr	getbyte
	negb
	ldx	#r1
	jsr	mulbytf
	jmp	ntmp2xf

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_nb			; numCalls = 1
	.module	modmul_ir1_ir1_nb
	jsr	getbyte
	negb
	ldx	#r1
	jsr	mulbyti
	jmp	ntmp2xi

mul_ir1_ir1_pb			; numCalls = 1
	.module	modmul_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

pr_sr1			; numCalls = 8
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

pr_ss			; numCalls = 16
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

str_sr1_fr1			; numCalls = 4
	.module	modstr_sr1_fr1
	jsr	noargs
	ldd	r1+1
	std	tmp2
	ldab	r1
	stab	tmp1+1
	ldd	r1+3
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

str_sr1_ir1			; numCalls = 4
	.module	modstr_sr1_ir1
	jsr	noargs
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

; data table
startdata
enddata

; Bytecode symbol lookup table

bytecode_INT_111111	.equ	0
bytecode_FLT_111111p11111	.equ	1

bytecode_INTVAR_X	.equ	2
bytecode_FLTVAR_Y	.equ	3

symtbl
	.word	INT_111111
	.word	FLT_111111p11111

	.word	INTVAR_X
	.word	FLTVAR_Y


; large integer constants
INT_111111	.byte	$01, $b2, $07

; fixed-point constants
FLT_111111p11111	.byte	$01, $b2, $07, $1c, $72

; block started by symbol
bss

; Numeric Variables
INTVAR_X	.block	3
FLTVAR_Y	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

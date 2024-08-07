; Assembly for testmul-bytecode.bas
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

	; CLS

	.byte	bytecode_cls

	; DIM S(7),T(7),E(6),F(6),X(6),Y(6),T,P,X,Y,P

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_S

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_T

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Y

LINE_10

	; P=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_P

LINE_20

	; S(P)=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_S
	.byte	bytecode_INTVAR_P

	.byte	bytecode_one_ip

	; T(P)=8

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ip_pb
	.byte	8

	; E(P)=23

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_E
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ip_pb
	.byte	23

	; F(P)=9

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ip_pb
	.byte	9

	; X(P)=ABS(S(P)-E(P))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_P

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_S
	.byte	bytecode_INTVAR_P

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_E
	.byte	bytecode_INTVAR_P

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_abs_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Y(P)=RND(40)+-10

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_P

	.byte	bytecode_irnd_ir1_pb
	.byte	40

	.byte	bytecode_add_ir1_ir1_nb
	.byte	-10

	.byte	bytecode_ld_ip_ir1

LINE_70

	; FOR T=0 TO 1 STEP 0.01

	.byte	bytecode_forclr_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_to_fp_pb
	.byte	1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLT_0p00999

	.byte	bytecode_step_fp_fr1

LINE_75

	; T1=SQ(1-T)

	.byte	bytecode_sub_fr1_pb_fx
	.byte	1
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_sq_fr1_fr1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_T1

	; T2=SHIFT((1-T)*T,1)

	.byte	bytecode_sub_fr1_pb_fx
	.byte	1
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_mul_fr1_fr1_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_dbl_fr1_fr1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_T2

	; T3=SQ(T)

	.byte	bytecode_sq_fr1_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_T3

LINE_76

	; U=(S(P)*T1)+(X(P)*T2)+(E(P)*T3)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_S
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_T1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_T2

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_E
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_T3

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_U

LINE_77

	; V=(T(P)*T1)+(Y(P)*T2)+(F(P)*T3)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_T1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_T2

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_T3

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_V

LINE_80

	; X=(SQ(1-T)*S(P))+SHIFT((1-T)*X(P)*T,1)+(SQ(T)*E(P))

	.byte	bytecode_sub_fr1_pb_fx
	.byte	1
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_sq_fr1_fr1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_S
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr1_fr1_ir2

	.byte	bytecode_sub_fr2_pb_fx
	.byte	1
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_fr2_ir3

	.byte	bytecode_mul_fr2_fr2_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_dbl_fr2_fr2

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_sq_fr2_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_E
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_fr2_ir3

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_X

LINE_90

	; Y=(SQ(1-T)*T(P))+SHIFT((1-T)*Y(P)*T,1)+(SQ(T)*F(P))

	.byte	bytecode_sub_fr1_pb_fx
	.byte	1
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_sq_fr1_fr1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr1_fr1_ir2

	.byte	bytecode_sub_fr2_pb_fx
	.byte	1
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_fr2_ir3

	.byte	bytecode_mul_fr2_fr2_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_dbl_fr2_fr2

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_sq_fr2_fx
	.byte	bytecode_FLTVAR_T

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_P

	.byte	bytecode_mul_fr2_fr2_ir3

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_Y

LINE_100

	; PRINT STR$(X);" ";STR$(Y);" \r";

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_105

	; PRINT STR$(U);" ";STR$(V);" \r";

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_U

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_125

	; WHEN INKEY$="" GOTO 125

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_125

LINE_130

	; NEXT

	.byte	bytecode_next

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_abs_ir1_ir1	.equ	0
bytecode_add_fr1_fr1_fr2	.equ	1
bytecode_add_ir1_ir1_nb	.equ	2
bytecode_arrdim1_ir1_ix	.equ	3
bytecode_arrref1_ir1_ix_id	.equ	4
bytecode_arrval1_ir1_ix_id	.equ	5
bytecode_arrval1_ir2_ix_id	.equ	6
bytecode_arrval1_ir3_ix_id	.equ	7
bytecode_clear	.equ	8
bytecode_cls	.equ	9
bytecode_dbl_fr1_fr1	.equ	10
bytecode_dbl_fr2_fr2	.equ	11
bytecode_forclr_fx	.equ	12
bytecode_inkey_sr1	.equ	13
bytecode_irnd_ir1_pb	.equ	14
bytecode_jmpne_ir1_ix	.equ	15
bytecode_ld_fr1_fx	.equ	16
bytecode_ld_fx_fr1	.equ	17
bytecode_ld_ip_ir1	.equ	18
bytecode_ld_ip_pb	.equ	19
bytecode_ld_ir1_pb	.equ	20
bytecode_ldeq_ir1_sr1_ss	.equ	21
bytecode_mul_fr1_fr1_fx	.equ	22
bytecode_mul_fr1_fr1_ir2	.equ	23
bytecode_mul_fr1_ir1_fx	.equ	24
bytecode_mul_fr2_fr2_fx	.equ	25
bytecode_mul_fr2_fr2_ir3	.equ	26
bytecode_mul_fr2_ir2_fx	.equ	27
bytecode_next	.equ	28
bytecode_one_ip	.equ	29
bytecode_one_ix	.equ	30
bytecode_pr_sr1	.equ	31
bytecode_pr_ss	.equ	32
bytecode_progbegin	.equ	33
bytecode_progend	.equ	34
bytecode_sq_fr1_fr1	.equ	35
bytecode_sq_fr1_fx	.equ	36
bytecode_sq_fr2_fx	.equ	37
bytecode_step_fp_fr1	.equ	38
bytecode_str_sr1_fx	.equ	39
bytecode_sub_fr1_pb_fx	.equ	40
bytecode_sub_fr2_pb_fx	.equ	41
bytecode_sub_ir1_ir1_ir2	.equ	42
bytecode_to_fp_pb	.equ	43

catalog
	.word	abs_ir1_ir1
	.word	add_fr1_fr1_fr2
	.word	add_ir1_ir1_nb
	.word	arrdim1_ir1_ix
	.word	arrref1_ir1_ix_id
	.word	arrval1_ir1_ix_id
	.word	arrval1_ir2_ix_id
	.word	arrval1_ir3_ix_id
	.word	clear
	.word	cls
	.word	dbl_fr1_fr1
	.word	dbl_fr2_fr2
	.word	forclr_fx
	.word	inkey_sr1
	.word	irnd_ir1_pb
	.word	jmpne_ir1_ix
	.word	ld_fr1_fx
	.word	ld_fx_fr1
	.word	ld_ip_ir1
	.word	ld_ip_pb
	.word	ld_ir1_pb
	.word	ldeq_ir1_sr1_ss
	.word	mul_fr1_fr1_fx
	.word	mul_fr1_fr1_ir2
	.word	mul_fr1_ir1_fx
	.word	mul_fr2_fr2_fx
	.word	mul_fr2_fr2_ir3
	.word	mul_fr2_ir2_fx
	.word	next
	.word	one_ip
	.word	one_ix
	.word	pr_sr1
	.word	pr_ss
	.word	progbegin
	.word	progend
	.word	sq_fr1_fr1
	.word	sq_fr1_fx
	.word	sq_fr2_fx
	.word	step_fp_fr1
	.word	str_sr1_fx
	.word	sub_fr1_pb_fx
	.word	sub_fr2_pb_fx
	.word	sub_ir1_ir1_ir2
	.word	to_fp_pb

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

	.module	mdgetlw
; fetch lower word from integer variable descriptor
;  ENTRY: D holds integer variable descriptor
;  EXIT: D holds lower word of integer variable
getlw
	std	tmp1
	stx	tmp2
	ldx	tmp1
	ldd	1,x
	ldx	tmp2
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

	.module	mdmulflt
mulfltx
	bsr	mulfltt
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts
mulfltt
	jsr	mulhlf
	clr	tmp4
_4_3
	ldaa	4+argv
	beq	_3_4
	ldab	3,x
	bsr	_m43
_4_1
	ldaa	4+argv
	ldab	1,x
	bsr	_m41
_4_2
	ldaa	4+argv
	ldab	2,x
	bsr	_m42
_4_0
	ldaa	4+argv
	ldab	0,x
	bsr	_m40
	ldab	0,x
	bpl	_4_4
	ldd	tmp1+1
	subb	4+argv
	sbca	#0
	std	tmp1+1
_4_4
	ldaa	4+argv
	ldab	4,x
	beq	_rndup
	mul
	adca	tmp4
	staa	tmp4
	bsr	mulflt3
_3_4
	ldab	4,x
	beq	_rndup
	ldaa	3+argv
	bsr	_m43
_1_4
	ldab	4,x
	ldaa	1+argv
	bsr	_m41
_2_4
	ldab	4,x
	ldaa	2+argv
	bsr	_m42
_0_4
	ldab	4,x
	ldaa	0+argv
	bsr	_m40
	ldaa	0+argv
	bpl	_rndup
	ldd	tmp1+1
	subb	4,x
	sbca	#0
	std	tmp1+1
_rndup
	ldaa	tmp4
	lsla
mulflt3
	ldd	tmp3
	adcb	#0
	adca	#0
	std	tmp3
	ldd	tmp2
	adcb	#0
	adca	#0
	jmp	mulhlf2
_m43
	mul
	addd	tmp3+1
	std	tmp3+1
	rol	tmp4+1
	rts
_m41
	mul
	lsr	tmp4+1
	adcb	tmp3
	adca	tmp2+1
	std	tmp2+1
	ldd	tmp1+1
	adcb	#0
	adca	#0
	std	tmp1+1
	rts
_m42
	mul
	addd	tmp3
	std	tmp3
	rol	tmp4+1
	rts
_m40
	mul
	lsr	tmp4+1
	adcb	tmp2+1
	adca	tmp2
	bra	mulhlf2

	.module	mdmulhlf
mulhlf
	bsr	mulint
	ldd	#0
	std	tmp3
	stab	tmp4+1
_3_2
	ldaa	3+argv
	beq	_2_3
	ldab	2,x
	bsr	_m32
_3_0
	ldaa	3+argv
	ldab	0,x
	bsr	_m30
	ldab	0,x
	bpl	_3_3
	ldab	tmp1+1
	subb	3+argv
	stab	tmp1+1
_3_3
	ldaa	3+argv
	ldab	3,x
	mul
	adda	tmp3
	std	tmp3
	rol	tmp4+1
_3_1
	ldaa	3+argv
	ldab	1,x
	bsr	_m31
_2_3
	ldab	3,x
	beq	_rts
	ldaa	2+argv
	bsr	_m32
_0_3
	ldab	3,x
	ldaa	0+argv
	bsr	_m30
	ldaa	0+argv
	bpl	_1_3
	ldab	tmp1+1
	subb	3,x
	stab	tmp1+1
_1_3
	ldab	3,x
	ldaa	1+argv
	clr	tmp4+1
_m31
	mul
	lsr	tmp4+1
	adcb	tmp2+1
	adca	tmp2
mulhlf2
	std	tmp2
	ldab	tmp1+1
	adcb	#0
	stab	tmp1+1
	rts
_m32
	mul
	addd	tmp2+1
	std	tmp2+1
	rol	tmp4+1
	rts
_m30
	mul
	lsr	tmp4+1
	adcb	tmp2
	adca	tmp1+1
	std	tmp1+1
_rts
	rts

	.module	mdmulint
mulint
	ldaa	2+argv
	ldab	2,x
	mul
	std	tmp2
	ldaa	1+argv
	ldab	1,x
	mul
	stab	tmp1+1
	ldaa	2+argv
	ldab	1,x
	mul
	addd	tmp1+1
	std	tmp1+1
	ldaa	1+argv
	ldab	2,x
	mul
	addd	tmp1+1
	std	tmp1+1
	ldaa	2+argv
	ldab	0,x
	mul
	addb	tmp1+1
	stab	tmp1+1
	ldaa	0+argv
	ldab	2,x
	mul
	addb	tmp1+1
	stab	tmp1+1
	rts
mulintx
	bsr	mulint
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
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

	.module	mdnegx
negx
	neg	4,x
	bcs	_com3
	neg	3,x
	bcs	_com2
negxi
	neg	2,x
	bcs	_com1
	neg	1,x
	bcs	_com0
	neg	0,x
	rts
_com3
	com	3,x
_com2
	com	2,x
_com1
	com	1,x
_com0
	com	0,x
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

	.module	mdtobc
; push for-loop record on stack
; ENTRY:  ACCB  contains size of record
;         r1    contains stopping variable
;               and is always fixedpoint.
;         r1+3  must contain zero when both:
;               1. loop var is integral.
;               2. STEP is missing
to
	clra
	std	tmp3
	pulx
	stx	tmp1
	tsx
	clrb
_nxtfor
	abx
	ldd	1,x
	subd	letptr
	beq	_oldfor
	ldab	,x
	cmpb	#3
	bhi	_nxtfor
	sts	tmp2
	ldd	tmp2
	subd	tmp3
	std	tmp2
	lds	tmp2
	tsx
	ldab	tmp3+1
	stab	0,x
	ldd	letptr
	std	1,x
_oldfor
	ldd	nxtinst
	std	3,x
	ldab	r1
	stab	5,x
	ldd	r1+1
	std	6,x
	ldd	r1+3
	std	8,x
	ldab	tmp3+1
	cmpb	#15
	beq	_flt
	inca
	staa	10,x
	bra	_done
_flt
	ldd	#0
	std	10,x
	std	13,x
	inca
	staa	12,x
_done
	ldx	tmp1
	jmp	,x

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

abs_ir1_ir1			; numCalls = 1
	.module	modabs_ir1_ir1
	jsr	noargs
	ldaa	r1
	bpl	_rts
	ldx	#r1
	jmp	negxi
_rts
	rts

add_fr1_fr1_fr2			; numCalls = 8
	.module	modadd_fr1_fr1_fr2
	jsr	noargs
	ldd	r1+3
	addd	r2+3
	std	r1+3
	ldd	r1+1
	adcb	r2+2
	adca	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_nb			; numCalls = 1
	.module	modadd_ir1_ir1_nb
	jsr	getbyte
	ldaa	#-1
	addd	r1+1
	std	r1+1
	ldab	#-1
	adcb	r1
	stab	r1
	rts

arrdim1_ir1_ix			; numCalls = 6
	.module	modarrdim1_ir1_ix
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

arrref1_ir1_ix_id			; numCalls = 6
	.module	modarrref1_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 3
	.module	modarrval1_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval1_ir2_ix_id			; numCalls = 7
	.module	modarrval1_ir2_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval1_ir3_ix_id			; numCalls = 4
	.module	modarrval1_ir3_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r3
	ldd	1,x
	std	r3+1
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

dbl_fr1_fr1			; numCalls = 1
	.module	moddbl_fr1_fr1
	jsr	noargs
	ldx	#r1
	lsl	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dbl_fr2_fr2			; numCalls = 2
	.module	moddbl_fr2_fr2
	jsr	noargs
	ldx	#r2
	lsl	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	rts

forclr_fx			; numCalls = 1
	.module	modforclr_fx
	jsr	extend
	stx	letptr
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

inkey_sr1			; numCalls = 1
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

irnd_ir1_pb			; numCalls = 1
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

ld_fr1_fx			; numCalls = 1
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 7
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_ir1			; numCalls = 2
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 3
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_pb			; numCalls = 6
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 1
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

mul_fr1_fr1_fx			; numCalls = 1
	.module	modmul_fr1_fr1_fx
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_fr1_ir2			; numCalls = 2
	.module	modmul_fr1_fr1_ir2
	jsr	noargs
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_ir1_fx			; numCalls = 2
	.module	modmul_fr1_ir1_fx
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#0
	std	r1+3
	ldx	#r1
	jmp	mulfltx

mul_fr2_fr2_fx			; numCalls = 2
	.module	modmul_fr2_fr2_fx
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r2
	jmp	mulfltx

mul_fr2_fr2_ir3			; numCalls = 4
	.module	modmul_fr2_fr2_ir3
	jsr	noargs
	ldab	r3
	stab	0+argv
	ldd	r3+1
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r2
	jmp	mulfltx

mul_fr2_ir2_fx			; numCalls = 4
	.module	modmul_fr2_ir2_fx
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#0
	std	r2+3
	ldx	#r2
	jmp	mulfltx

next			; numCalls = 1
	.module	modnext
	jsr	noargs
	pulx
	tsx
	ldab	,x
	cmpb	#3
	bhi	_ok
	ldab	#NF_ERROR
	jmp	error
_ok
	cmpb	#11
	bne	_flt
	ldab	8,x
	stab	r1
	ldd	9,x
	ldx	1,x
	addd	1,x
	std	r1+1
	std	1,x
	ldab	r1
	adcb	,x
	stab	r1
	stab	,x
	tsx
	tst	8,x
	bpl	_iopp
	ldd	r1+1
	subd	6,x
	ldab	r1
	sbcb	5,x
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
_done
	ldab	0,x
	abx
	txs
	jmp	mainloop
_flt
	ldab	10,x
	stab	r1
	ldd	11,x
	std	r1+1
	ldd	13,x
	ldx	1,x
	addd	3,x
	std	r1+3
	std	3,x
	ldd	1,x
	adcb	r1+2
	adca	r1+1
	std	r1+1
	std	1,x
	ldab	r1
	adcb	,x
	stab	r1
	stab	,x
	tsx
	tst	10,x
	bpl	_fopp
	ldd	r1+3
	subd	8,x
	ldd	r1+1
	sbcb	7,x
	sbca	6,x
	ldab	r1
	sbcb	5,x
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
_fopp
	ldd	8,x
	subd	r1+3
	ldd	6,x
	sbcb	r1+2
	sbca	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop

one_ip			; numCalls = 1
	.module	modone_ip
	jsr	noargs
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 1
	.module	modone_ix
	jsr	extend
	ldd	#1
	staa	0,x
	std	1,x
	rts

pr_sr1			; numCalls = 4
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

pr_ss			; numCalls = 4
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

sq_fr1_fr1			; numCalls = 3
	.module	modsq_fr1_fr1
	jsr	noargs
	ldx	#r1
	jsr	x2arg
	jmp	mulfltx

sq_fr1_fx			; numCalls = 1
	.module	modsq_fr1_fx
	jsr	extend
	jsr	x2arg
	jsr	mulfltt
	ldx	#r1
	jmp	tmp2xf

sq_fr2_fx			; numCalls = 2
	.module	modsq_fr2_fx
	jsr	extend
	jsr	x2arg
	jsr	mulfltt
	ldx	#r2
	jmp	tmp2xf

step_fp_fr1			; numCalls = 1
	.module	modstep_fp_fr1
	jsr	noargs
	tsx
	ldab	r1
	stab	12,x
	ldd	r1+1
	std	13,x
	ldd	r1+3
	std	15,x
	ldd	nxtinst
	std	5,x
	rts

str_sr1_fx			; numCalls = 4
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

sub_fr1_pb_fx			; numCalls = 4
	.module	modsub_fr1_pb_fx
	jsr	byteext
	stab	tmp1
	ldd	#0
	subd	3,x
	std	r1+3
	ldab	tmp1
	sbcb	2,x
	stab	r1+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r1
	rts

sub_fr2_pb_fx			; numCalls = 2
	.module	modsub_fr2_pb_fx
	jsr	byteext
	stab	tmp1
	ldd	#0
	subd	3,x
	std	r2+3
	ldab	tmp1
	sbcb	2,x
	stab	r2+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r2
	rts

sub_ir1_ir1_ir2			; numCalls = 1
	.module	modsub_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

to_fp_pb			; numCalls = 1
	.module	modto_fp_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

; data table
startdata
enddata

; Bytecode symbol lookup table

bytecode_FLT_0p00999	.equ	0

bytecode_INTVAR_P	.equ	1
bytecode_FLTVAR_T	.equ	2
bytecode_FLTVAR_T1	.equ	3
bytecode_FLTVAR_T2	.equ	4
bytecode_FLTVAR_T3	.equ	5
bytecode_FLTVAR_U	.equ	6
bytecode_FLTVAR_V	.equ	7
bytecode_FLTVAR_X	.equ	8
bytecode_FLTVAR_Y	.equ	9
bytecode_INTARR_E	.equ	10
bytecode_INTARR_F	.equ	11
bytecode_INTARR_S	.equ	12
bytecode_INTARR_T	.equ	13
bytecode_INTARR_X	.equ	14
bytecode_INTARR_Y	.equ	15

symtbl
	.word	FLT_0p00999

	.word	INTVAR_P
	.word	FLTVAR_T
	.word	FLTVAR_T1
	.word	FLTVAR_T2
	.word	FLTVAR_T3
	.word	FLTVAR_U
	.word	FLTVAR_V
	.word	FLTVAR_X
	.word	FLTVAR_Y
	.word	INTARR_E
	.word	INTARR_F
	.word	INTARR_S
	.word	INTARR_T
	.word	INTARR_X
	.word	INTARR_Y


; fixed-point constants
FLT_0p00999	.byte	$00, $00, $00, $02, $8f

; block started by symbol
bss

; Numeric Variables
INTVAR_P	.block	3
FLTVAR_T	.block	5
FLTVAR_T1	.block	5
FLTVAR_T2	.block	5
FLTVAR_T3	.block	5
FLTVAR_U	.block	5
FLTVAR_V	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
; Numeric Arrays
INTARR_E	.block	4	; dims=1
INTARR_F	.block	4	; dims=1
INTARR_S	.block	4	; dims=1
INTARR_T	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

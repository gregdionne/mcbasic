; Assembly for testtrig-native.bas
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
r3	.block	5
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_10

	; TH=0.785398

	ldd	#FLTVAR_TH
	ldx	#FLT_0p78540
	jsr	ld_fd_fx

LINE_20

	; FOR I=1 TO 6

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

LINE_30

	; GOSUB 100

	ldx	#LINE_100
	jsr	gosub_ix

LINE_40

	; TH=TH/10

	ldx	#FLTVAR_TH
	jsr	ld_fr1_fx

	ldab	#10
	jsr	div_fr1_fr1_pb

	ldx	#FLTVAR_TH
	jsr	ld_fx_fr1

LINE_50

	; NEXT

	jsr	next

LINE_60

	; END

	jsr	progend

LINE_100

	; TS=SQ(TH)

	ldx	#FLTVAR_TH
	jsr	sq_fr1_fx

	ldx	#FLTVAR_TS
	jsr	ld_fx_fr1

LINE_110

	; X=(40320-((20160-((1680-((56-TS)*TS))*TS))*TS))/40320

	ldab	#56
	ldx	#FLTVAR_TS
	jsr	sub_fr1_pb_fx

	ldx	#FLTVAR_TS
	jsr	mul_fr1_fr1_fx

	ldd	#1680
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_TS
	jsr	mul_fr1_fr1_fx

	ldd	#20160
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_TS
	jsr	mul_fr1_fr1_fx

	ldd	#40320
	jsr	rsub_fr1_fr1_pw

	ldd	#40320
	jsr	div_fr1_fr1_pw

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

LINE_120

	; Y=(5040-((840-((42-TS)*TS))*TS))*TH/5040

	ldab	#42
	ldx	#FLTVAR_TS
	jsr	sub_fr1_pb_fx

	ldx	#FLTVAR_TS
	jsr	mul_fr1_fr1_fx

	ldd	#840
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_TS
	jsr	mul_fr1_fr1_fx

	ldd	#5040
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_TH
	jsr	mul_fr1_fr1_fx

	ldd	#5040
	jsr	div_fr1_fr1_pw

	ldx	#FLTVAR_Y
	jsr	ld_fx_fr1

LINE_130

	; PRINT STR$(X);" ";STR$(Y);" ";STR$(Y/X);" \r";

	ldx	#FLTVAR_X
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_Y
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldx	#FLTVAR_X
	jsr	div_fr1_fr1_fx

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_140

	; PRINT STR$(COS(TH));" ";STR$(SIN(TH));" ";STR$(TAN(TH));" \r";

	ldx	#FLTVAR_TH
	jsr	ld_fr1_fx

	jsr	cos_fr1_fr1

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_TH
	jsr	ld_fr1_fx

	jsr	sin_fr1_fr1

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	ldx	#FLTVAR_TH
	jsr	ld_fr1_fx

	jsr	tan_fr1_fr1

	jsr	str_sr1_fr1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_150

	; RETURN

	jsr	return

LLAST

	; END

	jsr	progend

	.module	mdarg2x
; copy argv to [X]
;   ENTRY  Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   Y copied to 0,x 1,x 2,x 3,x 4,x
arg2x
	ldab	0+argv
	stab	0,x
	ldd	1+argv
	std	1,x
	ldd	3+argv
	std	3,x
	rts

	.module	mdcos
; X = COS(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   COS(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses (5,x 6,x 7,x 8,x 9,x)
;          uses argv and tmp1-tmp4
cos
	ldd	3,x
	addd	#$9220
	std	3,x
	ldd	1,x
	adcb	#$1
	adca	#0
	std	1,x
	ldab	0,x
	adcb	#0
	stab	0,x
	jmp	sin

	.module	mddivflt
; divide X by Y
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   X/Y in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
divflt
	ldaa	#8*5
	bsr	divmod
	tst	tmp4
	bmi	_add1
_com
	ldd	8,x
	coma
	comb
	std	3,x
	ldd	6,x
	coma
	comb
	std	1,x
	ldab	5,x
	comb
	stab	0,x
	rts
_add1
	ldd	8,x
	addd	#1
	std	3,x
	ldd	6,x
	adcb	#0
	adca	#0
	std	1,x
	ldab	5,x
	adcb	#0
	stab	0,x
	rts
divuflt
	clr	tmp4
	ldab	#8*5
	stab	tmp1
	bsr	divumod
	bra	_com

	.module	mddivmod
; divide/modulo X by Y with remainder
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;          #shifts in ACCA (24 for modulus, 40 for division
;   EXIT   for division:
;            NOT ABS(X)/ABS(Y) in (5,x 6,x 7,x 8,x 9,x)
;   EXIT   for modulus:
;            NOT INT(ABS(X)/ABS(Y)) in (7,x 8,x 9,x)
;            FMOD(X,Y) in (0,x 1,x 2,x 3,x 4,x)
;          result sign in tmp4.(0 = pos, -1 = neg).
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
divmod
	staa	tmp1
	clr	tmp4
	tst	0,x
	bpl	_posX
	com	tmp4
	jsr	negx
_posX
	tst	0+argv
	bpl	divumod
	com	tmp4
	jsr	negargv
divumod
	ldd	3,x
	std	6,x
	ldd	1,x
	std	4,x
	ldab	0,x
	stab	3,x
	clra
	clrb
	std	8,x
	std	1,x
	stab	0,x
_nxtdiv
	rol	7,x
	rol	6,x
	rol	5,x
	rol	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	bcc	_trialsub
	; force subtraction
	ldd	3,x
	subd	3+argv
	std	3,x
	ldd	1,x
	sbcb	2+argv
	sbca	1+argv
	std	1,x
	ldab	0,x
	sbcb	0+argv
	stab	0,x
	clc
	bra	_shift
_trialsub
	ldd	3,x
	subd	3+argv
	std	tmp3
	ldd	1,x
	sbcb	2+argv
	sbca	1+argv
	std	tmp2
	ldab	0,x
	sbcb	0+argv
	stab	tmp1+1
	blo	_shift
	ldd	tmp3
	std	3,x
	ldd	tmp2
	std	1,x
	ldab	tmp1+1
	stab	0,x
_shift
	rol	9,x
	rol	8,x
	dec	tmp1
	bne	_nxtdiv
	rol	7,x
	rol	6,x
	rol	5,x
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

	.module	mdmodflt
; modulo X by Y
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   X%Y in (0,x 1,x 2,x 3,x 4,x)
;          FIX(X/Y) in (7,x 8,x 9,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
modflt
	ldaa	#8*3
	jsr	divmod
	tst	tmp4
	bpl	_rts
	jsr	negx
	ldd	8,x
	addd	#1
	std	8,x
	ldab	7,x
	adcb	#0
	stab	7,x
	rts
_rts
	com	9,x
	com	8,x
	com	7,x
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

	.module	mdnegargv
negargv
	neg	4+argv
	bcs	_com3
	neg	3+argv
	bcs	_com2
	neg	2+argv
	bcs	_com1
	neg	1+argv
	bcs	_com0
	neg	0+argv
	rts
_com3
	com	3+argv
_com2
	com	2+argv
_com1
	com	1+argv
_com0
	com	0+argv
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

	.module	mdrmul315
; special routine to divide by 5040 or 40320
;   (reciprocal-multiply by 315 and shifting)
;               1/5040 = 256/315 >> 16
;              1/40320 = 128/315 >> 16
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;          0DD0 or A11A in ACCD
;   EXIT   result in (0,x 1,x 2,x 3,x 4,x)
;          result ~= X/5040 when D is $0DD0
;          result ~= X/40320 when D is $A11A
;          uses argv and tmp1-tmp4 (tmp4+1 unused)
rmul315
	stab	4+argv
	tab
	anda	#$0f
	andb	#$f0
	std	2+argv
	ldd	#0
	std	0+argv
	jsr	mulfltx
	ldd	1,x
	std	3,x
	ldab	0,x
	stab	2,x
	ldd	#0
	std	0,x
	rts

	.module	mdsin
; X = SIN(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   SIN(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses (5,x 6,x 7,x 8,x 9,x)
;          uses argv and tmp1-tmp4 (tmp4+1 unused)
sin
	tst	0,x
	bpl	_sinpos
	jsr	negx
	bsr	_sinpos
	jmp	negx
_sinpos
	ldd	#0
	std	0+argv
	ldab	#$6
	stab	2+argv
	ldd	#$487F
	std	3+argv
	jsr	modflt
	jsr	x2arg
	stx	tmp1
	ldx	#_tbl_pi1
	bsr	_cmptbl
	blo	_q12
	bsr	_subtbl
	bsr	_q12
	jmp	negx
_q12
	ldx	#_tbl_pi2
	bsr	_cmptbl
	blo	_q1
	ldx	#_tbl_pi1
	bsr	_rsubtbl
_q1
	ldx	#_tbl_pi4
	bsr	_cmptbl
	blo	_sin
	ldx	#_tbl_pi2
	bsr	_rsubtbl
	jmp	_cos
	; compare argv with *x
_cmptbl
	ldd	2+argv
	subd	,x
	bne	_rts
	ldab	4+argv
	subb	2,x
_rts
	rts
	; subtract *x from argv
_subtbl
	ldd	3+argv
	subd	1,x
	std	3+argv
	ldab	2+argv
	sbcb	0,x
	stab	2+argv
	rts
	; subtract *x from argv then negate
_rsubtbl
	ldd	1,x
	subd	3+argv
	std	3+argv
	ldab	0,x
	sbcb	2+argv
	stab	2+argv
	rts
	; sin of angle less than pi/4
_sin
	ldx	tmp1
	jsr	arg2x
	ldd	3,x
	pshb
	psha
	jsr	mulfltx
	jsr	x2arg
	ldd	#42
	bsr	_rsubm
	ldd	#840
	bsr	_rsubm
	ldd	#5040
	bsr	_rsub
	pula
	pulb
	std	3+argv
	jsr	mulfltx
	ldd	#$0DD0
	jmp	rmul315
	; cos of angle less than pi/4
_cos
	ldx	tmp1
	jsr	arg2x
	jsr	mulfltx
	jsr	x2arg
	ldd	#56
	bsr	_rsubm
	ldd	#1680
	bsr	_rsubm
	ldd	#20160
	bsr	_rsubm
	ldd	#40320
	bsr	_rsub
	ldd	#$A11A
	jmp	rmul315
_rsubm
	bsr	_rsub
	jmp	mulfltx
_rsub
	neg	4,x
	bcs	_ngc1
	neg	3,x
	bra	_ngc2
_ngc1
	com	3,x
_ngc2
	sbcb	2,x
	sbca	1,x
	std	1,x
	bcs	_ngc3
	neg	0,x
	rts
_ngc3
	com	0,x
	rts
_tbl_pi1	.byte	$03,$24,$40
_tbl_pi2	.byte	$01,$92,$20
_tbl_pi4	.byte	$00,$C9,$10

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

	.module	mdtan
; X = TAN(X)
;   ENTRY  X in 0,X 1,X 2,X 3,X 4,X
;   EXIT   TAN(X) in (0,x 1,x 2,x 3,x 4,x)
;          uses ( 5,x  6,x  7,x  8,x  9,x)
;          uses (10,x 11,x 12,x 13,x 14,x)
;          uses argv and tmp1-tmp4
tan
	ldd	3,x
	pshb
	psha
	ldd	1,x
	pshb
	psha
	ldab	0,x
	pshb
	jsr	sin
	pulb
	stab	5,x
	pula
	pulb
	std	6,x
	pula
	pulb
	std	8,x
	pshx
	ldab	#5
	abx
	jsr	cos
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	pulx
	jmp	divflt

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

	.module	mdtonat
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
	ldd	tmp1
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

cos_fr1_fr1			; numCalls = 1
	.module	modcos_fr1_fr1
	ldx	#r1
	jmp	cos

div_fr1_fr1_fx			; numCalls = 1
	.module	moddiv_fr1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	divflt

div_fr1_fr1_pb			; numCalls = 1
	.module	moddiv_fr1_fr1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	divflt

div_fr1_fr1_pw			; numCalls = 2
	.module	moddiv_fr1_fr1_pw
	std	1+argv
	ldd	#0
	stab	0+argv
	std	3+argv
	ldx	#r1
	jmp	divflt

forone_ix			; numCalls = 1
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 1
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

ld_fd_fx			; numCalls = 1
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

ld_fr1_fx			; numCalls = 5
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 4
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

mul_fr1_fr1_fx			; numCalls = 6
	.module	modmul_fr1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	mulfltx

next			; numCalls = 1
	.module	modnext
	pulx
	stx	tmp1
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
	jmp	,x
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	jmp	,x
_done
	ldab	0,x
	abx
	txs
	ldx	tmp1
	jmp	,x
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
	jmp	,x
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
	jmp	,x

pr_sr1			; numCalls = 6
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 6
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

return			; numCalls = 1
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

rsub_fr1_fr1_pw			; numCalls = 5
	.module	modrsub_fr1_fr1_pw
	std	tmp1
	ldd	#0
	subd	r1+3
	std	r1+3
	ldd	tmp1
	sbcb	r1+2
	sbca	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

sin_fr1_fr1			; numCalls = 1
	.module	modsin_fr1_fr1
	ldx	#r1
	jmp	sin

sq_fr1_fx			; numCalls = 1
	.module	modsq_fr1_fx
	jsr	x2arg
	jsr	mulfltt
	ldx	#r1
	jmp	tmp2xf

str_sr1_fr1			; numCalls = 4
	.module	modstr_sr1_fr1
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

str_sr1_fx			; numCalls = 2
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

sub_fr1_pb_fx			; numCalls = 2
	.module	modsub_fr1_pb_fx
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

tan_fr1_fr1			; numCalls = 1
	.module	modtan_fr1_fr1
	ldx	#r1
	jmp	tan

to_ip_pb			; numCalls = 1
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
enddata


; fixed-point constants
FLT_0p78540	.byte	$00, $00, $00, $c9, $10

; block started by symbol
bss

; Numeric Variables
INTVAR_I	.block	3
FLTVAR_TH	.block	5
FLTVAR_TS	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

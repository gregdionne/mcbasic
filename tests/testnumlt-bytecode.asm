; Assembly for testnumlt-bytecode.bas
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

LINE_1

	; X=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_X

	; NX=-X

	.byte	bytecode_neg_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_NX

LINE_2

	; Y=1000

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_Y
	.word	1000

	; NY=-Y

	.byte	bytecode_neg_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_NY

LINE_3

	; Z=1.1

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_Z
	.byte	bytecode_FLT_1p10000

LINE_10

	; IF X<1 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_20

	; PRINT "FAIL10\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL10\r"

LINE_20

	; IF NX<-1 THEN

	.byte	bytecode_ldlt_ir1_ix_nb
	.byte	bytecode_INTVAR_NX
	.byte	-1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_30

	; PRINT "FAIL20\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL20\r"

LINE_30

	; IF Y<1000 THEN

	.byte	bytecode_ldlt_ir1_ix_pw
	.byte	bytecode_INTVAR_Y
	.word	1000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_40

	; PRINT "FAIL30\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL30\r"

LINE_40

	; IF NY<-1000 THEN

	.byte	bytecode_ldlt_ir1_ix_nw
	.byte	bytecode_INTVAR_NY
	.word	-1000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_50

	; PRINT "FAIL40\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL40\r"

LINE_50

	; IF Y<-1000 THEN

	.byte	bytecode_ldlt_ir1_ix_nw
	.byte	bytecode_INTVAR_Y
	.word	-1000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_60

	; PRINT "FAIL50\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL50\r"

LINE_60

	; IF X>1 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	1
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_70

	; PRINT "FAIL60\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL60\r"

LINE_70

	; IF NX>-1 THEN

	.byte	bytecode_ldlt_ir1_nb_ix
	.byte	-1
	.byte	bytecode_INTVAR_NX

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_80

	; PRINT "FAIL70\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL70\r"

LINE_80

	; IF Y>1000 THEN

	.byte	bytecode_ldlt_ir1_pw_ix
	.word	1000
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_90

	; PRINT "FAIL80\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL80\r"

LINE_90

	; IF NY>-1000 THEN

	.byte	bytecode_ldlt_ir1_nw_ix
	.word	-1000
	.byte	bytecode_INTVAR_NY

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_100

	; PRINT "FAIL90\r";

	.byte	bytecode_pr_ss
	.text	7, "FAIL90\r"

LINE_100

	; IF Z<1.1 THEN

	.byte	bytecode_ldlt_ir1_fx_fd
	.byte	bytecode_FLTVAR_Z
	.byte	bytecode_FLT_1p10000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_110

	; PRINT "FAIL100\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL100\r"

LINE_110

	; IF Z>1.1 THEN

	.byte	bytecode_ldlt_ir1_fx_fd
	.byte	bytecode_FLT_1p10000
	.byte	bytecode_FLTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_120

	; PRINT "FAIL110\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL110\r"

LINE_120

	; IF (X+1)<2 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_130

	; PRINT "FAIL120\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL120\r"

LINE_130

	; IF (NX+1)<0 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_NX

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_140

	; PRINT "FAIL130\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL130\r"

LINE_140

	; IF (Y+1)<1001 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ldlt_ir1_ir1_pw
	.word	1001

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_150

	; PRINT "FAIL140\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL140\r"

LINE_150

	; IF (NY+1)<-999 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_NY

	.byte	bytecode_ldlt_ir1_ir1_nw
	.word	-999

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_160

	; PRINT "FAIL150\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL150\r"

LINE_160

	; IF (Y+1)<-999 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ldlt_ir1_ir1_nw
	.word	-999

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_170

	; PRINT "FAIL160\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL160\r"

LINE_170

	; IF (X+1)>2 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_180

	; PRINT "FAIL170\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL170\r"

LINE_180

	; IF (NX+1)>0 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_NX

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_190

	; PRINT "FAIL180\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL180\r"

LINE_190

	; IF (Y+1)>1001 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ldlt_ir1_pw_ir1
	.word	1001

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_200

	; PRINT "FAIL190\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL190\r"

LINE_200

	; IF (NY+1)>-999 THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_NY

	.byte	bytecode_ldlt_ir1_nw_ir1
	.word	-999

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_210

	; PRINT "FAIL200\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL200\r"

LINE_210

	; IF (Z+1)<2.1 THEN

	.byte	bytecode_inc_fr1_fx
	.byte	bytecode_FLTVAR_Z

	.byte	bytecode_ldlt_ir1_fr1_fx
	.byte	bytecode_FLT_2p10000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_220

	; PRINT "FAIL210\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL210\r"

LINE_220

	; IF (Z+1)>2.1 THEN

	.byte	bytecode_inc_fr1_fx
	.byte	bytecode_FLTVAR_Z

	.byte	bytecode_ldlt_ir1_fx_fr1
	.byte	bytecode_FLT_2p10000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_230

	; PRINT "FAIL220\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL220\r"

LINE_230

	; IF Z<1 THEN

	.byte	bytecode_ldlt_ir1_fx_pb
	.byte	bytecode_FLTVAR_Z
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_240

	; PRINT "FAIL230\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL230\r"

LINE_240

	; IF Z<-1000 THEN

	.byte	bytecode_ldlt_ir1_fx_nw
	.byte	bytecode_FLTVAR_Z
	.word	-1000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_250

	; PRINT "FAIL240\r";

	.byte	bytecode_pr_ss
	.text	8, "FAIL240\r"

LINE_250

	; PRINT "DONE\r";

	.byte	bytecode_pr_ss
	.text	5, "DONE\r"

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_clear	.equ	0
bytecode_inc_fr1_fx	.equ	1
bytecode_inc_ir1_ix	.equ	2
bytecode_jmpeq_ir1_ix	.equ	3
bytecode_ld_fd_fx	.equ	4
bytecode_ld_ix_ir1	.equ	5
bytecode_ld_ix_pw	.equ	6
bytecode_ldlt_ir1_fr1_fx	.equ	7
bytecode_ldlt_ir1_fx_fd	.equ	8
bytecode_ldlt_ir1_fx_fr1	.equ	9
bytecode_ldlt_ir1_fx_nw	.equ	10
bytecode_ldlt_ir1_fx_pb	.equ	11
bytecode_ldlt_ir1_ir1_nw	.equ	12
bytecode_ldlt_ir1_ir1_pb	.equ	13
bytecode_ldlt_ir1_ir1_pw	.equ	14
bytecode_ldlt_ir1_ix_nb	.equ	15
bytecode_ldlt_ir1_ix_nw	.equ	16
bytecode_ldlt_ir1_ix_pb	.equ	17
bytecode_ldlt_ir1_ix_pw	.equ	18
bytecode_ldlt_ir1_nb_ix	.equ	19
bytecode_ldlt_ir1_nw_ir1	.equ	20
bytecode_ldlt_ir1_nw_ix	.equ	21
bytecode_ldlt_ir1_pb_ir1	.equ	22
bytecode_ldlt_ir1_pb_ix	.equ	23
bytecode_ldlt_ir1_pw_ir1	.equ	24
bytecode_ldlt_ir1_pw_ix	.equ	25
bytecode_neg_ir1_ix	.equ	26
bytecode_one_ix	.equ	27
bytecode_pr_ss	.equ	28
bytecode_progbegin	.equ	29
bytecode_progend	.equ	30

catalog
	.word	clear
	.word	inc_fr1_fx
	.word	inc_ir1_ix
	.word	jmpeq_ir1_ix
	.word	ld_fd_fx
	.word	ld_ix_ir1
	.word	ld_ix_pw
	.word	ldlt_ir1_fr1_fx
	.word	ldlt_ir1_fx_fd
	.word	ldlt_ir1_fx_fr1
	.word	ldlt_ir1_fx_nw
	.word	ldlt_ir1_fx_pb
	.word	ldlt_ir1_ir1_nw
	.word	ldlt_ir1_ir1_pb
	.word	ldlt_ir1_ir1_pw
	.word	ldlt_ir1_ix_nb
	.word	ldlt_ir1_ix_nw
	.word	ldlt_ir1_ix_pb
	.word	ldlt_ir1_ix_pw
	.word	ldlt_ir1_nb_ix
	.word	ldlt_ir1_nw_ir1
	.word	ldlt_ir1_nw_ix
	.word	ldlt_ir1_pb_ir1
	.word	ldlt_ir1_pb_ix
	.word	ldlt_ir1_pw_ir1
	.word	ldlt_ir1_pw_ix
	.word	neg_ir1_ix
	.word	one_ix
	.word	pr_ss
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

	.module	mdgetlt
getlt
	blt	_1
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

inc_fr1_fx			; numCalls = 2
	.module	modinc_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir1_ix			; numCalls = 9
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 24
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
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

ld_ix_ir1			; numCalls = 2
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ldlt_ir1_fr1_fx			; numCalls = 1
	.module	modldlt_ir1_fr1_fx
	jsr	extend
	ldd	r1+3
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

ldlt_ir1_fx_fd			; numCalls = 2
	.module	modldlt_ir1_fx_fd
	jsr	extdex
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

ldlt_ir1_fx_fr1			; numCalls = 1
	.module	modldlt_ir1_fx_fr1
	jsr	extend
	ldd	3,x
	subd	r1+3
	ldd	1,x
	sbcb	r1+2
	sbca	r1+1
	ldab	0,x
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_nw			; numCalls = 1
	.module	modldlt_ir1_fx_nw
	jsr	extword
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_pb			; numCalls = 1
	.module	modldlt_ir1_fx_pb
	jsr	extbyte
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_nw			; numCalls = 2
	.module	modldlt_ir1_ir1_nw
	jsr	getword
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#-1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 2
	.module	modldlt_ir1_ir1_pb
	jsr	getbyte
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pw			; numCalls = 1
	.module	modldlt_ir1_ir1_pw
	jsr	getword
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_nb			; numCalls = 1
	.module	modldlt_ir1_ix_nb
	jsr	extbyte
	ldaa	#-1
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_nw			; numCalls = 2
	.module	modldlt_ir1_ix_nw
	jsr	extword
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_pb			; numCalls = 1
	.module	modldlt_ir1_ix_pb
	jsr	extbyte
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_pw			; numCalls = 1
	.module	modldlt_ir1_ix_pw
	jsr	extword
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_nb_ix			; numCalls = 1
	.module	modldlt_ir1_nb_ix
	jsr	byteext
	subb	1,x
	ldd	#-1
	sbcb	1,x
	sbca	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_nw_ir1			; numCalls = 1
	.module	modldlt_ir1_nw_ir1
	jsr	getword
	subd	r1+1
	ldab	#-1
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_nw_ix			; numCalls = 1
	.module	modldlt_ir1_nw_ix
	jsr	wordext
	subd	1,x
	ldab	#-1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ir1			; numCalls = 2
	.module	modldlt_ir1_pb_ir1
	jsr	getbyte
	clra
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ix			; numCalls = 1
	.module	modldlt_ir1_pb_ix
	jsr	byteext
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pw_ir1			; numCalls = 1
	.module	modldlt_ir1_pw_ir1
	jsr	getword
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pw_ix			; numCalls = 1
	.module	modldlt_ir1_pw_ix
	jsr	wordext
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

neg_ir1_ix			; numCalls = 2
	.module	modneg_ir1_ix
	jsr	extend
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

one_ix			; numCalls = 1
	.module	modone_ix
	jsr	extend
	ldd	#1
	staa	0,x
	std	1,x
	rts

pr_ss			; numCalls = 25
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

; data table
startdata
enddata

; Bytecode symbol lookup table

bytecode_FLT_1p10000	.equ	0
bytecode_FLT_2p10000	.equ	1

bytecode_INTVAR_NX	.equ	2
bytecode_INTVAR_NY	.equ	3
bytecode_INTVAR_X	.equ	4
bytecode_INTVAR_Y	.equ	5
bytecode_FLTVAR_Z	.equ	6

symtbl
	.word	FLT_1p10000
	.word	FLT_2p10000

	.word	INTVAR_NX
	.word	INTVAR_NY
	.word	INTVAR_X
	.word	INTVAR_Y
	.word	FLTVAR_Z


; fixed-point constants
FLT_1p10000	.byte	$00, $00, $01, $19, $9a
FLT_2p10000	.byte	$00, $00, $02, $19, $9a

; block started by symbol
bss

; Numeric Variables
INTVAR_NX	.block	3
INTVAR_NY	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
FLTVAR_Z	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

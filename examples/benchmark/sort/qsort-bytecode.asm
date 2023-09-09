; Assembly for qsort-bytecode.bas
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

LINE_10

	; DIM ST(50)

	.byte	bytecode_ld_ir1_pb
	.byte	50

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_ST

LINE_20

	; SP=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_SP

	; L=16384

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_L
	.word	16384

	; H=16895

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_H
	.word	16895

	; GOSUB 100

	.byte	bytecode_gosub_ix
	.word	LINE_100

LINE_30

	; END

	.byte	bytecode_progend

LINE_100

	; A=PEEK(L)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_110

	; B=PEEK(H)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

LINE_120

	; IF A>B THEN

	.byte	bytecode_ldlt_ir1_ix_id
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_130

	; POKE H,A

	.byte	bytecode_poke_id_ix
	.byte	bytecode_INTVAR_H
	.byte	bytecode_INTVAR_A

	; POKE L,B

	.byte	bytecode_poke_id_ix
	.byte	bytecode_INTVAR_L
	.byte	bytecode_INTVAR_B

LINE_130

	; Z=INT(SHIFT(H-L,-1))

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_H
	.byte	bytecode_INTVAR_L

	.byte	bytecode_hlf_fr1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

LINE_140

	; IF Z<1 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_150

	; RETURN

	.byte	bytecode_return

LINE_150

	; Z+=L

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_Z

LINE_160

	; A=PEEK(Z)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_170

	; IF PEEK(L)>A THEN

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ldlt_ir1_ix_ir1
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_180

	; A=PEEK(L)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_180

	; IF PEEK(H)<A THEN

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_190

	; A=PEEK(H)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_190

	; LP=L

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_LP
	.byte	bytecode_INTVAR_L

	; HP=H

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_HP
	.byte	bytecode_INTVAR_H

LINE_200

	; WHEN PEEK(LP)>=A GOTO 220

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_LP

	.byte	bytecode_ldge_ir1_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_220

LINE_210

	; LP+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_LP

	; GOTO 200

	.byte	bytecode_goto_ix
	.word	LINE_200

LINE_220

	; WHEN LP=HP GOTO 270

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_LP
	.byte	bytecode_INTVAR_HP

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_270

LINE_230

	; WHEN PEEK(HP)<A GOTO 250

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_HP

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_250

LINE_240

	; HP-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_HP

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_250

	; WHEN LP=HP GOTO 270

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_LP
	.byte	bytecode_INTVAR_HP

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_270

LINE_260

	; T=PEEK(LP)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_LP

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; POKE LP,PEEK(HP)

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_HP

	.byte	bytecode_poke_ix_ir1
	.byte	bytecode_INTVAR_LP

	; POKE HP,T

	.byte	bytecode_poke_id_ix
	.byte	bytecode_INTVAR_HP
	.byte	bytecode_INTVAR_T

	; GOTO 200

	.byte	bytecode_goto_ix
	.word	LINE_200

LINE_270

	; WHEN (PEEK(L)<>A) OR (L=H) GOTO 290

	.byte	bytecode_peek_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ldne_ir1_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_ldeq_ir2_ix_id
	.byte	bytecode_INTVAR_L
	.byte	bytecode_INTVAR_H

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_290

LINE_280

	; L+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_L

	; GOTO 270

	.byte	bytecode_goto_ix
	.word	LINE_270

LINE_290

	; IF LP<L THEN

	.byte	bytecode_ldlt_ir1_ix_id
	.byte	bytecode_INTVAR_LP
	.byte	bytecode_INTVAR_L

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_300

	; LP=L

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_LP
	.byte	bytecode_INTVAR_L

LINE_300

	; ST(SP)=LP

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_ST
	.byte	bytecode_INTVAR_SP

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LP

	.byte	bytecode_ld_ip_ir1

	; ST(SP+1)=H

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_SP

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_ST

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ld_ip_ir1

	; SP+=2

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_SP
	.byte	2

LINE_310

	; H=LP

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_H
	.byte	bytecode_INTVAR_LP

	; GOSUB 100

	.byte	bytecode_gosub_ix
	.word	LINE_100

LINE_320

	; SP-=2

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_SP
	.byte	2

	; L=ST(SP)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_ST
	.byte	bytecode_INTVAR_SP

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_L

	; H=ST(SP+1)

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_SP

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_ST

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

LINE_330

	; GOTO 100

	.byte	bytecode_goto_ix
	.word	LINE_100

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_ix_ix_ir1	.equ	0
bytecode_add_ix_ix_pb	.equ	1
bytecode_arrdim1_ir1_ix	.equ	2
bytecode_arrref1_ir1_ix_id	.equ	3
bytecode_arrref1_ir1_ix_ir1	.equ	4
bytecode_arrval1_ir1_ix_id	.equ	5
bytecode_arrval1_ir1_ix_ir1	.equ	6
bytecode_clear	.equ	7
bytecode_clr_ix	.equ	8
bytecode_dec_ix_ix	.equ	9
bytecode_gosub_ix	.equ	10
bytecode_goto_ix	.equ	11
bytecode_hlf_fr1_ir1	.equ	12
bytecode_inc_ir1_ix	.equ	13
bytecode_inc_ix_ix	.equ	14
bytecode_jmpeq_ir1_ix	.equ	15
bytecode_jmpne_ir1_ix	.equ	16
bytecode_ld_id_ix	.equ	17
bytecode_ld_ip_ir1	.equ	18
bytecode_ld_ir1_ix	.equ	19
bytecode_ld_ir1_pb	.equ	20
bytecode_ld_ix_ir1	.equ	21
bytecode_ld_ix_pw	.equ	22
bytecode_ldeq_ir1_ix_id	.equ	23
bytecode_ldeq_ir2_ix_id	.equ	24
bytecode_ldge_ir1_ir1_ix	.equ	25
bytecode_ldlt_ir1_ir1_ix	.equ	26
bytecode_ldlt_ir1_ix_id	.equ	27
bytecode_ldlt_ir1_ix_ir1	.equ	28
bytecode_ldlt_ir1_ix_pb	.equ	29
bytecode_ldne_ir1_ir1_ix	.equ	30
bytecode_or_ir1_ir1_ir2	.equ	31
bytecode_peek_ir1_ix	.equ	32
bytecode_poke_id_ix	.equ	33
bytecode_poke_ix_ir1	.equ	34
bytecode_progbegin	.equ	35
bytecode_progend	.equ	36
bytecode_return	.equ	37
bytecode_sub_ir1_ix_id	.equ	38
bytecode_sub_ix_ix_pb	.equ	39

catalog
	.word	add_ix_ix_ir1
	.word	add_ix_ix_pb
	.word	arrdim1_ir1_ix
	.word	arrref1_ir1_ix_id
	.word	arrref1_ir1_ix_ir1
	.word	arrval1_ir1_ix_id
	.word	arrval1_ir1_ix_ir1
	.word	clear
	.word	clr_ix
	.word	dec_ix_ix
	.word	gosub_ix
	.word	goto_ix
	.word	hlf_fr1_ir1
	.word	inc_ir1_ix
	.word	inc_ix_ix
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	ld_id_ix
	.word	ld_ip_ir1
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ix_ir1
	.word	ld_ix_pw
	.word	ldeq_ir1_ix_id
	.word	ldeq_ir2_ix_id
	.word	ldge_ir1_ir1_ix
	.word	ldlt_ir1_ir1_ix
	.word	ldlt_ir1_ix_id
	.word	ldlt_ir1_ix_ir1
	.word	ldlt_ir1_ix_pb
	.word	ldne_ir1_ir1_ix
	.word	or_ir1_ir1_ir2
	.word	peek_ir1_ix
	.word	poke_id_ix
	.word	poke_ix_ir1
	.word	progbegin
	.word	progend
	.word	return
	.word	sub_ir1_ix_id
	.word	sub_ix_ix_pb

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

	.module	mdgetne
getne
	bne	_1
	ldd	#0
	rts
_1
	ldd	#-1
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

add_ix_ix_ir1			; numCalls = 1
	.module	modadd_ix_ix_ir1
	jsr	extend
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 1
	.module	modadd_ix_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

arrdim1_ir1_ix			; numCalls = 1
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

arrref1_ir1_ix_id			; numCalls = 1
	.module	modarrref1_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 1
	.module	modarrref1_ir1_ix_ir1
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 1
	.module	modarrval1_ir1_ix_id
	jsr	extdex
	jsr	getlw
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

arrval1_ir1_ix_ir1			; numCalls = 1
	.module	modarrval1_ir1_ix_ir1
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

clr_ix			; numCalls = 1
	.module	modclr_ix
	jsr	extend
	ldd	#0
	stab	0,x
	std	1,x
	rts

dec_ix_ix			; numCalls = 1
	.module	moddec_ix_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

gosub_ix			; numCalls = 2
	.module	modgosub_ix
	pulx
	jsr	getaddr
	ldd	nxtinst
	pshb
	psha
	ldab	#3
	pshb
	stx	nxtinst
	jmp	mainloop

goto_ix			; numCalls = 5
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

hlf_fr1_ir1			; numCalls = 1
	.module	modhlf_fr1_ir1
	jsr	noargs
	asr	r1
	ror	r1+1
	ror	r1+2
	ldd	#0
	rora
	std	r1+3
	rts

inc_ir1_ix			; numCalls = 2
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ix_ix			; numCalls = 2
	.module	modinc_ix_ix
	jsr	extend
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

jmpeq_ir1_ix			; numCalls = 5
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 5
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

ld_id_ix			; numCalls = 4
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

ld_ip_ir1			; numCalls = 2
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 3
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 1
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ix_ir1			; numCalls = 9
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pw			; numCalls = 2
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ldeq_ir1_ix_id			; numCalls = 2
	.module	modldeq_ir1_ix_id
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	bne	_done
	ldab	r1
	cmpb	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir2_ix_id			; numCalls = 1
	.module	modldeq_ir2_ix_id
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldge_ir1_ir1_ix			; numCalls = 1
	.module	modldge_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 2
	.module	modldlt_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_id			; numCalls = 2
	.module	modldlt_ir1_ix_id
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ix_ir1			; numCalls = 1
	.module	modldlt_ir1_ix_ir1
	jsr	extend
	ldd	1,x
	subd	r1+1
	ldab	0,x
	sbcb	r1
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

ldne_ir1_ir1_ix			; numCalls = 1
	.module	modldne_ir1_ir1_ix
	jsr	extend
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

or_ir1_ir1_ir2			; numCalls = 1
	.module	modor_ir1_ir1_ir2
	jsr	noargs
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_ix			; numCalls = 12
	.module	modpeek_ir1_ix
	jsr	extend
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

poke_id_ix			; numCalls = 3
	.module	modpoke_id_ix
	jsr	dexext
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ix_ir1			; numCalls = 1
	.module	modpoke_ix_ir1
	jsr	extend
	ldab	r1+2
	ldx	1,x
	stab	,x
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

progend			; numCalls = 2
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
	pulx
	stx	nxtinst
	jmp	mainloop

sub_ir1_ix_id			; numCalls = 1
	.module	modsub_ir1_ix_id
	jsr	extdex
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ix_ix_pb			; numCalls = 1
	.module	modsub_ix_ix_pb
	jsr	extbyte
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

; data table
startdata
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_A	.equ	0
bytecode_INTVAR_B	.equ	1
bytecode_INTVAR_H	.equ	2
bytecode_INTVAR_HP	.equ	3
bytecode_INTVAR_L	.equ	4
bytecode_INTVAR_LP	.equ	5
bytecode_INTVAR_SP	.equ	6
bytecode_INTVAR_T	.equ	7
bytecode_INTVAR_Z	.equ	8
bytecode_INTARR_ST	.equ	9

symtbl

	.word	INTVAR_A
	.word	INTVAR_B
	.word	INTVAR_H
	.word	INTVAR_HP
	.word	INTVAR_L
	.word	INTVAR_LP
	.word	INTVAR_SP
	.word	INTVAR_T
	.word	INTVAR_Z
	.word	INTARR_ST


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_H	.block	3
INTVAR_HP	.block	3
INTVAR_L	.block	3
INTVAR_LP	.block	3
INTVAR_SP	.block	3
INTVAR_T	.block	3
INTVAR_Z	.block	3
; String Variables
; Numeric Arrays
INTARR_ST	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

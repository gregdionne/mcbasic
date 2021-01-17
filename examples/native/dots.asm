; Assembly for dots.bas
; compiled with mcbasic -native

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
DP_LNUM	.equ	$E2	; current line in BASIC
DP_TABW	.equ	$E4	; current tab width on console
DP_LPOS	.equ	$E6	; current line position on console
DP_LWID	.equ	$E7	; current line width of console
; 
; Memory equates
M_PMSK	.equ	$423C	; pixel mask for SET, RESET and POINT
M_IKEY	.equ	$427F	; key code for INKEY$
M_CRSR	.equ	$4280	; cursor location
M_LBUF	.equ	$42B2	; line input buffer (130 chars)
M_MSTR	.equ	$4334	; buffer for small string moves
M_CODE	.equ	$4346	; start of program space
; 
; ROM equates
R_BKMSG	.equ	$E1C1	; 'BREAK' string location
R_ERROR	.equ	$E238	; generate error and restore direct mode
R_BREAK	.equ	$E266	; generate break and restore direct mode
R_RESET	.equ	$E3EE	; setup stack and disable CONT
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

; direct page registers
	.org	$80
strbuf	.block	2
strend	.block	2
strfree	.block	2
strstop	.block	2
dataptr	.block	2
inptptr	.block	2
redoptr	.block	2
letptr	.block	2
	.org	$a3
r1	.block	5
r2	.block	5
r3	.block	5
rend
rvseed	.block	2
tmp1	.block	2
tmp2	.block	2
tmp3	.block	2
tmp4	.block	2
tmp5	.block	2
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_0

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_16

	; C1=(PEEK(LC+32)<>96)+(PEEK(LC+1)<>96)+(PEEK(LC-32)<>96)+(PEEK(LC-1)<>96)

	ldx	#INTVAR_LC
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#96
	jsr	ldne_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ir2_ix

	ldab	#1
	jsr	add_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#96
	jsr	ldne_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_LC
	jsr	ld_ir2_ix

	ldab	#32
	jsr	sub_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#96
	jsr	ldne_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_LC
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#96
	jsr	ldne_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

	; REM FNBX(LC)

LINE_17

	; C1=LC<>(INT(LC/2)*2)

	ldx	#INTVAR_LC
	jsr	ld_ir1_ix

	ldx	#INTVAR_LC
	jsr	ld_ir2_ix

	ldab	#2
	jsr	div_fr2_ir2_pb

	ldab	#2
	jsr	mul_ir2_ir2_pb

	jsr	ldne_ir1_ir1_ir2

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

	; REM FNVH(LC)

LINE_100

	; CLS 7

	ldab	#7
	jsr	clsn_pb

	; PRINT @236, "d o t s";

	ldab	#236
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "d o t s"

LINE_110

	; PRINT @357, "SKILL LEVEL (0-10)";

	ldd	#357
	jsr	prat_pw

	jsr	pr_ss
	.text	18, "SKILL LEVEL (0-10)"

	; INPUT SK

	jsr	input

	ldx	#FLTVAR_SK
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (SK<0) OR (SK>10) THEN

	ldx	#FLTVAR_SK
	jsr	ld_fr1_fx

	ldab	#0
	jsr	ldlt_ir1_fr1_pb

	ldab	#10
	jsr	ld_ir2_pb

	ldx	#FLTVAR_SK
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_110
	jsr	jmpne_ir1_ix

LINE_120

	; CLS

	jsr	cls

	; SK=(10-SK)/10

	ldab	#10
	jsr	ld_ir1_pb

	ldx	#FLTVAR_SK
	jsr	sub_fr1_ir1_fx

	ldab	#10
	jsr	div_fr1_fr1_pb

	ldx	#FLTVAR_SK
	jsr	ld_fx_fr1

	; TS=200-(200*SK)

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#200
	jsr	ld_ir2_pb

	ldx	#FLTVAR_SK
	jsr	mul_fr2_ir2_fx

	jsr	sub_fr1_ir1_fr2

	ldx	#FLTVAR_TS
	jsr	ld_fx_fr1

	; DT=TS+25

	ldx	#FLTVAR_TS
	jsr	ld_fr1_fx

	ldab	#25
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_DT
	jsr	ld_fx_fr1

	; SC=16384

	ldx	#INTVAR_SC
	ldd	#16384
	jsr	ld_ix_pw

LINE_130

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; FOR I=1 TO 7

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldab	#7
	jsr	to_ip_pb

	; PRINT " O O O O O O O O O O"

	jsr	pr_ss
	.text	21, " O O O O O O O O O O\r"

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_140

	; YS=0

	ldx	#INTVAR_YS
	ldab	#0
	jsr	ld_ix_pb

	; CS=0

	ldx	#INTVAR_CS
	ldab	#0
	jsr	ld_ix_pb

	; PRINT @87, "YOU:"

	ldab	#87
	jsr	prat_pb

	jsr	pr_ss
	.text	5, "YOU:\r"

	; PRINT @278, "COMPUTER:"

	ldd	#278
	jsr	prat_pw

	jsr	pr_ss
	.text	10, "COMPUTER:\r"

LINE_150

	; PRINT @152, STR$(YS);" "

	ldab	#152
	jsr	prat_pb

	ldx	#INTVAR_YS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; PRINT @344, STR$(CS);" "

	ldd	#344
	jsr	prat_pw

	ldx	#INTVAR_CS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_180

	; SL=SC+202

	ldx	#INTVAR_SC
	jsr	ld_ir1_ix

	ldab	#202
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_SL
	jsr	ld_ix_ir1

	; X=10

	ldx	#INTVAR_X
	ldab	#10
	jsr	ld_ix_pb

	; Y=7

	ldx	#INTVAR_Y
	ldab	#7
	jsr	ld_ix_pb

	; CC=PEEK(SL)

	ldx	#INTVAR_SL
	jsr	peek_ir1_ix

	ldx	#INTVAR_CC
	jsr	ld_ix_ir1

LINE_190

	; POKE SL,159

	ldx	#INTVAR_SL
	ldab	#159
	jsr	poke_ix_pb

	; F=0

	ldx	#INTVAR_F
	ldab	#0
	jsr	ld_ix_pb

LINE_200

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

LINE_210

	; X+=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ix_ix_ir1

	; Y+=K

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	add_ix_ix_ir1

	; IF (X<1) OR (X>19) OR (Y<2) OR (Y>14) THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldlt_ir1_ir1_pb

	ldab	#19
	jsr	ld_ir2_pb

	ldx	#INTVAR_X
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#14
	jsr	ld_ir2_pb

	ldx	#INTVAR_Y
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_220
	jsr	jmpeq_ir1_ix

	; X-=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	sub_ix_ix_ir1

	; Y-=K

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	sub_ix_ix_ir1

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_220

	; IF PC=99 THEN

	ldx	#INTVAR_PC
	jsr	ld_ir1_ix

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_250
	jsr	jmpne_ir1_ix

LINE_230

	; POKE SL,CC

	ldx	#INTVAR_CC
	jsr	ld_ir1_ix

	ldx	#INTVAR_SL
	jsr	poke_ix_ir1

	; SL+=PC

	ldx	#INTVAR_PC
	jsr	ld_ir1_ix

	ldx	#INTVAR_SL
	jsr	add_ix_ix_ir1

	; CC=PEEK(SL)

	ldx	#INTVAR_SL
	jsr	peek_ir1_ix

	ldx	#INTVAR_CC
	jsr	ld_ix_ir1

	; POKE SL,159

	ldx	#INTVAR_SL
	ldab	#159
	jsr	poke_ix_pb

LINE_240

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_250

	; L=(PEEK(SL+1)=79)+(PEEK(SL-1)=79)+(PEEK(SL+32)=79)+(PEEK(SL-32)=79)

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#79
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_SL
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#79
	jsr	ldeq_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_SL
	jsr	ld_ir2_ix

	ldab	#32
	jsr	add_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#79
	jsr	ldeq_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_SL
	jsr	ld_ir2_ix

	ldab	#32
	jsr	sub_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#79
	jsr	ldeq_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

LINE_260

	; IF ((CC=96)+L)=-3 THEN

	ldx	#INTVAR_CC
	jsr	ld_ir1_ix

	ldab	#96
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_L
	jsr	add_ir1_ir1_ix

	ldab	#-3
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_280
	jsr	jmpne_ir1_ix

LINE_270

	; I=62

	ldx	#INTVAR_I
	ldab	#62
	jsr	ld_ix_pb

	; GOSUB 760

	ldx	#LINE_760
	jsr	gosub_ix

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_280

	; WH=1

	ldx	#INTVAR_WH
	ldab	#1
	jsr	ld_ix_pb

	; ML=SL

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldx	#INTVAR_ML
	jsr	ld_ix_ir1

	; GOSUB 700

	ldx	#LINE_700
	jsr	gosub_ix

	; LC=SL

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 17

	ldx	#LINE_17
	jsr	gosub_ix

	; IF NOT C1 THEN

	ldx	#INTVAR_C1
	jsr	com_ir1_ix

	ldx	#LINE_330
	jsr	jmpne_ir1_ix

LINE_290

	; LC=SL-1

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF (X>1) AND (C1=-4) THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ir1_ix

	ldx	#INTVAR_C1
	jsr	ld_ir2_ix

	ldab	#-4
	jsr	ldeq_ir2_ir2_nb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_300
	jsr	jmpeq_ir1_ix

	; BX=SL-1

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; F=-1

	ldx	#INTVAR_F
	ldab	#-1
	jsr	ld_ix_nb

LINE_300

	; LC=SL+1

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF (X<19) AND (C1=-4) THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#19
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ir2_ix

	ldab	#-4
	jsr	ldeq_ir2_ir2_nb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_310
	jsr	jmpeq_ir1_ix

	; BX=SL+1

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; GOTO 180

	ldx	#LINE_180
	jsr	goto_ix

LINE_310

	; IF F THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#LINE_180
	jsr	jmpne_ir1_ix

LINE_320

	; GOTO 360

	ldx	#LINE_360
	jsr	goto_ix

LINE_330

	; LC=SL-32

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF (Y>1) AND (C1=-4) THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#INTVAR_C1
	jsr	ld_ir2_ix

	ldab	#-4
	jsr	ldeq_ir2_ir2_nb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_340
	jsr	jmpeq_ir1_ix

	; BX=SL-32

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; F=-1

	ldx	#INTVAR_F
	ldab	#-1
	jsr	ld_ix_nb

LINE_340

	; LC=SL+32

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF (Y<13) AND (C1=-4) THEN

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#13
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ir2_ix

	ldab	#-4
	jsr	ldeq_ir2_ir2_nb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_350
	jsr	jmpeq_ir1_ix

	; BX=SL+32

	ldx	#INTVAR_SL
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; GOTO 180

	ldx	#LINE_180
	jsr	goto_ix

LINE_350

	; IF F THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#LINE_180
	jsr	jmpne_ir1_ix

LINE_360

	; WH=2

	ldx	#INTVAR_WH
	ldab	#2
	jsr	ld_ix_pb

	; F=0

	ldx	#INTVAR_F
	ldab	#0
	jsr	ld_ix_pb

	; CN=0

	ldx	#INTVAR_CN
	ldab	#0
	jsr	ld_ix_pb

	; IF RND(0)<SK THEN

	ldab	#0
	jsr	rnd_fr1_pb

	ldx	#FLTVAR_SK
	jsr	ldlt_ir1_fr1_fx

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_370

	; FOR I=64 TO 384 STEP 64

	ldx	#INTVAR_I
	ldab	#64
	jsr	for_ix_pb

	ldd	#384
	jsr	to_ip_pw

	ldab	#64
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; FOR J=2 TO 12 STEP 2

	ldx	#INTVAR_J
	ldab	#2
	jsr	for_ix_pb

	ldab	#12
	jsr	to_ip_pb

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; K=SC+I+J

	ldx	#INTVAR_SC
	jsr	ld_ir1_ix

	ldx	#INTVAR_I
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_J
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

LINE_380

	; LC=K

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF (PEEK(K)=96) AND (C1=-3) THEN

	ldx	#INTVAR_K
	jsr	peek_ir1_ix

	ldab	#96
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ir2_ix

	ldab	#-3
	jsr	ldeq_ir2_ir2_nb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_400
	jsr	jmpne_ir1_ix

LINE_390

	; NEXT J,I

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; GOTO 440

	ldx	#LINE_440
	jsr	goto_ix

LINE_400

	; I=K

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_I
	jsr	ld_ix_ir1

	; IF PEEK(I-32)=96 THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#96
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_410
	jsr	jmpeq_ir1_ix

	; I-=32

	ldx	#INTVAR_I
	ldab	#32
	jsr	sub_ix_ix_pb

	; GOTO 590

	ldx	#LINE_590
	jsr	goto_ix

LINE_410

	; IF PEEK(I+32)=96 THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#96
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_420
	jsr	jmpeq_ir1_ix

	; I+=32

	ldx	#INTVAR_I
	ldab	#32
	jsr	add_ix_ix_pb

	; GOTO 590

	ldx	#LINE_590
	jsr	goto_ix

LINE_420

	; IF PEEK(I-1)<>96 THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#96
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_430
	jsr	jmpeq_ir1_ix

	; I+=1

	ldx	#INTVAR_I
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 650

	ldx	#LINE_650
	jsr	goto_ix

LINE_430

	; IF PEEK(I+1)<>96 THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#96
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_440
	jsr	jmpeq_ir1_ix

	; I-=1

	ldx	#INTVAR_I
	ldab	#1
	jsr	sub_ix_ix_pb

	; GOTO 650

	ldx	#LINE_650
	jsr	goto_ix

LINE_440

	; I=RND(19)+(RND(13)*32)+33+SC

	ldab	#19
	jsr	irnd_ir1_pb

	ldab	#13
	jsr	irnd_ir2_pb

	ldab	#32
	jsr	mul_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldab	#33
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_SC
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_I
	jsr	ld_ix_ir1

	; CN+=1

	ldx	#INTVAR_CN
	ldab	#1
	jsr	add_ix_ix_pb

	; IF PEEK(I)<>96 THEN

	ldx	#INTVAR_I
	jsr	peek_ir1_ix

	ldab	#96
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_450

	; IF NOT (((PEEK(I+1)=79) AND (PEEK(I-1)=79)) OR ((PEEK(I+32)=79) AND (PEEK(I-32)=79))) THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#79
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldab	#1
	jsr	sub_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#79
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldab	#32
	jsr	add_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#79
	jsr	ldeq_ir2_ir2_pb

	ldx	#INTVAR_I
	jsr	ld_ir3_ix

	ldab	#32
	jsr	sub_ir3_ir3_pb

	jsr	peek_ir3_ir3

	ldab	#79
	jsr	ldeq_ir3_ir3_pb

	jsr	and_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	jsr	com_ir1_ir1

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_460

	; IF (SK>0.6) OR (CN>TS) THEN

	ldx	#FLT_0p60000
	jsr	ld_fr1_fx

	ldx	#FLTVAR_SK
	jsr	ldlt_ir1_fr1_fx

	ldx	#FLTVAR_TS
	jsr	ld_fr2_fx

	ldx	#INTVAR_CN
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_520
	jsr	jmpne_ir1_ix

LINE_470

	; LC=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 17

	ldx	#LINE_17
	jsr	gosub_ix

	; IF C1 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldx	#LINE_500
	jsr	jmpne_ir1_ix

LINE_480

	; LC=I-32

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_481

	; LC=I+32

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_490

	; GOTO 590

	ldx	#LINE_590
	jsr	goto_ix

LINE_500

	; LC=I-1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_501

	; LC=I+1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_510

	; GOTO 650

	ldx	#LINE_650
	jsr	goto_ix

LINE_520

	; LC=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 17

	ldx	#LINE_17
	jsr	gosub_ix

	; IF C1 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldx	#LINE_560
	jsr	jmpne_ir1_ix

LINE_530

	; IF (SK>0.6) OR (CN>DT) THEN

	ldx	#FLT_0p60000
	jsr	ld_fr1_fx

	ldx	#FLTVAR_SK
	jsr	ldlt_ir1_fr1_fx

	ldx	#FLTVAR_DT
	jsr	ld_fr2_fx

	ldx	#INTVAR_CN
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_590
	jsr	jmpne_ir1_ix

LINE_540

	; LC=I+32

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_550
	jsr	jmpeq_ir1_ix

	; LC=I-32

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_550

	; GOTO 590

	ldx	#LINE_590
	jsr	goto_ix

LINE_560

	; IF (SK>0.6) OR (CN>DT) THEN

	ldx	#FLT_0p60000
	jsr	ld_fr1_fx

	ldx	#FLTVAR_SK
	jsr	ldlt_ir1_fr1_fx

	ldx	#FLTVAR_DT
	jsr	ld_fr2_fx

	ldx	#INTVAR_CN
	jsr	ldlt_ir2_fr2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jmpne_ir1_ix

LINE_570

	; LC=I+1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_580
	jsr	jmpeq_ir1_ix

	; LC=I-1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; IF C1=-2 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_580

	; GOTO 650

	ldx	#LINE_650
	jsr	goto_ix

LINE_590

	; ML=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_ML
	jsr	ld_ix_ir1

	; GOSUB 700

	ldx	#LINE_700
	jsr	gosub_ix

LINE_600

	; LC=ML-32

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-4 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-4
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_610
	jsr	jmpeq_ir1_ix

	; BX=ML-32

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; F=-1

	ldx	#INTVAR_F
	ldab	#-1
	jsr	ld_ix_nb

LINE_610

	; LC=ML+32

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-4 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-4
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_620
	jsr	jmpeq_ir1_ix

	; BX=ML+32

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#32
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; GOTO 360

	ldx	#LINE_360
	jsr	goto_ix

LINE_620

	; IF F THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#LINE_360
	jsr	jmpne_ir1_ix

LINE_630

	; GOTO 180

	ldx	#LINE_180
	jsr	goto_ix

LINE_640

	; IF NOT ((PEEK(I-32)=79) AND (PEEK(I+32)=79)) THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#32
	jsr	sub_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#79
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldab	#32
	jsr	add_ir2_ir2_pb

	jsr	peek_ir2_ir2

	ldab	#79
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	jsr	com_ir1_ir1

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_650

	; ML=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_ML
	jsr	ld_ix_ir1

	; GOSUB 700

	ldx	#LINE_700
	jsr	gosub_ix

LINE_660

	; LC=ML-1

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-4 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-4
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_670
	jsr	jmpeq_ir1_ix

	; BX=ML-1

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; F=-1

	ldx	#INTVAR_F
	ldab	#-1
	jsr	ld_ix_nb

LINE_670

	; LC=ML+1

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; IF C1=-4 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldab	#-4
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_680
	jsr	jmpeq_ir1_ix

	; BX=ML+1

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	ld_ix_ir1

	; GOSUB 770

	ldx	#LINE_770
	jsr	gosub_ix

	; GOTO 360

	ldx	#LINE_360
	jsr	goto_ix

LINE_680

	; IF F THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#LINE_360
	jsr	jmpne_ir1_ix

LINE_690

	; GOTO 180

	ldx	#LINE_180
	jsr	goto_ix

LINE_700

	; REM 

LINE_710

	; POKE ML,109

	ldx	#INTVAR_ML
	ldab	#109
	jsr	poke_ix_pb

LINE_720

	; LC=ML

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldx	#INTVAR_LC
	jsr	ld_ix_ir1

	; GOSUB 17

	ldx	#LINE_17
	jsr	gosub_ix

	; IF C1 THEN

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldx	#LINE_730
	jsr	jmpeq_ir1_ix

	; POKE ML,73

	ldx	#INTVAR_ML
	ldab	#73
	jsr	poke_ix_pb

LINE_730

	; I=185

	ldx	#INTVAR_I
	ldab	#185
	jsr	ld_ix_pb

	; IF WH=2 THEN

	ldx	#INTVAR_WH
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_740
	jsr	jmpeq_ir1_ix

	; I=150

	ldx	#INTVAR_I
	ldab	#150
	jsr	ld_ix_pb

LINE_740

	; FOR J=1 TO WH

	ldx	#INTVAR_J
	ldab	#1
	jsr	for_ix_pb

	ldx	#INTVAR_WH
	jsr	to_ip_ix

	; GOSUB 760

	ldx	#LINE_760
	jsr	gosub_ix

LINE_750

	; FOR L=1 TO 200

	ldx	#INTVAR_L
	ldab	#1
	jsr	for_ix_pb

	ldab	#200
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_760

	; SOUND I,2

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

	; REM NOISE 

LINE_770

	; YS+=1

	ldx	#INTVAR_YS
	ldab	#1
	jsr	add_ix_ix_pb

	; J=8

	ldx	#INTVAR_J
	ldab	#8
	jsr	ld_ix_pb

	; I=200

	ldx	#INTVAR_I
	ldab	#200
	jsr	ld_ix_pb

	; IF WH=2 THEN

	ldx	#INTVAR_WH
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_780
	jsr	jmpeq_ir1_ix

	; J=4

	ldx	#INTVAR_J
	ldab	#4
	jsr	ld_ix_pb

	; I=150

	ldx	#INTVAR_I
	ldab	#150
	jsr	ld_ix_pb

	; YS-=1

	ldx	#INTVAR_YS
	ldab	#1
	jsr	sub_ix_ix_pb

	; CS+=1

	ldx	#INTVAR_CS
	ldab	#1
	jsr	add_ix_ix_pb

LINE_780

	; POKE BX,207

	ldx	#INTVAR_BX
	ldab	#207
	jsr	poke_ix_pb

LINE_790

	; FOR L=1 TO 3

	ldx	#INTVAR_L
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; POKE BX,((J-1)*16)+143

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldab	#16
	jsr	mul_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	poke_ix_ir1

	; GOSUB 760

	ldx	#LINE_760
	jsr	gosub_ix

	; POKE BX,((J-1)*16)+143

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldab	#16
	jsr	mul_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	poke_ix_ir1

	; FOR I=1 TO 200

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldab	#200
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; I+=18

	ldx	#INTVAR_I
	ldab	#18
	jsr	add_ix_ix_pb

	; POKE BX,((J-1)*16)+143

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldab	#16
	jsr	mul_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_BX
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

LINE_800

	; PRINT @152, STR$(YS);" "

	ldab	#152
	jsr	prat_pb

	ldx	#INTVAR_YS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; PRINT @344, STR$(CS);" "

	ldd	#344
	jsr	prat_pw

	ldx	#INTVAR_CS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_810

	; IF (YS+CS)<54 THEN

	ldx	#INTVAR_YS
	jsr	ld_ir1_ix

	ldx	#INTVAR_CS
	jsr	add_ir1_ir1_ix

	ldab	#54
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_820
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_820

	; IF YS>CS THEN

	ldx	#INTVAR_CS
	jsr	ld_ir1_ix

	ldx	#INTVAR_YS
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_850
	jsr	jmpne_ir1_ix

LINE_830

	; PRINT @487, "SORRY, YOU LOST.";

	ldd	#487
	jsr	prat_pw

	jsr	pr_ss
	.text	16, "SORRY, YOU LOST."

LINE_840

	; SOUND 128,10

	ldab	#128
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR I=1 TO 1500

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldd	#1500
	jsr	to_ip_pw

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; GOTO 870

	ldx	#LINE_870
	jsr	goto_ix

LINE_850

	; PRINT @490, "YOU WIN!!!!!";

	ldd	#490
	jsr	prat_pw

	jsr	pr_ss
	.text	12, "YOU WIN!!!!!"

LINE_860

	; FOR I=128 TO 255

	ldx	#INTVAR_I
	ldab	#128
	jsr	for_ix_pb

	ldab	#255
	jsr	to_ip_pb

	; SOUND I,1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_870

	; PRINT @487, "PLAY AGAIN (y/n) ?";

	ldd	#487
	jsr	prat_pw

	jsr	pr_ss
	.text	18, "PLAY AGAIN (y/n) ?"

LINE_880

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; IF A$="" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_880
	jsr	jmpne_ir1_ix

LINE_890

	; IF LEFT$(A$,1)="Y" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_100
	jsr	jmpne_ir1_ix

LINE_900

	; END

	jsr	progend

LINE_910

	; J=0

	ldx	#INTVAR_J
	ldab	#0
	jsr	ld_ix_pb

	; K=0

	ldx	#INTVAR_K
	ldab	#0
	jsr	ld_ix_pb

	; PC=0

	ldx	#INTVAR_PC
	ldab	#0
	jsr	ld_ix_pb

LINE_920

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; IF A$="" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_920
	jsr	jmpne_ir1_ix

LINE_930

	; IF A$="W" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "W"

	ldx	#LINE_940
	jsr	jmpeq_ir1_ix

	; PC=-32

	ldx	#INTVAR_PC
	ldab	#-32
	jsr	ld_ix_nb

	; K=-1

	ldx	#INTVAR_K
	ldab	#-1
	jsr	ld_ix_nb

	; RETURN

	jsr	return

LINE_940

	; IF A$="S" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "S"

	ldx	#LINE_950
	jsr	jmpeq_ir1_ix

	; J=1

	ldx	#INTVAR_J
	ldab	#1
	jsr	ld_ix_pb

	; PC=1

	ldx	#INTVAR_PC
	ldab	#1
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_950

	; IF A$="Z" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Z"

	ldx	#LINE_960
	jsr	jmpeq_ir1_ix

	; K=1

	ldx	#INTVAR_K
	ldab	#1
	jsr	ld_ix_pb

	; PC=32

	ldx	#INTVAR_PC
	ldab	#32
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_960

	; IF A$="A" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "A"

	ldx	#LINE_970
	jsr	jmpeq_ir1_ix

	; J=-1

	ldx	#INTVAR_J
	ldab	#-1
	jsr	ld_ix_nb

	; PC=-1

	ldx	#INTVAR_PC
	ldab	#-1
	jsr	ld_ix_nb

	; RETURN

	jsr	return

LINE_970

	; IF ASC(A$)=13 THEN

	ldx	#STRVAR_A
	jsr	asc_ir1_sx

	ldab	#13
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_980
	jsr	jmpeq_ir1_ix

	; PC=99

	ldx	#INTVAR_PC
	ldab	#99
	jsr	ld_ix_pb

LINE_980

	; RETURN

	jsr	return

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

	.module	mddivflt
; divide X by Y
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   X/Y in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
divflt
	clr	tmp4
	tst	0,x
	bpl	_posX
	com	tmp4
	neg	4,x
	ngc	3,x
	ngc	2,x
	ngc	1,x
	ngc	0,x
_posX
	tst	0+argv
	bpl	_posA
	com	tmp4
	neg	4+argv
	ngc	3+argv
	ngc	2+argv
	ngc	1+argv
	ngc	0+argv
divufl
_posA
	ldd	3,x
	std	6,x
	ldd	1,x
	std	4,x
	ldab	0,x
	stab	3,x
	ldd	#0
	std	8,x
	std	1,x
	stab	0,x
	ldaa	#41
	staa	tmp1
_nxtdiv
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
	rol	7,x
	rol	6,x
	rol	5,x
	rol	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	dec	tmp1
	bne	_nxtdiv
	tst	tmp4
	bne	_add1
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

	.module	mdgeteq
geteq
	beq	_1
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

	.module	mdinput
inputqqs
	jsr	R_QUEST
inputqs
	jsr	R_QUEST
	jsr	R_SPACE
	jsr	R_GETLN
	ldaa	#','
	staa	,x
_done
	stx	inptptr
	rts
rdinit
	ldx	inptptr
	ldaa	,x
	inx
	cmpa	','
	beq	_skpspc
	jsr	inputqqs
	bra	rdinit
_skpspc
	ldaa	,x
	cmpa	#' '
	bne	_done
	inx
	bra	_skpspc
rdredo
	ldx	inptptr
	bsr	_skpspc
	tsta
	beq	_rts
	cmpa	#','
	beq	_rts
	ldx	#R_REDO
	ldab	#6
	jsr	print
	ldx	redoptr
_rts
	rts

	.module	mdmulflt
mulfltx
	bsr	mulflt
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts
mulflt
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
	lslb
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
	addb	tmp2
	adca	tmp1+1
	std	tmp1+1
	ldaa	1+argv
	ldab	2,x
	mul
	addb	tmp2
	adca	tmp1+1
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

	.module	mdprat
prat
	bita	#$FE
	bne	_fcerror
	anda	#$01
	oraa	#$40
	std	M_CRSR
	rts
_fcerror
	ldab	#FC_ERROR
	jmp	error

	.module	mdprint
print
_loop
	ldaa	,x
	jsr	R_PUTC
	inx
	decb
	bne	_loop
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

	.module	mdstreqs
; compare string against stack
; ENTRY: top of stack is return to caller (ld<ne/eq>_ir1_sr1_ss)
;        next two bytes address of string length+payload
; EXIT:  we modify those two bytes to point to code beyond payload so caller can just RTS
;        we return correct Z flag for caller
streqs
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
	pshx
	tst	tmp1+1
	bmi	_neg
	ldab	' '
	bra	_wdigs
_neg
	neg	tmp3+1
	ngc	tmp3
	ngc	tmp2+1
	ngc	tmp2
	ngc	tmp1+1
	ldab	'-'
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
	ldaa	tmp1+1
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
_dec
	suba	#5
	bhs	_dec
	adda	#5
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
	pshb
	ldd	tmp2
	psha
	ldaa	#$CC
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
	ldaa	#$CC
	mul
	stab	tmp3+1
	addd	tmp1+1
	std	tmp1+1
	pulb
	ldaa	#$CC
	mul
	addb	tmp1+1
	addb	tmp3+1
	stab	tmp1+1
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
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts
_char
	ldaa	#1
	ldx	1+argv
	ldab	,x
_null
	ldaa	#1
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
	rts

	.module	mdstrrel
; release a temporary string
; ENTRY: X holds string start
; EXIT:  X holds new end of string space
strrel
	cpx	strend
	bls	_rts
	cpx	strstop
	bhs	_rts
	stx	strfree
_rts
	rts

	.module	mdstrval
strval
	ldab	0,x
	ldx	1,x
	jsr	strrel
inptval
	clr	tmp1
	bsr	_getsgn
	jsr	_getint
	tstb
	beq	_dosign
	ldaa	,x
	cmpa	#'.'
	bne	_dosign
	inx
	decb
	beq	_dosign
	stab	tmp5
	ldd	tmp2
	pshb
	psha
	ldd	tmp1
	pshb
	psha
	ldab	tmp5
	bsr	_getint
	stx	tmp5
	ldab	tmp4
	ldx	#_tblten
	abx
	abx
	abx
	ldab	,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	sts	tmp4
	ldd	tmp4
	subd	#10
	std	tmp4
	lds	tmp4
	tsx
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	#0
	std	3,x
	stab	tmp4
	jsr	divufl
	ldd	3,x
	std	tmp3
	ldab	#10
	tsx
	abx
	txs
	pula
	pulb
	std	tmp1
	pula
	pulb
	std	tmp2
	ldx	tmp5
_dosign
	tst	tmp1
	beq	_rts
	neg	tmp3+1
	ngc	tmp3
	ngc	tmp2+1
	ngc	tmp2
	ngc	tmp1+1
_rts
	rts
_getsgn
	tstb
	beq	_srts
	ldaa	,x
	cmpa	#' '
	bne	_trysgn
	inx
	decb
	bra	_getsgn
_trysgn
	cmpa	#'+'
	beq	_prts
	cmpa	#'-'
	bne	_srts
	dec	tmp1
_prts
	inx
	decb
_srts
	rts
_getint
	clra
	staa	tmp1+1
	staa	tmp2
	staa	tmp2+1
	staa	tmp4
_nxtdig
	tstb
	beq	_crts
	ldaa	,x
	suba	#'0'
	blo	_crts
	cmpa	#10
	bhs	_crts
	inx
	decb
	pshb
	psha
	ldd	tmp2
	std	tmp3
	ldab	tmp1+1
	stab	tmp4+1
	bsr	_dbl
	bsr	_dbl
	ldd	tmp3
	addd	tmp2
	std	tmp2
	ldab	tmp4+1
	adcb	tmp1+1
	stab	tmp1+1
	bsr	_dbl
	pulb
	clra
	addd	tmp2
	std	tmp2
	ldab	tmp1+1
	adcb	#0
	stab	tmp1+1
	pulb
	ldaa	tmp4
	inca
	staa	tmp4
	cmpa	#6
	blo	_nxtdig
_crts
	clra
	staa	tmp3
	staa	tmp3+1
	rts
_dbl
	lsl	tmp2+1
	rol	tmp2
	rol	tmp1+1
	rts
_tblten
	.byte	$00,$00,$01
	.byte	$00,$00,$0A
	.byte	$00,$00,$64
	.byte	$00,$03,$E8
	.byte	$00,$27,$10
	.byte	$00,$86,$80
	.byte	$0F,$42,$40

	.module	mdtonat
; push for-loop record on stack
; ENTRY:  ACCB  contains size of record
;         r1    contains stopping variable and is always float.
;         r1+3  must contain zero if an integer.
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

add_fr1_fr1_pb			; numCalls = 1
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_ir2			; numCalls = 7
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 5
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 22
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir2_ir2_pb			; numCalls = 4
	.module	modadd_ir2_ir2_pb
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_ix_ix_ir1			; numCalls = 3
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 6
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 7
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir2_ir2_ir3			; numCalls = 1
	.module	modand_ir2_ir2_ir3
	ldd	r3+1
	andb	r2+2
	anda	r2+1
	std	r2+1
	ldab	r3
	andb	r2
	stab	r2
	rts

asc_ir1_sx			; numCalls = 1
	.module	modasc_ir1_sx
	ldab	0,x
	beq	_fc_error
	ldx	1,x
	ldab	,x
_null
	stab	r1+2
	ldd	#0
	std	r1
	rts
_fc_error
	ldab	#FC_ERROR
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
	stx	dataptr
	rts

cls			; numCalls = 1
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

com_ir1_ir1			; numCalls = 2
	.module	modcom_ir1_ir1
	com	r1+2
	com	r1+1
	com	r1
	rts

com_ir1_ix			; numCalls = 1
	.module	modcom_ir1_ix
	ldd	1,x
	comb
	coma
	std	r1+1
	ldab	0,x
	comb
	stab	r1
	rts

div_fr1_fr1_pb			; numCalls = 1
	.module	moddiv_fr1_fr1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	divflt

div_fr2_ir2_pb			; numCalls = 1
	.module	moddiv_fr2_ir2_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	std	r2+3
	ldx	#r2
	jmp	divflt

for_ix_pb			; numCalls = 9
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 34
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 21
	.module	modgoto_ix
	ins
	ins
	jmp	,x

ignxtra			; numCalls = 1
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inkey_sr1			; numCalls = 2
	.module	modinkey_sr1
	ldd	#$0101
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

input			; numCalls = 1
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

irnd_ir1_pb			; numCalls = 1
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

irnd_ir2_pb			; numCalls = 1
	.module	modirnd_ir2_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r2+1
	ldab	tmp1
	stab	r2
	rts

jmpeq_ir1_ix			; numCalls = 24
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

jmpne_ir1_ix			; numCalls = 28
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

ld_fr1_fx			; numCalls = 5
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 3
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 3
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 83
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 7
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 16
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 7
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 1
	.module	modld_ir3_ix
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ix_ir1			; numCalls = 41
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 8
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 24
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sr1_sx			; numCalls = 7
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 2
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_nb			; numCalls = 13
	.module	modldeq_ir1_ir1_nb
	cmpb	r1+2
	bne	_done
	ldd	r1
	subd	#-1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ir1_pb			; numCalls = 11
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 7
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

ldeq_ir2_ir2_nb			; numCalls = 5
	.module	modldeq_ir2_ir2_nb
	cmpb	r2+2
	bne	_done
	ldd	r2
	subd	#-1
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_pb			; numCalls = 6
	.module	modldeq_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir3_ir3_pb			; numCalls = 1
	.module	modldeq_ir3_ir3_pb
	cmpb	r3+2
	bne	_done
	ldd	r3
_done
	jsr	geteq
	std	r3+1
	stab	r3
	rts

ldlt_ir1_fr1_fx			; numCalls = 4
	.module	modldlt_ir1_fr1_fx
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

ldlt_ir1_fr1_pb			; numCalls = 1
	.module	modldlt_ir1_fr1_pb
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

ldlt_ir1_ir1_ix			; numCalls = 3
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 4
	.module	modldlt_ir1_ir1_pb
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

ldlt_ir2_fr2_ix			; numCalls = 3
	.module	modldlt_ir2_fr2_ix
	ldd	r2+1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_fx			; numCalls = 1
	.module	modldlt_ir2_ir2_fx
	ldd	#0
	subd	3,x
	ldd	r2+1
	sbcb	2,x
	sbca	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_ix			; numCalls = 2
	.module	modldlt_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_pb			; numCalls = 1
	.module	modldlt_ir2_ir2_pb
	clra
	std	tmp1
	ldd	r2+1
	subd	tmp1
	ldab	r2
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_ir2			; numCalls = 1
	.module	modldne_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	bne	_done
	ldab	r1
	cmpb	r2
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_ir1_pb			; numCalls = 4
	.module	modldne_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir2_ir2_pb			; numCalls = 3
	.module	modldne_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	getne
	std	r2+1
	stab	r2
	rts

left_sr1_sr1_pb			; numCalls = 1
	.module	modleft_sr1_sr1_pb
	tstb
	beq	_zero
	cmpb	r1
	bhs	_rts
	stab	r1
	rts
_zero
	pshx
	ldx	r1+1
	jsr	strrel
	pulx
	ldd	#$0100
	std	r1+1
	stab	r1
_rts
	rts
_fc_error
	ldab	#FC_ERROR
	jmp	error

mul_fr2_ir2_fx			; numCalls = 1
	.module	modmul_fr2_ir2_fx
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

mul_ir1_ir1_pb			; numCalls = 3
	.module	modmul_ir1_ir1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	ldx	#r1
	jmp	mulintx

mul_ir2_ir2_pb			; numCalls = 2
	.module	modmul_ir2_ir2_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	ldx	#r2
	jmp	mulintx

next			; numCalls = 9
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
	ldd	9,x
	std	r1+1
	ldab	8,x
	stab	r1
	ldx	1,x
	ldd	r1+1
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
	blt	_idone
	ldx	3,x
	jmp	,x
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_idone
	ldx	3,x
	jmp	,x
_idone
	ldab	#11
	bra	_done
_flt
	ldd	13,x
	std	r1+3
	ldd	11,x
	std	r1+1
	ldab	10,x
	stab	r1
	ldx	1,x
	ldd	r1+3
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
	blt	_fdone
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
	blt	_fdone
	ldx	3,x
	jmp	,x
_fdone
	ldab	#15
_done
	abx
	txs
	ldx	tmp1
	jmp	,x

nextvar_ix			; numCalls = 4
	.module	modnextvar_ix
	stx	letptr
	pulx
	stx	tmp1
	tsx
	clrb
_nxtvar
	abx
	ldd	1,x
	subd	letptr
	beq	_ok
	ldab	,x
	cmpb	#3
	bhi	_nxtvar
_ok
	txs
	ldx	tmp1
	jmp	,x

or_ir1_ir1_ir2			; numCalls = 8
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_ir1			; numCalls = 8
	.module	modpeek_ir1_ir1
	ldx	r1+1
	cpx	#M_IKEY
	bne	_nostore
	jsr	R_KPOLL
	beq	_nostore
	staa	M_IKEY
_nostore
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ix			; numCalls = 4
	.module	modpeek_ir1_ix
	ldx	1,x
	cpx	#M_IKEY
	bne	_nostore
	jsr	R_KPOLL
	beq	_nostore
	staa	M_IKEY
_nostore
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_ir2			; numCalls = 9
	.module	modpeek_ir2_ir2
	ldx	r2+1
	cpx	#M_IKEY
	bne	_nostore
	jsr	R_KPOLL
	beq	_nostore
	staa	M_IKEY
_nostore
	ldab	,x
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir3_ir3			; numCalls = 1
	.module	modpeek_ir3_ir3
	ldx	r3+1
	cpx	#M_IKEY
	bne	_nostore
	jsr	R_KPOLL
	beq	_nostore
	staa	M_IKEY
_nostore
	ldab	,x
	stab	r3+2
	ldd	#0
	std	r3
	rts

poke_ix_ir1			; numCalls = 4
	.module	modpoke_ix_ir1
	ldab	r1+2
	ldx	1,x
	stab	,x
	rts

poke_ix_pb			; numCalls = 5
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

pr_sr1			; numCalls = 4
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 14
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_pb			; numCalls = 4
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 7
	.module	modprat_pw
	jmp	prat

progbegin			; numCalls = 1
	.module	modprogbegin
	ldx	R_MCXID
	cpx	#'h'*256+'C'
	bne	_mcbasic
	pulx
	clrb
	pshb
	pshb
	pshb
	jmp	,x
_reqmsg	.text	"?MICROCOLOR BASIC ROM REQUIRED"
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
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
error
	jmp	R_ERROR

readbuf_fx			; numCalls = 1
	.module	modreadbuf_fx
	stx	letptr
	jsr	rdinit
	ldab	#128
	jsr	inptval
	stx	inptptr
	ldaa	,x
	ldx	letptr
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	jsr	rdredo
	beq	_rts
	pulx
	jmp	,x
_rts
	rts

return			; numCalls = 9
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

rnd_fr1_pb			; numCalls = 1
	.module	modrnd_fr1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	rnd
	std	r1+3
	ldd	#0
	std	r1+1
	stab	r1
	rts

sound_ir1_ir2			; numCalls = 3
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 2
	.module	modstep_ip_ir1
	tsx
	ldab	r1
	stab	10,x
	ldd	r1+1
	std	11,x
	ldd	,x
	std	5,x
	rts

str_sr1_ix			; numCalls = 4
	.module	modstr_sr1_ix
	ldd	1,x
	std	tmp2
	ldab	0,x
	stab	tmp1+1
	ldd	#0
	std	tmp3
	jsr	strflt
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

sub_fr1_ir1_fr2			; numCalls = 1
	.module	modsub_fr1_ir1_fr2
	ldd	#0
	subd	r2+3
	std	r1+3
	ldd	r1+1
	sbcb	r2+2
	sbca	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

sub_fr1_ir1_fx			; numCalls = 1
	.module	modsub_fr1_ir1_fx
	ldd	#0
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

sub_ir1_ir1_pb			; numCalls = 18
	.module	modsub_ir1_ir1_pb
	stab	tmp1
	ldd	r1+1
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

sub_ir2_ir2_pb			; numCalls = 5
	.module	modsub_ir2_ir2_pb
	stab	tmp1
	ldd	r2+1
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	r2
	sbcb	#0
	stab	r2
	rts

sub_ir3_ir3_pb			; numCalls = 1
	.module	modsub_ir3_ir3_pb
	stab	tmp1
	ldd	r3+1
	subb	tmp1
	sbca	#0
	std	r3+1
	ldab	r3
	sbcb	#0
	stab	r3
	rts

sub_ix_ix_ir1			; numCalls = 2
	.module	modsub_ix_ix_ir1
	ldd	1,x
	subd	r1+1
	std	1,x
	ldab	0,x
	sbcb	r1
	stab	0,x
	rts

sub_ix_ix_pb			; numCalls = 3
	.module	modsub_ix_ix_pb
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

to_ip_ix			; numCalls = 1
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 6
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 2
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
enddata

symstart

; fixed-point constants
FLT_0p60000	.byte	$00, $00, $00, $99, $9a

; block started by symbol
bss

; Numeric Variables
INTVAR_BX	.block	3
INTVAR_C1	.block	3
INTVAR_CC	.block	3
INTVAR_CN	.block	3
INTVAR_CS	.block	3
INTVAR_F	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_LC	.block	3
INTVAR_ML	.block	3
INTVAR_PC	.block	3
INTVAR_SC	.block	3
INTVAR_SL	.block	3
INTVAR_WH	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_YS	.block	3
FLTVAR_DT	.block	5
FLTVAR_SK	.block	5
FLTVAR_TS	.block	5
; String Variables
STRVAR_A	.block	3
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

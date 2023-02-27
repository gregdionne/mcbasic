; Assembly for bingo.bas
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
; 
; Memory equates
M_KBUF	.equ	$4231	; keystrobe buffer (8 bytes)
M_PMSK	.equ	$423C	; pixel mask for SET, RESET and POINT
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
R_SOUND	.equ	$FFAB	; play sound with pitch in ACCA and duration in ACCB
R_MCXID	.equ	$FFDA	; ID location for MCX BASIC

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

LINE_0

	; CLS

	jsr	cls

	; CLEAR 500

	jsr	clear

	; DIM C1,C2,C3,Z,M$,I$,B(10,10),L(75),A$(5),X,Y,F,U

	ldab	#10
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	ldx	#INTARR_B
	jsr	arrdim2_ir1_ix

	ldab	#75
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrdim1_ir1_ix

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_A
	jsr	arrdim1_ir1_sx

	; Z=16384

	ldx	#INTVAR_Z
	ldd	#16384
	jsr	ld_ix_pw

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_1

	; C2=1

	ldx	#INTVAR_C2
	jsr	one_ix

	; C1=32

	ldx	#INTVAR_C1
	ldab	#32
	jsr	ld_ix_pb

	; FOR C1=C1 TO C2 STEP -1

	ldd	#INTVAR_C1
	ldx	#INTVAR_C1
	jsr	for_id_ix

	ldx	#INTVAR_C2
	jsr	to_ip_ix

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; I$=MID$(M$,C1,1)

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_C1
	jsr	ld_ir2_ix

	ldab	#1
	jsr	midT_sr1_sr1_pb

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; IF I$<"!" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldlt_ir1_sr1_ss
	.text	1, "!"

	ldx	#LINE_2
	jsr	jmpeq_ir1_ix

	; PRINT MID$(M$,C2,C1-C2);"\r";

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_C2
	jsr	ld_ir2_ix

	ldx	#INTVAR_C1
	ldd	#INTVAR_C2
	jsr	sub_ir3_ix_id

	jsr	midT_sr1_sr1_ir3

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

	; C2=C1+1

	ldx	#INTVAR_C1
	jsr	inc_ir1_ix

	ldx	#INTVAR_C2
	jsr	ld_ix_ir1

	; C1=C2+32

	ldx	#INTVAR_C2
	ldab	#32
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; IF I$="" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_2
	jsr	jmpeq_ir1_ix

	; C1=0

	ldx	#INTVAR_C1
	jsr	clr_ix

LINE_2

	; C1+=(C1>255) AND (255-C1)

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTVAR_C1
	jsr	ldlt_ir1_ir1_ix

	ldab	#255
	ldx	#INTVAR_C1
	jsr	sub_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_C1
	jsr	add_ix_ix_ir1

	; NEXT

	jsr	next

	; M$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_7

	; C1=POS+Z-1

	jsr	pos_ir1

	ldx	#INTVAR_Z
	jsr	add_ir1_ir1_ix

	jsr	dec_ir1_ir1

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; FOR C2=1 TO LEN(M$)

	ldx	#INTVAR_C2
	jsr	forone_ix

	ldx	#STRVAR_M
	jsr	len_ir1_sx

	jsr	to_ip_ir1

	; C3=ASC(MID$(M$,C2))

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_C2
	jsr	mid_sr1_sr1_ix

	jsr	asc_ir1_sr1

	ldx	#INTVAR_C3
	jsr	ld_ix_ir1

	; POKE C1+C2,C3-(C3 AND 64)

	ldx	#INTVAR_C1
	ldd	#INTVAR_C2
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C3
	jsr	ld_ir2_ix

	ldab	#64
	jsr	and_ir2_ir2_pb

	ldx	#INTVAR_C3
	jsr	rsub_ir2_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT

	jsr	next

	; PRINT @C1+C2-Z,

	ldx	#INTVAR_C1
	ldd	#INTVAR_C2
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Z
	jsr	sub_ir1_ir1_ix

	jsr	prat_ir1

	; RETURN

	jsr	return

LINE_200

	; REM *MAIN PROGRAM*

LINE_210

	; EVAL RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	; REM RANDOMIZE

LINE_220

	; REM TITLE PAGE

LINE_230

	; PRINT @9,

	ldab	#9
	jsr	prat_pb

	; M$="LARRY BETHURUM"

	jsr	ld_sr1_ss
	.text	14, "LARRY BETHURUM"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

LINE_231

	; PRINT @32, "PHILLIPS EXETER ACADEMY. 1/23/66\r";

	ldab	#32
	jsr	prat_pb

	jsr	pr_ss
	.text	33, "PHILLIPS EXETER ACADEMY. 1/23/66\r"

LINE_233

	; PRINT "YOU ARE NOW GOING TO PLAY A\r";

	jsr	pr_ss
	.text	28, "YOU ARE NOW GOING TO PLAY A\r"

	; M$="COMPUTERIZED VERSION OF BINGO-- "

	jsr	ld_sr1_ss
	.text	32, "COMPUTERIZED VERSION OF BINGO-- "

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_234

	; M$="IF YOU SELECT PROMPT MODE THEN HIT THE ROW NUMBER (1-5/TOP TO BOTTOM) OF YOUR CARD AS IT IS CALLED."

	jsr	ld_sr1_ss
	.text	99, "IF YOU SELECT PROMPT MODE THEN HIT THE ROW NUMBER (1-5/TOP TO BOTTOM) OF YOUR CARD AS IT IS CALLED."

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 1

	ldx	#LINE_1
	jsr	gosub_ix

LINE_235

	; M$="I'LL BE WATCHING MY OWN CARDS FROM UP HERE IN DARTMOUTH."

	jsr	ld_sr1_ss
	.text	56, "I'LL BE WATCHING MY OWN CARDS FROM UP HERE IN DARTMOUTH."

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 1

	ldx	#LINE_1
	jsr	gosub_ix

LINE_238

	; PR=3

	ldx	#INTVAR_PR
	ldab	#3
	jsr	ld_ix_pb

	; PRINT @448, "PROMPT FOR CARD MARKING";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	23, "PROMPT FOR CARD MARKING"

	; INPUT M$

	jsr	input

	ldx	#STRVAR_M
	jsr	readbuf_sx

	jsr	ignxtra

	; IF LEFT$(M$,1)="N" THEN

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_239
	jsr	jmpeq_ir1_ix

	; PR=1

	ldx	#INTVAR_PR
	jsr	one_ix

	; GOTO 240

	ldx	#LINE_240
	jsr	goto_ix

LINE_239

	; PRINT @448,

	ldd	#448
	jsr	prat_pw

	; INPUT "LEVEL OF DIFFICULTY (1-3)"; LV$

	jsr	pr_ss
	.text	25, "LEVEL OF DIFFICULTY (1-3)"

	jsr	input

	ldx	#STRVAR_LV
	jsr	readbuf_sx

	jsr	ignxtra

	; LV=1500-(INT(VAL(LV$))*250)

	ldx	#STRVAR_LV
	jsr	val_fr1_sx

	ldab	#250
	jsr	mul_ir1_ir1_pb

	ldd	#1500
	jsr	rsub_ir1_ir1_pw

	ldx	#INTVAR_LV
	jsr	ld_ix_ir1

	; WHEN (LV<750) OR (LV>1250) GOTO 239

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldd	#750
	jsr	ldlt_ir1_ir1_pw

	ldd	#1250
	jsr	ld_ir2_pw

	ldx	#INTVAR_LV
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_239
	jsr	jmpne_ir1_ix

LINE_240

	; CLS

	jsr	cls

	; F=1

	ldx	#INTVAR_F
	jsr	one_ix

	; V=0

	ldx	#INTVAR_V
	jsr	clr_ix

	; W=0

	ldx	#INTVAR_W
	jsr	clr_ix

LINE_270

	; RESTORE

	jsr	restore

	; FOR C1=1 TO 5

	ldx	#INTVAR_C1
	jsr	forone_ix

	ldab	#5
	jsr	to_ip_pb

	; READ A$(C1)

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	jsr	arrref1_ir1_sx

	jsr	read_sp

	; NEXT

	jsr	next

LINE_280

LINE_290

	; REM THIS SEQUENCE GENERATES THE CARD NUMBERS

LINE_300

	; FOR K1=1 TO 75

	ldx	#INTVAR_K1
	jsr	forone_ix

	ldab	#75
	jsr	to_ip_pb

LINE_310

	; L(K1)=0

	ldx	#INTVAR_K1
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	jsr	clr_ip

LINE_320

	; NEXT K1

	ldx	#INTVAR_K1
	jsr	nextvar_ix

	jsr	next

LINE_330

	; REM 

LINE_340

	; WHEN F>1 GOTO 370

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_F
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_370
	jsr	jmpne_ir1_ix

LINE_350

	; LL=0

	ldx	#INTVAR_LL
	jsr	clr_ix

	; PRINT @LL, "   YOUR CARD    ";

	ldx	#INTVAR_LL
	jsr	prat_ix

	jsr	pr_ss
	.text	16, "   YOUR CARD    "

	; PRINT @LL+32, "Š€b€€i€€n€€g€€o…";

	ldx	#INTVAR_LL
	ldab	#32
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x8A\x80b\x80\x80i\x80\x80n\x80\x80g\x80\x80o\x85"

	; LL+=64

	ldx	#INTVAR_LL
	ldab	#64
	jsr	add_ix_ix_pb

LINE_360

	; GOTO 380

	ldx	#LINE_380
	jsr	goto_ix

LINE_370

	; LL=16

	ldx	#INTVAR_LL
	ldab	#16
	jsr	ld_ix_pb

	; PRINT @LL, "    MY CARD     ";

	ldx	#INTVAR_LL
	jsr	prat_ix

	jsr	pr_ss
	.text	16, "    MY CARD     "

	; PRINT @LL+32, "Š€b€€i€€n€€g€€o…";

	ldx	#INTVAR_LL
	ldab	#32
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x8A\x80b\x80\x80i\x80\x80n\x80\x80g\x80\x80o\x85"

	; LL+=64

	ldx	#INTVAR_LL
	ldab	#64
	jsr	add_ix_ix_pb

LINE_380

	; M=16

	ldx	#INTVAR_M
	ldab	#16
	jsr	ld_ix_pb

LINE_390

	; G=F+4

	ldx	#INTVAR_F
	ldab	#4
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

LINE_400

	; FOR Y=F TO G

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_410

	; FOR X=F TO G

	ldd	#INTVAR_X
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_420

	; R=INT(RND(0)*M)

	ldab	#0
	jsr	rnd_fr1_pb

	ldx	#INTVAR_M
	jsr	mul_fr1_fr1_ix

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

LINE_430

	; WHEN (M-15)>R GOTO 420

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTVAR_M
	ldab	#15
	jsr	sub_ir2_ix_pb

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_420
	jsr	jmpne_ir1_ix

LINE_440

	; WHEN L(R)<>0 GOTO 420

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldx	#LINE_420
	jsr	jmpne_ir1_ix

LINE_450

	; B(X,Y)=R

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrref2_ir1_ix

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_460

	; L(R)=1

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	jsr	one_ip

LINE_470

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_480

	; M+=15

	ldx	#INTVAR_M
	ldab	#15
	jsr	add_ix_ix_pb

LINE_490

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

LINE_500

	; REM THIS SEQUENCE PRINTS THE CARD

LINE_520

	; RR=0

	ldx	#INTVAR_RR
	jsr	clr_ix

LINE_530

	; FOR X=F TO G

	ldd	#INTVAR_X
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_570

	; FOR Y=F TO G

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_580

	; WHEN B(X,Y)=B(F+2,F+2) GOTO 610

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#INTVAR_F
	ldab	#2
	jsr	add_ir2_ix_pb

	ldx	#INTVAR_F
	ldab	#2
	jsr	add_ir3_ix_pb

	ldx	#INTARR_B
	jsr	arrval2_ir2_ix

	jsr	ldeq_ir1_ir1_ir2

	ldx	#LINE_610
	jsr	jmpne_ir1_ix

LINE_590

	; PRINT @LL+RR, "Š";MID$(STR$(B(X,Y))+" ",2,2);"…";

	ldx	#INTVAR_LL
	ldd	#INTVAR_RR
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x8A"

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	jsr	str_sr1_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, " "

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#2
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\x85"

	; RR+=3

	ldx	#INTVAR_RR
	ldab	#3
	jsr	add_ix_ix_pb

LINE_600

	; GOTO 620

	ldx	#LINE_620
	jsr	goto_ix

LINE_610

	; PRINT @LL+RR, "Š";

	ldx	#INTVAR_LL
	ldd	#INTVAR_RR
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x8A"

	; M$="  "

	jsr	ld_sr1_ss
	.text	2, "  "

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

	; PRINT "Š";

	jsr	pr_ss
	.text	1, "\x8A"

	; RR+=3

	ldx	#INTVAR_RR
	ldab	#3
	jsr	add_ix_ix_pb

LINE_620

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

	; LL+=32

	ldx	#INTVAR_LL
	ldab	#32
	jsr	add_ix_ix_pb

	; RR=0

	ldx	#INTVAR_RR
	jsr	clr_ix

LINE_630

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_670

	; PRINT @LL, "‹ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‡";

	ldx	#INTVAR_LL
	jsr	prat_ix

	jsr	pr_ss
	.text	16, "\x8B\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x83\x87"

LINE_720

	; WHEN F=6 GOTO 750

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#6
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_750
	jsr	jmpne_ir1_ix

LINE_730

	; F=6

	ldx	#INTVAR_F
	ldab	#6
	jsr	ld_ix_pb

LINE_740

	; GOTO 300

	ldx	#LINE_300
	jsr	goto_ix

LINE_750

	; REM CONTINUE

LINE_810

	; ON PR GOTO 840

	ldx	#INTVAR_PR
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_840

LINE_820

	; PRINT @256, "ARE YOU READY";

	ldd	#256
	jsr	prat_pw

	jsr	pr_ss
	.text	13, "ARE YOU READY"

LINE_830

	; INPUT R$

	jsr	input

	ldx	#STRVAR_R
	jsr	readbuf_sx

	jsr	ignxtra

LINE_840

	; WHEN LEFT$(R$,1)<>"N" GOTO 880

	ldx	#STRVAR_R
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	jsr	ldne_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_880
	jsr	jmpne_ir1_ix

LINE_860

	; PRINT "*********:HURRY UP:*********\r";

	jsr	pr_ss
	.text	29, "*********:HURRY UP:*********\r"

LINE_870

	; GOTO 810

	ldx	#LINE_810
	jsr	goto_ix

LINE_880

	; REM 

LINE_890

	; FOR K1=1 TO 75

	ldx	#INTVAR_K1
	jsr	forone_ix

	ldab	#75
	jsr	to_ip_pb

LINE_900

	; L(K1)=0

	ldx	#INTVAR_K1
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	jsr	clr_ip

LINE_910

	; NEXT K1

	ldx	#INTVAR_K1
	jsr	nextvar_ix

	jsr	next

LINE_930

	; B(3,3)=0

	ldab	#3
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#INTARR_B
	jsr	arrref2_ir1_ix

	jsr	clr_ip

LINE_940

	; B(8,8)=0

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#INTARR_B
	jsr	arrref2_ir1_ix

	jsr	clr_ip

LINE_950

	; REM THIS SEQUENCE GENERATES THE BINGO NUMBERS

LINE_960

	; U=INT(RND(0)*75)+1

	ldab	#0
	jsr	rnd_fr1_pb

	ldab	#75
	jsr	mul_fr1_fr1_pb

	jsr	inc_ir1_ir1

	ldx	#INTVAR_U
	jsr	ld_ix_ir1

LINE_970

	; WHEN L(U)<>0 GOTO 960

	ldx	#INTVAR_U
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldx	#LINE_960
	jsr	jmpne_ir1_ix

LINE_980

	; L(U)=1

	ldx	#INTVAR_U
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	jsr	one_ip

LINE_990

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1000

	; WHEN RND(0)>0.5 GOTO 1030

	ldx	#FLT_0p50000
	jsr	ld_fr1_fx

	ldab	#0
	jsr	rnd_fr2_pb

	jsr	ldlt_ir1_fr1_fr2

	ldx	#LINE_1030
	jsr	jmpne_ir1_ix

LINE_1010

	; PRINT @256, "THE NUMBER COMES UP:\r";

	ldd	#256
	jsr	prat_pw

	jsr	pr_ss
	.text	21, "THE NUMBER COMES UP:\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @288,

	ldd	#288
	jsr	prat_pw

LINE_1020

	; GOTO 1040

	ldx	#LINE_1040
	jsr	goto_ix

LINE_1030

	; PRINT @256, "THE NEXT ONE IS:\r";

	ldd	#256
	jsr	prat_pw

	jsr	pr_ss
	.text	17, "THE NEXT ONE IS:\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @288,

	ldd	#288
	jsr	prat_pw

LINE_1040

	; GU=0

	ldx	#INTVAR_GU
	jsr	clr_ix

	; FOR C1=1 TO PR

	ldx	#INTVAR_C1
	jsr	forone_ix

	ldx	#INTVAR_PR
	jsr	to_ip_ix

	; PRINT A$(IDIV((U-1),15)+1);STR$(U);"   ";

	ldx	#INTVAR_U
	jsr	dec_ir1_ix

	ldab	#15
	jsr	idiv5s_ir1_ir1_pb

	jsr	inc_ir1_ir1

	ldx	#STRARR_A
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_U
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	3, "   "

	; ON PR GOTO 1049

	ldx	#INTVAR_PR
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_1049

	; FOR C2=1 TO LV

	ldx	#INTVAR_C2
	jsr	forone_ix

	ldx	#INTVAR_LV
	jsr	to_ip_ix

LINE_1042

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; IF I$<>"" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldne_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_1043
	jsr	jmpeq_ir1_ix

	; IF GU=0 THEN

	ldx	#INTVAR_GU
	jsr	ld_ir1_ix

	ldx	#LINE_1043
	jsr	jmpne_ir1_ix

	; GU=INT(VAL(I$))

	ldx	#STRVAR_I
	jsr	val_fr1_sx

	ldx	#INTVAR_GU
	jsr	ld_ix_ir1

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_1043

	; NEXT

	jsr	next

LINE_1049

	; NEXT

	jsr	next

	; IF GU THEN

	ldx	#INTVAR_GU
	jsr	ld_ir1_ix

	ldx	#LINE_1050
	jsr	jmpeq_ir1_ix

	; PRINT STR$(GU);" ";

	ldx	#INTVAR_GU
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_1050

	; REM THIS IS THE "NUMBER ON CARD?" SEQUENCE

LINE_1060

	; FOR Y=1 TO 10

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

LINE_1070

	; FOR X=1 TO 10

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

LINE_1080

	; WHEN B(X,Y)=U GOTO 1200

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#INTVAR_U
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_1200
	jsr	jmpne_ir1_ix

LINE_1090

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_1100

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

LINE_1110

	; F=1

	ldx	#INTVAR_F
	jsr	one_ix

LINE_1120

	; GOSUB 1250

	ldx	#LINE_1250
	jsr	gosub_ix

LINE_1130

	; F=6

	ldx	#INTVAR_F
	ldab	#6
	jsr	ld_ix_pb

LINE_1140

	; GOSUB 1250

	ldx	#LINE_1250
	jsr	gosub_ix

LINE_1150

	; WHEN (V=1) AND (W=1) GOTO 1900

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_W
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1900
	jsr	jmpne_ir1_ix

LINE_1160

	; WHEN V=1 GOTO 2000

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_2000
	jsr	jmpne_ir1_ix

LINE_1170

	; WHEN W=1 GOTO 2080

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_2080
	jsr	jmpne_ir1_ix

LINE_1180

	; GOTO 960

	ldx	#LINE_960
	jsr	goto_ix

LINE_1200

	; C1=SHIFT(X-1,5)+((Y-1)*3)+65

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	dec_ir2_ix

	jsr	mul3_ir2_ir2

	jsr	add_ir1_ir1_ir2

	ldab	#65
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; IF X>5 THEN

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTVAR_X
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_1201
	jsr	jmpeq_ir1_ix

	; WHEN Y>5 GOTO 1215

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_1215
	jsr	jmpne_ir1_ix

LINE_1201

	; IF PR=3 THEN

	ldx	#INTVAR_PR
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1205
	jsr	jmpeq_ir1_ix

	; WHEN GU<>X GOTO 1210

	ldx	#INTVAR_GU
	ldd	#INTVAR_X
	jsr	ldne_ir1_ix_id

	ldx	#LINE_1210
	jsr	jmpne_ir1_ix

LINE_1205

	; PRINT @C1,

	ldx	#INTVAR_C1
	jsr	prat_ix

	; M$=MID$(STR$(B(X,Y))+" ",2,2)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	jsr	str_sr1_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, " "

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#2
	jsr	midT_sr1_sr1_pb

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

	; B(X,Y)=0

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrref2_ir1_ix

	jsr	clr_ip

LINE_1210

	; PRINT @320,

	ldd	#320
	jsr	prat_pw

	; GOTO 1090

	ldx	#LINE_1090
	jsr	goto_ix

LINE_1215

	; C1+=1

	ldx	#INTVAR_C1
	jsr	inc_ix_ix

	; C1-=160

	ldx	#INTVAR_C1
	ldab	#160
	jsr	sub_ix_ix_pb

	; IF LV THEN

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldx	#LINE_1216
	jsr	jmpeq_ir1_ix

	; WHEN RND(LV)<5 GOTO 1210

	ldx	#INTVAR_LV
	jsr	rnd_fr1_ix

	ldab	#5
	jsr	ldlt_ir1_fr1_pb

	ldx	#LINE_1210
	jsr	jmpne_ir1_ix

LINE_1216

	; GOTO 1205

	ldx	#LINE_1205
	jsr	goto_ix

LINE_1220

	; REM THIS IS THE BINGO DETERMINING SEQUENCE

LINE_1230

	; REM 

LINE_1240

	; REM THIS IS THE VERTICAL CHECK FOR BINGO***

LINE_1250

	; G=F+4

	ldx	#INTVAR_F
	ldab	#4
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

LINE_1260

	; FOR Y=F TO G

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_1270

	; FOR X=F TO G

	ldd	#INTVAR_X
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_1280

	; IF B(X,Y)<>0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#LINE_1290
	jsr	jmpeq_ir1_ix

	; X=G

	ldd	#INTVAR_X
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; GOTO 1390

	ldx	#LINE_1390
	jsr	goto_ix

LINE_1290

	; WHEN (F+4)>X GOTO 1390

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_F
	ldab	#4
	jsr	add_ir2_ix_pb

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_1390
	jsr	jmpne_ir1_ix

LINE_1300

	; WHEN F=6 GOTO 1350

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#6
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1350
	jsr	jmpne_ir1_ix

LINE_1310

	; PRINT "YOU'VE GOT A   B I N G O * * *\r";

	jsr	pr_ss
	.text	31, "YOU'VE GOT A   B I N G O * * *\r"

LINE_1330

	; W=1

	ldx	#INTVAR_W
	jsr	one_ix

	; WW+=1

	ldx	#INTVAR_WW
	jsr	inc_ix_ix

LINE_1340

	; GOTO 1380

	ldx	#LINE_1380
	jsr	goto_ix

LINE_1350

	; PRINT "I'VE GOT A   B I N G O * * * *\r";

	jsr	pr_ss
	.text	31, "I'VE GOT A   B I N G O * * * *\r"

LINE_1370

	; V=1

	ldx	#INTVAR_V
	jsr	one_ix

	; VV+=1

	ldx	#INTVAR_VV
	jsr	inc_ix_ix

LINE_1380

	; X=G

	ldd	#INTVAR_X
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

	; Y=G

	ldd	#INTVAR_Y
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

	; RETURN

	jsr	return

LINE_1390

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_1400

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

LINE_1410

	; REM THIS IS THE HORIZONTAL CHECK FOR BINGO***

LINE_1420

	; G=F+4

	ldx	#INTVAR_F
	ldab	#4
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

LINE_1430

	; FOR X=F TO G

	ldd	#INTVAR_X
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_1440

	; FOR Y=F TO G

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	for_id_ix

	ldx	#INTVAR_G
	jsr	to_ip_ix

LINE_1450

	; IF B(X,Y)<>0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#LINE_1460
	jsr	jmpeq_ir1_ix

	; Y=G

	ldd	#INTVAR_Y
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; GOTO 1560

	ldx	#LINE_1560
	jsr	goto_ix

LINE_1460

	; WHEN (F+4)>Y GOTO 1560

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_F
	ldab	#4
	jsr	add_ir2_ix_pb

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_1560
	jsr	jmpne_ir1_ix

LINE_1470

	; WHEN F=6 GOTO 1520

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#6
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1520
	jsr	jmpne_ir1_ix

LINE_1480

	; PRINT "YOU'VE GOT A   B I N G O * * *\r";

	jsr	pr_ss
	.text	31, "YOU'VE GOT A   B I N G O * * *\r"

LINE_1500

	; W=1

	ldx	#INTVAR_W
	jsr	one_ix

	; WW+=1

	ldx	#INTVAR_WW
	jsr	inc_ix_ix

LINE_1510

	; GOTO 1550

	ldx	#LINE_1550
	jsr	goto_ix

LINE_1520

	; PRINT "I'VE GOT A   B I N G O * * * *\r";

	jsr	pr_ss
	.text	31, "I'VE GOT A   B I N G O * * * *\r"

LINE_1540

	; V=1

	ldx	#INTVAR_V
	jsr	one_ix

	; VV+=1

	ldx	#INTVAR_VV
	jsr	inc_ix_ix

LINE_1550

	; Y=G

	ldd	#INTVAR_Y
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

	; X=G

	ldd	#INTVAR_X
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

	; RETURN

	jsr	return

LINE_1560

	; NEXT Y

	ldx	#INTVAR_Y
	jsr	nextvar_ix

	jsr	next

LINE_1570

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_1580

	; REM THIS IS THE SLANT CHECK (M=-1) FOR BINGO*** 

LINE_1590

	; X=F

	ldd	#INTVAR_X
	ldx	#INTVAR_F
	jsr	ld_id_ix

LINE_1600

	; Y=F

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	ld_id_ix

LINE_1610

	; IF B(X,Y)<>0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#LINE_1620
	jsr	jmpeq_ir1_ix

	; GOTO 1740

	ldx	#LINE_1740
	jsr	goto_ix

	; REM FIXED ERROR-- CHANGED TO 1740 FROM 1720

LINE_1620

	; X+=1

	ldx	#INTVAR_X
	jsr	inc_ix_ix

LINE_1630

	; Y+=1

	ldx	#INTVAR_Y
	jsr	inc_ix_ix

LINE_1640

	; WHEN (F+5)>Y GOTO 1610

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_F
	ldab	#5
	jsr	add_ir2_ix_pb

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_1610
	jsr	jmpne_ir1_ix

LINE_1650

	; WHEN Y=11 GOTO 1700

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#11
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1700
	jsr	jmpne_ir1_ix

LINE_1660

	; PRINT "YOU'VE GOT A   B I N G O * * *\r";

	jsr	pr_ss
	.text	31, "YOU'VE GOT A   B I N G O * * *\r"

LINE_1670

	; W=1

	ldx	#INTVAR_W
	jsr	one_ix

	; WW+=1

	ldx	#INTVAR_WW
	jsr	inc_ix_ix

LINE_1690

	; RETURN

	jsr	return

LINE_1700

	; PRINT "I'VE GOT A   B I N G O * * * *\r";

	jsr	pr_ss
	.text	31, "I'VE GOT A   B I N G O * * * *\r"

LINE_1710

	; V=1

	ldx	#INTVAR_V
	jsr	one_ix

	; VV+=1

	ldx	#INTVAR_VV
	jsr	inc_ix_ix

LINE_1720

	; RETURN

	jsr	return

LINE_1730

	; REM THIS IS THE SLANT CHECK (M=1) FOR BINGO***

LINE_1740

	; X=F+4

	ldx	#INTVAR_F
	ldab	#4
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

LINE_1750

	; Y=F

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	ld_id_ix

LINE_1760

	; WHEN B(X,Y)<>0 GOTO 1880

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTARR_B
	jsr	arrval2_ir1_ix

	ldx	#LINE_1880
	jsr	jmpne_ir1_ix

LINE_1770

	; X-=1

	ldx	#INTVAR_X
	jsr	dec_ix_ix

LINE_1780

	; Y+=1

	ldx	#INTVAR_Y
	jsr	inc_ix_ix

LINE_1790

	; WHEN (F+5)>Y GOTO 1760

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_F
	ldab	#5
	jsr	add_ir2_ix_pb

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_1760
	jsr	jmpne_ir1_ix

LINE_1800

	; WHEN Y=11 GOTO 1850

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#11
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1850
	jsr	jmpne_ir1_ix

LINE_1810

	; PRINT "YOU'VE GOT A   B I N G O * * *\r";

	jsr	pr_ss
	.text	31, "YOU'VE GOT A   B I N G O * * *\r"

LINE_1830

	; W=1

	ldx	#INTVAR_W
	jsr	one_ix

	; WW+=1

	ldx	#INTVAR_WW
	jsr	inc_ix_ix

LINE_1840

	; RETURN

	jsr	return

LINE_1850

	; PRINT "I'VE GOT A   B I N G O * * * *\r";

	jsr	pr_ss
	.text	31, "I'VE GOT A   B I N G O * * * *\r"

LINE_1870

	; V=1

	ldx	#INTVAR_V
	jsr	one_ix

	; VV+=1

	ldx	#INTVAR_VV
	jsr	inc_ix_ix

LINE_1880

	; RETURN

	jsr	return

LINE_1890

	; REM THIS THE TIE PRINTOUT SEQUENCE

LINE_1900

	; PRINT "********* IT'S A TIE *********\r";

	jsr	pr_ss
	.text	31, "********* IT'S A TIE *********\r"

	; GOTO 1940

	ldx	#LINE_1940
	jsr	goto_ix

LINE_1920

	; REM THIS IS THE "PLAY AGAIN?" SEQUENCE

LINE_1930

	; REM GOTO240:REM THIS OUT

LINE_1940

	; PRINT @448, "DO YOU WANT TO PLAY AGAIN";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	25, "DO YOU WANT TO PLAY AGAIN"

LINE_1950

	; INPUT E$

	jsr	input

	ldx	#STRVAR_E
	jsr	readbuf_sx

	jsr	ignxtra

LINE_1970

	; WHEN (E$="NO") OR (E$="N") GOTO 3000

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	2, "NO"

	ldx	#STRVAR_E
	jsr	ld_sr2_sx

	jsr	ldeq_ir2_sr2_ss
	.text	1, "N"

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_3000
	jsr	jmpne_ir1_ix

LINE_1980

	; GOTO 240

	ldx	#LINE_240
	jsr	goto_ix

LINE_1990

	; REM THIS IS THE "I WIN" SEQUENCE

LINE_2000

	; FOR S=1 TO 4

	ldx	#INTVAR_S
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

LINE_2020

	; PRINT "I WIN!  ";

	jsr	pr_ss
	.text	8, "I WIN!  "

	; FOR C2=1 TO 1500

	ldx	#INTVAR_C2
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

LINE_2030

	; NEXT S

	ldx	#INTVAR_S
	jsr	nextvar_ix

	jsr	next

LINE_2060

	; GOTO 1930

	ldx	#LINE_1930
	jsr	goto_ix

LINE_2070

	; REM THIS IS THE "YOU WIN" SEQUENCE

LINE_2080

	; PRINT TAB(10);"YOU WIN.....\r";

	ldab	#10
	jsr	prtab_pb

	jsr	pr_ss
	.text	13, "YOU WIN.....\r"

LINE_2100

	; GOTO 1930

	ldx	#LINE_1930
	jsr	goto_ix

LINE_2110

	; REM THIS IS THE "END" OF THE LIST OF PROGRAM ENTITLED "BINGO"

LINE_2120

	; END

	jsr	progend

LINE_3000

	; CLS

	jsr	cls

	; PRINT "YOU";STR$(WW);" ";,;"ME";STR$(VV);" \r";

	jsr	pr_ss
	.text	3, "YOU"

	ldx	#INTVAR_WW
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	jsr	prcomma

	jsr	pr_ss
	.text	2, "ME"

	ldx	#INTVAR_VV
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_3010

	; IF LV THEN

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldx	#LINE_3030
	jsr	jmpeq_ir1_ix

	; PRINT "AT LEVEL ";LV$;"\r";

	jsr	pr_ss
	.text	9, "AT LEVEL "

	ldx	#STRVAR_LV
	jsr	pr_sx

	jsr	pr_ss
	.text	1, "\r"

LINE_3030

	; END

	jsr	progend

LINE_3100

	; REM NAME--BINGO

LINE_3110

	; REM 

LINE_3120

	; REM DESCRIPTION--

LINE_3130

	; REM GAME OF BINGO

LINE_3140

	; REM SOURCE--

LINE_3150

	; REM LARRY BETHURUM

LINE_3160

	; REM PHILLIPS EXETER

LINE_3170

	; REM ACADEMY. 1/23/66

LINE_3180

	; REM MC-10 EDITS BY

LINE_3190

	; REM JIM GERRIE 2022

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

	.module	mdgeteq
geteq
	beq	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetlo
getlo
	blo	_1
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

	.module	mdidiv35
; fast divide by 3 or 5
; ENTRY: X in tmp1+1,tmp2,tmp2+1
;        ACCD is $CC05 for divide by 5
;        ACCD is $AA03 for divide by 3
; EXIT:  INT(X/(3 or 5)) in tmp1+1,tmp2,tmp2+1
;   tmp3,tmp3+1,tmp4 used for storage
idiv35
	psha
	jsr	imodb
	tab
	ldaa	tmp2+1
	sba
	staa	tmp2+1
	bcc	_dodiv
	ldd	tmp1+1
	subd	#1
	std	tmp1+1
_dodiv
	pulb
	jmp	idivb

	.module	mdidiv5s
; fast divide when divisor is '5-smooth'
; (i.e. having factors only of 2, 3, 5)
; ENTRY: X holds dividend
;        ACCB holds divisor
; EXIT:  INT(X/ACCB) in X
;   tmp1-tmp4 used for storage
idiv5s
	; div by factors of 2?
	bitb	#1
	bne	_odd
	lsrb
	asr	,x
	ror	1,x
	ror	2,x
	bra	idiv5s
_odd
	cmpb	#1
	beq	_rts
	stab	tmp1
	ldab	,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
_do3
	ldab	tmp1
_by3
	ldaa	#$AB
	mul
	cmpb	#$55
	bhi	_do5
	stab	tmp1
	ldd	#$AA03
	jsr	idiv35
	ldab	tmp1
	cmpb	#1
	beq	_store
	bra	_by3
_do5
	ldab	tmp1
_by5
	ldaa	#$CD
	mul
	stab	tmp1
	ldd	#$CC05
	jsr	idiv35
	ldab	tmp1
	cmpb	#1
	bne	_by5
_store
	ldab	tmp1+1
	stab	,x
	ldd	tmp2
	std	1,x
_rts
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
	cmpa	#','
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

	.module	mdmul12
; multiply words in TMP1 and TMP2
; result in TMP3
mul12
	ldaa	tmp1+1
	ldab	tmp2+1
	mul
	std	tmp3
	ldaa	tmp1
	ldab	tmp2+1
	mul
	addb	tmp3
	stab	tmp3
	ldaa	tmp1+1
	ldab	tmp2
	mul
	tba
	adda	tmp3
	ldab	tmp3+1
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

	.module	mdprtab
prtab
	jsr	R_MKTAB
	subb	DP_LPOS
	bls	_rts
_again
	jsr	R_SPACE
	decb
	bne	_again
_rts
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
	subd	2,x
	bhi	_err
	ldd	0+argv
	std	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

	.module	mdref2
; get offset from 2D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref2
	ldd	2,x
	std	tmp1
	subd	0+argv
	bls	_err
	ldd	2+argv
	std	tmp2
	subd	4,x
	bhs	_err
	jsr	mul12
	addd	0+argv
	std	tmp1
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

	.module	mdrpstrng
; read string DATA when records are pure strings
; EXIT:  data string descriptor in tmp1+1, tmp2
rpstrng
	pshx
	ldx	DP_DATA
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldab	,x
	stab	tmp1+1
	inx
	stx	tmp2
	abx
	stx	DP_DATA
	pulx
	rts

	.module	mdrsstrng
; read string DATA when records are pure strings
; ENTRY: X holds destination string descriptor
; EXIT:  data table read, and perm string created in X
rsstrng
	jsr	strdel
	jsr	rpstrng
	ldab	tmp1+1
	stab	0,X
	ldd	tmp2
	std	1,X
	rts

	.module	mdshlint
; multiply X by 2^ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x)
;          uses tmp1
shlint
	cmpb	#8
	blo	_shlbit
	stab	tmp1
	ldd	1,x
	std	0,x
	clr	2,x
	ldab	tmp1
	subb	#8
	bne	shlint
	rts
_shlbit
	lsl	2,x
	rol	1,x
	rol	0,x
	decb
	bne	_shlbit
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

	.module	mdstrlo
strlo
	stab	tmp1+1
	ldx	1+argv
	jsr	strrel
	ldx	tmp2
	jsr	strrel
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
	ldab	tmp1+1
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
	jsr	divuflt
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
	beq	_srts
	jmp	negtmp
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
	inc	tmp4
	ldd	tmp1+1
	subd	#$0CCC
	pulb
	blo	_nxtdig
	ldaa	tmp2+1
	cmpa	#$CC
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
	.byte	$01,$86,$A0
	.byte	$0F,$42,$40
	.byte	$98,$96,$80

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

add_ir1_ir1_ir2			; numCalls = 1
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 1
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 1
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 4
	.module	modadd_ir1_ix_id
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	ldx	tmp1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ix_pb			; numCalls = 7
	.module	modadd_ir1_ix_pb
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ix_pb			; numCalls = 5
	.module	modadd_ir2_ix_pb
	clra
	addd	1,x
	std	r2+1
	ldab	#0
	adcb	0,x
	stab	r2
	rts

add_ir3_ix_pb			; numCalls = 1
	.module	modadd_ir3_ix_pb
	clra
	addd	1,x
	std	r3+1
	ldab	#0
	adcb	0,x
	stab	r3
	rts

add_ix_ix_ir1			; numCalls = 1
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

and_ir1_ir1_ir2			; numCalls = 2
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir2_ir2_pb			; numCalls = 1
	.module	modand_ir2_ir2_pb
	andb	r2+2
	clra
	std	r2+1
	staa	r2
	rts

arrdim1_ir1_ix			; numCalls = 1
	.module	modarrdim1_ir1_ix
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

arrdim1_ir1_sx			; numCalls = 1
	.module	modarrdim1_ir1_sx
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

arrdim2_ir1_ix			; numCalls = 1
	.module	modarrdim2_ir1_ix
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
	std	tmp1
	ldd	r2+1
	addd	#1
	std	4,x
	std	tmp2
	jsr	mul12
	std	tmp3
	lsld
	addd	tmp3
	jmp	alloc

arrref1_ir1_ix			; numCalls = 4
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx			; numCalls = 1
	.module	modarrref1_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix			; numCalls = 4
	.module	modarrref2_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 2
	.module	modarrval1_ir1_ix
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

arrval1_ir1_sx			; numCalls = 1
	.module	modarrval1_ir1_sx
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

arrval2_ir1_ix			; numCalls = 8
	.module	modarrval2_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval2_ir2_ix			; numCalls = 1
	.module	modarrval2_ir2_ix
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

asc_ir1_sr1			; numCalls = 1
	.module	modasc_ir1_sr1
	ldab	r1
	beq	_fc_error
	ldx	r1+1
	ldab	,x
	jsr	strrel
_null
	stab	r1+2
	ldd	#0
	std	r1
	rts
_fc_error
	ldab	#FC_ERROR
	jmp	error

clear			; numCalls = 2
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

clr_ip			; numCalls = 5
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 7
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 3
	.module	modcls
	jmp	R_CLS

dec_ir1_ir1			; numCalls = 1
	.module	moddec_ir1_ir1
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 2
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 1
	.module	moddec_ir2_ix
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 1
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_id_ix			; numCalls = 9
	.module	modfor_id_ix
	std	letptr
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	ldx	letptr
	std	1,x
	ldab	tmp1+1
	stab	0,x
	rts

forone_ix			; numCalls = 10
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 8
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 19
	.module	modgoto_ix
	ins
	ins
	jmp	,x

idiv5s_ir1_ir1_pb			; numCalls = 1
	.module	modidiv5s_ir1_ir1_pb
	ldx	#r1
	jmp	idiv5s

ignxtra			; numCalls = 4
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inc_ir1_ir1			; numCalls = 2
	.module	modinc_ir1_ir1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 1
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ix_ix			; numCalls = 12
	.module	modinc_ix_ix
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 1
	.module	modinkey_sx
	pshx
	jsr	strdel
	pulx
	clr	strtcnt
	ldd	#$0100+(charpage>>8)
	std	0,x
	ldaa	M_IKEY
	bne	_gotkey
	jsr	R_KEYIN
_gotkey
	clr	M_IKEY
	staa	2,x
	bne	_rts
	staa	0,x
_rts
	rts

input			; numCalls = 4
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

jmpeq_ir1_ix			; numCalls = 12
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

jmpne_ir1_ix			; numCalls = 27
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

ld_fr1_fx			; numCalls = 1
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_id_ix			; numCalls = 9
	.module	modld_id_ix
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts

ld_ip_ir1			; numCalls = 1
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 39
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_nb			; numCalls = 1
	.module	modld_ir1_nb
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ir1_pb			; numCalls = 10
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 14
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 6
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir2_pw			; numCalls = 1
	.module	modld_ir2_pw
	std	r2+1
	ldab	#0
	stab	r2
	rts

ld_ix_ir1			; numCalls = 13
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 6
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

ld_sr1_ss			; numCalls = 6
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 9
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sr2_sx			; numCalls = 1
	.module	modld_sr2_sx
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_sx_sr1			; numCalls = 8
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ir2			; numCalls = 1
	.module	modldeq_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	bne	_done
	ldab	r1
	cmpb	r2
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ir1_ix			; numCalls = 1
	.module	modldeq_ir1_ir1_ix
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

ldeq_ir1_ir1_pb			; numCalls = 9
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 3
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

ldeq_ir2_ir2_pb			; numCalls = 1
	.module	modldeq_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_sr2_ss			; numCalls = 1
	.module	modldeq_ir2_sr2_ss
	ldab	r2
	stab	tmp1+1
	ldd	r2+1
	std	tmp2
	jsr	streqs
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldlt_ir1_fr1_fr2			; numCalls = 1
	.module	modldlt_ir1_fr1_fr2
	ldd	r1+3
	subd	r2+3
	ldd	r1+1
	sbcb	r2+2
	sbca	r2+1
	ldab	r1
	sbcb	r2
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

ldlt_ir1_ir1_ir2			; numCalls = 5
	.module	modldlt_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 4
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pw			; numCalls = 1
	.module	modldlt_ir1_ir1_pw
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getlt
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

ldlt_ir2_ir2_ix			; numCalls = 1
	.module	modldlt_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ix_id			; numCalls = 1
	.module	modldne_ir1_ix_id
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
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_sr1_ss			; numCalls = 2
	.module	modldne_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqs
	jsr	getne
	std	r1+1
	stab	r1
	rts

left_sr1_sr1_pb			; numCalls = 2
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

len_ir1_sx			; numCalls = 1
	.module	modlen_ir1_sx
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

midT_sr1_sr1_ir3			; numCalls = 1
	.module	modmidT_sr1_sr1_ir3
	ldd	5+r1
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	5+r1+2
	beq	_fc_error
	ldab	r1
	subb	5+r1+2
	blo	_zero
	incb
	stab	r1
	ldd	5+r1+1
	subd	#1
	addd	r1+1
	std	r1+1
	ldab	r3+2
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

midT_sr1_sr1_pb			; numCalls = 3
	.module	modmidT_sr1_sr1_pb
	clra
	std	tmp1
	ldd	5+r1
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	5+r1+2
	beq	_fc_error
	ldab	r1
	subb	5+r1+2
	blo	_zero
	incb
	stab	r1
	ldd	5+r1+1
	subd	#1
	addd	r1+1
	std	r1+1
	ldab	tmp1+1
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

mid_sr1_sr1_ix			; numCalls = 1
	.module	modmid_sr1_sr1_ix
	ldd	0,x
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	2,x
	beq	_fc_error
	ldab	r1
	incb
	subb	2,x
	bls	_zero
	stab	r1
	ldd	1,x
	subd	#1
	addd	r1+1
	std	r1+1
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

mul3_ir2_ir2			; numCalls = 1
	.module	modmul3_ir2_ir2
	ldx	#r2
	jmp	mul3i

mul_fr1_fr1_ix			; numCalls = 1
	.module	modmul_fr1_fr1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_pb			; numCalls = 1
	.module	modmul_ir1_ir1_pb
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

next			; numCalls = 23
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

nextvar_ix			; numCalls = 17
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

one_ip			; numCalls = 2
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 12
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongoto_ir1_is			; numCalls = 2
	.module	modongoto_ir1_is
	pulx
	ldd	r1
	bne	_fail
	ldab	r1+2
	decb
	cmpb	0,x
	bhs	_fail
	abx
	abx
	ldx	1,x
	jmp	,x
_fail
	ldab	,x
	abx
	abx
	jmp	1,x

or_ir1_ir1_ir2			; numCalls = 2
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

poke_ir1_ir2			; numCalls = 1
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

pos_ir1			; numCalls = 1
	.module	modpos_ir1
	ldd	M_CRSR
	anda	#1
	std	r1+1
	clrb
	stab	r1
	rts

pr_sr1			; numCalls = 7
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 42
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 1
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 5
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 4
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 2
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 9
	.module	modprat_pw
	jmp	prat

prcomma			; numCalls = 1
	.module	modprcomma
	jsr	R_MKTAB
	beq	_screen
	ldab	DP_LPOS
	cmpb	DP_LTAB
	blo	_nxttab
	jmp	R_ENTER
_screen
	ldab	DP_LPOS
_nxttab
	subb	DP_TABW
	bhs	_nxttab
_nxtspc
	jsr	R_SPACE
	incb
	beq	_nxtspc
_rts
	rts

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

progend			; numCalls = 3
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jmp	prtab

read_sp			; numCalls = 1
	.module	modread_sp
	ldx	letptr
	jmp	rsstrng

readbuf_sx			; numCalls = 4
	.module	modreadbuf_sx
	stx	letptr
	jsr	rdinit
	ldaa	#','
	staa	tmp1
	ldaa	,x
	beq	_null
	cmpa	#'"'
	bne	_unquoted
	staa	tmp1
	inx
_unquoted
	stx	tmp3
	clrb
_nxtchr
	incb
	inx
	ldaa	,x
	beq	_done
	cmpa	tmp1
	bne	_nxtchr
_done
	stx	inptptr
	stab	0+argv
	ldd	tmp3
	std	1+argv
	ldx	letptr
	jsr	strprm
_rdredo
	jsr	rdredo
	beq	_rts
	pulx
	jmp	,x
_rts
	rts
_null
	ldx	letptr
	jsr	strdel
	ldd	#$0100
	ldx	letptr
	stab	0,x
	std	1,x
	bra	_rdredo

restore			; numCalls = 1
	.module	modrestore
	ldx	#startdata
	stx	DP_DATA
	rts

return			; numCalls = 8
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

rnd_fr1_ir1			; numCalls = 1
	.module	modrnd_fr1_ir1
	ldab	r1
	stab	tmp1+1
	bmi	_neg
	ldd	r1+1
	std	tmp2
	beq	_flt
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	ldd	#0
	std	r1+3
	rts
_neg
	ldd	r1+1
	std	tmp2
_flt
	jsr	rnd
	std	r1+3
	ldd	#0
	std	r1+1
	stab	r1
	rts

rnd_fr1_ix			; numCalls = 1
	.module	modrnd_fr1_ix
	ldab	0,x
	stab	tmp1+1
	bmi	_neg
	ldd	1,x
	std	tmp2
	beq	_flt
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	ldd	#0
	std	r1+3
	rts
_neg
	ldd	1,x
	std	tmp2
_flt
	jsr	rnd
	std	r1+3
	ldd	#0
	std	r1+1
	stab	r1
	rts

rnd_fr1_pb			; numCalls = 2
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

rnd_fr2_pb			; numCalls = 1
	.module	modrnd_fr2_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	rnd
	std	r2+3
	ldd	#0
	std	r2+1
	stab	r2
	rts

rsub_ir1_ir1_pw			; numCalls = 1
	.module	modrsub_ir1_ir1_pw
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

rsub_ir2_ir2_ix			; numCalls = 1
	.module	modrsub_ir2_ir2_ix
	ldd	1,x
	subd	r2+1
	std	r2+1
	ldab	0,x
	sbcb	r2
	stab	r2
	rts

shift_ir1_ir1_pb			; numCalls = 1
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 1
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 1
	.module	modstep_ip_ir1
	tsx
	ldd	10,x
	beq	_zero
	ldab	r1
	bpl	_nonzero
	ldd	8,x
	addd	#1
	std	8,x
	ldab	7,x
	adcb	#0
	stab	7,x
_zero
	ldab	r1
_nonzero
	stab	10,x
	ldd	r1+1
	std	11,x
	ldd	,x
	std	5,x
	rts

str_sr1_ir1			; numCalls = 2
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

strcat_sr1_sr1_ss			; numCalls = 2
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

strinit_sr1_sr1			; numCalls = 2
	.module	modstrinit_sr1_sr1
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

sub_ir1_ir1_ix			; numCalls = 1
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir2_ix_pb			; numCalls = 1
	.module	modsub_ir2_ix_pb
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

sub_ir2_pb_ix			; numCalls = 1
	.module	modsub_ir2_pb_ix
	subb	2,x
	stab	r2+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r2
	rts

sub_ir3_ix_id			; numCalls = 1
	.module	modsub_ir3_ix_id
	std	tmp1
	ldab	0,x
	stab	r3
	ldd	1,x
	ldx	tmp1
	subd	1,x
	std	r3+1
	ldab	r3
	sbcb	0,x
	stab	r3
	rts

sub_ix_ix_pb			; numCalls = 1
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

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_ix			; numCalls = 11
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

to_ip_pw			; numCalls = 1
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

val_fr1_sx			; numCalls = 2
	.module	modval_fr1_sx
	jsr	strval
	ldab	tmp1+1
	stab	r1
	ldd	tmp2
	std	r1+1
	ldd	tmp3
	std	r1+3
	rts

; data table
startdata
	.text	2, "B "
	.text	2, "I "
	.text	2, "N "
	.text	2, "G "
	.text	2, "O "
enddata


; fixed-point constants
FLT_0p50000	.byte	$00, $00, $00, $80, $00

; block started by symbol
bss

; Numeric Variables
INTVAR_C1	.block	3
INTVAR_C2	.block	3
INTVAR_C3	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_GU	.block	3
INTVAR_K1	.block	3
INTVAR_LL	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_PR	.block	3
INTVAR_R	.block	3
INTVAR_RR	.block	3
INTVAR_S	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_VV	.block	3
INTVAR_W	.block	3
INTVAR_WW	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
; String Variables
STRVAR_E	.block	3
STRVAR_I	.block	3
STRVAR_LV	.block	3
STRVAR_M	.block	3
STRVAR_R	.block	3
; Numeric Arrays
INTARR_B	.block	6	; dims=2
INTARR_L	.block	4	; dims=1
; String Arrays
STRARR_A	.block	4	; dims=1

; block ended by symbol
bes
	.end

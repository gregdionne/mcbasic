; Assembly for towers.bas
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
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_10

	; CLEAR 1000

	jsr	clear

LINE_20

	; FOR X=1 TO 4

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; BL$=BL$+"€"

	ldx	#STRVAR_BL
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	ldx	#STRVAR_BL
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

LINE_30

	; BL$=BL$+"Å"

	ldx	#STRVAR_BL
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xC5"

	ldx	#STRVAR_BL
	jsr	ld_sx_sr1

LINE_40

	; FOR X=1 TO 4

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; BL$=BL$+"€"

	ldx	#STRVAR_BL
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	ldx	#STRVAR_BL
	jsr	ld_sx_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_50

	; CLS

	jsr	cls

LINE_60

	; PRINT @32, "********************************";

	ldab	#32
	jsr	prat_pb

	jsr	pr_ss
	.text	32, "********************************"

LINE_70

	; PRINT @71, "THE GAME OF TOWERS\r";

	ldab	#71
	jsr	prat_pb

	jsr	pr_ss
	.text	19, "THE GAME OF TOWERS\r"

LINE_80

	; PRINT @96, "********************************";

	ldab	#96
	jsr	prat_pb

	jsr	pr_ss
	.text	32, "********************************"

LINE_90

	; PRINT @161, "1- YOU PLAY (USE A,S & SPACE).\r";

	ldab	#161
	jsr	prat_pb

	jsr	pr_ss
	.text	31, "1- YOU PLAY (USE A,S & SPACE).\r"

LINE_100

	; PRINT @225, "2- COMPUTER'S DEMONSTRATION.\r";

	ldab	#225
	jsr	prat_pb

	jsr	pr_ss
	.text	29, "2- COMPUTER'S DEMONSTRATION.\r"

LINE_110

	; PRINT @289, "3- COMPUTER'S DEMONSTRATION\r";

	ldd	#289
	jsr	prat_pw

	jsr	pr_ss
	.text	28, "3- COMPUTER'S DEMONSTRATION\r"

LINE_120

	; PRINT @324, "(SLOW MOTION).\r";

	ldd	#324
	jsr	prat_pw

	jsr	pr_ss
	.text	15, "(SLOW MOTION).\r"

LINE_130

	; R$=INKEY$

	ldx	#STRVAR_R
	jsr	inkey_sx

	; WHEN R$="" GOTO 130

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_130
	jsr	jmpne_ir1_ix

LINE_140

	; WHEN (R$<>"1") AND (R$="") AND (R$<>"3") GOTO 60

	ldx	#STRVAR_R
	jsr	ldne_ir1_sx_ss
	.text	1, "1"

	ldx	#STRVAR_R
	jsr	ldeq_ir2_sx_ss
	.text	0, ""

	jsr	and_ir1_ir1_ir2

	ldx	#STRVAR_R
	jsr	ldne_ir2_sx_ss
	.text	1, "3"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_60
	jsr	jmpne_ir1_ix

LINE_150

	; CLS

	jsr	cls

	; PRINT @230, "ONE MOMENT...\r";

	ldab	#230
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "ONE MOMENT...\r"

LINE_160

	; GOSUB 600

	ldx	#LINE_600
	jsr	gosub_ix

LINE_170

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

LINE_180

	; GOSUB 680

	ldx	#LINE_680
	jsr	gosub_ix

LINE_190

	; GOSUB 720

	ldx	#LINE_720
	jsr	gosub_ix

LINE_200

	; GOSUB 760

	ldx	#LINE_760
	jsr	gosub_ix

LINE_210

	; GOSUB 800

	ldx	#LINE_800
	jsr	gosub_ix

LINE_220

	; GOSUB 840

	ldx	#LINE_840
	jsr	gosub_ix

LINE_230

	; GOSUB 880

	ldx	#LINE_880
	jsr	gosub_ix

LINE_240

	; CLS 0

	ldab	#0
	jsr	clsn_pb

LINE_250

	; PRINT @480, BR$(8);

	ldd	#480
	jsr	prat_pw

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

LINE_260

	; PRINT @491, BR$(8);

	ldd	#491
	jsr	prat_pw

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

LINE_270

	; PRINT @502, BR$(9);

	ldd	#502
	jsr	prat_pw

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

LINE_280

	; FOR DP=0 TO 22 STEP 11

	ldx	#INTVAR_DP
	jsr	forclr_ix

	ldab	#22
	jsr	to_ip_pb

	ldab	#11
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

LINE_290

	; FOR X=4 TO 452 STEP 32

	ldx	#INTVAR_X
	ldab	#4
	jsr	for_ix_pb

	ldd	#452
	jsr	to_ip_pw

	ldab	#32
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

LINE_300

	; PRINT @X+DP, "Å";

	ldx	#INTVAR_X
	ldd	#INTVAR_DP
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\xC5"

LINE_310

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_320

	; NEXT DP

	ldx	#INTVAR_DP
	jsr	nextvar_ix

	jsr	next

LINE_330

	; FOR I=1 TO 7

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_340

	; A$(I,1)=BR$(I)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	ldx	#STRARR_BR
	ldd	#INTVAR_I
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_350

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_360

	; FOR I=1 TO 7

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_370

	; A$(I,2)=BL$

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	ldx	#STRVAR_BL
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

	; A$(I,3)=BL$

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	ldx	#STRVAR_BL
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

LINE_380

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_390

	; GOSUB 920

	ldx	#LINE_920
	jsr	gosub_ix

LINE_400

	; CR$="Î"

	jsr	ld_sr1_ss
	.text	1, "\xCE"

	ldx	#STRVAR_CR
	jsr	ld_sx_sr1

LINE_410

	; CB$="Ï"

	jsr	ld_sr1_ss
	.text	1, "\xCF"

	ldx	#STRVAR_CB
	jsr	ld_sx_sr1

LINE_420

	; P=484

	ldx	#INTVAR_P
	ldd	#484
	jsr	ld_ix_pw

LINE_430

	; PRINT @P, CR$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_CR
	jsr	pr_sx

LINE_440

	; IF R$="2" THEN

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	1, "2"

	ldx	#LINE_450
	jsr	jmpeq_ir1_ix

	; DL=1

	ldx	#INTVAR_DL
	jsr	one_ix

	; GOTO 1400

	ldx	#LINE_1400
	jsr	goto_ix

LINE_450

	; IF R$="3" THEN

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	1, "3"

	ldx	#LINE_460
	jsr	jmpeq_ir1_ix

	; DL=1500

	ldx	#INTVAR_DL
	ldd	#1500
	jsr	ld_ix_pw

	; GOTO 1400

	ldx	#LINE_1400
	jsr	goto_ix

LINE_460

	; R$=INKEY$

	ldx	#STRVAR_R
	jsr	inkey_sx

	; WHEN R$="" GOTO 460

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_460
	jsr	jmpne_ir1_ix

LINE_470

	; WHEN (R$<>" ") AND (R$<>"A") AND (R$<>"S") AND (R$<>"R") GOTO 460

	ldx	#STRVAR_R
	jsr	ldne_ir1_sx_ss
	.text	1, " "

	ldx	#STRVAR_R
	jsr	ldne_ir2_sx_ss
	.text	1, "A"

	jsr	and_ir1_ir1_ir2

	ldx	#STRVAR_R
	jsr	ldne_ir2_sx_ss
	.text	1, "S"

	jsr	and_ir1_ir1_ir2

	ldx	#STRVAR_R
	jsr	ldne_ir2_sx_ss
	.text	1, "R"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_460
	jsr	jmpne_ir1_ix

LINE_480

	; WHEN R$="R" GOTO 10

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	1, "R"

	ldx	#LINE_10
	jsr	jmpne_ir1_ix

LINE_490

	; P1=P

	ldd	#INTVAR_P1
	ldx	#INTVAR_P
	jsr	ld_id_ix

LINE_500

	; IF R$="A" THEN

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_510
	jsr	jmpeq_ir1_ix

	; P-=11

	ldx	#INTVAR_P
	ldab	#11
	jsr	sub_ix_ix_pb

	; IF P<484 THEN

	ldx	#INTVAR_P
	ldd	#484
	jsr	ldlt_ir1_ix_pw

	ldx	#LINE_510
	jsr	jmpeq_ir1_ix

	; P=506

	ldx	#INTVAR_P
	ldd	#506
	jsr	ld_ix_pw

LINE_510

	; IF R$="S" THEN

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_520
	jsr	jmpeq_ir1_ix

	; P+=11

	ldx	#INTVAR_P
	ldab	#11
	jsr	add_ix_ix_pb

	; IF P>506 THEN

	ldd	#506
	ldx	#INTVAR_P
	jsr	ldlt_ir1_pw_ix

	ldx	#LINE_520
	jsr	jmpeq_ir1_ix

	; P=484

	ldx	#INTVAR_P
	ldd	#484
	jsr	ld_ix_pw

LINE_520

	; PRINT @P1, CB$;

	ldx	#INTVAR_P1
	jsr	prat_ix

	ldx	#STRVAR_CB
	jsr	pr_sx

LINE_530

	; PRINT @P, CR$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_CR
	jsr	pr_sx

LINE_540

	; WHEN R$<>" " GOTO 460

	ldx	#STRVAR_R
	jsr	ldne_ir1_sx_ss
	.text	1, " "

	ldx	#LINE_460
	jsr	jmpne_ir1_ix

LINE_550

	; IF R$=" " THEN

	ldx	#STRVAR_R
	jsr	ldeq_ir1_sx_ss
	.text	1, " "

	ldx	#LINE_560
	jsr	jmpeq_ir1_ix

	; CC+=1

	ldx	#INTVAR_CC
	jsr	inc_ix_ix

	; SOUND 150,2

	ldab	#150
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOSUB 1080

	ldx	#LINE_1080
	jsr	gosub_ix

LINE_560

	; GOSUB 1640

	ldx	#LINE_1640
	jsr	gosub_ix

LINE_570

	; IF A=B THEN

	ldx	#INTVAR_A
	ldd	#INTVAR_B
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_580
	jsr	jmpeq_ir1_ix

	; CC=1

	ldx	#INTVAR_CC
	jsr	one_ix

	; GOTO 460

	ldx	#LINE_460
	jsr	goto_ix

LINE_580

	; WHEN CC=0 GOSUB 1180

	ldx	#INTVAR_CC
	jsr	ld_ir1_ix

	ldx	#LINE_1180
	jsr	jsreq_ir1_ix

LINE_590

	; GOTO 460

	ldx	#LINE_460
	jsr	goto_ix

LINE_600

	; FOR X=1 TO 4

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; BR$(7)=BR$(7)+"€"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_610

	; BR$(7)=BR$(7)+"Ÿš"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	2, "\x9F\x9A"

	jsr	ld_sp_sr1

LINE_620

	; FOR X=1 TO 3

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; BR$(7)=BR$(7)+"€"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_630

	; RETURN

	jsr	return

LINE_640

	; FOR X=1 TO 3

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; BR$(6)=BR$(6)+"€"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_650

	; BR$(6)=BR$(6)+"…"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	3, "\x85\x8F\x8F"

	jsr	ld_sp_sr1

LINE_660

	; FOR X=1 TO 3

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; BR$(6)=BR$(6)+"€"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_670

	; RETURN

	jsr	return

LINE_680

	; FOR X=1 TO 3

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; BR$(5)=BR$(5)+"€"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_690

	; FOR X=1 TO 3

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; BR$(5)=BR$(5)+"ÿ"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xFF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_700

	; BR$(5)=BR$(5)+"ú€€"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	3, "\xFA\x80\x80"

	jsr	ld_sp_sr1

LINE_710

	; RETURN

	jsr	return

LINE_720

	; BR$(4)="€€å"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	3, "\x80\x80\xE5"

	jsr	ld_sp_sr1

LINE_730

	; FOR X=1 TO 4

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; BR$(4)=BR$(4)+"ï"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xEF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_740

	; BR$(4)=BR$(4)+"€€"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	2, "\x80\x80"

	jsr	ld_sp_sr1

LINE_750

	; RETURN

	jsr	return

LINE_760

	; BR$(3)="€€"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	2, "\x80\x80"

	jsr	ld_sp_sr1

LINE_770

	; FOR X=1 TO 5

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#5
	jsr	to_ip_pb

	; BR$(3)=BR$(3)+"ß"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xDF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_780

	; BR$(3)=BR$(3)+"Ú€"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	2, "\xDA\x80"

	jsr	ld_sp_sr1

LINE_790

	; RETURN

	jsr	return

LINE_800

	; BR$(2)="€µ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	2, "\x80\xB5"

	jsr	ld_sp_sr1

LINE_810

	; FOR X=1 TO 6

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

	; BR$(2)=BR$(2)+"¿"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xBF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_820

	; BR$(2)=BR$(2)+"€"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

LINE_830

	; RETURN

	jsr	return

LINE_840

	; BR$(1)="€"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

LINE_850

	; FOR X=1 TO 7

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

	; BR$(1)=BR$(1)+"¯"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xAF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_860

	; BR$(1)=BR$(1)+"ª€"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	2, "\xAA\x80"

	jsr	ld_sp_sr1

LINE_870

	; RETURN

	jsr	return

LINE_880

	; FOR X=1 TO 9

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#9
	jsr	to_ip_pb

	; BR$(8)=BR$(8)+"Ï"

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xCF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_890

	; BR$(8)=BR$(8)+"Ê"

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xCA"

	jsr	ld_sp_sr1

LINE_900

	; FOR X=1 TO 9

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#9
	jsr	to_ip_pb

	; BR$(9)=BR$(9)+"Ï"

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrref1_ir1_sx_ir1

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir1_sx_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xCF"

	jsr	ld_sp_sr1

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_910

	; RETURN

	jsr	return

LINE_920

	; I=1

	ldx	#INTVAR_I
	jsr	one_ix

LINE_930

	; FOR X=416 TO 32 STEP -64

	ldx	#INTVAR_X
	ldd	#416
	jsr	for_ix_pw

	ldab	#32
	jsr	to_ip_pb

	ldab	#-64
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_940

	; PRINT @X, A$(I,1);

	ldx	#INTVAR_X
	jsr	prat_ix

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_950

	; I+=1

	ldx	#INTVAR_I
	jsr	inc_ix_ix

LINE_960

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_970

	; I=1

	ldx	#INTVAR_I
	jsr	one_ix

LINE_980

	; FOR X=427 TO 43 STEP -64

	ldx	#INTVAR_X
	ldd	#427
	jsr	for_ix_pw

	ldab	#43
	jsr	to_ip_pb

	ldab	#-64
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_990

	; PRINT @X, A$(I,2);

	ldx	#INTVAR_X
	jsr	prat_ix

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_1000

	; I+=1

	ldx	#INTVAR_I
	jsr	inc_ix_ix

LINE_1010

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_1020

	; I=1

	ldx	#INTVAR_I
	jsr	one_ix

LINE_1030

	; FOR X=438 TO 54 STEP -64

	ldx	#INTVAR_X
	ldd	#438
	jsr	for_ix_pw

	ldab	#54
	jsr	to_ip_pb

	ldab	#-64
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_1040

	; PRINT @X, A$(I,3);

	ldx	#INTVAR_X
	jsr	prat_ix

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_1050

	; I+=1

	ldx	#INTVAR_I
	jsr	inc_ix_ix

LINE_1060

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_1070

	; RETURN

	jsr	return

LINE_1080

	; WHEN CC>1 GOTO 1130

	ldab	#1
	ldx	#INTVAR_CC
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_1130
	jsr	jmpne_ir1_ix

LINE_1090

	; IF P=484 THEN

	ldx	#INTVAR_P
	ldd	#484
	jsr	ldeq_ir1_ix_pw

	ldx	#LINE_1100
	jsr	jmpeq_ir1_ix

	; A=1

	ldx	#INTVAR_A
	jsr	one_ix

LINE_1100

	; IF P=495 THEN

	ldx	#INTVAR_P
	ldd	#495
	jsr	ldeq_ir1_ix_pw

	ldx	#LINE_1110
	jsr	jmpeq_ir1_ix

	; A=2

	ldx	#INTVAR_A
	ldab	#2
	jsr	ld_ix_pb

LINE_1110

	; IF P=506 THEN

	ldx	#INTVAR_P
	ldd	#506
	jsr	ldeq_ir1_ix_pw

	ldx	#LINE_1120
	jsr	jmpeq_ir1_ix

	; A=3

	ldx	#INTVAR_A
	ldab	#3
	jsr	ld_ix_pb

LINE_1120

	; RETURN

	jsr	return

LINE_1130

	; IF P=484 THEN

	ldx	#INTVAR_P
	ldd	#484
	jsr	ldeq_ir1_ix_pw

	ldx	#LINE_1140
	jsr	jmpeq_ir1_ix

	; B=1

	ldx	#INTVAR_B
	jsr	one_ix

LINE_1140

	; IF P=495 THEN

	ldx	#INTVAR_P
	ldd	#495
	jsr	ldeq_ir1_ix_pw

	ldx	#LINE_1150
	jsr	jmpeq_ir1_ix

	; B=2

	ldx	#INTVAR_B
	ldab	#2
	jsr	ld_ix_pb

LINE_1150

	; IF P=506 THEN

	ldx	#INTVAR_P
	ldd	#506
	jsr	ldeq_ir1_ix_pw

	ldx	#LINE_1160
	jsr	jmpeq_ir1_ix

	; B=3

	ldx	#INTVAR_B
	ldab	#3
	jsr	ld_ix_pb

LINE_1160

	; CC=0

	ldx	#INTVAR_CC
	jsr	clr_ix

LINE_1170

	; RETURN

	jsr	return

LINE_1180

	; FOR I=7 TO 1 STEP -1

	ldx	#INTVAR_I
	ldab	#7
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_1190

	; WHEN A$(I,A)<>BL$ GOTO 1220

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_A
	jsr	arrval2_ir1_sx_id

	ldx	#STRVAR_BL
	jsr	ldne_ir1_sr1_sx

	ldx	#LINE_1220
	jsr	jmpne_ir1_ix

LINE_1200

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_1210

	; CC=0

	ldx	#INTVAR_CC
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_1220

	; FOR J=1 TO 7

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1230

	; WHEN A$(J,B)=BL$ GOTO 1250

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_sx_id

	ldx	#STRVAR_BL
	jsr	ldeq_ir1_sr1_sx

	ldx	#LINE_1250
	jsr	jmpne_ir1_ix

LINE_1240

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

LINE_1250

	; FOR K=1 TO 7

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1260

	; WHEN A$(I,A)=BR$(K) GOTO 1280

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_A
	jsr	arrval2_ir1_sx_id

	ldx	#STRARR_BR
	ldd	#INTVAR_K
	jsr	arrval1_ir2_sx_id

	jsr	ldeq_ir1_sr1_sr2

	ldx	#LINE_1280
	jsr	jmpne_ir1_ix

LINE_1270

	; NEXT K

	ldx	#INTVAR_K
	jsr	nextvar_ix

	jsr	next

LINE_1280

	; FOR L=1 TO 7

	ldx	#INTVAR_L
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1290

	; WHEN A$(J-1,B)=BR$(L) GOTO 1320

	ldx	#INTVAR_J
	jsr	dec_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_sx_id

	ldx	#STRARR_BR
	ldd	#INTVAR_L
	jsr	arrval1_ir2_sx_id

	jsr	ldeq_ir1_sr1_sr2

	ldx	#LINE_1320
	jsr	jmpne_ir1_ix

LINE_1300

	; NEXT L

	ldx	#INTVAR_L
	jsr	nextvar_ix

	jsr	next

LINE_1310

	; L=1

	ldx	#INTVAR_L
	jsr	one_ix

LINE_1320

	; IF K<L THEN

	ldx	#INTVAR_K
	ldd	#INTVAR_L
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_1330
	jsr	jmpeq_ir1_ix

	; SOUND 122,10

	ldab	#122
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_1330

	; A$(J,B)=A$(I,A)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_sx_id

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_A
	jsr	arrval2_ir1_sx_id

	jsr	ld_sp_sr1

LINE_1340

	; A$(I,A)=BL$

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_A
	jsr	arrref2_ir1_sx_id

	ldx	#STRVAR_BL
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

LINE_1350

	; CO+=1

	ldx	#INTVAR_CO
	jsr	inc_ix_ix

LINE_1360

	; PRINT @7, STR$(CO);" ";

	ldab	#7
	jsr	prat_pb

	ldx	#INTVAR_CO
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_1370

	; GOSUB 920

	ldx	#LINE_920
	jsr	gosub_ix

LINE_1380

	; WHEN A$(7,3)=BR$(7) GOTO 2000

	ldab	#7
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	ldab	#7
	jsr	ld_ir2_pb

	ldx	#STRARR_BR
	jsr	arrval1_ir2_sx_ir2

	jsr	ldeq_ir1_sr1_sr2

	ldx	#LINE_2000
	jsr	jmpne_ir1_ix

LINE_1390

	; RETURN

	jsr	return

LINE_1400

	; REM COMPUTER'S LOGIC

LINE_1410

	; DN=7

	ldx	#INTVAR_DN
	ldab	#7
	jsr	ld_ix_pb

LINE_1420

	; T1(1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_T1
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; T2(1)=3

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_T2
	jsr	arrref1_ir1_ix_ir1

	ldab	#3
	jsr	ld_ip_pb

	; T3(1)=2

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_T3
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ip_pb

LINE_1430

	; NE=1

	ldx	#INTVAR_NE
	jsr	one_ix

LINE_1440

	; DD(1)=DN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_DD
	jsr	arrref1_ir1_ix_ir1

	ldx	#INTVAR_DN
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_1450

	; RZ=0

	ldx	#INTVAR_RZ
	jsr	clr_ix

LINE_1460

	; GOSUB 1480

	ldx	#LINE_1480
	jsr	gosub_ix

LINE_1470

	; END

	jsr	progend

LINE_1480

	; NE+=1

	ldx	#INTVAR_NE
	jsr	inc_ix_ix

LINE_1490

	; DD(NE)=DD(NE-1)-1

	ldx	#INTARR_DD
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_DD
	jsr	arrval1_ir1_ix_ir1

	jsr	dec_ir1_ir1

	jsr	ld_ip_ir1

LINE_1500

	; T1(NE)=T1(NE-1)

	ldx	#INTARR_T1
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T1
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_1510

	; T2(NE)=T3(NE-1)

	ldx	#INTARR_T2
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T3
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_1520

	; T3(NE)=T2(NE-1)

	ldx	#INTARR_T3
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T2
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_1530

	; IF DD(NE)=1 THEN

	ldx	#INTARR_DD
	ldd	#INTVAR_NE
	jsr	arrval1_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1531
	jsr	jmpeq_ir1_ix

	; RZ+=1

	ldx	#INTVAR_RZ
	jsr	inc_ix_ix

	; A=T1(NE)

	ldx	#INTARR_T1
	ldd	#INTVAR_NE
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=T2(NE)

	ldx	#INTARR_T2
	ldd	#INTVAR_NE
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; GOSUB 1610

	ldx	#LINE_1610
	jsr	gosub_ix

	; GOTO 1540

	ldx	#LINE_1540
	jsr	goto_ix

LINE_1531

	; GOSUB 1480

	ldx	#LINE_1480
	jsr	gosub_ix

LINE_1540

	; RZ+=1

	ldx	#INTVAR_RZ
	jsr	inc_ix_ix

	; A=T1(NE-1)

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T1
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=T2(NE-1)

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T2
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; GOSUB 1610

	ldx	#LINE_1610
	jsr	gosub_ix

LINE_1550

	; T1(NE)=T3(NE-1)

	ldx	#INTARR_T1
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T3
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_1560

	; T2(NE)=T2(NE-1)

	ldx	#INTARR_T2
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T2
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_1570

	; T3(NE)=T1(NE-1)

	ldx	#INTARR_T3
	ldd	#INTVAR_NE
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_NE
	jsr	dec_ir1_ix

	ldx	#INTARR_T1
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_1580

	; IF DD(NE)=1 THEN

	ldx	#INTARR_DD
	ldd	#INTVAR_NE
	jsr	arrval1_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1581
	jsr	jmpeq_ir1_ix

	; RZ+=1

	ldx	#INTVAR_RZ
	jsr	inc_ix_ix

	; A=T1(NE)

	ldx	#INTARR_T1
	ldd	#INTVAR_NE
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=T2(NE)

	ldx	#INTARR_T2
	ldd	#INTVAR_NE
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; GOSUB 1610

	ldx	#LINE_1610
	jsr	gosub_ix

	; GOTO 1590

	ldx	#LINE_1590
	jsr	goto_ix

LINE_1581

	; GOSUB 1480

	ldx	#LINE_1480
	jsr	gosub_ix

LINE_1590

	; NE-=1

	ldx	#INTVAR_NE
	jsr	dec_ix_ix

LINE_1600

	; RETURN

	jsr	return

LINE_1610

	; FOR X=1 TO DL

	ldx	#INTVAR_X
	jsr	forone_ix

	ldx	#INTVAR_DL
	jsr	to_ip_ix

	; NEXT X

	ldx	#INTVAR_X
	jsr	nextvar_ix

	jsr	next

LINE_1620

	; GOSUB 1180

	ldx	#LINE_1180
	jsr	gosub_ix

LINE_1630

	; RETURN

	jsr	return

LINE_1640

	; FOR I=7 TO 1 STEP -1

	ldx	#INTVAR_I
	ldab	#7
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_1650

	; IF A$(I,A)<>BL$ THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_A
	jsr	arrval2_ir1_sx_id

	ldx	#STRVAR_BL
	jsr	ldne_ir1_sr1_sx

	ldx	#LINE_1660
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_1660

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_1670

	; CC=0

	ldx	#INTVAR_CC
	jsr	clr_ix

	; GOTO 460

	ldx	#LINE_460
	jsr	goto_ix

LINE_2000

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; IF (M$="\r") OR (M$="Y") THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "\r"

	ldx	#STRVAR_M
	jsr	ldeq_ir2_sx_ss
	.text	1, "Y"

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_2010
	jsr	jmpeq_ir1_ix

	; RUN

	jsr	clear

	ldx	#LINE_10
	jsr	goto_ix

LINE_2010

	; IF M$="N" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_2020
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_2020

	; GOTO 2000

	ldx	#LINE_2000
	jsr	goto_ix

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

	.module	mdref2
; validate offset from 2D descriptor X and argv.
; if empty desc, then alloc D bytes in array memory
; and 11 elements in each dimension (121 total elements).
; return word offset in D and byte offset in tmp1
ref2
	std	tmp1
	ldd	,x
	bne	_preexist
	ldd	strbuf
	std	,x
	ldd	#11
	std	2,x
	std	4,x
	ldd	tmp1
	pshx
	jsr	alloc
	pulx
_preexist
	ldd	2+argv
	std	tmp1
	subd	4,x
	bhs	_err
	ldd	2,x
	std	tmp2
	subd	0+argv
	bls	_err
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

	.module	mdstreqx
; equality comparison with string release
; ENTRY:  X holds descriptor of LHS
;         tmp1+1 and tmp2 are RHS
; EXIT:  Z CCR flag set
streqx
	ldab	0,x
	cmpb	tmp1+1
	bne	_frts
	tstb
	beq	_frts
	ldx	1,x
	jsr	strrel
	pshx
	ldx	tmp2
	jsr	strrel
	pulx
	sts	tmp3
	txs
	ldx	tmp2
_nxtchr
	pula
	cmpa	,x
	bne	_ne
	inx
	decb
	bne	_nxtchr
	lds	tmp3
	clra
	rts
_ne
	lds	tmp3
	rts
_frts
	tpa
	ldx	1,x
	jsr	strrel
	ldx	tmp2
	jsr	strrel
	tap
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

add_ir1_ix_id			; numCalls = 1
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

add_ix_ix_pb			; numCalls = 1
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 5
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

arrref1_ir1_ix_id			; numCalls = 7
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 4
	.module	modarrref1_ir1_ix_ir1
	ldd	r1+1
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx_ir1			; numCalls = 24
	.module	modarrref1_ir1_sx_ir1
	ldd	r1+1
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_sx_id			; numCalls = 2
	.module	modarrref2_ir1_sx_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrref2_ir1_sx_ir2			; numCalls = 3
	.module	modarrref2_ir1_sx_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 6
	.module	modarrval1_ir1_ix_id
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

arrval1_ir1_ix_ir1			; numCalls = 9
	.module	modarrval1_ir1_ix_ir1
	ldd	r1+1
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

arrval1_ir1_sx_id			; numCalls = 1
	.module	modarrval1_ir1_sx_id
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

arrval1_ir1_sx_ir1			; numCalls = 23
	.module	modarrval1_ir1_sx_ir1
	ldd	r1+1
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

arrval1_ir2_sx_id			; numCalls = 2
	.module	modarrval1_ir2_sx_id
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

arrval1_ir2_sx_ir2			; numCalls = 1
	.module	modarrval1_ir2_sx_ir2
	ldd	r2+1
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

arrval2_ir1_sx_id			; numCalls = 6
	.module	modarrval2_ir1_sx_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval2_ir1_sx_ir2			; numCalls = 4
	.module	modarrval2_ir1_sx_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

clear			; numCalls = 3
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

clr_ix			; numCalls = 4
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 2
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

dec_ir1_ir1			; numCalls = 1
	.module	moddec_ir1_ir1
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 10
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
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

for_ix_pb			; numCalls = 3
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

for_ix_pw			; numCalls = 3
	.module	modfor_ix_pw
	stx	letptr
	clr	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 1
	.module	modforclr_ix
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 20
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 19
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 9
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_ix_ix			; numCalls = 9
	.module	modinc_ix_ix
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 3
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

jmpeq_ir1_ix			; numCalls = 20
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

jmpne_ir1_ix			; numCalls = 12
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

jsreq_ir1_ix			; numCalls = 1
	.module	modjsreq_ir1_ix
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	ldab	#3
	pshb
	jmp	,x
_rts
	rts

ld_id_ix			; numCalls = 1
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

ld_ip_ir1			; numCalls = 8
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 2
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 15
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_nb			; numCalls = 5
	.module	modld_ir1_nb
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ir1_pb			; numCalls = 56
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 10
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 6
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 5
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 4
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 29
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 6
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 3
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 5
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_pb			; numCalls = 2
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ix_id			; numCalls = 1
	.module	modldeq_ir1_ix_id
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

ldeq_ir1_ix_pw			; numCalls = 6
	.module	modldeq_ir1_ix_pw
	subd	1,x
	bne	_done
	ldab	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_sr2			; numCalls = 3
	.module	modldeq_ir1_sr1_sr2
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	ldx	#r2
	jsr	streqx
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_sx			; numCalls = 1
	.module	modldeq_ir1_sr1_sx
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqx
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 10
	.module	modldeq_ir1_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir2_sx_ss			; numCalls = 2
	.module	modldeq_ir2_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldlt_ir1_ix_id			; numCalls = 1
	.module	modldlt_ir1_ix_id
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

ldlt_ir1_ix_pw			; numCalls = 1
	.module	modldlt_ir1_ix_pw
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ix			; numCalls = 1
	.module	modldlt_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pw_ix			; numCalls = 1
	.module	modldlt_ir1_pw_ix
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldne_ir1_sr1_sx			; numCalls = 2
	.module	modldne_ir1_sr1_sx
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqx
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_sx_ss			; numCalls = 3
	.module	modldne_ir1_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir2_sx_ss			; numCalls = 4
	.module	modldne_ir2_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
	jsr	getne
	std	r2+1
	stab	r2
	rts

next			; numCalls = 27
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

nextvar_ix			; numCalls = 26
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

one_ip			; numCalls = 1
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 9
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

or_ir1_ir1_ir2			; numCalls = 1
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
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

pr_ss			; numCalls = 10
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 3
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 1
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 6
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 7
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 5
	.module	modprat_pw
	jmp	prat

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
D0_ERROR	.equ	20
LS_ERROR	.equ	28
IO_ERROR	.equ	34
FM_ERROR	.equ	36
error
	jmp	R_ERROR

return			; numCalls = 17
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

sound_ir1_ir2			; numCalls = 2
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 7
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

str_sr1_ix			; numCalls = 1
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

strcat_sr1_sr1_ss			; numCalls = 23
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

strinit_sr1_sr1			; numCalls = 20
	.module	modstrinit_sr1_sr1
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

strinit_sr1_sx			; numCalls = 3
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
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

to_ip_pb			; numCalls = 25
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

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_CC	.block	3
INTVAR_CO	.block	3
INTVAR_DL	.block	3
INTVAR_DN	.block	3
INTVAR_DP	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_NE	.block	3
INTVAR_P	.block	3
INTVAR_P1	.block	3
INTVAR_RZ	.block	3
INTVAR_X	.block	3
; String Variables
STRVAR_BL	.block	3
STRVAR_CB	.block	3
STRVAR_CR	.block	3
STRVAR_M	.block	3
STRVAR_R	.block	3
; Numeric Arrays
INTARR_DD	.block	4	; dims=1
INTARR_T1	.block	4	; dims=1
INTARR_T2	.block	4	; dims=1
INTARR_T3	.block	4	; dims=1
; String Arrays
STRARR_A	.block	6	; dims=2
STRARR_BR	.block	4	; dims=1

; block ended by symbol
bes
	.end

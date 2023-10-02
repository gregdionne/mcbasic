; Assembly for klondike.bas
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
r4	.block	5
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_0

	; CLEAR 4000

	jsr	clear

	; CLS

	jsr	cls

	; PRINT "KLONDIKE SOLITAIRE\r";

	jsr	pr_ss
	.text	19, "KLONDIKE SOLITAIRE\r"

	; GOTO 15

	ldx	#LINE_15
	jsr	goto_ix

LINE_1

	; L(CL,RL)=((RL+3)*T)+R

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	ldd	#INTVAR_RL
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_RL
	ldab	#3
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_T
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_R
	jsr	add_ir1_ir1_ix

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_2

	; L(CL,RL)=(T*11)+R

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	ldd	#INTVAR_RL
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#11
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_R
	jsr	add_ir1_ir1_ix

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_3

	; ON SU GOTO 4,5,6,7,8

	ldx	#INTVAR_SU
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_4, LINE_5, LINE_6, LINE_7, LINE_8

	; RETURN

	jsr	return

LINE_4

	; PRINT @RL, "µ¿¿";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\xB5\xBF\xBF"

	; PRINT @RL+T, "€½¸";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\x80\xBD\xB8"

	; RETURN

	jsr	return

LINE_5

	; PRINT @RL, "±¿»";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\xB1\xBF\xBB"

	; PRINT @RL+T, "€½¸";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\x80\xBD\xB8"

	; RETURN

	jsr	return

LINE_6

	; PRINT @RL, "¡¯«";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\xA1\xAF\xAB"

	; PRINT @RL+T, "¤­¬";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\xA4\xAD\xAC"

	; RETURN

	jsr	return

LINE_7

	; PRINT @RL, "¡¯«";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\xA1\xAF\xAB"

	; PRINT @RL+T, "¤­¬";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\xA4\xAD\xAC"

	; RETURN

	jsr	return

LINE_8

	; PRINT @RL, "ÅÏÊ";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\xC5\xCF\xCA"

	; PRINT @RL+T, "ÄÌÈ";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\xC4\xCC\xC8"

	; RETURN

	jsr	return

LINE_15

	; DIM DK$(52),SU$(4),CA$(13),CL$(7,19,2),ND$(52)

	ldab	#52
	jsr	ld_ir1_pb

	ldx	#STRARR_DK
	jsr	arrdim1_ir1_sx

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_SU
	jsr	arrdim1_ir1_sx

	ldab	#13
	jsr	ld_ir1_pb

	ldx	#STRARR_CA
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldab	#19
	jsr	ld_ir2_pb

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrdim3_ir1_sx

	ldab	#52
	jsr	ld_ir1_pb

	ldx	#STRARR_ND
	jsr	arrdim1_ir1_sx

LINE_20

	; DIM AC$(4),L(7,19),PL,RL,EF,CL,MC,TM,AC,T1,NC,FW,FP,SU,BS,TW,FE,T,C$,IN$,A$

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_AC
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldab	#19
	jsr	ld_ir2_pb

	ldx	#INTARR_L
	jsr	arrdim2_ir1_ix

	; GOSUB 8000

	ldx	#LINE_8000
	jsr	gosub_ix

LINE_30

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "DO YOU NEED INSTRUCTIONS? ";

	jsr	pr_ss
	.text	26, "DO YOU NEED INSTRUCTIONS? "

LINE_35

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; TM=INT(RND(0))

	ldab	#0
	jsr	rnd_fr1_pb

	ldx	#INTVAR_TM
	jsr	ld_ix_ir1

	; WHEN A$="" GOTO 35

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_35
	jsr	jmpne_ir1_ix

LINE_36

	; WHEN (A$<>"Y") AND (A$<>"N") GOTO 35

	ldx	#STRVAR_A
	jsr	ldne_ir1_sx_ss
	.text	1, "Y"

	ldx	#STRVAR_A
	jsr	ldne_ir2_sx_ss
	.text	1, "N"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_35
	jsr	jmpne_ir1_ix

LINE_37

	; WHEN A$="Y" GOSUB 5000

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_5000
	jsr	jsrne_ir1_ix

LINE_38

	; CLS

	jsr	cls

LINE_40

	; PRINT "INITIALIZING... \r";

	jsr	pr_ss
	.text	17, "INITIALIZING... \r"

LINE_45

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_50

	; PRINT "SHUFFLING... \r";

	jsr	pr_ss
	.text	14, "SHUFFLING... \r"

LINE_60

	; GOSUB 1200

	ldx	#LINE_1200
	jsr	gosub_ix

LINE_65

	; PRINT "DEALING... \r";

	jsr	pr_ss
	.text	12, "DEALING... \r"

LINE_70

	; GOSUB 1500

	ldx	#LINE_1500
	jsr	gosub_ix

LINE_80

	; GOSUB 1700

	ldx	#LINE_1700
	jsr	gosub_ix

LINE_90

	; T1=3

	ldx	#INTVAR_T1
	ldab	#3
	jsr	ld_ix_pb

LINE_91

	; PRINT @16, "C=MORE CARDS";

	ldab	#16
	jsr	prat_pb

	jsr	pr_ss
	.text	12, "C=MORE CARDS"

LINE_92

	; PRINT @T+16, "D=MOVE FROM DECK";

	ldx	#INTVAR_T
	ldab	#16
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "D=MOVE FROM DECK"

LINE_93

	; PRINT @SHIFT(T,1)+16, "COLUMN # TO MOVE";

	ldx	#INTVAR_T
	jsr	dbl_ir1_ix

	ldab	#16
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "COLUMN # TO MOVE"

LINE_94

	; PRINT @(T*6)+28, "WINS";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#6
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	4, "WINS"

	; PRINT @(T*7)+28, STR$(WI);" ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#7
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_WI
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_100

	; RL=444

	ldx	#INTVAR_RL
	ldd	#444
	jsr	ld_ix_pw

	; PRINT @RL, "";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	0, ""

	; IF ND<1 THEN

	ldx	#INTVAR_ND
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_120
	jsr	jmpeq_ir1_ix

	; PRINT "NONE";

	jsr	pr_ss
	.text	4, "NONE"

	; PRINT @RL+T, "   ";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "   "

	; PRINT @RL+64, "   ";

	ldx	#INTVAR_RL
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "   "

	; GOTO 140

	ldx	#LINE_140
	jsr	goto_ix

LINE_120

	; C$=ND$(T1)

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir1_sx_id

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; IN$=C$

	ldd	#STRVAR_IN
	ldx	#STRVAR_C
	jsr	ld_sd_sx

	; GOSUB 3070

	ldx	#LINE_3070
	jsr	gosub_ix

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; RL+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_RL
	jsr	add_ix_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_140

	; PRINT @(T*9)+28, "CARD";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#9
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	4, "CARD"

	; PRINT @(T*10)+28, STR$(T1);" ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#10
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_T1
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; PRINT @(T*11)+29, "OF";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#11
	jsr	mul_ir1_ir1_pb

	ldab	#29
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	2, "OF"

	; PRINT @(T*12)+28, STR$(ND);" ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#12
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_ND
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_150

	; PRINT @T*15, "                            ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#15
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	28, "                            "

LINE_152

	; WHEN NC>51 GOTO 900

	ldab	#51
	ldx	#INTVAR_NC
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_900
	jsr	jmpne_ir1_ix

LINE_155

	; PRINT @T*14, "WHAT DO YOU WANT TO DO?  \x08";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#14
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	26, "WHAT DO YOU WANT TO DO?  \x08"

LINE_160

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; WHEN A$="" GOTO 160

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_160
	jsr	jmpne_ir1_ix

LINE_170

	; IF A$="C" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "C"

	ldx	#LINE_180
	jsr	jmpeq_ir1_ix

	; PRINT A$;

	ldx	#STRVAR_A
	jsr	pr_sx

	; GOSUB 300

	ldx	#LINE_300
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_180

	; IF A$="D" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "D"

	ldx	#LINE_190
	jsr	jmpeq_ir1_ix

	; PRINT A$;

	ldx	#STRVAR_A
	jsr	pr_sx

	; GOSUB 350

	ldx	#LINE_350
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_190

	; IF (A$>="1") AND (A$<="7") THEN

	ldx	#STRVAR_A
	jsr	ldge_ir1_sx_ss
	.text	1, "1"

	ldx	#STRVAR_A
	jsr	ldge_ir2_ss_sx
	.text	1, "7"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_200
	jsr	jmpeq_ir1_ix

	; PRINT A$;

	ldx	#STRVAR_A
	jsr	pr_sx

	; GOSUB 600

	ldx	#LINE_600
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_200

	; WHEN A$="Q" GOTO 900

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_900
	jsr	jmpne_ir1_ix

LINE_210

	; GOTO 160

	ldx	#LINE_160
	jsr	goto_ix

LINE_300

	; REM GET MORE CARDS FROM DECK

LINE_310

	; IF T1=ND THEN

	ldx	#INTVAR_T1
	ldd	#INTVAR_ND
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_311
	jsr	jmpeq_ir1_ix

	; T1=3

	ldx	#INTVAR_T1
	ldab	#3
	jsr	ld_ix_pb

	; GOTO 320

	ldx	#LINE_320
	jsr	goto_ix

LINE_311

	; T1+=3

	ldx	#INTVAR_T1
	ldab	#3
	jsr	add_ix_ix_pb

LINE_320

	; IF T1>ND THEN

	ldx	#INTVAR_ND
	ldd	#INTVAR_T1
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_330
	jsr	jmpeq_ir1_ix

	; T1=ND

	ldd	#INTVAR_T1
	ldx	#INTVAR_ND
	jsr	ld_id_ix

LINE_330

	; RETURN

	jsr	return

LINE_350

	; REM MOVE FROM DECK TO A COLUMN

LINE_360

	; PRINT @T*15, "FROM DECK TO? ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#15
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	14, "FROM DECK TO? "

LINE_380

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; WHEN (A$="A") OR ((A$>="1") AND (A$<="7")) GOTO 390

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#STRVAR_A
	jsr	ldge_ir2_sx_ss
	.text	1, "1"

	ldx	#STRVAR_A
	jsr	ldge_ir3_ss_sx
	.text	1, "7"

	jsr	and_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_390
	jsr	jmpne_ir1_ix

LINE_381

	; GOTO 380

	ldx	#LINE_380
	jsr	goto_ix

LINE_390

	; IF A$="A" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_391
	jsr	jmpeq_ir1_ix

	; PRINT "ACES";

	jsr	pr_ss
	.text	4, "ACES"

	; GOTO 395

	ldx	#LINE_395
	jsr	goto_ix

LINE_391

	; PRINT A$;

	ldx	#STRVAR_A
	jsr	pr_sx

LINE_395

	; WHEN A$="A" GOTO 540

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_540
	jsr	jmpne_ir1_ix

LINE_400

	; TW=INT(VAL(A$))

	ldx	#STRVAR_A
	jsr	val_fr1_sx

	ldx	#INTVAR_TW
	jsr	ld_ix_ir1

LINE_410

	; FOR PL=19 TO 1 STEP -1

	ldx	#INTVAR_PL
	ldab	#19
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_420

	; IF CL$(TW,PL,2)<>"   " THEN

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ldne_ir1_sr1_ss
	.text	3, "   "

	ldx	#LINE_430
	jsr	jmpeq_ir1_ix

	; TM=PL

	ldd	#INTVAR_TM
	ldx	#INTVAR_PL
	jsr	ld_id_ix

	; PL=1

	ldx	#INTVAR_PL
	jsr	one_ix

	; NEXT

	jsr	next

	; PL=TM

	ldd	#INTVAR_PL
	ldx	#INTVAR_TM
	jsr	ld_id_ix

	; GOTO 460

	ldx	#LINE_460
	jsr	goto_ix

LINE_430

	; NEXT

	jsr	next

LINE_432

	; IF (CL$(TW,1,2)="   ") AND (LEFT$(ND$(T1),1)="K") THEN

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ldeq_ir1_sr1_ss
	.text	3, "   "

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir2_sx_id

	ldab	#1
	jsr	left_sr2_sr2_pb

	jsr	ldeq_ir2_sr2_ss
	.text	1, "K"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_440
	jsr	jmpeq_ir1_ix

	; PL=0

	ldx	#INTVAR_PL
	jsr	clr_ix

	; GOTO 500

	ldx	#LINE_500
	jsr	goto_ix

LINE_440

	; GOSUB 990

	ldx	#LINE_990
	jsr	gosub_ix

LINE_450

	; RETURN

	jsr	return

LINE_460

	; BE$=CL$(TW,PL,2)

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_BE
	jsr	ld_sx_sr1

LINE_470

	; AB$=ND$(T1)

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir1_sx_id

	ldx	#STRVAR_AB
	jsr	ld_sx_sr1

LINE_480

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; REM CHECK IF MATCH

LINE_490

	; WHEN OK$="NO" GOTO 440

	ldx	#STRVAR_OK
	jsr	ldeq_ir1_sx_ss
	.text	2, "NO"

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_500

	; CL$(TW,PL+1,1)=ND$(T1)

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	inc_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_510

	; CL$(TW,PL+1,2)=ND$(T1)

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	inc_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_520

	; CL=TW

	ldd	#INTVAR_CL
	ldx	#INTVAR_TW
	jsr	ld_id_ix

	; GOSUB 3100

	ldx	#LINE_3100
	jsr	gosub_ix

LINE_525

	; GOSUB 2200

	ldx	#LINE_2200
	jsr	gosub_ix

	; REM REPACK DECK

LINE_530

	; RETURN

	jsr	return

LINE_540

	; REM PLAY DECK TO ACES

LINE_550

	; AB$=ND$(T1)

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir1_sx_id

	ldx	#STRVAR_AB
	jsr	ld_sx_sr1

LINE_560

	; GOSUB 2300

	ldx	#LINE_2300
	jsr	gosub_ix

	; REM PLAY TO ACES

LINE_570

	; WHEN OK$="NO" GOTO 440

	ldx	#STRVAR_OK
	jsr	ldeq_ir1_sx_ss
	.text	2, "NO"

	ldx	#LINE_440
	jsr	jmpne_ir1_ix

LINE_580

	; GOTO 525

	ldx	#LINE_525
	jsr	goto_ix

LINE_600

	; REM MOVE FROM ONE COLUMN TO ANOTHER

LINE_610

	; FW=INT(VAL(A$))

	ldx	#STRVAR_A
	jsr	val_fr1_sx

	ldx	#INTVAR_FW
	jsr	ld_ix_ir1

LINE_620

	; FOR FE=1 TO 19

	ldx	#INTVAR_FE
	jsr	forone_ix

	ldab	#19
	jsr	to_ip_pb

LINE_630

	; IF CL$(FW,FE,2)<>DN$ THEN

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_DN
	jsr	ldne_ir1_sr1_sx

	ldx	#LINE_640
	jsr	jmpeq_ir1_ix

	; TM=FE

	ldd	#INTVAR_TM
	ldx	#INTVAR_FE
	jsr	ld_id_ix

	; FE=19

	ldx	#INTVAR_FE
	ldab	#19
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; FE=TM

	ldd	#INTVAR_FE
	ldx	#INTVAR_TM
	jsr	ld_id_ix

	; GOTO 660

	ldx	#LINE_660
	jsr	goto_ix

LINE_640

	; NEXT

	jsr	next

LINE_650

	; GOTO 990

	ldx	#LINE_990
	jsr	goto_ix

LINE_660

	; PRINT @T*15, "FROM COLUMN";STR$(FW);" TO? ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#15
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	11, "FROM COLUMN"

	ldx	#INTVAR_FW
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	5, " TO? "

LINE_680

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; WHEN (A$="A") OR ((A$>="1") AND (A$<="7")) GOTO 690

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#STRVAR_A
	jsr	ldge_ir2_sx_ss
	.text	1, "1"

	ldx	#STRVAR_A
	jsr	ldge_ir3_ss_sx
	.text	1, "7"

	jsr	and_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_690
	jsr	jmpne_ir1_ix

LINE_681

	; GOTO 680

	ldx	#LINE_680
	jsr	goto_ix

LINE_690

	; IF A$="A" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_691
	jsr	jmpeq_ir1_ix

	; PRINT "ACES";

	jsr	pr_ss
	.text	4, "ACES"

	; GOTO 695

	ldx	#LINE_695
	jsr	goto_ix

LINE_691

	; PRINT A$;

	ldx	#STRVAR_A
	jsr	pr_sx

LINE_695

	; WHEN A$="A" GOTO 830

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_830
	jsr	jmpne_ir1_ix

LINE_700

	; TW=INT(VAL(A$))

	ldx	#STRVAR_A
	jsr	val_fr1_sx

	ldx	#INTVAR_TW
	jsr	ld_ix_ir1

LINE_710

	; FOR T0=19 TO 1 STEP -1

	ldx	#INTVAR_T0
	ldab	#19
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_720

	; IF CL$(TW,T0,2)<>"   " THEN

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_T0
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ldne_ir1_sr1_ss
	.text	3, "   "

	ldx	#LINE_730
	jsr	jmpeq_ir1_ix

	; TM=T0

	ldd	#INTVAR_TM
	ldx	#INTVAR_T0
	jsr	ld_id_ix

	; T0=1

	ldx	#INTVAR_T0
	jsr	one_ix

	; NEXT

	jsr	next

	; T0=TM

	ldd	#INTVAR_T0
	ldx	#INTVAR_TM
	jsr	ld_id_ix

	; GOTO 770

	ldx	#LINE_770
	jsr	goto_ix

LINE_730

	; NEXT

	jsr	next

LINE_732

	; IF (CL$(TW,1,2)="   ") AND (LEFT$(CL$(FW,FE,2),1)="K") THEN

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ldeq_ir1_sr1_ss
	.text	3, "   "

	ldx	#INTVAR_FW
	jsr	ld_ir2_ix

	ldx	#INTVAR_FE
	jsr	ld_ir3_ix

	ldab	#2
	jsr	ld_ir4_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir2_sx_ir4

	ldab	#1
	jsr	left_sr2_sr2_pb

	jsr	ldeq_ir2_sr2_ss
	.text	1, "K"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_740
	jsr	jmpeq_ir1_ix

	; T0=0

	ldx	#INTVAR_T0
	jsr	clr_ix

	; GOTO 800

	ldx	#LINE_800
	jsr	goto_ix

LINE_740

	; GOSUB 990

	ldx	#LINE_990
	jsr	gosub_ix

LINE_750

	; RETURN

	jsr	return

LINE_770

	; AB$=CL$(FW,FE,2)

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_AB
	jsr	ld_sx_sr1

LINE_775

	; BE$=CL$(TW,T0,2)

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_T0
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_BE
	jsr	ld_sx_sr1

LINE_780

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; REM CHECK IF MATCH

LINE_790

	; WHEN OK$="NO" GOTO 740

	ldx	#STRVAR_OK
	jsr	ldeq_ir1_sx_ss
	.text	2, "NO"

	ldx	#LINE_740
	jsr	jmpne_ir1_ix

LINE_800

	; GOSUB 3200

	ldx	#LINE_3200
	jsr	gosub_ix

	; REM MOVE THE STACK

LINE_810

	; CL=FW

	ldd	#INTVAR_CL
	ldx	#INTVAR_FW
	jsr	ld_id_ix

	; GOSUB 3100

	ldx	#LINE_3100
	jsr	gosub_ix

	; REM REDRAW A COLUMN

LINE_815

	; CL=TW

	ldd	#INTVAR_CL
	ldx	#INTVAR_TW
	jsr	ld_id_ix

	; GOSUB 3100

	ldx	#LINE_3100
	jsr	gosub_ix

LINE_820

	; RETURN

	jsr	return

LINE_830

	; REM PLAY FROM A COLUMN TO ACES

LINE_832

	; FOR FE=19 TO 1 STEP -1

	ldx	#INTVAR_FE
	ldab	#19
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

LINE_834

	; IF CL$(FW,FE,2)<>"   " THEN

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ldne_ir1_sr1_ss
	.text	3, "   "

	ldx	#LINE_836
	jsr	jmpeq_ir1_ix

	; TM=FE

	ldd	#INTVAR_TM
	ldx	#INTVAR_FE
	jsr	ld_id_ix

	; FE=1

	ldx	#INTVAR_FE
	jsr	one_ix

	; NEXT

	jsr	next

	; FE=TM

	ldd	#INTVAR_FE
	ldx	#INTVAR_TM
	jsr	ld_id_ix

	; GOTO 840

	ldx	#LINE_840
	jsr	goto_ix

LINE_836

	; NEXT

	jsr	next

LINE_838

	; GOTO 990

	ldx	#LINE_990
	jsr	goto_ix

LINE_840

	; AB$=CL$(FW,FE,2)

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_AB
	jsr	ld_sx_sr1

LINE_850

	; GOSUB 2300

	ldx	#LINE_2300
	jsr	gosub_ix

	; REM PLAY TO ACES

LINE_851

	; WHEN OK$="NO" GOTO 740

	ldx	#STRVAR_OK
	jsr	ldeq_ir1_sx_ss
	.text	2, "NO"

	ldx	#LINE_740
	jsr	jmpne_ir1_ix

LINE_853

	; REM CL$(FW,FE,1)="   "

LINE_854

	; CL$(FW,FE,2)="   "

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

LINE_855

	; IF FE>1 THEN

	ldab	#1
	ldx	#INTVAR_FE
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_856
	jsr	jmpeq_ir1_ix

	; CL$(FW,FE-1,2)=CL$(FW,FE-1,1)

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	dec_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	dec_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ld_sp_sr1

LINE_856

	; CL=FW

	ldd	#INTVAR_CL
	ldx	#INTVAR_FW
	jsr	ld_id_ix

	; GOSUB 3100

	ldx	#LINE_3100
	jsr	gosub_ix

	; REM REDRAW A COLUMN

LINE_860

	; RETURN

	jsr	return

LINE_900

	; REM EXIT GAME

LINE_910

	; GOSUB 1900

	ldx	#LINE_1900
	jsr	gosub_ix

LINE_925

	; FOR I=1 TO 20

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#20
	jsr	to_ip_pb

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; NEXT

	jsr	next

LINE_930

	; GOSUB 3400

	ldx	#LINE_3400
	jsr	gosub_ix

	; PRINT "PLAY AGAIN?";

	jsr	pr_ss
	.text	11, "PLAY AGAIN?"

LINE_940

	; FOR T1=1 TO ND

	ldx	#INTVAR_T1
	jsr	forone_ix

	ldx	#INTVAR_ND
	jsr	to_ip_ix

	; GOSUB 1800

	ldx	#LINE_1800
	jsr	gosub_ix

	; FOR ZZ=1 TO 200

	ldx	#INTVAR_ZZ
	jsr	forone_ix

	ldab	#200
	jsr	to_ip_pb

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; IF A$="N" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_950
	jsr	jmpeq_ir1_ix

	; ZZ=200

	ldx	#INTVAR_ZZ
	ldab	#200
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; T1=ND

	ldd	#INTVAR_T1
	ldx	#INTVAR_ND
	jsr	ld_id_ix

	; NEXT

	jsr	next

	; GOTO 970

	ldx	#LINE_970
	jsr	goto_ix

LINE_950

	; IF A$="Y" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_965
	jsr	jmpeq_ir1_ix

	; ZZ=200

	ldx	#INTVAR_ZZ
	ldab	#200
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; T1=ND

	ldd	#INTVAR_T1
	ldx	#INTVAR_ND
	jsr	ld_id_ix

	; NEXT

	jsr	next

	; CLS

	jsr	cls

	; PRINT "RE-";

	jsr	pr_ss
	.text	3, "RE-"

	; GOTO 40

	ldx	#LINE_40
	jsr	goto_ix

LINE_965

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 940

	ldx	#LINE_940
	jsr	goto_ix

LINE_970

	; CLS

	jsr	cls

	; PRINT "BYE\r";

	jsr	pr_ss
	.text	4, "BYE\r"

	; END

	jsr	progend

LINE_990

	; REM BAD PLAY

LINE_992

	; PRINT @T*14, "CAN'T DO THAT!           ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#14
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	25, "CAN'T DO THAT!           "

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_994

	; PRINT @T*15, "PRESS ANY KEY TO CONTINUE";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#15
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	25, "PRESS ANY KEY TO CONTINUE"

LINE_996

	; WHEN INKEY$="" GOTO 996

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_996
	jsr	jmpne_ir1_ix

LINE_997

	; PRINT @T*14, "                         ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#14
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	25, "                         "

LINE_998

	; PRINT @T*15, "                         ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#15
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	25, "                         "

LINE_999

	; RETURN

	jsr	return

LINE_1000

	; REM INIT

LINE_1005

	; DN$="ÁÃÂ"

	jsr	ld_sr1_ss
	.text	3, "\xC1\xC3\xC2"

	ldx	#STRVAR_DN
	jsr	ld_sx_sr1

LINE_1030

	; SU$(1)="²²"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_SU
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	2, "\xB2\xB2"

	jsr	ld_sp_sr1

	; SU$(2)="±€"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_SU
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	2, "\xB1\x80"

	jsr	ld_sp_sr1

LINE_1031

	; SU$(3)="£¢"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_SU
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	2, "\xA3\xA2"

	jsr	ld_sp_sr1

	; SU$(4)="¡€"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_SU
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	2, "\xA1\x80"

	jsr	ld_sp_sr1

LINE_1035

	; FOR I=1 TO 4

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; AC$(I)="   "

	ldx	#STRARR_AC
	ldd	#INTVAR_I
	jsr	arrref1_ir1_sx_id

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

	; NEXT

	jsr	next

LINE_1040

	; FOR I=2 TO 9

	ldx	#INTVAR_I
	ldab	#2
	jsr	for_ix_pb

	ldab	#9
	jsr	to_ip_pb

	; CA$(I)=RIGHT$(STR$(I),1)

	ldx	#STRARR_CA
	ldd	#INTVAR_I
	jsr	arrref1_ir1_sx_id

	ldx	#INTVAR_I
	jsr	str_sr1_ix

	ldab	#1
	jsr	right_sr1_sr1_pb

	jsr	ld_sp_sr1

	; NEXT

	jsr	next

LINE_1050

	; CA$(1)="A"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_CA
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	1, "A"

	jsr	ld_sp_sr1

	; CA$(10)="T"

	ldab	#10
	jsr	ld_ir1_pb

	ldx	#STRARR_CA
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	1, "T"

	jsr	ld_sp_sr1

	; CA$(11)="J"

	ldab	#11
	jsr	ld_ir1_pb

	ldx	#STRARR_CA
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	1, "J"

	jsr	ld_sp_sr1

	; CA$(12)="Q"

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#STRARR_CA
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	1, "Q"

	jsr	ld_sp_sr1

	; CA$(13)="K"

	ldab	#13
	jsr	ld_ir1_pb

	ldx	#STRARR_CA
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	1, "K"

	jsr	ld_sp_sr1

LINE_1060

	; FOR I=1 TO 4

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

LINE_1070

	; FOR J=1 TO 13

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#13
	jsr	to_ip_pb

LINE_1080

	; K=((I-1)*13)+J

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldab	#13
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

LINE_1090

	; DK$(K)=CA$(J)+SU$(I)

	ldx	#STRARR_DK
	ldd	#INTVAR_K
	jsr	arrref1_ir1_sx_id

	ldx	#STRARR_CA
	ldd	#INTVAR_J
	jsr	arrval1_ir1_sx_id

	jsr	strinit_sr1_sr1

	ldx	#STRARR_SU
	ldd	#INTVAR_I
	jsr	arrval1_ir2_sx_id

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1100

	; NEXT

	jsr	next

LINE_1110

	; NEXT

	jsr	next

LINE_1120

	; FOR I=1 TO 7

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1130

	; FOR J=1 TO 19

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#19
	jsr	to_ip_pb

LINE_1140

	; CL$(I,J,1)="   "

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

	; CL$(I,J,2)="   "

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

LINE_1150

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_1160

	; NC=0

	ldx	#INTVAR_NC
	jsr	clr_ix

LINE_1170

	; RETURN

	jsr	return

LINE_1200

	; REM SHUFFLE

LINE_1210

	; FOR I=1 TO 52

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#52
	jsr	to_ip_pb

	; ND$(I)=""

	ldx	#STRARR_ND
	ldd	#INTVAR_I
	jsr	arrref1_ir1_sx_id

	jsr	ld_sr1_ss
	.text	0, ""

	jsr	ld_sp_sr1

	; NEXT

	jsr	next

LINE_1220

	; FOR I=1 TO 52

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#52
	jsr	to_ip_pb

LINE_1230

	; R=RND(52)

	ldab	#52
	jsr	irnd_ir1_pb

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

LINE_1240

	; IF ND$(R)="" THEN

	ldx	#STRARR_ND
	ldd	#INTVAR_R
	jsr	arrval1_ir1_sx_id

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_1241
	jsr	jmpeq_ir1_ix

	; ND$(R)=DK$(I)

	ldx	#STRARR_ND
	ldd	#INTVAR_R
	jsr	arrref1_ir1_sx_id

	ldx	#STRARR_DK
	ldd	#INTVAR_I
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

	; GOTO 1250

	ldx	#LINE_1250
	jsr	goto_ix

LINE_1241

	; GOTO 1230

	ldx	#LINE_1230
	jsr	goto_ix

LINE_1250

	; NEXT

	jsr	next

LINE_1260

	; FOR I=1 TO 52

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#52
	jsr	to_ip_pb

LINE_1270

	; DK$(I)=ND$(I)

	ldx	#STRARR_DK
	ldd	#INTVAR_I
	jsr	arrref1_ir1_sx_id

	ldx	#STRARR_ND
	ldd	#INTVAR_I
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_1280

	; NEXT

	jsr	next

LINE_1290

	; RETURN

	jsr	return

LINE_1295

	; REM DISPLAY A CARD (C$)

LINE_1300

	; IF C$="   " THEN

	ldx	#STRVAR_C
	jsr	ldeq_ir1_sx_ss
	.text	3, "   "

	ldx	#LINE_1350
	jsr	jmpeq_ir1_ix

	; PRINT C$;

	ldx	#STRVAR_C
	jsr	pr_sx

	; PRINT @RL+T, C$;

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; PRINT @RL+64, C$;

	ldx	#INTVAR_RL
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; RETURN

	jsr	return

LINE_1350

	; PRINT C$;

	ldx	#STRVAR_C
	jsr	pr_sx

	; TM=PEEK(MC+RL)-64

	ldx	#INTVAR_MC
	ldd	#INTVAR_RL
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldab	#64
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_TM
	jsr	ld_ix_ir1

	; IF TM>128 THEN

	ldab	#128
	ldx	#INTVAR_TM
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_1360
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_1360

	; POKE MC+RL,TM

	ldx	#INTVAR_MC
	ldd	#INTVAR_RL
	jsr	add_ir1_ix_id

	ldx	#INTVAR_TM
	jsr	poke_ir1_ix

	; RETURN

	jsr	return

LINE_1500

	; REM DEAL THE GAME

LINE_1510

	; C=1

	ldx	#INTVAR_C
	jsr	one_ix

LINE_1520

	; FOR PL=1 TO 7

	ldx	#INTVAR_PL
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1530

	; FOR CL=1 TO 7

	ldx	#INTVAR_CL
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1535

	; IF CL<PL THEN

	ldx	#INTVAR_CL
	ldd	#INTVAR_PL
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_1540
	jsr	jmpeq_ir1_ix

	; CL$(CL,PL,1)="   "

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

	; CL$(CL,PL,2)="   "

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

	; GOTO 1570

	ldx	#LINE_1570
	jsr	goto_ix

LINE_1540

	; CL$(CL,PL,1)=DK$(C)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#STRARR_DK
	ldd	#INTVAR_C
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_1550

	; C+=1

	ldx	#INTVAR_C
	jsr	inc_ix_ix

LINE_1560

	; IF CL=PL THEN

	ldx	#INTVAR_CL
	ldd	#INTVAR_PL
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_1561
	jsr	jmpeq_ir1_ix

	; CL$(CL,PL,2)=CL$(CL,PL,1)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ld_sp_sr1

	; GOTO 1570

	ldx	#LINE_1570
	jsr	goto_ix

LINE_1561

	; CL$(CL,PL,2)=DN$

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#STRVAR_DN
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

LINE_1570

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_1580

	; CLS

	jsr	cls

LINE_1590

	; PRINT @1, "A=ACES\r";

	ldab	#1
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "A=ACES\r"

	; AC=0

	ldx	#INTVAR_AC
	jsr	clr_ix

LINE_1640

	; PRINT @SHIFT(T,2), " 1 \r";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#2
	jsr	shift_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	4, " 1 \r"

LINE_1645

	; PRINT @T*3, " 1   2   3   4   5   6   7\r";

	ldx	#INTVAR_T
	jsr	mul3_ir1_ix

	jsr	prat_ir1

	jsr	pr_ss
	.text	27, " 1   2   3   4   5   6   7\r"

LINE_1650

	; FOR PL=1 TO 7

	ldx	#INTVAR_PL
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1660

	; FOR CL=1 TO 7

	ldx	#INTVAR_CL
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1665

	; C$=CL$(CL,PL,2)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

LINE_1670

	; RL=L(CL,PL)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	ldd	#INTVAR_PL
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_RL
	jsr	ld_ix_ir1

	; PRINT @RL,

	ldx	#INTVAR_RL
	jsr	prat_ix

	; WHEN C$="   " GOTO 1680

	ldx	#STRVAR_C
	jsr	ldeq_ir1_sx_ss
	.text	3, "   "

	ldx	#LINE_1680
	jsr	jmpne_ir1_ix

LINE_1675

	; IN$=C$

	ldd	#STRVAR_IN
	ldx	#STRVAR_C
	jsr	ld_sd_sx

	; GOSUB 3070

	ldx	#LINE_3070
	jsr	gosub_ix

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; RL+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_RL
	jsr	add_ix_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_1680

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_1690

	; RETURN

	jsr	return

LINE_1700

	; REM PREPARE TO PLAY

LINE_1710

	; FOR I=1 TO 24

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#24
	jsr	to_ip_pb

LINE_1715

	; J=I+28

	ldx	#INTVAR_I
	ldab	#28
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

LINE_1720

	; ND$(I)=DK$(J)

	ldx	#STRARR_ND
	ldd	#INTVAR_I
	jsr	arrref1_ir1_sx_id

	ldx	#STRARR_DK
	ldd	#INTVAR_J
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_1730

	; NEXT

	jsr	next

LINE_1740

	; FOR I=25 TO 52

	ldx	#INTVAR_I
	ldab	#25
	jsr	for_ix_pb

	ldab	#52
	jsr	to_ip_pb

LINE_1750

	; ND$(I)=""

	ldx	#STRARR_ND
	ldd	#INTVAR_I
	jsr	arrref1_ir1_sx_id

	jsr	ld_sr1_ss
	.text	0, ""

	jsr	ld_sp_sr1

LINE_1760

	; NEXT

	jsr	next

LINE_1770

	; ND=24

	ldx	#INTVAR_ND
	ldab	#24
	jsr	ld_ix_pb

LINE_1780

	; RETURN

	jsr	return

LINE_1800

	; REM SHOW DECK

LINE_1810

	; RL=444

	ldx	#INTVAR_RL
	ldd	#444
	jsr	ld_ix_pw

	; PRINT @RL,

	ldx	#INTVAR_RL
	jsr	prat_ix

	; IF ND<1 THEN

	ldx	#INTVAR_ND
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_1820
	jsr	jmpeq_ir1_ix

	; PRINT "NONE";

	jsr	pr_ss
	.text	4, "NONE"

	; PRINT @RL+T, "   ";

	ldx	#INTVAR_RL
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "   "

	; PRINT @RL+64, "   ";

	ldx	#INTVAR_RL
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "   "

	; RETURN

	jsr	return

LINE_1820

	; C$=ND$(T1)

	ldx	#STRARR_ND
	ldd	#INTVAR_T1
	jsr	arrval1_ir1_sx_id

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; IN$=C$

	ldd	#STRVAR_IN
	ldx	#STRVAR_C
	jsr	ld_sd_sx

	; GOSUB 3070

	ldx	#LINE_3070
	jsr	gosub_ix

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; RL+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_RL
	jsr	add_ix_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_1830

	; PRINT @316, "CARD";

	ldd	#316
	jsr	prat_pw

	jsr	pr_ss
	.text	4, "CARD"

	; PRINT @(T*10)+28, STR$(T1);" ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#10
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_T1
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; PRINT @412, STR$(ND);" ";

	ldd	#412
	jsr	prat_pw

	ldx	#INTVAR_ND
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; RETURN

	jsr	return

LINE_1900

	; REM SHOW CARDS

LINE_1910

	; CN=0

	ldx	#INTVAR_CN
	jsr	clr_ix

LINE_1920

	; FOR PL=1 TO 19

	ldx	#INTVAR_PL
	jsr	forone_ix

	ldab	#19
	jsr	to_ip_pb

	; FOR CL=1 TO 7

	ldx	#INTVAR_CL
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

	; RL=L(CL,PL)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	ldd	#INTVAR_PL
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_RL
	jsr	ld_ix_ir1

	; PRINT @RL, "";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	0, ""

LINE_1935

	; C$=CL$(CL,PL,2)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; WHEN C$="   " GOTO 1960

	ldx	#STRVAR_C
	jsr	ldeq_ir1_sx_ss
	.text	3, "   "

	ldx	#LINE_1960
	jsr	jmpne_ir1_ix

LINE_1940

	; IF C$=DN$ THEN

	ldx	#STRVAR_C
	ldd	#STRVAR_DN
	jsr	ldeq_ir1_sx_sd

	ldx	#LINE_1950
	jsr	jmpeq_ir1_ix

	; C$=CL$(CL,PL,1)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; CN+=1

	ldx	#INTVAR_CN
	jsr	inc_ix_ix

LINE_1950

	; IN$=C$

	ldd	#STRVAR_IN
	ldx	#STRVAR_C
	jsr	ld_sd_sx

	; GOSUB 3070

	ldx	#LINE_3070
	jsr	gosub_ix

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; RL+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_RL
	jsr	add_ix_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_1960

	; NEXT

	jsr	next

LINE_1965

	; IF CN=0 THEN

	ldx	#INTVAR_CN
	jsr	ld_ir1_ix

	ldx	#LINE_1980
	jsr	jmpne_ir1_ix

	; PL=20

	ldx	#INTVAR_PL
	ldab	#20
	jsr	ld_ix_pb

LINE_1980

	; NEXT

	jsr	next

LINE_1990

	; RETURN

	jsr	return

LINE_2000

	; REM CHECK IF AB$ CAN GO ON BE$

LINE_2010

	; IN$=AB$

	ldd	#STRVAR_IN
	ldx	#STRVAR_AB
	jsr	ld_sd_sx

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; A=N

	ldd	#INTVAR_A
	ldx	#INTVAR_N
	jsr	ld_id_ix

	; AS=SU

	ldd	#INTVAR_AS
	ldx	#INTVAR_SU
	jsr	ld_id_ix

LINE_2020

	; IN$=BE$

	ldd	#STRVAR_IN
	ldx	#STRVAR_BE
	jsr	ld_sd_sx

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; BN=N

	ldd	#INTVAR_BN
	ldx	#INTVAR_N
	jsr	ld_id_ix

	; BS=SU

	ldd	#INTVAR_BS
	ldx	#INTVAR_SU
	jsr	ld_id_ix

LINE_2030

	; OK$="YES"

	jsr	ld_sr1_ss
	.text	3, "YES"

	ldx	#STRVAR_OK
	jsr	ld_sx_sr1

LINE_2040

	; IF (A+1)<>BN THEN

	ldx	#INTVAR_A
	jsr	inc_ir1_ix

	ldx	#INTVAR_BN
	jsr	ldne_ir1_ir1_ix

	ldx	#LINE_2050
	jsr	jmpeq_ir1_ix

	; OK$="NO"

	jsr	ld_sr1_ss
	.text	2, "NO"

	ldx	#STRVAR_OK
	jsr	ld_sx_sr1

LINE_2050

	; IF (AS<=2) AND (BS<=2) THEN

	ldab	#2
	ldx	#INTVAR_AS
	jsr	ldge_ir1_pb_ix

	ldab	#2
	ldx	#INTVAR_BS
	jsr	ldge_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_2060
	jsr	jmpeq_ir1_ix

	; OK$="NO"

	jsr	ld_sr1_ss
	.text	2, "NO"

	ldx	#STRVAR_OK
	jsr	ld_sx_sr1

LINE_2060

	; IF (AS>=3) AND (BS>=3) THEN

	ldx	#INTVAR_AS
	ldab	#3
	jsr	ldge_ir1_ix_pb

	ldx	#INTVAR_BS
	ldab	#3
	jsr	ldge_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_2070
	jsr	jmpeq_ir1_ix

	; OK$="NO"

	jsr	ld_sr1_ss
	.text	2, "NO"

	ldx	#STRVAR_OK
	jsr	ld_sx_sr1

LINE_2070

	; RETURN

	jsr	return

LINE_2200

	; REM REPACK DECK

LINE_2205

	; IF ND=1 THEN

	ldx	#INTVAR_ND
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_2210
	jsr	jmpeq_ir1_ix

	; T1=0

	ldx	#INTVAR_T1
	jsr	clr_ix

	; ND=0

	ldx	#INTVAR_ND
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_2210

	; FOR I=T1+1 TO ND

	ldx	#INTVAR_T1
	jsr	inc_ir1_ix

	ldx	#INTVAR_I
	jsr	for_ix_ir1

	ldx	#INTVAR_ND
	jsr	to_ip_ix

LINE_2220

	; ND$(I-1)=ND$(I)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#STRARR_ND
	jsr	arrref1_ir1_sx_ir1

	ldx	#STRARR_ND
	ldd	#INTVAR_I
	jsr	arrval1_ir1_sx_id

	jsr	ld_sp_sr1

LINE_2230

	; NEXT

	jsr	next

LINE_2240

	; ND-=1

	ldx	#INTVAR_ND
	jsr	dec_ix_ix

LINE_2250

	; T1-=1

	ldx	#INTVAR_T1
	jsr	dec_ix_ix

LINE_2260

	; IF T1<1 THEN

	ldx	#INTVAR_T1
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_2280
	jsr	jmpeq_ir1_ix

	; T1=3

	ldx	#INTVAR_T1
	ldab	#3
	jsr	ld_ix_pb

LINE_2280

	; IF T1>ND THEN

	ldx	#INTVAR_ND
	ldd	#INTVAR_T1
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_2290
	jsr	jmpeq_ir1_ix

	; T1=ND

	ldd	#INTVAR_T1
	ldx	#INTVAR_ND
	jsr	ld_id_ix

LINE_2290

	; RETURN

	jsr	return

LINE_2300

	; REM PLAY AB$ TO ACES

LINE_2310

	; IN$=AB$

	ldd	#STRVAR_IN
	ldx	#STRVAR_AB
	jsr	ld_sd_sx

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; A=N

	ldd	#INTVAR_A
	ldx	#INTVAR_N
	jsr	ld_id_ix

	; AS=SU

	ldd	#INTVAR_AS
	ldx	#INTVAR_SU
	jsr	ld_id_ix

LINE_2315

	; IN$=AC$(AS)

	ldx	#STRARR_AC
	ldd	#INTVAR_AS
	jsr	arrval1_ir1_sx_id

	ldx	#STRVAR_IN
	jsr	ld_sx_sr1

	; IF IN$="   " THEN

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	3, "   "

	ldx	#LINE_2320
	jsr	jmpeq_ir1_ix

	; BN=0

	ldx	#INTVAR_BN
	jsr	clr_ix

	; GOTO 2330

	ldx	#LINE_2330
	jsr	goto_ix

LINE_2320

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; BN=N

	ldd	#INTVAR_BN
	ldx	#INTVAR_N
	jsr	ld_id_ix

LINE_2330

	; IF (BN+1)=A THEN

	ldx	#INTVAR_BN
	jsr	inc_ir1_ix

	ldx	#INTVAR_A
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_2331
	jsr	jmpeq_ir1_ix

	; OK$="YES"

	jsr	ld_sr1_ss
	.text	3, "YES"

	ldx	#STRVAR_OK
	jsr	ld_sx_sr1

	; GOTO 2340

	ldx	#LINE_2340
	jsr	goto_ix

LINE_2331

	; OK$="NO"

	jsr	ld_sr1_ss
	.text	2, "NO"

	ldx	#STRVAR_OK
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_2340

	; AC$(AS)=AB$

	ldx	#STRARR_AC
	ldd	#INTVAR_AS
	jsr	arrref1_ir1_sx_id

	ldx	#STRVAR_AB
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

LINE_2350

	; IF AC=0 THEN

	ldx	#INTVAR_AC
	jsr	ld_ir1_ix

	ldx	#LINE_2355
	jsr	jmpne_ir1_ix

	; AC=1

	ldx	#INTVAR_AC
	jsr	one_ix

	; PRINT @0, "           ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	11, "           "

LINE_2355

	; RL=SHIFT(AS-1,2)

	ldx	#INTVAR_AS
	jsr	dec_ir1_ix

	ldab	#2
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_RL
	jsr	ld_ix_ir1

	; PRINT @RL, "";

	ldx	#INTVAR_RL
	jsr	prat_ix

	jsr	pr_ss
	.text	0, ""

	; C$=AB$

	ldd	#STRVAR_C
	ldx	#STRVAR_AB
	jsr	ld_sd_sx

LINE_2360

	; IN$=C$

	ldd	#STRVAR_IN
	ldx	#STRVAR_C
	jsr	ld_sd_sx

	; GOSUB 3070

	ldx	#LINE_3070
	jsr	gosub_ix

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; RL+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_RL
	jsr	add_ix_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_2365

	; NC+=1

	ldx	#INTVAR_NC
	jsr	inc_ix_ix

	; PRINT @SHIFT(T,2)+27, "SCORE";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#2
	jsr	shift_ir1_ir1_pb

	ldab	#27
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	5, "SCORE"

	; PRINT @(T*5)+28, STR$(NC);" ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#5
	jsr	mul_ir1_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_NC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_2370

	; RETURN

	jsr	return

LINE_3000

	; REM CHANGE IN$ TO NUM AND SUIT

LINE_3005

	; IF A$="   " THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	3, "   "

	ldx	#LINE_3010
	jsr	jmpeq_ir1_ix

	; N=0

	ldx	#INTVAR_N
	jsr	clr_ix

	; SU=0

	ldx	#INTVAR_SU
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_3010

	; A$=LEFT$(IN$,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; IF A$="A" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_3030
	jsr	jmpeq_ir1_ix

	; A$=" 1"

	jsr	ld_sr1_ss
	.text	2, " 1"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_3030

	; IF A$="J" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "J"

	ldx	#LINE_3040
	jsr	jmpeq_ir1_ix

	; A$="11"

	jsr	ld_sr1_ss
	.text	2, "11"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_3040

	; IF A$="Q" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_3050
	jsr	jmpeq_ir1_ix

	; A$="12"

	jsr	ld_sr1_ss
	.text	2, "12"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_3050

	; IF A$="K" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "K"

	ldx	#LINE_3055
	jsr	jmpeq_ir1_ix

	; A$="13"

	jsr	ld_sr1_ss
	.text	2, "13"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_3055

	; IF A$="T" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "T"

	ldx	#LINE_3060
	jsr	jmpeq_ir1_ix

	; A$="10"

	jsr	ld_sr1_ss
	.text	2, "10"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_3060

	; N=INT(VAL(A$))

	ldx	#STRVAR_A
	jsr	val_fr1_sx

	ldx	#INTVAR_N
	jsr	ld_ix_ir1

LINE_3070

	; A$=MID$(IN$,2,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; IF A$="²" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "\xB2"

	ldx	#LINE_3072
	jsr	jmpeq_ir1_ix

	; SU=1

	ldx	#INTVAR_SU
	jsr	one_ix

	; RETURN

	jsr	return

LINE_3072

	; IF A$="±" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "\xB1"

	ldx	#LINE_3073
	jsr	jmpeq_ir1_ix

	; SU=2

	ldx	#INTVAR_SU
	ldab	#2
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_3073

	; IF A$="£" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "\xA3"

	ldx	#LINE_3074
	jsr	jmpeq_ir1_ix

	; SU=3

	ldx	#INTVAR_SU
	ldab	#3
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_3074

	; IF A$="¡" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "\xA1"

	ldx	#LINE_3075
	jsr	jmpeq_ir1_ix

	; SU=4

	ldx	#INTVAR_SU
	ldab	#4
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_3075

	; IF A$="Ã" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "\xC3"

	ldx	#LINE_3080
	jsr	jmpeq_ir1_ix

	; SU=5

	ldx	#INTVAR_SU
	ldab	#5
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_3080

	; SU=0

	ldx	#INTVAR_SU
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_3100

	; EF=0

	ldx	#INTVAR_EF
	jsr	clr_ix

	; FOR PL=1 TO 19

	ldx	#INTVAR_PL
	jsr	forone_ix

	ldab	#19
	jsr	to_ip_pb

	; C$=CL$(CL,PL,2)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; RL=L(CL,PL)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	ldd	#INTVAR_PL
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_RL
	jsr	ld_ix_ir1

	; PRINT @RL,

	ldx	#INTVAR_RL
	jsr	prat_ix

LINE_3150

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; IF C$="   " THEN

	ldx	#STRVAR_C
	jsr	ldeq_ir1_sx_ss
	.text	3, "   "

	ldx	#LINE_3160
	jsr	jmpeq_ir1_ix

	; IF EF=0 THEN

	ldx	#INTVAR_EF
	jsr	ld_ir1_ix

	ldx	#LINE_3160
	jsr	jmpne_ir1_ix

	; EF=L(CL,PL-1)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	dec_ir2_ix

	ldx	#INTARR_L
	jsr	arrval2_ir1_ix_ir2

	ldx	#INTVAR_EF
	jsr	ld_ix_ir1

	; IN$=CL$(CL,PL-1,2)

	ldx	#INTVAR_CL
	jsr	ld_ir1_ix

	ldx	#INTVAR_PL
	jsr	dec_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	ldx	#STRVAR_IN
	jsr	ld_sx_sr1

LINE_3160

	; NEXT

	jsr	next

	; IF EF>0 THEN

	ldab	#0
	ldx	#INTVAR_EF
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_3170
	jsr	jmpeq_ir1_ix

	; RL=EF

	ldd	#INTVAR_RL
	ldx	#INTVAR_EF
	jsr	ld_id_ix

	; PRINT @RL,

	ldx	#INTVAR_RL
	jsr	prat_ix

	; GOSUB 3070

	ldx	#LINE_3070
	jsr	gosub_ix

	; C$=IN$

	ldd	#STRVAR_C
	ldx	#STRVAR_IN
	jsr	ld_sd_sx

	; GOSUB 1300

	ldx	#LINE_1300
	jsr	gosub_ix

	; RL+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_RL
	jsr	add_ix_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_3170

	; RETURN

	jsr	return

LINE_3199

	; REM REDRAW A COLUMN

LINE_3200

	; REM COPY PART OF A COLUMN

LINE_3205

	; FP=FE

	ldd	#INTVAR_FP
	ldx	#INTVAR_FE
	jsr	ld_id_ix

	; TP=T0

	ldd	#INTVAR_TP
	ldx	#INTVAR_T0
	jsr	ld_id_ix

LINE_3207

	; WHEN (TP=1) AND (LEFT$(CL$(FW,FE,2),1)="K") GOTO 3220

	ldx	#INTVAR_TP
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#INTVAR_FW
	jsr	ld_ir2_ix

	ldx	#INTVAR_FE
	jsr	ld_ir3_ix

	ldab	#2
	jsr	ld_ir4_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir2_sx_ir4

	ldab	#1
	jsr	left_sr2_sr2_pb

	jsr	ldeq_ir2_sr2_ss
	.text	1, "K"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_3220
	jsr	jmpne_ir1_ix

LINE_3210

	; TP+=1

	ldx	#INTVAR_TP
	jsr	inc_ix_ix

LINE_3220

	; CL$(TW,TP,1)=CL$(FW,FP,1)

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_TP
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FP
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ld_sp_sr1

LINE_3225

	; CL$(TW,TP,2)=CL$(FW,FP,2)

	ldx	#INTVAR_TW
	jsr	ld_ir1_ix

	ldx	#INTVAR_TP
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FP
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ld_sp_sr1

LINE_3230

	; REM CL$(FW,FP,1)="   "

LINE_3235

	; CL$(FW,FP,2)="   "

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FP
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

LINE_3240

	; FP+=1

	ldx	#INTVAR_FP
	jsr	inc_ix_ix

LINE_3250

	; WHEN CL$(FW,FP,2)<>"   " GOTO 3210

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FP
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ldne_ir1_sr1_ss
	.text	3, "   "

	ldx	#LINE_3210
	jsr	jmpne_ir1_ix

LINE_3260

	; WHEN FE>1 GOTO 3300

	ldab	#1
	ldx	#INTVAR_FE
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_3300
	jsr	jmpne_ir1_ix

LINE_3270

	; CL$(FW,FP,1)="   "

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FP
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

LINE_3280

	; CL$(FW,1,2)="   "

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

LINE_3290

	; RETURN

	jsr	return

LINE_3300

	; CL$(FW,FE-1,2)=CL$(FW,FE-1,1)

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	dec_ir2_ix

	ldab	#2
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrref3_ir1_sx_ir3

	ldx	#INTVAR_FW
	jsr	ld_ir1_ix

	ldx	#INTVAR_FE
	jsr	dec_ir2_ix

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#STRARR_CL
	jsr	arrval3_ir1_sx_ir3

	jsr	ld_sp_sr1

LINE_3310

	; RETURN

	jsr	return

LINE_3400

	; REM EVALUATE GAME PERFORMANCE

LINE_3405

	; PRINT @(T*14)-1, STR$(NC);" PLACED ON ACES PILES.  ";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#14
	jsr	mul_ir1_ir1_pb

	jsr	dec_ir1_ir1

	jsr	prat_ir1

	ldx	#INTVAR_NC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	24, " PLACED ON ACES PILES.  "

	; PRINT @T*15, "";

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#15
	jsr	mul_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	0, ""

LINE_3410

	; SC=IDIV(NC,10)+1

	ldx	#INTVAR_NC
	jsr	ld_ir1_ix

	ldab	#10
	jsr	idiv5s_ir1_ir1_pb

	jsr	inc_ir1_ir1

	ldx	#INTVAR_SC
	jsr	ld_ix_ir1

LINE_3415

	; IF NC=52 THEN

	ldx	#INTVAR_NC
	ldab	#52
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_3420
	jsr	jmpeq_ir1_ix

	; SC=7

	ldx	#INTVAR_SC
	ldab	#7
	jsr	ld_ix_pb

LINE_3420

	; WHEN NC=0 GOTO 3520

	ldx	#INTVAR_NC
	jsr	ld_ir1_ix

	ldx	#LINE_3520
	jsr	jmpeq_ir1_ix

LINE_3430

	; ON SC GOSUB 3450,3460,3470,3480,3490,3500,3510

	ldx	#INTVAR_SC
	jsr	ld_ir1_ix

	jsr	ongosub_ir1_is
	.byte	7
	.word	LINE_3450, LINE_3460, LINE_3470, LINE_3480, LINE_3490, LINE_3500, LINE_3510

LINE_3440

	; RETURN

	jsr	return

	; REM SCORE 0-9  10-19 20-29 30-39 40-49 50+

LINE_3450

	; PRINT "NOT SO GOOD.  ";

	jsr	pr_ss
	.text	14, "NOT SO GOOD.  "

	; RETURN

	jsr	return

LINE_3460

	; PRINT "NOT TOO BAD.  ";

	jsr	pr_ss
	.text	14, "NOT TOO BAD.  "

	; RETURN

	jsr	return

LINE_3470

	; PRINT "KEEP TRYING.  ";

	jsr	pr_ss
	.text	14, "KEEP TRYING.  "

	; RETURN

	jsr	return

LINE_3480

	; PRINT "GOOD JOB!     ";

	jsr	pr_ss
	.text	14, "GOOD JOB!     "

	; RETURN

	jsr	return

LINE_3490

	; PRINT "VERY GOOD!    ";

	jsr	pr_ss
	.text	14, "VERY GOOD!    "

	; RETURN

	jsr	return

LINE_3500

	; PRINT "ALMOST...     ";

	jsr	pr_ss
	.text	14, "ALMOST...     "

	; RETURN

	jsr	return

LINE_3510

	; PRINT "YOU DID IT!   ";

	jsr	pr_ss
	.text	14, "YOU DID IT!   "

	; WI+=1

	ldx	#INTVAR_WI
	jsr	inc_ix_ix

	; RETURN

	jsr	return

LINE_3520

	; PRINT "BAD SHUFFLE!  ";

	jsr	pr_ss
	.text	14, "BAD SHUFFLE!  "

	; RETURN

	jsr	return

LINE_5000

	; REM INSTRUCTIONS

LINE_5010

	; CLS

	jsr	cls

	; PRINT "       KLONDIKE SOLITAIRE\r";

	jsr	pr_ss
	.text	26, "       KLONDIKE SOLITAIRE\r"

LINE_5030

	; PRINT "THIS PROGRAM PLAYS A SOLITAIRE  GAME. A DECK OF 52 CARDS IS\r";

	jsr	pr_ss
	.text	60, "THIS PROGRAM PLAYS A SOLITAIRE  GAME. A DECK OF 52 CARDS IS\r"

LINE_5040

	; PRINT "USED AND 28 CARDS ARE DEALT     INTO 7 COLUMNS. THE FIRST COL-\r";

	jsr	pr_ss
	.text	63, "USED AND 28 CARDS ARE DEALT     INTO 7 COLUMNS. THE FIRST COL-\r"

LINE_5050

	; PRINT "UMN AT THE LEFT HAS ONE CARD,   THE SECOND TWO, AND SO ON, UP\r";

	jsr	pr_ss
	.text	62, "UMN AT THE LEFT HAS ONE CARD,   THE SECOND TWO, AND SO ON, UP\r"

LINE_5060

	; PRINT "TO SEVEN IN COLUMN SEVEN. THE   LAST CARD OF EACH COLUMN IS \r";

	jsr	pr_ss
	.text	61, "TO SEVEN IN COLUMN SEVEN. THE   LAST CARD OF EACH COLUMN IS \r"

LINE_5070

	; PRINT "FACE UP AND THE REST ARE FACE   DOWN. ON EACH COLUMN YOU MAY\r";

	jsr	pr_ss
	.text	61, "FACE UP AND THE REST ARE FACE   DOWN. ON EACH COLUMN YOU MAY\r"

LINE_5080

	; PRINT "BUILD IN DESCENDING SEQUENCE:   RED ON BLACK, SUCH AS THE TEN\r";

	jsr	pr_ss
	.text	62, "BUILD IN DESCENDING SEQUENCE:   RED ON BLACK, SUCH AS THE TEN\r"

LINE_5090

	; PRINT "OF HEARTS ON THE JACK OF CLUBS  OR SPADES.\r";

	jsr	pr_ss
	.text	43, "OF HEARTS ON THE JACK OF CLUBS  OR SPADES.\r"

	; GOSUB 5500

	ldx	#LINE_5500
	jsr	gosub_ix

LINE_5100

	; PRINT "YOU CAN MOVE THE FACE UP CARDS  IN A COLUMN AS A UNIT. THE TOP\r";

	jsr	pr_ss
	.text	63, "YOU CAN MOVE THE FACE UP CARDS  IN A COLUMN AS A UNIT. THE TOP\r"

LINE_5110

	; PRINT "CARD BEING MOVED MUST FIT IN    SEQUENCE AND COLOUR WITH THE\r";

	jsr	pr_ss
	.text	61, "CARD BEING MOVED MUST FIT IN    SEQUENCE AND COLOUR WITH THE\r"

LINE_5120

	; PRINT "CARD BEING MOVED UNDER IN THE   OTHER COLUMN. WHEN YOU UNCOVER\r";

	jsr	pr_ss
	.text	63, "CARD BEING MOVED UNDER IN THE   OTHER COLUMN. WHEN YOU UNCOVER\r"

LINE_5130

	; PRINT "A FACE-DOWN CARD ON A COLUMN,   IT WILL BE TURNED UP.\r";

	jsr	pr_ss
	.text	54, "A FACE-DOWN CARD ON A COLUMN,   IT WILL BE TURNED UP.\r"

LINE_5140

	; PRINT "YOU ARE ALWAYS ENTITLED TO HAVE 7 COLUMNS, AND IF ONE IS\r";

	jsr	pr_ss
	.text	57, "YOU ARE ALWAYS ENTITLED TO HAVE 7 COLUMNS, AND IF ONE IS\r"

LINE_5150

	; PRINT "ENTIRELY OPEN YOU MAY PUT A KINGIN THE SPACE. WHENEVER YOU\r";

	jsr	pr_ss
	.text	59, "ENTIRELY OPEN YOU MAY PUT A KINGIN THE SPACE. WHENEVER YOU\r"

LINE_5160

	; PRINT "FREE AN ACE, MOVE IT TO THE ACE FOUNDATIONS. ON THE ACES PILES\r";

	jsr	pr_ss
	.text	63, "FREE AN ACE, MOVE IT TO THE ACE FOUNDATIONS. ON THE ACES PILES\r"

	; GOSUB 5500

	ldx	#LINE_5500
	jsr	gosub_ix

LINE_5170

	; PRINT "YOU MAY BUILD UP IN SUIT AND    SEQUENCE AND THEN TO WIN THE\r";

	jsr	pr_ss
	.text	61, "YOU MAY BUILD UP IN SUIT AND    SEQUENCE AND THEN TO WIN THE\r"

LINE_5180

	; PRINT "GAME, YOU HAVE TO BUILD EACH    SUIT UP TO A KING. A CARD MUST\r";

	jsr	pr_ss
	.text	63, "GAME, YOU HAVE TO BUILD EACH    SUIT UP TO A KING. A CARD MUST\r"

LINE_5190

	; PRINT "BE THE TOP CARD OF A COLUMN TO  BE PLAYED FROM, TO THE COLUMNS\r";

	jsr	pr_ss
	.text	63, "BE THE TOP CARD OF A COLUMN TO  BE PLAYED FROM, TO THE COLUMNS\r"

LINE_5200

	; PRINT "OF THE ACE FOUNDATIONS. ONCE    PLAYED ON THE ACE FOUNDATIONS,\r";

	jsr	pr_ss
	.text	63, "OF THE ACE FOUNDATIONS. ONCE    PLAYED ON THE ACE FOUNDATIONS,\r"

LINE_5210

	; PRINT "A CARD CANNOT BE REMOVED TO     HELP ELSEWHERE.\r";

	jsr	pr_ss
	.text	48, "A CARD CANNOT BE REMOVED TO     HELP ELSEWHERE.\r"

	; GOSUB 5500

	ldx	#LINE_5500
	jsr	gosub_ix

LINE_5240

	; PRINT "THE REMAINING 24 CARDS IN THE   DECK ARE USED AS THE STOCK.\r";

	jsr	pr_ss
	.text	60, "THE REMAINING 24 CARDS IN THE   DECK ARE USED AS THE STOCK.\r"

LINE_5250

	; PRINT "EVERY THIRD CARD MAY BE TURNED  UP AND THE DECK MAY BE GONE\r";

	jsr	pr_ss
	.text	60, "EVERY THIRD CARD MAY BE TURNED  UP AND THE DECK MAY BE GONE\r"

LINE_5260

	; PRINT "THROUGH ANY NUMBER OF TIMES.    THE TOP CARD IS AVAILABLE FOR\r";

	jsr	pr_ss
	.text	62, "THROUGH ANY NUMBER OF TIMES.    THE TOP CARD IS AVAILABLE FOR\r"

LINE_5270

	; PRINT "PLAY TO ANY COLUMN OR THE ACES  FOUNDATIONS. WHEN THE TOP CARD\r";

	jsr	pr_ss
	.text	63, "PLAY TO ANY COLUMN OR THE ACES  FOUNDATIONS. WHEN THE TOP CARD\r"

LINE_5280

	; PRINT "IS PLAYED, THE NEXT CARD WILL   THEN BE AVAILABLE. YOU WIN\r";

	jsr	pr_ss
	.text	59, "IS PLAYED, THE NEXT CARD WILL   THEN BE AVAILABLE. YOU WIN\r"

LINE_5290

	; PRINT "IF YOU CAN BUILD ALL 4 ACE      FOUNDATIONS UP TO KINGS.\r";

	jsr	pr_ss
	.text	57, "IF YOU CAN BUILD ALL 4 ACE      FOUNDATIONS UP TO KINGS.\r"

LINE_5300

	; PRINT "YOU LOSE WHEN YOU CAN NOT MAKE  ANY FURTHER PLAYS.\r";

	jsr	pr_ss
	.text	51, "YOU LOSE WHEN YOU CAN NOT MAKE  ANY FURTHER PLAYS.\r"

	; GOSUB 5500

	ldx	#LINE_5500
	jsr	gosub_ix

LINE_5320

	; PRINT "PLAYS ARE CONTROLLED BY KEYBOARDCOMMANDS AS FOLLOWS:\r";

	jsr	pr_ss
	.text	53, "PLAYS ARE CONTROLLED BY KEYBOARDCOMMANDS AS FOLLOWS:\r"

LINE_5330

	; PRINT "D = PLAY TOP CARD OF THE DECK TO    ACES (A) OR (#1-7).\r";

	jsr	pr_ss
	.text	56, "D = PLAY TOP CARD OF THE DECK TO    ACES (A) OR (#1-7).\r"

LINE_5340

	; PRINT "    ANSWER 'A' OR NUMBER 1-7        TO NEXT QUESTION TO\r";

	jsr	pr_ss
	.text	56, "    ANSWER 'A' OR NUMBER 1-7        TO NEXT QUESTION TO\r"

LINE_5350

	; PRINT "    INDICATE WHERE THE CARD IS      TO BE MOVED.\r";

	jsr	pr_ss
	.text	49, "    INDICATE WHERE THE CARD IS      TO BE MOVED.\r"

LINE_5360

	; PRINT "C = GET NEXT CARD IN THE DECK.\r";

	jsr	pr_ss
	.text	31, "C = GET NEXT CARD IN THE DECK.\r"

LINE_5370

	; PRINT "Q = QUIT GAME AND TURN OVER ALL     FACE-DOWN CARDS.\r";

	jsr	pr_ss
	.text	53, "Q = QUIT GAME AND TURN OVER ALL     FACE-DOWN CARDS.\r"

LINE_5380

	; PRINT "#1-7 = PLAY CARDS FROM COLUMN#      TO ACES OR ANOTHER COLUMN.\r";

	jsr	pr_ss
	.text	63, "#1-7 = PLAY CARDS FROM COLUMN#      TO ACES OR ANOTHER COLUMN.\r"

	; GOSUB 5500

	ldx	#LINE_5500
	jsr	gosub_ix

LINE_5400

	; PRINT "AN ERROR MESSAGE WILL DISPLAY   IF AN INVALID RESPONSE IS\r";

	jsr	pr_ss
	.text	58, "AN ERROR MESSAGE WILL DISPLAY   IF AN INVALID RESPONSE IS\r"

LINE_5410

	; PRINT "GIVEN TO ANY QUESTION OR ANY    INVALID PLAYS ARE ATTEMPTED.\r";

	jsr	pr_ss
	.text	61, "GIVEN TO ANY QUESTION OR ANY    INVALID PLAYS ARE ATTEMPTED.\r"

	; GOSUB 5500

	ldx	#LINE_5500
	jsr	gosub_ix

LINE_5420

	; RETURN

	jsr	return

LINE_5500

	; PRINT @480, "   PRESS ANY KEY TO CONTINUE";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	28, "   PRESS ANY KEY TO CONTINUE"

LINE_5510

	; WHEN INKEY$="" GOTO 5510

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_5510
	jsr	jmpne_ir1_ix

LINE_5520

	; CLS

	jsr	cls

	; RETURN

	jsr	return

LINE_8000

	; MC=16384

	ldx	#INTVAR_MC
	ldd	#16384
	jsr	ld_ix_pw

	; T=32

	ldx	#INTVAR_T
	ldab	#32
	jsr	ld_ix_pb

	; FOR CL=1 TO 7

	ldx	#INTVAR_CL
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

	; R=SHIFT(CL-1,2)

	ldx	#INTVAR_CL
	jsr	dec_ir1_ix

	ldab	#2
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; FOR RL=1 TO 19

	ldx	#INTVAR_RL
	jsr	forone_ix

	ldab	#19
	jsr	to_ip_pb

LINE_8010

	; ON RL GOSUB 1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2

	ldx	#INTVAR_RL
	jsr	ld_ir1_ix

	jsr	ongosub_ir1_is
	.byte	19
	.word	LINE_1, LINE_1, LINE_1, LINE_1, LINE_1, LINE_1, LINE_1, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2

LINE_8020

	; NEXT

	jsr	next

	; NEXT

	jsr	next

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

	.module	mdgetge
getge
	bge	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgeths
geths
	bhs	_1
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
; get offset from 2D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref2
	ldd	,x
	beq	_err
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

	.module	mdref3
; get offset from 3D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref3
	ldd	,x
	beq	_err
	ldd	4+argv
	std	tmp1
	subd	6,x
	bhs	_err
	ldd	4,x
	std	tmp2
	subd	2+argv
	bls	_err
	jsr	mul12
	addd	2+argv
	std	tmp1
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

	.module	mdstrlo
; compare A$ < B$ with string release
; ENTRY:  A$ = 0+argv (len) 1+argv (ptr)
;         B$ = tmp1+1 (len) tmp2   (ptr)
; EXIT: C flag set if A$ < B$
strlo
	ldx	1+argv
	jsr	strrel
	ldx	tmp2
	jsr	strrel
	ldab	tmp1+1
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
	bra	strlo

	.module	mdstrlosr
strlosr
	tsx
	ldx	2,x
	ldab	,x
	stab	0+argv
	inx
	stx	1+argv
	abx
	stx	tmp3
	tsx
	ldd	tmp3
	std	2,x
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

add_ir1_ir1_ix			; numCalls = 3
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 10
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 10
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

add_ir1_ix_pb			; numCalls = 6
	.module	modadd_ir1_ix_pb
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ix_ix_ir1			; numCalls = 6
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
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

and_ir2_ir2_ir3			; numCalls = 2
	.module	modand_ir2_ir2_ir3
	ldd	r3+1
	andb	r2+2
	anda	r2+1
	std	r2+1
	ldab	r3
	andb	r2
	stab	r2
	rts

arrdim1_ir1_sx			; numCalls = 5
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

arrdim3_ir1_sx			; numCalls = 1
	.module	modarrdim3_ir1_sx
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
	std	tmp1
	ldd	r3+1
	addd	#1
	std	6,x
	std	tmp2
	jsr	mul12
	std	tmp3
	lsld
	addd	tmp3
	jmp	alloc

arrref1_ir1_sx_id			; numCalls = 9
	.module	modarrref1_ir1_sx_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx_ir1			; numCalls = 10
	.module	modarrref1_ir1_sx_ir1
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix_id			; numCalls = 2
	.module	modarrref2_ir1_ix_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrref3_ir1_sx_ir3			; numCalls = 17
	.module	modarrref3_ir1_sx_ir3
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	std	letptr
	rts

arrval1_ir1_sx_id			; numCalls = 14
	.module	modarrval1_ir1_sx_id
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

arrval1_ir2_sx_id			; numCalls = 2
	.module	modarrval1_ir2_sx_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval2_ir1_ix_id			; numCalls = 3
	.module	modarrval2_ir1_ix_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval2_ir1_ix_ir2			; numCalls = 1
	.module	modarrval2_ir1_ix_ir2
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

arrval3_ir1_sx_ir3			; numCalls = 21
	.module	modarrval3_ir1_sx_ir3
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval3_ir2_sx_ir4			; numCalls = 2
	.module	modarrval3_ir2_sx_ir4
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
	ldd	r2+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

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

clr_ix			; numCalls = 12
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 7
	.module	modcls
	jmp	R_CLS

dbl_ir1_ix			; numCalls = 1
	.module	moddbl_ir1_ix
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dec_ir1_ir1			; numCalls = 1
	.module	moddec_ir1_ir1
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 4
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 6
	.module	moddec_ir2_ix
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 2
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_ix_ir1			; numCalls = 1
	.module	modfor_ix_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 5
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forone_ix			; numCalls = 22
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 52
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 29
	.module	modgoto_ix
	ins
	ins
	jmp	,x

idiv5s_ir1_ir1_pb			; numCalls = 1
	.module	modidiv5s_ir1_ir1_pb
	ldx	#r1
	jmp	idiv5s

inc_ir1_ir1			; numCalls = 1
	.module	modinc_ir1_ir1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 3
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir2_ix			; numCalls = 2
	.module	modinc_ir2_ix
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 6
	.module	modinc_ix_ix
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sr1			; numCalls = 2
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

inkey_sx			; numCalls = 6
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

jmpeq_ir1_ix			; numCalls = 47
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

jmpne_ir1_ix			; numCalls = 23
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

jsrne_ir1_ix			; numCalls = 1
	.module	modjsrne_ir1_ix
	ldd	r1+1
	bne	_go
	ldaa	r1
	bne	_go
	rts
_go
	ldab	#3
	pshb
	jmp	,x

ld_id_ix			; numCalls = 26
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

ld_ip_ir1			; numCalls = 2
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 79
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_nb			; numCalls = 3
	.module	modld_ir1_nb
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ir1_pb			; numCalls = 17
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 30
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

ld_ir3_ix			; numCalls = 2
	.module	modld_ir3_ix
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ir3_pb			; numCalls = 39
	.module	modld_ir3_pb
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ir4_pb			; numCalls = 2
	.module	modld_ir4_pb
	stab	r4+2
	ldd	#0
	std	r4
	rts

ld_ix_ir1			; numCalls = 16
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 14
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 3
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sd_sx			; numCalls = 10
	.module	modld_sd_sx
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	tmp1
	jmp	strprm

ld_sp_sr1			; numCalls = 36
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 32
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 4
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 28
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir1_ix_id			; numCalls = 2
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

ldeq_ir1_ix_pb			; numCalls = 3
	.module	modldeq_ir1_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 5
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

ldeq_ir1_sx_sd			; numCalls = 1
	.module	modldeq_ir1_sx_sd
	std	tmp3
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	ldx	tmp3
	jsr	streqx
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 34
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

ldeq_ir2_sr2_ss			; numCalls = 3
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

ldge_ir1_ix_pb			; numCalls = 1
	.module	modldge_ir1_ix_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_pb_ix			; numCalls = 1
	.module	modldge_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_sx_ss			; numCalls = 1
	.module	modldge_ir1_sx_ss
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	jsr	strlos
	jsr	geths
	std	r1+1
	stab	r1
	rts

ldge_ir2_ix_pb			; numCalls = 1
	.module	modldge_ir2_ix_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getge
	std	r2+1
	stab	r2
	rts

ldge_ir2_pb_ix			; numCalls = 1
	.module	modldge_ir2_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getge
	std	r2+1
	stab	r2
	rts

ldge_ir2_ss_sx			; numCalls = 1
	.module	modldge_ir2_ss_sx
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	strlosr
	jsr	geths
	std	r2+1
	stab	r2
	rts

ldge_ir2_sx_ss			; numCalls = 2
	.module	modldge_ir2_sx_ss
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	jsr	strlos
	jsr	geths
	std	r2+1
	stab	r2
	rts

ldge_ir3_ss_sx			; numCalls = 2
	.module	modldge_ir3_ss_sx
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	strlosr
	jsr	geths
	std	r3+1
	stab	r3
	rts

ldlt_ir1_ix_id			; numCalls = 3
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

ldlt_ir1_ix_pb			; numCalls = 3
	.module	modldlt_ir1_ix_pb
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

ldlt_ir1_pb_ix			; numCalls = 5
	.module	modldlt_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldne_ir1_ir1_ix			; numCalls = 1
	.module	modldne_ir1_ir1_ix
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

ldne_ir1_sr1_ss			; numCalls = 4
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

ldne_ir1_sr1_sx			; numCalls = 1
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

ldne_ir1_sx_ss			; numCalls = 1
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

ldne_ir2_sx_ss			; numCalls = 1
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

left_sr2_sr2_pb			; numCalls = 3
	.module	modleft_sr2_sr2_pb
	tstb
	beq	_zero
	cmpb	r2
	bhs	_rts
	stab	r2
	rts
_zero
	pshx
	ldx	r2+1
	jsr	strrel
	pulx
	ldd	#$0100
	std	r2+1
	stab	r2
_rts
	rts
_fc_error
	ldab	#FC_ERROR
	jmp	error

midT_sr1_sr1_pb			; numCalls = 1
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

mul3_ir1_ix			; numCalls = 1
	.module	modmul3_ir1_ix
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

mul_ir1_ir1_ix			; numCalls = 1
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pb			; numCalls = 20
	.module	modmul_ir1_ir1_pb
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

next			; numCalls = 36
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

one_ix			; numCalls = 6
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongosub_ir1_is			; numCalls = 2
	.module	modongosub_ir1_is
	pulx
	ldd	r1
	bne	_fail
	ldab	r1+2
	decb
	cmpb	0,x
	bhs	_fail
	stx	tmp1
	stab	tmp2
	ldab	,x
	abx
	abx
	inx
	pshx
	ldaa	#3
	psha
	ldx	tmp1
	ldab	tmp2
	abx
	abx
	ldx	1,x
	jmp	,x
_fail
	ldab	,x
	abx
	abx
	jmp	1,x

ongoto_ir1_is			; numCalls = 1
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

peek_ir1_ir1			; numCalls = 1
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

poke_ir1_ix			; numCalls = 1
	.module	modpoke_ir1_ix
	ldab	2,x
	ldx	r1+1
	stab	,x
	rts

pr_sr1			; numCalls = 8
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 104
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 9
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 34
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 12
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 3
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 3
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

return			; numCalls = 52
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

right_sr1_sr1_pb			; numCalls = 1
	.module	modright_sr1_sr1_pb
	tstb
	beq	_zero
	stab	tmp1
	ldab	r1
	subb	tmp1
	bls	_rts
	clra
	addd	r1+1
	std	r1+1
	ldab	tmp1
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

shift_ir1_ir1_pb			; numCalls = 4
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 1
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 3
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

str_sr1_ix			; numCalls = 9
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

strcat_sr1_sr1_sr2			; numCalls = 1
	.module	modstrcat_sr1_sr1_sr2
	ldx	r2+1
	jsr	strrel
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	addb	r2
	bcs	_lserror
	stab	r1
	ldab	r2
	ldx	r2+1
	jmp	strcat
_lserror
	ldab	#LS_ERROR
	jmp	error

strinit_sr1_sr1			; numCalls = 1
	.module	modstrinit_sr1_sr1
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

sub_ir1_ir1_pb			; numCalls = 1
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

to_ip_ix			; numCalls = 2
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 26
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

val_fr1_sx			; numCalls = 4
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
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_AC	.block	3
INTVAR_AS	.block	3
INTVAR_BN	.block	3
INTVAR_BS	.block	3
INTVAR_C	.block	3
INTVAR_CL	.block	3
INTVAR_CN	.block	3
INTVAR_EF	.block	3
INTVAR_FE	.block	3
INTVAR_FP	.block	3
INTVAR_FW	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_MC	.block	3
INTVAR_N	.block	3
INTVAR_NC	.block	3
INTVAR_ND	.block	3
INTVAR_PL	.block	3
INTVAR_R	.block	3
INTVAR_RL	.block	3
INTVAR_SC	.block	3
INTVAR_SU	.block	3
INTVAR_T	.block	3
INTVAR_T0	.block	3
INTVAR_T1	.block	3
INTVAR_TM	.block	3
INTVAR_TP	.block	3
INTVAR_TW	.block	3
INTVAR_WI	.block	3
INTVAR_ZZ	.block	3
; String Variables
STRVAR_A	.block	3
STRVAR_AB	.block	3
STRVAR_BE	.block	3
STRVAR_C	.block	3
STRVAR_DN	.block	3
STRVAR_IN	.block	3
STRVAR_OK	.block	3
; Numeric Arrays
INTARR_L	.block	6	; dims=2
; String Arrays
STRARR_AC	.block	4	; dims=1
STRARR_CA	.block	4	; dims=1
STRARR_CL	.block	8	; dims=3
STRARR_DK	.block	4	; dims=1
STRARR_ND	.block	4	; dims=1
STRARR_SU	.block	4	; dims=1

; block ended by symbol
bes
	.end

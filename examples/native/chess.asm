; Assembly for chess.bas
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

LINE_0

	; REM COMPILED USING MCBASIC

LINE_10

	; CLEAR 500

	jsr	clear

	; DIM A(9,9),A,B,X,Y,A0,A1,A2,A3,A4,A5,A6,A7,A8,B1,B3,B4,B5,B6,B7,B8,H,M,N,P,I,J,K,T,W,Q,S

	ldab	#9
	jsr	ld_ir1_pb

	ldab	#9
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrdim2_ir1_ix

LINE_20

	; A=0

	ldx	#INTVAR_A
	jsr	clr_ix

	; B=0

	ldx	#INTVAR_B
	jsr	clr_ix

	; X=0

	ldx	#INTVAR_X
	jsr	clr_ix

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; A0=0

	ldx	#INTVAR_A0
	jsr	clr_ix

	; T=0

	ldx	#INTVAR_T
	jsr	clr_ix

	; A8=0

	ldx	#INTVAR_A8
	jsr	clr_ix

	; A2=0

	ldx	#INTVAR_A2
	jsr	clr_ix

	; A3=0

	ldx	#INTVAR_A3
	jsr	clr_ix

	; A4=0

	ldx	#INTVAR_A4
	jsr	clr_ix

	; B1=0

	ldx	#INTVAR_B1
	jsr	clr_ix

	; B6=0

	ldx	#FLTVAR_B6
	jsr	clr_fx

	; H=0

	ldx	#INTVAR_H
	jsr	clr_ix

	; M=0

	ldx	#INTVAR_M
	jsr	clr_ix

	; N=0

	ldx	#INTVAR_N
	jsr	clr_ix

	; P=0

	ldx	#INTVAR_P
	jsr	clr_ix

	; A5=0

	ldx	#INTVAR_A5
	jsr	clr_ix

	; I=1

	ldx	#INTVAR_I
	jsr	one_ix

	; B7=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_B7
	jsr	ld_fx_fr1

LINE_30

	; CLS

	jsr	cls

	; INPUT "DO YOU WANT INSTRUCTIONS"; IN$

	jsr	pr_ss
	.text	24, "DO YOU WANT INSTRUCTIONS"

	jsr	input

	ldx	#STRVAR_IN
	jsr	readbuf_sx

	jsr	ignxtra

	; IN$=LEFT$(IN$,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	ldx	#STRVAR_IN
	jsr	ld_sx_sr1

	; WHEN IN$="Y" GOSUB 2220

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_2220
	jsr	jsrne_ir1_ix

LINE_50

	; INPUT "YOUR NAME IS"; B$

	jsr	pr_ss
	.text	12, "YOUR NAME IS"

	jsr	input

	ldx	#STRVAR_B
	jsr	readbuf_sx

	jsr	ignxtra

	; IF B$="" THEN

	ldx	#STRVAR_B
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_55
	jsr	jmpeq_ir1_ix

	; B$=" HUMAN "

	jsr	ld_sr1_ss
	.text	7, " HUMAN "

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; GOTO 60

	ldx	#LINE_60
	jsr	goto_ix

LINE_55

	; IF LEN(B$)<6 THEN

	ldx	#STRVAR_B
	jsr	len_ir1_sx

	ldab	#6
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_57
	jsr	jmpeq_ir1_ix

	; B$=LEFT$("      ",6-LEN(B$))+B$

	jsr	ld_sr1_ss
	.text	6, "      "

	ldx	#STRVAR_B
	jsr	len_ir2_sx

	ldab	#6
	jsr	rsub_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_B
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

LINE_57

	; B$=LEFT$(B$,7)

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldab	#7
	jsr	left_sr1_sr1_pb

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

LINE_60

	; INPUT "LEVEL OF PLAY"; B8

	jsr	pr_ss
	.text	13, "LEVEL OF PLAY"

	jsr	input

	ldx	#FLTVAR_B8
	jsr	readbuf_fx

	jsr	ignxtra

	; IF B8<1 THEN

	ldx	#FLTVAR_B8
	ldab	#1
	jsr	ldlt_ir1_fx_pb

	ldx	#LINE_61
	jsr	jmpeq_ir1_ix

	; B8=1

	ldx	#FLTVAR_B8
	jsr	one_fx

	; GOTO 70

	ldx	#LINE_70
	jsr	goto_ix

LINE_61

	; IF B8>24 THEN

	ldab	#24
	ldx	#FLTVAR_B8
	jsr	ldlt_ir1_pb_fx

	ldx	#LINE_70
	jsr	jmpeq_ir1_ix

	; B8=24

	ldx	#FLTVAR_B8
	ldab	#24
	jsr	ld_fx_pb

LINE_70

	; B7=SHIFT(RND(0)+B8+1,-1)

	ldab	#0
	jsr	rnd_fr1_pb

	ldx	#FLTVAR_B8
	jsr	add_fr1_fr1_fx

	jsr	inc_fr1_fr1

	jsr	hlf_fr1_fr1

	ldx	#FLTVAR_B7
	jsr	ld_fx_fr1

	; PRINT "DO YOU WANT WHITE ";B$;

	jsr	pr_ss
	.text	18, "DO YOU WANT WHITE "

	ldx	#STRVAR_B
	jsr	pr_sx

	; INPUT IN$

	jsr	input

	ldx	#STRVAR_IN
	jsr	readbuf_sx

	jsr	ignxtra

	; GOSUB 790

	ldx	#LINE_790
	jsr	gosub_ix

	; IF LEFT$(IN$,1)<>"N" THEN

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	jsr	ldne_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_80
	jsr	jmpeq_ir1_ix

	; GOSUB 900

	ldx	#LINE_900
	jsr	gosub_ix

	; GOTO 190

	ldx	#LINE_190
	jsr	goto_ix

LINE_80

	; GOSUB 890

	ldx	#LINE_890
	jsr	gosub_ix

LINE_90

	; REM COMPUTER MOVE

LINE_100

	; F=-99

	ldx	#FLTVAR_F
	ldab	#-99
	jsr	ld_fx_nb

	; A0=0

	ldx	#INTVAR_A0
	jsr	clr_ix

	; FOR J=1 TO 8

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; FOR K=1 TO 8

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; IF A(J,K)=99 THEN

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrval2_ir1_ix_id

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_101
	jsr	jmpeq_ir1_ix

	; A6=J

	ldd	#INTVAR_A6
	ldx	#INTVAR_J
	jsr	ld_id_ix

	; A7=K

	ldd	#INTVAR_A7
	ldx	#INTVAR_K
	jsr	ld_id_ix

	; GOTO 120

	ldx	#LINE_120
	jsr	goto_ix

LINE_101

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_120

	; FOR X=1 TO 8

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; FOR Y=1 TO 8

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; IF A(X,Y)<0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_130
	jsr	jmpeq_ir1_ix

	; GOSUB 270

	ldx	#LINE_270
	jsr	gosub_ix

	; WHEN F>=B7 GOTO 150

	ldx	#FLTVAR_F
	ldd	#FLTVAR_B7
	jsr	ldge_ir1_fx_fd

	ldx	#LINE_150
	jsr	jmpne_ir1_ix

LINE_130

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; WHEN F>=-9 GOTO 150

	ldx	#FLTVAR_F
	ldab	#-9
	jsr	ldge_ir1_fx_nb

	ldx	#LINE_150
	jsr	jmpne_ir1_ix

LINE_140

	; GOTO 2200

	ldx	#LINE_2200
	jsr	goto_ix

LINE_150

	; A(R,U)=A(E,Q)

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_U
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Q
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; A(E,Q)=1

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Q
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; IF (A(R,U)=-2) AND (U=1) THEN

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_U
	jsr	arrval2_ir1_ix_id

	ldab	#-2
	jsr	ldeq_ir1_ir1_nb

	ldx	#INTVAR_U
	ldab	#1
	jsr	ldeq_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_160
	jsr	jmpeq_ir1_ix

	; A(R,U)=-9

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_U
	jsr	arrref2_ir1_ix_id

	ldab	#-9
	jsr	ld_ip_nb

LINE_160

	; X=R

	ldd	#INTVAR_X
	ldx	#INTVAR_R
	jsr	ld_id_ix

	; Y=U

	ldd	#INTVAR_Y
	ldx	#INTVAR_U
	jsr	ld_id_ix

	; A0=4

	ldx	#INTVAR_A0
	ldab	#4
	jsr	ld_ix_pb

	; GOSUB 270

	ldx	#LINE_270
	jsr	gosub_ix

	; PRINT @89, "MY MOVE";

	ldab	#89
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "MY MOVE"

	; PRINT @121, "   IS  ";

	ldab	#121
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "   IS  "

	; PRINT @155, CHR$(E+64);CHR$(Q+48);CHR$(R+64);CHR$(U+48);

	ldab	#155
	jsr	prat_pb

	ldx	#INTVAR_E
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	ldx	#INTVAR_Q
	ldab	#48
	jsr	add_ir1_ix_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	ldx	#INTVAR_R
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	ldx	#INTVAR_U
	ldab	#48
	jsr	add_ir1_ix_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

LINE_180

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; X=E

	ldd	#INTVAR_X
	ldx	#INTVAR_E
	jsr	ld_id_ix

	; Y=Q

	ldd	#INTVAR_Y
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; IF C=1 THEN

	ldx	#INTVAR_C
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_181
	jsr	jmpeq_ir1_ix

	; PRINT @185, " check ";

	ldab	#185
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " check "

	; C=0

	ldx	#INTVAR_C
	jsr	clr_ix

	; GOTO 190

	ldx	#LINE_190
	jsr	goto_ix

LINE_181

	; PRINT @185, "       ";

	ldab	#185
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "       "

LINE_185

	; REM PLAYER MOVE

LINE_190

	; IF X$="S" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_191
	jsr	jmpeq_ir1_ix

	; B7=RND(0)*3

	ldab	#0
	jsr	rnd_fr1_pb

	jsr	mul3_fr1_fr1

	ldx	#FLTVAR_B7
	jsr	ld_fx_fr1

	; GOSUB 2480

	ldx	#LINE_2480
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_191

	; GOSUB 1590

	ldx	#LINE_1590
	jsr	gosub_ix

	; IF X$="S" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_192
	jsr	jmpeq_ir1_ix

	; PRINT @25, " SELF- ";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " SELF- "

	; PRINT @57, "PLAYING";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "PLAYING"

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; GOTO 190

	ldx	#LINE_190
	jsr	goto_ix

LINE_192

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; B4=A

	ldd	#INTVAR_B4
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; B9=B

	ldd	#INTVAR_B9
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; B5=0

	ldx	#INTVAR_B5
	jsr	clr_ix

	; IF (A(X,Y)=2) AND (Y=5) AND (B=6) AND (A(A,B)=1) AND (ABS(A-X)=1) THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_Y
	ldab	#5
	jsr	ldeq_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_B
	ldab	#6
	jsr	ldeq_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir2_ix_id

	ldab	#1
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_A
	ldd	#INTVAR_X
	jsr	sub_ir2_ix_id

	jsr	abs_ir2_ir2

	ldab	#1
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_200
	jsr	jmpeq_ir1_ix

	; B5=1

	ldx	#INTVAR_B5
	jsr	one_ix

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_200

	; WHEN (X$="K") OR (X$="Q") GOTO 100

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "K"

	ldx	#STRVAR_X
	jsr	ldeq_ir2_sx_ss
	.text	1, "Q"

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_100
	jsr	jmpne_ir1_ix

LINE_210

	; A0=3

	ldx	#INTVAR_A0
	ldab	#3
	jsr	ld_ix_pb

	; GOSUB 250

	ldx	#LINE_250
	jsr	gosub_ix

	; IF D=0 THEN

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#LINE_220
	jsr	jmpne_ir1_ix

	; PRINT @25, "illegal";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "illegal"

	; PRINT @57, " move  ";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " move  "

	; FOR J=1 TO 1500

	ldx	#INTVAR_J
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; GOTO 190

	ldx	#LINE_190
	jsr	goto_ix

LINE_220

	; PRINT @345, "   OK  ";

	ldd	#345
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "   OK  "

	; A=B4

	ldd	#INTVAR_A
	ldx	#INTVAR_B4
	jsr	ld_id_ix

	; B=B9

	ldd	#INTVAR_B
	ldx	#INTVAR_B9
	jsr	ld_id_ix

	; A(A,B)=A(X,Y)

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; A(X,Y)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; X=A

	ldd	#INTVAR_X
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; Y=B

	ldd	#INTVAR_Y
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

LINE_230

	; IF (A(A,B)=2) AND (B=8) THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_B
	ldab	#8
	jsr	ldeq_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_240
	jsr	jmpeq_ir1_ix

	; GOSUB 2100

	ldx	#LINE_2100
	jsr	gosub_ix

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

LINE_240

	; IF B5=1 THEN

	ldx	#INTVAR_B5
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_241
	jsr	jmpeq_ir1_ix

	; A(A,B-1)=1

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	dec_ir2_ix

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; X=A

	ldd	#INTVAR_X
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; Y=B-1

	ldx	#INTVAR_B
	jsr	dec_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_241

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_245

	; REM COMPUTER PIECE MOVE

LINE_250

	; PRINT @31, "$";

	ldab	#31
	jsr	prat_pb

	jsr	pr_ss
	.text	1, "$"

	; ON A(X,Y) GOTO 0,480,0,380,330,0,280,0,330

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_0, LINE_480, LINE_0, LINE_380, LINE_330, LINE_0, LINE_280, LINE_0, LINE_330

LINE_255

	; REM KING MOVE

LINE_260

	; FOR A=X-1 TO X+1

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	jsr	to_ip_ir1

	; FOR B=Y-1 TO Y+1

	ldx	#INTVAR_Y
	jsr	dec_ir1_ix

	ldx	#INTVAR_B
	jsr	for_ix_ir1

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	jsr	to_ip_ir1

	; IF A(A,B)<>0 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldx	#LINE_261
	jsr	jmpeq_ir1_ix

	; GOSUB 650

	ldx	#LINE_650
	jsr	gosub_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_261

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_265

	; REM PLAYER PIECE MOVE

LINE_270

	; ON -A(X,Y) GOTO 0,530,0,380,330,0,280,0,330

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	neg_ir1_ir1

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_0, LINE_530, LINE_0, LINE_380, LINE_330, LINE_0, LINE_280, LINE_0, LINE_330

	; GOTO 260

	ldx	#LINE_260
	jsr	goto_ix

LINE_275

	; REM ROOK/QUEEN MOVE

LINE_280

	; B=Y

	ldd	#INTVAR_B
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; FOR A=X+1 TO 8

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldab	#8
	jsr	to_ip_pb

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_290
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_290

	; FOR A=X-1 TO 1 STEP -1

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_300
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_300

	; A=X

	ldd	#INTVAR_A
	ldx	#INTVAR_X
	jsr	ld_id_ix

	; FOR B=Y+1 TO 8

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldx	#INTVAR_B
	jsr	for_ix_ir1

	ldab	#8
	jsr	to_ip_pb

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_310

	; FOR B=Y-1 TO 1 STEP -1

	ldx	#INTVAR_Y
	jsr	dec_ir1_ix

	ldx	#INTVAR_B
	jsr	for_ix_ir1

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_311
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_311

	; RETURN

	jsr	return

LINE_320

	; REM BISHOP/QUEEN MOVE

LINE_330

	; B=Y

	ldd	#INTVAR_B
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; FOR A=X+1 TO 8

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldab	#8
	jsr	to_ip_pb

	; B+=1

	ldx	#INTVAR_B
	jsr	inc_ix_ix

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_340
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_340

	; B=Y

	ldd	#INTVAR_B
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; FOR A=X-1 TO 1 STEP -1

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; B-=1

	ldx	#INTVAR_B
	jsr	dec_ix_ix

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_350
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_350

	; B=Y

	ldd	#INTVAR_B
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; FOR A=X-1 TO 1 STEP -1

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; B+=1

	ldx	#INTVAR_B
	jsr	inc_ix_ix

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_360
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_360

	; B=Y

	ldd	#INTVAR_B
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; FOR A=X+1 TO 8

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTVAR_A
	jsr	for_ix_ir1

	ldab	#8
	jsr	to_ip_pb

	; B-=1

	ldx	#INTVAR_B
	jsr	dec_ix_ix

	; GOSUB 640

	ldx	#LINE_640
	jsr	gosub_ix

	; IF S=0 THEN

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#LINE_370
	jsr	jmpne_ir1_ix

	; NEXT

	jsr	next

LINE_370

	; WHEN ABS(A(X,Y))=9 GOTO 280

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	abs_ir1_ir1

	ldab	#9
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_280
	jsr	jmpne_ir1_ix

LINE_371

	; RETURN

	jsr	return

LINE_375

	; REM KNIGHT MOVE

LINE_380

	; A=X+2

	ldx	#INTVAR_X
	ldab	#2
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=Y+1

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; WHEN (A<9) AND (B<9) GOSUB 650

	ldx	#INTVAR_A
	ldab	#9
	jsr	ldlt_ir1_ix_pb

	ldx	#INTVAR_B
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_390

	; B-=2

	ldx	#INTVAR_B
	ldab	#2
	jsr	sub_ix_ix_pb

	; WHEN (B>0) AND (A<9) GOSUB 650

	ldab	#0
	ldx	#INTVAR_B
	jsr	ldlt_ir1_pb_ix

	ldx	#INTVAR_A
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_400

	; A-=4

	ldx	#INTVAR_A
	ldab	#4
	jsr	sub_ix_ix_pb

	; WHEN (A>0) AND (B>0) GOSUB 650

	ldab	#0
	ldx	#INTVAR_A
	jsr	ldlt_ir1_pb_ix

	ldab	#0
	ldx	#INTVAR_B
	jsr	ldlt_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_410

	; B+=2

	ldx	#INTVAR_B
	ldab	#2
	jsr	add_ix_ix_pb

	; WHEN (B<9) AND (A>0) GOSUB 650

	ldx	#INTVAR_B
	ldab	#9
	jsr	ldlt_ir1_ix_pb

	ldab	#0
	ldx	#INTVAR_A
	jsr	ldlt_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_420

	; A+=1

	ldx	#INTVAR_A
	jsr	inc_ix_ix

	; B+=1

	ldx	#INTVAR_B
	jsr	inc_ix_ix

	; WHEN (A>0) AND (A<9) AND (B<9) GOSUB 650

	ldab	#0
	ldx	#INTVAR_A
	jsr	ldlt_ir1_pb_ix

	ldx	#INTVAR_A
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_B
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_430

	; B-=4

	ldx	#INTVAR_B
	ldab	#4
	jsr	sub_ix_ix_pb

	; WHEN (B>0) AND (A>0) AND (A<9) GOSUB 650

	ldab	#0
	ldx	#INTVAR_B
	jsr	ldlt_ir1_pb_ix

	ldab	#0
	ldx	#INTVAR_A
	jsr	ldlt_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_A
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_440

	; A+=2

	ldx	#INTVAR_A
	ldab	#2
	jsr	add_ix_ix_pb

	; WHEN (A>0) AND (A<9) AND (B>0) GOSUB 650

	ldab	#0
	ldx	#INTVAR_A
	jsr	ldlt_ir1_pb_ix

	ldx	#INTVAR_A
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldab	#0
	ldx	#INTVAR_B
	jsr	ldlt_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jsrne_ir1_ix

LINE_450

	; B+=4

	ldx	#INTVAR_B
	ldab	#4
	jsr	add_ix_ix_pb

	; WHEN (B<9) AND (A>0) AND (A<9) GOTO 650

	ldx	#INTVAR_B
	ldab	#9
	jsr	ldlt_ir1_ix_pb

	ldab	#0
	ldx	#INTVAR_A
	jsr	ldlt_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_A
	ldab	#9
	jsr	ldlt_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_650
	jsr	jmpne_ir1_ix

LINE_451

	; RETURN

	jsr	return

LINE_475

	; REM PLAYER PAWN MOVE

LINE_480

	; A=X

	ldd	#INTVAR_A
	ldx	#INTVAR_X
	jsr	ld_id_ix

	; WHEN Y>2 GOTO 500

	ldab	#2
	ldx	#INTVAR_Y
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_500
	jsr	jmpne_ir1_ix

LINE_490

	; B=Y+1

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; IF A(A,B)=1 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_491
	jsr	jmpeq_ir1_ix

	; GOSUB 660

	ldx	#LINE_660
	jsr	gosub_ix

	; B+=1

	ldx	#INTVAR_B
	jsr	inc_ix_ix

	; IF A(A,B)=1 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_491
	jsr	jmpeq_ir1_ix

	; GOSUB 660

	ldx	#LINE_660
	jsr	gosub_ix

	; GOTO 510

	ldx	#LINE_510
	jsr	goto_ix

LINE_491

	; GOTO 510

	ldx	#LINE_510
	jsr	goto_ix

LINE_500

	; B=Y+1

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; WHEN A(A,B)=1 GOSUB 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_660
	jsr	jsrne_ir1_ix

LINE_510

	; A=X+1

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=Y+1

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; WHEN A(A,B)<0 GOSUB 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_660
	jsr	jsrne_ir1_ix

LINE_520

	; A-=2

	ldx	#INTVAR_A
	ldab	#2
	jsr	sub_ix_ix_pb

	; WHEN A(A,B)<0 GOTO 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_660
	jsr	jmpne_ir1_ix

LINE_521

	; RETURN

	jsr	return

LINE_525

	; REM COMPUTER PAWN MOVE

LINE_530

	; A=X

	ldd	#INTVAR_A
	ldx	#INTVAR_X
	jsr	ld_id_ix

	; WHEN Y<7 GOTO 550

	ldx	#INTVAR_Y
	ldab	#7
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_550
	jsr	jmpne_ir1_ix

LINE_540

	; B=Y-1

	ldx	#INTVAR_Y
	jsr	dec_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; IF A(A,B)=1 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_541
	jsr	jmpeq_ir1_ix

	; GOSUB 660

	ldx	#LINE_660
	jsr	gosub_ix

	; B-=1

	ldx	#INTVAR_B
	jsr	dec_ix_ix

	; IF A(A,B)=1 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_541
	jsr	jmpeq_ir1_ix

	; GOSUB 660

	ldx	#LINE_660
	jsr	gosub_ix

	; GOTO 560

	ldx	#LINE_560
	jsr	goto_ix

LINE_541

	; GOTO 560

	ldx	#LINE_560
	jsr	goto_ix

LINE_550

	; B=Y-1

	ldx	#INTVAR_Y
	jsr	dec_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; WHEN A(A,B)=1 GOSUB 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_660
	jsr	jsrne_ir1_ix

LINE_560

	; A=X-1

	ldx	#INTVAR_X
	jsr	dec_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=Y-1

	ldx	#INTVAR_Y
	jsr	dec_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; WHEN A(A,B)>1 GOSUB 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_660
	jsr	jsrne_ir1_ix

LINE_570

	; A+=2

	ldx	#INTVAR_A
	ldab	#2
	jsr	add_ix_ix_pb

	; WHEN A(A,B)>1 GOTO 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_660
	jsr	jmpne_ir1_ix

LINE_571

	; RETURN

	jsr	return

LINE_575

	; REM PROTECT ROUTINE

LINE_580

	; T=A(A,B)

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; IF T=-99 THEN

	ldx	#INTVAR_T
	ldab	#-99
	jsr	ldeq_ir1_ix_nb

	ldx	#LINE_590
	jsr	jmpeq_ir1_ix

	; B1=T

	ldd	#INTVAR_B1
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_590

	; A5=S

	ldd	#INTVAR_A5
	ldx	#INTVAR_S
	jsr	ld_id_ix

	; IF ABS(T)<=A(X,Y) THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_T
	jsr	abs_ir2_ix

	jsr	ldge_ir1_ir1_ir2

	ldx	#LINE_600
	jsr	jmpeq_ir1_ix

	; A(A,B)=A(X,Y)

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; A(X,Y)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; GOTO 610

	ldx	#LINE_610
	jsr	goto_ix

LINE_600

	; IF T<B1 THEN

	ldx	#INTVAR_T
	ldd	#INTVAR_B1
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_601
	jsr	jmpeq_ir1_ix

	; B1=T

	ldd	#INTVAR_B1
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; S=A5

	ldd	#INTVAR_S
	ldx	#INTVAR_A5
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_601

	; S=A5

	ldd	#INTVAR_S
	ldx	#INTVAR_A5
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_610

	; A1=X

	ldd	#INTVAR_A1
	ldx	#INTVAR_X
	jsr	ld_id_ix

	; A2=Y

	ldd	#INTVAR_A2
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; A3=A

	ldd	#INTVAR_A3
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; A4=B

	ldd	#INTVAR_A4
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; A8=T

	ldd	#INTVAR_A8
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; A0=2

	ldx	#INTVAR_A0
	ldab	#2
	jsr	ld_ix_pb

	; FOR X=1 TO 8

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; FOR Y=1 TO 8

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; IF A(X,Y)<0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_620
	jsr	jmpeq_ir1_ix

	; GOSUB 270

	ldx	#LINE_270
	jsr	gosub_ix

	; WHEN T=0 GOTO 630

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#LINE_630
	jsr	jmpeq_ir1_ix

LINE_620

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_630

	; X=A1

	ldd	#INTVAR_X
	ldx	#INTVAR_A1
	jsr	ld_id_ix

	; Y=A2

	ldd	#INTVAR_Y
	ldx	#INTVAR_A2
	jsr	ld_id_ix

	; A=A3

	ldd	#INTVAR_A
	ldx	#INTVAR_A3
	jsr	ld_id_ix

	; B=A4

	ldd	#INTVAR_B
	ldx	#INTVAR_A4
	jsr	ld_id_ix

	; A0=5

	ldx	#INTVAR_A0
	ldab	#5
	jsr	ld_ix_pb

	; A(X,Y)=A(A,B)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; A(A,B)=A8

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_A8
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; GOTO 600

	ldx	#LINE_600
	jsr	goto_ix

LINE_635

	; REM LEGAL MOVE CHECK

LINE_640

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; WHEN A(A,B)=1 GOTO 660

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_660
	jsr	jmpne_ir1_ix

LINE_641

	; IF A(A,B)=0 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldx	#LINE_642
	jsr	jmpne_ir1_ix

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; RETURN

	jsr	return

LINE_642

	; IF SGN(A(A,B))=SGN(A(X,Y)) THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir2_ix_id

	jsr	sgn_ir2_ir2

	jsr	ldeq_ir1_ir1_ir2

	ldx	#LINE_643
	jsr	jmpeq_ir1_ix

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; RETURN

	jsr	return

LINE_643

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; GOTO 660

	ldx	#LINE_660
	jsr	goto_ix

LINE_650

	; IF A(A,B)<>1 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_652
	jsr	jmpeq_ir1_ix

	; IF SGN(A(A,B))=SGN(A(X,Y)) THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir2_ix_id

	jsr	sgn_ir2_ir2

	jsr	ldeq_ir1_ir1_ir2

	ldx	#LINE_652
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_652

	; REM SPECIAL CONDITION CHECKS

LINE_653

	; REM A0=1  ADJUST MOVE VALUE IF PLAYER IN CHECK

LINE_654

	; REM A0=2  FROM PROTECT ROUTINE T=0, COMPUTER PIECE PROTECTED

LINE_655

	; REM A0=3  CHECK FOR LEGAL MOVE D=1, ILLEGAL MOVE

LINE_656

	; REM A0=4  C=1, PLAYER IN CHECK

LINE_657

	; REM A0=5  GOTO PROTECT ROUTINE IF UNDER ATTACK

LINE_658

	; REM A0=0  GOTO LOOK-AHEAD ROUTINE

LINE_660

	; PRINT @31, " ";

	ldab	#31
	jsr	prat_pb

	jsr	pr_ss
	.text	1, " "

	; ON A0 GOTO 670,680,690,700,710

	ldx	#INTVAR_A0
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_670, LINE_680, LINE_690, LINE_700, LINE_710

	; GOTO 720

	ldx	#LINE_720
	jsr	goto_ix

LINE_670

	; IF (A6=A) AND (A7=B) THEN

	ldx	#INTVAR_A6
	ldd	#INTVAR_A
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_A7
	ldd	#INTVAR_B
	jsr	ldeq_ir2_ix_id

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_671
	jsr	jmpeq_ir1_ix

	; B1+=1

	ldx	#INTVAR_B1
	jsr	inc_ix_ix

	; RETURN

	jsr	return

LINE_671

	; RETURN

	jsr	return

LINE_680

	; IF (A3=A) AND (A4=B) THEN

	ldx	#INTVAR_A3
	ldd	#INTVAR_A
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_A4
	ldd	#INTVAR_B
	jsr	ldeq_ir2_ix_id

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_681
	jsr	jmpeq_ir1_ix

	; T=0

	ldx	#INTVAR_T
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_681

	; RETURN

	jsr	return

LINE_690

	; IF (B4=A) AND (B9=B) THEN

	ldx	#INTVAR_B4
	ldd	#INTVAR_A
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_B9
	ldd	#INTVAR_B
	jsr	ldeq_ir2_ix_id

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_691
	jsr	jmpeq_ir1_ix

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

	; RETURN

	jsr	return

LINE_691

	; RETURN

	jsr	return

LINE_700

	; IF (A6=A) AND (A7=B) THEN

	ldx	#INTVAR_A6
	ldd	#INTVAR_A
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_A7
	ldd	#INTVAR_B
	jsr	ldeq_ir2_ix_id

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_701
	jsr	jmpeq_ir1_ix

	; C=1

	ldx	#INTVAR_C
	jsr	one_ix

	; RETURN

	jsr	return

LINE_701

	; RETURN

	jsr	return

LINE_710

	; WHEN A(A,B)<0 GOTO 580

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_580
	jsr	jmpne_ir1_ix

LINE_711

	; RETURN

	jsr	return

LINE_715

	; REM LOOK-AHEAD ROUTINE

LINE_720

	; B3=S

	ldd	#INTVAR_B3
	ldx	#INTVAR_S
	jsr	ld_id_ix

	; W=X

	ldd	#INTVAR_W
	ldx	#INTVAR_X
	jsr	ld_id_ix

	; M=Y

	ldd	#INTVAR_M
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; N=A

	ldd	#INTVAR_N
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; H=B

	ldd	#INTVAR_H
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; P=A(A,B)

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; A(A,B)=A(X,Y)

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; A(X,Y)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; B1=0

	ldx	#INTVAR_B1
	jsr	clr_ix

LINE_730

	; A0=5

	ldx	#INTVAR_A0
	ldab	#5
	jsr	ld_ix_pb

	; FOR X=1 TO 8

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; FOR Y=1 TO 8

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; WHEN A(X,Y)>1 GOSUB 250

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_250
	jsr	jsrne_ir1_ix

LINE_740

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; X=N

	ldd	#INTVAR_X
	ldx	#INTVAR_N
	jsr	ld_id_ix

	; Y=H

	ldd	#INTVAR_Y
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; A0=1

	ldx	#INTVAR_A0
	jsr	one_ix

	; GOSUB 270

	ldx	#LINE_270
	jsr	gosub_ix

	; A0=0

	ldx	#INTVAR_A0
	jsr	clr_ix

	; S=B3

	ldd	#INTVAR_S
	ldx	#INTVAR_B3
	jsr	ld_id_ix

	; X=W

	ldd	#INTVAR_X
	ldx	#INTVAR_W
	jsr	ld_id_ix

	; Y=M

	ldd	#INTVAR_Y
	ldx	#INTVAR_M
	jsr	ld_id_ix

	; A=N

	ldd	#INTVAR_A
	ldx	#INTVAR_N
	jsr	ld_id_ix

	; B=H

	ldd	#INTVAR_B
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; A(X,Y)=A(A,B)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; A(A,B)=P

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_745

	; REM EVALUATE MOVE

LINE_750

	; B6=1/(ABS(4.5-A)+ABS(4.5-B)+1)

	ldx	#FLT_4p50000
	ldd	#INTVAR_A
	jsr	sub_fr1_fx_id

	jsr	abs_fr1_fr1

	ldx	#FLT_4p50000
	ldd	#INTVAR_B
	jsr	sub_fr2_fx_id

	jsr	abs_fr2_fr2

	jsr	add_fr1_fr1_fr2

	jsr	inc_fr1_fr1

	jsr	inv_fr1_fr1

	ldx	#FLTVAR_B6
	jsr	ld_fx_fr1

	; IF (A(X,Y)<-2) AND (A(X,Y)>-9) THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#-2
	jsr	ldlt_ir1_ir1_nb

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir2_ix_id

	ldab	#-9
	jsr	ldlt_ir2_nb_ir2

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_760
	jsr	jmpeq_ir1_ix

	; B6+=(RND(0)/15)+(1/(ABS(A6-A)+ABS(A7-B)+5))

	ldab	#0
	jsr	rnd_fr1_pb

	ldab	#15
	jsr	div_fr1_fr1_pb

	ldx	#INTVAR_A6
	ldd	#INTVAR_A
	jsr	sub_ir2_ix_id

	jsr	abs_ir2_ir2

	ldx	#INTVAR_A7
	ldd	#INTVAR_B
	jsr	sub_ir3_ix_id

	jsr	abs_ir3_ir3

	jsr	add_ir2_ir2_ir3

	ldab	#5
	jsr	add_ir2_ir2_pb

	jsr	inv_fr2_ir2

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_B6
	jsr	add_fx_fx_fr1

LINE_760

	; G=P+B1+B6

	ldx	#INTVAR_P
	ldd	#INTVAR_B1
	jsr	add_ir1_ix_id

	ldx	#FLTVAR_B6
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_G
	jsr	ld_fx_fr1

	; IF P=99 THEN

	ldx	#INTVAR_P
	ldab	#99
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_770
	jsr	jmpeq_ir1_ix

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; PRINT @89, "       ";

	ldab	#89
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "       "

	; PRINT @121, " mate! ";

	ldab	#121
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " mate! "

	; PRINT @153, B$;

	ldab	#153
	jsr	prat_pb

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @185, "       ";

	ldab	#185
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "       "

	; GOTO 2205

	ldx	#LINE_2205
	jsr	goto_ix

LINE_770

	; IF G<=F THEN

	ldx	#FLTVAR_F
	ldd	#FLTVAR_G
	jsr	ldge_ir1_fx_fd

	ldx	#LINE_780
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_780

	; F=G

	ldd	#FLTVAR_F
	ldx	#FLTVAR_G
	jsr	ld_fd_fx

	; E=X

	ldd	#INTVAR_E
	ldx	#INTVAR_X
	jsr	ld_id_ix

	; Q=Y

	ldd	#INTVAR_Q
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; R=A

	ldd	#INTVAR_R
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; U=B

	ldd	#INTVAR_U
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_785

	; REM INITIALIZATION ROUTINE

LINE_790

	; CLS

	jsr	cls

	; FOR Y=8 TO 1 STEP -1

	ldx	#INTVAR_Y
	ldab	#8
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; FOR X=1 TO 8

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; READ A(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	read_ip

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_800

	; FOR J=1 TO 4

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; SB$=SB$+"������"

	ldx	#STRVAR_SB
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	6, "\x8C\x8C\x8C\x83\x83\x83"

	ldx	#STRVAR_SB
	jsr	ld_sx_sr1

LINE_801

	; SW$=SW$+"������"

	ldx	#STRVAR_SW
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	6, "\x83\x83\x83\x8C\x8C\x8C"

	ldx	#STRVAR_SW
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

LINE_810

	; FOR J=32 TO 416 STEP 128

	ldx	#INTVAR_J
	ldab	#32
	jsr	for_ix_pb

	ldd	#416
	jsr	to_ip_pw

	ldab	#128
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; PRINT @J, SB$;

	ldx	#INTVAR_J
	jsr	prat_ix

	ldx	#STRVAR_SB
	jsr	pr_sx

	; PRINT @J+64, SW$;

	ldx	#INTVAR_J
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldx	#STRVAR_SW
	jsr	pr_sx

	; NEXT

	jsr	next

	; M$=" A  B  C  D  E  F  G  H  "

	jsr	ld_sr1_ss
	.text	25, " A  B  C  D  E  F  G  H  "

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

LINE_811

	; FOR J=0 TO 24

	ldx	#INTVAR_J
	jsr	forclr_ix

	ldab	#24
	jsr	to_ip_pb

	; C3=ASC(MID$(M$,J+1,1))

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldx	#INTVAR_C3
	jsr	ld_ix_ir1

	; POKE J+16864,C3-(C3 AND 64)

	ldx	#INTVAR_J
	ldd	#16864
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_C3
	jsr	ld_ir2_ix

	ldab	#64
	jsr	and_ir2_ir2_pb

	ldx	#INTVAR_C3
	jsr	rsub_ir2_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT

	jsr	next

LINE_812

	; M$="8 7 6 5 4 3 2 1 "

	jsr	ld_sr1_ss
	.text	16, "8 7 6 5 4 3 2 1 "

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; FOR J=0 TO 15

	ldx	#INTVAR_J
	jsr	forclr_ix

	ldab	#15
	jsr	to_ip_pb

	; C3=ASC(MID$(M$,J+1,1))

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldx	#INTVAR_C3
	jsr	ld_ix_ir1

	; POKE SHIFT(J,5)+16408,C3-(C3 AND 64)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldd	#16408
	jsr	add_ir1_ir1_pw

	ldx	#INTVAR_C3
	jsr	ld_ir2_ix

	ldab	#64
	jsr	and_ir2_ir2_pb

	ldx	#INTVAR_C3
	jsr	rsub_ir2_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT

	jsr	next

LINE_813

	; RETURN

	jsr	return

LINE_820

LINE_830

LINE_840

LINE_850

LINE_860

LINE_885

	; REM PLAYER REQUESTS BLACK

LINE_890

	; I=-I

	ldx	#INTVAR_I
	jsr	neg_ix_ix

	; A(4,1)=99

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#99
	jsr	ld_ip_pb

	; A(5,1)=9

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#9
	jsr	ld_ip_pb

	; A(4,8)=-99

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#-99
	jsr	ld_ip_nb

	; A(5,8)=-9

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#-9
	jsr	ld_ip_nb

LINE_895

	; REM GRAPHIC DRIVER-FULL SCREEN

LINE_900

	; FOR Y=1 TO 8

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; FOR X=1 TO 8

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_905

	; REM GRAPHIC DRIVER-ONE PIECE

LINE_910

	; L=(X*3)+509-SHIFT(Y,6)

	ldx	#INTVAR_X
	jsr	mul3_ir1_ix

	ldd	#509
	jsr	add_ir1_ir1_pw

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#6
	jsr	shift_ir2_ir2_pb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; WHEN (X+Y)=SHIFT(INT(SHIFT(X+Y,-1)),1) GOTO 940

	ldx	#INTVAR_X
	ldd	#INTVAR_Y
	jsr	add_ir1_ix_id

	ldx	#INTVAR_X
	ldd	#INTVAR_Y
	jsr	add_ir2_ix_id

	jsr	hlf_fr2_ir2

	jsr	dbl_ir2_ir2

	jsr	ldeq_ir1_ir1_ir2

	ldx	#LINE_940
	jsr	jmpne_ir1_ix

LINE_920

	; IF (A(X,Y)*I)>0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_I
	jsr	mul_ir1_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_921
	jsr	jmpeq_ir1_ix

	; ON ABS(A(X,Y)) GOTO 960,970,0,980,990,0,1000,0,1010

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	abs_ir1_ir1

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_960, LINE_970, LINE_0, LINE_980, LINE_990, LINE_0, LINE_1000, LINE_0, LINE_1010

	; PRINT @L, " K ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " K "

	; RETURN

	jsr	return

LINE_921

	; ON ABS(A(X,Y)) GOTO 960,1040,0,1050,1060,0,1070,0,1080

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	abs_ir1_ir1

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_960, LINE_1040, LINE_0, LINE_1050, LINE_1060, LINE_0, LINE_1070, LINE_0, LINE_1080

	; PRINT @L, " k ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " k "

	; RETURN

	jsr	return

LINE_940

	; IF (A(X,Y)*I)>0 THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_I
	jsr	mul_ir1_ir1_ix

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_941
	jsr	jmpeq_ir1_ix

	; ON ABS(A(X,Y)) GOTO 1100,1110,0,1120,1130,0,1140,0,1150

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	abs_ir1_ir1

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_1100, LINE_1110, LINE_0, LINE_1120, LINE_1130, LINE_0, LINE_1140, LINE_0, LINE_1150

	; PRINT @L, "�K�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80K\x80"

	; RETURN

	jsr	return

LINE_941

	; ON ABS(A(X,Y)) GOTO 1100,1180,0,1190,1200,0,1210,0,1220

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	abs_ir1_ir1

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_1100, LINE_1180, LINE_0, LINE_1190, LINE_1200, LINE_0, LINE_1210, LINE_0, LINE_1220

	; PRINT @L, "�k�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80k\x80"

	; RETURN

	jsr	return

LINE_960

	; PRINT @L, "   ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "   "

	; RETURN

	jsr	return

LINE_970

	; PRINT @L, " P ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " P "

	; RETURN

	jsr	return

LINE_980

	; PRINT @L, " N ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " N "

	; RETURN

	jsr	return

LINE_990

	; PRINT @L, " B ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " B "

	; RETURN

	jsr	return

LINE_1000

	; PRINT @L, " R ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " R "

	; RETURN

	jsr	return

LINE_1010

	; PRINT @L, " Q ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " Q "

	; RETURN

	jsr	return

LINE_1040

	; PRINT @L, " p ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " p "

	; RETURN

	jsr	return

LINE_1050

	; PRINT @L, " n ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " n "

	; RETURN

	jsr	return

LINE_1060

	; PRINT @L, " b ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " b "

	; RETURN

	jsr	return

LINE_1070

	; PRINT @L, " r ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " r "

	; RETURN

	jsr	return

LINE_1080

	; PRINT @L, " q ";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, " q "

	; RETURN

	jsr	return

LINE_1100

	; PRINT @L, "���";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80\x80\x80"

	; RETURN

	jsr	return

LINE_1110

	; PRINT @L, "�P�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80P\x80"

	; RETURN

	jsr	return

LINE_1120

	; PRINT @L, "�N�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80N\x80"

	; RETURN

	jsr	return

LINE_1130

	; PRINT @L, "�B�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80B\x80"

	; RETURN

	jsr	return

LINE_1140

	; PRINT @L, "�R�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80R\x80"

	; RETURN

	jsr	return

LINE_1150

	; PRINT @L, "�Q�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80Q\x80"

	; RETURN

	jsr	return

LINE_1180

	; PRINT @L, "�p�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80p\x80"

	; RETURN

	jsr	return

LINE_1190

	; PRINT @L, "�n�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80n\x80"

	; RETURN

	jsr	return

LINE_1200

	; PRINT @L, "�b�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80b\x80"

	; RETURN

	jsr	return

LINE_1210

	; PRINT @L, "�r�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80r\x80"

	; RETURN

	jsr	return

LINE_1220

	; PRINT @L, "�q�";

	ldx	#INTVAR_L
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\x80q\x80"

	; RETURN

	jsr	return

LINE_1565

	; REM INPUT ROUTINE

LINE_1570

	; PRINT @25, "cannot ";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "cannot "

	; PRINT @57, "castle ";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "castle "

	; FOR J=1 TO 1500

	ldx	#INTVAR_J
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; GOTO 1590

	ldx	#LINE_1590
	jsr	goto_ix

LINE_1580

	; PRINT @25, " entry ";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " entry "

	; PRINT @57, " error ";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " error "

	; FOR J=1 TO 1500

	ldx	#INTVAR_J
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

LINE_1590

	; GOSUB 1790

	ldx	#LINE_1790
	jsr	gosub_ix

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; PRINT @217, "  your ";

	ldab	#217
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "  your "

	; PRINT @249, "  move ";

	ldab	#249
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "  move "

	; PRINT @281, B$;

	ldd	#281
	jsr	prat_pw

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @313, "";

	ldd	#313
	jsr	prat_pw

	jsr	pr_ss
	.text	0, ""

LINE_1591

	; INPUT IN$

	jsr	input

	ldx	#STRVAR_IN
	jsr	readbuf_sx

	jsr	ignxtra

	; X$=LEFT$(IN$,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	ldx	#STRVAR_X
	jsr	ld_sx_sr1

	; WHEN (X$>="A") AND (X$<="H") GOTO 1730

	ldx	#STRVAR_X
	jsr	ldge_ir1_sx_ss
	.text	1, "A"

	ldx	#STRVAR_X
	jsr	ldge_ir2_ss_sx
	.text	1, "H"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1730
	jsr	jmpne_ir1_ix

LINE_1630

	; IF X$="K" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "K"

	ldx	#LINE_1640
	jsr	jmpeq_ir1_ix

	; IF (A(5,1)=99) AND (A(8,1)=7) AND (A(6,1)<2) AND (A(7,1)<2) THEN

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix_ir2

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#7
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#6
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#7
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1640
	jsr	jmpeq_ir1_ix

	; A(5,1)=1

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; A(6,1)=7

	ldab	#6
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#7
	jsr	ld_ip_pb

	; A(7,1)=99

	ldab	#7
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#99
	jsr	ld_ip_pb

	; A(8,1)=1

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; GOTO 1800

	ldx	#LINE_1800
	jsr	goto_ix

LINE_1640

	; IF X$="Q" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_1650
	jsr	jmpeq_ir1_ix

	; IF (A(5,1)=99) AND (A(1,1)=7) AND (A(4,1)<2) AND (A(3,1)<2) THEN

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix_ir2

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#7
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#3
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1650
	jsr	jmpeq_ir1_ix

	; A(5,1)=1

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; A(4,1)=7

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#7
	jsr	ld_ip_pb

	; A(3,1)=99

	ldab	#3
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#99
	jsr	ld_ip_pb

	; A(1,1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; GOTO 1800

	ldx	#LINE_1800
	jsr	goto_ix

LINE_1650

	; IF X$="K" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "K"

	ldx	#LINE_1660
	jsr	jmpeq_ir1_ix

	; IF (A(4,1)=99) AND (A(1,1)=7) AND (A(3,1)<2) AND (A(2,1)<2) THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix_ir2

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#7
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#3
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1660
	jsr	jmpeq_ir1_ix

	; A(4,1)=1

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; A(3,1)=7

	ldab	#3
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#7
	jsr	ld_ip_pb

	; A(2,1)=99

	ldab	#2
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#99
	jsr	ld_ip_pb

	; A(1,1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; GOTO 1800

	ldx	#LINE_1800
	jsr	goto_ix

LINE_1660

	; IF X$="Q" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_1665
	jsr	jmpeq_ir1_ix

	; IF (A(4,1)=99) AND (A(8,1)=7) AND (A(5,1)<2) AND (A(6,1)<2) THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix_ir2

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#7
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#5
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#6
	jsr	ld_ir2_pb

	ldab	#1
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval2_ir2_ix_ir3

	ldab	#2
	jsr	ldlt_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1665
	jsr	jmpeq_ir1_ix

	; A(4,1)=1

	ldab	#4
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; A(5,1)=7

	ldab	#5
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#7
	jsr	ld_ip_pb

	; A(6,1)=99

	ldab	#6
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldab	#99
	jsr	ld_ip_pb

	; A(8,1)=1

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; GOTO 1800

	ldx	#LINE_1800
	jsr	goto_ix

LINE_1665

	; REM DECODE INPUT

LINE_1670

	; IF X$="X" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "X"

	ldx	#LINE_1680
	jsr	jmpeq_ir1_ix

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; PRINT @25, "  EX-  ";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "  EX-  "

	; PRINT @57, "CHANGE ";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "CHANGE "

	; GOSUB 2480

	ldx	#LINE_2480
	jsr	gosub_ix

	; GOSUB 1790

	ldx	#LINE_1790
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_1680

	; IF X$="S" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_1690
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_1690

	; WHEN X$="M" GOTO 1840

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "M"

	ldx	#LINE_1840
	jsr	jmpne_ir1_ix

LINE_1700

	; IF X$="I" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "I"

	ldx	#LINE_1710
	jsr	jmpeq_ir1_ix

	; GOSUB 2220

	ldx	#LINE_2220
	jsr	gosub_ix

	; GOSUB 810

	ldx	#LINE_810
	jsr	gosub_ix

	; GOSUB 900

	ldx	#LINE_900
	jsr	gosub_ix

	; GOTO 1590

	ldx	#LINE_1590
	jsr	goto_ix

LINE_1710

	; IF X$="L" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "L"

	ldx	#LINE_1720
	jsr	jmpeq_ir1_ix

	; GOSUB 2040

	ldx	#LINE_2040
	jsr	gosub_ix

	; GOTO 1590

	ldx	#LINE_1590
	jsr	goto_ix

LINE_1720

	; IF X$="P" THEN

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sx_ss
	.text	1, "P"

	ldx	#LINE_1721
	jsr	jmpeq_ir1_ix

	; RUN

	jsr	clear

	ldx	#LINE_0
	jsr	goto_ix

LINE_1721

	; GOTO 1580

	ldx	#LINE_1580
	jsr	goto_ix

LINE_1730

	; IF LEN(IN$)=4 THEN

	ldx	#STRVAR_IN
	jsr	len_ir1_sx

	ldab	#4
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1731
	jsr	jmpeq_ir1_ix

	; X=ASC(X$)-64

	ldx	#STRVAR_X
	jsr	asc_ir1_sx

	ldab	#64
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=ASC(MID$(IN$,2,1))-48

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldab	#48
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; A=ASC(MID$(IN$,3,1))-64

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#3
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldab	#64
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=ASC(MID$(IN$,4,1))-48

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#4
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldab	#48
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; GOTO 1740

	ldx	#LINE_1740
	jsr	goto_ix

LINE_1731

	; GOTO 1580

	ldx	#LINE_1580
	jsr	goto_ix

LINE_1740

	; WHEN (Y<1) OR (Y>8) OR (A<1) OR (A>8) OR (B<1) OR (B>8) GOTO 1580

	ldx	#INTVAR_Y
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldab	#8
	ldx	#INTVAR_Y
	jsr	ldlt_ir2_pb_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_A
	ldab	#1
	jsr	ldlt_ir2_ix_pb

	jsr	or_ir1_ir1_ir2

	ldab	#8
	ldx	#INTVAR_A
	jsr	ldlt_ir2_pb_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_B
	ldab	#1
	jsr	ldlt_ir2_ix_pb

	jsr	or_ir1_ir1_ir2

	ldab	#8
	ldx	#INTVAR_B
	jsr	ldlt_ir2_pb_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_1580
	jsr	jmpne_ir1_ix

LINE_1741

	; WHEN (A(X,Y)<2) OR (A(A,B)>1) GOTO 1580

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	ldab	#2
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrval2_ir2_ix_id

	ldab	#1
	jsr	ldlt_ir2_pb_ir2

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_1580
	jsr	jmpne_ir1_ix

LINE_1742

	; GOTO 1790

	ldx	#LINE_1790
	jsr	goto_ix

LINE_1790

	; PRINT @25, "       ";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "       "

	; PRINT @57, "       ";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "       "

	; RETURN

	jsr	return

LINE_1800

	; PRINT @313, "CASTLE ";

	ldd	#313
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "CASTLE "

	; PRINT @345, X$;"-SIDE ";

	ldd	#345
	jsr	prat_pw

	ldx	#STRVAR_X
	jsr	pr_sx

	jsr	pr_ss
	.text	6, "-SIDE "

	; GOSUB 1790

	ldx	#LINE_1790
	jsr	gosub_ix

	; GOTO 900

	ldx	#LINE_900
	jsr	goto_ix

LINE_1820

	; REM BLANK MESSAGE AREA

LINE_1830

	; FOR J=217 TO 345 STEP 32

	ldx	#INTVAR_J
	ldab	#217
	jsr	for_ix_pb

	ldd	#345
	jsr	to_ip_pw

	ldab	#32
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; PRINT @J, "       ";

	ldx	#INTVAR_J
	jsr	prat_ix

	jsr	pr_ss
	.text	7, "       "

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_1834

	; REM MODIFY ROUTINE

LINE_1835

	; PRINT @25, "modify ";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "modify "

	; PRINT @57, " error ";

	ldab	#57
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " error "

	; FOR J=1 TO 1500

	ldx	#INTVAR_J
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

LINE_1840

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; GOSUB 1790

	ldx	#LINE_1790
	jsr	gosub_ix

	; PRINT @25, "modify?";

	ldab	#25
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "modify?"

	; PRINT @57,

	ldab	#57
	jsr	prat_pb

	; INPUT IN$

	jsr	input

	ldx	#STRVAR_IN
	jsr	readbuf_sx

	jsr	ignxtra

	; M$=LEFT$(IN$,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; IF M$="Z" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "Z"

	ldx	#LINE_1850
	jsr	jmpeq_ir1_ix

	; GOSUB 1790

	ldx	#LINE_1790
	jsr	gosub_ix

	; GOTO 1590

	ldx	#LINE_1590
	jsr	goto_ix

LINE_1850

	; WHEN LEN(IN$)<>4 GOTO 1835

	ldx	#STRVAR_IN
	jsr	len_ir1_sx

	ldab	#4
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_1835
	jsr	jmpne_ir1_ix

LINE_1851

	; X=ASC(MID$(IN$,1,1))-64

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldab	#64
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=ASC(MID$(IN$,2,1))-48

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#2
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldab	#48
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; WHEN (X<1) OR (X>8) OR (Y<1) OR (Y>8) GOTO 1835

	ldx	#INTVAR_X
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldab	#8
	ldx	#INTVAR_X
	jsr	ldlt_ir2_pb_ix

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_Y
	ldab	#1
	jsr	ldlt_ir2_ix_pb

	jsr	or_ir1_ir1_ir2

	ldab	#8
	ldx	#INTVAR_Y
	jsr	ldlt_ir2_pb_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_1835
	jsr	jmpne_ir1_ix

LINE_1890

	; M$=MID$(IN$,3,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#3
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; WHEN (M$="C") OR (M$="P") OR (M$="E") GOTO 1900

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "C"

	ldx	#STRVAR_M
	jsr	ldeq_ir2_sx_ss
	.text	1, "P"

	jsr	or_ir1_ir1_ir2

	ldx	#STRVAR_M
	jsr	ldeq_ir2_sx_ss
	.text	1, "E"

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_1900
	jsr	jmpne_ir1_ix

LINE_1891

	; GOTO 1835

	ldx	#LINE_1835
	jsr	goto_ix

LINE_1900

	; V$=MID$(IN$,4,1)

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#4
	jsr	ld_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	ldx	#STRVAR_V
	jsr	ld_sx_sr1

	; WHEN (V$="S") OR (V$="P") OR (V$="N") OR (V$="B") OR (V$="R") OR (V$="Q") OR (V$="K") GOTO 1905

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#STRVAR_V
	jsr	ldeq_ir2_sx_ss
	.text	1, "P"

	jsr	or_ir1_ir1_ir2

	ldx	#STRVAR_V
	jsr	ldeq_ir2_sx_ss
	.text	1, "N"

	jsr	or_ir1_ir1_ir2

	ldx	#STRVAR_V
	jsr	ldeq_ir2_sx_ss
	.text	1, "B"

	jsr	or_ir1_ir1_ir2

	ldx	#STRVAR_V
	jsr	ldeq_ir2_sx_ss
	.text	1, "R"

	jsr	or_ir1_ir1_ir2

	ldx	#STRVAR_V
	jsr	ldeq_ir2_sx_ss
	.text	1, "Q"

	jsr	or_ir1_ir1_ir2

	ldx	#STRVAR_V
	jsr	ldeq_ir2_sx_ss
	.text	1, "K"

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_1905
	jsr	jmpne_ir1_ix

LINE_1901

	; GOTO 1835

	ldx	#LINE_1835
	jsr	goto_ix

LINE_1905

	; WHEN ABS(A(X,Y))=99 GOTO 1835

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_ix_id

	jsr	abs_ir1_ir1

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1835
	jsr	jmpne_ir1_ix

LINE_1910

	; IF V$="P" THEN

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "P"

	ldx	#LINE_1920
	jsr	jmpeq_ir1_ix

	; A(X,Y)=2

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldab	#2
	jsr	ld_ip_pb

	; GOTO 1980

	ldx	#LINE_1980
	jsr	goto_ix

LINE_1920

	; IF V$="N" THEN

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_1930
	jsr	jmpeq_ir1_ix

	; A(X,Y)=4

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldab	#4
	jsr	ld_ip_pb

	; GOTO 1980

	ldx	#LINE_1980
	jsr	goto_ix

LINE_1930

	; IF V$="B" THEN

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "B"

	ldx	#LINE_1940
	jsr	jmpeq_ir1_ix

	; A(X,Y)=5

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldab	#5
	jsr	ld_ip_pb

	; GOTO 1980

	ldx	#LINE_1980
	jsr	goto_ix

LINE_1940

	; IF V$="R" THEN

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "R"

	ldx	#LINE_1950
	jsr	jmpeq_ir1_ix

	; A(X,Y)=7

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldab	#7
	jsr	ld_ip_pb

	; GOTO 1980

	ldx	#LINE_1980
	jsr	goto_ix

LINE_1950

	; IF V$="Q" THEN

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_1960
	jsr	jmpeq_ir1_ix

	; A(X,Y)=9

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldab	#9
	jsr	ld_ip_pb

	; GOTO 1980

	ldx	#LINE_1980
	jsr	goto_ix

LINE_1960

	; IF V$="K" THEN

	ldx	#STRVAR_V
	jsr	ldeq_ir1_sx_ss
	.text	1, "K"

	ldx	#LINE_1961
	jsr	jmpeq_ir1_ix

	; A(X,Y)=99

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

LINE_1961

	; IF M$+V$="ES" THEN

	ldx	#STRVAR_M
	jsr	strinit_sr1_sx

	ldx	#STRVAR_V
	jsr	strcat_sr1_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	2, "ES"

	ldx	#LINE_1962
	jsr	jmpeq_ir1_ix

	; A(X,Y)=1

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; GOTO 1990

	ldx	#LINE_1990
	jsr	goto_ix

LINE_1962

	; GOTO 1835

	ldx	#LINE_1835
	jsr	goto_ix

LINE_1980

	; IF M$="C" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "C"

	ldx	#LINE_1990
	jsr	jmpeq_ir1_ix

	; A(X,Y)=-A(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	jsr	neg_ip_ip

LINE_1990

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; WHEN V$<>"K" GOTO 1840

	ldx	#STRVAR_V
	jsr	ldne_ir1_sx_ss
	.text	1, "K"

	ldx	#LINE_1840
	jsr	jmpne_ir1_ix

LINE_1991

	; FOR J=1 TO 8

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; FOR K=1 TO 8

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; IF (A(J,K)=A(X,Y)) AND ((X<>J) OR (Y<>K)) THEN

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ir2_ix

	ldx	#INTARR_A
	ldd	#INTVAR_Y
	jsr	arrval2_ir2_ix_id

	jsr	ldeq_ir1_ir1_ir2

	ldx	#INTVAR_X
	ldd	#INTVAR_J
	jsr	ldne_ir2_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_K
	jsr	ldne_ir3_ix_id

	jsr	or_ir2_ir2_ir3

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1992
	jsr	jmpeq_ir1_ix

	; A(J,K)=1

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; X=J

	ldd	#INTVAR_X
	ldx	#INTVAR_J
	jsr	ld_id_ix

	; Y=K

	ldd	#INTVAR_Y
	ldx	#INTVAR_K
	jsr	ld_id_ix

	; GOSUB 910

	ldx	#LINE_910
	jsr	gosub_ix

	; GOTO 1840

	ldx	#LINE_1840
	jsr	goto_ix

LINE_1992

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 1840

	ldx	#LINE_1840
	jsr	goto_ix

LINE_2035

	; REM CHANGE LEVEL OF PLAY

LINE_2040

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; PRINT @217, " LEVEL ";

	ldab	#217
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " LEVEL "

	; PRINT @251, STR$(B8);" ";

	ldab	#251
	jsr	prat_pb

	ldx	#FLTVAR_B8
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; PRINT @281, "change ";

	ldd	#281
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "change "

	; PRINT @313, "levels ";

	ldd	#313
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "levels "

	; PRINT @345,

	ldd	#345
	jsr	prat_pw

	; INPUT IN$

	jsr	input

	ldx	#STRVAR_IN
	jsr	readbuf_sx

	jsr	ignxtra

	; WHEN LEN(IN$)=0 GOTO 2040

	ldx	#STRVAR_IN
	jsr	len_ir1_sx

	ldx	#LINE_2040
	jsr	jmpeq_ir1_ix

LINE_2041

	; IF LEFT$(IN$,1)="N" THEN

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_2042
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_2042

	; WHEN LEFT$(IN$,1)="Y" GOTO 2040

	ldx	#STRVAR_IN
	jsr	ld_sr1_sx

	ldab	#1
	jsr	left_sr1_sr1_pb

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_2040
	jsr	jmpne_ir1_ix

LINE_2043

	; B8=VAL(IN$)

	ldx	#STRVAR_IN
	jsr	val_fr1_sx

	ldx	#FLTVAR_B8
	jsr	ld_fx_fr1

	; WHEN (B8<1) OR (B8>24) GOTO 2040

	ldx	#FLTVAR_B8
	ldab	#1
	jsr	ldlt_ir1_fx_pb

	ldab	#24
	ldx	#FLTVAR_B8
	jsr	ldlt_ir2_pb_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_2040
	jsr	jmpne_ir1_ix

LINE_2044

	; B7=SHIFT(B8,-1)

	ldx	#FLTVAR_B8
	jsr	hlf_fr1_fx

	ldx	#FLTVAR_B7
	jsr	ld_fx_fr1

	; RETURN

	jsr	return

LINE_2090

	; REM PROMOTE PLAYER PAWN

LINE_2100

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; PRINT @217, "  what ";

	ldab	#217
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "  what "

	; PRINT @249, " piece ";

	ldab	#249
	jsr	prat_pb

	jsr	pr_ss
	.text	7, " piece "

	; PRINT @281, " PNBRQ ";

	ldd	#281
	jsr	prat_pw

	jsr	pr_ss
	.text	7, " PNBRQ "

LINE_2110

	; PRINT @313,

	ldd	#313
	jsr	prat_pw

	; INPUT IN$

	jsr	input

	ldx	#STRVAR_IN
	jsr	readbuf_sx

	jsr	ignxtra

LINE_2120

	; IF IN$="P" THEN

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	1, "P"

	ldx	#LINE_2130
	jsr	jmpeq_ir1_ix

	; A(A,B)=2

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldab	#2
	jsr	ld_ip_pb

	; RETURN

	jsr	return

LINE_2130

	; IF IN$="N" THEN

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_2140
	jsr	jmpeq_ir1_ix

	; A(A,B)=4

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldab	#4
	jsr	ld_ip_pb

	; RETURN

	jsr	return

LINE_2140

	; IF IN$="B" THEN

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	1, "B"

	ldx	#LINE_2150
	jsr	jmpeq_ir1_ix

	; A(A,B)=5

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldab	#5
	jsr	ld_ip_pb

	; RETURN

	jsr	return

LINE_2150

	; IF IN$="R" THEN

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	1, "R"

	ldx	#LINE_2160
	jsr	jmpeq_ir1_ix

	; A(A,B)=7

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldab	#7
	jsr	ld_ip_pb

	; RETURN

	jsr	return

LINE_2160

	; IF IN$="Q" THEN

	ldx	#STRVAR_IN
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_2161
	jsr	jmpeq_ir1_ix

	; A(A,B)=9

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_B
	jsr	arrref2_ir1_ix_id

	ldab	#9
	jsr	ld_ip_pb

	; RETURN

	jsr	return

LINE_2161

	; GOTO 2110

	ldx	#LINE_2110
	jsr	goto_ix

LINE_2190

	; REM END OF GAME

LINE_2200

	; GOSUB 1830

	ldx	#LINE_1830
	jsr	gosub_ix

	; PRINT @89, "       ";

	ldab	#89
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "       "

	; PRINT @121, "  YOU  ";

	ldab	#121
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "  YOU  "

	; PRINT @153, "  WIN! ";

	ldab	#153
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "  WIN! "

	; PRINT @185, B$;

	ldab	#185
	jsr	prat_pb

	ldx	#STRVAR_B
	jsr	pr_sx

LINE_2205

	; PRINT @377, "HIT 'P'";

	ldd	#377
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "HIT 'P'"

	; PRINT @409, "TO PLAY";

	ldd	#409
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "TO PLAY"

	; PRINT @441, "OR 'B' ";

	ldd	#441
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "OR 'B' "

	; PRINT @473, "  FOR  ";

	ldd	#473
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "  FOR  "

	; PRINT @505, " BASIC";

	ldd	#505
	jsr	prat_pw

	jsr	pr_ss
	.text	6, " BASIC"

LINE_2210

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; IF A$="B" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "B"

	ldx	#LINE_2211
	jsr	jmpeq_ir1_ix

	; CLS

	jsr	cls

	; END

	jsr	progend

LINE_2211

	; IF A$="P" THEN

	ldx	#STRVAR_A
	jsr	ldeq_ir1_sx_ss
	.text	1, "P"

	ldx	#LINE_2212
	jsr	jmpeq_ir1_ix

	; RUN

	jsr	clear

	ldx	#LINE_0
	jsr	goto_ix

LINE_2212

	; GOTO 2210

	ldx	#LINE_2210
	jsr	goto_ix

LINE_2215

	; REM INSTRUCTIONS

LINE_2220

	; GOSUB 2330

	ldx	#LINE_2330
	jsr	gosub_ix

	; PRINT "***COMMANDS DURING PLAYER'S MOVE";

	jsr	pr_ss
	.text	32, "***COMMANDS DURING PLAYER'S MOVE"

	; PRINT "  K - TO CASTLE KING SIDE\r";

	jsr	pr_ss
	.text	26, "  K - TO CASTLE KING SIDE\r"

LINE_2221

	; PRINT "  Q - TO CASTLE QUEEN SIDE\r";

	jsr	pr_ss
	.text	27, "  Q - TO CASTLE QUEEN SIDE\r"

	; PRINT "  X - TO EXCHANGE BLACK/WHITE\r";

	jsr	pr_ss
	.text	30, "  X - TO EXCHANGE BLACK/WHITE\r"

	; PRINT "  S - TO LET COMPUTER SELF-PLAY\r";

	jsr	pr_ss
	.text	32, "  S - TO LET COMPUTER SELF-PLAY\r"

LINE_2230

	; PRINT "  M - TO modify THE BOARD, ENTER";

	jsr	pr_ss
	.text	32, "  M - TO modify THE BOARD, ENTER"

	; PRINT "      THE SQUARE FOLLOWED BY:\r";

	jsr	pr_ss
	.text	30, "      THE SQUARE FOLLOWED BY:\r"

LINE_2231

	; PRINT "      -C, P OR E FOR COMPUTER,\r";

	jsr	pr_ss
	.text	31, "      -C, P OR E FOR COMPUTER,\r"

	; PRINT "       PLAYER OR EMPTY\r";

	jsr	pr_ss
	.text	23, "       PLAYER OR EMPTY\r"

	; PRINT "      -S, P, N, B, Q OR K FOR\r";

	jsr	pr_ss
	.text	30, "      -S, P, N, B, Q OR K FOR\r"

	; PRINT "       SQUARE, PAWN, ETC.\r";

	jsr	pr_ss
	.text	26, "       SQUARE, PAWN, ETC.\r"

LINE_2240

	; PRINT "      (E.G.'D4PP', 'A8ES', ECT.)";

	jsr	pr_ss
	.text	32, "      (E.G.'D4PP', 'A8ES', ECT.)"

	; PRINT "  Z - TO ESCAPE modify\r";

	jsr	pr_ss
	.text	23, "  Z - TO ESCAPE modify\r"

	; GOSUB 2310

	ldx	#LINE_2310
	jsr	gosub_ix

LINE_2250

	; GOSUB 2330

	ldx	#LINE_2330
	jsr	gosub_ix

	; PRINT "***COMMANDS DURING PLAYER'S MOVE";

	jsr	pr_ss
	.text	32, "***COMMANDS DURING PLAYER'S MOVE"

	; PRINT "   I - TO GET INSTRUCTIONS\r";

	jsr	pr_ss
	.text	27, "   I - TO GET INSTRUCTIONS\r"

LINE_2251

	; PRINT "   L - TO CHANGE LEVEL OF PLAY\r";

	jsr	pr_ss
	.text	31, "   L - TO CHANGE LEVEL OF PLAY\r"

	; PRINT "   P - TO START NEW GAME\r";

	jsr	pr_ss
	.text	25, "   P - TO START NEW GAME\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_2260

	; PRINT "***TO PROMOTE TO P, N, B, R OR Q";

	jsr	pr_ss
	.text	32, "***TO PROMOTE TO P, N, B, R OR Q"

	; PRINT "   ENTER LETTER WHEN PROMPTED\r";

	jsr	pr_ss
	.text	30, "   ENTER LETTER WHEN PROMPTED\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_2261

	; PRINT "***TO MOVE, CAPTURE OR CAPTURE\r";

	jsr	pr_ss
	.text	31, "***TO MOVE, CAPTURE OR CAPTURE\r"

	; PRINT "   'EN PASSANT', SPECIFY FROM/TO";

	jsr	pr_ss
	.text	32, "   'EN PASSANT', SPECIFY FROM/TO"

	; PRINT "   SQUARES(E.G. 'B1C3')\r";

	jsr	pr_ss
	.text	24, "   SQUARES(E.G. 'B1C3')\r"

LINE_2270

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "***LEVELS OF PLAY ARE 1 THRU 24\r";

	jsr	pr_ss
	.text	32, "***LEVELS OF PLAY ARE 1 THRU 24\r"

	; GOSUB 2310

	ldx	#LINE_2310
	jsr	gosub_ix

LINE_2275

	; CLS

	jsr	cls

	; PRINT "        ***C.4 CHESS***\r";

	jsr	pr_ss
	.text	24, "        ***C.4 CHESS***\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "***COMPUTER ASSUMES MATE IF KING";

	jsr	pr_ss
	.text	32, "***COMPUTER ASSUMES MATE IF KING"

	; PRINT "   IS LEFT IN check\r";

	jsr	pr_ss
	.text	20, "   IS LEFT IN check\r"

LINE_2276

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "***IF entry error OR illegal\r";

	jsr	pr_ss
	.text	29, "***IF entry error OR illegal\r"

LINE_2277

	; PRINT "   move APPEAR, ENTER CORRECTED\r";

	jsr	pr_ss
	.text	32, "   move APPEAR, ENTER CORRECTED\r"

	; PRINT "   MOVE.  A MOVE MAY BE STARTED\r";

	jsr	pr_ss
	.text	32, "   MOVE.  A MOVE MAY BE STARTED\r"

LINE_2280

	; PRINT "   OVER BY FORCING AN ERROR\r";

	jsr	pr_ss
	.text	28, "   OVER BY FORCING AN ERROR\r"

LINE_2290

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "***YOU HAVE A CHOICE OF BLACK\r";

	jsr	pr_ss
	.text	30, "***YOU HAVE A CHOICE OF BLACK\r"

	; PRINT "   OR WHITE.  YOU ARE ALWAYS\r";

	jsr	pr_ss
	.text	29, "   OR WHITE.  YOU ARE ALWAYS\r"

LINE_2291

	; PRINT "   AT THE BOTTOM OF THE SCREEN\r";

	jsr	pr_ss
	.text	31, "   AT THE BOTTOM OF THE SCREEN\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; GOTO 2310

	ldx	#LINE_2310
	jsr	goto_ix

LINE_2300

	; WHEN INKEY$="" GOTO 2300

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_2300
	jsr	jmpne_ir1_ix

LINE_2301

	; RETURN

	jsr	return

LINE_2310

	; PRINT "HIT ANY KEY TO CONTINUE";

	jsr	pr_ss
	.text	23, "HIT ANY KEY TO CONTINUE"

LINE_2320

	; WHEN INKEY$="" GOTO 2320

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_2320
	jsr	jmpne_ir1_ix

LINE_2321

	; CLS

	jsr	cls

	; RETURN

	jsr	return

LINE_2330

	; CLS

	jsr	cls

	; PRINT "        ***C.4 CHESS***\r";

	jsr	pr_ss
	.text	24, "        ***C.4 CHESS***\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; RETURN

	jsr	return

LINE_2470

	; REM EXCHANGE COMPUTER/PLAYER  PIECES

LINE_2480

	; I=-I

	ldx	#INTVAR_I
	jsr	neg_ix_ix

	; FOR J=1 TO 4

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; FOR K=1 TO 8

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; L=A(J,K)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; IF A(9-J,9-K)=1 THEN

	ldab	#9
	ldx	#INTVAR_J
	jsr	sub_ir1_pb_ix

	ldab	#9
	ldx	#INTVAR_K
	jsr	sub_ir2_pb_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix_ir2

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_2481
	jsr	jmpeq_ir1_ix

	; A(J,K)=1

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; GOTO 2490

	ldx	#LINE_2490
	jsr	goto_ix

LINE_2481

	; A(J,K)=-A(9-J,9-K)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrref2_ir1_ix_id

	ldab	#9
	ldx	#INTVAR_J
	jsr	sub_ir1_pb_ix

	ldab	#9
	ldx	#INTVAR_K
	jsr	sub_ir2_pb_ix

	ldx	#INTARR_A
	jsr	arrval2_ir1_ix_ir2

	jsr	neg_ir1_ir1

	jsr	ld_ip_ir1

LINE_2490

	; IF L=1 THEN

	ldx	#INTVAR_L
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_2491
	jsr	jmpeq_ir1_ix

	; A(9-J,9-K)=1

	ldab	#9
	ldx	#INTVAR_J
	jsr	sub_ir1_pb_ix

	ldab	#9
	ldx	#INTVAR_K
	jsr	sub_ir2_pb_ix

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	jsr	one_ip

	; GOTO 2500

	ldx	#LINE_2500
	jsr	goto_ix

LINE_2491

	; A(9-J,9-K)=-L

	ldab	#9
	ldx	#INTVAR_J
	jsr	sub_ir1_pb_ix

	ldab	#9
	ldx	#INTVAR_K
	jsr	sub_ir2_pb_ix

	ldx	#INTARR_A
	jsr	arrref2_ir1_ix_ir2

	ldx	#INTVAR_L
	jsr	neg_ir1_ix

	jsr	ld_ip_ir1

LINE_2500

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 900

	ldx	#LINE_900
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

	.module	mdinvflt
; X = 1/Y
;   ENTRY  Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   1/Y in (0,x 1,x 2,x 3,x 4,x)
;          uses (5,x 6,x 7,x 8,x 9,x)
;          uses argv and tmp1-tmp4 (tmp4+1 unused)
invflt
	ldd	#0
	std	0,x
	std	3,x
	incb
	stab	2,x
	jmp	divflt

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

	.module	mdrpsbyte
; read DATA when records are purely signed bytes
; EXIT:  flt in tmp1+1, tmp2, tmp3
rpsbyte
	pshx
	ldx	DP_DATA
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldaa	,x
	inx
	stx	DP_DATA
	staa	tmp2+1
	clrb
	stab	tmp3
	stab	tmp3+1
	lsla
	sbcb	#0
	tba
	std	tmp1+1
	pulx
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

abs_fr1_fr1			; numCalls = 1
	.module	modabs_fr1_fr1
	ldaa	r1
	bpl	_rts
	ldx	#r1
	jmp	negx
_rts
	rts

abs_fr2_fr2			; numCalls = 1
	.module	modabs_fr2_fr2
	ldaa	r2
	bpl	_rts
	ldx	#r2
	jmp	negx
_rts
	rts

abs_ir1_ir1			; numCalls = 6
	.module	modabs_ir1_ir1
	ldaa	r1
	bpl	_rts
	ldx	#r1
	jmp	negxi
_rts
	rts

abs_ir2_ir2			; numCalls = 2
	.module	modabs_ir2_ir2
	ldaa	r2
	bpl	_rts
	ldx	#r2
	jmp	negxi
_rts
	rts

abs_ir2_ix			; numCalls = 1
	.module	modabs_ir2_ix
	ldaa	0,x
	bpl	_copy
	ldd	#0
	subd	1,x
	std	r2+1
	ldab	#0
	sbcb	0,x
	stab	r2
	rts
_copy
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

abs_ir3_ir3			; numCalls = 1
	.module	modabs_ir3_ir3
	ldaa	r3
	bpl	_rts
	ldx	#r3
	jmp	negxi
_rts
	rts

add_fr1_fr1_fr2			; numCalls = 2
	.module	modadd_fr1_fr1_fr2
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

add_fr1_fr1_fx			; numCalls = 1
	.module	modadd_fr1_fr1_fx
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

add_fr1_ir1_fx			; numCalls = 1
	.module	modadd_fr1_ir1_fx
	ldd	3,x
	std	r1+3
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fx_fx_fr1			; numCalls = 1
	.module	modadd_fx_fx_fr1
	ldd	3,x
	addd	r1+3
	std	3,x
	ldd	1,x
	adcb	r1+2
	adca	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ir1_ir1_pw			; numCalls = 2
	.module	modadd_ir1_ir1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 2
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

add_ir1_ix_pw			; numCalls = 1
	.module	modadd_ir1_ix_pw
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ir2_ir3			; numCalls = 1
	.module	modadd_ir2_ir2_ir3
	ldd	r2+1
	addd	r3+1
	std	r2+1
	ldab	r2
	adcb	r3
	stab	r2
	rts

add_ir2_ir2_pb			; numCalls = 1
	.module	modadd_ir2_ir2_pb
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_ir2_ix_id			; numCalls = 1
	.module	modadd_ir2_ix_id
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ix_ix_pb			; numCalls = 4
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 37
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir2_ir2_pb			; numCalls = 2
	.module	modand_ir2_ir2_pb
	andb	r2+2
	clra
	std	r2+1
	staa	r2
	rts

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

arrref2_ir1_ix_id			; numCalls = 30
	.module	modarrref2_ir1_ix_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix_ir2			; numCalls = 23
	.module	modarrref2_ir1_ix_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval2_ir1_ix_id			; numCalls = 47
	.module	modarrval2_ir1_ix_id
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

arrval2_ir1_ix_ir2			; numCalls = 6
	.module	modarrval2_ir1_ix_ir2
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

arrval2_ir2_ix_id			; numCalls = 6
	.module	modarrval2_ir2_ix_id
	jsr	getlw
	std	2+argv
	ldd	r2+1
	std	0+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval2_ir2_ix_ir3			; numCalls = 12
	.module	modarrval2_ir2_ix_ir3
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

asc_ir1_sr1			; numCalls = 7
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

chr_sr1_ir1			; numCalls = 4
	.module	modchr_sr1_ir1
	ldd	#$0100+(charpage>>8)
	std	r1
	rts

clear			; numCalls = 4
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

clr_fx			; numCalls = 1
	.module	modclr_fx
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

clr_ix			; numCalls = 25
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 6
	.module	modcls
	jmp	R_CLS

dbl_ir2_ir2			; numCalls = 1
	.module	moddbl_ir2_ir2
	ldx	#r2
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dec_ir1_ix			; numCalls = 11
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

dec_ix_ix			; numCalls = 3
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

div_fr1_fr1_pb			; numCalls = 1
	.module	moddiv_fr1_fr1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	divflt

for_ix_ir1			; numCalls = 10
	.module	modfor_ix_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 3
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 2
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

gosub_ix			; numCalls = 55
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 55
	.module	modgoto_ix
	ins
	ins
	jmp	,x

hlf_fr1_fr1			; numCalls = 1
	.module	modhlf_fr1_fr1
	ldx	#r1
	asr	0,x
	ror	1,x
	ror	2,x
	ror	3,x
	ror	4,x
	rts

hlf_fr1_fx			; numCalls = 1
	.module	modhlf_fr1_fx
	ldab	0,x
	asrb
	stab	r1
	ldd	1,x
	rora
	rorb
	std	r1+1
	ldd	3,x
	rora
	rorb
	std	r1+3
	rts

hlf_fr2_ir2			; numCalls = 1
	.module	modhlf_fr2_ir2
	asr	r2
	ror	r2+1
	ror	r2+2
	ldd	#0
	rora
	std	r2+3
	rts

ignxtra			; numCalls = 8
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inc_fr1_fr1			; numCalls = 2
	.module	modinc_fr1_fr1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 11
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

input			; numCalls = 8
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

inv_fr1_fr1			; numCalls = 1
	.module	modinv_fr1_fr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	ldd	r1+3
	std	3+argv
	std	r1+3
	ldx	#r1
	jmp	invflt

inv_fr2_ir2			; numCalls = 1
	.module	modinv_fr2_ir2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldd	#0
	std	3+argv
	std	r2+3
	ldx	#r2
	jmp	invflt

jmpeq_ir1_ix			; numCalls = 71
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

jmpne_ir1_ix			; numCalls = 36
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

jsrne_ir1_ix			; numCalls = 13
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

ld_fx_fr1			; numCalls = 7
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_nb			; numCalls = 1
	.module	modld_fx_nb
	stab	2,x
	ldd	#0
	std	3,x
	ldd	#-1
	std	0,x
	rts

ld_fx_pb			; numCalls = 1
	.module	modld_fx_pb
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
	rts

ld_id_ix			; numCalls = 53
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

ld_ip_ir1			; numCalls = 10
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_nb			; numCalls = 3
	.module	modld_ip_nb
	ldx	letptr
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ip_pb			; numCalls = 21
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 92
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

ld_ir1_pb			; numCalls = 27
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 9
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 44
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_pb			; numCalls = 12
	.module	modld_ir3_pb
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ix_ir1			; numCalls = 23
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

ld_sr1_ss			; numCalls = 4
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 16
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 12
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ir2			; numCalls = 4
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

ldeq_ir1_ir1_nb			; numCalls = 1
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

ldeq_ir1_ir1_pb			; numCalls = 18
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ix_id			; numCalls = 4
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

ldeq_ir1_ix_nb			; numCalls = 1
	.module	modldeq_ir1_ix_nb
	cmpb	2,x
	bne	_done
	ldd	0,x
	subd	#-1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ix_pb			; numCalls = 4
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

ldeq_ir1_sx_ss			; numCalls = 32
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

ldeq_ir2_ix_id			; numCalls = 4
	.module	modldeq_ir2_ix_id
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

ldeq_ir2_ix_pb			; numCalls = 4
	.module	modldeq_ir2_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_sx_ss			; numCalls = 9
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

ldge_ir1_fx_fd			; numCalls = 2
	.module	modldge_ir1_fx_fd
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
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_fx_nb			; numCalls = 1
	.module	modldge_ir1_fx_nb
	ldaa	#-1
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_ir1_ir2			; numCalls = 1
	.module	modldge_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
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

ldlt_ir1_fx_pb			; numCalls = 2
	.module	modldlt_ir1_fx_pb
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

ldlt_ir1_ir1_nb			; numCalls = 1
	.module	modldlt_ir1_ir1_nb
	ldaa	#-1
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#-1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 7
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

ldlt_ir1_ix_pb			; numCalls = 6
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

ldlt_ir1_pb_fx			; numCalls = 1
	.module	modldlt_ir1_pb_fx
	clra
	std	tmp1
	clrb
	subd	3,x
	ldd	tmp1
	sbcb	2,x
	sbca	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ir1			; numCalls = 5
	.module	modldlt_ir1_pb_ir1
	clra
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pb_ix			; numCalls = 6
	.module	modldlt_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_ir2_pb			; numCalls = 8
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

ldlt_ir2_ix_pb			; numCalls = 10
	.module	modldlt_ir2_ix_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_nb_ir2			; numCalls = 1
	.module	modldlt_ir2_nb_ir2
	subb	r2+1
	ldd	#-1
	sbcb	r2+1
	sbca	r2
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_pb_fx			; numCalls = 1
	.module	modldlt_ir2_pb_fx
	clra
	std	tmp1
	clrb
	subd	3,x
	ldd	tmp1
	sbcb	2,x
	sbca	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_pb_ir2			; numCalls = 1
	.module	modldlt_ir2_pb_ir2
	clra
	subd	r2+1
	ldab	#0
	sbcb	r2
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_pb_ix			; numCalls = 10
	.module	modldlt_ir2_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_pb			; numCalls = 2
	.module	modldne_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_sr1_ss			; numCalls = 1
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

ldne_ir2_ix_id			; numCalls = 1
	.module	modldne_ir2_ix_id
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
	jsr	getne
	std	r2+1
	stab	r2
	rts

ldne_ir3_ix_id			; numCalls = 1
	.module	modldne_ir3_ix_id
	std	tmp1
	ldab	0,x
	stab	r3
	ldd	1,x
	ldx	tmp1
	subd	1,x
	bne	_done
	ldab	r3
	cmpb	0,x
_done
	jsr	getne
	std	r3+1
	stab	r3
	rts

left_sr1_sr1_ir2			; numCalls = 1
	.module	modleft_sr1_sr1_ir2
	ldd	r2
	beq	_ok
	bmi	_fc_error
	bne	_rts
_ok
	ldab	r2+2
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

left_sr1_sr1_pb			; numCalls = 7
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

len_ir1_sx			; numCalls = 4
	.module	modlen_ir1_sx
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

len_ir2_sx			; numCalls = 1
	.module	modlen_ir2_sx
	ldab	0,x
	stab	r2+2
	ldd	#0
	std	r2
	rts

midT_sr1_sr1_pb			; numCalls = 9
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

mul3_fr1_fr1			; numCalls = 1
	.module	modmul3_fr1_fr1
	ldx	#r1
	jmp	mul3f

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

mul_ir1_ir1_ix			; numCalls = 2
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

neg_ip_ip			; numCalls = 1
	.module	modneg_ip_ip
	ldx	letptr
	jmp	negxi

neg_ir1_ir1			; numCalls = 3
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

neg_ir1_ix			; numCalls = 1
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

neg_ix_ix			; numCalls = 2
	.module	modneg_ix_ix
	jmp	negxi

next			; numCalls = 37
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

one_fx			; numCalls = 1
	.module	modone_fx
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

one_ip			; numCalls = 17
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 8
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongoto_ir1_is			; numCalls = 7
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

or_ir1_ir1_ir2			; numCalls = 19
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

or_ir2_ir2_ir3			; numCalls = 1
	.module	modor_ir2_ir2_ir3
	ldd	r3+1
	orab	r2+2
	oraa	r2+1
	std	r2+1
	ldab	r3
	orab	r2
	stab	r2
	rts

poke_ir1_ir2			; numCalls = 2
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

pr_sr1			; numCalls = 5
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 119
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 7
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

prat_ix			; numCalls = 28
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 37
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 15
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

read_ip			; numCalls = 1
	.module	modread_ip
	ldx	letptr
	jsr	rpsbyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

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

readbuf_sx			; numCalls = 7
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

return			; numCalls = 66
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

rnd_fr1_pb			; numCalls = 3
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

rsub_ir2_ir2_ix			; numCalls = 2
	.module	modrsub_ir2_ir2_ix
	ldd	1,x
	subd	r2+1
	std	r2+1
	ldab	0,x
	sbcb	r2
	stab	r2
	rts

rsub_ir2_ir2_pb			; numCalls = 1
	.module	modrsub_ir2_ir2_pb
	clra
	subd	r2+1
	std	r2+1
	ldab	#0
	sbcb	r2
	stab	r2
	rts

sgn_ir1_ir1			; numCalls = 2
	.module	modsgn_ir1_ir1
	ldab	r1
	bmi	_neg
	bne	_pos
	ldd	r1+1
	bne	_pos
	ldd	#0
	stab	r1+2
	bra	_done
_pos
	ldd	#1
	stab	r1+2
	clrb
	bra	_done
_neg
	ldd	#-1
	stab	r1+2
_done
	std	r1
	rts

sgn_ir2_ir2			; numCalls = 2
	.module	modsgn_ir2_ir2
	ldab	r2
	bmi	_neg
	bne	_pos
	ldd	r2+1
	bne	_pos
	ldd	#0
	stab	r2+2
	bra	_done
_pos
	ldd	#1
	stab	r2+2
	clrb
	bra	_done
_neg
	ldd	#-1
	stab	r2+2
_done
	std	r2
	rts

shift_ir1_ir1_pb			; numCalls = 1
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

shift_ir2_ir2_pb			; numCalls = 1
	.module	modshift_ir2_ir2_pb
	ldx	#r2
	jmp	shlint

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

str_sr1_fx			; numCalls = 1
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

strcat_sr1_sr1_sx			; numCalls = 2
	.module	modstrcat_sr1_sr1_sx
	stx	tmp1
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	ldx	tmp1
	addb	0,x
	bcs	_lserror
	stab	r1
	ldab	0,x
	ldx	1,x
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

strinit_sr1_sx			; numCalls = 3
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

sub_fr1_fx_id			; numCalls = 1
	.module	modsub_fr1_fx_id
	std	tmp1
	ldd	3,x
	std	r1+3
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

sub_fr2_fx_id			; numCalls = 1
	.module	modsub_fr2_fx_id
	std	tmp1
	ldd	3,x
	std	r2+3
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

sub_ir1_ir1_ir2			; numCalls = 1
	.module	modsub_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

sub_ir1_ir1_pb			; numCalls = 6
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

sub_ir1_pb_ix			; numCalls = 4
	.module	modsub_ir1_pb_ix
	subb	2,x
	stab	r1+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r1
	rts

sub_ir2_ix_id			; numCalls = 2
	.module	modsub_ir2_ix_id
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

sub_ir2_pb_ix			; numCalls = 4
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

sub_ix_ix_pb			; numCalls = 4
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

to_ip_ir1			; numCalls = 2
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 27
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 6
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

val_fr1_sx			; numCalls = 1
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
	.byte	-7, -4, -5, -9, -99, -5
	.byte	-4, -7, -2, -2, -2, -2
	.byte	-2, -2, -2, -2, 1, 1
	.byte	1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1
	.byte	2, 2, 2, 2, 2, 2
	.byte	2, 2, 7, 4, 5, 9
	.byte	99, 5, 4, 7
enddata


; fixed-point constants
FLT_4p50000	.byte	$00, $00, $04, $80, $00

; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_A0	.block	3
INTVAR_A1	.block	3
INTVAR_A2	.block	3
INTVAR_A3	.block	3
INTVAR_A4	.block	3
INTVAR_A5	.block	3
INTVAR_A6	.block	3
INTVAR_A7	.block	3
INTVAR_A8	.block	3
INTVAR_B	.block	3
INTVAR_B1	.block	3
INTVAR_B3	.block	3
INTVAR_B4	.block	3
INTVAR_B5	.block	3
INTVAR_B9	.block	3
INTVAR_C	.block	3
INTVAR_C3	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_H	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_M	.block	3
INTVAR_N	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_W	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
FLTVAR_B6	.block	5
FLTVAR_B7	.block	5
FLTVAR_B8	.block	5
FLTVAR_F	.block	5
FLTVAR_G	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
STRVAR_IN	.block	3
STRVAR_M	.block	3
STRVAR_SB	.block	3
STRVAR_SW	.block	3
STRVAR_V	.block	3
STRVAR_X	.block	3
; Numeric Arrays
INTARR_A	.block	6	; dims=2
; String Arrays

; block ended by symbol
bes
	.end

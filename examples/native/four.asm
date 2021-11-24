; Assembly for four.bas
; compiled with mcbasic -native

; Equates for MC-10 MICROCOLOR BASIC 1.0
; 
; Direct page equates
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

; Equate(s) for MCBASIC constants
charpage	.equ	$0100	; single-character string page.

; direct page registers
	.org	$80
strtcnt	.block	1
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

	; REM COPYRIGHT (C) T&D SOFTWARE 1985

LINE_2

	; REM *********************

LINE_4

	; REM * FOUR IN A ROW     *

LINE_6

	; REM *   BY:             *

LINE_8

	; REM * HAROLD SNYDER     *

LINE_10

	; REM * P.O. BOX 3330     *

LINE_12

	; REM * CHEYENNE,  WY     *

LINE_14

	; REM *            82003  *

LINE_16

	; REM *********************

LINE_18

	; REM 

LINE_20

	; CLEAR 500

	jsr	clear

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; PRINT @192, "    **** FOUR IN A ROW ****\r";

	ldab	#192
	jsr	prat_pb

	jsr	pr_ss
	.text	28, "    **** FOUR IN A ROW ****\r"

	; PRINT @256, "        BY HAROLD SNYDER\r";

	ldd	#256
	jsr	prat_pw

	jsr	pr_ss
	.text	25, "        BY HAROLD SNYDER\r"

	; FOR I=1 TO 999

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldd	#999
	jsr	to_ip_pw

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_22

	; E$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; FOR Z1=1 TO 13

	ldx	#INTVAR_Z1
	ldab	#1
	jsr	for_ix_pb

	ldab	#13
	jsr	to_ip_pb

	; E$=E$+"\x80"

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

	; C$="                               "

	jsr	ld_sr1_ss
	.text	31, "                               "

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; D$="\x80\x80"

	jsr	ld_sr1_ss
	.text	2, "\x80\x80"

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

LINE_23

	; X$="\x9C"

	jsr	ld_sr1_ss
	.text	1, "\x9C"

	ldx	#STRVAR_X
	jsr	ld_sx_sr1

	; O$="\xBC"

	jsr	ld_sr1_ss
	.text	1, "\xBC"

	ldx	#STRVAR_O
	jsr	ld_sx_sr1

	; H$="\x8C"

	jsr	ld_sr1_ss
	.text	1, "\x8C"

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; DIM B$(8,9),L(8),S(49),F(4),V(16),N(4)

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#9
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrdim2_ir1_sx

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrdim1_ir1_ix

	ldab	#49
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrdim1_ir1_ix

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_F
	jsr	arrdim1_ir1_ix

	ldab	#16
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrdim1_ir1_ix

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_N
	jsr	arrdim1_ir1_ix

	; MC=15360

	ldx	#INTVAR_MC
	ldd	#15360
	jsr	ld_ix_pw

LINE_24

LINE_26

LINE_28

	; FOR Z1=1 TO 16

	ldx	#INTVAR_Z1
	ldab	#1
	jsr	for_ix_pb

	ldab	#16
	jsr	to_ip_pb

	; READ V(Z1)

	ldx	#INTVAR_Z1
	jsr	ld_ir1_ix

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix

	jsr	read_ip

	; NEXT Z1

	ldx	#INTVAR_Z1
	jsr	nextvar_ix

	jsr	next

	; CLS

	jsr	cls

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "  DO YOU WANT INSTRUCTIONS Y/N\r";

	jsr	pr_ss
	.text	31, "  DO YOU WANT INSTRUCTIONS Y/N\r"

LINE_30

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; WHEN A$="N" GOTO 42

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_42
	jsr	jmpne_ir1_ix

LINE_32

	; WHEN A$="Y" GOTO 36

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_36
	jsr	jmpne_ir1_ix

LINE_34

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_36

	; CLS

	jsr	cls

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "THIS GAME CONSISTS OF STACKING  MARKERS(THE COMPUTER PLAYS RED) ON THE BOARD UNTIL ONE OF THE\r";

	jsr	pr_ss
	.text	94, "THIS GAME CONSISTS OF STACKING  MARKERS(THE COMPUTER PLAYS RED) ON THE BOARD UNTIL ONE OF THE\r"

LINE_37

	; PRINT "PLAYERS GETS FOUR IN A ROW.     THIS CAN BE DONE HORIZONTALLY,  VERTICALLY OR DIAGONALLY.\r";

	jsr	pr_ss
	.text	90, "PLAYERS GETS FOUR IN A ROW.     THIS CAN BE DONE HORIZONTALLY,  VERTICALLY OR DIAGONALLY.\r"

LINE_38

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "      HIT ANY KEY TO START\r";

	jsr	pr_ss
	.text	27, "      HIT ANY KEY TO START\r"

LINE_40

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; WHEN A$="" GOTO 40

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_40
	jsr	jmpne_ir1_ix

LINE_42

	; CLS

	jsr	cls

	; FOR I=1 TO 8

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldab	#8
	jsr	to_ip_pb

	; FOR J=1 TO 8

	ldx	#INTVAR_J
	ldab	#1
	jsr	for_ix_pb

	ldab	#8
	jsr	to_ip_pb

	; B$(I,J)=H$

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; FOR Z1=1 TO 8

	ldx	#INTVAR_Z1
	ldab	#1
	jsr	for_ix_pb

	ldab	#8
	jsr	to_ip_pb

	; L(Z1)=0

	ldx	#INTVAR_Z1
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; NEXT Z1

	ldx	#INTVAR_Z1
	jsr	nextvar_ix

	jsr	next

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "  DO YOU WANT TO GO FIRST Y/N\r";

	jsr	pr_ss
	.text	30, "  DO YOU WANT TO GO FIRST Y/N\r"

LINE_44

	; A$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; IF A$="N" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_46
	jsr	jmpeq_ir1_ix

	; M9=RND(2)+4

	ldab	#2
	jsr	irnd_ir1_pb

	ldab	#4
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_M9
	jsr	ld_ix_ir1

	; GOTO 102

	ldx	#LINE_102
	jsr	goto_ix

LINE_46

	; WHEN A$<>"Y" GOTO 44

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldne_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_44
	jsr	jmpne_ir1_ix

LINE_48

	; CLS

	jsr	cls

	; GOSUB 50

	ldx	#LINE_50
	jsr	gosub_ix

	; GOTO 54

	ldx	#LINE_54
	jsr	goto_ix

LINE_50

	; PRINT @0, "";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	0, ""

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT TAB(3);

	ldab	#3
	jsr	prtab_pb

	; PRINT E$;E$;"\r";

	ldx	#STRVAR_E
	jsr	pr_sx

	ldx	#STRVAR_E
	jsr	pr_sx

	jsr	pr_ss
	.text	1, "\r"

	; FOR I=8 TO 1 STEP -1

	ldx	#INTVAR_I
	ldab	#8
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; PRINT TAB(3);

	ldab	#3
	jsr	prtab_pb

	; FOR J=1 TO 9

	ldx	#INTVAR_J
	ldab	#1
	jsr	for_ix_pb

	ldab	#9
	jsr	to_ip_pb

	; PRINT D$;B$(I,J);

	ldx	#STRVAR_D
	jsr	pr_sx

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx

	jsr	pr_sr1

	; NEXT J

	ldx	#INTVAR_J
	jsr	nextvar_ix

	jsr	next

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_51

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

	; RETURN

	jsr	return

LINE_54

	; PRINT @416, "        ** YOUR MOVE **\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	24, "        ** YOUR MOVE **\r"

LINE_56

	; M$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; WHEN M$="" GOTO 56

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_56
	jsr	jmpne_ir1_ix

LINE_58

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; M=VAL(M$)

	ldx	#STRVAR_M
	jsr	val_fr1_sx

	ldx	#FLTVAR_M
	jsr	ld_fx_fr1

	; IF (M<1) OR (M>8) THEN

	ldx	#FLTVAR_M
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#FLTVAR_M
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_60
	jsr	jmpeq_ir1_ix

	; PRINT @416, "     ILLEGAL MOVE,TRY AGAIN\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	28, "     ILLEGAL MOVE,TRY AGAIN\r"

	; PRINT @448, C$;"\r";

	ldd	#448
	jsr	prat_pw

	ldx	#STRVAR_C
	jsr	pr_sx

	jsr	pr_ss
	.text	1, "\r"

	; SOUND 40,2

	ldab	#40
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOTO 56

	ldx	#LINE_56
	jsr	goto_ix

LINE_60

	; L=L(M)

	ldx	#FLTVAR_M
	jsr	ld_fr1_fx

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; IF L>7 THEN

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTVAR_L
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_62
	jsr	jmpeq_ir1_ix

	; PRINT @416, "     ILLEGAL MOVE,TRY AGAIN\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	28, "     ILLEGAL MOVE,TRY AGAIN\r"

	; PRINT @448, C$;"\r";

	ldd	#448
	jsr	prat_pw

	ldx	#STRVAR_C
	jsr	pr_sx

	jsr	pr_ss
	.text	1, "\r"

	; SOUND 40,2

	ldab	#40
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOTO 56

	ldx	#LINE_56
	jsr	goto_ix

LINE_62

	; L(M)=L+1

	ldx	#FLTVAR_M
	jsr	ld_fr1_fx

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

	; L+=1

	ldx	#INTVAR_L
	ldab	#1
	jsr	add_ix_ix_pb

	; B$(L,M)=X$

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#FLTVAR_M
	jsr	ld_fr2_fx

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx

	ldx	#STRVAR_X
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

	; GOSUB 50

	ldx	#LINE_50
	jsr	gosub_ix

	; PRINT @416, "         ** THINKING **\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	24, "         ** THINKING **\r"

	; PRINT @448, C$;"\r";

	ldd	#448
	jsr	prat_pw

	ldx	#STRVAR_C
	jsr	pr_sx

	jsr	pr_ss
	.text	1, "\r"

	; P$=X$

	ldx	#STRVAR_X
	jsr	ld_sr1_sx

	ldx	#STRVAR_P
	jsr	ld_sx_sr1

	; GOSUB 110

	ldx	#LINE_110
	jsr	gosub_ix

	; FOR Z=1 TO 4

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

LINE_63

	; WHEN S(Z)<4 GOTO 66

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	ldab	#4
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_66
	jsr	jmpne_ir1_ix

LINE_64

	; PRINT @416, "         ** YOU WIN **\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	23, "         ** YOU WIN **\r"

	; PRINT @448, C$;"\r";

	ldd	#448
	jsr	prat_pw

	ldx	#STRVAR_C
	jsr	pr_sx

	jsr	pr_ss
	.text	1, "\r"

	; GOTO 134

	ldx	#LINE_134
	jsr	goto_ix

LINE_66

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

	; M9=0

	ldx	#INTVAR_M9
	ldab	#0
	jsr	ld_ix_pb

	; V1=0

	ldx	#INTVAR_V1
	ldab	#0
	jsr	ld_ix_pb

	; N1=1

	ldx	#INTVAR_N1
	ldab	#1
	jsr	ld_ix_pb

	; FOR M4=1 TO 8

	ldx	#INTVAR_M4
	ldab	#1
	jsr	for_ix_pb

	ldab	#8
	jsr	to_ip_pb

	; L=L(M4)+1

	ldx	#INTVAR_M4
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; WHEN L>8 GOTO 98

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#INTVAR_L
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_98
	jsr	jmpne_ir1_ix

LINE_68

	; V=1

	ldx	#INTVAR_V
	ldab	#1
	jsr	ld_ix_pb

	; P$=O$

	ldx	#STRVAR_O
	jsr	ld_sr1_sx

	ldx	#STRVAR_P
	jsr	ld_sx_sr1

	; W=0

	ldx	#INTVAR_W
	ldab	#0
	jsr	ld_ix_pb

	; M=M4

	ldx	#INTVAR_M4
	jsr	ld_ir1_ix

	ldx	#FLTVAR_M
	jsr	ld_fx_ir1

LINE_70

	; GOSUB 110

	ldx	#LINE_110
	jsr	gosub_ix

	; FOR Z1=1 TO 4

	ldx	#INTVAR_Z1
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

	; N(Z1)=0

	ldx	#INTVAR_Z1
	jsr	ld_ir1_ix

	ldx	#INTARR_N
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; NEXT Z1

	ldx	#INTVAR_Z1
	jsr	nextvar_ix

	jsr	next

	; FOR Z=1 TO 4

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

	; S=S(Z)

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; WHEN (S-W)>3 GOTO 104

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTVAR_S
	jsr	ld_ir2_ix

	ldx	#INTVAR_W
	jsr	sub_ir2_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_104
	jsr	jmpne_ir1_ix

LINE_72

	; T=F(Z)+S

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; WHEN T<4 GOTO 76

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_76
	jsr	jmpne_ir1_ix

LINE_74

	; V+=4

	ldx	#INTVAR_V
	ldab	#4
	jsr	add_ix_ix_pb

	; N(S)+=1

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#INTARR_N
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	add_ip_ip_pb

LINE_76

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

	; FOR I=1 TO 4

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

	; N=N(I)-1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_N
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_N
	jsr	ld_ix_ir1

	; WHEN N=-1 GOTO 80

	ldx	#INTVAR_N
	jsr	ld_ir1_ix

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_80
	jsr	jmpne_ir1_ix

LINE_78

	; I1=SHIFT(W,3)+SHIFT(SGN(N),2)+I

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#3
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_N
	jsr	sgn_ir2_ix

	ldab	#2
	jsr	shift_ir2_ir2_pb

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_I
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_I1
	jsr	ld_ix_ir1

	; V+=(V(SHIFT(W,3)+1)*N)+V(I1)

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#3
	jsr	shift_ir1_ir1_pb

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_N
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_I1
	jsr	ld_ir2_ix

	ldx	#INTARR_V
	jsr	arrval1_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_V
	jsr	add_ix_ix_ir1

LINE_80

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; WHEN W=1 GOTO 84

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_84
	jsr	jmpne_ir1_ix

LINE_82

	; W=1

	ldx	#INTVAR_W
	ldab	#1
	jsr	ld_ix_pb

	; P$=X$

	ldx	#STRVAR_X
	jsr	ld_sr1_sx

	ldx	#STRVAR_P
	jsr	ld_sx_sr1

	; GOTO 70

	ldx	#LINE_70
	jsr	goto_ix

LINE_84

	; L+=1

	ldx	#INTVAR_L
	ldab	#1
	jsr	add_ix_ix_pb

	; WHEN L>8 GOTO 90

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#INTVAR_L
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_90
	jsr	jmpne_ir1_ix

LINE_86

	; GOSUB 110

	ldx	#LINE_110
	jsr	gosub_ix

	; FOR Z=1 TO 4

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

	; IF S(Z)>3 THEN

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#INTARR_S
	jsr	arrval1_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_88
	jsr	jmpeq_ir1_ix

	; V=2

	ldx	#INTVAR_V
	ldab	#2
	jsr	ld_ix_pb

LINE_88

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

LINE_90

	; WHEN V<V1 GOTO 98

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_V1
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_98
	jsr	jmpne_ir1_ix

LINE_92

	; IF V>V1 THEN

	ldx	#INTVAR_V1
	jsr	ld_ir1_ix

	ldx	#INTVAR_V
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_94
	jsr	jmpeq_ir1_ix

	; N1=1

	ldx	#INTVAR_N1
	ldab	#1
	jsr	ld_ix_pb

	; GOTO 96

	ldx	#LINE_96
	jsr	goto_ix

LINE_94

	; N1+=1

	ldx	#INTVAR_N1
	ldab	#1
	jsr	add_ix_ix_pb

LINE_96

	; V1=V

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_V1
	jsr	ld_ix_ir1

	; M9=M4

	ldx	#INTVAR_M4
	jsr	ld_ir1_ix

	ldx	#INTVAR_M9
	jsr	ld_ix_ir1

LINE_98

	; NEXT M4

	ldx	#INTVAR_M4
	jsr	nextvar_ix

	jsr	next

	; WHEN M<>0 GOTO 102

	ldx	#FLTVAR_M
	jsr	ld_fr1_fx

	ldab	#0
	jsr	ldne_ir1_fr1_pb

	ldx	#LINE_102
	jsr	jmpne_ir1_ix

LINE_100

	; PRINT @416, "         ** TIE GAME **\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	24, "         ** TIE GAME **\r"

	; GOTO 134

	ldx	#LINE_134
	jsr	goto_ix

LINE_102

	; M=M9

	ldx	#INTVAR_M9
	jsr	ld_ir1_ix

	ldx	#FLTVAR_M
	jsr	ld_fx_ir1

LINE_104

	; PRINT @448, "         MY MOVE WAS";STR$(M);" \r";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	20, "         MY MOVE WAS"

	ldx	#FLTVAR_M
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; L=L(M)+1

	ldx	#FLTVAR_M
	jsr	ld_fr1_fx

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; L(M)+=1

	ldx	#FLTVAR_M
	jsr	ld_fr1_fx

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	add_ip_ip_pb

	; B$(L,M)=O$

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#FLTVAR_M
	jsr	ld_fr2_fx

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx

	ldx	#STRVAR_O
	jsr	ld_sr1_sx

	jsr	ld_sp_sr1

	; P$=O$

	ldx	#STRVAR_O
	jsr	ld_sr1_sx

	ldx	#STRVAR_P
	jsr	ld_sx_sr1

	; GOSUB 50

	ldx	#LINE_50
	jsr	gosub_ix

	; GOSUB 110

	ldx	#LINE_110
	jsr	gosub_ix

	; FOR Z=1 TO 4

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldab	#4
	jsr	to_ip_pb

	; WHEN S(Z)<4 GOTO 108

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	ldab	#4
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_108
	jsr	jmpne_ir1_ix

LINE_106

	; PRINT @416, "      ** COMPUTER WINS **\r";

	ldd	#416
	jsr	prat_pw

	jsr	pr_ss
	.text	26, "      ** COMPUTER WINS **\r"

	; GOTO 134

	ldx	#LINE_134
	jsr	goto_ix

LINE_108

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

	; GOTO 54

	ldx	#LINE_54
	jsr	goto_ix

LINE_110

	; Q$=X$

	ldx	#STRVAR_X
	jsr	ld_sr1_sx

	ldx	#STRVAR_Q
	jsr	ld_sx_sr1

	; IF P$=X$ THEN

	ldx	#STRVAR_P
	jsr	ld_sr1_sx

	ldx	#STRVAR_X
	jsr	ldeq_ir1_sr1_sx

	ldx	#LINE_112
	jsr	jmpeq_ir1_ix

	; Q$=O$

	ldx	#STRVAR_O
	jsr	ld_sr1_sx

	ldx	#STRVAR_Q
	jsr	ld_sx_sr1

LINE_112

	; D2=1

	ldx	#INTVAR_D2
	ldab	#1
	jsr	ld_ix_pb

	; D1=0

	ldx	#INTVAR_D1
	ldab	#0
	jsr	ld_ix_pb

	; Z=0

	ldx	#INTVAR_Z
	ldab	#0
	jsr	ld_ix_pb

	; GOSUB 114

	ldx	#LINE_114
	jsr	gosub_ix

	; D1=1

	ldx	#INTVAR_D1
	ldab	#1
	jsr	ld_ix_pb

	; D2=1

	ldx	#INTVAR_D2
	ldab	#1
	jsr	ld_ix_pb

	; GOSUB 114

	ldx	#LINE_114
	jsr	gosub_ix

	; D2=0

	ldx	#INTVAR_D2
	ldab	#0
	jsr	ld_ix_pb

	; D1=1

	ldx	#INTVAR_D1
	ldab	#1
	jsr	ld_ix_pb

	; GOSUB 114

	ldx	#LINE_114
	jsr	gosub_ix

	; D2=-1

	ldx	#INTVAR_D2
	ldab	#-1
	jsr	ld_ix_nb

	; D1=1

	ldx	#INTVAR_D1
	ldab	#1
	jsr	ld_ix_pb

	; GOSUB 114

	ldx	#LINE_114
	jsr	gosub_ix

	; RETURN

	jsr	return

LINE_114

	; D=1

	ldx	#INTVAR_D
	ldab	#1
	jsr	ld_ix_pb

	; S=1

	ldx	#INTVAR_S
	ldab	#1
	jsr	ld_ix_pb

	; T=0

	ldx	#INTVAR_T
	ldab	#0
	jsr	ld_ix_pb

	; Z+=1

	ldx	#INTVAR_Z
	ldab	#1
	jsr	add_ix_ix_pb

LINE_116

	; C=0

	ldx	#INTVAR_C
	ldab	#0
	jsr	ld_ix_pb

	; FOR K=1 TO 3

	ldx	#INTVAR_K
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; M5=(K*D1)+M

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_D1
	jsr	mul_ir1_ir1_ix

	ldx	#FLTVAR_M
	jsr	add_fr1_ir1_fx

	ldx	#FLTVAR_M5
	jsr	ld_fx_fr1

	; L1=(K*D2)+L

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_D2
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L1
	jsr	ld_ix_ir1

	; WHEN (M5<1) OR (L1<1) OR (M5>8) OR (L1>8) GOTO 128

	ldx	#FLTVAR_M5
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldx	#INTVAR_L1
	jsr	ld_ir2_ix

	ldab	#1
	jsr	ldlt_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#FLTVAR_M5
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#INTVAR_L1
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_128
	jsr	jmpne_ir1_ix

LINE_118

	; B$=B$(L1,M5)

	ldx	#INTVAR_L1
	jsr	ld_ir1_ix

	ldx	#FLTVAR_M5
	jsr	ld_fr2_fx

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; WHEN C=0 GOTO 124

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_124
	jsr	jmpne_ir1_ix

LINE_120

	; IF B$=Q$ THEN

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldx	#STRVAR_Q
	jsr	ldeq_ir1_sr1_sx

	ldx	#LINE_122
	jsr	jmpeq_ir1_ix

	; K=3

	ldx	#INTVAR_K
	ldab	#3
	jsr	ld_ix_pb

	; GOTO 128

	ldx	#LINE_128
	jsr	goto_ix

LINE_122

	; T+=1

	ldx	#INTVAR_T
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 128

	ldx	#LINE_128
	jsr	goto_ix

LINE_124

	; IF B$=P$ THEN

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldx	#STRVAR_P
	jsr	ldeq_ir1_sr1_sx

	ldx	#LINE_126
	jsr	jmpeq_ir1_ix

	; S+=1

	ldx	#INTVAR_S
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 128

	ldx	#LINE_128
	jsr	goto_ix

LINE_126

	; C=1

	ldx	#INTVAR_C
	ldab	#1
	jsr	ld_ix_pb

	; GOTO 120

	ldx	#LINE_120
	jsr	goto_ix

LINE_128

	; NEXT K

	ldx	#INTVAR_K
	jsr	nextvar_ix

	jsr	next

	; WHEN D=0 GOTO 132

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_132
	jsr	jmpne_ir1_ix

LINE_130

	; D=0

	ldx	#INTVAR_D
	ldab	#0
	jsr	ld_ix_pb

	; D1=-D1

	ldx	#INTVAR_D1
	jsr	neg_ir1_ix

	ldx	#INTVAR_D1
	jsr	ld_ix_ir1

	; D2=-D2

	ldx	#INTVAR_D2
	jsr	neg_ir1_ix

	ldx	#INTVAR_D2
	jsr	ld_ix_ir1

	; GOTO 116

	ldx	#LINE_116
	jsr	goto_ix

LINE_132

	; S(Z)=S

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; F(Z)=T

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_134

	; END

	jsr	progend

LINE_200

	; PRINT "   ";

	jsr	pr_ss
	.text	3, "   "

	; FOR I=1 TO 2

	ldx	#INTVAR_I
	ldab	#1
	jsr	for_ix_pb

	ldab	#2
	jsr	to_ip_pb

	; PRINT E$;

	ldx	#STRVAR_E
	jsr	pr_sx

	; SOUND (I*75)+50,1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#75
	jsr	mul_ir1_ir1_pb

	ldab	#50
	jsr	add_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_201

	; POKE MC+1379,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1379
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1380,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1380
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1381,49

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1381
	jsr	add_ir1_ir1_pw

	ldab	#49
	jsr	poke_ir1_pb

	; POKE MC+1382,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1382
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1383,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1383
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1384,50

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1384
	jsr	add_ir1_ir1_pw

	ldab	#50
	jsr	poke_ir1_pb

	; POKE MC+1385,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1385
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

LINE_204

	; POKE MC+1386,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1386
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1387,51

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1387
	jsr	add_ir1_ir1_pw

	ldab	#51
	jsr	poke_ir1_pb

LINE_205

	; POKE MC+1388,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1388
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1389,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1389
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1390,52

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1390
	jsr	add_ir1_ir1_pw

	ldab	#52
	jsr	poke_ir1_pb

	; POKE MC+1391,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1391
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1392,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1392
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1393,53

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1393
	jsr	add_ir1_ir1_pw

	ldab	#53
	jsr	poke_ir1_pb

	; POKE MC+1394,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1394
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

LINE_206

	; POKE MC+1395,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1395
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1396,54

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1396
	jsr	add_ir1_ir1_pw

	ldab	#54
	jsr	poke_ir1_pb

	; POKE MC+1397,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1397
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1398,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1398
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1399,55

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1399
	jsr	add_ir1_ir1_pw

	ldab	#55
	jsr	poke_ir1_pb

	; POKE MC+1400,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1400
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1401,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1401
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

LINE_207

	; POKE MC+1402,56

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1402
	jsr	add_ir1_ir1_pw

	ldab	#56
	jsr	poke_ir1_pb

	; POKE MC+1403,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1403
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; POKE MC+1404,32

	ldx	#INTVAR_MC
	jsr	ld_ir1_ix

	ldd	#1404
	jsr	add_ir1_ir1_pw

	ldab	#32
	jsr	poke_ir1_pb

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

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

	.module	mdmul12
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

	.module	mdrpuword
; read DATA when records are purely unsigned words
; EXIT:  flt in tmp1+1, tmp2, tmp3
rpuword
	pshx
	ldx	dataptr
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldd	,x
	inx
	inx
	stx	dataptr
	std	tmp2
	ldd	#0
	std	tmp3
	stab	tmp1+1
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

	.module	mdstreqx
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
	inc	strtcnt
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

add_ip_ip_pb			; numCalls = 2
	.module	modadd_ip_ip_pb
	ldx	letptr
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

add_ir1_ir1_ir2			; numCalls = 2
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 3
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 6
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pw			; numCalls = 26
	.module	modadd_ir1_ir1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
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

add_ix_ix_pb			; numCalls = 7
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

arrdim1_ir1_ix			; numCalls = 5
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

arrdim2_ir1_sx			; numCalls = 1
	.module	modarrdim2_ir1_sx
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

arrref1_ir1_ix			; numCalls = 8
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_sx			; numCalls = 3
	.module	modarrref2_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 9
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

arrval1_ir2_ix			; numCalls = 2
	.module	modarrval1_ir2_ix
	ldd	r2+1
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

arrval2_ir1_sx			; numCalls = 2
	.module	modarrval2_ir1_sx
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
	stx	dataptr
	rts

cls			; numCalls = 4
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

for_ix_pb			; numCalls = 17
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 12
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 16
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inkey_sr1			; numCalls = 4
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

jmpeq_ir1_ix			; numCalls = 8
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

jmpne_ir1_ix			; numCalls = 18
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

ld_fr1_fx			; numCalls = 7
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

ld_fx_fr1			; numCalls = 2
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 2
	.module	modld_fx_ir1
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_ir1			; numCalls = 3
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

ld_ir1_ix			; numCalls = 62
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

ld_ir1_pb			; numCalls = 14
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 6
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 8
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 13
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 1
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 23
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

ld_sp_sr1			; numCalls = 3
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

ld_sr1_sx			; numCalls = 18
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 18
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir1_ir1_pb			; numCalls = 3
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
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

ldeq_ir1_sr1_sx			; numCalls = 3
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

ldlt_ir1_fr1_pb			; numCalls = 2
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

ldlt_ir1_ir1_ir2			; numCalls = 2
	.module	modldlt_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 5
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 3
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

ldlt_ir2_ir2_fx			; numCalls = 2
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

ldne_ir1_fr1_pb			; numCalls = 1
	.module	modldne_ir1_fr1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1+3
	bne	_done
	ldd	r1
	bne	_done
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

mul_ir1_ir1_ix			; numCalls = 3
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pb			; numCalls = 1
	.module	modmul_ir1_ir1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	ldx	#r1
	jmp	mulintx

neg_ir1_ix			; numCalls = 2
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

next			; numCalls = 17
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

nextvar_ix			; numCalls = 16
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

or_ir1_ir1_ir2			; numCalls = 4
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

poke_ir1_pb			; numCalls = 26
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

pr_sr1			; numCalls = 2
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 34
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 8
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jsr	print
_rts
	rts

prat_pb			; numCalls = 2
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 13
	.module	modprat_pw
	jmp	prat

progbegin			; numCalls = 1
	.module	modprogbegin
	ldx	R_MCXID
	cpx	#'h'*256+'C'
	bne	_mcbasic
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
_reqmsg	.text	"?ORIGINAL MC-10 ROM REQUIRED"
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

prtab_pb			; numCalls = 2
	.module	modprtab_pb
	jmp	prtab

read_ip			; numCalls = 1
	.module	modread_ip
	ldx	letptr
	jsr	rpuword
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

return			; numCalls = 4
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

sgn_ir2_ix			; numCalls = 1
	.module	modsgn_ir2_ix
	ldab	0,x
	bmi	_neg
	bne	_pos
	ldd	1,x
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

shift_ir1_ir1_pb			; numCalls = 2
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

shift_ir2_ir2_pb			; numCalls = 1
	.module	modshift_ir2_ir2_pb
	ldx	#r2
	jmp	shlint

sound_ir1_ir2			; numCalls = 4
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

strcat_sr1_sr1_ss			; numCalls = 1
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
	jsr	strtmp
	pulx
	ldab	,x
	abx
	jmp	1,x
_lserror
	ldab	#LS_ERROR
	jmp	error

strinit_sr1_sx			; numCalls = 1
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
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

sub_ir2_ir2_ix			; numCalls = 1
	.module	modsub_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

to_ip_pb			; numCalls = 16
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
	.word	1, 100, 500, 7712
	.word	1, 800, 4000, 7712
	.word	1, 75, 900, 7704
	.word	1, 450, 3000, 7704
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_D1	.block	3
INTVAR_D2	.block	3
INTVAR_I	.block	3
INTVAR_I1	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_L1	.block	3
INTVAR_M4	.block	3
INTVAR_M9	.block	3
INTVAR_MC	.block	3
INTVAR_N	.block	3
INTVAR_N1	.block	3
INTVAR_S	.block	3
INTVAR_T	.block	3
INTVAR_V	.block	3
INTVAR_V1	.block	3
INTVAR_W	.block	3
INTVAR_Z	.block	3
INTVAR_Z1	.block	3
FLTVAR_M	.block	5
FLTVAR_M5	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
STRVAR_C	.block	3
STRVAR_D	.block	3
STRVAR_E	.block	3
STRVAR_H	.block	3
STRVAR_M	.block	3
STRVAR_O	.block	3
STRVAR_P	.block	3
STRVAR_Q	.block	3
STRVAR_X	.block	3
; Numeric Arrays
INTARR_F	.block	4	; dims=1
INTARR_L	.block	4	; dims=1
INTARR_N	.block	4	; dims=1
INTARR_S	.block	4	; dims=1
INTARR_V	.block	4	; dims=1
; String Arrays
STRARR_B	.block	6	; dims=2

; block ended by symbol
bes
	.end

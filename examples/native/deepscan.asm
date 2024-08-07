; Assembly for deepscan.bas
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

LINE_0

	; POKE 3,0

	ldab	#0
	jsr	ld_ir1_pb

	ldab	#3
	jsr	poke_pb_ir1

LINE_1

	; CLS

	jsr	cls

	; GOTO 190

	ldx	#LINE_190
	jsr	goto_ix

LINE_2

	; W+=W>32

	ldab	#32
	ldx	#INTVAR_W
	jsr	ldlt_ir1_pb_ix

	ldx	#INTVAR_W
	jsr	add_ix_ix_ir1

	; PRINT @W, S$(L);

	ldx	#INTVAR_W
	jsr	prat_ix

	ldx	#STRARR_S
	ldd	#INTVAR_L
	jsr	arrval1_ir1_sx_id

	jsr	pr_sr1

	; ON K(0) GOTO 0,0,0,6

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_0, LINE_0, LINE_0, LINE_6

	; RETURN

	jsr	return

LINE_3

	; W-=W<57

	ldx	#INTVAR_W
	ldab	#57
	jsr	ldlt_ir1_ix_pb

	ldx	#INTVAR_W
	jsr	sub_ix_ix_ir1

	; PRINT @W, S$(L);

	ldx	#INTVAR_W
	jsr	prat_ix

	ldx	#STRARR_S
	ldd	#INTVAR_L
	jsr	arrval1_ir1_sx_id

	jsr	pr_sr1

	; ON K(0) GOTO 0,0,0,6

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_0, LINE_0, LINE_0, LINE_6

	; RETURN

	jsr	return

LINE_5

	; POKE H,175

	ldx	#INTVAR_H
	ldab	#175
	jsr	poke_ix_pb

	; K(0)=4

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#4
	jsr	ld_ip_pb

	; H=W+16418

	ldx	#INTVAR_W
	ldd	#16418
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_6

	; POKE H,175

	ldx	#INTVAR_H
	ldab	#175
	jsr	poke_ix_pb

	; H+=32

	ldx	#INTVAR_H
	ldab	#32
	jsr	add_ix_ix_pb

	; WHEN PEEK(H)<>175 GOTO 90

	ldx	#INTVAR_H
	jsr	peek_ir1_ix

	ldab	#175
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_90
	jsr	jmpne_ir1_ix

LINE_7

	; POKE H,42

	ldx	#INTVAR_H
	ldab	#42
	jsr	poke_ix_pb

	; RETURN

	jsr	return

LINE_8

	; IF POINT(A(T),B(T)+1) THEN

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	inc_ir2_ir2

	jsr	point_ir1_ir1_ir2

	ldx	#LINE_9
	jsr	jmpeq_ir1_ix

	; A(T)=X(P(T))

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; B(T)=Y(P(T))

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; GOTO 22

	ldx	#LINE_22
	jsr	goto_ix

LINE_9

	; SET(A(T),B(T),5)

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(A(T)+1,B(T),5)

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	inc_ir1_ir1

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(A(T),B(T)+1,5)

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	inc_ir2_ir2

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; SET(A(T)+1,B(T)+1,5)

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	inc_ir1_ir1

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	inc_ir2_ir2

	ldab	#5
	jsr	setc_ir1_ir2_pb

	; J-=1

	ldx	#INTVAR_J
	jsr	dec_ix_ix

	; PRINT @508, STR$(J);" ";

	ldd	#508
	jsr	prat_pw

	ldx	#INTVAR_J
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_10

	; A(T)=X(P(T))

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; B(T)=Y(P(T))

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; PRINT @W, S$(L);

	ldx	#INTVAR_W
	jsr	prat_ix

	ldx	#STRARR_S
	ldd	#INTVAR_L
	jsr	arrval1_ir1_sx_id

	jsr	pr_sr1

	; WHEN J>0 GOTO 22

	ldab	#0
	ldx	#INTVAR_J
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_22
	jsr	jmpne_ir1_ix

LINE_11

	; PRINT @W, S$(9);

	ldx	#INTVAR_W
	jsr	prat_ix

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

	; PRINT @W-32, S$(8);

	ldx	#INTVAR_W
	ldab	#32
	jsr	sub_ir1_ix_pb

	jsr	prat_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

	; SOUND 1,5

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#5
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; T=10

	ldx	#FLTVAR_T
	ldab	#10
	jsr	ld_fx_pb

	; NEXT

	jsr	next

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_20

	; FOR Y=500 TO 0 STEP -1

	ldx	#INTVAR_Y
	ldd	#500
	jsr	for_ix_pw

	ldab	#0
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; FOR T=1 TO Z

	ldx	#FLTVAR_T
	jsr	forone_fx

	ldx	#INTVAR_Z
	jsr	to_fp_ix

	; P(T)+=D(T)

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_D
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	add_ip_ip_ir1

	; IF (P(T)<160) OR (P(T)>379) THEN

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#160
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	ldd	#379
	jsr	ldlt_ir2_pw_ir2

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_21
	jsr	jmpeq_ir1_ix

	; PRINT @P(T), S$(5);

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

	; P(T)=RND(200)+164

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#200
	jsr	irnd_ir1_pb

	ldab	#164
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

	; D(T)=R(RND(2))

	ldx	#INTARR_D
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#INTARR_R
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_21

	; PRINT @P(T), S$(D(T)+5);

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTARR_D
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#5
	jsr	add_ir1_ir1_pb

	ldx	#STRARR_S
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

	; SET(A(T),B(T),3)

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	ldab	#3
	jsr	setc_ir1_ir2_pb

	; B(T)-=2

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	sub_ip_ip_pb

	; WHEN B(T)<4 GOTO 8

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#4
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_8
	jsr	jmpne_ir1_ix

LINE_22

	; RESET(A(T),B(T))

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	reset_ir1_ir2

	; FOR DL=1 TO (LV*100)+100

	ldx	#INTVAR_DL
	jsr	forone_ix

	ldx	#FLTVAR_LV
	jsr	ld_fr1_fx

	ldab	#100
	jsr	mul_fr1_fr1_pb

	ldab	#100
	jsr	add_fr1_fr1_pb

	jsr	to_ip_ir1

	; NEXT

	jsr	next

	; KK=0

	ldx	#INTVAR_KK
	jsr	clr_ix

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	jsr	peek2_ir1

	ldd	#16946
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_23
	jsr	jmpeq_ir1_ix

	; KK=65

	ldx	#INTVAR_KK
	ldab	#65
	jsr	ld_ix_pb

LINE_23

	; IF PEEK(3)=70 THEN

	ldab	#3
	jsr	peek_ir1_pb

	ldab	#70
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_24
	jsr	jmpeq_ir1_ix

	; KK=65

	ldx	#INTVAR_KK
	ldab	#65
	jsr	ld_ix_pb

LINE_24

	; IF PEEK(2) AND NOT PEEK(16948) AND 4 THEN

	jsr	peek2_ir1

	ldd	#16948
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	and_ir1_ir1_pb

	ldx	#LINE_25
	jsr	jmpeq_ir1_ix

	; KK=83

	ldx	#INTVAR_KK
	ldab	#83
	jsr	ld_ix_pb

LINE_25

	; IF PEEK(3)=74 THEN

	ldab	#3
	jsr	peek_ir1_pb

	ldab	#74
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_26
	jsr	jmpeq_ir1_ix

	; KK=83

	ldx	#INTVAR_KK
	ldab	#83
	jsr	ld_ix_pb

LINE_26

	; IF PEEK(2) AND NOT PEEK(16952) AND 8 THEN

	jsr	peek2_ir1

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#8
	jsr	and_ir1_ir1_pb

	ldx	#LINE_27
	jsr	jmpeq_ir1_ix

	; KK=32

	ldx	#INTVAR_KK
	ldab	#32
	jsr	ld_ix_pb

LINE_27

	; IF PEEK(3)=66 THEN

	ldab	#3
	jsr	peek_ir1_pb

	ldab	#66
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_29
	jsr	jmpeq_ir1_ix

	; KK=32

	ldx	#INTVAR_KK
	ldab	#32
	jsr	ld_ix_pb

LINE_29

	; ON K(KK) GOSUB 2,3,5,6

	ldx	#INTARR_K
	ldd	#INTVAR_KK
	jsr	arrval1_ir1_ix_id

	jsr	ongosub_ir1_is
	.byte	4
	.word	LINE_2, LINE_3, LINE_5, LINE_6

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_30

	; PRINT @235, "OUT OF FUEL!";

	ldab	#235
	jsr	prat_pb

	jsr	pr_ss
	.text	12, "OUT OF FUEL!"

	; SOUND 1,10

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR T=1 TO 10000

	ldx	#FLTVAR_T
	jsr	forone_fx

	ldd	#10000
	jsr	to_fp_pw

	; NEXT

	jsr	next

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_70

	; FOR Z=1 TO 5

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#5
	jsr	to_ip_pb

	; SOUND RND(100),2

	ldab	#100
	jsr	irnd_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; S+=Y

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ix_ix_ir1

	; PRINT @485, STR$(S);" ";

	ldd	#485
	jsr	prat_pw

	ldx	#INTVAR_S
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; Y=500

	ldx	#INTVAR_Y
	ldd	#500
	jsr	ld_ix_pw

	; Z=5

	ldx	#INTVAR_Z
	ldab	#5
	jsr	ld_ix_pb

	; G+=1

	ldx	#INTVAR_G
	jsr	inc_ix_ix

	; WHEN G=3 GOSUB 910

	ldx	#INTVAR_G
	ldab	#3
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_910
	jsr	jsrne_ir1_ix

LINE_80

	; FOR T=1 TO 10

	ldx	#FLTVAR_T
	jsr	forone_fx

	ldab	#10
	jsr	to_fp_pb

	; P(T)=RND(200)+164

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#200
	jsr	irnd_ir1_pb

	ldab	#164
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

	; D(T)=R(RND(2))

	ldx	#INTARR_D
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#INTARR_R
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; A(T)=X(P(T))

	ldx	#INTARR_A
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; B(T)=Y(P(T))

	ldx	#INTARR_B
	ldd	#FLTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_P
	ldd	#FLTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_90

	; IF H>16864 THEN

	ldd	#16864
	ldx	#INTVAR_H
	jsr	ldlt_ir1_pw_ix

	ldx	#LINE_91
	jsr	jmpeq_ir1_ix

	; H=16863

	ldx	#INTVAR_H
	ldd	#16863
	jsr	ld_ix_pw

	; K(0)=0

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; RETURN

	jsr	return

LINE_91

	; ON K(PEEK(H)) GOSUB 95,92,93

	ldx	#INTVAR_H
	jsr	peek_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ongosub_ir1_is
	.byte	3
	.word	LINE_95, LINE_92, LINE_93

	; POKE H,191

	ldx	#INTVAR_H
	ldab	#191
	jsr	poke_ix_pb

	; POKE H,175

	ldx	#INTVAR_H
	ldab	#175
	jsr	poke_ix_pb

	; H=16863

	ldx	#INTVAR_H
	ldd	#16863
	jsr	ld_ix_pw

	; K(0)=0

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; SOUND 100,2

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_92

	; FOR X=1 TO L*5

	ldx	#INTVAR_X
	jsr	forone_ix

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldab	#5
	jsr	mul_ir1_ir1_pb

	jsr	to_ip_ir1

	; S+=10

	ldx	#INTVAR_S
	ldab	#10
	jsr	add_ix_ix_pb

	; PRINT @485, STR$(S);" ";

	ldd	#485
	jsr	prat_pw

	ldx	#INTVAR_S
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SOUND RND(100),1

	ldab	#100
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_93

	; FOR X=1 TO 2

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#2
	jsr	to_ip_pb

	; J+=1

	ldx	#INTVAR_J
	jsr	inc_ix_ix

	; PRINT @508, STR$(J);" ";

	ldd	#508
	jsr	prat_pw

	ldx	#INTVAR_J
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SOUND 100,1

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 110,1

	ldab	#110
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 210,1

	ldab	#210
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 120,1

	ldab	#120
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 220,1

	ldab	#220
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_95

	; POKE H,159

	ldx	#INTVAR_H
	ldab	#159
	jsr	poke_ix_pb

	; SOUND 100,2

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 200,2

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR C=1 TO Z

	ldx	#INTVAR_C
	jsr	forone_ix

	ldx	#INTVAR_Z
	jsr	to_ip_ix

	; X=P(C)+16385

	ldx	#INTARR_P
	ldd	#INTVAR_C
	jsr	arrval1_ir1_ix_id

	ldd	#16385
	jsr	add_ir1_ir1_pw

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; IF (X=H) OR ((X+1)=H) THEN

	ldx	#INTVAR_X
	ldd	#INTVAR_H
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_X
	jsr	inc_ir2_ix

	ldx	#INTVAR_H
	jsr	ldeq_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_97
	jsr	jmpeq_ir1_ix

	; PRINT @P(C), S$(7);

	ldx	#INTARR_P
	ldd	#INTVAR_C
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

	; GOSUB 98

	ldx	#LINE_98
	jsr	gosub_ix

LINE_97

	; NEXT

	jsr	next

	; S+=20

	ldx	#INTVAR_S
	ldab	#20
	jsr	add_ix_ix_pb

	; PRINT @485, STR$(S);" ";

	ldd	#485
	jsr	prat_pw

	ldx	#INTVAR_S
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; C=17023

	ldx	#INTVAR_C
	ldd	#17023
	jsr	ld_ix_pw

	; RETURN

	jsr	return

LINE_98

	; SET(A(C),B(C),3)

	ldx	#INTARR_A
	ldd	#INTVAR_C
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#INTVAR_C
	jsr	arrval1_ir2_ix_id

	ldab	#3
	jsr	setc_ir1_ir2_pb

	; PRINT @P(C), S$(5);

	ldx	#INTARR_P
	ldd	#INTVAR_C
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrval1_ir1_sx_ir1

	jsr	pr_sr1

	; FOR X=C TO Z

	ldd	#INTVAR_X
	ldx	#INTVAR_C
	jsr	for_id_ix

	ldx	#INTVAR_Z
	jsr	to_ip_ix

	; P(X)=P(X+1)

	ldx	#INTARR_P
	ldd	#INTVAR_X
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTARR_P
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; D(X)=D(X+1)

	ldx	#INTARR_D
	ldd	#INTVAR_X
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTARR_D
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; A(X)=A(X+1)

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; B(X)=B(X+1)

	ldx	#INTARR_B
	ldd	#INTVAR_X
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; NEXT

	jsr	next

	; Z-=1

	ldx	#INTVAR_Z
	jsr	dec_ix_ix

	; WHEN Z<1 GOSUB 70

	ldx	#INTVAR_Z
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_70
	jsr	jsrne_ir1_ix

LINE_99

	; T=10

	ldx	#FLTVAR_T
	ldab	#10
	jsr	ld_fx_pb

	; C=10

	ldx	#INTVAR_C
	ldab	#10
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_100

	; IF S>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_S
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_110
	jsr	jmpeq_ir1_ix

	; HS=S

	ldd	#INTVAR_HS
	ldx	#INTVAR_S
	jsr	ld_id_ix

	; PRINT @499, STR$(HS);" ";

	ldd	#499
	jsr	prat_pw

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_110

	; PRINT @235, "PLAY AGAIN?����������";

	ldab	#235
	jsr	prat_pb

	jsr	pr_ss
	.text	21, "PLAY AGAIN?\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_120

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

LINE_130

	; IF (I$="Y") OR (PEEK(3)=66) THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldab	#3
	jsr	peek_ir2_pb

	ldab	#66
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_140
	jsr	jmpeq_ir1_ix

	; PRINT @235, "�����������";

	ldab	#235
	jsr	prat_pb

	jsr	pr_ss
	.text	11, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

	; GOTO 210

	ldx	#LINE_210
	jsr	goto_ix

LINE_140

	; IF I$="N" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_150
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_150

	; GOTO 120

	ldx	#LINE_120
	jsr	goto_ix

LINE_190

	; CLS

	jsr	cls

	; DIM T,C,P(10),D(10),S$(9),A(10),B(10),W,K(255),H,Z,Y,X,X(511),Y(511),R(3),L,J,G,S

	ldab	#10
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrdim1_ir1_ix

	ldab	#10
	jsr	ld_ir1_pb

	ldx	#INTARR_D
	jsr	arrdim1_ir1_ix

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrdim1_ir1_sx

	ldab	#10
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrdim1_ir1_ix

	ldab	#10
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrdim1_ir1_ix

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrdim1_ir1_ix

	ldd	#511
	jsr	ld_ir1_pw

	ldx	#INTARR_X
	jsr	arrdim1_ir1_ix

	ldd	#511
	jsr	ld_ir1_pw

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_R
	jsr	arrdim1_ir1_ix

LINE_200

	; T=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_T
	jsr	ld_fx_fr1

	; GOSUB 900

	ldx	#LINE_900
	jsr	gosub_ix

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT @484, "WANT INSTRUCTIONS (Y/N)?";

	ldd	#484
	jsr	prat_pw

	jsr	pr_ss
	.text	24, "WANT INSTRUCTIONS (Y/N)?"

	; GOSUB 3020

	ldx	#LINE_3020
	jsr	gosub_ix

	; WHEN I$="Y" GOSUB 3000

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_3000
	jsr	jsrne_ir1_ix

LINE_210

	; PRINT @480, "      LEVEL OF PLAY? (1-3)     ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	31, "      LEVEL OF PLAY? (1-3)     "

	; POKE 16895,96

	ldab	#96
	jsr	ld_ir1_pb

	ldd	#16895
	jsr	poke_pw_ir1

	; GOSUB 3020

	ldx	#LINE_3020
	jsr	gosub_ix

	; LV=4-VAL(I$)

	ldx	#STRVAR_I
	jsr	val_fr1_sx

	ldab	#4
	jsr	rsub_fr1_fr1_pb

	ldx	#FLTVAR_LV
	jsr	ld_fx_fr1

	; WHEN (LV<1) OR (LV>3) GOTO 210

	ldx	#FLTVAR_LV
	ldab	#1
	jsr	ldlt_ir1_fx_pb

	ldab	#3
	ldx	#FLTVAR_LV
	jsr	ldlt_ir2_pb_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_210
	jsr	jmpne_ir1_ix

LINE_400

	; L=1

	ldx	#INTVAR_L
	jsr	one_ix

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; W=RND(20)+35

	ldab	#20
	jsr	irnd_ir1_pb

	ldab	#35
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_W
	jsr	ld_ix_ir1

	; H=16863

	ldx	#INTVAR_H
	ldd	#16863
	jsr	ld_ix_pw

	; Z=5

	ldx	#INTVAR_Z
	ldab	#5
	jsr	ld_ix_pb

	; J=3

	ldx	#INTVAR_J
	ldab	#3
	jsr	ld_ix_pb

	; G=0

	ldx	#INTVAR_G
	jsr	clr_ix

LINE_410

	; R(1)=-1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_R
	jsr	arrref1_ir1_ix_ir1

	jsr	true_ip

	; R(2)=1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_R
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; GOSUB 80

	ldx	#LINE_80
	jsr	gosub_ix

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; C=17023

	ldx	#INTVAR_C
	ldd	#17023
	jsr	ld_ix_pw

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_800

	; POKE 49151,68

	ldab	#68
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; CLS

	jsr	cls

	; FOR L=1 TO 500

	ldx	#INTVAR_L
	jsr	forone_ix

	ldd	#500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; CLS 5

	ldab	#5
	jsr	clsn_pb

	; FOR L=1 TO 500

	ldx	#INTVAR_L
	jsr	forone_ix

	ldd	#500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; SOUND 225,1

	ldab	#225
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_810

	; CLS 3

	ldab	#3
	jsr	clsn_pb

	; PRINT @236, "DEEP SCAN";

	ldab	#236
	jsr	prat_pb

	jsr	pr_ss
	.text	9, "DEEP SCAN"

	; FOR L=1 TO 1000

	ldx	#INTVAR_L
	jsr	forone_ix

	ldd	#1000
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_900

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; C=0

	ldx	#INTVAR_C
	jsr	clr_ix

	; FOR Y=0 TO 15

	ldx	#INTVAR_Y
	jsr	forclr_ix

	ldab	#15
	jsr	to_ip_pb

	; GOSUB 800

	ldx	#LINE_800
	jsr	gosub_ix

	; FOR X=0 TO 31

	ldx	#INTVAR_X
	jsr	forclr_ix

	ldab	#31
	jsr	to_ip_pb

	; X(C)=SHIFT(X,1)+1

	ldx	#INTARR_X
	ldd	#INTVAR_C
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	dbl_ir1_ix

	jsr	inc_ir1_ir1

	jsr	ld_ip_ir1

	; Y(C)=SHIFT(Y,1)

	ldx	#INTARR_Y
	ldd	#INTVAR_C
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	dbl_ir1_ix

	jsr	ld_ip_ir1

	; C+=1

	ldx	#INTVAR_C
	jsr	inc_ix_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_910

	; SOUND 9,3

	ldab	#9
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; L+=1

	ldx	#INTVAR_L
	jsr	inc_ix_ix

	; IF L>3 THEN

	ldab	#3
	ldx	#INTVAR_L
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_915
	jsr	jmpeq_ir1_ix

	; L=3

	ldx	#INTVAR_L
	ldab	#3
	jsr	ld_ix_pb

LINE_915

	; PRINT @W, S$(L);

	ldx	#INTVAR_W
	jsr	prat_ix

	ldx	#STRARR_S
	ldd	#INTVAR_L
	jsr	arrval1_ir1_sx_id

	jsr	pr_sr1

	; G=0

	ldx	#INTVAR_G
	jsr	clr_ix

LINE_920

	; PRINT @448, "��������������������������������";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_930

	; POKE RND(22)+16837,36

	ldab	#22
	jsr	irnd_ir1_pb

	ldd	#16837
	jsr	add_ir1_ir1_pw

	ldab	#36
	jsr	poke_ir1_pb

	; SOUND 150,2

	ldab	#150
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE RND(22)+16837,43

	ldab	#22
	jsr	irnd_ir1_pb

	ldd	#16837
	jsr	add_ir1_ir1_pw

	ldab	#43
	jsr	poke_ir1_pb

	; SOUND 220,2

	ldab	#220
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_1000

	; CLS

	jsr	cls

LINE_1010

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF"

LINE_1011

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF"

LINE_1012

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1013

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1014

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1015

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1016

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1017

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1018

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1019

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1020

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1021

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1022

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1023

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1024

	; PRINT "��������������������������������";

	jsr	pr_ss
	.text	32, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_1025

	; PRINT "SCORE          HIGH";

	jsr	pr_ss
	.text	19, "SCORE          HIGH"

	; PRINT @499, STR$(HS);" ";

	ldd	#499
	jsr	prat_pw

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; PRINT @485, STR$(S);" ";

	ldd	#485
	jsr	prat_pw

	ldx	#INTVAR_S
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_1026

	; PRINT @W, S$(L);

	ldx	#INTVAR_W
	jsr	prat_ix

	ldx	#STRARR_S
	ldd	#INTVAR_L
	jsr	arrval1_ir1_sx_id

	jsr	pr_sr1

	; PRINT @508, STR$(J);" ";

	ldd	#508
	jsr	prat_pw

	ldx	#INTVAR_J
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; RETURN

	jsr	return

LINE_2000

	; S$(0)="�����"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	5, "\xDF\xDF\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_2005

	; S$(1)="�����"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	5, "\xDF\xDF\xDE\xD4\xDF"

	jsr	ld_sp_sr1

LINE_2010

	; S$(2)="�����"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	5, "\xDF\xDF\xD8\xD4\xDF"

	jsr	ld_sp_sr1

LINE_2020

	; S$(3)="�����"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	5, "\xDF\xDC\xD0\xDC\xDF"

	jsr	ld_sp_sr1

LINE_2030

	; S$(4)="����"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	4, "\xAF\xA8\xAC\xAF"

	jsr	ld_sp_sr1

LINE_2040

	; S$(5)="����"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	4, "\xAF\xAF\xAF\xAF"

	jsr	ld_sp_sr1

LINE_2050

	; S$(6)="����"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	4, "\xAF\xAC\xA4\xAF"

	jsr	ld_sp_sr1

LINE_2055

	; S$(7)="����"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	4, "\xC9\xC9\xC9\xC9"

	jsr	ld_sp_sr1

LINE_2056

	; S$(8)="�������"

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	7, "\xD6\xD6\xD6\xD6\xD6\xD6\xD7"

	jsr	ld_sp_sr1

LINE_2057

	; S$(9)="�������"

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#STRARR_S
	jsr	arrref1_ir1_sx_ir1

	jsr	ld_sr1_ss
	.text	7, "\xDF\xD6\xD6\xD6\xD6\xD7\xDF"

	jsr	ld_sp_sr1

LINE_2060

	; K(65)=1

	ldab	#65
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; K(83)=2

	ldab	#83
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ip_pb

	; K(68)=2

	ldab	#68
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ip_pb

	; K(32)=3

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#3
	jsr	ld_ip_pb

	; K(168)=1

	ldab	#168
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; K(172)=1

	ldab	#172
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; K(164)=1

	ldab	#164
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; K(36)=2

	ldab	#36
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ip_pb

	; K(43)=3

	ldab	#43
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#3
	jsr	ld_ip_pb

	; RETURN

	jsr	return

LINE_3000

	; CLS

	jsr	cls

	; PRINT TAB(11);"DEEP SCAN\r";

	ldab	#11
	jsr	prtab_pb

	jsr	pr_ss
	.text	10, "DEEP SCAN\r"

LINE_3001

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_3002

	; PRINT "USE: a OR joystick TO MOVE PORT\r";

	jsr	pr_ss
	.text	32, "USE: a OR joystick TO MOVE PORT\r"

LINE_3003

	; PRINT "     s MOVE STARBOARD\r";

	jsr	pr_ss
	.text	22, "     s MOVE STARBOARD\r"

LINE_3004

	; PRINT "     space FIRE DEPTH CHARGE\r";

	jsr	pr_ss
	.text	29, "     space FIRE DEPTH CHARGE\r"

LINE_3005

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_3006

	; PRINT "BONUSES:   $ EXTRA POINTS\r";

	jsr	pr_ss
	.text	26, "BONUSES:   $ EXTRA POINTS\r"

	; POKE 16587,36

	ldab	#36
	jsr	ld_ir1_pb

	ldd	#16587
	jsr	poke_pw_ir1

LINE_3007

	; PRINT "           + EXTRA LIVES\r";

	jsr	pr_ss
	.text	25, "           + EXTRA LIVES\r"

	; POKE 16619,43

	ldab	#43
	jsr	ld_ir1_pb

	ldd	#16619
	jsr	poke_pw_ir1

LINE_3008

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_3009

	; PRINT "GOALS: EVERY 3 LEVELS BONUSES\r";

	jsr	pr_ss
	.text	30, "GOALS: EVERY 3 LEVELS BONUSES\r"

LINE_3010

	; PRINT "       APPEAR AND SHIP SIZE\r";

	jsr	pr_ss
	.text	28, "       APPEAR AND SHIP SIZE\r"

LINE_3011

	; PRINT "       INCREASES. DESTROY SUBS\r";

	jsr	pr_ss
	.text	31, "       INCREASES. DESTROY SUBS\r"

LINE_3012

	; PRINT "       AS FAST AS POSSIBLE.\r";

	jsr	pr_ss
	.text	28, "       AS FAST AS POSSIBLE.\r"

LINE_3013

	; PRINT "       SUBS ARE 20 POINTS EACH.\r";

	jsr	pr_ss
	.text	32, "       SUBS ARE 20 POINTS EACH.\r"

LINE_3014

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_3015

	; PRINT @485, "PRESS ANY KEY TO BEGIN";

	ldd	#485
	jsr	prat_pw

	jsr	pr_ss
	.text	22, "PRESS ANY KEY TO BEGIN"

LINE_3020

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; IF I$<>"" THEN

	ldx	#STRVAR_I
	jsr	ldne_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_3030
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_3030

	; IF PEEK(3)=66 THEN

	ldab	#3
	jsr	peek_ir1_pb

	ldab	#66
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_3040
	jsr	jmpeq_ir1_ix

	; I$="2"

	jsr	ld_sr1_ss
	.text	1, "2"

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_3040

	; GOTO 3020

	ldx	#LINE_3020
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

	.module	mdpoint
; get pixel color
; ENTRY: ACCA holds X, ACCB holds Y
; EXIT: ACCD holds color
point
	jsr	getxym
	ldab	,x
	bpl	_text
	clra
	bitb	M_PMSK
	beq	_unset
	andb	#$70
	lsrb
	lsrb
	lsrb
	lsrb
	incb
	rts
_text
	ldd	#-1
	rts
_unset
	tab
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

	.module	mdset
; set pixel with existing color
; ENTRY: ACCA holds X, ACCB holds Y
set
	bsr	getxym
	ldab	,x
	bmi	doset
	clrb
doset
	andb	#$70
	ldaa	$82
	psha
	stab	$82
	jsr	R_SETPX
	pula
	staa	$82
	rts
getxym
	anda	#$1f
	andb	#$3f
	pshb
	tab
	jmp	R_MSKPX

	.module	mdsetc
; set pixel with color
; ENTRY: X holds byte-to-modify, ACCB holds color
setc
	decb
	bmi	_loadc
	lslb
	lslb
	lslb
	lslb
	bra	_ok
_loadc
	ldab	,x
	bmi	_ok
	clrb
_ok
	bra	doset

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

add_fr1_fr1_pb			; numCalls = 1
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ip_ip_ir1			; numCalls = 1
	.module	modadd_ip_ip_ir1
	ldx	letptr
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ir1_ir1_pb			; numCalls = 4
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pw			; numCalls = 3
	.module	modadd_ir1_ir1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
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

add_ix_ix_ir1			; numCalls = 2
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 3
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 3
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir1_ir1_pb			; numCalls = 3
	.module	modand_ir1_ir1_pb
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

arrdim1_ir1_ix			; numCalls = 8
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

arrref1_ir1_ix_id			; numCalls = 18
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 14
	.module	modarrref1_ir1_ix_ir1
	ldd	r1+1
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx_ir1			; numCalls = 10
	.module	modarrref1_ir1_sx_ir1
	ldd	r1+1
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 24
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

arrval1_ir1_ix_ir1			; numCalls = 15
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

arrval1_ir1_sx_id			; numCalls = 5
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

arrval1_ir1_sx_ir1			; numCalls = 6
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

arrval1_ir2_ix_id			; numCalls = 9
	.module	modarrval1_ir2_ix_id
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

clr_ip			; numCalls = 2
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 5
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 5
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 2
	.module	modclsn_pb
	jmp	R_CLSN

com_ir2_ir2			; numCalls = 3
	.module	modcom_ir2_ir2
	com	r2+2
	com	r2+1
	com	r2
	rts

dbl_ir1_ix			; numCalls = 2
	.module	moddbl_ir1_ix
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
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

for_id_ix			; numCalls = 1
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

for_ix_pw			; numCalls = 1
	.module	modfor_ix_pw
	stx	letptr
	clr	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 2
	.module	modforclr_ix
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_fx			; numCalls = 3
	.module	modforone_fx
	stx	letptr
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

forone_ix			; numCalls = 8
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

goto_ix			; numCalls = 8
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_ir1_ir1			; numCalls = 3
	.module	modinc_ir1_ir1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 4
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir2_ir2			; numCalls = 3
	.module	modinc_ir2_ir2
	inc	r2+2
	bne	_rts
	inc	r2+1
	bne	_rts
	inc	r2
_rts
	rts

inc_ir2_ix			; numCalls = 1
	.module	modinc_ir2_ix
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 4
	.module	modinc_ix_ix
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 2
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

irnd_ir1_pb			; numCalls = 9
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 16
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

jmpne_ir1_ix			; numCalls = 4
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

jsrne_ir1_ix			; numCalls = 3
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

ld_fr1_fx			; numCalls = 1
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
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

ld_fx_pb			; numCalls = 2
	.module	modld_fx_pb
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
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

ld_ip_ir1			; numCalls = 16
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 6
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 2
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

ld_ir1_pb			; numCalls = 59
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir1_pw			; numCalls = 2
	.module	modld_ir1_pw
	std	r1+1
	ldab	#0
	stab	r1
	rts

ld_ir2_pb			; numCalls = 18
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 3
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 11
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 6
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 10
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 11
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sx_sr1			; numCalls = 1
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_pb			; numCalls = 4
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

ldeq_ir1_ix_pb			; numCalls = 1
	.module	modldeq_ir1_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 3
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

ldeq_ir2_ir2_ix			; numCalls = 1
	.module	modldeq_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
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

ldlt_ir1_fx_pb			; numCalls = 1
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

ldlt_ir1_ir1_pb			; numCalls = 2
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

ldlt_ir1_ix_pb			; numCalls = 2
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

ldlt_ir1_pb_ix			; numCalls = 3
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

ldlt_ir2_pw_ir2			; numCalls = 1
	.module	modldlt_ir2_pw_ir2
	subd	r2+1
	ldab	#0
	sbcb	r2
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_pb			; numCalls = 1
	.module	modldne_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
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

next			; numCalls = 16
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

one_ip			; numCalls = 5
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 2
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

peek2_ir1			; numCalls = 3
	.module	modpeek2_ir1
	jsr	R_KPOLL
	ldab	2
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ix			; numCalls = 2
	.module	modpeek_ir1_ix
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pb			; numCalls = 4
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_pb			; numCalls = 1
	.module	modpeek_ir2_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir2_pw			; numCalls = 3
	.module	modpeek_ir2_pw
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

point_ir1_ir1_ir2			; numCalls = 1
	.module	modpoint_ir1_ir1_ir2
	ldaa	r2+2
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

poke_ir1_pb			; numCalls = 2
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_ix_pb			; numCalls = 6
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

poke_pb_ir1			; numCalls = 1
	.module	modpoke_pb_ir1
	clra
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

poke_pw_ir1			; numCalls = 4
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 20
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 48
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_ir1			; numCalls = 5
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

prat_pb			; numCalls = 4
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

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jmp	prtab

reset_ir1_ir2			; numCalls = 1
	.module	modreset_ir1_ir2
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

return			; numCalls = 18
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

rsub_fr1_fr1_pb			; numCalls = 1
	.module	modrsub_fr1_fr1_pb
	stab	tmp1
	ldd	#0
	subd	r1+3
	std	r1+3
	ldab	tmp1
	sbcb	r1+2
	stab	r1+2
	ldd	#0
	sbcb	r1+1
	sbca	r1
	std	r1
	rts

setc_ir1_ir2_pb			; numCalls = 6
	.module	modsetc_ir1_ir2_pb
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

sound_ir1_ir2			; numCalls = 18
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

sub_ip_ip_pb			; numCalls = 1
	.module	modsub_ip_ip_pb
	ldx	letptr
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

sub_ir1_ix_pb			; numCalls = 1
	.module	modsub_ir1_ix_pb
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

sub_ix_ix_ir1			; numCalls = 1
	.module	modsub_ix_ix_ir1
	ldd	1,x
	subd	r1+1
	std	1,x
	ldab	0,x
	sbcb	r1
	stab	0,x
	rts

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_fp_ix			; numCalls = 1
	.module	modto_fp_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#15
	jmp	to

to_fp_pb			; numCalls = 1
	.module	modto_fp_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

to_fp_pw			; numCalls = 1
	.module	modto_fp_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_ir1			; numCalls = 2
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

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

to_ip_pb			; numCalls = 5
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 3
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

true_ip			; numCalls = 1
	.module	modtrue_ip
	ldx	letptr
	ldd	#-1
	stab	0,x
	std	1,x
	rts

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
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_C	.block	3
INTVAR_DL	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_HS	.block	3
INTVAR_J	.block	3
INTVAR_KK	.block	3
INTVAR_L	.block	3
INTVAR_S	.block	3
INTVAR_W	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
FLTVAR_LV	.block	5
FLTVAR_T	.block	5
; String Variables
STRVAR_I	.block	3
; Numeric Arrays
INTARR_A	.block	4	; dims=1
INTARR_B	.block	4	; dims=1
INTARR_D	.block	4	; dims=1
INTARR_K	.block	4	; dims=1
INTARR_P	.block	4	; dims=1
INTARR_R	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays
STRARR_S	.block	4	; dims=1

; block ended by symbol
bes
	.end

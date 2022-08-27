; Assembly for closeout.bas
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

	; CLS

	jsr	cls

	; LV=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_LV
	jsr	ld_fx_fr1

	; GOSUB 400

	ldx	#LINE_400
	jsr	gosub_ix

	; POKE 16925,0

	ldab	#0
	jsr	ld_ir1_pb

	ldd	#16925
	jsr	poke_pw_ir1

	; POKE 16926,1

	ldab	#1
	jsr	ld_ir1_pb

	ldd	#16926
	jsr	poke_pw_ir1

	; GOTO 5

	ldx	#LINE_5
	jsr	goto_ix

LINE_1

	; C=-1

	ldx	#INTVAR_C
	jsr	true_ix

	; D=O

	ldd	#INTVAR_D
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; C2+=1

	ldx	#INTVAR_C2
	jsr	inc_ix_ix

	; C1=C2 AND 1

	ldx	#INTVAR_C2
	jsr	ld_ir1_ix

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_2

	; C=1

	ldx	#INTVAR_C
	jsr	one_ix

	; D=O

	ldd	#INTVAR_D
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; C2+=1

	ldx	#INTVAR_C2
	jsr	inc_ix_ix

	; C1=C2 AND 1

	ldx	#INTVAR_C2
	jsr	ld_ir1_ix

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_3

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

	; C=O

	ldd	#INTVAR_C
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; C2+=1

	ldx	#INTVAR_C2
	jsr	inc_ix_ix

	; C1=C2 AND 1

	ldx	#INTVAR_C2
	jsr	ld_ir1_ix

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_4

	; D=-1

	ldx	#INTVAR_D
	jsr	true_ix

	; C=O

	ldd	#INTVAR_C
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; C2+=1

	ldx	#INTVAR_C2
	jsr	inc_ix_ix

	; C1=C2 AND 1

	ldx	#INTVAR_C2
	jsr	ld_ir1_ix

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_C1
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_5

	; DIM W(2),Z(2),F(2),X(2),Y(2),H(2),S(21),K(255),P(4)

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_W
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_Z
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_F
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_H
	jsr	arrdim1_ir1_ix

	ldab	#21
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrdim1_ir1_ix

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrdim1_ir1_ix

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrdim1_ir1_ix

	; P(0)=25

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrref1_ir1_ix

	ldab	#25
	jsr	ld_ip_pb

	; P(1)=24

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrref1_ir1_ix

	ldab	#24
	jsr	ld_ip_pb

	; P(2)=25

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrref1_ir1_ix

	ldab	#25
	jsr	ld_ip_pb

	; P(3)=28

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrref1_ir1_ix

	ldab	#28
	jsr	ld_ip_pb

	; P(4)=47

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_P
	jsr	arrref1_ir1_ix

	ldab	#47
	jsr	ld_ip_pb

LINE_6

	; DIM V,Q,O,A,B,P,C,D,G,N,E,W,Z,H,X,Y,F,K,U,I,J

LINE_7

	; K(65)=1

	ldab	#65
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(68)=2

	ldab	#68
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; K(83)=3

	ldab	#83
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(87)=4

	ldab	#87
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; K(32)=5

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#5
	jsr	ld_ip_pb

LINE_8

	; R=0

	ldx	#INTVAR_R
	jsr	clr_ix

	; T=0

	ldx	#FLTVAR_T
	jsr	clr_fx

	; SH=1

	ldx	#INTVAR_SH
	jsr	one_ix

	; O=0

	ldx	#INTVAR_O
	jsr	clr_ix

LINE_9

	; PRINT @23, "closeout";

	ldab	#23
	jsr	prat_pb

	jsr	pr_ss
	.text	8, "closeout"

	; POKE 16415,33

	ldab	#33
	jsr	ld_ir1_pb

	ldd	#16415
	jsr	poke_pw_ir1

LINE_10

	; R+=1

	ldx	#INTVAR_R
	jsr	inc_ix_ix

	; PRINT @87, "round";STR$(R);" ";

	ldab	#87
	jsr	prat_pb

	jsr	pr_ss
	.text	5, "round"

	ldx	#INTVAR_R
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SH+=2

	ldx	#INTVAR_SH
	ldab	#2
	jsr	add_ix_ix_pb

	; IF SH>9 THEN

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#INTVAR_SH
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_11
	jsr	jmpeq_ir1_ix

	; SH=9

	ldx	#INTVAR_SH
	ldab	#9
	jsr	ld_ix_pb

LINE_11

	; GOSUB 68

	ldx	#LINE_68
	jsr	gosub_ix

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

LINE_12

	; Q=32

	ldx	#INTVAR_Q
	ldab	#32
	jsr	ld_ix_pb

	; M=O

	ldd	#INTVAR_M
	ldx	#INTVAR_O
	jsr	ld_id_ix

LINE_13

	; V=16384

	ldx	#INTVAR_V
	ldd	#16384
	jsr	ld_ix_pw

	; K(96)=3

	ldab	#96
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(255)=3

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(33)=3

	ldab	#33
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(240)=3

	ldab	#240
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(195)=2

	ldab	#195
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; K(220)=3

	ldab	#220
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; LN$="ˆ˜¨¸èø"

	jsr	ld_sr1_ss
	.text	6, "\x88\x98\xA8\xB8\xE8\xF8"

	ldx	#STRVAR_LN
	jsr	ld_sx_sr1

LINE_14

	; FOR I=1 TO 6

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

	; K(ASC(MID$(LN$,I,1)))=1

	ldx	#STRVAR_LN
	jsr	ld_sr1_sx

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; NEXT

	jsr	next

	; K(42)=1

	ldab	#42
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(24)=5

	ldab	#24
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#5
	jsr	ld_ip_pb

	; K(25)=5

	ldab	#25
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#5
	jsr	ld_ip_pb

LINE_16

	; FOR J=0 TO 15 STEP 2

	ldx	#INTVAR_J
	jsr	forclr_ix

	ldab	#15
	jsr	to_ip_pb

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; PRINT @SHIFT(J,5),

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	jsr	prat_ir1

LINE_17

	; FOR I=1 TO 22

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#22
	jsr	to_ip_pb

	; PRINT MID$(LN$,RND(6),1);

	ldx	#STRVAR_LN
	jsr	ld_sr1_sx

	ldab	#6
	jsr	irnd_ir2_pb

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; NEXT

	jsr	next

LINE_18

	; PRINT @SHIFT(J,5)+32, "ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ";

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldab	#32
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	22, "\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC\xDC"

LINE_19

	; NEXT

	jsr	next

	; PRINT "€";

	jsr	pr_ss
	.text	1, "\x80"

	; TT=160

	ldx	#INTVAR_TT
	ldab	#160
	jsr	ld_ix_pb

LINE_20

	; FOR I=0 TO 448 STEP Q

	ldx	#INTVAR_I
	jsr	forclr_ix

	ldd	#448
	jsr	to_ip_pw

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; PRINT @I, "Ã";

	ldx	#INTVAR_I
	jsr	prat_ix

	jsr	pr_ss
	.text	1, "\xC3"

	; PRINT @I+21, "Ãð";

	ldx	#INTVAR_I
	ldab	#21
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	2, "\xC3\xF0"

	; NEXT

	jsr	next

LINE_21

	; FOR I=1 TO 9

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#9
	jsr	to_ip_pb

LINE_23

	; A=(INT(RND(O)*7)*3)+3

	ldx	#INTVAR_O
	jsr	rnd_fr1_ix

	ldab	#7
	jsr	mul_fr1_fr1_pb

	jsr	mul3_ir1_ir1

	ldab	#3
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=SHIFT(INT(RND(O)*6),1)+2

	ldx	#INTVAR_O
	jsr	rnd_fr1_ix

	ldab	#6
	jsr	mul_fr1_fr1_pb

	jsr	dbl_ir1_ir1

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; L=SHIFT(INT(RND(O)*3),1)+2

	ldx	#INTVAR_O
	jsr	rnd_fr1_ix

	jsr	mul3_fr1_fr1

	jsr	dbl_ir1_ir1

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; WHEN (B+L)>15 GOTO 23

	ldab	#15
	jsr	ld_ir1_pb

	ldx	#INTVAR_B
	ldd	#INTVAR_L
	jsr	add_ir2_ix_id

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_23
	jsr	jmpne_ir1_ix

LINE_24

	; FOR J=B*Q TO (B+L)*Q STEP Q

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_J
	jsr	for_ix_ir1

	ldx	#INTVAR_B
	ldd	#INTVAR_L
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	jsr	to_ip_ir1

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; K=PEEK(V+A+J)

	ldx	#INTVAR_V
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_J
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; IF K(K)=1 THEN

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_25
	jsr	jmpeq_ir1_ix

	; TT-=1

	ldx	#INTVAR_TT
	jsr	dec_ix_ix

LINE_25

	; PRINT @A+J, "Ã";

	ldx	#INTVAR_A
	ldd	#INTVAR_J
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\xC3"

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; TT-=1

	ldx	#INTVAR_TT
	jsr	dec_ix_ix

	; PRINT @375, "time\r";

	ldd	#375
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "time\r"

	; WHEN R>2 GOSUB 300

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTVAR_R
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_300
	jsr	jsrne_ir1_ix

LINE_26

	; J=RND(120)+V+8

	ldab	#120
	jsr	irnd_ir1_pb

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldab	#8
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; L=PEEK(J)

	ldx	#INTVAR_J
	jsr	peek_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; WHEN K(L)<>1 GOTO 26

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_26
	jsr	jmpne_ir1_ix

LINE_27

	; POKE J,42

	ldx	#INTVAR_J
	ldab	#42
	jsr	poke_ix_pb

	; W(O)=1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; W(1)=2

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; W(2)=3

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; FOR I=O TO 2

	ldd	#INTVAR_I
	ldx	#INTVAR_O
	jsr	for_id_ix

	ldab	#2
	jsr	to_ip_pb

	; Z(I)=O

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_Z
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y(I)=O

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT

	jsr	next

LINE_28

	; H(O)=30

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#INTARR_H
	jsr	arrref1_ir1_ix

	ldab	#30
	jsr	ld_ip_pb

	; H(1)=35

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_H
	jsr	arrref1_ir1_ix

	ldab	#35
	jsr	ld_ip_pb

	; H(2)=37

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_H
	jsr	arrref1_ir1_ix

	ldab	#37
	jsr	ld_ip_pb

	; K(30)=4

	ldab	#30
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; K(35)=4

	ldab	#35
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; K(37)=4

	ldab	#37
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

LINE_29

	; X(O)=1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; X(1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; X(2)=-1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	jsr	true_ip

LINE_30

	; FOR I=O TO 2

	ldd	#INTVAR_I
	ldx	#INTVAR_O
	jsr	for_id_ix

	ldab	#2
	jsr	to_ip_pb

	; F(I)=136

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrref1_ir1_ix

	ldab	#136
	jsr	ld_ip_pb

	; NEXT

	jsr	next

LINE_31

	; A=2

	ldx	#INTVAR_A
	ldab	#2
	jsr	ld_ix_pb

	; B=14

	ldx	#INTVAR_B
	ldab	#14
	jsr	ld_ix_pb

	; C=O

	ldd	#INTVAR_C
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; D=O

	ldd	#INTVAR_D
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; G=128

	ldx	#INTVAR_G
	ldab	#128
	jsr	ld_ix_pb

	; K=O

	ldd	#INTVAR_K
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; L=379

	ldx	#INTVAR_L
	ldd	#379
	jsr	ld_ix_pw

	; C2=O

	ldd	#INTVAR_C2
	ldx	#INTVAR_O
	jsr	ld_id_ix

LINE_32

	; FOR U=500 TO O STEP -1

	ldx	#INTVAR_U
	ldd	#500
	jsr	for_ix_pw

	ldx	#INTVAR_O
	jsr	to_ip_ix

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; PRINT @L, STR$(U);" ";

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_U
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; FOR Z2=1 TO Z3

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldx	#FLTVAR_Z3
	jsr	to_ip_ix

	; NEXT

	jsr	next

	; GOSUB 83

	ldx	#LINE_83
	jsr	gosub_ix

	; IF C THEN

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#LINE_33
	jsr	jmpeq_ir1_ix

	; CC=C

	ldd	#INTVAR_CC
	ldx	#INTVAR_C
	jsr	ld_id_ix

LINE_33

	; C=O

	ldd	#INTVAR_C
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; D=O

	ldd	#INTVAR_D
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; ON K(K) GOSUB 1,2,3,4,59

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongosub_ir1_is
	.byte	5
	.word	LINE_1, LINE_2, LINE_3, LINE_4, LINE_59

	; P=(Q*B)+A+V

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; IF D THEN

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; IF (K(G)<>2) OR (K(PEEK((Q*D)+P))=3) OR ((B+D)<O) THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#2
	jsr	ldne_ir1_ir1_pb

	ldx	#INTVAR_Q
	jsr	ld_ir2_ix

	ldx	#INTVAR_D
	jsr	mul_ir2_ir2_ix

	ldx	#INTVAR_P
	jsr	add_ir2_ir2_ix

	jsr	peek_ir2_ir2

	ldx	#INTARR_K
	jsr	arrval1_ir2_ix

	ldab	#3
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_B
	ldd	#INTVAR_D
	jsr	add_ir2_ix_id

	ldx	#INTVAR_O
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; D=O

	ldd	#INTVAR_D
	ldx	#INTVAR_O
	jsr	ld_id_ix

LINE_34

	; IF C THEN

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#LINE_35
	jsr	jmpeq_ir1_ix

	; IF K(PEEK(P+C))=3 THEN

	ldx	#INTVAR_P
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#3
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_35
	jsr	jmpeq_ir1_ix

	; C=O

	ldd	#INTVAR_C
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; K=O

	ldd	#INTVAR_K
	ldx	#INTVAR_O
	jsr	ld_id_ix

LINE_35

	; POKE P,G

	ldd	#INTVAR_P
	ldx	#INTVAR_G
	jsr	poke_id_ix

	; A+=C

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ix_ix_ir1

	; B+=D

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	add_ix_ix_ir1

	; N=(Q*B)+A+V

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_N
	jsr	ld_ix_ir1

	; G=PEEK(N)

	ldx	#INTVAR_N
	jsr	peek_ir1_ix

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

	; WHEN K(G)<>1 GOTO 41

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_41
	jsr	jmpne_ir1_ix

LINE_39

	; T+=LV

	ldx	#FLTVAR_LV
	jsr	ld_fr1_fx

	ldx	#FLTVAR_T
	jsr	add_fx_fx_fr1

	; J=PEEK(9) AND 128

	ldab	#9
	jsr	peek_ir1_pb

	ldab	#128
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; POKE 49151,J

	ldd	#49151
	ldx	#INTVAR_J
	jsr	poke_pw_ix

	; POKE 49151,128-J

	ldab	#128
	ldx	#INTVAR_J
	jsr	sub_ir1_pb_ix

	ldd	#49151
	jsr	poke_pw_ir1

	; IF G=42 THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#42
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_40
	jsr	jmpeq_ir1_ix

	; T+=LV*50

	ldx	#FLTVAR_LV
	jsr	ld_fr1_fx

	ldab	#50
	jsr	mul_fr1_fr1_pb

	ldx	#FLTVAR_T
	jsr	add_fx_fx_fr1

	; FOR I=200 TO 210

	ldx	#INTVAR_I
	ldab	#200
	jsr	for_ix_pb

	ldab	#210
	jsr	to_ip_pb

	; U+=5

	ldx	#INTVAR_U
	ldab	#5
	jsr	add_ix_ix_pb

	; PRINT @L, STR$(U);" ";

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_U
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SOUND I,1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_40

	; PRINT @247, STR$(T);" \r";

	ldab	#247
	jsr	prat_pb

	ldx	#FLTVAR_T
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; G=128

	ldx	#INTVAR_G
	ldab	#128
	jsr	ld_ix_pb

	; M+=1

	ldx	#INTVAR_M
	jsr	inc_ix_ix

	; IF M=TT THEN

	ldx	#INTVAR_M
	ldd	#INTVAR_TT
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_41
	jsr	jmpeq_ir1_ix

	; POKE N,P(C1)

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldx	#INTARR_P
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_N
	jsr	poke_ix_ir1

	; FOR I=1 TO LV

	ldx	#INTVAR_I
	jsr	forone_ix

	ldx	#FLTVAR_LV
	jsr	to_ip_ix

	; GOSUB 90

	ldx	#LINE_90
	jsr	gosub_ix

	; NEXT

	jsr	next

	; GOTO 9

	ldx	#LINE_9
	jsr	goto_ix

LINE_41

	; IF K(G)=4 THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#4
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_42
	jsr	jmpeq_ir1_ix

	; POKE N,191

	ldx	#INTVAR_N
	ldab	#191
	jsr	poke_ix_pb

	; GOTO 51

	ldx	#LINE_51
	jsr	goto_ix

LINE_42

	; POKE N,P(C1)

	ldx	#INTVAR_C1
	jsr	ld_ir1_ix

	ldx	#INTARR_P
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_N
	jsr	poke_ix_ir1

	; E=(E<2) AND (E+1)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTVAR_E
	jsr	inc_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_E
	jsr	ld_ix_ir1

	; W=W(E)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_W
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_W
	jsr	ld_ix_ir1

	; Z=Z(E)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_Z
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z
	jsr	ld_ix_ir1

	; H=H(E)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_H
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; X=X(E)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y(E)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; F=F(E)

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_F
	jsr	ld_ix_ir1

	; P=(Q*Z)+W+V

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Z
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; POKE P,F

	ldd	#INTVAR_P
	ldx	#INTVAR_F
	jsr	poke_id_ix

LINE_43

	; IF (K(PEEK(P-Q))=2) OR (K(PEEK(P+Q))=2) THEN

	ldx	#INTVAR_P
	ldd	#INTVAR_Q
	jsr	sub_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_P
	ldd	#INTVAR_Q
	jsr	add_ir2_ix_id

	jsr	peek_ir2_ir2

	ldx	#INTARR_K
	jsr	arrval1_ir2_ix

	ldab	#2
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_44
	jsr	jmpeq_ir1_ix

	; IF RND(O)>0.1 THEN

	ldx	#FLT_0p10000
	jsr	ld_fr1_fx

	ldx	#INTVAR_O
	jsr	rnd_fr2_ix

	jsr	ldlt_ir1_fr1_fr2

	ldx	#LINE_44
	jsr	jmpeq_ir1_ix

	; X=O

	ldd	#INTVAR_X
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; Y=SGN(B-Z)

	ldx	#INTVAR_B
	ldd	#INTVAR_Z
	jsr	sub_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

LINE_44

	; IF (K(PEEK((Y*Q)+P))=3) OR ((Z=B) AND (SHIFT(Z,-1)=INT(SHIFT(Z,-1)))) THEN

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_Q
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#3
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_Z
	ldd	#INTVAR_B
	jsr	ldeq_ir2_ix_id

	ldx	#INTVAR_Z
	jsr	hlf_fr3_ix

	ldx	#INTVAR_Z
	jsr	hlf_fr4_ix

	jsr	ldeq_ir3_fr3_ir4

	jsr	and_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_45
	jsr	jmpeq_ir1_ix

	; Y=O

	ldd	#INTVAR_Y
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; X=SGN(A-W)

	ldx	#INTVAR_A
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

LINE_45

	; W+=X

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_W
	jsr	add_ix_ix_ir1

	; Z+=Y

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_Z
	jsr	add_ix_ix_ir1

	; IF (W=O) OR (W=21) THEN

	ldx	#INTVAR_W
	ldd	#INTVAR_O
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_W
	jsr	ld_ir2_ix

	ldab	#21
	jsr	ldeq_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_46
	jsr	jmpeq_ir1_ix

	; X=-X

	ldx	#INTVAR_X
	jsr	neg_ix_ix

LINE_46

	; N=(Q*Z)+W+V

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_Z
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_N
	jsr	ld_ix_ir1

	; F=PEEK(N)

	ldx	#INTVAR_N
	jsr	peek_ir1_ix

	ldx	#INTVAR_F
	jsr	ld_ix_ir1

	; IF K(F)=5 THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#5
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_47
	jsr	jmpeq_ir1_ix

	; POKE N,191

	ldx	#INTVAR_N
	ldab	#191
	jsr	poke_ix_pb

	; GOTO 51

	ldx	#LINE_51
	jsr	goto_ix

LINE_47

	; IF K(F)<>4 THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#4
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_48
	jsr	jmpeq_ir1_ix

	; POKE N,H

	ldd	#INTVAR_N
	ldx	#INTVAR_H
	jsr	poke_id_ix

	; W(E)=W

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Z(E)=Z

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_Z
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; F(E)=F

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; X(E)=X

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y(E)=Y

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_48

	; FOR I=O TO 2

	ldd	#INTVAR_I
	ldx	#INTVAR_O
	jsr	for_id_ix

	ldab	#2
	jsr	to_ip_pb

	; IF H(I)<>F THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_H
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_F
	jsr	ldne_ir1_ir1_ix

	ldx	#LINE_49
	jsr	jmpeq_ir1_ix

	; NEXT

	jsr	next

	; STOP

	jsr	stop

LINE_49

	; F=F(I)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_F
	jsr	ld_ix_ir1

	; I=2

	ldx	#INTVAR_I
	ldab	#2
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; POKE N,H

	ldd	#INTVAR_N
	ldx	#INTVAR_H
	jsr	poke_id_ix

	; W(E)=W

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Z(E)=Z

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_Z
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; F(E)=F

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; X(E)=X

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y(E)=Y

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_51

	; U=O

	ldd	#INTVAR_U
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; NEXT

	jsr	next

	; FOR I=1 TO 20

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#20
	jsr	to_ip_pb

	; POKE 49151,68

	ldab	#68
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; FOR J=1 TO 100

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#100
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; SOUND RND(100)+110,1

	ldab	#100
	jsr	irnd_ir1_pb

	ldab	#110
	jsr	add_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_52

	; PRINT @375, " nabbed!";

	ldd	#375
	jsr	prat_pw

	jsr	pr_ss
	.text	8, " nabbed!"

	; POKE V+382,33

	ldx	#INTVAR_V
	ldd	#382
	jsr	add_ir1_ix_pw

	ldab	#33
	jsr	poke_ir1_pb

	; SOUND 1,5

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#5
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_53

	; PRINT @471, "PRESS r";

	ldd	#471
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "PRESS r"

	; PRINT @503, "TO REPLA";

	ldd	#503
	jsr	prat_pw

	jsr	pr_ss
	.text	8, "TO REPLA"

	; POKE V+511,89

	ldx	#INTVAR_V
	ldd	#511
	jsr	add_ir1_ix_pw

	ldab	#89
	jsr	poke_ir1_pb

	; IF T>HS THEN

	ldx	#FLTVAR_HS
	ldd	#FLTVAR_T
	jsr	ldlt_ir1_fx_fd

	ldx	#LINE_54
	jsr	jmpeq_ir1_ix

	; HS=T

	ldd	#FLTVAR_HS
	ldx	#FLTVAR_T
	jsr	ld_fd_fx

LINE_54

	; GOSUB 76

	ldx	#LINE_76
	jsr	gosub_ix

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

LINE_55

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; WHEN A$="" GOTO 55

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_55
	jsr	jmpne_ir1_ix

LINE_56

	; WHEN A$="Q" GOTO 500

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Q"

	ldx	#LINE_500
	jsr	jmpne_ir1_ix

	; IF A$="N" THEN

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_57
	jsr	jmpeq_ir1_ix

	; GOSUB 400

	ldx	#LINE_400
	jsr	gosub_ix

	; GOTO 8

	ldx	#LINE_8
	jsr	goto_ix

LINE_57

	; WHEN A$<>"R" GOTO 55

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldne_ir1_sr1_ss
	.text	1, "R"

	ldx	#LINE_55
	jsr	jmpne_ir1_ix

LINE_58

	; PRINT @375, "         ";

	ldd	#375
	jsr	prat_pw

	jsr	pr_ss
	.text	9, "         "

	; PRINT @471, "       ";

	ldd	#471
	jsr	prat_pw

	jsr	pr_ss
	.text	7, "       "

	; PRINT @503, "        ";

	ldd	#503
	jsr	prat_pw

	jsr	pr_ss
	.text	8, "        "

	; POKE V+511,96

	ldx	#INTVAR_V
	ldd	#511
	jsr	add_ir1_ix_pw

	ldab	#96
	jsr	poke_ir1_pb

	; GOTO 8

	ldx	#LINE_8
	jsr	goto_ix

LINE_59

	; REM SHOVE!

LINE_60

	; IF CC=O THEN

	ldx	#INTVAR_CC
	ldd	#INTVAR_O
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_61
	jsr	jmpeq_ir1_ix

	; SOUND 1,10

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; K=O

	ldd	#INTVAR_K
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_61

	; IF SH=0 THEN

	ldx	#INTVAR_SH
	jsr	ld_ir1_ix

	ldx	#LINE_62
	jsr	jmpne_ir1_ix

	; SOUND 20,10

	ldab	#20
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; K=O

	ldd	#INTVAR_K
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_62

	; P=(Q*B)+V

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; K=O

	ldd	#INTVAR_K
	ldx	#INTVAR_O
	jsr	ld_id_ix

LINE_63

	; FOR I=A TO (CC>O) AND 21 STEP CC

	ldd	#INTVAR_I
	ldx	#INTVAR_A
	jsr	for_id_ix

	ldx	#INTVAR_O
	ldd	#INTVAR_CC
	jsr	ldlt_ir1_ix_id

	ldab	#21
	jsr	and_ir1_ir1_pb

	jsr	to_ip_ir1

	ldx	#INTVAR_CC
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; S(I)=PEEK(P+I)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_P
	ldd	#INTVAR_I
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	jsr	ld_ip_ir1

	; POKE P+I,P((INT(I) AND 1)+3)

	ldx	#INTVAR_P
	ldd	#INTVAR_I
	jsr	add_ir1_ix_id

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldab	#1
	jsr	and_ir2_ir2_pb

	ldab	#3
	jsr	add_ir2_ir2_pb

	ldx	#INTARR_P
	jsr	arrval1_ir2_ix

	jsr	poke_ir1_ir2

	; SOUND S(I),1

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; WHEN K(S(I))=4 GOSUB 70

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#4
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_70
	jsr	jsrne_ir1_ix

LINE_65

	; NEXT

	jsr	next

LINE_66

	; FOR I=A TO (CC>O) AND 21 STEP CC

	ldd	#INTVAR_I
	ldx	#INTVAR_A
	jsr	for_id_ix

	ldx	#INTVAR_O
	ldd	#INTVAR_CC
	jsr	ldlt_ir1_ix_id

	ldab	#21
	jsr	and_ir1_ir1_pb

	jsr	to_ip_ir1

	ldx	#INTVAR_CC
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

LINE_67

	; POKE P+I,S(I)

	ldx	#INTVAR_P
	ldd	#INTVAR_I
	jsr	add_ir1_ix_id

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldx	#INTARR_S
	jsr	arrval1_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT

	jsr	next

	; SH-=1

	ldx	#INTVAR_SH
	jsr	dec_ix_ix

LINE_68

	; PRINT @151, "shoves";STR$(SH);

	ldab	#151
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "shoves"

	ldx	#INTVAR_SH
	jsr	str_sr1_ix

	jsr	pr_sr1

LINE_69

	; RETURN

	jsr	return

LINE_70

	; FOR J=O TO 2

	ldd	#INTVAR_J
	ldx	#INTVAR_O
	jsr	for_id_ix

	ldab	#2
	jsr	to_ip_pb

	; IF S(I)<>H(J) THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldx	#INTARR_H
	jsr	arrval1_ir2_ix

	jsr	ldne_ir1_ir1_ir2

	ldx	#LINE_71
	jsr	jmpeq_ir1_ix

	; NEXT

	jsr	next

	; STOP

	jsr	stop

LINE_71

	; S(I)=F(J)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrval1_ir1_ix

	jsr	ld_ip_ir1

LINE_72

	; W(J)=INT((RND(O)*18)+2)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_O
	jsr	rnd_fr1_ix

	ldab	#18
	jsr	mul_fr1_fr1_pb

	ldab	#2
	jsr	add_fr1_fr1_pb

	jsr	ld_ip_ir1

	; Z(J)=0

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_Z
	jsr	arrref1_ir1_ix

	jsr	clr_ip

	; F(J)=PEEK(W(J)+V)

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_W
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	jsr	ld_ip_ir1

	; WHEN K(F(J))=5 GOTO 72

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_F
	jsr	arrval1_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#5
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_72
	jsr	jmpne_ir1_ix

LINE_73

	; X(J)=-1

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	jsr	true_ip

	; IF RND(O)>0.5 THEN

	ldx	#FLT_0p50000
	jsr	ld_fr1_fx

	ldx	#INTVAR_O
	jsr	rnd_fr2_ix

	jsr	ldlt_ir1_fr1_fr2

	ldx	#LINE_74
	jsr	jmpeq_ir1_ix

	; X(J)=1

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	jsr	one_ip

LINE_74

	; Y(J)=O

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; T+=LV*50

	ldx	#FLTVAR_LV
	jsr	ld_fr1_fx

	ldab	#50
	jsr	mul_fr1_fr1_pb

	ldx	#FLTVAR_T
	jsr	add_fx_fx_fr1

	; SOUND 10,4

	ldab	#10
	jsr	ld_ir1_pb

	ldab	#4
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; J=2

	ldx	#INTVAR_J
	ldab	#2
	jsr	ld_ix_pb

	; NEXT

	jsr	next

LINE_75

	; PRINT @215, "score:";

	ldab	#215
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "score:"

	; PRINT @247, STR$(T);" \r";

	ldab	#247
	jsr	prat_pb

	ldx	#FLTVAR_T
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; RETURN

	jsr	return

LINE_76

	; PRINT @279, "high:";

	ldd	#279
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "high:"

	; PRINT @311, STR$(HS);" \r";

	ldd	#311
	jsr	prat_pw

	ldx	#FLTVAR_HS
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; RETURN

	jsr	return

LINE_83

	; K=O

	ldd	#INTVAR_K
	ldx	#INTVAR_O
	jsr	ld_id_ix

	; IF PEEK(2) AND NOT PEEK(16952) AND 4 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	and_ir1_ir1_pb

	ldx	#LINE_84
	jsr	jmpeq_ir1_ix

	; K=87

	ldx	#INTVAR_K
	ldab	#87
	jsr	ld_ix_pb

LINE_84

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16946
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_85
	jsr	jmpeq_ir1_ix

	; K=65

	ldx	#INTVAR_K
	ldab	#65
	jsr	ld_ix_pb

LINE_85

	; IF PEEK(2) AND NOT PEEK(16948) AND 4 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16948
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	and_ir1_ir1_pb

	ldx	#LINE_86
	jsr	jmpeq_ir1_ix

	; K=83

	ldx	#INTVAR_K
	ldab	#83
	jsr	ld_ix_pb

LINE_86

	; IF PEEK(2) AND NOT PEEK(16949) AND 1 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16949
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_87
	jsr	jmpeq_ir1_ix

	; K=68

	ldx	#INTVAR_K
	ldab	#68
	jsr	ld_ix_pb

LINE_87

	; IF PEEK(2) AND NOT PEEK(16952) AND 8 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#8
	jsr	and_ir1_ir1_pb

	ldx	#LINE_89
	jsr	jmpeq_ir1_ix

	; K=32

	ldx	#INTVAR_K
	ldab	#32
	jsr	ld_ix_pb

LINE_89

	; RETURN

	jsr	return

LINE_90

	; PRINT @215, "SCORE:";

	ldab	#215
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "SCORE:"

	; FOR J=100 TO 150 STEP 2

	ldx	#INTVAR_J
	ldab	#100
	jsr	for_ix_pb

	ldab	#150
	jsr	to_ip_pb

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; T+=LV

	ldx	#FLTVAR_LV
	jsr	ld_fr1_fx

	ldx	#FLTVAR_T
	jsr	add_fx_fx_fr1

	; PRINT @247, STR$(T);" \r";

	ldab	#247
	jsr	prat_pb

	ldx	#FLTVAR_T
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; SOUND J,1

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_200

	; PRINT @379, "'S UP";

	ldd	#379
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "'S UP"

	; FOR I=1 TO 20

	ldx	#INTVAR_I
	jsr	forone_ix

	ldab	#20
	jsr	to_ip_pb

	; POKE 49151,68

	ldab	#68
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; FOR J=1 TO 100

	ldx	#INTVAR_J
	jsr	forone_ix

	ldab	#100
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; SOUND RND(100)+110,1

	ldab	#100
	jsr	irnd_ir1_pb

	ldab	#110
	jsr	add_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_210

	; GOTO 53

	ldx	#LINE_53
	jsr	goto_ix

LINE_300

	; L=3

	ldx	#INTVAR_L
	ldab	#3
	jsr	ld_ix_pb

	; IF R>4 THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTVAR_R
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_305
	jsr	jmpeq_ir1_ix

	; L=5

	ldx	#INTVAR_L
	ldab	#5
	jsr	ld_ix_pb

	; IF R>9 THEN

	ldab	#9
	jsr	ld_ir1_pb

	ldx	#INTVAR_R
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_305
	jsr	jmpeq_ir1_ix

	; L=7

	ldx	#INTVAR_L
	ldab	#7
	jsr	ld_ix_pb

	; IF R>14 THEN

	ldab	#14
	jsr	ld_ir1_pb

	ldx	#INTVAR_R
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_305
	jsr	jmpeq_ir1_ix

	; L=9

	ldx	#INTVAR_L
	ldab	#9
	jsr	ld_ix_pb

LINE_305

	; FOR I=1 TO RND(L)

	ldx	#INTVAR_I
	jsr	forone_ix

	ldx	#INTVAR_L
	jsr	rnd_fr1_ix

	jsr	to_ip_ir1

	; ON RND(2) GOSUB 310,320

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	ongosub_ir1_is
	.byte	2
	.word	LINE_310, LINE_320

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_310

	; J=SHIFT(RND(5),1)+1

	ldab	#5
	jsr	irnd_ir1_pb

	jsr	dbl_ir1_ir1

	jsr	inc_ir1_ir1

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; IF PEEK((Q*J)+V+21)=220 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldab	#21
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#220
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_311
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_311

	; PRINT @Q*J, "Ü";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\xDC"

	; IF PEEK((Q*J)+V+64)=220 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldab	#64
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#220
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_312
	jsr	jmpeq_ir1_ix

	; PRINT @(Q*J)+Q, "€";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x80"

LINE_312

	; IF PEEK((Q*J)+V-64)=220 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldab	#64
	jsr	sub_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#220
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_315
	jsr	jmpeq_ir1_ix

	; PRINT @(Q*J)-Q, "€";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	sub_ir1_ir1_ix

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x80"

LINE_315

	; RETURN

	jsr	return

LINE_320

	; J=SHIFT(RND(5),1)+1

	ldab	#5
	jsr	irnd_ir1_pb

	jsr	dbl_ir1_ir1

	jsr	inc_ir1_ir1

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; IF PEEK((Q*J)+V)=220 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldab	#220
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_321
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_321

	; PRINT @(Q*J)+21, "Ü";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldab	#21
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\xDC"

	; IF PEEK((Q*J)+V+85)=220 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldab	#85
	jsr	add_ir1_ir1_pb

	jsr	peek_ir1_ir1

	ldab	#220
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_322
	jsr	jmpeq_ir1_ix

	; PRINT @(Q*J)+Q+21, "€";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_Q
	jsr	add_ir1_ir1_ix

	ldab	#21
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x80"

LINE_322

	; IF PEEK((Q*J)+V+-43)=220 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldab	#-43
	jsr	add_ir1_ir1_nb

	jsr	peek_ir1_ir1

	ldab	#220
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_325
	jsr	jmpeq_ir1_ix

	; PRINT @(Q*J)+21-Q, "€";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	mul_ir1_ir1_ix

	ldab	#21
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_Q
	jsr	sub_ir1_ir1_ix

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\x80"

LINE_325

	; RETURN

	jsr	return

LINE_400

	; CLS

	jsr	cls

	; PRINT TAB(12);"closeout!\r";

	ldab	#12
	jsr	prtab_pb

	jsr	pr_ss
	.text	10, "closeout!\r"

LINE_410

	; PRINT TAB(10);"BY L. L. BEH\r";

	ldab	#10
	jsr	prtab_pb

	jsr	pr_ss
	.text	13, "BY L. L. BEH\r"

LINE_420

	; PRINT TAB(6);"COMPUTE! MARCH 1983\r";

	ldab	#6
	jsr	prtab_pb

	jsr	pr_ss
	.text	20, "COMPUTE! MARCH 1983\r"

LINE_430

	; PRINT "  MC-10 EDITS JIM GERRIE 2020\r";

	jsr	pr_ss
	.text	30, "  MC-10 EDITS JIM GERRIE 2020\r"

LINE_435

	; PRINT " USING MCBASIC BY GREG DIONNE\r";

	jsr	pr_ss
	.text	30, " USING MCBASIC BY GREG DIONNE\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_440

	; PRINT "THE OBJECT OF 'CLOSEOUT' IS TO\r";

	jsr	pr_ss
	.text	31, "THE OBJECT OF 'CLOSEOUT' IS TO\r"

LINE_441

	; PRINT "SNATCH UP AS MANY SALE ITEMS\r";

	jsr	pr_ss
	.text	29, "SNATCH UP AS MANY SALE ITEMS\r"

LINE_442

	; PRINT "AS POSSIBLE WHILE EVADING THE\r";

	jsr	pr_ss
	.text	30, "AS POSSIBLE WHILE EVADING THE\r"

LINE_443

	; PRINT "HOSTILE BARGAIN HUNTERS. IF\r";

	jsr	pr_ss
	.text	28, "HOSTILE BARGAIN HUNTERS. IF\r"

LINE_444

	; PRINT "THEY GET TOO CLOSE, USE YOUR\r";

	jsr	pr_ss
	.text	29, "THEY GET TOO CLOSE, USE YOUR\r"

LINE_445

	; PRINT "'SHOVE' TO CHASE THEM BACK TO\r";

	jsr	pr_ss
	.text	30, "'SHOVE' TO CHASE THEM BACK TO\r"

LINE_446

	; PRINT "THE TOP FLOOR. USE wasd TO MOVE\r";

	jsr	pr_ss
	.text	32, "THE TOP FLOOR. USE wasd TO MOVE\r"

LINE_447

	; PRINT "AND space TO SHOVE.\r";

	jsr	pr_ss
	.text	20, "AND space TO SHOVE.\r"

LINE_448

	; PRINT @490, "LEVEL (1-3)?";

	ldd	#490
	jsr	prat_pw

	jsr	pr_ss
	.text	12, "LEVEL (1-3)?"

	; A$=INKEY$

	ldx	#STRVAR_A
	jsr	inkey_sx

	; WHEN (A$<"1") OR (A$>"3") GOTO 448

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	jsr	ldlt_ir1_sr1_ss
	.text	1, "1"

	jsr	ld_sr2_ss
	.text	1, "3"

	ldx	#STRVAR_A
	jsr	ldlt_ir2_sr2_sx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_448
	jsr	jmpne_ir1_ix

LINE_449

	; Z3=550-(VAL(A$)*50)

	ldx	#STRVAR_A
	jsr	val_fr1_sx

	ldab	#50
	jsr	mul_fr1_fr1_pb

	ldd	#550
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_Z3
	jsr	ld_fx_fr1

	; LV=VAL(A$)

	ldx	#STRVAR_A
	jsr	val_fr1_sx

	ldx	#FLTVAR_LV
	jsr	ld_fx_fr1

	; CLS

	jsr	cls

	; RETURN

	jsr	return

LINE_500

	; END

	jsr	progend

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

	.module	mdstrlox
strlox
	ldab	,x
	ldx	1,x
	stx	tmp2
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

add_fx_fx_fr1			; numCalls = 4
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

add_ir1_ir1_ix			; numCalls = 21
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_nb			; numCalls = 1
	.module	modadd_ir1_ir1_nb
	ldaa	#-1
	addd	r1+1
	std	r1+1
	ldab	#-1
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 13
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 7
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

add_ir1_ix_pb			; numCalls = 1
	.module	modadd_ir1_ix_pb
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir1_ix_pw			; numCalls = 3
	.module	modadd_ir1_ix_pw
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ir2_ix			; numCalls = 1
	.module	modadd_ir2_ir2_ix
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
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

add_ir2_ix_id			; numCalls = 3
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

add_ix_ix_ir1			; numCalls = 4
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 2
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 6
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir1_ir1_pb			; numCalls = 12
	.module	modand_ir1_ir1_pb
	andb	r1+2
	clra
	std	r1+1
	staa	r1
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

and_ir2_ir2_pb			; numCalls = 1
	.module	modand_ir2_ir2_pb
	andb	r2+2
	clra
	std	r2+1
	staa	r2
	rts

arrdim1_ir1_ix			; numCalls = 9
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

arrref1_ir1_ix			; numCalls = 53
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 29
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

arrval1_ir2_ix			; numCalls = 5
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

clr_fx			; numCalls = 1
	.module	modclr_fx
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

clr_ip			; numCalls = 1
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 2
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 3
	.module	modcls
	jmp	R_CLS

com_ir2_ir2			; numCalls = 5
	.module	modcom_ir2_ir2
	com	r2+2
	com	r2+1
	com	r2
	rts

dbl_ir1_ir1			; numCalls = 4
	.module	moddbl_ir1_ir1
	ldx	#r1
	rol	2,x
	rol	1,x
	rol	0,x
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

for_id_ix			; numCalls = 6
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

for_ix_ir1			; numCalls = 1
	.module	modfor_ix_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 2
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
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

forone_ix			; numCalls = 11
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 7
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 9
	.module	modgoto_ix
	ins
	ins
	jmp	,x

hlf_fr3_ix			; numCalls = 1
	.module	modhlf_fr3_ix
	ldab	0,x
	asrb
	stab	r3
	ldd	1,x
	rora
	rorb
	std	r3+1
	ldd	#0
	rora
	std	r3+3
	rts

hlf_fr4_ix			; numCalls = 1
	.module	modhlf_fr4_ix
	ldab	0,x
	asrb
	stab	r4
	ldd	1,x
	rora
	rorb
	std	r4+1
	ldd	#0
	rora
	std	r4+3
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

inc_ir2_ix			; numCalls = 1
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

irnd_ir1_pb			; numCalls = 6
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

jmpeq_ir1_ix			; numCalls = 36
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

jmpne_ir1_ix			; numCalls = 9
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

jsrne_ir1_ix			; numCalls = 2
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

ld_fr1_fx			; numCalls = 6
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
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

ld_id_ix			; numCalls = 22
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

ld_ip_ir1			; numCalls = 17
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 26
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 102
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

ld_ir1_pb			; numCalls = 54
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

ld_ir2_pb			; numCalls = 9
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 30
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 18
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 2
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sr1_ss			; numCalls = 1
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 7
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sr2_ss			; numCalls = 1
	.module	modld_sr2_ss
	pulx
	ldab	,x
	stab	r2
	inx
	stx	r2+1
	abx
	jmp	,x

ld_sx_sr1			; numCalls = 1
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_pb			; numCalls = 15
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ix_id			; numCalls = 3
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

ldeq_ir2_ir2_pb			; numCalls = 3
	.module	modldeq_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ix_id			; numCalls = 1
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

ldeq_ir3_fr3_ir4			; numCalls = 1
	.module	modldeq_ir3_fr3_ir4
	ldd	r3+3
	bne	_done
	ldd	r3+1
	subd	r4+1
	bne	_done
	ldab	r3
	cmpb	r4
_done
	jsr	geteq
	std	r3+1
	stab	r3
	rts

ldlt_ir1_fr1_fr2			; numCalls = 2
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

ldlt_ir1_fx_fd			; numCalls = 1
	.module	modldlt_ir1_fx_fd
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

ldlt_ir1_ir1_ir2			; numCalls = 1
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

ldlt_ir1_ir1_pb			; numCalls = 1
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

ldlt_ir1_ix_id			; numCalls = 2
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

ldlt_ir2_sr2_sx			; numCalls = 1
	.module	modldlt_ir2_sr2_sx
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	jsr	strlox
	jsr	getlo
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

midT_sr1_sr1_pb			; numCalls = 2
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

mul3_ir1_ir1			; numCalls = 1
	.module	modmul3_ir1_ir1
	ldx	#r1
	jmp	mul3i

mul_fr1_fr1_pb			; numCalls = 6
	.module	modmul_fr1_fr1_pb
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_ix			; numCalls = 20
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir2_ir2_ix			; numCalls = 1
	.module	modmul_ir2_ir2_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r2
	jmp	mulintx

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

neg_ix_ix			; numCalls = 1
	.module	modneg_ix_ix
	jmp	negxi

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

one_ip			; numCalls = 7
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 3
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

or_ir1_ir1_ir2			; numCalls = 6
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_ir1			; numCalls = 12
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ix			; numCalls = 3
	.module	modpeek_ir1_ix
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pb			; numCalls = 6
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_ir2			; numCalls = 2
	.module	modpeek_ir2_ir2
	ldx	r2+1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir2_pw			; numCalls = 5
	.module	modpeek_ir2_pw
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_id_ix			; numCalls = 4
	.module	modpoke_id_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ir1_ir2			; numCalls = 2
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 3
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_ix_ir1			; numCalls = 2
	.module	modpoke_ix_ir1
	ldab	r1+2
	ldx	1,x
	stab	,x
	rts

poke_ix_pb			; numCalls = 3
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

poke_pw_ir1			; numCalls = 6
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

poke_pw_ix			; numCalls = 1
	.module	modpoke_pw_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 9
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 47
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_ir1			; numCalls = 10
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 3
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 8
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 11
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

prtab_pb			; numCalls = 3
	.module	modprtab_pb
	jmp	prtab

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

rnd_fr1_ix			; numCalls = 5
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

rnd_fr2_ix			; numCalls = 2
	.module	modrnd_fr2_ix
	ldab	0,x
	stab	tmp1+1
	bmi	_neg
	ldd	1,x
	std	tmp2
	beq	_flt
	jsr	irnd
	std	r2+1
	ldab	tmp1
	stab	r2
	ldd	#0
	std	r2+3
	rts
_neg
	ldd	1,x
	std	tmp2
_flt
	jsr	rnd
	std	r2+3
	ldd	#0
	std	r2+1
	stab	r2
	rts

rsub_fr1_fr1_pw			; numCalls = 1
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

shift_ir1_ir1_pb			; numCalls = 2
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 9
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

stop			; numCalls = 2
	.module	modstop
	ldx	#R_BKMSG-1
	jmp	R_BREAK

str_sr1_fx			; numCalls = 4
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

sub_ir1_ir1_ix			; numCalls = 2
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
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

sub_ir1_ix_id			; numCalls = 3
	.module	modsub_ir1_ix_id
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

sub_ir1_pb_ix			; numCalls = 1
	.module	modsub_ir1_pb_ix
	subb	2,x
	stab	r1+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r1
	rts

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_ip_ir1			; numCalls = 4
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_ix			; numCalls = 3
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 15
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

true_ip			; numCalls = 2
	.module	modtrue_ip
	ldx	letptr
	ldd	#-1
	stab	0,x
	std	1,x
	rts

true_ix			; numCalls = 2
	.module	modtrue_ix
	ldd	#-1
	stab	0,x
	std	1,x
	rts

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
enddata


; fixed-point constants
FLT_0p10000	.byte	$00, $00, $00, $19, $9a
FLT_0p50000	.byte	$00, $00, $00, $80, $00

; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_C1	.block	3
INTVAR_C2	.block	3
INTVAR_CC	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_M	.block	3
INTVAR_N	.block	3
INTVAR_O	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_SH	.block	3
INTVAR_TT	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_W	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
INTVAR_Z2	.block	3
FLTVAR_HS	.block	5
FLTVAR_LV	.block	5
FLTVAR_T	.block	5
FLTVAR_Z3	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_LN	.block	3
; Numeric Arrays
INTARR_F	.block	4	; dims=1
INTARR_H	.block	4	; dims=1
INTARR_K	.block	4	; dims=1
INTARR_P	.block	4	; dims=1
INTARR_S	.block	4	; dims=1
INTARR_W	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
INTARR_Z	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

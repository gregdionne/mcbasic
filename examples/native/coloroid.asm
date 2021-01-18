; Assembly for coloroid.bas
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

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; CLEAR 1000

	jsr	clear

	; DIM X(256),Y(256),L(256),E,J,I,W,X,Y,S,M,U,K,L,B,C,T,Q,H,R,H$,WI,LV,OF,KH,PA(16),R

	ldd	#256
	jsr	ld_ir1_pw

	ldx	#INTARR_X
	jsr	arrdim1_ir1_ix

	ldd	#256
	jsr	ld_ir1_pw

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldd	#256
	jsr	ld_ir1_pw

	ldx	#INTARR_L
	jsr	arrdim1_ir1_ix

	ldab	#16
	jsr	ld_ir1_pb

	ldx	#INTARR_PA
	jsr	arrdim1_ir1_ix

	; GOTO 800

	ldx	#LINE_800
	jsr	goto_ix

LINE_2

	; PRINT @(32*Y)+X, CHR$(((C-1)*16)+143);

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	sub_ir1_ir1_pb

	ldab	#16
	jsr	mul_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	; U-=E

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_U
	jsr	sub_ix_ix_ir1

	; RETURN

	jsr	return

LINE_3

	; W-=E

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_W
	jsr	sub_ix_ix_ir1

	; X(W)=X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y(W)=Y

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

	; L(C)-=E

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	jsr	sub_ip_ip_ir1

	; L(R)+=E

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	jsr	add_ip_ip_ir1

	; RETURN

	jsr	return

LINE_4

	; W=0

	ldx	#INTVAR_W
	ldab	#0
	jsr	ld_ix_pb

	; U=0

	ldx	#INTVAR_U
	ldab	#0
	jsr	ld_ix_pb

	; X(0)=0

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; Y(0)=0

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; L(H)-=E

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	jsr	sub_ip_ip_ir1

	; L(R)+=E

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	jsr	add_ip_ip_ir1

	; C=H

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; X=0

	ldx	#INTVAR_X
	ldab	#0
	jsr	ld_ix_pb

	; Y=0

	ldx	#INTVAR_Y
	ldab	#0
	jsr	ld_ix_pb

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

LINE_5

	; I=X(W)

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_I
	jsr	ld_ix_ir1

	; J=Y(W)

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; W+=E

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_W
	jsr	add_ix_ix_ir1

	; X=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=J+S

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

LINE_6

	; IF Y<(L-E) THEN

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_E
	jsr	sub_ir2_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_7
	jsr	jmpeq_ir1_ix

	; WHEN POINT(X*2,Y*2)=R GOSUB 3

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#2
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#2
	jsr	mul_ir2_ir2_pb

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_R
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_3
	jsr	jsrne_ir1_ix

LINE_7

	; IF (J-S)>E THEN

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldx	#INTVAR_S
	jsr	sub_ir2_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_8
	jsr	jmpeq_ir1_ix

	; IF POINT(X*2,(J-S)*2)=R THEN

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#2
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldx	#INTVAR_S
	jsr	sub_ir2_ir2_ix

	ldab	#2
	jsr	mul_ir2_ir2_pb

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_R
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_8
	jsr	jmpeq_ir1_ix

	; X=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=J-S

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_8

	; IF (I+S)<(K-E) THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_K
	jsr	ld_ir2_ix

	ldx	#INTVAR_E
	jsr	sub_ir2_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_9
	jsr	jmpeq_ir1_ix

	; IF POINT((I+S)*2,J*2)=R THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ir1_ir1_ix

	ldab	#2
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#2
	jsr	mul_ir2_ir2_pb

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_R
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_9
	jsr	jmpeq_ir1_ix

	; X=I+S

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_9

	; IF (I-S)>E THEN

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_I
	jsr	ld_ir2_ix

	ldx	#INTVAR_S
	jsr	sub_ir2_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_10
	jsr	jmpeq_ir1_ix

	; IF POINT((I-S)*2,J*2)=R THEN

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	sub_ir1_ir1_ix

	ldab	#2
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#2
	jsr	mul_ir2_ir2_pb

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_R
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_10
	jsr	jmpeq_ir1_ix

	; X=I-S

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=J

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 3

	ldx	#LINE_3
	jsr	gosub_ix

LINE_10

	; WHEN W>E GOTO 5

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_W
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_5
	jsr	jmpne_ir1_ix

LINE_11

	; RETURN

	jsr	return

LINE_800

	; R=INT(RND(-(PEEK(9)*256)-PEEK(10)))

	ldab	#9
	jsr	peek_ir1_pb

	ldd	#256
	jsr	mul_ir1_ir1_pw

	ldab	#10
	jsr	peek_ir2_pb

	jsr	add_ir1_ir1_ir2

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

LINE_820

	; GOSUB 3040

	ldx	#LINE_3040
	jsr	gosub_ix

	; INPUT "INPUT BOARD SIZE (x BY x)"; S$

	jsr	pr_ss
	.text	25, "INPUT BOARD SIZE (x BY x)"

	jsr	input

	ldx	#STRVAR_S
	jsr	readbuf_sx

	jsr	ignxtra

	; B=INT(VAL(S$))

	ldx	#STRVAR_S
	jsr	val_fr1_sx

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; MB=B*B

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_MB
	jsr	ld_ix_ir1

	; WHEN (B<4) OR (B>16) GOTO 820

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#4
	jsr	ldlt_ir1_ir1_pb

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_B
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_820
	jsr	jmpne_ir1_ix

LINE_830

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; WI=0

	ldx	#INTVAR_WI
	ldab	#0
	jsr	ld_ix_pb

	; OF=0

	ldx	#INTVAR_OF
	ldab	#0
	jsr	ld_ix_pb

	; FOR T=1 TO 13

	ldx	#INTVAR_T
	ldab	#1
	jsr	for_ix_pb

	ldab	#13
	jsr	to_ip_pb

	; READ PA(T)

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_PA
	jsr	arrref1_ir1_ix

	jsr	read_ip

	; NEXT

	jsr	next

LINE_1000

	; LV=B-3

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#3
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_LV
	jsr	ld_ix_ir1

	; E=-1

	ldx	#INTVAR_E
	ldab	#-1
	jsr	ld_ix_nb

	; SS=7

	ldx	#INTVAR_SS
	ldab	#7
	jsr	ld_ix_pb

	; S=1

	ldx	#INTVAR_S
	ldab	#1
	jsr	ld_ix_pb

	; M=0

	ldx	#INTVAR_M
	ldab	#0
	jsr	ld_ix_pb

	; U=0

	ldx	#INTVAR_U
	ldab	#0
	jsr	ld_ix_pb

	; K=(B*S)+E

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_E
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; L=(B*S)+E

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_E
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; C=0

	ldx	#INTVAR_C
	ldab	#0
	jsr	ld_ix_pb

	; X=0

	ldx	#INTVAR_X
	ldab	#0
	jsr	ld_ix_pb

	; Y=0

	ldx	#INTVAR_Y
	ldab	#0
	jsr	ld_ix_pb

	; T=0

	ldx	#INTVAR_T
	ldab	#0
	jsr	ld_ix_pb

	; Q=0

	ldx	#INTVAR_Q
	ldab	#0
	jsr	ld_ix_pb

	; KH=0

	ldx	#INTVAR_KH
	ldab	#0
	jsr	ld_ix_pb

	; GOSUB 2800

	ldx	#LINE_2800
	jsr	gosub_ix

	; GOSUB 2840

	ldx	#LINE_2840
	jsr	gosub_ix

LINE_1001

	; H=0

	ldx	#INTVAR_H
	ldab	#0
	jsr	ld_ix_pb

	; W=0

	ldx	#INTVAR_W
	ldab	#0
	jsr	ld_ix_pb

	; ML=0

	ldx	#INTVAR_ML
	ldab	#0
	jsr	ld_ix_pb

	; FOR X=0 TO 256

	ldx	#INTVAR_X
	ldab	#0
	jsr	for_ix_pb

	ldd	#256
	jsr	to_ip_pw

	; X(X)=0

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; Y(X)=0

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; L(X)=0

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; NEXT

	jsr	next

LINE_1500

	; FOR X=0 TO K STEP S

	ldx	#INTVAR_X
	ldab	#0
	jsr	for_ix_pb

	ldx	#INTVAR_K
	jsr	to_ip_ix

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; FOR Y=0 TO L

	ldx	#INTVAR_Y
	ldab	#0
	jsr	for_ix_pb

	ldx	#INTVAR_L
	jsr	to_ip_ix

LINE_1501

	; C=RND(6)+1

	ldab	#6
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; L(C)+=1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	add_ip_ip_pb

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_2500

	; ML=0

	ldx	#INTVAR_ML
	ldab	#0
	jsr	ld_ix_pb

	; FOR T=1 TO 6

	ldx	#INTVAR_T
	ldab	#1
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

	; PRINT @(32*T)+18, RIGHT$(STR$(T),1)+"="+CHR$((16*T)+143)+"("+RIGHT$(" "+STR$(L(T+1)),3)+")"

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_T
	jsr	mul_ir1_ir1_ix

	ldab	#18
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_T
	jsr	str_sr1_ix

	ldab	#1
	jsr	right_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "="

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#INTVAR_T
	jsr	mul_ir2_ir2_ix

	ldab	#143
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	strcat_sr1_sr1_ss
	.text	1, "("

	jsr	strinit_sr2_ss
	.text	1, " "

	ldx	#INTVAR_T
	jsr	ld_ir3_ix

	ldab	#1
	jsr	add_ir3_ir3_pb

	ldx	#INTARR_L
	jsr	arrval1_ir3_ix

	jsr	str_sr3_ir3

	jsr	strcat_sr2_sr2_sr3

	ldab	#3
	jsr	right_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	jsr	strcat_sr1_sr1_ss
	.text	1, ")"

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_2580

	; IF L(T+1)>ML THEN

	ldx	#INTVAR_ML
	jsr	ld_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#1
	jsr	add_ir2_ir2_pb

	ldx	#INTARR_L
	jsr	arrval1_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_2590
	jsr	jmpeq_ir1_ix

	; ML=L(T+1)

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_ML
	jsr	ld_ix_ir1

LINE_2590

	; NEXT

	jsr	next

LINE_2600

	; GOSUB 2790

	ldx	#LINE_2790
	jsr	gosub_ix

	; SOUND 100,1

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_2610

	; IF ML>(MB+E) THEN

	ldx	#INTVAR_MB
	jsr	ld_ir1_ix

	ldx	#INTVAR_E
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_ML
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_2640
	jsr	jmpeq_ir1_ix

	; OF+=1

	ldx	#INTVAR_OF
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 2720

	ldx	#LINE_2720
	jsr	goto_ix

LINE_2640

	; H$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; WHEN H$="" GOTO 2640

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_2640
	jsr	jmpne_ir1_ix

LINE_2650

	; IF H$="Q" THEN

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Q"

	ldx	#LINE_2655
	jsr	jmpeq_ir1_ix

	; OF+=1

	ldx	#INTVAR_OF
	ldab	#1
	jsr	add_ix_ix_pb

	; GOTO 2730

	ldx	#LINE_2730
	jsr	goto_ix

LINE_2655

	; KH+=1

	ldx	#INTVAR_KH
	ldab	#1
	jsr	add_ix_ix_pb

	; WHEN (KH=1) AND (H$="R") GOTO 1000

	ldx	#INTVAR_KH
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#STRVAR_H
	jsr	ld_sr2_sx

	jsr	ldeq_ir2_sr2_ss
	.text	1, "R"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_1000
	jsr	jmpne_ir1_ix

LINE_2660

	; H=INT(VAL(H$))

	ldx	#STRVAR_H
	jsr	val_fr1_sx

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; WHEN (H<1) OR (H>6) GOTO 2640

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldlt_ir1_ir1_pb

	ldab	#6
	jsr	ld_ir2_pb

	ldx	#INTVAR_H
	jsr	ldlt_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_2640
	jsr	jmpne_ir1_ix

LINE_2680

	; H+=1

	ldx	#INTVAR_H
	ldab	#1
	jsr	add_ix_ix_pb

	; R=POINT(0,0)

	ldab	#0
	jsr	ld_ir1_pb

	ldab	#0
	jsr	point_ir1_ir1_pb

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; WHEN H=R GOTO 2640

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTVAR_R
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_2640
	jsr	jmpne_ir1_ix

LINE_2710

	; M-=E

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTVAR_M
	jsr	sub_ix_ix_ir1

	; GOSUB 4

	ldx	#LINE_4
	jsr	gosub_ix

	; GOTO 2500

	ldx	#LINE_2500
	jsr	goto_ix

LINE_2720

	; WHEN M<=PA(LV) GOTO 2750

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldx	#INTARR_PA
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_M
	jsr	ldge_ir1_ir1_ix

	ldx	#LINE_2750
	jsr	jmpne_ir1_ix

LINE_2730

	; PRINT @498, "PLAY AGAIN?";

	ldd	#498
	jsr	prat_pw

	jsr	pr_ss
	.text	11, "PLAY AGAIN?"

LINE_2740

	; H$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; WHEN H$="" GOTO 2740

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_2740
	jsr	jmpne_ir1_ix

LINE_2745

	; WHEN H$="Y" GOTO 1000

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_1000
	jsr	jmpne_ir1_ix

LINE_2746

	; IF H$="N" THEN

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_2747
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_2747

	; GOTO 2740

	ldx	#LINE_2740
	jsr	goto_ix

LINE_2750

	; WI+=1

	ldx	#INTVAR_WI
	ldab	#1
	jsr	add_ix_ix_pb

	; PRINT @370, "YOU BEAT"

	ldd	#370
	jsr	prat_pw

	jsr	pr_ss
	.text	9, "YOU BEAT\r"

	; PRINT @402, "LEVEL";STR$(LV);"!"

	ldd	#402
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "LEVEL"

	ldx	#INTVAR_LV
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, "!\r"

	; SOUND 100,2

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 120,4

	ldab	#120
	jsr	ld_ir1_pb

	ldab	#4
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOSUB 2830

	ldx	#LINE_2830
	jsr	gosub_ix

LINE_2760

	; PRINT @434, "UPGRADE TO"

	ldd	#434
	jsr	prat_pw

	jsr	pr_ss
	.text	11, "UPGRADE TO\r"

	; IF (B+1)<10 THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	ldab	#10
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_2765
	jsr	jmpeq_ir1_ix

	; PRINT @466, RIGHT$(STR$(B+1),1);"X";RIGHT$(STR$(B+1),1);" (Y/N)?"

	ldd	#466
	jsr	prat_pw

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	str_sr1_ir1

	ldab	#1
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "X"

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	str_sr1_ir1

	ldab	#1
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	8, " (Y/N)?\r"

	; GOTO 2770

	ldx	#LINE_2770
	jsr	goto_ix

LINE_2765

	; PRINT @466, RIGHT$(STR$(B+1),2);"X";RIGHT$(STR$(B+1),2);"?"

	ldd	#466
	jsr	prat_pw

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	str_sr1_ir1

	ldab	#2
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "X"

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	str_sr1_ir1

	ldab	#2
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, "?\r"

LINE_2770

	; H$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; WHEN H$="" GOTO 2770

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_2770
	jsr	jmpne_ir1_ix

LINE_2775

	; WHEN H$="Y" GOTO 2780

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_2780
	jsr	jmpne_ir1_ix

LINE_2776

	; WHEN H$="N" GOTO 2730

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_2730
	jsr	jmpne_ir1_ix

LINE_2777

	; GOTO 2770

	ldx	#LINE_2770
	jsr	goto_ix

LINE_2780

	; B+=1

	ldx	#INTVAR_B
	ldab	#1
	jsr	add_ix_ix_pb

	; IF B>16 THEN

	ldab	#16
	jsr	ld_ir1_pb

	ldx	#INTVAR_B
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_2785
	jsr	jmpeq_ir1_ix

	; B=16

	ldx	#INTVAR_B
	ldab	#16
	jsr	ld_ix_pb

LINE_2785

	; MB=B*B

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_MB
	jsr	ld_ix_ir1

	; GOTO 1000

	ldx	#LINE_1000
	jsr	goto_ix

LINE_2790

	; PRINT @242, "MOVES:";STR$(M);" "

	ldab	#242
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "MOVES:"

	ldx	#INTVAR_M
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; RETURN

	jsr	return

LINE_2800

	; PRINT @18, " * COLOROID *"

	ldab	#18
	jsr	prat_pb

	jsr	pr_ss
	.text	14, " * COLOROID *\r"

LINE_2810

	; PRINT @306, "PAR:";STR$(PA(LV));" "

	ldd	#306
	jsr	prat_pw

	jsr	pr_ss
	.text	4, "PAR:"

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldx	#INTARR_PA
	jsr	arrval1_ir1_ix

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_2820

	; PRINT @274, "SIZE: ";

	ldd	#274
	jsr	prat_pw

	jsr	pr_ss
	.text	6, "SIZE: "

	; IF B<10 THEN

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldab	#10
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_2825
	jsr	jmpeq_ir1_ix

	; PRINT RIGHT$(STR$(B),1);"X";RIGHT$(STR$(B),1)

	ldx	#INTVAR_B
	jsr	str_sr1_ix

	ldab	#1
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "X"

	ldx	#INTVAR_B
	jsr	str_sr1_ix

	ldab	#1
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

	; GOTO 2830

	ldx	#LINE_2830
	jsr	goto_ix

LINE_2825

	; PRINT RIGHT$(STR$(B),2);"X";RIGHT$(STR$(B),2)

	ldx	#INTVAR_B
	jsr	str_sr1_ix

	ldab	#2
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "X"

	ldx	#INTVAR_B
	jsr	str_sr1_ix

	ldab	#2
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

LINE_2830

	; PRINT @338, "WINS: ";RIGHT$(" "+STR$(WI),3);"/";RIGHT$(" "+STR$(OF),3)

	ldd	#338
	jsr	prat_pw

	jsr	pr_ss
	.text	6, "WINS: "

	jsr	strinit_sr1_ss
	.text	1, " "

	ldx	#INTVAR_WI
	jsr	str_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldab	#3
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "/"

	jsr	strinit_sr1_ss
	.text	1, " "

	ldx	#INTVAR_OF
	jsr	str_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldab	#3
	jsr	right_sr1_sr1_pb

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, "\r"

	; RETURN

	jsr	return

LINE_2840

	; FOR T=11 TO 14

	ldx	#INTVAR_T
	ldab	#11
	jsr	for_ix_pb

	ldab	#14
	jsr	to_ip_pb

	; PRINT @(32*T)+18,

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_T
	jsr	mul_ir1_ir1_ix

	ldab	#18
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\r"

	; NEXT

	jsr	next

	; PRINT @498, "             ";

	ldd	#498
	jsr	prat_pw

	jsr	pr_ss
	.text	13, "             "

	; POKE 16895,96

	ldab	#96
	jsr	ld_ir1_pb

	ldd	#16895
	jsr	poke_pw_ir1

	; RETURN

	jsr	return

LINE_2900

LINE_3000

	; CLS

	jsr	cls

LINE_3001

	; PRINT "coloroid STARTS WITH A GRID OF "

	jsr	pr_ss
	.text	32, "coloroid STARTS WITH A GRID OF \r"

LINE_3022

	; PRINT "MULTI-COLORED BLOCKS. THE GAME"

	jsr	pr_ss
	.text	31, "MULTI-COLORED BLOCKS. THE GAME\r"

LINE_3023

	; PRINT "IS PLAYED FROM THE TOP LEFT."

	jsr	pr_ss
	.text	29, "IS PLAYED FROM THE TOP LEFT.\r"

LINE_3025

	; PRINT "CHOOSE A # TO CHANGE THE COLOR"

	jsr	pr_ss
	.text	31, "CHOOSE A # TO CHANGE THE COLOR\r"

LINE_3026

	; PRINT "OF THE TOP LEFT BLOCK. IF YOU'VE";

	jsr	pr_ss
	.text	32, "OF THE TOP LEFT BLOCK. IF YOU'VE"

LINE_3027

	; PRINT "CHOSEN WISELY, THAT IS IF YOU'VE";

	jsr	pr_ss
	.text	32, "CHOSEN WISELY, THAT IS IF YOU'VE"

LINE_3028

	; PRINT "CHOSEN A COLOR THAT WAS ADJACENT";

	jsr	pr_ss
	.text	32, "CHOSEN A COLOR THAT WAS ADJACENT"

LINE_3029

	; PRINT "TO THE TOP LEFT BLOCK, IT"

	jsr	pr_ss
	.text	26, "TO THE TOP LEFT BLOCK, IT\r"

LINE_3031

	; PRINT "WILL JOIN WITH THE NEWLY COLORED";

	jsr	pr_ss
	.text	32, "WILL JOIN WITH THE NEWLY COLORED"

LINE_3032

	; PRINT "BLOCK. AS YOU KEEP CHANGING THE"

	jsr	pr_ss
	.text	32, "BLOCK. AS YOU KEEP CHANGING THE\r"

LINE_3033

	; PRINT "GROUP OF BLOCKS, IT GROWS AND "

	jsr	pr_ss
	.text	31, "GROUP OF BLOCKS, IT GROWS AND \r"

LINE_3034

	; PRINT "CONTINUES TO MERGE WITH ANY "

	jsr	pr_ss
	.text	29, "CONTINUES TO MERGE WITH ANY \r"

LINE_3035

	; PRINT "TOUCHING BLOCKS OF THE SAME"

	jsr	pr_ss
	.text	28, "TOUCHING BLOCKS OF THE SAME\r"

LINE_3036

	; PRINT "COLOR. THE GOAL IS TO TURN THE"

	jsr	pr_ss
	.text	31, "COLOR. THE GOAL IS TO TURN THE\r"

LINE_3037

	; PRINT "WHOLE SCREEN TO A SINGLE COLOR."

	jsr	pr_ss
	.text	32, "WHOLE SCREEN TO A SINGLE COLOR.\r"

LINE_3038

	; RETURN

	jsr	return

LINE_3040

	; PRINT "    press any key to begin";

	jsr	pr_ss
	.text	26, "    press any key to begin"

LINE_3045

	; H$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; WHEN H$="" GOTO 3045

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_3045
	jsr	jmpne_ir1_ix

LINE_3050

	; CLS

	jsr	cls

	; PRINT @32, "(MIN=4, MAX=16)";

	ldab	#32
	jsr	prat_pb

	jsr	pr_ss
	.text	15, "(MIN=4, MAX=16)"

	; PRINT @0, "";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	0, ""

	; RETURN

	jsr	return

LINE_3500

	; REM 

LINE_4000

	; REM CREDITS

LINE_4010

	; REM BY CHRIS HARRINGTON chris.harrington@gmail.com

LINE_4020

	; REM BASED ON COLOROID FOR ANDROID

LINE_4030

	; REM FOR MY WIFE ALISSA

LINE_4040

	; REM CREATED 7/4/2010;REVISED 7/9/2010

LINE_4050

	; REM 13 SECONDS FOR 10X10 BLOCKFILL

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

	.module	mdrpubyte
; read DATA when records are purely unsigned bytes
; EXIT:  int in tmp1+1 and tmp2
rpubyte
	pshx
	ldx	dataptr
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldaa	,x
	inx
	stx	dataptr
	staa	tmp2+1
	ldd	#0
	std	tmp1+1
	std	tmp3
	pulx
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

	.module	mdstrtmp
; make a temporary clone of a string
; ENTRY: X holds string start
;        B holds string length
; EXIT:  D holds new string pointer
strtmp
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

add_ip_ip_ir1			; numCalls = 2
	.module	modadd_ip_ip_ir1
	ldx	letptr
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ip_ip_pb			; numCalls = 1
	.module	modadd_ip_ip_pb
	ldx	letptr
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

add_ir1_ir1_ir2			; numCalls = 1
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 8
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

add_ir2_ir2_pb			; numCalls = 2
	.module	modadd_ir2_ir2_pb
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_ir3_ir3_pb			; numCalls = 1
	.module	modadd_ir3_ir3_pb
	clra
	addd	r3+1
	std	r3+1
	ldab	#0
	adcb	r3
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

and_ir1_ir1_ir2			; numCalls = 1
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

arrdim1_ir1_ix			; numCalls = 4
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

arrref1_ir1_ix			; numCalls = 13
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 5
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

arrval1_ir2_ix			; numCalls = 1
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

arrval1_ir3_ix			; numCalls = 1
	.module	modarrval1_ir3_ix
	ldd	r3+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r3
	ldd	1,x
	std	r3+1
	rts

chr_sr1_ir1			; numCalls = 1
	.module	modchr_sr1_ir1
	ldd	#$0101
	std	r1
	rts

chr_sr2_ir2			; numCalls = 1
	.module	modchr_sr2_ir2
	ldd	#$0101
	std	r2
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

cls			; numCalls = 2
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

for_ix_pb			; numCalls = 6
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 13
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 9
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

jmpeq_ir1_ix			; numCalls = 14
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

jmpne_ir1_ix			; numCalls = 13
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

ld_ip_ir1			; numCalls = 2
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 5
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 63
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 12
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir1_pw			; numCalls = 3
	.module	modld_ir1_pw
	std	r1+1
	ldab	#0
	stab	r1
	rts

ld_ir2_ix			; numCalls = 9
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

ld_ir3_ix			; numCalls = 1
	.module	modld_ir3_ix
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ix_ir1			; numCalls = 22
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

ld_ix_pb			; numCalls = 21
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

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

ld_sx_sr1			; numCalls = 4
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ix			; numCalls = 5
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

ldeq_ir1_ir1_pb			; numCalls = 1
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 9
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

ldge_ir1_ir1_ix			; numCalls = 1
	.module	modldge_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getge
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

mul_ir1_ir1_ix			; numCalls = 7
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pb			; numCalls = 5
	.module	modmul_ir1_ir1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pw			; numCalls = 1
	.module	modmul_ir1_ir1_pw
	std	1+argv
	clrb
	stab	0+argv
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

mul_ir2_ir2_pb			; numCalls = 4
	.module	modmul_ir2_ir2_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	ldx	#r2
	jmp	mulintx

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	neg	r1+2
	ngc	r1+1
	ngc	r1
	rts

next			; numCalls = 6
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

peek_ir1_pb			; numCalls = 1
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

point_ir1_ir1_ir2			; numCalls = 4
	.module	modpoint_ir1_ir1_ir2
	ldaa	r2+2
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

point_ir1_ir1_pb			; numCalls = 1
	.module	modpoint_ir1_ir1_pb
	tba
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

poke_pw_ir1			; numCalls = 1
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 15
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 44
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_ir1			; numCalls = 3
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 4
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 10
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

read_ip			; numCalls = 1
	.module	modread_ip
	ldx	letptr
	jsr	rpubyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

readbuf_sx			; numCalls = 1
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

right_sr1_sr1_pb			; numCalls = 11
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

right_sr2_sr2_pb			; numCalls = 1
	.module	modright_sr2_sr2_pb
	tstb
	beq	_zero
	stab	tmp1
	ldab	r2
	subb	tmp1
	bls	_rts
	clra
	addd	r2+1
	std	r2+1
	ldab	tmp1
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

sound_ir1_ir2			; numCalls = 3
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 1
	.module	modstep_ip_ir1
	tsx
	ldab	r1
	stab	10,x
	ldd	r1+1
	std	11,x
	ldd	,x
	std	5,x
	rts

str_sr1_ir1			; numCalls = 5
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

str_sr1_ix			; numCalls = 7
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

str_sr2_ix			; numCalls = 2
	.module	modstr_sr2_ix
	ldd	1,x
	std	tmp2
	ldab	0,x
	stab	tmp1+1
	ldd	#0
	std	tmp3
	jsr	strflt
	std	r2+1
	ldab	tmp1
	stab	r2
	rts

str_sr3_ir3			; numCalls = 1
	.module	modstr_sr3_ir3
	ldd	r3+1
	std	tmp2
	ldab	r3
	stab	tmp1+1
	ldd	#0
	std	tmp3
	jsr	strflt
	std	r3+1
	ldab	tmp1
	stab	r3
	rts

strcat_sr1_sr1_sr2			; numCalls = 4
	.module	modstrcat_sr1_sr1_sr2
	ldab	r2
	addb	r1
	stab	r1
	ldab	r2
	ldx	r2+1
	jmp	strtmp

strcat_sr1_sr1_ss			; numCalls = 3
	.module	modstrcat_sr1_sr1_ss
	tsx
	ldx	,x
	ldab	,x
	addb	r1
	stab	r1
	ldab	,x
	inx
	jsr	strtmp
	pulx
	ldab	,x
	abx
	jmp	1,x

strcat_sr2_sr2_sr3			; numCalls = 1
	.module	modstrcat_sr2_sr2_sr3
	ldab	r3
	addb	r2
	stab	r2
	ldab	r3
	ldx	r3+1
	jmp	strtmp

strinit_sr1_sr1			; numCalls = 1
	.module	modstrinit_sr1_sr1
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

strinit_sr1_ss			; numCalls = 2
	.module	modstrinit_sr1_ss
	tsx
	ldx	,x
	ldab	,x
	stab	r1
	inx
	jsr	strtmp
	std	r1+1
	pulx
	ldab	,x
	abx
	jmp	1,x

strinit_sr2_ss			; numCalls = 1
	.module	modstrinit_sr2_ss
	tsx
	ldx	,x
	ldab	,x
	stab	r2
	inx
	jsr	strtmp
	std	r2+1
	pulx
	ldab	,x
	abx
	jmp	1,x

sub_ip_ip_ir1			; numCalls = 2
	.module	modsub_ip_ip_ir1
	ldx	letptr
	ldd	1,x
	subd	r1+1
	std	1,x
	ldab	0,x
	sbcb	r1
	stab	0,x
	rts

sub_ir1_ir1_ix			; numCalls = 3
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir1_ir1_pb			; numCalls = 2
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

sub_ir2_ir2_ix			; numCalls = 5
	.module	modsub_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

sub_ix_ix_ir1			; numCalls = 3
	.module	modsub_ix_ix_ir1
	ldd	1,x
	subd	r1+1
	std	1,x
	ldab	0,x
	sbcb	r1
	stab	0,x
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

to_ip_pb			; numCalls = 3
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
	.byte	7, 9, 11, 13, 15, 17
	.byte	19, 20, 22, 24, 26, 28
	.byte	33
enddata

symstart

; block started by symbol
bss

; Numeric Variables
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_E	.block	3
INTVAR_H	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_KH	.block	3
INTVAR_L	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_MB	.block	3
INTVAR_ML	.block	3
INTVAR_OF	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_SS	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_W	.block	3
INTVAR_WI	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
; String Variables
STRVAR_H	.block	3
STRVAR_S	.block	3
; Numeric Arrays
INTARR_L	.block	4	; dims=1
INTARR_PA	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

; Assembly for defcon1.bas
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

	; CLS

	jsr	cls

	; DIM W(383),S(7),T(7),E(6),F(6),X(6),Y(6),C(7),T1,T2,T3,T,C,P,X,Y,L,P,Z,M,I$

	ldd	#383
	jsr	ld_ir1_pw

	ldx	#INTARR_W
	jsr	arrdim1_ir1_ix

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#FLTARR_S
	jsr	arrdim1_ir1_fx

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#FLTARR_T
	jsr	arrdim1_ir1_fx

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#FLTARR_E
	jsr	arrdim1_ir1_fx

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#FLTARR_F
	jsr	arrdim1_ir1_fx

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#FLTARR_X
	jsr	arrdim1_ir1_fx

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTARR_C
	jsr	arrdim1_ir1_ix

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; GOSUB 1200

	ldx	#LINE_1200
	jsr	gosub_ix

	; GOTO 60

	ldx	#LINE_60
	jsr	goto_ix

LINE_1

	; RESET(X,Y)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	reset_ir1_ix

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 9

	ldx	#LINE_9
	jsr	goto_ix

LINE_2

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 9

	ldx	#LINE_9
	jsr	goto_ix

LINE_4

	; ON POINT(X,Y)+1 GOTO 2,2,2,1,1,2,2

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	point_ir1_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	ongoto_ir1_is
	.byte	7
	.word	LINE_2, LINE_2, LINE_2, LINE_1, LINE_1, LINE_2, LINE_2

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 9

	ldx	#LINE_9
	jsr	goto_ix

LINE_5

	; ON POINT(X,Y)+1 GOTO 2,2,2,1,2,2,1

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#FLTVAR_Y
	jsr	point_ir1_ir1_ix

	ldab	#1
	jsr	add_ir1_ir1_pb

	jsr	ongoto_ir1_is
	.byte	7
	.word	LINE_2, LINE_2, LINE_2, LINE_1, LINE_2, LINE_2, LINE_1

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 9

	ldx	#LINE_9
	jsr	goto_ix

LINE_6

	; FOR T=0 TO 1 STEP 0.01

	ldx	#FLTVAR_T
	ldab	#0
	jsr	for_fx_pb

	ldab	#1
	jsr	to_fp_pb

	ldx	#FLT_0p00999
	jsr	ld_fr1_fx

	jsr	step_fp_fr1

	; T1=(1-T)*(1-T)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#FLTVAR_T
	jsr	sub_fr1_ir1_fx

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#FLTVAR_T
	jsr	sub_fr2_ir2_fx

	jsr	mul_fr1_fr1_fr2

	ldx	#FLTVAR_T1
	jsr	ld_fx_fr1

	; T2=(1-T)*2*T

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#FLTVAR_T
	jsr	sub_fr1_ir1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	ldx	#FLTVAR_T
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_T2
	jsr	ld_fx_fr1

	; T3=T*T

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTVAR_T
	jsr	mul_fr1_fr1_fx

	ldx	#FLTVAR_T3
	jsr	ld_fx_fr1

	; FOR P=1 TO 6

	ldx	#INTVAR_P
	ldab	#1
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

	; X=INT((S(P)*T1)+(X(P)*T2)+(E(P)*T3))

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#FLTVAR_T1
	jsr	mul_fr1_fr1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_X
	jsr	arrval1_ir2_fx

	ldx	#FLTVAR_T2
	jsr	mul_fr2_fr2_fx

	jsr	add_fr1_fr1_fr2

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_E
	jsr	arrval1_ir2_fx

	ldx	#FLTVAR_T3
	jsr	mul_fr2_fr2_fx

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_X
	jsr	ld_fx_ir1

LINE_7

	; Y=INT((T(P)*T1)+(Y(P)*T2)+(F(P)*T3))

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir1_fx

	ldx	#FLTVAR_T1
	jsr	mul_fr1_fr1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#INTARR_Y
	jsr	arrval1_ir2_ix

	ldx	#FLTVAR_T2
	jsr	mul_fr2_ir2_fx

	jsr	add_fr1_fr1_fr2

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_F
	jsr	arrval1_ir2_fx

	ldx	#FLTVAR_T3
	jsr	mul_fr2_fr2_fx

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_Y
	jsr	ld_fx_ir1

	; IF (Y>=0) AND (Y<24) THEN

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#0
	jsr	ldge_ir1_fr1_pb

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#24
	jsr	ldlt_ir2_fr2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_8
	jsr	jmpeq_ir1_ix

	; ON C(P) GOTO 4,5

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	2
	.word	LINE_4, LINE_5

LINE_8

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_9

	; FOR T=1 TO 6

	ldx	#FLTVAR_T
	ldab	#1
	jsr	for_fx_pb

	ldab	#6
	jsr	to_fp_pb

	; C=(F(T)*16)+(E(T)/2)

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTARR_F
	jsr	arrval1_ir1_fx

	ldab	#16
	jsr	mul_fr1_fr1_pb

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_E
	jsr	arrval1_ir2_fx

	ldab	#2
	jsr	div_fr2_fr2_pb

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; IF (C>0) AND (C<385) THEN

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#FLTVAR_C
	jsr	ldlt_ir1_ir1_fx

	ldx	#FLTVAR_C
	jsr	ld_fr2_fx

	ldd	#385
	jsr	ldlt_ir2_fr2_pw

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_10
	jsr	jmpeq_ir1_ix

	; P=PEEK(M+C)

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#FLTVAR_C
	jsr	add_fr1_ir1_fx

	jsr	peek_ir1_ir1

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; PRINT @C, "Ÿ";

	ldx	#FLTVAR_C
	jsr	prat_ix

	jsr	pr_ss
	.text	1, "\x9F"

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; IF P>175 THEN

	ldab	#175
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_10
	jsr	jmpeq_ir1_ix

	; W(C)=255

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#255
	jsr	ld_ip_pb

LINE_10

	; NEXT

	jsr	next

	; FOR P=1 TO 3

	ldx	#INTVAR_P
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; FOR T=4 TO 7

	ldx	#FLTVAR_T
	ldab	#4
	jsr	for_fx_pb

	ldab	#7
	jsr	to_fp_pb

	; IF (E(P)=S(T)) AND (F(P)=T(T)) THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_E
	jsr	arrval1_ir1_fx

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_S
	jsr	arrval1_ir2_fx

	jsr	ldeq_ir1_fr1_fr2

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_F
	jsr	arrval1_ir2_fx

	ldx	#FLTVAR_T
	jsr	ld_fr3_fx

	ldx	#FLTARR_T
	jsr	arrval1_ir3_fx

	jsr	ldeq_ir2_fr2_fr3

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_12
	jsr	jmpeq_ir1_ix

	; GOSUB 29

	ldx	#LINE_29
	jsr	gosub_ix

	; RD+=1

	ldx	#INTVAR_RD
	ldab	#1
	jsr	add_ix_ix_pb

LINE_12

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_14

	; FOR P=3 TO 6

	ldx	#INTVAR_P
	ldab	#3
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

	; FOR T=0 TO 3

	ldx	#FLTVAR_T
	ldab	#0
	jsr	for_fx_pb

	ldab	#3
	jsr	to_fp_pb

	; IF (E(P)=S(T)) AND (F(P)=T(T)) THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_E
	jsr	arrval1_ir1_fx

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_S
	jsr	arrval1_ir2_fx

	jsr	ldeq_ir1_fr1_fr2

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_F
	jsr	arrval1_ir2_fx

	ldx	#FLTVAR_T
	jsr	ld_fr3_fx

	ldx	#FLTARR_T
	jsr	arrval1_ir3_fx

	jsr	ldeq_ir2_fr2_fr3

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_16
	jsr	jmpeq_ir1_ix

	; GOSUB 29

	ldx	#LINE_29
	jsr	gosub_ix

	; UD+=1

	ldx	#INTVAR_UD
	ldab	#1
	jsr	add_ix_ix_pb

LINE_16

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_28

	; RETURN

	jsr	return

LINE_29

	; C=(T(T)*16)+(S(T)/2)

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTARR_T
	jsr	arrval1_ir1_fx

	ldab	#16
	jsr	mul_fr1_fr1_pb

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_S
	jsr	arrval1_ir2_fx

	ldab	#2
	jsr	div_fr2_fr2_pb

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; IF (T=7) OR (T=0) THEN

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldab	#7
	jsr	ldeq_ir1_fr1_pb

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldab	#0
	jsr	ldeq_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_30
	jsr	jmpeq_ir1_ix

	; POKE M+C,42

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#FLTVAR_C
	jsr	add_fr1_ir1_fx

	ldab	#42
	jsr	poke_ir1_pb

	; W(C)=42

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#42
	jsr	ld_ip_pb

	; S(T)=99+P

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldab	#99
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; T(T)=99+P

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldab	#99
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; C(T)=0

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

	; GOTO 31

	ldx	#LINE_31
	jsr	goto_ix

LINE_30

	; POKE M+C,30

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#FLTVAR_C
	jsr	add_fr1_ir1_fx

	ldab	#30
	jsr	poke_ir1_pb

	; W(C)=30

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#30
	jsr	ld_ip_pb

	; S(T)=99+P

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldab	#99
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; T(T)=99+P

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldab	#99
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; C(T)=0

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ip_pb

LINE_31

	; RETURN

	jsr	return

LINE_40

	; C=0

	ldx	#FLTVAR_C
	ldab	#0
	jsr	ld_fx_pb

	; FOR X=16384 TO 16767

	ldx	#FLTVAR_X
	ldd	#16384
	jsr	for_fx_pw

	ldd	#16767
	jsr	to_fp_pw

	; POKE X,W(C)

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrval1_ir1_ix

	ldx	#FLTVAR_X
	jsr	poke_ix_ir1

	; C+=1

	ldx	#FLTVAR_C
	ldab	#1
	jsr	add_fx_fx_pb

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_60

	; FOR P=0 TO 3

	ldx	#INTVAR_P
	ldab	#0
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; C(P)=1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#1
	jsr	ld_ip_pb

	; S(P)=0

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldab	#0
	jsr	ld_fp_pb

	; T(P)=0

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldab	#0
	jsr	ld_fp_pb

	; NEXT

	jsr	next

	; FOR P=4 TO 7

	ldx	#INTVAR_P
	ldab	#4
	jsr	for_ix_pb

	ldab	#7
	jsr	to_ip_pb

	; C(P)=2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; S(P)=0

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldab	#0
	jsr	ld_fp_pb

	; T(P)=0

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldab	#0
	jsr	ld_fp_pb

	; NEXT

	jsr	next

LINE_61

	; PRINT @480, "USA ENTER COMMAND BASE        ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USA ENTER COMMAND BASE        "

	; GOSUB 500

	ldx	#LINE_500
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

LINE_62

	; PRINT @480, "USA ENTER ICBM BASES          ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USA ENTER ICBM BASES          "

	; GOSUB 300

	ldx	#LINE_300
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

LINE_70

	; PRINT @480, "USSR ENTER COMMAND BASE       ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USSR ENTER COMMAND BASE       "

	; GOSUB 600

	ldx	#LINE_600
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

LINE_72

	; PRINT @480, "USSR ENTER ICBM BASES         ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USSR ENTER ICBM BASES         "

	; GOSUB 400

	ldx	#LINE_400
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

LINE_74

	; PRINT @480, "USA ENTER TARGETS             ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USA ENTER TARGETS             "

	; GOSUB 350

	ldx	#LINE_350
	jsr	gosub_ix

LINE_76

	; PRINT @480, "USSR ENTER TARGETS            ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USSR ENTER TARGETS            "

	; GOSUB 450

	ldx	#LINE_450
	jsr	gosub_ix

	; PRINT @480, "MISSILES LAUNCHED!            ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "MISSILES LAUNCHED!            "

LINE_80

	; GOSUB 6

	ldx	#LINE_6
	jsr	gosub_ix

LINE_82

	; IF RD>=3 THEN

	ldx	#INTVAR_RD
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_84
	jsr	jmpeq_ir1_ix

	; PRINT @480, "USA WINS!                     ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "USA WINS!                     "

LINE_84

	; IF UD>=3 THEN

	ldx	#INTVAR_UD
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_86
	jsr	jmpeq_ir1_ix

	; PRINT @480, "                 USSR WINS!   ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "                 USSR WINS!   "

LINE_86

	; IF (UD>=3) AND (RD>=3) THEN

	ldx	#INTVAR_UD
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldge_ir1_ir1_pb

	ldx	#INTVAR_RD
	jsr	ld_ir2_ix

	ldab	#3
	jsr	ldge_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_88
	jsr	jmpeq_ir1_ix

	; PRINT @480, "NEITHER SIDE WINS.            ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "NEITHER SIDE WINS.            "

LINE_88

	; IF (UD>=3) OR (RD>=3) THEN

	ldx	#INTVAR_UD
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldge_ir1_ir1_pb

	ldx	#INTVAR_RD
	jsr	ld_ir2_ix

	ldab	#3
	jsr	ldge_ir2_ir2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_150
	jsr	jmpne_ir1_ix

LINE_100

	; PRINT @480, "PRESS ANY KEY FOR NEXT LAUNCH";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	29, "PRESS ANY KEY FOR NEXT LAUNCH"

LINE_110

	; IF INKEY$="" THEN

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_110
	jsr	jmpne_ir1_ix

LINE_120

	; GOSUB 40

	ldx	#LINE_40
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

	; GOTO 74

	ldx	#LINE_74
	jsr	goto_ix

LINE_150

	; FOR P=0 TO 7

	ldx	#INTVAR_P
	ldab	#0
	jsr	for_ix_pb

	ldab	#7
	jsr	to_ip_pb

	; C=(T(P)*16)+(S(P)/2)

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir1_fx

	ldab	#16
	jsr	mul_fr1_fr1_pb

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir2_fx

	ldab	#2
	jsr	div_fr2_fr2_pb

	jsr	add_fr1_fr1_fr2

	ldx	#FLTVAR_C
	jsr	ld_fx_fr1

	; IF (C(P)<>0) AND ((P=0) OR (P=7)) THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldab	#0
	jsr	ldne_ir1_ir1_pb

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldeq_ir2_ir2_pb

	ldx	#INTVAR_P
	jsr	ld_ir3_ix

	ldab	#7
	jsr	ldeq_ir3_ir3_pb

	jsr	or_ir2_ir2_ir3

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_160
	jsr	jmpeq_ir1_ix

	; PRINT @C, "*";

	ldx	#FLTVAR_C
	jsr	prat_ix

	jsr	pr_ss
	.text	1, "*"

	; GOTO 170

	ldx	#LINE_170
	jsr	goto_ix

LINE_160

	; IF C(P)<>0 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldab	#0
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_170
	jsr	jmpeq_ir1_ix

	; PRINT @C, "^";

	ldx	#FLTVAR_C
	jsr	prat_ix

	jsr	pr_ss
	.text	1, "^"

LINE_170

	; NEXT

	jsr	next

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

	; PRINT @384, "PLAY AGAIN (Y/N)";

	ldd	#384
	jsr	prat_pw

	jsr	pr_ss
	.text	16, "PLAY AGAIN (Y/N)"

LINE_180

	; I$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; IF I$="" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_180
	jsr	jmpne_ir1_ix

LINE_185

	; IF I$="Y" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_190
	jsr	jmpeq_ir1_ix

	; CLS

	jsr	cls

	; RESTORE

	jsr	restore

	; GOSUB 1200

	ldx	#LINE_1200
	jsr	gosub_ix

	; GOTO 60

	ldx	#LINE_60
	jsr	goto_ix

LINE_190

	; IF I$="N" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_195
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_195

	; GOTO 180

	ldx	#LINE_180
	jsr	goto_ix

LINE_200

	; FOR T=1 TO 3

	ldx	#FLTVAR_T
	ldab	#1
	jsr	for_fx_pb

	ldab	#3
	jsr	to_fp_pb

	; PRINT @(T*32)+352, "                                ";

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldab	#32
	jsr	mul_fr1_fr1_pb

	ldd	#352
	jsr	add_fr1_fr1_pw

	jsr	prat_ir1

	jsr	pr_ss
	.text	32, "                                "

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_300

	; FOR P=1 TO 3

	ldx	#INTVAR_P
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

LINE_310

	; PRINT @(32*P)+352, STR$(P);" (X,Y)";

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	mul_ir1_ir1_ix

	ldd	#352
	jsr	add_ir1_ir1_pw

	jsr	prat_ir1

	ldx	#INTVAR_P
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	6, " (X,Y)"

	; INPUT X,Y

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (X<1) OR (X>31) OR (Y<1) OR (Y>12) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#31
	jsr	ld_ir2_pb

	ldx	#FLTVAR_X
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#1
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

LINE_320

	; S(P)=X*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; T(P)=Y*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; IF POINT(S(P),T(P))<>6 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir2_fx

	jsr	point_ir1_ir1_ir2

	ldab	#6
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

LINE_325

	; FOR T=0 TO 3

	ldx	#FLTVAR_T
	ldab	#0
	jsr	for_fx_pb

	ldab	#3
	jsr	to_fp_pb

	; IF (T<>P) AND (S(T)=S(P)) AND (T(T)=T(P)) THEN

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#INTVAR_P
	jsr	ldne_ir1_fr1_ix

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_S
	jsr	arrval1_ir2_fx

	ldx	#INTVAR_P
	jsr	ld_ir3_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir3_fx

	jsr	ldeq_ir2_fr2_fr3

	jsr	and_ir1_ir1_ir2

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_T
	jsr	arrval1_ir2_fx

	ldx	#INTVAR_P
	jsr	ld_ir3_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir3_fx

	jsr	ldeq_ir2_fr2_fr3

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

LINE_330

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_350

	; FOR P=1 TO 3

	ldx	#INTVAR_P
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; E(P)=999+P

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_E
	jsr	arrref1_ir1_fx

	ldd	#999
	jsr	ld_ir1_pw

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; F(P)=999+P

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_F
	jsr	arrref1_ir1_fx

	ldd	#999
	jsr	ld_ir1_pw

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; NEXT

	jsr	next

	; FOR P=1 TO 3

	ldx	#INTVAR_P
	ldab	#1
	jsr	for_ix_pb

	ldab	#3
	jsr	to_ip_pb

	; IF C(P)=0 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_380
	jsr	jmpne_ir1_ix

LINE_360

	; PRINT @(32*P)+352, STR$(P);" (X,Y)";

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	mul_ir1_ir1_ix

	ldd	#352
	jsr	add_ir1_ir1_pw

	jsr	prat_ir1

	ldx	#INTVAR_P
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	6, " (X,Y)"

	; INPUT X,Y

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (X=0) OR (Y=0) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#0
	jsr	ldeq_ir1_fr1_pb

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#0
	jsr	ldeq_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_365
	jsr	jmpeq_ir1_ix

	; GOSUB 40

	ldx	#LINE_40
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

	; GOTO 360

	ldx	#LINE_360
	jsr	goto_ix

LINE_365

	; IF (X<16) OR (X>31) OR (Y<1) OR (Y>12) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#16
	jsr	ldlt_ir1_fr1_pb

	ldab	#31
	jsr	ld_ir2_pb

	ldx	#FLTVAR_X
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#1
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_360
	jsr	jmpne_ir1_ix

LINE_370

	; E(P)=X*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_E
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; F(P)=Y*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_F
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

LINE_375

	; X(P)=ABS(S(P)-E(P))

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_X
	jsr	arrref1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_E
	jsr	arrval1_ir2_fx

	jsr	sub_fr1_fr1_fr2

	jsr	abs_fr1_fr1

	jsr	ld_fp_fr1

	; Y(P)=RND(40)+-10

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#40
	jsr	irnd_ir1_pb

	ldab	#-10
	jsr	add_ir1_ir1_nb

	jsr	ld_ip_ir1

LINE_380

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_400

	; FOR P=4 TO 6

	ldx	#INTVAR_P
	ldab	#4
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

LINE_410

	; PRINT @((P-3)*32)+368, STR$(P-3);" (X,Y)";

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldab	#3
	jsr	sub_ir1_ir1_pb

	ldab	#32
	jsr	mul_ir1_ir1_pb

	ldd	#368
	jsr	add_ir1_ir1_pw

	jsr	prat_ir1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldab	#3
	jsr	sub_ir1_ir1_pb

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	6, " (X,Y)"

	; INPUT X,Y

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (X<1) OR (X>31) OR (Y<1) OR (Y>12) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#31
	jsr	ld_ir2_pb

	ldx	#FLTVAR_X
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#1
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_410
	jsr	jmpne_ir1_ix

LINE_420

	; S(P)=X*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; T(P)=Y*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; IF POINT(S(P),T(P))<>4 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir2_fx

	jsr	point_ir1_ir1_ir2

	ldab	#4
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_410
	jsr	jmpne_ir1_ix

LINE_425

	; FOR T=4 TO 7

	ldx	#FLTVAR_T
	ldab	#4
	jsr	for_fx_pb

	ldab	#7
	jsr	to_fp_pb

	; IF (T<>P) AND (S(T)=S(P)) AND (T(T)=T(P)) THEN

	ldx	#FLTVAR_T
	jsr	ld_fr1_fx

	ldx	#INTVAR_P
	jsr	ldne_ir1_fr1_ix

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_S
	jsr	arrval1_ir2_fx

	ldx	#INTVAR_P
	jsr	ld_ir3_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir3_fx

	jsr	ldeq_ir2_fr2_fr3

	jsr	and_ir1_ir1_ir2

	ldx	#FLTVAR_T
	jsr	ld_fr2_fx

	ldx	#FLTARR_T
	jsr	arrval1_ir2_fx

	ldx	#INTVAR_P
	jsr	ld_ir3_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir3_fx

	jsr	ldeq_ir2_fr2_fr3

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_410
	jsr	jmpne_ir1_ix

LINE_430

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_450

	; FOR P=4 TO 6

	ldx	#INTVAR_P
	ldab	#4
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

	; E(P)=999+P

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_E
	jsr	arrref1_ir1_fx

	ldd	#999
	jsr	ld_ir1_pw

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; F(P)=999+P

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_F
	jsr	arrref1_ir1_fx

	ldd	#999
	jsr	ld_ir1_pw

	ldx	#INTVAR_P
	jsr	add_ir1_ir1_ix

	jsr	ld_fp_ir1

	; NEXT

	jsr	next

	; FOR P=4 TO 6

	ldx	#INTVAR_P
	ldab	#4
	jsr	for_ix_pb

	ldab	#6
	jsr	to_ip_pb

	; IF C(P)=0 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_480
	jsr	jmpne_ir1_ix

LINE_460

	; PRINT @((P-3)*32)+368, STR$(P-3);" (X,Y)";

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldab	#3
	jsr	sub_ir1_ir1_pb

	ldab	#32
	jsr	mul_ir1_ir1_pb

	ldd	#368
	jsr	add_ir1_ir1_pw

	jsr	prat_ir1

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldab	#3
	jsr	sub_ir1_ir1_pb

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	6, " (X,Y)"

	; INPUT X,Y

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (X=0) OR (Y=0) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#0
	jsr	ldeq_ir1_fr1_pb

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#0
	jsr	ldeq_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_465
	jsr	jmpeq_ir1_ix

	; GOSUB 40

	ldx	#LINE_40
	jsr	gosub_ix

	; GOSUB 200

	ldx	#LINE_200
	jsr	gosub_ix

	; GOTO 460

	ldx	#LINE_460
	jsr	goto_ix

LINE_465

	; IF (X<1) OR (X>16) OR (Y<1) OR (Y>12) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#16
	jsr	ld_ir2_pb

	ldx	#FLTVAR_X
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#1
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_460
	jsr	jmpne_ir1_ix

LINE_470

	; E(P)=X*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_E
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; F(P)=Y*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_F
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

LINE_475

	; X(P)=ABS(S(P)-E(P))

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_X
	jsr	arrref1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_E
	jsr	arrval1_ir2_fx

	jsr	sub_fr1_fr1_fr2

	jsr	abs_fr1_fr1

	jsr	ld_fp_fr1

	; Y(P)=RND(40)+-10

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix

	ldab	#40
	jsr	irnd_ir1_pb

	ldab	#-10
	jsr	add_ir1_ir1_nb

	jsr	ld_ip_ir1

LINE_480

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_500

	; P=0

	ldx	#INTVAR_P
	ldab	#0
	jsr	ld_ix_pb

LINE_510

	; PRINT @384, " * (X,Y)";

	ldd	#384
	jsr	prat_pw

	jsr	pr_ss
	.text	8, " * (X,Y)"

	; INPUT X,Y

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (X<1) OR (X>31) OR (Y<1) OR (Y>12) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#31
	jsr	ld_ir2_pb

	ldx	#FLTVAR_X
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#1
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_510
	jsr	jmpne_ir1_ix

LINE_520

	; S(P)=X*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; T(P)=Y*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; IF POINT(S(P),T(P))<>6 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir2_fx

	jsr	point_ir1_ir1_ir2

	ldab	#6
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_510
	jsr	jmpne_ir1_ix

LINE_530

	; RETURN

	jsr	return

LINE_600

	; P=7

	ldx	#INTVAR_P
	ldab	#7
	jsr	ld_ix_pb

LINE_610

	; PRINT @400, " * (X,Y)";

	ldd	#400
	jsr	prat_pw

	jsr	pr_ss
	.text	8, " * (X,Y)"

	; INPUT X,Y

	jsr	input

	ldx	#FLTVAR_X
	jsr	readbuf_fx

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; IF (X<1) OR (X>31) OR (Y<1) OR (Y>12) THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#1
	jsr	ldlt_ir1_fr1_pb

	ldab	#31
	jsr	ld_ir2_pb

	ldx	#FLTVAR_X
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_Y
	jsr	ld_fr2_fx

	ldab	#1
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_ir2_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_610
	jsr	jmpne_ir1_ix

LINE_620

	; S(P)=X*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; T(P)=Y*2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_T
	jsr	arrref1_ir1_fx

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#2
	jsr	mul_fr1_fr1_pb

	jsr	ld_fp_fr1

	; IF POINT(S(P),T(P))<>4 THEN

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#FLTARR_S
	jsr	arrval1_ir1_fx

	ldx	#INTVAR_P
	jsr	ld_ir2_ix

	ldx	#FLTARR_T
	jsr	arrval1_ir2_fx

	jsr	point_ir1_ir1_ir2

	ldab	#4
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_610
	jsr	jmpne_ir1_ix

LINE_630

	; RETURN

	jsr	return

LINE_1000

LINE_1010

LINE_1020

LINE_1030

LINE_1040

LINE_1050

LINE_1060

LINE_1070

LINE_1080

LINE_1090

LINE_1100

LINE_1110

LINE_1200

	; C=0

	ldx	#FLTVAR_C
	ldab	#0
	jsr	ld_fx_pb

	; P=16384

	ldx	#INTVAR_P
	ldd	#16384
	jsr	ld_ix_pw

	; FOR Y=1 TO 12

	ldx	#FLTVAR_Y
	ldab	#1
	jsr	for_fx_pb

	ldab	#12
	jsr	to_fp_pb

	; READ A$

	ldx	#STRVAR_A
	jsr	read_sx

	; FOR X=1 TO 32

	ldx	#FLTVAR_X
	ldab	#1
	jsr	for_fx_pb

	ldab	#32
	jsr	to_fp_pb

	; A=ASC(MID$(A$,X,1))

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldx	#FLTVAR_X
	jsr	ld_ir2_ix

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	asc_ir1_sr1

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; IF A<107 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldab	#107
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_1205
	jsr	jmpeq_ir1_ix

	; W(C)=A-49

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldab	#49
	jsr	sub_ir1_ir1_pb

	jsr	ld_ip_ir1

	; GOTO 1220

	ldx	#LINE_1220
	jsr	goto_ix

LINE_1205

	; IF A=107 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldab	#107
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1210
	jsr	jmpeq_ir1_ix

	; W(C)=223

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#223
	jsr	ld_ip_pb

	; GOTO 1220

	ldx	#LINE_1220
	jsr	goto_ix

LINE_1210

	; IF A=108 THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldab	#108
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_1215
	jsr	jmpeq_ir1_ix

	; W(C)=191

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#191
	jsr	ld_ip_pb

	; GOTO 1220

	ldx	#LINE_1220
	jsr	goto_ix

LINE_1215

	; W(C)=175

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrref1_ir1_ix

	ldab	#175
	jsr	ld_ip_pb

LINE_1220

	; POKE P,W(C)

	ldx	#FLTVAR_C
	jsr	ld_fr1_fx

	ldx	#INTARR_W
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_P
	jsr	poke_ix_ir1

	; C+=1

	ldx	#FLTVAR_C
	ldab	#1
	jsr	add_fx_fx_pb

	; P+=1

	ldx	#INTVAR_P
	ldab	#1
	jsr	add_ix_ix_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_1230

	; M=16384

	ldx	#INTVAR_M
	ldd	#16384
	jsr	ld_ix_pw

	; RD=0

	ldx	#INTVAR_RD
	ldab	#0
	jsr	ld_ix_pb

	; UD=0

	ldx	#INTVAR_UD
	ldab	#0
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_2000

	; FOR T=1 TO LEN(N$)

	ldx	#FLTVAR_T
	ldab	#1
	jsr	for_fx_pb

	ldx	#STRVAR_N
	jsr	len_ir1_sx

	jsr	to_fp_ir1

	; PRINT MID$(N$,T,1);

	ldx	#STRVAR_N
	jsr	ld_sr1_sx

	ldx	#FLTVAR_T
	jsr	ld_ir2_ix

	ldab	#1
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; FOR Z=1 TO 50

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldab	#50
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_3000

	; CLS

	jsr	cls

	; T=RND(-(PEEK(9)*256)-PEEK(10))

	ldab	#9
	jsr	peek_ir1_pb

	ldd	#256
	jsr	mul_ir1_ir1_pw

	ldab	#10
	jsr	peek_ir2_pb

	jsr	add_ir1_ir1_ir2

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_T
	jsr	ld_fx_fr1

	; N$="WOULD YOU LIKE TO PLAY A GAME?"

	jsr	ld_sr1_ss
	.text	30, "WOULD YOU LIKE TO PLAY A GAME?"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; FOR Z=1 TO 2000

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldd	#2000
	jsr	to_ip_pw

	; NEXT

	jsr	next

LINE_3005

	; N$="YES"

	jsr	ld_sr1_ss
	.text	3, "YES"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3010

	; N$="HOW ABOUT:"

	jsr	ld_sr1_ss
	.text	10, "HOW ABOUT:"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3020

	; N$="TACTICAL THERMO-NUCLEAR WAR"

	jsr	ld_sr1_ss
	.text	27, "TACTICAL THERMO-NUCLEAR WAR"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3030

	; N$="TIC-TAC-TOE"

	jsr	ld_sr1_ss
	.text	11, "TIC-TAC-TOE"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3040

	; N$="INPUT CHOICE"

	jsr	ld_sr1_ss
	.text	12, "INPUT CHOICE"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; FOR Z=1 TO 2000

	ldx	#INTVAR_Z
	ldab	#1
	jsr	for_ix_pb

	ldd	#2000
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3050

	; N$="TACTICAL THERMO-NUCLEAR WAR"

	jsr	ld_sr1_ss
	.text	27, "TACTICAL THERMO-NUCLEAR WAR"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3060

	; N$="OK."

	jsr	ld_sr1_ss
	.text	3, "OK."

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3065

	; N$="HERE ARE THE INSTRUCTIONS:"

	jsr	ld_sr1_ss
	.text	26, "HERE ARE THE INSTRUCTIONS:"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3070

	; N$="ENTER THE COORDINATES OF YOUR"

	jsr	ld_sr1_ss
	.text	29, "ENTER THE COORDINATES OF YOUR"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3080

	; N$="COMMAND BASE AND 3 ICBM SILOS."

	jsr	ld_sr1_ss
	.text	30, "COMMAND BASE AND 3 ICBM SILOS."

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3090

	; N$="EACH ROUND YOU WILL ENTER"

	jsr	ld_sr1_ss
	.text	25, "EACH ROUND YOU WILL ENTER"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3100

	; N$="TARGET COORDINATES FOR EACH"

	jsr	ld_sr1_ss
	.text	27, "TARGET COORDINATES FOR EACH"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3110

	; N$="OF YOUR SURVIVING ICBM SILOS."

	jsr	ld_sr1_ss
	.text	29, "OF YOUR SURVIVING ICBM SILOS."

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3120

	; N$="YOU WIN WHEN YOU HAVE DESTROYED"

	jsr	ld_sr1_ss
	.text	31, "YOU WIN WHEN YOU HAVE DESTROYED"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3130

	; N$="3 ENEMY MISSILE SILOS, OR 2"

	jsr	ld_sr1_ss
	.text	27, "3 ENEMY MISSILE SILOS, OR 2"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3140

	; N$="SILOS AND THEIR COMMAND BASE."

	jsr	ld_sr1_ss
	.text	29, "SILOS AND THEIR COMMAND BASE."

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3150

	; N$="DESTROYED BASES AND SILOS"

	jsr	ld_sr1_ss
	.text	25, "DESTROYED BASES AND SILOS"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3160

	; N$="ARE DISPLAYED IN DARK GREEN"

	jsr	ld_sr1_ss
	.text	27, "ARE DISPLAYED IN DARK GREEN"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3170

	; N$="UNDAMAGED SITES ARE DISPLAYED"

	jsr	ld_sr1_ss
	.text	29, "UNDAMAGED SITES ARE DISPLAYED"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3180

	; N$="IN LIGHT GREEN AT THE END OF"

	jsr	ld_sr1_ss
	.text	28, "IN LIGHT GREEN AT THE END OF"

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3190

	; N$="THE GAME.  GOOD LUCK..."

	jsr	ld_sr1_ss
	.text	23, "THE GAME.  GOOD LUCK..."

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT

	jsr	pr_ss
	.text	1, "\r"

LINE_3200

	; PRINT "PRESS ANY KEY TO BEGIN";

	jsr	pr_ss
	.text	22, "PRESS ANY KEY TO BEGIN"

LINE_3210

	; I$=INKEY$

	jsr	inkey_sr1

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; IF I$="" THEN

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_3210
	jsr	jmpne_ir1_ix

LINE_3220

	; CLS

	jsr	cls

	; RETURN

	jsr	return

LINE_4000

	; REM COPYRIGHT JIM AND CHARLIE GERRIE

LINE_4010

	; REM SEPT 21 2011, SYDNEY NS CANADA

LINE_4020

	; REM LUV TO PATTY, MADELEINE AND NAY

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

	.module	mdrefflt
; return flt array reference in D/tmp1
refflt
	lsld
	addd	0,x
	std	tmp1
	rts

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
	ldx	dataptr
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
	stx	dataptr
	pulx
	rts

	.module	mdrsstrng
; read string DATA when records are pure strings
; ENTRY: X holds destination string descriptor
; EXIT:  data table read, and perm string created in X
rsstrng
	jsr	strrel
	jsr	rpstrng
	ldab	tmp1+1
	stab	0,X
	ldd	tmp2
	std	1,X
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

abs_fr1_fr1			; numCalls = 2
	.module	modabs_fr1_fr1
	ldaa	r1
	bpl	_rts
	neg	r1+4
	ngc	r1+3
	ngc	r1+2
	ngc	r1+1
	ngc	r1
_rts
	rts

add_fr1_fr1_fr2			; numCalls = 7
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

add_fr1_fr1_pw			; numCalls = 1
	.module	modadd_fr1_fr1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_ir1_fx			; numCalls = 3
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

add_fx_fx_pb			; numCalls = 2
	.module	modadd_fx_fx_pb
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

add_ir1_ir1_nb			; numCalls = 2
	.module	modadd_ir1_ir1_nb
	ldaa	#-1
	addd	r1+1
	std	r1+1
	ldab	#-1
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 2
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pw			; numCalls = 4
	.module	modadd_ir1_ir1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
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

and_ir1_ir1_ir2			; numCalls = 10
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

arrdim1_ir1_fx			; numCalls = 5
	.module	modarrdim1_ir1_fx
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
	lsld
	addd	2,x
	jmp	alloc

arrdim1_ir1_ix			; numCalls = 3
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

arrref1_ir1_fx			; numCalls = 26
	.module	modarrref1_ir1_fx
	ldd	r1+1
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	std	letptr
	rts

arrref1_ir1_ix			; numCalls = 13
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_fx			; numCalls = 13
	.module	modarrval1_ir1_fx
	ldd	r1+1
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	std	r1+3
	rts

arrval1_ir1_ix			; numCalls = 7
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

arrval1_ir2_fx			; numCalls = 20
	.module	modarrval1_ir2_fx
	ldd	r2+1
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	ldd	3,x
	std	r2+3
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

arrval1_ir3_fx			; numCalls = 6
	.module	modarrval1_ir3_fx
	ldd	r3+1
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r3
	ldd	1,x
	std	r3+1
	ldd	3,x
	std	r3+3
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
	stx	dataptr
	rts

cls			; numCalls = 4
	.module	modcls
	jmp	R_CLS

div_fr2_fr2_pb			; numCalls = 3
	.module	moddiv_fr2_fr2_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r2
	jmp	divflt

for_fx_pb			; numCalls = 10
	.module	modfor_fx_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
	rts

for_fx_pw			; numCalls = 1
	.module	modfor_fx_pw
	stx	letptr
	std	1,x
	ldd	#0
	stab	0,x
	std	3,x
	rts

for_ix_pb			; numCalls = 15
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 45
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 15
	.module	modgoto_ix
	ins
	ins
	jmp	,x

ignxtra			; numCalls = 6
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inkey_sr1			; numCalls = 3
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

input			; numCalls = 6
	.module	modinput
	tsx
	ldd	,x
	subd	#3
	std	redoptr
	jmp	inputqs

irnd_ir1_pb			; numCalls = 2
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 18
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

ld_fp_fr1			; numCalls = 14
	.module	modld_fp_fr1
	ldx	letptr
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fp_ir1			; numCalls = 8
	.module	modld_fp_ir1
	ldx	letptr
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fp_pb			; numCalls = 4
	.module	modld_fp_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
	rts

ld_fr1_fx			; numCalls = 44
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 19
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fr3_fx			; numCalls = 2
	.module	modld_fr3_fx
	ldd	3,x
	std	r3+3
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
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

ld_fx_ir1			; numCalls = 2
	.module	modld_fx_ir1
	ldd	#0
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

ld_ip_ir1			; numCalls = 3
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 10
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 60
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 18
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir1_pw			; numCalls = 5
	.module	modld_ir1_pw
	std	r1+1
	ldab	#0
	stab	r1
	rts

ld_ir2_ix			; numCalls = 18
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 14
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 5
	.module	modld_ir3_ix
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ix_ir1			; numCalls = 2
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 4
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

ld_sr1_ss			; numCalls = 22
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 6
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 24
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_fr1_fr2			; numCalls = 2
	.module	modldeq_ir1_fr1_fr2
	ldd	r1+3
	subd	r2+3
	bne	_done
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

ldeq_ir1_fr1_pb			; numCalls = 3
	.module	modldeq_ir1_fr1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1+3
	bne	_done
	ldd	r1
	bne	_done
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

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

ldeq_ir2_fr2_fr3			; numCalls = 6
	.module	modldeq_ir2_fr2_fr3
	ldd	r2+3
	subd	r3+3
	bne	_done
	ldd	r2+1
	subd	r3+1
	bne	_done
	ldab	r2
	cmpb	r3
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_fr2_pb			; numCalls = 3
	.module	modldeq_ir2_fr2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2+3
	bne	_done
	ldd	r2
	bne	_done
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

ldge_ir1_fr1_pb			; numCalls = 1
	.module	modldge_ir1_fr1_pb
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_ir1_pb			; numCalls = 4
	.module	modldge_ir1_ir1_pb
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir2_ir2_pb			; numCalls = 2
	.module	modldge_ir2_ir2_pb
	clra
	std	tmp1
	ldd	r2+1
	subd	tmp1
	ldab	r2
	sbcb	#0
	jsr	getge
	std	r2+1
	stab	r2
	rts

ldlt_ir1_fr1_pb			; numCalls = 6
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

ldlt_ir1_ir1_fx			; numCalls = 1
	.module	modldlt_ir1_ir1_fx
	ldd	#0
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

ldlt_ir1_ir1_ix			; numCalls = 1
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

ldlt_ir2_fr2_pb			; numCalls = 7
	.module	modldlt_ir2_fr2_pb
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

ldlt_ir2_fr2_pw			; numCalls = 1
	.module	modldlt_ir2_fr2_pw
	std	tmp1
	ldd	r2+1
	subd	tmp1
	ldab	r2
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_fx			; numCalls = 12
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

ldne_ir1_fr1_ix			; numCalls = 2
	.module	modldne_ir1_fr1_ix
	ldd	r1+3
	bne	_done
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

ldne_ir1_ir1_pb			; numCalls = 6
	.module	modldne_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

len_ir1_sx			; numCalls = 1
	.module	modlen_ir1_sx
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
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

mul_fr1_fr1_fr2			; numCalls = 1
	.module	modmul_fr1_fr1_fr2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldd	r2+3
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_fr1_fx			; numCalls = 4
	.module	modmul_fr1_fr1_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_fr1_pb			; numCalls = 17
	.module	modmul_fr1_fr1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr2_fr2_fx			; numCalls = 3
	.module	modmul_fr2_fr2_fx
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldx	#r2
	jmp	mulfltx

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

mul_ir1_ir1_ix			; numCalls = 2
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pb			; numCalls = 2
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

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	neg	r1+2
	ngc	r1+1
	ngc	r1
	rts

next			; numCalls = 34
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

ongoto_ir1_is			; numCalls = 3
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

or_ir1_ir1_ir2			; numCalls = 22
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

peek_ir1_ir1			; numCalls = 1
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

point_ir1_ir1_ix			; numCalls = 2
	.module	modpoint_ir1_ir1_ix
	ldaa	2,x
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

poke_ix_ir1			; numCalls = 2
	.module	modpoke_ix_ir1
	ldab	r1+2
	ldx	1,x
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

prat_ir1			; numCalls = 5
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

prat_pw			; numCalls = 14
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

read_sx			; numCalls = 1
	.module	modread_sx
	jmp	rsstrng

readbuf_fx			; numCalls = 12
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

reset_ir1_ix			; numCalls = 1
	.module	modreset_ir1_ix
	ldaa	2,x
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

restore			; numCalls = 1
	.module	modrestore
	ldx	#startdata
	stx	dataptr
	rts

return			; numCalls = 13
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

sound_ir1_ir2			; numCalls = 1
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_fp_fr1			; numCalls = 1
	.module	modstep_fp_fr1
	tsx
	ldab	r1
	stab	12,x
	ldd	r1+1
	std	13,x
	ldd	r1+3
	std	15,x
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

str_sr1_ix			; numCalls = 2
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

sub_fr1_fr1_fr2			; numCalls = 2
	.module	modsub_fr1_fr1_fr2
	ldd	r1+3
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

sub_fr1_ir1_fx			; numCalls = 2
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

sub_fr2_ir2_fx			; numCalls = 1
	.module	modsub_fr2_ir2_fx
	ldd	#0
	subd	3,x
	std	r2+3
	ldd	r2+1
	sbcb	2,x
	sbca	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

sub_ir1_ir1_pb			; numCalls = 5
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

to_fp_ir1			; numCalls = 1
	.module	modto_fp_ir1
	ldd	#0
	std	r1+3
	ldab	#15
	jmp	to

to_fp_pb			; numCalls = 9
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

to_ip_pb			; numCalls = 13
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
	.text	32, "ammmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
	.text	32, "bkkmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
	.text	32, "ckkmmmmmmmmmmmmmmmmmmmmllllllllm"
	.text	32, "dmmkmmmmmmmmmmmmmmllllllllllllll"
	.text	32, "emmmmmmmmmmmmmmmmllllllllllllllm"
	.text	32, "fkkkkkkkkkmmkkmmmmlllllllllllmlm"
	.text	32, "gkkkkkkkkkkkkkmmmmmmlmlllllmmmmm"
	.text	32, "hkkkkkkkkkkkkmmmmmmmmmmlmmmmmmmm"
	.text	32, "immkkkkkkkkkmmmmmmmmmmmmmmmmmmmm"
	.text	32, "jkmmmmkkkmmkmmmmmmmmmmmmmmmmmmmm"
	.text	32, "ammmmmmmmmbmmmmmmmmmcmmmmmmmmmdm"
	.text	32, "abcdefghijabcdefghijabcdefghijab"
enddata

symstart

; fixed-point constants
FLT_0p00999	.byte	$00, $00, $00, $02, $8f

; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_L	.block	3
INTVAR_M	.block	3
INTVAR_P	.block	3
INTVAR_RD	.block	3
INTVAR_UD	.block	3
INTVAR_Z	.block	3
FLTVAR_C	.block	5
FLTVAR_T	.block	5
FLTVAR_T1	.block	5
FLTVAR_T2	.block	5
FLTVAR_T3	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_I	.block	3
STRVAR_N	.block	3
; Numeric Arrays
INTARR_C	.block	4	; dims=1
INTARR_W	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
FLTARR_E	.block	4	; dims=1
FLTARR_F	.block	4	; dims=1
FLTARR_S	.block	4	; dims=1
FLTARR_T	.block	4	; dims=1
FLTARR_X	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

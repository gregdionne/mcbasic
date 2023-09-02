; Assembly for treasrch.bas
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
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_100

	; CLEAR 100

	jsr	clear

	; CLS

	jsr	cls

	; SH=0

	ldx	#INTVAR_SH
	jsr	clr_ix

	; ST=0

	ldx	#INTVAR_ST
	jsr	clr_ix

	; EVAL RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	; MC=-124

	ldx	#INTVAR_MC
	ldab	#-124
	jsr	ld_ix_nb

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

LINE_110

	; PRINT @448, "PLEASE ENTER YOUR NAME";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	22, "PLEASE ENTER YOUR NAME"

	; INPUT N$

	jsr	input

	ldx	#STRVAR_N
	jsr	readbuf_sx

	jsr	ignxtra

	; N$=LEFT$(N$,7)

	ldx	#STRVAR_N
	jsr	ld_sr1_sx

	ldab	#7
	jsr	left_sr1_sr1_pb

	ldx	#STRVAR_N
	jsr	ld_sx_sr1

LINE_120

	; DIM A(255),B(99),D(4),E(12),M(12)

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrdim1_ir1_ix

	ldab	#99
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrdim1_ir1_ix

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_D
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_E
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_M
	jsr	arrdim1_ir1_ix

LINE_130

	; DIM PV(12,12),Q(12),V(12),Z(12)

	ldab	#12
	jsr	ld_ir1_pb

	ldab	#12
	jsr	ld_ir2_pb

	ldx	#INTARR_PV
	jsr	arrdim2_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_Q
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrdim1_ir1_ix

	ldab	#12
	jsr	ld_ir1_pb

	ldx	#INTARR_Z
	jsr	arrdim1_ir1_ix

LINE_140

	; D(1)=-10

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_D
	jsr	arrref1_ir1_ix_ir1

	ldab	#-10
	jsr	ld_ip_nb

	; D(2)=-1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_D
	jsr	arrref1_ir1_ix_ir1

	jsr	true_ip

	; D(3)=1

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_D
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; D(4)=10

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_D
	jsr	arrref1_ir1_ix_ir1

	ldab	#10
	jsr	ld_ip_pb

LINE_150

	; A(65)=-1

	ldab	#65
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	true_ip

	; A(83)=1

	ldab	#83
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; A(87)=10

	ldab	#87
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	ldab	#10
	jsr	ld_ip_pb

	; A(90)=-10

	ldab	#90
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	ldab	#-10
	jsr	ld_ip_nb

LINE_160

	; PRINT @448, "\r";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @448, "PLAYING STRENGTH (1-5)";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	22, "PLAYING STRENGTH (1-5)"

	; INPUT Y

	jsr	input

	ldx	#FLTVAR_Y
	jsr	readbuf_fx

	jsr	ignxtra

	; WHEN (Y<1) OR (Y>5) GOTO 160

	ldx	#FLTVAR_Y
	ldab	#1
	jsr	ldlt_ir1_fx_pb

	ldab	#5
	ldx	#FLTVAR_Y
	jsr	ldlt_ir2_pb_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_160
	jsr	jmpne_ir1_ix

LINE_170

	; DM=SHIFT(INT(Y),1)

	ldx	#FLTVAR_Y
	jsr	dbl_ir1_ix

	ldx	#INTVAR_DM
	jsr	ld_ix_ir1

	; FOR I=11 TO 88

	ldx	#INTVAR_I
	ldab	#11
	jsr	for_ix_pb

	ldab	#88
	jsr	to_ip_pb

	; B(I)=RND(9)

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	ldab	#9
	jsr	irnd_ir1_pb

	jsr	ld_ip_ir1

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_180

	; FOR I=0 TO 10

	ldx	#INTVAR_I
	jsr	forclr_ix

	ldab	#10
	jsr	to_ip_pb

	; B(I)=99

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; FOR I=89 TO 99

	ldx	#INTVAR_I
	ldab	#89
	jsr	for_ix_pb

	ldab	#99
	jsr	to_ip_pb

	; B(I)=99

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_190

	; FOR I=19 TO 79 STEP 10

	ldx	#INTVAR_I
	ldab	#19
	jsr	for_ix_pb

	ldab	#79
	jsr	to_ip_pb

	ldab	#10
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; B(I)=99

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; B(I+1)=99

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	ldab	#99
	jsr	ld_ip_pb

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_220

	; CLS

	jsr	cls

	; FOR I=11 TO 88

	ldx	#INTVAR_I
	ldab	#11
	jsr	for_ix_pb

	ldab	#88
	jsr	to_ip_pb

	; WHEN B(I)=99 GOTO 240

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrval1_ir1_ix_id

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_240
	jsr	jmpne_ir1_ix

LINE_230

	; X$=RIGHT$(STR$(B(I)),1)

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrval1_ir1_ix_id

	jsr	str_sr1_ir1

	ldab	#1
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_X
	jsr	ld_sx_sr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_240

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; PRINT @8, "TREASURE SEARCH";STR$(Y);" ";

	ldab	#8
	jsr	prat_pb

	jsr	pr_ss
	.text	15, "TREASURE SEARCH"

	ldx	#FLTVAR_Y
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_250

	; PRINT @129, N$;

	ldab	#129
	jsr	prat_pb

	ldx	#STRVAR_N
	jsr	pr_sx

	; PRINT @225, "TRS-80";

	ldab	#225
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "TRS-80"

	; Y$="         "

	jsr	ld_sr1_ss
	.text	9, "         "

	ldx	#STRVAR_Y
	jsr	ld_sx_sr1

LINE_260

	; T=54

	ldx	#INTVAR_T
	ldab	#54
	jsr	ld_ix_pb

	; T$="*"

	jsr	ld_sr1_ss
	.text	1, "*"

	ldx	#STRVAR_T
	jsr	ld_sx_sr1

	; H=45

	ldx	#INTVAR_H
	ldab	#45
	jsr	ld_ix_pb

	; H$="x"

	jsr	ld_sr1_ss
	.text	1, "x"

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

LINE_270

	; I=T

	ldd	#INTVAR_I
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; X$=T$

	ldd	#STRVAR_X
	ldx	#STRVAR_T
	jsr	ld_sd_sx

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; B(T)=99

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; B(H)=99

	ldx	#INTARR_B
	ldd	#INTVAR_H
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

LINE_280

	; I=H

	ldd	#INTVAR_I
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; X$=H$

	ldd	#STRVAR_X
	ldx	#STRVAR_H
	jsr	ld_sd_sx

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; GOTO 300

	ldx	#LINE_300
	jsr	goto_ix

LINE_290

	; PRINT @448, "ILLEGAL MOVE. TRY AGAIN\r";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	24, "ILLEGAL MOVE. TRY AGAIN\r"

	; FOR I=1 TO 2200

	ldx	#INTVAR_I
	jsr	forone_ix

	ldd	#2200
	jsr	to_ip_pw

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_300

	; PRINT @448, "\r";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @448, "WHICH DIRECTION (AWSZ) FOR x?";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	29, "WHICH DIRECTION (AWSZ) FOR x?"

LINE_310

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 310

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

LINE_311

	; R=ASC(M$)

	ldx	#STRVAR_M
	jsr	asc_ir1_sx

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; WHEN (R<>65) AND (R<>83) AND (R<>87) AND (R<>90) GOTO 310

	ldx	#INTVAR_R
	ldab	#65
	jsr	ldne_ir1_ix_pb

	ldx	#INTVAR_R
	ldab	#83
	jsr	ldne_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_R
	ldab	#87
	jsr	ldne_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_R
	ldab	#90
	jsr	ldne_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

LINE_320

	; J=A(R)+H

	ldx	#INTARR_A
	ldd	#INTVAR_R
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_H
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

LINE_330

	; WHEN B(J)=99 GOTO 290

	ldx	#INTARR_B
	ldd	#INTVAR_J
	jsr	arrval1_ir1_ix_id

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_290
	jsr	jmpne_ir1_ix

LINE_331

	; PRINT @448, "\r";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	1, "\r"

LINE_360

	; I=H

	ldd	#INTVAR_I
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; B(I)=0

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; X$="-"

	jsr	ld_sr1_ss
	.text	1, "-"

	ldx	#STRVAR_X
	jsr	ld_sx_sr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; SH+=B(J)

	ldx	#INTARR_B
	ldd	#INTVAR_J
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_SH
	jsr	add_ix_ix_ir1

LINE_370

	; H=J

	ldd	#INTVAR_H
	ldx	#INTVAR_J
	jsr	ld_id_ix

	; B(H)=99

	ldx	#INTARR_B
	ldd	#INTVAR_H
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; I=H

	ldd	#INTVAR_I
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; X$=H$

	ldd	#STRVAR_X
	ldx	#STRVAR_H
	jsr	ld_sd_sx

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

LINE_380

	; PRINT @162, STR$(SH);" ";

	ldab	#162
	jsr	prat_pb

	ldx	#INTVAR_SH
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; WHEN SH>99 GOTO 930

	ldab	#99
	ldx	#INTVAR_SH
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_930
	jsr	jmpne_ir1_ix

LINE_500

	; FOR I=4 TO DM

	ldx	#INTVAR_I
	ldab	#4
	jsr	for_ix_pb

	ldx	#INTVAR_DM
	jsr	to_ip_ix

	; Z(I-2)=PV(2,I)

	ldx	#INTVAR_I
	ldab	#2
	jsr	sub_ir1_ix_pb

	ldx	#INTARR_Z
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_PV
	ldd	#INTVAR_I
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

LINE_510

	; IF PV(2,3)=H THEN

	ldab	#2
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#INTARR_PV
	jsr	arrval2_ir1_ix_ir2

	ldx	#INTVAR_H
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_511
	jsr	jmpeq_ir1_ix

	; DT=DM

	ldd	#INTVAR_DT
	ldx	#INTVAR_DM
	jsr	ld_id_ix

	; GOTO 520

	ldx	#LINE_520
	jsr	goto_ix

LINE_511

	; DT=2

	ldx	#INTVAR_DT
	ldab	#2
	jsr	ld_ix_pb

LINE_520

	; L=1

	ldx	#INTVAR_L
	jsr	one_ix

	; SC=0

	ldx	#INTVAR_SC
	jsr	clr_ix

	; S=-1

	ldx	#INTVAR_S
	jsr	true_ix

LINE_530

	; V(0)=-99

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	ldab	#-99
	jsr	ld_ip_nb

	; V(1)=-99

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	ldab	#-99
	jsr	ld_ip_nb

	; M(0)=T

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_M
	jsr	arrref1_ir1_ix_ir1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; M(1)=H

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_M
	jsr	arrref1_ir1_ix_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_540

	; L+=1

	ldx	#INTVAR_L
	jsr	inc_ix_ix

	; Q(L)=0

	ldx	#INTARR_Q
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; S=-S

	ldx	#INTVAR_S
	jsr	neg_ix_ix

	; V(L)=V(L-2)

	ldx	#INTARR_V
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_L
	ldab	#2
	jsr	sub_ir1_ix_pb

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_550

	; J=Z(L)

	ldx	#INTARR_Z
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; I=0

	ldx	#INTVAR_I
	jsr	clr_ix

LINE_560

	; I+=1

	ldx	#INTVAR_I
	jsr	inc_ix_ix

	; WHEN (M(L-2)+D(I))=J GOTO 600

	ldx	#INTVAR_L
	ldab	#2
	jsr	sub_ir1_ix_pb

	ldx	#INTARR_M
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTARR_D
	ldd	#INTVAR_I
	jsr	arrval1_ir2_ix_id

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_J
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_600
	jsr	jmpne_ir1_ix

LINE_561

	; WHEN I<4 GOTO 560

	ldx	#INTVAR_I
	ldab	#4
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_560
	jsr	jmpne_ir1_ix

LINE_580

	; Q(L)+=1

	ldx	#INTARR_Q
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	jsr	inc_ip_ip

	; WHEN Q(L)>4 GOTO 760

	ldx	#INTARR_Q
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldab	#4
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_760
	jsr	jmpne_ir1_ix

LINE_590

	; J=M(L-2)+D(Q(L))

	ldx	#INTVAR_L
	ldab	#2
	jsr	sub_ir1_ix_pb

	ldx	#INTARR_M
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTARR_Q
	ldd	#INTVAR_L
	jsr	arrval1_ir2_ix_id

	ldx	#INTARR_D
	jsr	arrval1_ir2_ix_ir2

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; WHEN Z(L)=J GOTO 580

	ldx	#INTARR_Z
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_J
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_580
	jsr	jmpne_ir1_ix

LINE_600

	; WHEN B(J)=99 GOTO 580

	ldx	#INTARR_B
	ldd	#INTVAR_J
	jsr	arrval1_ir1_ix_id

	ldab	#99
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_580
	jsr	jmpne_ir1_ix

LINE_601

	; M(L)=J

	ldx	#INTARR_M
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; E(L)=B(J)

	ldx	#INTARR_E
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#INTVAR_J
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

LINE_610

	; B(J)=99

	ldx	#INTARR_B
	ldd	#INTVAR_J
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; B(M(L-2))=0

	ldx	#INTVAR_L
	ldab	#2
	jsr	sub_ir1_ix_pb

	ldx	#INTARR_M
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; SC+=E(L)*S

	ldx	#INTARR_E
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_S
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_SC
	jsr	add_ix_ix_ir1

LINE_620

	; PRINT @SHIFT(L,5)+MC+179, STR$(J);STR$(SC);STR$(V(L));" ";

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_MC
	jsr	add_ir1_ir1_ix

	ldab	#179
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#INTVAR_J
	jsr	str_sr1_ix

	jsr	pr_sr1

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	pr_sr1

	ldx	#INTARR_V
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; WHEN L<DT GOTO 540

	ldx	#INTVAR_L
	ldd	#INTVAR_DT
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_540
	jsr	jmpne_ir1_ix

LINE_670

	; V(L+1)=-S*SC

	ldx	#INTVAR_L
	jsr	inc_ir1_ix

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	ldx	#INTVAR_S
	jsr	neg_ir1_ix

	ldx	#INTVAR_SC
	jsr	mul_ir1_ir1_ix

	jsr	ld_ip_ir1

LINE_680

	; B(M(L))=E(L)

	ldx	#INTARR_M
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	ldx	#INTARR_E
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

	; B(M(L-2))=99

	ldx	#INTVAR_L
	ldab	#2
	jsr	sub_ir1_ix_pb

	ldx	#INTARR_M
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	ldab	#99
	jsr	ld_ip_pb

	; SC-=E(L)*S

	ldx	#INTARR_E
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_S
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_SC
	jsr	sub_ix_ix_ir1

LINE_700

	; IF V(L)<-V(L+1) THEN

	ldx	#INTARR_V
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_L
	jsr	inc_ir2_ix

	ldx	#INTARR_V
	jsr	arrval1_ir2_ix_ir2

	jsr	neg_ir2_ir2

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_701
	jsr	jmpeq_ir1_ix

	; V(L)=-V(L+1)

	ldx	#INTARR_V
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_L
	jsr	inc_ir1_ix

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	neg_ir1_ir1

	jsr	ld_ip_ir1

	; GOTO 740

	ldx	#LINE_740
	jsr	goto_ix

LINE_701

	; GOTO 580

	ldx	#LINE_580
	jsr	goto_ix

LINE_710

	; IF L>2 THEN

	ldab	#2
	ldx	#INTVAR_L
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_720
	jsr	jmpeq_ir1_ix

	; Z(L)=M(L)

	ldx	#INTARR_Z
	ldd	#INTVAR_L
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_M
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

LINE_720

	; I=L

	ldd	#INTVAR_I
	ldx	#INTVAR_L
	jsr	ld_id_ix

	; PV(L,I)=M(L)

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTARR_PV
	ldd	#INTVAR_I
	jsr	arrref2_ir1_ix_id

	ldx	#INTARR_M
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

	; WHEN L=DT GOTO 740

	ldx	#INTVAR_L
	ldd	#INTVAR_DT
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_740
	jsr	jmpne_ir1_ix

LINE_730

	; I+=1

	ldx	#INTVAR_I
	jsr	inc_ix_ix

	; PV(L,I)=PV(L+1,I)

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTARR_PV
	ldd	#INTVAR_I
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_L
	jsr	inc_ir1_ix

	ldx	#INTARR_PV
	ldd	#INTVAR_I
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; WHEN I<DT GOTO 730

	ldx	#INTVAR_I
	ldd	#INTVAR_DT
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_730
	jsr	jmpne_ir1_ix

LINE_740

	; IF L=2 THEN

	ldx	#INTVAR_L
	ldab	#2
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_750
	jsr	jmpeq_ir1_ix

	; BM=M(L)

	ldx	#INTARR_M
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_BM
	jsr	ld_ix_ir1

	; PRINT @MC+180, STR$(BM);STR$(V(2));

	ldx	#INTVAR_MC
	ldab	#180
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldx	#INTVAR_BM
	jsr	str_sr1_ix

	jsr	pr_sr1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	str_sr1_ir1

	jsr	pr_sr1

LINE_750

	; IF V(L)<-V(L-1) THEN

	ldx	#INTARR_V
	ldd	#INTVAR_L
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_L
	jsr	dec_ir2_ix

	ldx	#INTARR_V
	jsr	arrval1_ir2_ix_ir2

	jsr	neg_ir2_ir2

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_760
	jsr	jmpeq_ir1_ix

	; GOTO 580

	ldx	#LINE_580
	jsr	goto_ix

	; REM GOTO580

LINE_760

	; L-=1

	ldx	#INTVAR_L
	jsr	dec_ix_ix

	; S=-S

	ldx	#INTVAR_S
	jsr	neg_ix_ix

	; PRINT @SHIFT(L,5)+MC+243, Y$;

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_MC
	jsr	add_ir1_ir1_ix

	ldab	#243
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	ldx	#STRVAR_Y
	jsr	pr_sx

	; WHEN L>1 GOTO 680

	ldab	#1
	ldx	#INTVAR_L
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_680
	jsr	jmpne_ir1_ix

LINE_780

	; WHEN DT=DM GOTO 800

	ldx	#INTVAR_DT
	ldd	#INTVAR_DM
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_800
	jsr	jmpne_ir1_ix

LINE_790

	; FOR I=2 TO DT

	ldx	#INTVAR_I
	ldab	#2
	jsr	for_ix_pb

	ldx	#INTVAR_DT
	jsr	to_ip_ix

	; Z(I)=PV(2,I)

	ldx	#INTARR_Z
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_PV
	ldd	#INTVAR_I
	jsr	arrval2_ir1_ix_id

	jsr	ld_ip_ir1

	; NEXT I

	ldx	#INTVAR_I
	jsr	nextvar_ix

	jsr	next

	; DT+=2

	ldx	#INTVAR_DT
	ldab	#2
	jsr	add_ix_ix_pb

	; GOTO 520

	ldx	#LINE_520
	jsr	goto_ix

LINE_800

	; I=T

	ldd	#INTVAR_I
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; B(I)=0

	ldx	#INTARR_B
	ldd	#INTVAR_I
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; X$="-"

	jsr	ld_sr1_ss
	.text	1, "-"

	ldx	#STRVAR_X
	jsr	ld_sx_sr1

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; PRINT @MC+179, Y$;

	ldx	#INTVAR_MC
	ldab	#179
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldx	#STRVAR_Y
	jsr	pr_sx

LINE_810

	; T=BM

	ldd	#INTVAR_T
	ldx	#INTVAR_BM
	jsr	ld_id_ix

	; ST+=B(T)

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_ST
	jsr	add_ix_ix_ir1

	; B(T)=99

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#99
	jsr	ld_ip_pb

	; I=T

	ldd	#INTVAR_I
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; X$=T$

	ldd	#STRVAR_X
	ldx	#STRVAR_T
	jsr	ld_sd_sx

LINE_820

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; PRINT @258, STR$(ST);" ";

	ldd	#258
	jsr	prat_pw

	ldx	#INTVAR_ST
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; WHEN ST<100 GOTO 300

	ldx	#INTVAR_ST
	ldab	#100
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_300
	jsr	jmpne_ir1_ix

LINE_910

	; PRINT @448, "THANK YOU FOR A PLEASANT GAME";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	29, "THANK YOU FOR A PLEASANT GAME"

LINE_920

	; PRINT @480, "TRY AGAIN? (Y/N)";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	16, "TRY AGAIN? (Y/N)"

LINE_921

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

LINE_922

	; IF M$="Y" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_923
	jsr	jmpeq_ir1_ix

	; RUN

	jsr	clear

	ldx	#LINE_100
	jsr	goto_ix

LINE_923

	; IF M$="N" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_924
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_924

	; GOTO 921

	ldx	#LINE_921
	jsr	goto_ix

LINE_930

	; PRINT @448, "CONGRATULATIONS, YOU WIN";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	24, "CONGRATULATIONS, YOU WIN"

	; GOTO 920

	ldx	#LINE_920
	jsr	goto_ix

LINE_1000

	; R=IDIV(I,10)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#10
	jsr	idiv5s_ir1_ir1_pb

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; C=I-(R*10)

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#10
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_I
	jsr	rsub_ir1_ir1_ix

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; K=SHIFT(8-R,5)+SHIFT(C,1)+70

	ldab	#8
	ldx	#INTVAR_R
	jsr	sub_ir1_pb_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_C
	jsr	dbl_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldab	#70
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

LINE_1010

	; PRINT @K, X$;

	ldx	#INTVAR_K
	jsr	prat_ix

	ldx	#STRVAR_X
	jsr	pr_sx

	; RETURN

	jsr	return

LINE_2000

	; CLS

	jsr	cls

	; PRINT TAB(8);"treasure search\r";

	ldab	#8
	jsr	prtab_pb

	jsr	pr_ss
	.text	16, "treasure search\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_2001

	; PRINT "TREASURE SEARCH IS TAKEN FROM\r";

	jsr	pr_ss
	.text	30, "TREASURE SEARCH IS TAKEN FROM\r"

LINE_2002

	; PRINT "BYTE MAGAZINE NOV 1980, AND IS\r";

	jsr	pr_ss
	.text	31, "BYTE MAGAZINE NOV 1980, AND IS\r"

LINE_2003

	; PRINT "BY PETER FREY. IT IS PLAYED ON\r";

	jsr	pr_ss
	.text	31, "BY PETER FREY. IT IS PLAYED ON\r"

LINE_2004

	; PRINT "AN 8-BY-8 GRID. EACH SQUARE IS\r";

	jsr	pr_ss
	.text	31, "AN 8-BY-8 GRID. EACH SQUARE IS\r"

LINE_2005

	; PRINT "A RANDOM NUMBER FROM 1 TO 9.\r";

	jsr	pr_ss
	.text	29, "A RANDOM NUMBER FROM 1 TO 9.\r"

LINE_2006

	; PRINT "THE PLAYERS TAKE TURNS MOVING\r";

	jsr	pr_ss
	.text	30, "THE PLAYERS TAKE TURNS MOVING\r"

LINE_2007

	; PRINT "ONE SQUARE AT A TIME EITHER\r";

	jsr	pr_ss
	.text	28, "ONE SQUARE AT A TIME EITHER\r"

LINE_2008

	; PRINT "HORIZONTALLY OR VERTICALLY\r";

	jsr	pr_ss
	.text	27, "HORIZONTALLY OR VERTICALLY\r"

LINE_2009

	; PRINT "COLLECTING NUMBERS. THE\r";

	jsr	pr_ss
	.text	24, "COLLECTING NUMBERS. THE\r"

LINE_2010

	; PRINT "OBJECTIVE OF THE GAME IS TO BE\r";

	jsr	pr_ss
	.text	31, "OBJECTIVE OF THE GAME IS TO BE\r"

LINE_2011

	; PRINT "THE FIRST TO REACH 100 POINTS.\r";

	jsr	pr_ss
	.text	31, "THE FIRST TO REACH 100 POINTS.\r"

LINE_2012

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; RETURN

	jsr	return

LINE_2013

	; REM MC-10 EDITS JIM GERRIE

LINE_2014

	; REM AND GREG DIONNE 2023

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

add_ir1_ir1_ir2			; numCalls = 3
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

add_ir1_ir1_pb			; numCalls = 3
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_pb			; numCalls = 2
	.module	modadd_ir1_ix_pb
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
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

add_ix_ix_pb			; numCalls = 1
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

arrref1_ir1_ix_id			; numCalls = 19
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 18
	.module	modarrref1_ir1_ix_ir1
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

arrval1_ir1_ix_id			; numCalls = 21
	.module	modarrval1_ir1_ix_id
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

arrval1_ir1_ix_ir1			; numCalls = 7
	.module	modarrval1_ir1_ix_ir1
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

arrval1_ir2_ix_id			; numCalls = 2
	.module	modarrval1_ir2_ix_id
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

arrval1_ir2_ix_ir2			; numCalls = 3
	.module	modarrval1_ir2_ix_ir2
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

clr_ip			; numCalls = 4
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 4
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 3
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

dbl_ir2_ix			; numCalls = 1
	.module	moddbl_ir2_ix
	ldd	1,x
	lsld
	std	r2+1
	ldab	0,x
	rolb
	stab	r2
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

for_ix_pb			; numCalls = 6
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 1
	.module	modforclr_ix
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 1
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

goto_ix			; numCalls = 9
	.module	modgoto_ix
	ins
	ins
	jmp	,x

idiv5s_ir1_ir1_pb			; numCalls = 1
	.module	modidiv5s_ir1_ir1_pb
	ldx	#r1
	jmp	idiv5s

ignxtra			; numCalls = 2
	.module	modignxtra
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inc_ip_ip			; numCalls = 1
	.module	modinc_ip_ip
	ldx	letptr
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
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

inc_ir2_ix			; numCalls = 1
	.module	modinc_ir2_ix
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 3
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

input			; numCalls = 2
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

jmpeq_ir1_ix			; numCalls = 7
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

jmpne_ir1_ix			; numCalls = 17
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

ld_id_ix			; numCalls = 10
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

ld_ip_ir1			; numCalls = 14
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_nb			; numCalls = 4
	.module	modld_ip_nb
	ldx	letptr
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ip_pb			; numCalls = 12
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 9
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 26
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 2
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 9
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

ld_ix_pb			; numCalls = 3
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_sd_sx			; numCalls = 4
	.module	modld_sd_sx
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	tmp1
	jmp	strprm

ld_sr1_ss			; numCalls = 5
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 1
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 7
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ix			; numCalls = 3
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

ldlt_ir1_pb_ir1			; numCalls = 1
	.module	modldlt_ir1_pb_ir1
	clra
	subd	r1+1
	ldab	#0
	sbcb	r1
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

ldne_ir1_ix_pb			; numCalls = 1
	.module	modldne_ir1_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir2_ix_pb			; numCalls = 3
	.module	modldne_ir2_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
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
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

neg_ir1_ir1			; numCalls = 2
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

neg_ir2_ir2			; numCalls = 2
	.module	modneg_ir2_ir2
	ldx	#r2
	jmp	negxi

neg_ix_ix			; numCalls = 2
	.module	modneg_ix_ix
	jmp	negxi

next			; numCalls = 8
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

nextvar_ix			; numCalls = 8
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

one_ix			; numCalls = 1
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

pr_ss			; numCalls = 30
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 4
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 4
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 1
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

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jmp	prtab

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

return			; numCalls = 2
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

rsub_ir1_ir1_ix			; numCalls = 1
	.module	modrsub_ir1_ir1_ix
	ldd	1,x
	subd	r1+1
	std	r1+1
	ldab	0,x
	sbcb	r1
	stab	r1
	rts

shift_ir1_ir1_pb			; numCalls = 3
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

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

str_sr1_ir1			; numCalls = 3
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

str_sr1_ix			; numCalls = 5
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

sub_ir1_ix_pb			; numCalls = 6
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

sub_ir1_pb_ix			; numCalls = 1
	.module	modsub_ir1_pb_ix
	subb	2,x
	stab	r1+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r1
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

true_ix			; numCalls = 1
	.module	modtrue_ix
	ldd	#-1
	stab	0,x
	std	1,x
	rts

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_BM	.block	3
INTVAR_C	.block	3
INTVAR_DM	.block	3
INTVAR_DT	.block	3
INTVAR_H	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_MC	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_SH	.block	3
INTVAR_ST	.block	3
INTVAR_T	.block	3
FLTVAR_Y	.block	5
; String Variables
STRVAR_H	.block	3
STRVAR_M	.block	3
STRVAR_N	.block	3
STRVAR_T	.block	3
STRVAR_X	.block	3
STRVAR_Y	.block	3
; Numeric Arrays
INTARR_A	.block	4	; dims=1
INTARR_B	.block	4	; dims=1
INTARR_D	.block	4	; dims=1
INTARR_E	.block	4	; dims=1
INTARR_M	.block	4	; dims=1
INTARR_PV	.block	6	; dims=2
INTARR_Q	.block	4	; dims=1
INTARR_V	.block	4	; dims=1
INTARR_Z	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

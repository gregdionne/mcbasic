; Assembly for elevator.bas
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

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; GOTO 1000

	ldx	#LINE_1000
	jsr	goto_ix

LINE_1

	; RETURN

	jsr	return

LINE_2

	; WHEN D<>2 GOTO 5

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_5
	jsr	jmpne_ir1_ix

	; ON K(PEEK(P+M-3)) GOTO 30,50,90,82

	ldx	#INTVAR_P
	ldd	#FLTVAR_M
	jsr	add_fr1_ix_fd

	ldab	#3
	jsr	sub_fr1_fr1_pb

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_30, LINE_50, LINE_90, LINE_82

	; P-=3

	ldx	#INTVAR_P
	ldab	#3
	jsr	sub_ix_ix_pb

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_3

	; WHEN D>0 GOTO 5

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_D
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_5
	jsr	jmpne_ir1_ix

	; ON K(PEEK(P+M+3)) GOTO 30,50,93,82

	ldx	#INTVAR_P
	ldd	#FLTVAR_M
	jsr	add_fr1_ix_fd

	ldab	#3
	jsr	add_fr1_fr1_pb

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_30, LINE_50, LINE_93, LINE_82

	; P+=3

	ldx	#INTVAR_P
	ldab	#3
	jsr	add_ix_ix_pb

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_4

	; D=((D=1) AND 3)-(D=0)-(D=3)-((D=2) AND -3)

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldab	#3
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_D
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldeq_ir2_ir2_pb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_D
	jsr	ld_ir2_ix

	ldab	#3
	jsr	ldeq_ir2_ir2_pb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_D
	jsr	ld_ir2_ix

	ldab	#2
	jsr	ldeq_ir2_ir2_pb

	ldab	#-3
	jsr	and_ir2_ir2_nb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_5

	; D=((D=0) AND 2)-((D=3) AND -2)

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	ldab	#2
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_D
	jsr	ld_ir2_ix

	ldab	#3
	jsr	ldeq_ir2_ir2_pb

	ldab	#-2
	jsr	and_ir2_ir2_nb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_6

	; SET(I,13,4)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#13
	jsr	ld_ir2_pb

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; I+=SHIFT(J,1)

	ldx	#INTVAR_J
	jsr	dbl_ir1_ix

	ldx	#INTVAR_I
	jsr	add_ix_ix_ir1

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; D=-(D<2)-((D>1) AND -3)

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldlt_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#INTVAR_D
	jsr	ldlt_ir2_ir2_ix

	ldab	#-3
	jsr	and_ir2_ir2_nb

	jsr	add_ir1_ir1_ir2

	jsr	neg_ir1_ir1

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; GOTO 48

	ldx	#LINE_48
	jsr	goto_ix

LINE_7

	; SET(X,13,4)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldab	#13
	jsr	ld_ir2_pb

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; X=T

	ldd	#FLTVAR_X
	ldx	#INTVAR_T
	jsr	ld_fd_ix

	; GOTO 44

	ldx	#LINE_44
	jsr	goto_ix

LINE_8

	; I+=SHIFT(J,1)

	ldx	#INTVAR_J
	jsr	dbl_ir1_ix

	ldx	#INTVAR_I
	jsr	add_ix_ix_ir1

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_9

	; T=B(F+1)

	ldx	#INTVAR_F
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; V=A(F+1)

	ldx	#INTVAR_F
	jsr	inc_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_V
	jsr	ld_ix_ir1

	; O=C(F+1)

	ldx	#INTVAR_F
	jsr	inc_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; PRINT @0, V$;F$(T);W$;B$(V);G$(T);B$(O);X$;C$(V);H$(T);C$(O);X$;D$(V);I$(T);D$(O);Y$;J$(T);Z$;

	ldab	#0
	jsr	prat_pb

	ldx	#STRVAR_V
	jsr	pr_sx

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_F
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_W
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_G
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_H
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_I
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Y
	jsr	pr_sx

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_J
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Z
	jsr	pr_sx

LINE_10

	; T=B(F)

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; V=A(F)

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_V
	jsr	ld_ix_ir1

	; O=C(F)

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; PRINT V$;F$(T);W$;B$(V);G$(T);B$(O);X$;C$(V);H$(T);C$(O);X$;D$(V);I$(T);D$(O);Y$;J$(T);Z$;

	ldx	#STRVAR_V
	jsr	pr_sx

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_F
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_W
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_G
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_H
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_I
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Y
	jsr	pr_sx

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_J
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Z
	jsr	pr_sx

LINE_11

	; T=B(F-1)

	ldx	#INTVAR_F
	jsr	dec_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; V=A(F-1)

	ldx	#INTVAR_F
	jsr	dec_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_V
	jsr	ld_ix_ir1

	; O=C(F-1)

	ldx	#INTVAR_F
	jsr	dec_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; PRINT V$;F$(T);W$;B$(V);G$(T);B$(O);X$;C$(V);H$(T);C$(O);X$;D$(V);I$(T);D$(O);Y$;J$(T);

	ldx	#STRVAR_V
	jsr	pr_sx

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_F
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_W
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_G
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_H
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_I
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_O
	jsr	ld_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Y
	jsr	pr_sx

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#STRARR_J
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_20

	; FOR N=0 TO 5 STEP 0

	ldx	#INTVAR_N
	jsr	forclr_ix

	ldab	#5
	jsr	to_ip_pb

	ldab	#0
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; PRINT @P, M$(D);

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @P+C, N$(D);

	ldx	#INTVAR_P
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @P+K, O$(D);

	ldx	#INTVAR_P
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; ON K(PEEK(2) AND PEEK(R)) GOTO 2,3,70,4,87

	ldab	#2
	jsr	peek_ir1_pb

	ldx	#INTVAR_R
	jsr	peek_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_2, LINE_3, LINE_70, LINE_4, LINE_87

LINE_30

	; IF G THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#LINE_31
	jsr	jmpeq_ir1_ix

	; PRINT @G, M$(H);

	ldx	#INTVAR_G
	jsr	prat_ix

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+C, N$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+K, O$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; IF J=0 THEN

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#LINE_31
	jsr	jmpne_ir1_ix

	; IF RND(Q)=1 THEN

	ldx	#INTVAR_Q
	jsr	rnd_fr1_ix

	ldab	#1
	jsr	ldeq_ir1_fr1_pb

	ldx	#LINE_31
	jsr	jmpeq_ir1_ix

	; J=SGN(P-G)

	ldx	#INTVAR_P
	ldd	#INTVAR_G
	jsr	sub_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; H=J+5

	ldx	#INTVAR_J
	ldab	#5
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; J=SHIFT(J,1)

	ldx	#INTVAR_J
	jsr	dbl_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ix_ir1

	; I=SHIFT(J,1)+L

	ldx	#INTVAR_J
	jsr	dbl_ir1_ix

	ldx	#INTVAR_L
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_I
	jsr	ld_ix_ir1

	; GOTO 40

	ldx	#LINE_40
	jsr	goto_ix

LINE_31

	; W+=1

	ldx	#INTVAR_W
	jsr	inc_ix_ix

	; IF W=3 THEN

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; W=0

	ldx	#INTVAR_W
	jsr	clr_ix

	; T=2-RND(3)

	ldab	#3
	jsr	irnd_ir1_pb

	ldab	#2
	jsr	rsub_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; IF ABS(E+T-F)<2 THEN

	ldx	#INTVAR_E
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	ldx	#INTVAR_F
	jsr	sub_ir1_ir1_ix

	jsr	abs_ir1_ir1

	ldab	#2
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; IF (E+T)>1 THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_E
	ldd	#INTVAR_T
	jsr	add_ir2_ix_id

	jsr	ldlt_ir1_ir1_ir2

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; IF (E+T)<31 THEN

	ldx	#INTVAR_E
	ldd	#INTVAR_T
	jsr	add_ir1_ix_id

	ldab	#31
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_34
	jsr	jmpeq_ir1_ix

	; E+=T

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTVAR_E
	jsr	add_ix_ix_ir1

	; B(E+1)=1

	ldx	#INTVAR_E
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; B(E)=2

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; B(E-1)=0

	ldx	#INTVAR_E
	jsr	dec_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	clr_ip

LINE_34

	; IF J THEN

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldx	#LINE_36
	jsr	jmpeq_ir1_ix

	; FOR I=I TO SHIFT(J,1)+I STEP J

	ldd	#INTVAR_I
	ldx	#INTVAR_I
	jsr	for_id_ix

	ldx	#INTVAR_J
	jsr	dbl_ir1_ix

	ldx	#INTVAR_I
	jsr	add_ir1_ir1_ix

	jsr	to_ip_ir1

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; ON POINT(I,13) GOSUB 1,6,1,1,8

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#13
	jsr	point_ir1_ir1_pb

	jsr	ongosub_ir1_is
	.byte	5
	.word	LINE_1, LINE_6, LINE_1, LINE_1, LINE_8

	; RESET(I,13)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldab	#13
	jsr	reset_ir1_pb

	; NEXT

	jsr	next

LINE_36

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_40

	; IF H=5 THEN

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#5
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_41
	jsr	jmpeq_ir1_ix

	; ON RND(3) GOSUB 42,43,44

	ldab	#3
	jsr	irnd_ir1_pb

	jsr	ongosub_ir1_is
	.byte	3
	.word	LINE_42, LINE_43, LINE_44

LINE_41

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_42

	; H=4

	ldx	#INTVAR_H
	ldab	#4
	jsr	ld_ix_pb

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; GOTO 48

	ldx	#LINE_48
	jsr	goto_ix

LINE_43

	; H=6

	ldx	#INTVAR_H
	ldab	#6
	jsr	ld_ix_pb

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; GOTO 48

	ldx	#LINE_48
	jsr	goto_ix

LINE_44

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; H+=1

	ldx	#INTVAR_H
	jsr	inc_ix_ix

	; Z+=1

	ldx	#INTVAR_Z
	jsr	inc_ix_ix

	; PRINT @G, M$(H);

	ldx	#INTVAR_G
	jsr	prat_ix

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+C, N$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+K, O$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; IF Z=3 THEN

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_45
	jsr	jmpeq_ir1_ix

	; G=0

	ldx	#INTVAR_G
	jsr	clr_ix

	; SC+=10

	ldx	#INTVAR_SC
	ldab	#10
	jsr	add_ix_ix_pb

	; GOSUB 120

	ldx	#LINE_120
	jsr	gosub_ix

	; SOUND 38,1

	ldab	#38
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_45

	; RETURN

	jsr	return

LINE_47

	; PRINT @P, M$(D);

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @P+C, N$(D);

	ldx	#INTVAR_P
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @P+K, O$(D);

	ldx	#INTVAR_P
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_48

	; N+=1

	ldx	#INTVAR_N
	jsr	inc_ix_ix

	; POKE M+511,117-N

	ldx	#FLTVAR_M
	ldd	#511
	jsr	add_fr1_fx_pw

	ldab	#117
	ldx	#INTVAR_N
	jsr	sub_ir2_pb_ix

	jsr	poke_ir1_ir2

	; SOUND 1,4

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#4
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_50

	; P=207

	ldx	#INTVAR_P
	ldab	#207
	jsr	ld_ix_pb

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; W=0

	ldx	#INTVAR_W
	jsr	clr_ix

LINE_51

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; PRINT @P, M$(D);

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @P+C, N$(D);

	ldx	#INTVAR_P
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @P+K, O$(D);

	ldx	#INTVAR_P
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; ON K(PEEK(2) AND PEEK(R)) GOTO 64,65,60,55

	ldab	#2
	jsr	peek_ir1_pb

	ldx	#INTVAR_R
	jsr	peek_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_64, LINE_65, LINE_60, LINE_55

	; GOTO 51

	ldx	#LINE_51
	jsr	goto_ix

LINE_55

	; IF F=2 THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_56
	jsr	jmpeq_ir1_ix

	; WHEN U=S GOTO 250

	ldx	#INTVAR_U
	ldd	#INTVAR_S
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_250
	jsr	jmpne_ir1_ix

LINE_56

	; IF F>2 THEN

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTVAR_F
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_57
	jsr	jmpeq_ir1_ix

	; F-=1

	ldx	#INTVAR_F
	jsr	dec_ix_ix

	; E-=1

	ldx	#INTVAR_E
	jsr	dec_ix_ix

	; B(E+1)=1

	ldx	#INTVAR_E
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; B(E)=2

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; B(E-1)=0

	ldx	#INTVAR_E
	jsr	dec_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	clr_ip

	; PRINT @493, "FLOOR";STR$(F);" ";

	ldd	#493
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "FLOOR"

	ldx	#INTVAR_F
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_57

	; GOSUB 99

	ldx	#LINE_99
	jsr	gosub_ix

	; GOTO 51

	ldx	#LINE_51
	jsr	goto_ix

LINE_60

	; IF F<29 THEN

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#29
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_61
	jsr	jmpeq_ir1_ix

	; F+=1

	ldx	#INTVAR_F
	jsr	inc_ix_ix

	; E+=1

	ldx	#INTVAR_E
	jsr	inc_ix_ix

	; B(E+1)=1

	ldx	#INTVAR_E
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; B(E)=2

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; B(E-1)=0

	ldx	#INTVAR_E
	jsr	dec_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	clr_ip

	; PRINT @493, "FLOOR";STR$(F);" ";

	ldd	#493
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "FLOOR"

	ldx	#INTVAR_F
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_61

	; GOSUB 99

	ldx	#LINE_99
	jsr	gosub_ix

	; GOTO 51

	ldx	#LINE_51
	jsr	goto_ix

LINE_64

	; P-=4

	ldx	#INTVAR_P
	ldab	#4
	jsr	sub_ix_ix_pb

	; D=2

	ldx	#INTVAR_D
	ldab	#2
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_65

	; P+=4

	ldx	#INTVAR_P
	ldab	#4
	jsr	add_ix_ix_pb

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_66

	; IF K(PEEK(J(O+V)+M-C))<>1 THEN

	ldx	#INTVAR_O
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTARR_J
	jsr	arrval1_ir1_ix

	ldx	#FLTVAR_M
	jsr	add_fr1_ir1_fx

	ldx	#INTVAR_C
	jsr	sub_fr1_fr1_ix

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_67
	jsr	jmpeq_ir1_ix

	; P=J(O+V)-C

	ldx	#INTVAR_O
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTARR_J
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_C
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; P+=C

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	add_ix_ix_ir1

	; IF K(PEEK(J(O+V+V)+M))<>1 THEN

	ldx	#INTVAR_O
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTARR_J
	jsr	arrval1_ir1_ix

	ldx	#FLTVAR_M
	jsr	add_fr1_ir1_fx

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_67
	jsr	jmpeq_ir1_ix

	; P=J(O+V+V)

	ldx	#INTVAR_O
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTARR_J
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

LINE_67

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; IF G THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#LINE_68
	jsr	jmpeq_ir1_ix

	; PRINT @G, M$(H);

	ldx	#INTVAR_G
	jsr	prat_ix

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+C, N$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+K, O$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

LINE_68

	; T=J(O+V)

	ldx	#INTVAR_O
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTARR_J
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; ON K(PEEK(P+M+1)) GOTO 30,50,91,85

	ldx	#INTVAR_P
	ldd	#FLTVAR_M
	jsr	add_fr1_ix_fd

	jsr	inc_fr1_fr1

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_30, LINE_50, LINE_91, LINE_85

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_70

	; IF D=1 THEN

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_71
	jsr	jmpeq_ir1_ix

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_71

	; IF D=3 THEN

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#3
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_72
	jsr	jmpeq_ir1_ix

	; D=2

	ldx	#INTVAR_D
	ldab	#2
	jsr	ld_ix_pb

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_72

	; IF D=0 THEN

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#LINE_73
	jsr	jmpne_ir1_ix

	; V=1

	ldx	#INTVAR_V
	jsr	one_ix

	; GOSUB 78

	ldx	#LINE_78
	jsr	gosub_ix

	; GOTO 66

	ldx	#LINE_66
	jsr	goto_ix

LINE_73

	; V=-1

	ldx	#INTVAR_V
	jsr	true_ix

	; GOSUB 78

	ldx	#LINE_78
	jsr	gosub_ix

	; GOTO 66

	ldx	#LINE_66
	jsr	goto_ix

LINE_75

	; PRINT @160, V$;F$(B(F));W$;B$(A(F));G$(B(F));B$(C(F));X$;C$(A(F));H$(B(F));C$(C(F));X$;D$(A(F));I$(B(F));D$(C(F));Y$;J$(B(F));Z$;

	ldab	#160
	jsr	prat_pb

	ldx	#STRVAR_V
	jsr	pr_sx

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#STRARR_F
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_W
	jsr	pr_sx

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#STRARR_G
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldx	#STRARR_B
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#STRARR_H
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldx	#STRARR_C
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_X
	jsr	pr_sx

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#STRARR_I
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrval1_ir1_ix

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Y
	jsr	pr_sx

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrval1_ir1_ix

	ldx	#STRARR_J
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	ldx	#STRVAR_Z
	jsr	pr_sx

	; RETURN

	jsr	return

LINE_78

	; FOR T=1 TO 7

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#7
	jsr	to_ip_pb

	; IF J(T)=P THEN

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_J
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_P
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_79
	jsr	jmpeq_ir1_ix

	; O=T

	ldd	#INTVAR_O
	ldx	#INTVAR_T
	jsr	ld_id_ix

LINE_79

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_82

	; A=P

	ldd	#INTVAR_A
	ldx	#INTVAR_P
	jsr	ld_id_ix

	; B=D

	ldd	#INTVAR_B
	ldx	#INTVAR_D
	jsr	ld_id_ix

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; FOR P=207 TO 335 STEP K

	ldx	#INTVAR_P
	ldab	#207
	jsr	for_ix_pb

	ldd	#335
	jsr	to_ip_pw

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; SOUND SHIFT(P,-1),1

	ldx	#INTVAR_P
	jsr	hlf_fr1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; D+=1

	ldx	#INTVAR_D
	jsr	inc_ix_ix

	; NEXT

	jsr	next

LINE_83

	; IF (F-1)=E THEN

	ldx	#INTVAR_F
	jsr	dec_ir1_ix

	ldx	#INTVAR_E
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_84
	jsr	jmpeq_ir1_ix

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; P-=C

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	sub_ix_ix_ir1

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; F=E

	ldd	#INTVAR_F
	ldx	#INTVAR_E
	jsr	ld_id_ix

	; PRINT @493, "FLOOR";STR$(F);" ";

	ldd	#493
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "FLOOR"

	ldx	#INTVAR_F
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; GOSUB 99

	ldx	#LINE_99
	jsr	gosub_ix

	; GOTO 50

	ldx	#LINE_50
	jsr	goto_ix

LINE_84

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; SOUND SHIFT(P,-1),1

	ldx	#INTVAR_P
	jsr	hlf_fr1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; D+=1

	ldx	#INTVAR_D
	jsr	inc_ix_ix

	; GOSUB 48

	ldx	#LINE_48
	jsr	gosub_ix

	; P=A

	ldd	#INTVAR_P
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; D=B

	ldd	#INTVAR_D
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_85

	; P=T

	ldd	#INTVAR_P
	ldx	#INTVAR_T
	jsr	ld_id_ix

	; GOTO 82

	ldx	#LINE_82
	jsr	goto_ix

LINE_86

	; X=T

	ldd	#FLTVAR_X
	ldx	#INTVAR_T
	jsr	ld_fd_ix

	; RETURN

	jsr	return

LINE_87

	; IF G THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#LINE_88
	jsr	jmpeq_ir1_ix

	; PRINT @G, M$(H);

	ldx	#INTVAR_G
	jsr	prat_ix

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_M
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+C, N$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_N
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

	; PRINT @G+K, O$(H);

	ldx	#INTVAR_G
	ldd	#INTVAR_K
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#STRARR_O
	jsr	arrval1_ir1_sx

	jsr	pr_sr1

LINE_88

	; Y=(D=2)-(D=0)

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_D
	jsr	ld_ir2_ix

	ldab	#0
	jsr	ldeq_ir2_ir2_pb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; X=(FRACT(P/C)*K)+(Y*3)+2

	ldx	#INTVAR_P
	jsr	ld_ir1_ix

	ldx	#INTVAR_C
	jsr	div_fr1_ir1_ix

	jsr	fract_fr1_fr1

	ldx	#INTVAR_K
	jsr	mul_fr1_fr1_ix

	ldx	#INTVAR_Y
	jsr	mul3_ir2_ix

	jsr	add_fr1_fr1_ir2

	ldab	#2
	jsr	add_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

	; WHEN Y=0 GOTO 30

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#LINE_30
	jsr	jmpeq_ir1_ix

LINE_89

	; T=((Y=1) AND 63)-(Y=-1)

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldab	#63
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#-1
	jsr	ldeq_ir2_ir2_nb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; FOR X=X TO T STEP SHIFT(Y,1)

	ldd	#FLTVAR_X
	ldx	#FLTVAR_X
	jsr	for_fd_fx

	ldx	#INTVAR_T
	jsr	to_fp_ix

	ldx	#INTVAR_Y
	jsr	dbl_ir1_ix

	jsr	step_fp_ir1

	; ON POINT(X,13) GOSUB 1,1,1,1,86,1,1,7

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldab	#13
	jsr	point_ir1_ir1_pb

	jsr	ongosub_ir1_is
	.byte	8
	.word	LINE_1, LINE_1, LINE_1, LINE_1, LINE_86, LINE_1, LINE_1, LINE_7

	; RESET(X,13)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldab	#13
	jsr	reset_ir1_pb

	; NEXT

	jsr	next

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_90

	; P-=3

	ldx	#INTVAR_P
	ldab	#3
	jsr	sub_ix_ix_pb

LINE_91

	; IF P>207 THEN

	ldab	#207
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_92
	jsr	jmpeq_ir1_ix

	; C(F)+=2

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	add_ip_ip_pb

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; C(F)=1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; GOTO 97

	ldx	#LINE_97
	jsr	goto_ix

LINE_92

	; A(F)+=2

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	add_ip_ip_pb

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; A(F)=1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; GOTO 97

	ldx	#LINE_97
	jsr	goto_ix

LINE_93

	; P+=3

	ldx	#INTVAR_P
	ldab	#3
	jsr	add_ix_ix_pb

LINE_94

	; IF P>207 THEN

	ldab	#207
	jsr	ld_ir1_pb

	ldx	#INTVAR_P
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_96
	jsr	jmpeq_ir1_ix

	; C(F)+=2

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	add_ip_ip_pb

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; C(F)=1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; GOTO 97

	ldx	#LINE_97
	jsr	goto_ix

LINE_96

	; A(F)+=2

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	add_ip_ip_pb

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; A(F)=1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; GOTO 97

	ldx	#LINE_97
	jsr	goto_ix

LINE_97

	; S+=1

	ldx	#INTVAR_S
	jsr	inc_ix_ix

	; SC+=1

	ldx	#INTVAR_SC
	jsr	inc_ix_ix

	; GOSUB 120

	ldx	#LINE_120
	jsr	gosub_ix

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

	; IF G=0 THEN

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#LINE_98
	jsr	jmpne_ir1_ix

	; WHEN RND(2)=1 GOSUB 99

	ldab	#2
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_99
	jsr	jsrne_ir1_ix

LINE_98

	; GOTO 30

	ldx	#LINE_30
	jsr	goto_ix

LINE_99

	; G=0

	ldx	#INTVAR_G
	jsr	clr_ix

	; IF RND(2)=1 THEN

	ldab	#2
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_100
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_100

	; IF RND(2)=1 THEN

	ldab	#2
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_101
	jsr	jmpeq_ir1_ix

	; T=RND(2)

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; G=(T*3)+211

	ldx	#INTVAR_T
	jsr	mul3_ir1_ix

	ldab	#211
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

	; I=(T*6)+40

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#6
	jsr	mul_ir1_ir1_pb

	ldab	#40
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_I
	jsr	ld_ix_ir1

	; L=I

	ldd	#INTVAR_L
	ldx	#INTVAR_I
	jsr	ld_id_ix

	; H=6

	ldx	#INTVAR_H
	ldab	#6
	jsr	ld_ix_pb

	; GOTO 110

	ldx	#LINE_110
	jsr	goto_ix

LINE_101

	; T=RND(2)

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; G=(T*3)+194

	ldx	#INTVAR_T
	jsr	mul3_ir1_ix

	ldab	#194
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

	; I=(T*6)+6

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#6
	jsr	mul_ir1_ir1_pb

	ldab	#6
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_I
	jsr	ld_ix_ir1

	; L=I

	ldd	#INTVAR_L
	ldx	#INTVAR_I
	jsr	ld_id_ix

	; H=4

	ldx	#INTVAR_H
	ldab	#4
	jsr	ld_ix_pb

	; GOTO 110

	ldx	#LINE_110
	jsr	goto_ix

LINE_110

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; Z=0

	ldx	#INTVAR_Z
	jsr	clr_ix

	; WHEN PEEK(G+M+1)=159 GOTO 100

	ldx	#INTVAR_G
	ldd	#FLTVAR_M
	jsr	add_fr1_ix_fd

	jsr	inc_fr1_fr1

	jsr	peek_ir1_ir1

	ldab	#159
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_100
	jsr	jmpne_ir1_ix

LINE_111

	; RETURN

	jsr	return

LINE_120

	; PRINT @480, "SCORE";STR$(SC);" ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "SCORE"

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; IF SC>NL THEN

	ldx	#INTVAR_NL
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_121
	jsr	jmpeq_ir1_ix

	; NL+=50

	ldx	#INTVAR_NL
	ldab	#50
	jsr	add_ix_ix_pb

	; N+=N>0

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_N
	jsr	ldlt_ir1_ir1_ix

	ldx	#INTVAR_N
	jsr	add_ix_ix_ir1

	; POKE M+511,53-N

	ldx	#FLTVAR_M
	ldd	#511
	jsr	add_fr1_fx_pw

	ldab	#53
	ldx	#INTVAR_N
	jsr	sub_ir2_pb_ix

	jsr	poke_ir1_ir2

LINE_121

	; RETURN

	jsr	return

LINE_200

	; PRINT @480, "SCORE";STR$(SC);"            ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "SCORE"

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	12, "            "

	; PRINT @494, "PLAY AGAIN (Y/N)?";

	ldd	#494
	jsr	prat_pw

	jsr	pr_ss
	.text	17, "PLAY AGAIN (Y/N)?"

	; POKE M+511,96

	ldx	#FLTVAR_M
	ldd	#511
	jsr	add_fr1_fx_pw

	ldab	#96
	jsr	poke_ir1_pb

LINE_210

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 210

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_210
	jsr	jmpne_ir1_ix

LINE_220

	; WHEN M$="Y" GOTO 1070

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_1070
	jsr	jmpne_ir1_ix

LINE_230

	; IF M$="N" THEN

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_240
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_240

	; GOTO 210

	ldx	#LINE_210
	jsr	goto_ix

LINE_250

	; P=367

	ldx	#INTVAR_P
	ldd	#367
	jsr	ld_ix_pw

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; E=1

	ldx	#INTVAR_E
	jsr	one_ix

	; B(E+1)=1

	ldx	#INTVAR_E
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; B(E)=2

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; B(E-1)=0

	ldx	#INTVAR_E
	jsr	dec_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	clr_ip

	; PRINT @493, "FLOOR";STR$(F+1);" ";

	ldd	#493
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "FLOOR"

	ldx	#INTVAR_F
	jsr	inc_ir1_ix

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

LINE_280

	; PRINT @480, "MISSION COMPLETE. 100 PT BONUS.";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	31, "MISSION COMPLETE. 100 PT BONUS."

	; POKE M+511,96

	ldx	#FLTVAR_M
	ldd	#511
	jsr	add_fr1_fx_pw

	ldab	#96
	jsr	poke_ir1_pb

	; SC+=100

	ldx	#INTVAR_SC
	ldab	#100
	jsr	add_ix_ix_pb

	; NL=SC+50

	ldx	#INTVAR_SC
	ldab	#50
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_NL
	jsr	ld_ix_ir1

LINE_281

	; GOSUB 5000

	ldx	#LINE_5000
	jsr	gosub_ix

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; FOR T=1 TO 1500

	ldx	#INTVAR_T
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; GOSUB 1080

	ldx	#LINE_1080
	jsr	gosub_ix

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_1000

	; DIM A(31)

	ldab	#31
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrdim1_ir1_ix

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

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; DIM B(31),C(31),K(255),T,E,F,D,I,J,X,Y,X,Y,P,H,M,W,M,N,L,R,G

	ldab	#31
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrdim1_ir1_ix

	ldab	#31
	jsr	ld_ir1_pb

	ldx	#INTARR_C
	jsr	arrdim1_ir1_ix

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrdim1_ir1_ix

LINE_1001

	; M=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_M
	jsr	ld_fx_fr1

	; M=16384

	ldx	#FLTVAR_M
	ldd	#16384
	jsr	ld_fx_pw

	; R=17023

	ldx	#INTVAR_R
	ldd	#17023
	jsr	ld_ix_pw

LINE_1002

	; V$="ÄÄÄÄœﬂﬂﬂﬂﬂﬂﬂﬂﬂ"

	jsr	ld_sr1_ss
	.text	14, "\x80\x80\x80\x80\xCF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF"

	ldx	#STRVAR_V
	jsr	ld_sx_sr1

	; W$="ﬂﬂﬂﬂﬂﬂﬂﬂﬂœÄÄÄÄÄÄÄœ"

	jsr	ld_sr1_ss
	.text	18, "\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xDF\xCF\x80\x80\x80\x80\x80\x80\x80\xCF"

	ldx	#STRVAR_W
	jsr	ld_sx_sr1

	; X$="œÄÄÄÄÄÄÄœ"

	jsr	ld_sr1_ss
	.text	9, "\xCF\x80\x80\x80\x80\x80\x80\x80\xCF"

	ldx	#STRVAR_X
	jsr	ld_sx_sr1

	; Y$="œÄÄÄÄÄÄÄœœœœœœœœœœ"

	jsr	ld_sr1_ss
	.text	18, "\xCF\x80\x80\x80\x80\x80\x80\x80\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF"

	ldx	#STRVAR_Y
	jsr	ld_sx_sr1

	; Z$="œœœœœœœœœœÄÄÄ"

	jsr	ld_sr1_ss
	.text	13, "\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\x80\x80\x80"

	ldx	#STRVAR_Z
	jsr	ld_sx_sr1

LINE_1003

	; DIM B$(7),C$(7),D$(7),F$(2),G$(2),H$(2),I$(2),J$(2),M$(7),N$(7),O$(7),V,Q,U,O,Z,S,J(8),C,K,A,B,SC,HS,NL

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrdim1_ir1_sx

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_F
	jsr	arrdim1_ir1_sx

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_G
	jsr	arrdim1_ir1_sx

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_H
	jsr	arrdim1_ir1_sx

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_I
	jsr	arrdim1_ir1_sx

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_J
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_M
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrdim1_ir1_sx

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrdim1_ir1_sx

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrdim1_ir1_ix

LINE_1004

	; C=32

	ldx	#INTVAR_C
	ldab	#32
	jsr	ld_ix_pb

	; K=64

	ldx	#INTVAR_K
	ldab	#64
	jsr	ld_ix_pb

LINE_1011

	; B$(1)="ﬂØØØﬂØØØﬂ"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAF\xAF\xAF\xDF\xAF\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; B$(2)="ﬂøøøﬂØØØﬂ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xBF\xBF\xBF\xDF\xAF\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; B$(3)="ﬂØØØﬂøøøﬂ"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAF\xAF\xAF\xDF\xBF\xBF\xBF\xDF"

	jsr	ld_sp_sr1

	; B$(4)="ﬂ–––ﬂØØØﬂ"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0\xDF\xAF\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; B$(5)="ﬂØØØﬂ–––ﬂ"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAF\xAF\xAF\xDF\xD0\xD0\xD0\xDF"

	jsr	ld_sp_sr1

LINE_1012

	; C$(1)="ﬂÆØØﬂÆØØﬂ"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAE\xAF\xAF\xDF\xAE\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; C$(2)="ﬂæøøﬂÆØØﬂ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xBE\xBF\xBF\xDF\xAE\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; C$(3)="ﬂÆØØﬂæøøﬂ"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAE\xAF\xAF\xDF\xBE\xBF\xBF\xDF"

	jsr	ld_sp_sr1

	; C$(4)="ﬂ–––ﬂÆØØﬂ"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0\xDF\xAE\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; C$(5)="ﬂÆØØﬂ–––ﬂ"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAE\xAF\xAF\xDF\xD0\xD0\xD0\xDF"

	jsr	ld_sp_sr1

LINE_1013

	; D$(1)="ﬂØØØﬂØØØﬂ"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAF\xAF\xAF\xDF\xAF\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; D$(2)="ﬂøøøﬂØØØﬂ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xBF\xBF\xBF\xDF\xAF\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; D$(3)="ﬂØØØﬂøøøﬂ"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAF\xAF\xAF\xDF\xBF\xBF\xBF\xDF"

	jsr	ld_sp_sr1

	; D$(4)="ﬂ–––ﬂØØØﬂ"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0\xDF\xAF\xAF\xAF\xDF"

	jsr	ld_sp_sr1

	; D$(5)="ﬂØØØﬂ–––ﬂ"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xAF\xAF\xAF\xDF\xD0\xD0\xD0\xDF"

	jsr	ld_sp_sr1

LINE_1014

	; B$(6)="ﬂ–––roofﬂ"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0roof\xDF"

	jsr	ld_sp_sr1

	; B$(7)="ﬂ–––exitﬂ"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0exit\xDF"

	jsr	ld_sp_sr1

LINE_1015

	; C$(6)="ﬂ––œﬂﬂﬂﬂﬂ"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xCF\xDF\xDF\xDF\xDF\xDF"

	jsr	ld_sp_sr1

	; C$(7)="ﬂ–––ﬂﬂﬂﬂﬂ"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_C
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0\xDF\xDF\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_1016

	; D$(6)="ﬂ–œœﬂﬂﬂﬂﬂ"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xCF\xCF\xDF\xDF\xDF\xDF\xDF"

	jsr	ld_sp_sr1

	; D$(7)="ﬂ–––ﬂﬂﬂﬂﬂ"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	9, "\xDF\xD0\xD0\xD0\xDF\xDF\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_1020

	; F$(0)="–––––"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_F
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xD0\xD0\xD0\xD0"

	jsr	ld_sp_sr1

	; F$(1)="–Â–Í–"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_F
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xE5\xD0\xEA\xD0"

	jsr	ld_sp_sr1

	; F$(2)="ÔﬂﬂﬂÔ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_F
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xEF\xDF\xDF\xDF\xEF"

	jsr	ld_sp_sr1

LINE_1021

	; G$(0)="–––––"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_G
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xD0\xD0\xD0\xD0"

	jsr	ld_sp_sr1

	; G$(1)="–Â–Í–"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_G
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xE5\xD0\xEA\xD0"

	jsr	ld_sp_sr1

	; G$(2)="ÔﬂÔﬂÔ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_G
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xEF\xDF\xEF\xDF\xEF"

	jsr	ld_sp_sr1

LINE_1022

	; H$(0)="–––––"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_H
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xD0\xD0\xD0\xD0"

	jsr	ld_sp_sr1

	; H$(1)="–Â–Í–"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_H
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xE5\xD0\xEA\xD0"

	jsr	ld_sp_sr1

	; H$(2)="ÔﬂﬂﬂÔ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_H
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xEF\xDF\xDF\xDF\xEF"

	jsr	ld_sp_sr1

LINE_1023

	; I$(0)="–––––"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_I
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xD0\xD0\xD0\xD0"

	jsr	ld_sp_sr1

	; I$(1)="–Â–Í–"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_I
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xE5\xD0\xEA\xD0"

	jsr	ld_sp_sr1

	; I$(2)="ÔﬂﬂﬂÔ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_I
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xEF\xDF\xDF\xDF\xEF"

	jsr	ld_sp_sr1

LINE_1024

	; J$(0)="–––––"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_J
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xD0\xD0\xD0\xD0"

	jsr	ld_sp_sr1

	; J$(1)="–Â–Í–"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_J
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xD0\xE5\xD0\xEA\xD0"

	jsr	ld_sp_sr1

	; J$(2)="ÏÏÏÏÏ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_J
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	5, "\xEC\xEC\xEC\xEC\xEC"

	jsr	ld_sp_sr1

LINE_1030

	; M$(0)="ﬂüﬂ"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_M
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\x9F\xDF"

	jsr	ld_sp_sr1

LINE_1031

	; N$(0)="ﬂ‘—"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xD4\xD1"

	jsr	ld_sp_sr1

	; N$(1)="ﬂﬂﬂ"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_1032

	; O$(0)="ﬁ÷ﬂ"

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDE\xD6\xDF"

	jsr	ld_sp_sr1

	; O$(1)="ÿ“ù"

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xD8\xD2\x9D"

	jsr	ld_sp_sr1

LINE_1033

	; M$(2)="ﬂüﬂ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_M
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\x9F\xDF"

	jsr	ld_sp_sr1

LINE_1034

	; N$(2)="“ÿﬂ"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xD2\xD8\xDF"

	jsr	ld_sp_sr1

	; N$(3)="ﬂﬂﬂ"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_1035

	; O$(2)="ﬂŸ›"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xD9\xDD"

	jsr	ld_sp_sr1

	; O$(3)="û—‘"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\x9E\xD1\xD4"

	jsr	ld_sp_sr1

LINE_1040

	; M$(4)="ﬂˇﬂ"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_M
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xFF\xDF"

	jsr	ld_sp_sr1

LINE_1041

	; N$(4)="“ÿﬂ"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xD2\xD8\xDF"

	jsr	ld_sp_sr1

	; N$(5)="ﬂﬂﬂ"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_1042

	; O$(4)="ﬂŸ›"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xD9\xDD"

	jsr	ld_sp_sr1

	; O$(5)="ÿ“˝"

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xD8\xD2\xFD"

	jsr	ld_sp_sr1

LINE_1043

	; M$(6)="ﬂˇﬂ"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_M
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xFF\xDF"

	jsr	ld_sp_sr1

LINE_1044

	; N$(6)="ﬂ‘—"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xD4\xD1"

	jsr	ld_sp_sr1

	; N$(7)="ﬂﬂﬂ"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_N
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDF\xDF\xDF"

	jsr	ld_sp_sr1

LINE_1045

	; O$(6)="ﬁ÷ﬂ"

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xDE\xD6\xDF"

	jsr	ld_sp_sr1

	; O$(7)="˛—‘"

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#STRARR_O
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	3, "\xFE\xD1\xD4"

	jsr	ld_sp_sr1

LINE_1050

	; J(0)=194

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#194
	jsr	ld_ip_pb

	; J(1)=197

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#197
	jsr	ld_ip_pb

	; J(2)=200

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#200
	jsr	ld_ip_pb

	; J(3)=203

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#203
	jsr	ld_ip_pb

	; J(4)=207

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#207
	jsr	ld_ip_pb

	; J(5)=211

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#211
	jsr	ld_ip_pb

	; J(6)=214

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#214
	jsr	ld_ip_pb

	; J(7)=217

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#217
	jsr	ld_ip_pb

	; J(8)=220

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#INTARR_J
	jsr	arrref1_ir1_ix

	ldab	#220
	jsr	ld_ip_pb

LINE_1060

	; K(65)=1

	ldab	#65
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(83)=2

	ldab	#83
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; K(87)=3

	ldab	#87
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(90)=4

	ldab	#90
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

	; K(74)=1

	ldab	#74
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(76)=2

	ldab	#76
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; K(73)=3

	ldab	#73
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(75)=4

	ldab	#75
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

LINE_1061

	; K(128)=1

	ldab	#128
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(207)=1

	ldab	#207
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(239)=2

	ldab	#239
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; K(191)=3

	ldab	#191
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(208)=4

	ldab	#208
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; K(229)=4

	ldab	#229
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; K(234)=4

	ldab	#234
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

LINE_1065

	; GOSUB 3150

	ldx	#LINE_3150
	jsr	gosub_ix

LINE_1070

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; Q=18

	ldx	#INTVAR_Q
	ldab	#18
	jsr	ld_ix_pb

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; SC=0

	ldx	#INTVAR_SC
	jsr	clr_ix

	; Q=18-A(0)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldab	#18
	jsr	rsub_ir1_ir1_pb

	ldx	#INTVAR_Q
	jsr	ld_ix_ir1

	; Z=0

	ldx	#INTVAR_Z
	jsr	clr_ix

	; N=0

	ldx	#INTVAR_N
	jsr	clr_ix

	; NL=50

	ldx	#INTVAR_NL
	ldab	#50
	jsr	ld_ix_pb

	; GOSUB 1080

	ldx	#LINE_1080
	jsr	gosub_ix

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; PRINT Z$;

	ldx	#STRVAR_Z
	jsr	pr_sx

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_1080

	; GOSUB 2100

	ldx	#LINE_2100
	jsr	gosub_ix

	; U=0

	ldx	#INTVAR_U
	jsr	clr_ix

	; FOR T=2 TO 29

	ldx	#INTVAR_T
	ldab	#2
	jsr	for_ix_pb

	ldab	#29
	jsr	to_ip_pb

	; E=RND(3)

	ldab	#3
	jsr	irnd_ir1_pb

	ldx	#INTVAR_E
	jsr	ld_ix_ir1

	; A(T)=E

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; IF E>1 THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_E
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_1081
	jsr	jmpeq_ir1_ix

	; U+=1

	ldx	#INTVAR_U
	jsr	inc_ix_ix

LINE_1081

	; E=RND(3)

	ldab	#3
	jsr	irnd_ir1_pb

	ldx	#INTVAR_E
	jsr	ld_ix_ir1

	; C(T)=E

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; IF E>1 THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_E
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_1082
	jsr	jmpeq_ir1_ix

	; U+=1

	ldx	#INTVAR_U
	jsr	inc_ix_ix

LINE_1082

	; B(T)=0

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	clr_ip

	; NEXT

	jsr	next

LINE_1083

	; A(30)=6

	ldab	#30
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	ldab	#6
	jsr	ld_ip_pb

	; C(30)=6

	ldab	#30
	jsr	ld_ir1_pb

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#6
	jsr	ld_ip_pb

	; A(1)=7

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	ldab	#7
	jsr	ld_ip_pb

	; C(1)=7

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_C
	jsr	arrref1_ir1_ix

	ldab	#7
	jsr	ld_ip_pb

LINE_1084

	; F=29

	ldx	#INTVAR_F
	ldab	#29
	jsr	ld_ix_pb

	; E=29

	ldx	#INTVAR_E
	ldab	#29
	jsr	ld_ix_pb

	; B(E+1)=1

	ldx	#INTVAR_E
	jsr	inc_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; B(E)=2

	ldx	#INTVAR_E
	jsr	ld_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; B(E-1)=0

	ldx	#INTVAR_E
	jsr	dec_ir1_ix

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix

	jsr	clr_ip

	; P=211

	ldx	#INTVAR_P
	ldab	#211
	jsr	ld_ix_pb

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; Z=0

	ldx	#INTVAR_Z
	jsr	clr_ix

	; Q-=2

	ldx	#INTVAR_Q
	ldab	#2
	jsr	sub_ix_ix_pb

	; IF Q<2 THEN

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_1087
	jsr	jmpeq_ir1_ix

	; Q=2

	ldx	#INTVAR_Q
	ldab	#2
	jsr	ld_ix_pb

LINE_1087

	; GOSUB 99

	ldx	#LINE_99
	jsr	gosub_ix

	; POKE M+511,117-N

	ldx	#FLTVAR_M
	ldd	#511
	jsr	add_fr1_fx_pw

	ldab	#117
	ldx	#INTVAR_N
	jsr	sub_ir2_pb_ix

	jsr	poke_ir1_ir2

LINE_1090

	; RETURN

	jsr	return

LINE_2000

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; PRINT @76, "elevator";

	ldab	#76
	jsr	prat_pb

	jsr	pr_ss
	.text	8, "elevator"

	; PRINT @141, "action";

	ldab	#141
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "action"

	; PRINT @256,

	ldd	#256
	jsr	prat_pw

LINE_2010

	; PRINT "–––––––––––––œœœœœœœ––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

LINE_2020

	; PRINT "–––––––––––––œ–––––œ––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

LINE_2030

	; PRINT "–––––––––––––œ–––––Ø––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xAF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

LINE_2040

	; PRINT "–––––––––––––œ–––––Ø––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xAF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

LINE_2050

	; PRINT "–––––––––––––œ–––––Ø––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xAF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

	; WHEN Q<10 GOSUB 4000

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldab	#10
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_4000
	jsr	jsrne_ir1_ix

LINE_2060

	; PRINT "––––œœœœœœœœœœ–––––œœœœœœœœœœ–––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0"

LINE_2070

	; PRINT "––––œœœœœœœœœœ––––œœœœœœœœœœœ–––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0"

LINE_2080

	; PRINT "––––œœœœœœœœœœ–––œœœœœœœœœœœœ–––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xD0\xD0\xD0"

	; IF SC>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_2090
	jsr	jmpeq_ir1_ix

	; HS=SC

	ldd	#INTVAR_HS
	ldx	#INTVAR_SC
	jsr	ld_id_ix

LINE_2090

	; RETURN

	jsr	return

LINE_2100

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

	; FOR X=55 TO 40 STEP -1

	ldx	#FLTVAR_X
	ldab	#55
	jsr	for_fx_pb

	ldab	#40
	jsr	to_fp_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_fp_ir1

	; SET(X,Y,8)

	ldx	#FLTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; Y+=1

	ldx	#INTVAR_Y
	jsr	inc_ix_ix

	; NEXT

	jsr	next

	; PRINT @490, "BY JIM GERRIE";

	ldd	#490
	jsr	prat_pw

	jsr	pr_ss
	.text	13, "BY JIM GERRIE"

	; FOR T=1 TO 1500

	ldx	#INTVAR_T
	jsr	forone_ix

	ldd	#1500
	jsr	to_ip_pw

	; NEXT

	jsr	next

LINE_2120

	; PRINT @490, "HIGH SCORE:";STR$(HS);"   ";

	ldd	#490
	jsr	prat_pw

	jsr	pr_ss
	.text	11, "HIGH SCORE:"

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	3, "   "

LINE_2200

	; D=2

	ldx	#INTVAR_D
	ldab	#2
	jsr	ld_ix_pb

	; FOR P=59 TO 276 STEP 31

	ldx	#INTVAR_P
	ldab	#59
	jsr	for_ix_pb

	ldd	#276
	jsr	to_ip_pw

	ldab	#31
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; SOUND SHIFT(P,-1),2

	ldx	#INTVAR_P
	jsr	hlf_fr1_ix

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @P, "–––";

	ldx	#INTVAR_P
	jsr	prat_ix

	jsr	pr_ss
	.text	3, "\xD0\xD0\xD0"

	; PRINT @P+32, "–––";

	ldx	#INTVAR_P
	ldab	#32
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\xD0\xD0\xD0"

	; PRINT @P+64, "–––";

	ldx	#INTVAR_P
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "\xD0\xD0\xD0"

	; NEXT

	jsr	next

LINE_2210

	; GOSUB 47

	ldx	#LINE_47
	jsr	gosub_ix

	; SOUND SHIFT(P,-1),2

	ldx	#INTVAR_P
	jsr	hlf_fr1_ix

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 200,2

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR T=1 TO 2500

	ldx	#INTVAR_T
	jsr	forone_ix

	ldd	#2500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; PRINT @480, "SCORE        FLOOR 29    LIVES";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "SCORE        FLOOR 29    LIVES"

	; PRINT @493, "FLOOR 29";

	ldd	#493
	jsr	prat_pw

	jsr	pr_ss
	.text	8, "FLOOR 29"

	; RETURN

	jsr	return

LINE_3000

	; CLS 6

	ldab	#6
	jsr	clsn_pb

	; PRINT @8, "elevatorﬂaction";

	ldab	#8
	jsr	prat_pb

	jsr	pr_ss
	.text	15, "elevator\xDFaction"

	; PRINT @45, "⁄";

	ldab	#45
	jsr	prat_pb

	jsr	pr_ss
	.text	1, "\xDA"

	; PRINT @51, "’";

	ldab	#51
	jsr	prat_pb

	jsr	pr_ss
	.text	1, "\xD5"

	; PRINT @64,

	ldab	#64
	jsr	prat_pb

LINE_3005

	; PRINT "ﬂﬂﬂﬂﬂﬂUSE: awsz OR jikl TOﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFUSE: awsz OR jikl TO\xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3010

	; PRINT "ﬂﬂﬂﬂﬂﬂMOVE & space TO FIREﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFMOVE & space TO FIRE\xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3020

	; PRINT "ﬂﬂﬂﬂﬂﬂDOWN= CROUCH-- HIT  ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFDOWN= CROUCH-- HIT  \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3030

	; PRINT "ﬂﬂﬂﬂﬂﬂAGAIN TO CHANGE DIR.ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFAGAIN TO CHANGE DIR.\xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3040

	; PRINT "ﬂﬂﬂﬂﬂﬂUP=STAND UP OR JUMP.ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFUP=STAND UP OR JUMP.\xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3060

	; PRINT "ﬂﬂﬂﬂﬂﬂNEW LIFE EVERY 50   ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFNEW LIFE EVERY 50   \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3070

	; PRINT "ﬂﬂﬂﬂﬂﬂPOINTS. 10 PTS FOR  ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFPOINTS. 10 PTS FOR  \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3080

	; PRINT "ﬂﬂﬂﬂﬂﬂEVERY AGENT KILLED. ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFEVERY AGENT KILLED. \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3090

	; PRINT "ﬂﬂﬂﬂﬂﬂOPEN ALL RED DOORS, ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFOPEN ALL RED DOORS, \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3100

	; PRINT "ﬂﬂﬂﬂﬂﬂTHEN DESCEND TO 1ST ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFTHEN DESCEND TO 1ST \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3110

	; PRINT "ﬂﬂﬂﬂﬂﬂFLOOR FOR BONUS AND ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFFLOOR FOR BONUS AND \xDF\xDF\xDF\xDF\xDF\xDF"

LINE_3130

	; PRINT "ﬂﬂﬂﬂﬂﬂYOUR NEXT MISSION...ﬂﬂﬂﬂﬂﬂ";

	jsr	pr_ss
	.text	32, "\xDF\xDF\xDF\xDF\xDF\xDFYOUR NEXT MISSION...\xDF\xDF\xDF\xDF\xDF\xDF"

	; RETURN

	jsr	return

LINE_3150

	; PRINT @486, "levelﬂofﬂplay";

	ldd	#486
	jsr	prat_pw

	jsr	pr_ss
	.text	13, "level\xDFof\xDFplay"

	; POKE 16884,40

	ldab	#40
	jsr	ld_ir1_pb

	ldd	#16884
	jsr	poke_pw_ir1

	; POKE 16885,49

	ldab	#49
	jsr	ld_ir1_pb

	ldd	#16885
	jsr	poke_pw_ir1

	; POKE 16886,45

	ldab	#45
	jsr	ld_ir1_pb

	ldd	#16886
	jsr	poke_pw_ir1

	; POKE 16887,51

	ldab	#51
	jsr	ld_ir1_pb

	ldd	#16887
	jsr	poke_pw_ir1

	; POKE 16888,41

	ldab	#41
	jsr	ld_ir1_pb

	ldd	#16888
	jsr	poke_pw_ir1

	; POKE 16889,63

	ldab	#63
	jsr	ld_ir1_pb

	ldd	#16889
	jsr	poke_pw_ir1

LINE_3160

	; A(0)=VAL(INKEY$)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	jsr	inkey_sr1

	jsr	val_fr1_sr1

	jsr	ld_ip_ir1

	; WHEN (A(0)<1) OR (A(0)>4) GOTO 3160

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	ldab	#1
	jsr	ldlt_ir1_ir1_pb

	ldab	#4
	jsr	ld_ir2_pb

	ldab	#0
	jsr	ld_ir3_pb

	ldx	#INTARR_A
	jsr	arrval1_ir3_ix

	jsr	ldlt_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_3160
	jsr	jmpne_ir1_ix

LINE_3170

	; A(0)=SHIFT(A(0),1)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix

	jsr	dbl_ir1_ir1

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_4000

	; PRINT @320,

	ldd	#320
	jsr	prat_pw

LINE_4030

	; PRINT "––––––HERON––œ–––––Ø––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0HERON\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xAF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

LINE_4040

	; PRINT "––––––POINT––œ–––––Ø––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0POINT\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xAF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

LINE_4050

	; PRINT "–––––––ä–Ö–––œ–––––Ø––––––––––––";

	jsr	pr_ss
	.text	32, "\xD0\xD0\xD0\xD0\xD0\xD0\xD0\x8A\xD0\x85\xD0\xD0\xD0\xCF\xD0\xD0\xD0\xD0\xD0\xAF\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0\xD0"

	; RETURN

	jsr	return

LINE_5000

	; SOUND 64,3

	ldab	#64
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5011

	; SOUND 64,3

	ldab	#64
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR T=1 TO 150

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#150
	jsr	to_ip_pb

	; NEXT

	jsr	next

LINE_5012

	; SOUND 103,6

	ldab	#103
	jsr	ld_ir1_pb

	ldab	#6
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5013

	; SOUND 129,6

	ldab	#129
	jsr	ld_ir1_pb

	ldab	#6
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5014

	; SOUND 142,3

	ldab	#142
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5015

	; SOUND 149,3

	ldab	#149
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5016

	; SOUND 142,3

	ldab	#142
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5017

	; SOUND 129,3

	ldab	#129
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5018

	; SOUND 122,3

	ldab	#122
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5019

	; SOUND 129,10

	ldab	#129
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR T=1 TO 150

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#150
	jsr	to_ip_pb

	; NEXT

	jsr	next

LINE_5020

	; SOUND 64,3

	ldab	#64
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5021

	; SOUND 64,3

	ldab	#64
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR T=1 TO 150

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#150
	jsr	to_ip_pb

	; NEXT

	jsr	next

LINE_5022

	; SOUND 103,6

	ldab	#103
	jsr	ld_ir1_pb

	ldab	#6
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5023

	; SOUND 129,6

	ldab	#129
	jsr	ld_ir1_pb

	ldab	#6
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5024

	; SOUND 142,3

	ldab	#142
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5025

	; SOUND 149,3

	ldab	#149
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5026

	; SOUND 142,3

	ldab	#142
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5027

	; SOUND 129,3

	ldab	#129
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5028

	; SOUND 103,3

	ldab	#103
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_5029

	; SOUND 64,10

	ldab	#64
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

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

abs_ir1_ir1			; numCalls = 1
	.module	modabs_ir1_ir1
	ldaa	r1
	bpl	_rts
	ldx	#r1
	jmp	negxi
_rts
	rts

add_fr1_fr1_ir2			; numCalls = 1
	.module	modadd_fr1_fr1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 2
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_fx_pw			; numCalls = 5
	.module	modadd_fr1_fx_pw
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	ldd	3,x
	std	r1+3
	rts

add_fr1_ir1_fx			; numCalls = 2
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

add_fr1_ix_fd			; numCalls = 4
	.module	modadd_fr1_ix_fd
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
	ldd	3,x
	std	r1+3
	rts

add_ip_ip_pb			; numCalls = 4
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

add_ir1_ir1_ix			; numCalls = 4
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
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

add_ir1_ix_id			; numCalls = 21
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

add_ir1_ix_pb			; numCalls = 4
	.module	modadd_ir1_ix_pb
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
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

add_ix_ix_ir1			; numCalls = 5
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

and_ir1_ir1_pb			; numCalls = 3
	.module	modand_ir1_ir1_pb
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

and_ir2_ir2_nb			; numCalls = 3
	.module	modand_ir2_ir2_nb
	andb	r2+2
	stab	r2+2
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

arrdim1_ir1_sx			; numCalls = 11
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

arrref1_ir1_ix			; numCalls = 57
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx			; numCalls = 56
	.module	modarrref1_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 36
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

arrval1_ir1_sx			; numCalls = 65
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

clr_ip			; numCalls = 6
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 23
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

clsn_pb			; numCalls = 3
	.module	modclsn_pb
	jmp	R_CLSN

dbl_ir1_ir1			; numCalls = 1
	.module	moddbl_ir1_ir1
	ldx	#r1
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dbl_ir1_ix			; numCalls = 6
	.module	moddbl_ir1_ix
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dec_ir1_ix			; numCalls = 9
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
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

div_fr1_ir1_ix			; numCalls = 1
	.module	moddiv_fr1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	#0
	std	3+argv
	std	r1+3
	ldx	#r1
	jmp	divflt

for_fd_fx			; numCalls = 1
	.module	modfor_fd_fx
	std	letptr
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	ldd	3,x
	ldx	letptr
	std	3,x
	ldd	tmp2
	std	1,x
	ldab	tmp1+1
	stab	0,x
	rts

for_fx_pb			; numCalls = 1
	.module	modfor_fx_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
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

for_ix_pb			; numCalls = 3
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

forone_ix			; numCalls = 7
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

fract_fr1_fr1			; numCalls = 1
	.module	modfract_fr1_fr1
	ldd	#0
	stab	r1
	std	r1+1
	rts

gosub_ix			; numCalls = 43
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 36
	.module	modgoto_ix
	ins
	ins
	jmp	,x

hlf_fr1_ix			; numCalls = 4
	.module	modhlf_fr1_ix
	ldab	0,x
	asrb
	stab	r1
	ldd	1,x
	rora
	rorb
	std	r1+1
	ldd	#0
	rora
	std	r1+3
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

inc_ir1_ix			; numCalls = 9
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ix_ix			; numCalls = 13
	.module	modinc_ix_ix
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sr1			; numCalls = 1
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

jmpeq_ir1_ix			; numCalls = 31
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

jmpne_ir1_ix			; numCalls = 10
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

ld_fd_ix			; numCalls = 2
	.module	modld_fd_ix
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	ldd	#0
	std	3,x
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

ld_fx_pw			; numCalls = 1
	.module	modld_fx_pw
	std	1,x
	ldd	#0
	std	3,x
	stab	0,x
	rts

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

ld_ip_ir1			; numCalls = 4
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 30
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 125
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

ld_ir1_pb			; numCalls = 152
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 7
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 36
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_pb			; numCalls = 1
	.module	modld_ir3_pb
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ix_ir1			; numCalls = 32
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 16
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

ld_sp_sr1			; numCalls = 56
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 61
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

ldeq_ir1_fr1_pb			; numCalls = 1
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

ldeq_ir1_ir1_ix			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 14
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

ldeq_ir2_ir2_nb			; numCalls = 1
	.module	modldeq_ir2_ir2_nb
	cmpb	r2+2
	bne	_done
	ldd	r2
	subd	#-1
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_pb			; numCalls = 5
	.module	modldeq_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
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

ldlt_ir1_ir1_ix			; numCalls = 7
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
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

ldlt_ir2_ir2_ir3			; numCalls = 1
	.module	modldlt_ir2_ir2_ir3
	ldd	r2+1
	subd	r3+1
	ldab	r2
	sbcb	r3
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

ldne_ir1_ir1_pb			; numCalls = 3
	.module	modldne_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

mul3_ir1_ix			; numCalls = 2
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

mul3_ir2_ix			; numCalls = 1
	.module	modmul3_ir2_ix
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	lsld
	rol	tmp1+1
	addd	1,x
	std	r2+1
	ldab	0,x
	adcb	tmp1+1
	stab	r2
	rts

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

mul_ir1_ir1_pb			; numCalls = 2
	.module	modmul_ir1_ir1_pb
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

neg_ir1_ir1			; numCalls = 2
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

next			; numCalls = 18
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

one_ip			; numCalls = 13
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 4
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongosub_ir1_is			; numCalls = 3
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

ongoto_ir1_is			; numCalls = 5
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

peek_ir1_ir1			; numCalls = 6
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pb			; numCalls = 2
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_ix			; numCalls = 2
	.module	modpeek_ir2_ix
	ldx	1,x
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

point_ir1_ir1_pb			; numCalls = 2
	.module	modpoint_ir1_ir1_pb
	tba
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

poke_ir1_ir2			; numCalls = 3
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 2
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_pw_ir1			; numCalls = 8
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 72
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 51
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 24
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 16
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 8
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

reset_ir1_pb			; numCalls = 2
	.module	modreset_ir1_pb
	tba
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

return			; numCalls = 19
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

rsub_ir1_ir1_pb			; numCalls = 2
	.module	modrsub_ir1_ir1_pb
	clra
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

setc_ir1_ir2_pb			; numCalls = 3
	.module	modsetc_ir1_ir2_pb
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

sgn_ir1_ir1			; numCalls = 1
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

sound_ir1_ir2			; numCalls = 32
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_fp_ir1			; numCalls = 2
	.module	modstep_fp_ir1
	tsx
	ldab	r1
	stab	12,x
	ldd	r1+1
	std	13,x
	ldd	#0
	std	15,x
	ldd	,x
	std	5,x
	rts

step_ip_ir1			; numCalls = 4
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

str_sr1_ir1			; numCalls = 1
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

str_sr1_ix			; numCalls = 6
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

sub_fr1_fr1_ix			; numCalls = 1
	.module	modsub_fr1_fr1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_fr1_fr1_pb			; numCalls = 1
	.module	modsub_fr1_fr1_pb
	stab	tmp1
	ldd	r1+1
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

sub_ir1_ir1_ir2			; numCalls = 6
	.module	modsub_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
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

sub_ir1_ix_id			; numCalls = 1
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

sub_ir2_pb_ix			; numCalls = 3
	.module	modsub_ir2_pb_ix
	subb	2,x
	stab	r2+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r2
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

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
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

to_ip_pw			; numCalls = 5
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

true_ix			; numCalls = 1
	.module	modtrue_ix
	ldd	#-1
	stab	0,x
	std	1,x
	rts

val_fr1_sr1			; numCalls = 1
	.module	modval_fr1_sr1
	ldx	#r1
	jsr	strval
	ldx	r1+1
	jsr	strrel
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
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_HS	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_N	.block	3
INTVAR_NL	.block	3
INTVAR_O	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_W	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
FLTVAR_M	.block	5
FLTVAR_X	.block	5
; String Variables
STRVAR_M	.block	3
STRVAR_V	.block	3
STRVAR_W	.block	3
STRVAR_X	.block	3
STRVAR_Y	.block	3
STRVAR_Z	.block	3
; Numeric Arrays
INTARR_A	.block	4	; dims=1
INTARR_B	.block	4	; dims=1
INTARR_C	.block	4	; dims=1
INTARR_J	.block	4	; dims=1
INTARR_K	.block	4	; dims=1
; String Arrays
STRARR_B	.block	4	; dims=1
STRARR_C	.block	4	; dims=1
STRARR_D	.block	4	; dims=1
STRARR_F	.block	4	; dims=1
STRARR_G	.block	4	; dims=1
STRARR_H	.block	4	; dims=1
STRARR_I	.block	4	; dims=1
STRARR_J	.block	4	; dims=1
STRARR_M	.block	4	; dims=1
STRARR_N	.block	4	; dims=1
STRARR_O	.block	4	; dims=1

; block ended by symbol
bes
	.end

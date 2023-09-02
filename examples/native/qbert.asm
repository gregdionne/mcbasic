; Assembly for qbert.bas
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

LINE_1

	; CLS

	jsr	cls

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

	; GOSUB 4000

	ldx	#LINE_4000
	jsr	gosub_ix

	; CLEAR 4000

	jsr	clear

	; GOTO 900

	ldx	#LINE_900
	jsr	goto_ix

LINE_2

	; PRINT @L, X$(C,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; X-=2

	ldx	#INTVAR_X
	ldab	#2
	jsr	sub_ix_ix_pb

	; Y-=2

	ldx	#INTVAR_Y
	ldab	#2
	jsr	sub_ix_ix_pb

	; L=(W*Y)+X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; ON Y+3 GOTO 52

	ldx	#INTVAR_Y
	ldab	#3
	jsr	add_ir1_ix_pb

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_52

	; P=PEEK(M+L)

	ldx	#INTVAR_M
	ldd	#INTVAR_L
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; PRINT @L, X$(C,1);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,1);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; GOTO 24

	ldx	#LINE_24
	jsr	goto_ix

LINE_3

	; PRINT @L, X$(C,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; X+=2

	ldx	#INTVAR_X
	ldab	#2
	jsr	add_ix_ix_pb

	; Y-=2

	ldx	#INTVAR_Y
	ldab	#2
	jsr	sub_ix_ix_pb

	; L=(W*Y)+X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; ON Y+3 GOTO 52

	ldx	#INTVAR_Y
	ldab	#3
	jsr	add_ir1_ix_pb

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_52

	; P=PEEK(M+L)

	ldx	#INTVAR_M
	ldd	#INTVAR_L
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; PRINT @L, X$(C,0);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,0);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; GOTO 24

	ldx	#LINE_24
	jsr	goto_ix

LINE_4

	; PRINT @L, X$(C,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; X-=2

	ldx	#INTVAR_X
	ldab	#2
	jsr	sub_ix_ix_pb

	; Y+=2

	ldx	#INTVAR_Y
	ldab	#2
	jsr	add_ix_ix_pb

	; L=(W*Y)+X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; P=PEEK(M+L)

	ldx	#INTVAR_M
	ldd	#INTVAR_L
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; PRINT @L, X$(C,1);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,1);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; GOTO 24

	ldx	#LINE_24
	jsr	goto_ix

LINE_5

	; PRINT @L, X$(C,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; X+=2

	ldx	#INTVAR_X
	ldab	#2
	jsr	add_ix_ix_pb

	; Y+=2

	ldx	#INTVAR_Y
	ldab	#2
	jsr	add_ix_ix_pb

	; L=(W*Y)+X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; P=PEEK(M+L)

	ldx	#INTVAR_M
	ldd	#INTVAR_L
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; PRINT @L, X$(C,0);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,0);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; GOTO 24

	ldx	#LINE_24
	jsr	goto_ix

LINE_6

	; IF K(P)<>C THEN

	ldx	#INTARR_K
	ldd	#INTVAR_P
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ldne_ir1_ir1_ix

	ldx	#LINE_7
	jsr	jmpeq_ir1_ix

	; J+=1

	ldx	#INTVAR_J
	jsr	inc_ix_ix

	; N+=1

	ldx	#INTVAR_N
	jsr	inc_ix_ix

	; PRINT @I, STR$(N);" ";

	ldx	#INTVAR_I
	jsr	prat_ix

	ldx	#INTVAR_N
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; WHEN J>27 GOTO 95

	ldab	#27
	ldx	#INTVAR_J
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_95
	jsr	jmpne_ir1_ix

LINE_7

	; SOUND 10,1

	ldab	#10
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 20,1

	ldab	#20
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; P=0

	ldx	#INTVAR_P
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_8

	; RETURN

	jsr	return

LINE_9

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

	; V=-2

	ldx	#INTVAR_V
	ldab	#-2
	jsr	ld_ix_nb

	; RETURN

	jsr	return

LINE_10

	; V=-2

	ldx	#INTVAR_V
	ldab	#-2
	jsr	ld_ix_nb

	; RETURN

	jsr	return

LINE_11

	; ON B GOTO 8,12,8,12,8,12,8,12,8,12,8,10

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	12
	.word	LINE_8, LINE_12, LINE_8, LINE_12, LINE_8, LINE_12, LINE_8, LINE_12, LINE_8, LINE_12, LINE_8, LINE_10

	; V=2

	ldx	#INTVAR_V
	ldab	#2
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_12

	; V=V(RND(2))

	ldab	#2
	jsr	irnd_ir1_pb

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_V
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_13

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; V=2

	ldx	#INTVAR_V
	ldab	#2
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_14

	; V=2

	ldx	#INTVAR_V
	ldab	#2
	jsr	ld_ix_pb

	; RETURN

	jsr	return

LINE_15

	; ON SGN(X-A)+2 GOSUB 9,11,13

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	sub_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldab	#2
	jsr	add_ir1_ir1_pb

	jsr	ongosub_ir1_is
	.byte	3
	.word	LINE_9, LINE_11, LINE_13

	; U=V

	ldd	#INTVAR_U
	ldx	#INTVAR_V
	jsr	ld_id_ix

	; ON SGN(Y-B)+2 GOSUB 10,11,14

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	sub_ir1_ix_id

	jsr	sgn_ir1_ir1

	ldab	#2
	jsr	add_ir1_ir1_pb

	jsr	ongosub_ir1_is
	.byte	3
	.word	LINE_10, LINE_11, LINE_14

	; G=K

	ldd	#INTVAR_G
	ldx	#INTVAR_K
	jsr	ld_id_ix

	; K=K(PEEK(((B+V)*W)+A+U+M))

	ldx	#INTVAR_B
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTVAR_W
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_U
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; ON K GOTO 40,60,16,16,16,16,16,22,22

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_40, LINE_60, LINE_16, LINE_16, LINE_16, LINE_16, LINE_16, LINE_22, LINE_22

LINE_16

	; PRINT @O, X$(G,2);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O+W, Y$(G,2);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; A+=U

	ldx	#INTVAR_U
	jsr	ld_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ix_ix_ir1

	; B+=V

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	add_ix_ix_ir1

	; O=(W*B)+A

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; ON K GOSUB 42,90

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	jsr	ongosub_ir1_is
	.byte	2
	.word	LINE_42, LINE_90

	; PRINT @O, A$(K,D);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; PRINT @O+W, B$(K,D);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; SOUND H,1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 50,1

	ldab	#50
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_18

	; ON A(T) GOTO 44

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_44

	; PRINT @O(T), X$(I(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, Y$(I(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; GOSUB 12

	ldx	#LINE_12
	jsr	gosub_ix

	; U=2

	ldx	#INTVAR_U
	ldab	#2
	jsr	ld_ix_pb

	; G(T)=I(T)

	ldx	#INTARR_G
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

	; I(T)=K(PEEK(((B(T)+U)*W)+A(T)+V+M))

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_U
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_W
	jsr	mul_ir1_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_V
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_19

	; ON I(T) GOTO 46,90,20,20,20,20,20,21,21

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	ongoto_ir1_is
	.byte	9
	.word	LINE_46, LINE_90, LINE_20, LINE_20, LINE_20, LINE_20, LINE_20, LINE_21, LINE_21

LINE_20

	; A(T)+=V

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	jsr	add_ip_ip_ir1

	; B(T)+=U

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_U
	jsr	ld_ir1_ix

	jsr	add_ip_ip_ir1

	; O(T)=(B(T)*W)+A(T)

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	mul_ir1_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	add_ir1_ir1_ir2

	jsr	ld_ip_ir1

	; PRINT @O(T), A$(I(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(I(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; ON A GOTO 38

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_38

	; RETURN

	jsr	return

LINE_21

	; PRINT @O(T), A$(G(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTARR_G
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(G(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTARR_G
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; I(T)=G(T)

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_G
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_22

	; PRINT @O, A$(G,D);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; PRINT @O+W, B$(G,D);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; K=G

	ldd	#INTVAR_K
	ldx	#INTVAR_G
	jsr	ld_id_ix

	; RETURN

	jsr	return

LINE_24

	; ON K(P) GOTO 50,8,6,6,6,6,6,70,80,200

	ldx	#INTARR_K
	ldd	#INTVAR_P
	jsr	arrval1_ir1_ix_id

	jsr	ongoto_ir1_is
	.byte	10
	.word	LINE_50, LINE_8, LINE_6, LINE_6, LINE_6, LINE_6, LINE_6, LINE_70, LINE_80, LINE_200

	; RETURN

	jsr	return

LINE_25

	; FOR Z=1 TO 65000

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldd	#65000
	jsr	to_ip_pw

	; GOSUB 83

	ldx	#LINE_83
	jsr	gosub_ix

	; IF L>448 THEN

	ldd	#448
	ldx	#INTVAR_L
	jsr	ldlt_ir1_pw_ix

	ldx	#LINE_26
	jsr	jmpeq_ir1_ix

	; L=14

	ldx	#INTVAR_L
	ldab	#14
	jsr	ld_ix_pb

LINE_26

	; ON K(ASC(INKEY$+B$)) GOSUB 2,3,4,5

	jsr	inkey_sr1

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_B
	jsr	strcat_sr1_sr1_sx

	jsr	asc_ir1_sr1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ongosub_ir1_is
	.byte	4
	.word	LINE_2, LINE_3, LINE_4, LINE_5

	; ON RND(S) GOSUB 15

	ldx	#INTVAR_S
	jsr	rnd_fr1_ix

	jsr	ongosub_ir1_is
	.byte	1
	.word	LINE_15

	; FOR T=1 TO 2

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#2
	jsr	to_ip_pb

	; ON RND(S(T)) GOSUB 18

	ldx	#INTARR_S
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	rnd_fr1_ir1

	jsr	ongosub_ir1_is
	.byte	1
	.word	LINE_18

LINE_28

	; IF LC<>0 THEN

	ldx	#INTVAR_LC
	jsr	ld_ir1_ix

	ldx	#LINE_29
	jsr	jmpeq_ir1_ix

	; Z=65000

	ldx	#INTVAR_Z
	ldd	#65000
	jsr	ld_ix_pw

	; J=28

	ldx	#INTVAR_J
	ldab	#28
	jsr	ld_ix_pb

LINE_29

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_31

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; IF J>27 THEN

	ldab	#27
	ldx	#INTVAR_J
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_32
	jsr	jmpeq_ir1_ix

	; N+=H

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTVAR_N
	jsr	add_ix_ix_ir1

	; PRINT @I, STR$(N);" ";

	ldx	#INTVAR_I
	jsr	prat_ix

	ldx	#INTVAR_N
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; PRINT @480, "           NEXT LEVEL!";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	22, "           NEXT LEVEL!"

	; GOSUB 6000

	ldx	#LINE_6000
	jsr	gosub_ix

	; GOTO 120

	ldx	#LINE_120
	jsr	goto_ix

LINE_32

	; LF-=1

	ldx	#INTVAR_LF
	jsr	dec_ix_ix

	; IF LF>0 THEN

	ldab	#0
	ldx	#INTVAR_LF
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_33
	jsr	jmpeq_ir1_ix

	; GOSUB 230

	ldx	#LINE_230
	jsr	gosub_ix

	; PRINT @0, "         @!#@!";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "         @!#@!"

	; FOR T=1 TO 10

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND RND(H),1

	ldx	#INTVAR_H
	jsr	rnd_fr1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; PRINT @0, BL$;

	ldab	#0
	jsr	prat_pb

	ldx	#STRVAR_BL
	jsr	pr_sx

	; GOTO 260

	ldx	#LINE_260
	jsr	goto_ix

LINE_33

	; PRINT @21, "PLAY AGAIN?";

	ldab	#21
	jsr	prat_pb

	jsr	pr_ss
	.text	11, "PLAY AGAIN?"

	; PRINT @218, STR$(LF);" ";

	ldab	#218
	jsr	prat_pb

	ldx	#INTVAR_LF
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_34

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; R=RND(1000)

	ldd	#1000
	jsr	irnd_ir1_pw

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; WHEN I$="" GOTO 34

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_34
	jsr	jmpne_ir1_ix

LINE_35

	; WHEN I$="Y" GOTO 100

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_100
	jsr	jmpne_ir1_ix

LINE_36

	; IF I$="N" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_37
	jsr	jmpeq_ir1_ix

	; CLS

	jsr	cls

	; END

	jsr	progend

LINE_37

	; GOTO 33

	ldx	#LINE_33
	jsr	goto_ix

LINE_38

	; IF RND(8)>1 THEN

	ldab	#8
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_39
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_39

	; S=SS

	ldd	#INTVAR_S
	ldx	#INTVAR_SS
	jsr	ld_id_ix

	; O=O(T)

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; A=A(T)

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=B(T)

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; K=I(T)

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; G=G(T)

	ldx	#INTARR_G
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_G
	jsr	ld_ix_ir1

	; A(T)=1

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

	; PRINT @O, A$(K,D);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; FOR F=1 TO 10

	ldx	#INTVAR_F
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND H,1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 50,1

	ldab	#50
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; PRINT @O+W, B$(K,D);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_40

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; N+=H

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldx	#INTVAR_N
	jsr	add_ix_ix_ir1

	; PRINT @O, X$(G,2);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O+W, Y$(G,2);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; A+=U

	ldx	#INTVAR_U
	jsr	ld_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ix_ix_ir1

	; B+=V

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	add_ix_ix_ir1

	; O=(W*B)+A

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; PRINT @O, A$(K,D);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; PRINT @O+W, B$(K,D);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

LINE_42

	; FL=SHIFT(ABS(B),1)+2

	ldx	#INTVAR_B
	jsr	abs_ir1_ix

	jsr	dbl_ir1_ir1

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_FL
	jsr	ld_ix_ir1

	; PRINT @O, X$(1,2);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O+W, Y$(1,2);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; O=(W*14)+A

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#14
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

	; FOR F=30 TO 1 STEP -1

	ldx	#INTVAR_F
	ldab	#30
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; IF F=FL THEN

	ldx	#INTVAR_F
	ldd	#INTVAR_FL
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_43
	jsr	jmpeq_ir1_ix

	; PRINT @O, A$(1,D);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_A
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; PRINT @O+W, B$(1,D);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

LINE_43

	; SOUND F,1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @O, X$(1,2);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O+W, Y$(1,2);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; NEXT

	jsr	next

	; SOUND 1,5

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#5
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @I, STR$(N);" ";

	ldx	#INTVAR_I
	jsr	prat_ix

	ldx	#INTVAR_N
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; A=1

	ldx	#INTVAR_A
	jsr	one_ix

	; RETURN

	jsr	return

LINE_44

	; ON RND(2) GOTO 8

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_8

	; A(T)=14

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#14
	jsr	ld_ip_pb

	; B(T)=0

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; O(T)=(B(T)*W)+A(T)

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	mul_ir1_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	add_ir1_ir1_ir2

	jsr	ld_ip_ir1

	; I(T)=K(PEEK(O(T)+M))

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; PRINT @O(T), A$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; G(T)=I(T)

	ldx	#INTARR_G
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	ld_ip_ir1

LINE_45

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @O(T), X$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, Y$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; ON 1-(O(T)=L) GOTO 48,49

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_L
	jsr	ldeq_ir1_ir1_ix

	ldab	#1
	jsr	rsub_ir1_ir1_pb

	jsr	ongoto_ir1_is
	.byte	2
	.word	LINE_48, LINE_49

LINE_46

	; A(T)+=V

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	jsr	add_ip_ip_ir1

	; B(T)+=2

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	add_ip_ip_pb

	; O(T)=(B(T)*W)+A(T)

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	mul_ir1_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	jsr	add_ir1_ir1_ir2

	jsr	ld_ip_ir1

	; PRINT @O(T), A$(1,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(1,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_47

	; PRINT @O(T), X$(1,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, Y$(1,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; A(T)=1

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_48

	; PRINT @O(T), A$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; I(T)=C

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_49

	; PRINT @O(T), A$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(C,2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; I(T)=C

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; GOSUB 91

	ldx	#LINE_91
	jsr	gosub_ix

	; GOSUB 18

	ldx	#LINE_18
	jsr	gosub_ix

	; PRINT @L, X$(C,1);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,1);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_50

	; PRINT @L, X$(1,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(1,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @0, "@!#?@!        ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "@!#?@!        "

LINE_52

	; FL=SHIFT(ABS(Y),1)+2

	ldx	#INTVAR_Y
	jsr	abs_ir1_ix

	jsr	dbl_ir1_ir1

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_FL
	jsr	ld_ix_ir1

	; L=(W*14)+X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldab	#14
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; Z=65000

	ldx	#INTVAR_Z
	ldd	#65000
	jsr	ld_ix_pw

	; FOR F=30 TO 1 STEP -1

	ldx	#INTVAR_F
	ldab	#30
	jsr	for_ix_pb

	ldab	#1
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; IF F=FL THEN

	ldx	#INTVAR_F
	ldd	#INTVAR_FL
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_53
	jsr	jmpeq_ir1_ix

	; PRINT @L, X$(1,1);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(1,1);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_53

	; SOUND F,1

	ldx	#INTVAR_F
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @L, X$(1,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(1,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; NEXT

	jsr	next

	; SOUND 1,5

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#5
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RETURN

	jsr	return

LINE_60

	; K=C

	ldd	#INTVAR_K
	ldx	#INTVAR_C
	jsr	ld_id_ix

	; GOSUB 16

	ldx	#LINE_16
	jsr	gosub_ix

	; PRINT @0, "SNAKE BITE!   ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "SNAKE BITE!   "

	; GOSUB 99

	ldx	#LINE_99
	jsr	gosub_ix

	; FOR Z2=1 TO 25

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#25
	jsr	to_ip_pb

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_70

	; PRINT @O, A$(K,D);

	ldx	#INTVAR_O
	jsr	prat_ix

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_A
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; PRINT @O+W, B$(K,D);

	ldx	#INTVAR_O
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#STRARR_B
	ldd	#INTVAR_D
	jsr	arrval2_ir1_sx_id

	jsr	pr_sr1

	; PRINT @0, "HIT THE SNAKE!";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "HIT THE SNAKE!"

	; GOTO 99

	ldx	#LINE_99
	jsr	goto_ix

LINE_80

	; FOR T=1 TO 2

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#2
	jsr	to_ip_pb

	; IF O(T)=L THEN

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_L
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_81
	jsr	jmpeq_ir1_ix

	; PRINT @O(T), A$(I(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @O(T)+W, B$(I(T),2);

	ldx	#INTARR_O
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_W
	jsr	add_ir1_ir1_ix

	jsr	prat_ir1

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_81

	; NEXT

	jsr	next

	; PRINT @0, "HIT AN EGG!   ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "HIT AN EGG!   "

	; GOSUB 99

	ldx	#LINE_99
	jsr	gosub_ix

	; FOR Z2=1 TO 25

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#25
	jsr	to_ip_pb

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_83

	; FOR Z2=1 TO Z3

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldx	#FLTVAR_Z3
	jsr	to_ip_ix

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_90

	; I(T)=C

	ldx	#INTARR_I
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; GOSUB 20

	ldx	#LINE_20
	jsr	gosub_ix

LINE_91

	; PRINT @0, "HIT BY EGG!   ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "HIT BY EGG!   "

	; GOTO 99

	ldx	#LINE_99
	jsr	goto_ix

LINE_95

	; LC=-1

	ldx	#INTVAR_LC
	jsr	true_ix

	; PRINT @0, "LEVEL CLEARED!";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "LEVEL CLEARED!"

	; FOR Z=1 TO 10

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND Z*10,1

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#10
	jsr	mul_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

LINE_99

	; FOR Z=1 TO 800

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldd	#800
	jsr	to_ip_pw

	; NEXT Z

	ldx	#INTVAR_Z
	jsr	nextvar_ix

	jsr	next

	; Z=65000

	ldx	#INTVAR_Z
	ldd	#65000
	jsr	ld_ix_pw

	; RETURN

	jsr	return

LINE_100

	; LV=0

	ldx	#INTVAR_LV
	jsr	clr_ix

	; SS=30

	ldx	#INTVAR_SS
	ldab	#30
	jsr	ld_ix_pb

	; S(1)=20

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix_ir1

	ldab	#20
	jsr	ld_ip_pb

	; S(2)=20

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix_ir1

	ldab	#20
	jsr	ld_ip_pb

	; IF N>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_N
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_110
	jsr	jmpeq_ir1_ix

	; HS=N

	ldd	#INTVAR_HS
	ldx	#INTVAR_N
	jsr	ld_id_ix

LINE_110

	; N=0

	ldx	#INTVAR_N
	jsr	clr_ix

	; LF=3

	ldx	#INTVAR_LF
	ldab	#3
	jsr	ld_ix_pb

LINE_120

	; CLS 1

	ldab	#1
	jsr	clsn_pb

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

LINE_140

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; X=14

	ldx	#INTVAR_X
	ldab	#14
	jsr	ld_ix_pb

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

	; L=14

	ldx	#INTVAR_L
	ldab	#14
	jsr	ld_ix_pb

	; C=RND(5)+2

	ldab	#5
	jsr	irnd_ir1_pb

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; WHEN C=Q GOTO 140

	ldx	#INTVAR_C
	ldd	#INTVAR_Q
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_140
	jsr	jmpne_ir1_ix

LINE_145

	; GOSUB 250

	ldx	#LINE_250
	jsr	gosub_ix

LINE_150

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

	; A=1

	ldx	#INTVAR_A
	jsr	one_ix

	; A(1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; A(2)=1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; SS-=2

	ldx	#INTVAR_SS
	ldab	#2
	jsr	sub_ix_ix_pb

	; S(1)-=1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix_ir1

	jsr	dec_ip_ip

	; S(2)-=1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix_ir1

	jsr	dec_ip_ip

	; IF SS<10 THEN

	ldx	#INTVAR_SS
	ldab	#10
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_155
	jsr	jmpeq_ir1_ix

	; SS=10

	ldx	#INTVAR_SS
	ldab	#10
	jsr	ld_ix_pb

	; S(1)=10

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix_ir1

	ldab	#10
	jsr	ld_ip_pb

	; S(2)=10

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrref1_ir1_ix_ir1

	ldab	#10
	jsr	ld_ip_pb

LINE_155

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; GOTO 260

	ldx	#LINE_260
	jsr	goto_ix

LINE_200

	; PRINT @0, "              ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	14, "              "

	; PRINT @L, X$(1,0);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(1,0);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; IF S>0 THEN

	ldab	#0
	ldx	#INTVAR_S
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_210
	jsr	jmpeq_ir1_ix

	; S=4

	ldx	#INTVAR_S
	ldab	#4
	jsr	ld_ix_pb

LINE_210

	; FOR Y=Y TO 2 STEP -1

	ldd	#INTVAR_Y
	ldx	#INTVAR_Y
	jsr	for_id_ix

	ldab	#2
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; L=(W*Y)+X

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; PRINT @L, X$(1,2);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(1,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_220

	; PRINT @L-64, X$(1,0);

	ldx	#INTVAR_L
	ldab	#64
	jsr	sub_ir1_ix_pb

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L-W, Y$(1,0);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; SOUND H,1

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 30-SHIFT(Y,1),1

	ldx	#INTVAR_Y
	jsr	dbl_ir1_ix

	ldab	#30
	jsr	rsub_ir1_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; FOR T=1 TO 2

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#2
	jsr	to_ip_pb

LINE_221

	; WHEN (A(T)=14) AND (B(T)=0) GOSUB 18

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldab	#14
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	ldab	#0
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_18
	jsr	jsrne_ir1_ix

LINE_222

	; NEXT

	jsr	next

LINE_223

	; FOR T=1 TO 2

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#2
	jsr	to_ip_pb

	; ON RND(S(T)) GOSUB 18

	ldx	#INTARR_S
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	jsr	rnd_fr1_ir1

	jsr	ongosub_ir1_is
	.byte	1
	.word	LINE_18

	; ON RND(S) GOSUB 15

	ldx	#INTVAR_S
	jsr	rnd_fr1_ix

	jsr	ongosub_ir1_is
	.byte	1
	.word	LINE_15

LINE_225

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; PRINT @L-64, X$(1,2);

	ldx	#INTVAR_L
	ldab	#64
	jsr	sub_ir1_ix_pb

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L-W, Y$(1,2);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	jsr	prat_ir1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; IF S=4 THEN

	ldx	#INTVAR_S
	ldab	#4
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_230
	jsr	jmpeq_ir1_ix

	; S=SS

	ldd	#INTVAR_S
	ldx	#INTVAR_SS
	jsr	ld_id_ix

LINE_230

	; X=14

	ldx	#INTVAR_X
	ldab	#14
	jsr	ld_ix_pb

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

	; L=14

	ldx	#INTVAR_L
	ldab	#14
	jsr	ld_ix_pb

LINE_250

	; P=PEEK(M+L)

	ldx	#INTVAR_M
	ldd	#INTVAR_L
	jsr	add_ir1_ix_id

	jsr	peek_ir1_ir1

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; PRINT @L, X$(C,1);

	ldx	#INTVAR_L
	jsr	prat_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; PRINT @L+W, Y$(C,1);

	ldx	#INTVAR_L
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	; ON K(P) GOTO 50,8,6,6,6,6,6,70,80,200

	ldx	#INTARR_K
	ldd	#INTVAR_P
	jsr	arrval1_ir1_ix_id

	jsr	ongoto_ir1_is
	.byte	10
	.word	LINE_50, LINE_8, LINE_6, LINE_6, LINE_6, LINE_6, LINE_6, LINE_70, LINE_80, LINE_200

	; RETURN

	jsr	return

LINE_260

	; PRINT @218, STR$(LF);" ";

	ldab	#218
	jsr	prat_pb

	ldx	#INTVAR_LF
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; FOR Z=1 TO 25

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#25
	jsr	to_ip_pb

	; GOSUB 83

	ldx	#LINE_83
	jsr	gosub_ix

	; IF LC<>0 THEN

	ldx	#INTVAR_LC
	jsr	ld_ir1_ix

	ldx	#LINE_261
	jsr	jmpeq_ir1_ix

	; Z=65000

	ldx	#INTVAR_Z
	ldd	#65000
	jsr	ld_ix_pw

	; J=28

	ldx	#INTVAR_J
	ldab	#28
	jsr	ld_ix_pb

LINE_261

	; ON K(ASC(INKEY$+B$)) GOSUB 2,3,4,5

	jsr	inkey_sr1

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_B
	jsr	strcat_sr1_sr1_sx

	jsr	asc_ir1_sr1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix_ir1

	jsr	ongosub_ir1_is
	.byte	4
	.word	LINE_2, LINE_3, LINE_4, LINE_5

	; NEXT

	jsr	next

	; GOTO 25

	ldx	#LINE_25
	jsr	goto_ix

LINE_900

	; DIM X$(9,2),Y$(9,2),A$(9,2),B$(9,2),K(255),V(2),A,B,C,D,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z

	ldab	#9
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrdim2_ir1_sx

	ldab	#9
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrdim2_ir1_sx

	ldab	#9
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrdim2_ir1_sx

	ldab	#9
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrdim2_ir1_sx

	ldab	#255
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrdim1_ir1_ix

LINE_910

	; DIM O(2),I(2),G(2),A(2),B(2),S(2),LF,LV,FL,SS,I$,B$,BL$

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_O
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_I
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_G
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrdim1_ir1_ix

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_S
	jsr	arrdim1_ir1_ix

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; GOSUB 5000

	ldx	#LINE_5000
	jsr	gosub_ix

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_1000

	; FOR T=0 TO 7

	ldx	#INTVAR_T
	jsr	forclr_ix

	ldab	#7
	jsr	to_ip_pb

LINE_1010

	; X$(T+1,0)="””"+CHR$(SHIFT(T,4)+141)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrref2_ir1_sx_ir2

	jsr	strinit_sr1_ss
	.text	2, "\x94\x94"

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#141
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

	; Y$(T+1,0)=CHR$(SHIFT(T,4)+132)+CHR$(SHIFT(T,4)+138)+CHR$(SHIFT(T,4)+141)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#132
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#138
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#141
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1020

	; X$(T+1,1)=CHR$(SHIFT(T,4)+142)+"˜˜"

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#142
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	2, "\x98\x98"

	jsr	ld_sp_sr1

	; Y$(T+1,1)=CHR$(SHIFT(T,4)+142)+CHR$(SHIFT(T,4)+133)+CHR$(SHIFT(T,4)+136)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#142
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#133
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#136
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1030

	; X$(T+1,2)=CHR$(SHIFT(T,4)+143)+CHR$(SHIFT(T,4)+143)+CHR$(SHIFT(T,4)+143)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#143
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#143
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

	; Y$(T+1,2)=CHR$(SHIFT(T,4)+143)+CHR$(SHIFT(T,4)+143)+CHR$(SHIFT(T,4)+143)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#143
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#143
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#143
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1040

	; A$(T+1,0)=CHR$(SHIFT(T,4)+140)+CHR$(SHIFT(T,4)+141)+"ø"

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#140
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#141
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	strcat_sr1_sr1_ss
	.text	1, "\xF8"

	jsr	ld_sp_sr1

	; A$(T+1,1)="ô"+CHR$(SHIFT(T,4)+142)+CHR$(SHIFT(T,4)+140)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	jsr	strinit_sr1_ss
	.text	1, "\xF4"

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#142
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#140
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1045

	; B$(T+1,0)=CHR$(SHIFT(T,4)+133)+CHR$(SHIFT(T,4)+132)+CHR$(SHIFT(T,4)+133)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#133
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#132
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#133
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

	; B$(T+1,1)=CHR$(SHIFT(T,4)+138)+CHR$(SHIFT(T,4)+136)+CHR$(SHIFT(T,4)+138)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#138
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#136
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#138
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1050

	; A$(T+1,2)=CHR$(SHIFT(T,4)+136)+"€"+CHR$(SHIFT(T,4)+141)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#136
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#141
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1055

	; B$(T+1,2)=CHR$(SHIFT(T,4)+130)+"€"+CHR$(SHIFT(T,4)+135)

	ldx	#INTVAR_T
	jsr	inc_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx_ir2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldab	#4
	jsr	shift_ir1_ir1_pb

	ldab	#130
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	strinit_sr1_sr1

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x80"

	ldx	#INTVAR_T
	jsr	ld_ir2_ix

	ldab	#4
	jsr	shift_ir2_ir2_pb

	ldab	#135
	jsr	add_ir2_ir2_pb

	jsr	chr_sr2_ir2

	jsr	strcat_sr1_sr1_sr2

	jsr	ld_sp_sr1

LINE_1060

	; NEXT

	jsr	next

	; C=1

	ldx	#INTVAR_C
	jsr	one_ix

	; FOR T=143 TO 255 STEP 16

	ldx	#INTVAR_T
	ldab	#143
	jsr	for_ix_pb

	ldab	#255
	jsr	to_ip_pb

	ldab	#16
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; K(T)=C

	ldx	#INTARR_K
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; C+=1

	ldx	#INTVAR_C
	jsr	inc_ix_ix

	; NEXT

	jsr	next

	; K(96)=10

	ldab	#96
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#10
	jsr	ld_ip_pb

	; W=32

	ldx	#INTVAR_W
	ldab	#32
	jsr	ld_ix_pb

	; I=122

	ldx	#INTVAR_I
	ldab	#122
	jsr	ld_ix_pb

	; H=100

	ldx	#INTVAR_H
	ldab	#100
	jsr	ld_ix_pb

LINE_1070

	; FOR T=142 TO 255 STEP 16

	ldx	#INTVAR_T
	ldab	#142
	jsr	for_ix_pb

	ldab	#255
	jsr	to_ip_pb

	ldab	#16
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; K(T)=2

	ldx	#INTARR_K
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	ld_ip_pb

	; NEXT

	jsr	next

	; K(148)=2

	ldab	#148
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ip_pb

LINE_1075

	; FOR T=140 TO 255 STEP 16

	ldx	#INTVAR_T
	ldab	#140
	jsr	for_ix_pb

	ldab	#255
	jsr	to_ip_pb

	ldab	#16
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; K(T)=8

	ldx	#INTARR_K
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#8
	jsr	ld_ip_pb

	; NEXT

	jsr	next

	; K(244)=8

	ldab	#244
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#8
	jsr	ld_ip_pb

LINE_1080

	; FOR T=136 TO 255 STEP 16

	ldx	#INTVAR_T
	ldab	#136
	jsr	for_ix_pb

	ldab	#255
	jsr	to_ip_pb

	ldab	#16
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; K(T)=9

	ldx	#INTARR_K
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#9
	jsr	ld_ip_pb

	; NEXT

	jsr	next

LINE_1090

	; A$(8,0)="   "

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrref2_ir1_sx_ir2

	jsr	ld_sr1_ss
	.text	3, "   "

	jsr	ld_sp_sr1

	; B$(8,0)="ŒŒŒ"

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrref2_ir1_sx_ir2

	jsr	ld_sr1_ss
	.text	3, "\x8C\x8C\x8C"

	jsr	ld_sp_sr1

LINE_1095

	; Y$(1,0)="„ˆŒ"

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrref2_ir1_sx_ir2

	jsr	ld_sr1_ss
	.text	3, "\x84\x88\x8C"

	jsr	ld_sp_sr1

LINE_1110

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

	; K(90)=3

	ldab	#90
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#3
	jsr	ld_ip_pb

	; K(88)=4

	ldab	#88
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix_ir1

	ldab	#4
	jsr	ld_ip_pb

	; B$="€"

	jsr	ld_sr1_ss
	.text	1, "\x80"

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; M=16384

	ldx	#INTVAR_M
	ldd	#16384
	jsr	ld_ix_pw

	; V(1)=-2

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	ldab	#-2
	jsr	ld_ip_nb

	; V(2)=2

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	ld_ip_pb

LINE_1120

	; FOR T=1 TO 14

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#14
	jsr	to_ip_pb

	; BL$=BL$+""

	ldx	#STRVAR_BL
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, "\x8F"

	ldx	#STRVAR_BL
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

LINE_1220

	; RETURN

	jsr	return

LINE_2000

	; T=254

	ldx	#INTVAR_T
	ldab	#254
	jsr	ld_ix_pb

	; PRINT @T+4, A$(8,0);

	ldx	#INTVAR_T
	ldab	#4
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_2065

	; PRINT @T+36, B$(8,0);

	ldx	#INTVAR_T
	ldab	#36
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_2070

	; R=RND(3)-1

	ldab	#3
	jsr	irnd_ir1_pb

	jsr	dec_ir1_ir1

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; T=SHIFT(R,6)+SHIFT(R,1)+80

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#6
	jsr	shift_ir1_ir1_pb

	ldx	#INTVAR_R
	jsr	dbl_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldab	#80
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; PRINT @T+4, A$(8,0);

	ldx	#INTVAR_T
	ldab	#4
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_A
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_2075

	; PRINT @T+36, B$(8,0);

	ldx	#INTVAR_T
	ldab	#36
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	ldab	#8
	jsr	ld_ir1_pb

	ldab	#0
	jsr	ld_ir2_pb

	ldx	#STRARR_B
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_2090

	; RETURN

	jsr	return

LINE_3000

	; Q=RND(5)+2

	ldab	#5
	jsr	irnd_ir1_pb

	ldab	#2
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_Q
	jsr	ld_ix_ir1

	; X=0

	ldx	#INTVAR_X
	jsr	clr_ix

	; FOR Y=0 TO 6

	ldx	#INTVAR_Y
	jsr	forclr_ix

	ldab	#6
	jsr	to_ip_pb

	; X+=1

	ldx	#INTVAR_X
	jsr	inc_ix_ix

LINE_3010

	; PRINT @SHIFT(Y,6)+16-SHIFT(X,1),

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#6
	jsr	shift_ir1_ir1_pb

	ldab	#16
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	dbl_ir2_ix

	jsr	sub_ir1_ir1_ir2

	jsr	prat_ir1

	; FOR C=1 TO X

	ldx	#INTVAR_C
	jsr	forone_ix

	ldx	#INTVAR_X
	jsr	to_ip_ix

	; PRINT X$(Q,2);" ";

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_X
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; NEXT

	jsr	next

LINE_3011

	; PRINT @SHIFT(Y,6)+48-SHIFT(X,1),

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#6
	jsr	shift_ir1_ir1_pb

	ldab	#48
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_X
	jsr	dbl_ir2_ix

	jsr	sub_ir1_ir1_ir2

	jsr	prat_ir1

	; FOR C=1 TO X

	ldx	#INTVAR_C
	jsr	forone_ix

	ldx	#INTVAR_X
	jsr	to_ip_ix

	; PRINT Y$(Q,2);

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldab	#2
	jsr	ld_ir2_pb

	ldx	#STRARR_Y
	jsr	arrval2_ir1_sx_ir2

	jsr	pr_sr1

LINE_3012

	; WHEN (Y=7) AND (C=8) GOTO 3020

	ldx	#INTVAR_Y
	ldab	#7
	jsr	ldeq_ir1_ix_pb

	ldx	#INTVAR_C
	ldab	#8
	jsr	ldeq_ir2_ix_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_3020
	jsr	jmpne_ir1_ix

LINE_3013

	; PRINT " ";

	jsr	pr_ss
	.text	1, " "

LINE_3020

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_3030

	; LV+=1

	ldx	#INTVAR_LV
	jsr	inc_ix_ix

	; IF LV=99 THEN

	ldx	#INTVAR_LV
	ldab	#99
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_3035
	jsr	jmpeq_ir1_ix

	; CLS

	jsr	cls

	; PRINT "JIM LOVES HIS PATTY, BOO,\r";

	jsr	pr_ss
	.text	26, "JIM LOVES HIS PATTY, BOO,\r"

	; PRINT "CHUM AND NAY\r";

	jsr	pr_ss
	.text	13, "CHUM AND NAY\r"

	; END

	jsr	progend

LINE_3035

	; IF FRACT(LV/3)=0 THEN

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldab	#3
	jsr	div_fr1_ir1_pb

	jsr	fract_fr1_fr1

	ldx	#LINE_3040
	jsr	jmpne_fr1_ix

	; LF+=1

	ldx	#INTVAR_LF
	jsr	inc_ix_ix

	; FOR Z2=1 TO 10

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; PRINT @0, "BONUS LIFE";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	10, "BONUS LIFE"

	; SOUND 100,2

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @0, "          ";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	10, "          "

	; SOUND 50,2

	ldab	#50
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_3040

	; PRINT @91, "LV";STR$(LV);" ";

	ldab	#91
	jsr	prat_pb

	jsr	pr_ss
	.text	2, "LV"

	ldx	#INTVAR_LV
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; PRINT @122, STR$(N);" ";

	ldab	#122
	jsr	prat_pb

	ldx	#INTVAR_N
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; IF N>9999 THEN

	ldd	#9999
	ldx	#INTVAR_N
	jsr	ldlt_ir1_pw_ix

	ldx	#LINE_3041
	jsr	jmpeq_ir1_ix

	; PRINT @121, STR$(N);" ";

	ldab	#121
	jsr	prat_pb

	ldx	#INTVAR_N
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_3041

	; PRINT @155, "HIGH";

	ldab	#155
	jsr	prat_pb

	jsr	pr_ss
	.text	4, "HIGH"

	; PRINT @186, STR$(HS);" ";

	ldab	#186
	jsr	prat_pb

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; IF HS>9999 THEN

	ldd	#9999
	ldx	#INTVAR_HS
	jsr	ldlt_ir1_pw_ix

	ldx	#LINE_3050
	jsr	jmpeq_ir1_ix

	; PRINT @185, STR$(HS);" ";

	ldab	#185
	jsr	prat_pb

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_3050

	; RETURN

	jsr	return

LINE_4000

	; CLS

	jsr	cls

	; PRINT @77, "q*bert\r";

	ldab	#77
	jsr	prat_pb

	jsr	pr_ss
	.text	7, "q*bert\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "  BY JIM GERRIE & GREG DIONNE\r";

	jsr	pr_ss
	.text	30, "  BY JIM GERRIE & GREG DIONNE\r"

LINE_4010

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_4015

	; PRINT " USE THE A,S,Z&X KEYS TO MOVE.\r";

	jsr	pr_ss
	.text	31, " USE THE A,S,Z&X KEYS TO MOVE.\r"

LINE_4020

	; PRINT " JUMP ON EACH SQUARE TO CHANGE\r";

	jsr	pr_ss
	.text	31, " JUMP ON EACH SQUARE TO CHANGE\r"

LINE_4030

	; PRINT " ITS COLOR. YOU GET A FREE MAN\r";

	jsr	pr_ss
	.text	31, " ITS COLOR. YOU GET A FREE MAN\r"

LINE_4040

	; PRINT " EVERY 3 LEVELS. USE THE LIFTS\r";

	jsr	pr_ss
	.text	31, " EVERY 3 LEVELS. USE THE LIFTS\r"

LINE_4050

	; PRINT " TO KILL THE SNAKE=100. MOVE  \r";

	jsr	pr_ss
	.text	31, " TO KILL THE SNAKE=100. MOVE  \r"

LINE_4060

	; PRINT " QUICKLY FROM THE TOP SQUARE.\r";

	jsr	pr_ss
	.text	30, " QUICKLY FROM THE TOP SQUARE.\r"

LINE_4070

	; RETURN

	jsr	return

LINE_5000

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; PRINT @448, "     ENTER DIFFICULTY (1-3)?";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	28, "     ENTER DIFFICULTY (1-3)?"

	; LC=0

	ldx	#INTVAR_LC
	jsr	clr_ix

LINE_5010

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; R=RND(1000)

	ldd	#1000
	jsr	irnd_ir1_pw

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; WHEN I$="" GOTO 5010

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_5010
	jsr	jmpne_ir1_ix

LINE_5015

	; WHEN (VAL(I$)<0) OR (VAL(I$)>3) GOTO 5010

	ldx	#STRVAR_I
	jsr	val_fr1_sx

	ldab	#0
	jsr	ldlt_ir1_fr1_pb

	ldx	#STRVAR_I
	jsr	val_fr2_sx

	ldab	#3
	jsr	ldlt_ir2_pb_fr2

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_5010
	jsr	jmpne_ir1_ix

LINE_5016

	; Z3=400-(VAL(I$)*100)

	ldx	#STRVAR_I
	jsr	val_fr1_sx

	ldab	#100
	jsr	mul_fr1_fr1_pb

	ldd	#400
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_Z3
	jsr	ld_fx_fr1

LINE_5020

	; RETURN

	jsr	return

LINE_6000

	; PRINT @448, "          GET READY FOR     ";

	ldd	#448
	jsr	prat_pw

	jsr	pr_ss
	.text	28, "          GET READY FOR     "

	; LC=0

	ldx	#INTVAR_LC
	jsr	clr_ix

LINE_6010

	; FOR Z2=1 TO 22000

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldd	#22000
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; FOR Z2=1 TO 25

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#25
	jsr	to_ip_pb

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

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
	tst	tmp1+1
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

abs_ir1_ix			; numCalls = 2
	.module	modabs_ir1_ix
	ldaa	0,x
	bpl	_copy
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts
_copy
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

add_ip_ip_ir1			; numCalls = 3
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

add_ir1_ir1_ir2			; numCalls = 5
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 26
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 19
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 31
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

add_ir2_ir2_pb			; numCalls = 18
	.module	modadd_ir2_ir2_pb
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
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

add_ix_ix_pb			; numCalls = 4
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

arrdim2_ir1_sx			; numCalls = 4
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

arrref1_ir1_ix_id			; numCalls = 23
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 17
	.module	modarrref1_ir1_ix_ir1
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_sx_ir2			; numCalls = 15
	.module	modarrref2_ir1_sx_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 51
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

arrval1_ir1_ix_ir1			; numCalls = 6
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

arrval1_ir2_ix_id			; numCalls = 5
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

arrval2_ir1_sx_id			; numCalls = 12
	.module	modarrval2_ir1_sx_id
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

arrval2_ir1_sx_ir2			; numCalls = 68
	.module	modarrval2_ir1_sx_ir2
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

asc_ir1_sr1			; numCalls = 2
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

chr_sr1_ir1			; numCalls = 10
	.module	modchr_sr1_ir1
	ldd	#$0100+(charpage>>8)
	std	r1
	rts

chr_sr2_ir2			; numCalls = 18
	.module	modchr_sr2_ir2
	ldd	#$0100+(charpage>>8)
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
	stx	DP_DATA
	rts

clr_ip			; numCalls = 1
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 13
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 4
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

dbl_ir1_ir1			; numCalls = 2
	.module	moddbl_ir1_ir1
	ldx	#r1
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dbl_ir1_ix			; numCalls = 1
	.module	moddbl_ir1_ix
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dbl_ir2_ix			; numCalls = 3
	.module	moddbl_ir2_ix
	ldd	1,x
	lsld
	std	r2+1
	ldab	0,x
	rolb
	stab	r2
	rts

dec_ip_ip			; numCalls = 2
	.module	moddec_ip_ip
	ldx	letptr
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
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

dec_ix_ix			; numCalls = 1
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

div_fr1_ir1_pb			; numCalls = 1
	.module	moddiv_fr1_ir1_pb
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	std	r1+3
	ldx	#r1
	jmp	divflt

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

for_ix_pb			; numCalls = 6
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

forone_ix			; numCalls = 19
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

gosub_ix			; numCalls = 17
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 13
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_ir1_ix			; numCalls = 12
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
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

inkey_sx			; numCalls = 7
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

irnd_ir1_pw			; numCalls = 2
	.module	modirnd_ir1_pw
	clr	tmp1+1
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

jmpne_fr1_ix			; numCalls = 1
	.module	modjmpne_fr1_ix
	ldd	r1+1
	bne	_go
	ldaa	r1
	bne	_go
	ldd	r1+3
	bne	_go
	rts
_go
	ins
	ins
	jmp	,x

jmpne_ir1_ix			; numCalls = 7
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

ld_fx_fr1			; numCalls = 1
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_id_ix			; numCalls = 7
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

ld_ip_ir1			; numCalls = 12
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_nb			; numCalls = 1
	.module	modld_ip_nb
	ldx	letptr
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ip_pb			; numCalls = 15
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

ld_ir1_nb			; numCalls = 3
	.module	modld_ir1_nb
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ir1_pb			; numCalls = 76
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 18
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 105
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 29
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 2
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 19
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 5
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 15
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 4
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sx_sr1			; numCalls = 2
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir1_sx_ss			; numCalls = 4
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

ldeq_ir2_ix_pb			; numCalls = 1
	.module	modldeq_ir2_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldlt_ir1_fr1_pb			; numCalls = 1
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

ldlt_ir1_ix_pb			; numCalls = 1
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

ldlt_ir1_pb_ix			; numCalls = 4
	.module	modldlt_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_pw_ix			; numCalls = 3
	.module	modldlt_ir1_pw_ix
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_pb_fr2			; numCalls = 1
	.module	modldlt_ir2_pb_fr2
	clra
	std	tmp1
	clrb
	subd	r2+3
	ldd	tmp1
	sbcb	r2+2
	sbca	r2+1
	ldab	#0
	sbcb	r2
	jsr	getlt
	std	r2+1
	stab	r2
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

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_ix			; numCalls = 12
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pb			; numCalls = 3
	.module	modmul_ir1_ir1_pb
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

next			; numCalls = 28
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

nextvar_ix			; numCalls = 2
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

one_ip			; numCalls = 5
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

ongosub_ir1_is			; numCalls = 9
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

ongoto_ir1_is			; numCalls = 11
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

peek_ir1_ir1			; numCalls = 8
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

poke_pw_ir1			; numCalls = 2
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 90
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 40
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 1
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 55
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

prat_pb			; numCalls = 21
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

return			; numCalls = 31
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

rnd_fr1_ir1			; numCalls = 2
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

rnd_fr1_ix			; numCalls = 3
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

rsub_ir1_ir1_pb			; numCalls = 2
	.module	modrsub_ir1_ir1_pb
	clra
	subd	r1+1
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

shift_ir1_ir1_pb			; numCalls = 13
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

shift_ir2_ir2_pb			; numCalls = 18
	.module	modshift_ir2_ir2_pb
	ldx	#r2
	jmp	shlint

sound_ir1_ir2			; numCalls = 18
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

str_sr1_ix			; numCalls = 10
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

strcat_sr1_sr1_sr2			; numCalls = 18
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

strcat_sr1_sr1_ss			; numCalls = 5
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

strinit_sr1_sr1			; numCalls = 12
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

strinit_sr1_sx			; numCalls = 1
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

sub_ir1_ir1_ir2			; numCalls = 2
	.module	modsub_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

sub_ir1_ix_id			; numCalls = 4
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

sub_ir1_ix_pb			; numCalls = 2
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

sub_ix_ix_pb			; numCalls = 5
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

to_ip_pb			; numCalls = 22
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

true_ix			; numCalls = 1
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

val_fr2_sx			; numCalls = 1
	.module	modval_fr2_sx
	jsr	strval
	ldab	tmp1+1
	stab	r2
	ldd	tmp2
	std	r2+1
	ldd	tmp3
	std	r2+3
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
INTVAR_F	.block	3
INTVAR_FL	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_HS	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_LC	.block	3
INTVAR_LF	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_N	.block	3
INTVAR_O	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_SS	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_W	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
INTVAR_Z2	.block	3
FLTVAR_Z3	.block	5
; String Variables
STRVAR_B	.block	3
STRVAR_BL	.block	3
STRVAR_I	.block	3
; Numeric Arrays
INTARR_A	.block	4	; dims=1
INTARR_B	.block	4	; dims=1
INTARR_G	.block	4	; dims=1
INTARR_I	.block	4	; dims=1
INTARR_K	.block	4	; dims=1
INTARR_O	.block	4	; dims=1
INTARR_S	.block	4	; dims=1
INTARR_V	.block	4	; dims=1
; String Arrays
STRARR_A	.block	6	; dims=2
STRARR_B	.block	6	; dims=2
STRARR_X	.block	6	; dims=2
STRARR_Y	.block	6	; dims=2

; block ended by symbol
bes
	.end

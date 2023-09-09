; Assembly for jailbrk.bas
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

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_1

	; X=I-1

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=J+1

	ldx	#INTVAR_J
	jsr	inc_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; A=0

	ldx	#INTVAR_A
	jsr	clr_ix

	; B=0

	ldx	#INTVAR_B
	jsr	clr_ix

	; GOTO 90

	ldx	#LINE_90
	jsr	goto_ix

LINE_2

	; X=I+1

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=J+1

	ldx	#INTVAR_J
	jsr	inc_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; A=0

	ldx	#INTVAR_A
	jsr	clr_ix

	; B=0

	ldx	#INTVAR_B
	jsr	clr_ix

	; GOTO 90

	ldx	#LINE_90
	jsr	goto_ix

LINE_3

	; WHEN B=0 GOTO 26

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#LINE_26
	jsr	jmpeq_ir1_ix

LINE_4

	; IF Y=27 THEN

	ldx	#INTVAR_Y
	ldab	#27
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_5
	jsr	jmpeq_ir1_ix

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 100,3

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; B(T)=0

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; X(T)=0

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; Y(T)=0

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; GOTO 26

	ldx	#LINE_26
	jsr	goto_ix

LINE_5

	; GOTO 21

	ldx	#LINE_21
	jsr	goto_ix

LINE_8

	; IF T<6 THEN

	ldx	#INTVAR_T
	ldab	#6
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_9
	jsr	jmpeq_ir1_ix

	; RESET(X+A,Y+B)

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	reset_ir1_ir2

	; GOTO 22

	ldx	#LINE_22
	jsr	goto_ix

LINE_9

	; GOTO 22

	ldx	#LINE_22
	jsr	goto_ix

LINE_10

	; IF I>3 THEN

	ldab	#3
	ldx	#INTVAR_I
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_11
	jsr	jmpeq_ir1_ix

	; SET(I+1,J+1,1)

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; RESET(I,J)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	reset_ir1_ix

	; RESET(I+1,J+1)

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	jsr	reset_ir1_ir2

	; I-=1

	ldx	#INTVAR_I
	jsr	dec_ix_ix

	; SET(I+1,J+1,8)

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; K=POINT(I-1,J+1)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; SET(I-1,J+1,8)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; SET(I,J,8)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; WHEN K=1 GOTO 1

	ldx	#INTVAR_K
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_1
	jsr	jmpne_ir1_ix

LINE_11

	; GOTO 26

	ldx	#LINE_26
	jsr	goto_ix

LINE_12

	; IF I<R THEN

	ldx	#INTVAR_I
	ldd	#INTVAR_R
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_13
	jsr	jmpeq_ir1_ix

	; SET(I-1,J+1,1)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; RESET(I,J)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	reset_ir1_ix

	; RESET(I-1,J+1)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	jsr	reset_ir1_ir2

	; I+=1

	ldx	#INTVAR_I
	jsr	inc_ix_ix

	; SET(I-1,J+1,8)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; K=POINT(I+1,J+1)

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; SET(I+1,J+1,8)

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; SET(I,J,8)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; WHEN K=1 GOTO 2

	ldx	#INTVAR_K
	ldab	#1
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_2
	jsr	jmpne_ir1_ix

LINE_13

	; GOTO 26

	ldx	#LINE_26
	jsr	goto_ix

LINE_14

	; WHEN POINT(I,J-1) OR S GOTO 26

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	dec_ir2_ix

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_S
	jsr	or_ir1_ir1_ix

	ldx	#LINE_26
	jsr	jmpne_ir1_ix

LINE_15

	; Z+=1

	ldx	#INTVAR_Z
	jsr	inc_ix_ix

	; IF Z=16 THEN

	ldx	#INTVAR_Z
	ldab	#16
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_16
	jsr	jmpeq_ir1_ix

	; Z=10

	ldx	#INTVAR_Z
	ldab	#10
	jsr	ld_ix_pb

LINE_16

	; WHEN A(Z) GOTO 26

	ldx	#INTARR_A
	ldd	#INTVAR_Z
	jsr	arrval1_ir1_ix_id

	ldx	#LINE_26
	jsr	jmpne_ir1_ix

LINE_17

	; X(Z)=I

	ldx	#INTARR_X
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y(Z)=J-1

	ldx	#INTARR_Y
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_J
	jsr	dec_ir1_ix

	jsr	ld_ip_ir1

	; A(Z)=1

	ldx	#INTARR_A
	ldd	#INTVAR_Z
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

	; SET(I,J-1,0)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	dec_ir2_ix

	ldab	#0
	jsr	setc_ir1_ir2_pb

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; GOTO 26

	ldx	#LINE_26
	jsr	goto_ix

LINE_20

	; FOR Q=1 TO L

	ldx	#INTVAR_Q
	jsr	forone_ix

	ldx	#INTVAR_L
	jsr	to_ip_ix

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; FOR T=1 TO 6

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

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

	; X=X(T)

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y(T)

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; WHEN A=0 GOTO 3

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#LINE_3
	jsr	jmpeq_ir1_ix

LINE_21

	; K=POINT(X+A,Y+B)

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; IF K THEN

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#LINE_22
	jsr	jmpeq_ir1_ix

	; ON K GOTO 80,22,22,22,22,22,8,60

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	8
	.word	LINE_80, LINE_22, LINE_22, LINE_22, LINE_22, LINE_22, LINE_8, LINE_60

LINE_22

	; A=V(-(POINT(X+A,Y)=0))*A

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	point_ir1_ir1_ix

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	jsr	neg_ir1_ir1

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_A
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; B=V(-(POINT(X,Y+B)=0))*B

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	point_ir1_ir1_ir2

	ldab	#0
	jsr	ldeq_ir1_ir1_pb

	jsr	neg_ir1_ir1

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_B
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; IF POINT(X+A,Y+B) THEN

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	point_ir1_ir1_ir2

	ldx	#LINE_23
	jsr	jmpeq_ir1_ix

	; IF POINT(X+A,Y+B)<>1 THEN

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	jsr	point_ir1_ir1_ir2

	ldab	#1
	jsr	ldne_ir1_ir1_pb

	ldx	#LINE_23
	jsr	jmpeq_ir1_ix

	; A=-A

	ldx	#INTVAR_A
	jsr	neg_ix_ix

	; B=-B

	ldx	#INTVAR_B
	jsr	neg_ix_ix

LINE_23

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; X+=A

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ix_ix_ir1

	; Y+=B

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	add_ix_ix_ir1

	; SET(X,Y,0)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#0
	jsr	setc_ir1_ir2_pb

	; A(T)=A

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; B(T)=B

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; X(T)=X

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Y(T)=Y

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; WHEN PEEK(2) AND NOT PEEK(16946) AND 1 GOTO 10

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16946
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_10
	jsr	jmpne_ir1_ix

LINE_24

	; WHEN PEEK(2) AND NOT PEEK(16949) AND 1 GOTO 12

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16949
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_12
	jsr	jmpne_ir1_ix

LINE_25

	; WHEN PEEK(2) AND NOT PEEK(16952) AND 8 GOTO 14

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#8
	jsr	and_ir1_ir1_pb

	ldx	#LINE_14
	jsr	jmpne_ir1_ix

LINE_26

	; M=T+9

	ldx	#INTVAR_T
	ldab	#9
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_M
	jsr	ld_ix_ir1

	; IF A(M) THEN

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrval1_ir1_ix_id

	ldx	#LINE_27
	jsr	jmpeq_ir1_ix

	; X=X(M)

	ldx	#INTARR_X
	ldd	#INTVAR_M
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; Y=Y(M)

	ldx	#INTARR_Y
	ldd	#INTVAR_M
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; Y-=1

	ldx	#INTVAR_Y
	jsr	dec_ix_ix

	; Y(M)=Y

	ldx	#INTARR_Y
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; A=POINT(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	point_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; SET(X,Y,0)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#0
	jsr	setc_ir1_ir2_pb

	; K=POINT(X,Y-1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	dec_ir2_ix

	jsr	point_ir1_ir1_ir2

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; WHEN K OR A GOTO 45

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#INTVAR_A
	jsr	or_ir1_ir1_ix

	ldx	#LINE_45
	jsr	jmpne_ir1_ix

LINE_27

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; FOR T=1 TO 6

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

	; IF B(T) THEN

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#LINE_28
	jsr	jmpeq_ir1_ix

	; NEXT

	jsr	next

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_28

	; SOUND 230,1

	ldab	#230
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOSUB 400

	ldx	#LINE_400
	jsr	gosub_ix

	; T=6

	ldx	#INTVAR_T
	ldab	#6
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_45

	; IF K>5 THEN

	ldab	#5
	ldx	#INTVAR_K
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_46
	jsr	jmpeq_ir1_ix

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; GOTO 27

	ldx	#LINE_27
	jsr	goto_ix

LINE_46

	; IF A THEN

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#LINE_50
	jsr	jmpeq_ir1_ix

	; K=A

	ldd	#INTVAR_K
	ldx	#INTVAR_A
	jsr	ld_id_ix

	; Y+=1

	ldx	#INTVAR_Y
	jsr	inc_ix_ix

LINE_50

	; Y-=1

	ldx	#INTVAR_Y
	jsr	dec_ix_ix

	; IF X(1)=X THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_X
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_52
	jsr	jmpeq_ir1_ix

	; IF Y(1)=Y THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_52
	jsr	jmpeq_ir1_ix

	; IF A(1)<>0 THEN

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix_ir1

	ldx	#LINE_52
	jsr	jmpeq_ir1_ix

	; A(1)=0

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; B(1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; GOTO 58

	ldx	#LINE_58
	jsr	goto_ix

LINE_52

	; IF X(2)=X THEN

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_X
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_53
	jsr	jmpeq_ir1_ix

	; IF Y(2)=Y THEN

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_53
	jsr	jmpeq_ir1_ix

	; IF A(2)<>0 THEN

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix_ir1

	ldx	#LINE_53
	jsr	jmpeq_ir1_ix

	; A(2)=0

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; B(2)=1

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; GOTO 58

	ldx	#LINE_58
	jsr	goto_ix

LINE_53

	; IF X(3)=X THEN

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_X
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_54
	jsr	jmpeq_ir1_ix

	; IF Y(3)=Y THEN

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_54
	jsr	jmpeq_ir1_ix

	; IF A(3)<>0 THEN

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix_ir1

	ldx	#LINE_54
	jsr	jmpeq_ir1_ix

	; A(3)=0

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; B(3)=1

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; GOTO 58

	ldx	#LINE_58
	jsr	goto_ix

LINE_54

	; IF X(4)=X THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_X
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_55
	jsr	jmpeq_ir1_ix

	; IF Y(4)=Y THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_55
	jsr	jmpeq_ir1_ix

	; IF A(4)<>0 THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix_ir1

	ldx	#LINE_55
	jsr	jmpeq_ir1_ix

	; A(4)=0

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; B(4)=1

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; GOTO 58

	ldx	#LINE_58
	jsr	goto_ix

LINE_55

	; IF X(5)=X THEN

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_X
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_56
	jsr	jmpeq_ir1_ix

	; IF Y(5)=Y THEN

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_56
	jsr	jmpeq_ir1_ix

	; IF A(5)<>0 THEN

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrval1_ir1_ix_ir1

	ldx	#LINE_56
	jsr	jmpeq_ir1_ix

	; A(5)=0

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	jsr	clr_ip

	; B(5)=1

	ldab	#5
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; GOTO 58

	ldx	#LINE_58
	jsr	goto_ix

LINE_56

	; IF X(6)=X THEN

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_X
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_58
	jsr	jmpeq_ir1_ix

	; IF Y(6)=Y THEN

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir1_ix_ir1

	ldx	#INTVAR_Y
	jsr	ldeq_ir1_ir1_ix

	ldx	#LINE_58
	jsr	jmpeq_ir1_ix

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(M)=0

	ldx	#INTARR_A
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SC+=50

	ldx	#INTVAR_SC
	ldab	#50
	jsr	add_ix_ix_pb

	; GOTO 70

	ldx	#LINE_70
	jsr	goto_ix

LINE_58

	; GOSUB 610

	ldx	#LINE_610
	jsr	gosub_ix

	; RESET(X,Y+1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	inc_ir2_ix

	jsr	reset_ir1_ir2

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; GOTO 27

	ldx	#LINE_27
	jsr	goto_ix

LINE_60

	; A(T)=0

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; B(T)=0

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SET(X+A,Y+B,4)

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

LINE_61

	; D+=1

	ldx	#INTVAR_D
	jsr	inc_ix_ix

	; GOSUB 500

	ldx	#LINE_500
	jsr	gosub_ix

	; SOUND 50,2

	ldab	#50
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 100,2

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X+A,Y+B,8)

	ldx	#INTVAR_X
	ldd	#INTVAR_A
	jsr	add_ir1_ix_id

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	add_ir2_ix_id

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; WHEN D=5 GOTO 65

	ldx	#INTVAR_D
	ldab	#5
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_65
	jsr	jmpne_ir1_ix

LINE_62

	; GOTO 27

	ldx	#LINE_27
	jsr	goto_ix

LINE_65

	; T=6

	ldx	#INTVAR_T
	ldab	#6
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; Q=L

	ldd	#INTVAR_Q
	ldx	#INTVAR_L
	jsr	ld_id_ix

	; NEXT

	jsr	next

	; PRINT @235, "GAME OVER";

	ldab	#235
	jsr	prat_pb

	jsr	pr_ss
	.text	9, "GAME OVER"

	; GOTO 700

	ldx	#LINE_700
	jsr	goto_ix

LINE_70

	; T=6

	ldx	#INTVAR_T
	ldab	#6
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; Q=L

	ldd	#INTVAR_Q
	ldx	#INTVAR_L
	jsr	ld_id_ix

	; NEXT

	jsr	next

	; GOSUB 610

	ldx	#LINE_610
	jsr	gosub_ix

	; SET(X(6),Y(6),4)

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrval1_ir1_ix_ir1

	ldab	#6
	jsr	ld_ir2_pb

	ldx	#INTARR_Y
	jsr	arrval1_ir2_ix_ir2

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; PRINT @235, "NEW JAIL!";

	ldab	#235
	jsr	prat_pb

	jsr	pr_ss
	.text	9, "NEW JAIL!"

LINE_71

	; D-=1

	ldx	#INTVAR_D
	jsr	dec_ix_ix

	; IF D<1 THEN

	ldx	#INTVAR_D
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_72
	jsr	jmpeq_ir1_ix

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

LINE_72

	; GOSUB 500

	ldx	#LINE_500
	jsr	gosub_ix

	; FOR K=1 TO 15000

	ldx	#INTVAR_K
	jsr	forone_ix

	ldd	#15000
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; GOTO 175

	ldx	#LINE_175
	jsr	goto_ix

LINE_80

	; WHEN A=0 GOTO 23

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#LINE_23
	jsr	jmpeq_ir1_ix

LINE_81

	; FOR K=10 TO 15

	ldx	#INTVAR_K
	ldab	#10
	jsr	for_ix_pb

	ldab	#15
	jsr	to_ip_pb

	; IF (ABS(X-X(K))>1) OR (ABS(Y-Y(K))>1) THEN

	ldx	#INTARR_X
	ldd	#INTVAR_K
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	rsub_ir1_ir1_ix

	jsr	abs_ir1_ir1

	ldab	#1
	jsr	ldlt_ir1_pb_ir1

	ldx	#INTARR_Y
	ldd	#INTVAR_K
	jsr	arrval1_ir2_ix_id

	ldx	#INTVAR_Y
	jsr	rsub_ir2_ir2_ix

	jsr	abs_ir2_ir2

	ldab	#1
	jsr	ldlt_ir2_pb_ir2

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_82
	jsr	jmpeq_ir1_ix

	; NEXT

	jsr	next

	; GOTO 22

	ldx	#LINE_22
	jsr	goto_ix

LINE_82

	; A(T)=0

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; B(T)=1

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	one_ip

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(K)=0

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; RESET(X(K),Y(K))

	ldx	#INTARR_X
	ldd	#INTVAR_K
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_Y
	ldd	#INTVAR_K
	jsr	arrval1_ir2_ix_id

	jsr	reset_ir1_ir2

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; K=15

	ldx	#INTVAR_K
	ldab	#15
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; IF T=6 THEN

	ldx	#INTVAR_T
	ldab	#6
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_83
	jsr	jmpeq_ir1_ix

	; SC+=30

	ldx	#INTVAR_SC
	ldab	#30
	jsr	add_ix_ix_pb

	; GOTO 70

	ldx	#LINE_70
	jsr	goto_ix

LINE_83

	; GOTO 58

	ldx	#LINE_58
	jsr	goto_ix

LINE_90

	; FOR K=1 TO 6

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

	; IF (X(K)<>X) OR (Y(K)<>Y) THEN

	ldx	#INTARR_X
	ldd	#INTVAR_K
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_X
	jsr	ldne_ir1_ir1_ix

	ldx	#INTARR_Y
	ldd	#INTVAR_K
	jsr	arrval1_ir2_ix_id

	ldx	#INTVAR_Y
	jsr	ldne_ir2_ir2_ix

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_91
	jsr	jmpeq_ir1_ix

	; NEXT

	jsr	next

	; GOTO 26

	ldx	#LINE_26
	jsr	goto_ix

LINE_91

	; SET(X,Y,4)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#4
	jsr	setc_ir1_ir2_pb

	; SC+=20

	ldx	#INTVAR_SC
	ldab	#20
	jsr	add_ix_ix_pb

	; SOUND 1,2

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#2
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOSUB 610

	ldx	#LINE_610
	jsr	gosub_ix

	; A(K)=0

	ldx	#INTARR_A
	ldd	#INTVAR_K
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; B(K)=0

	ldx	#INTARR_B
	ldd	#INTVAR_K
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; X(K)=0

	ldx	#INTARR_X
	ldd	#INTVAR_K
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; Y(K)=0

	ldx	#INTARR_Y
	ldd	#INTVAR_K
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; K+=6

	ldx	#INTVAR_K
	ldab	#6
	jsr	add_ix_ix_pb

	; NEXT

	jsr	next

	; IF K=13 THEN

	ldx	#INTVAR_K
	ldab	#13
	jsr	ldeq_ir1_ix_pb

	ldx	#LINE_92
	jsr	jmpeq_ir1_ix

	; SC+=30

	ldx	#INTVAR_SC
	ldab	#30
	jsr	add_ix_ix_pb

	; GOTO 70

	ldx	#LINE_70
	jsr	goto_ix

LINE_92

	; GOTO 61

	ldx	#LINE_61
	jsr	goto_ix

LINE_100

	; CLS

	jsr	cls

	; DIM X,Y,A,B,T,V(1),X(15),Y(15),A(15),B(15),K,I,J,Z,S,M,Q,L,R

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrdim1_ir1_ix

	ldab	#15
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrdim1_ir1_ix

	ldab	#15
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrdim1_ir1_ix

	ldab	#15
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrdim1_ir1_ix

	ldab	#15
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrdim1_ir1_ix

	; V(0)=-1

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	jsr	true_ip

	; V(1)=1

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_V
	jsr	arrref1_ir1_ix_ir1

	jsr	one_ip

LINE_110

	; HS=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_HS
	jsr	ld_fx_fr1

	; R=60

	ldx	#INTVAR_R
	ldab	#60
	jsr	ld_ix_pb

	; HS=0

	ldx	#FLTVAR_HS
	jsr	clr_fx

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; POKE 49151,64

	ldab	#64
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; GOSUB 990

	ldx	#LINE_990
	jsr	gosub_ix

LINE_150

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; POKE 49151,0

	ldab	#0
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; CLS

	jsr	cls

	; SC=0

	ldx	#INTVAR_SC
	jsr	clr_ix

	; L=140

	ldx	#INTVAR_L
	ldab	#140
	jsr	ld_ix_pb

	; LL=2

	ldx	#INTVAR_LL
	ldab	#2
	jsr	ld_ix_pb

	; M$="^^^€€€€"

	jsr	ld_sr1_ss
	.text	7, "^^^\x80\x80\x80\x80"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; D=1

	ldx	#INTVAR_D
	jsr	one_ix

LINE_175

	; L-=10

	ldx	#INTVAR_L
	ldab	#10
	jsr	sub_ix_ix_pb

	; IF L<50 THEN

	ldx	#INTVAR_L
	ldab	#50
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_200
	jsr	jmpeq_ir1_ix

	; L=50

	ldx	#INTVAR_L
	ldab	#50
	jsr	ld_ix_pb

LINE_200

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; GOSUB 300

	ldx	#LINE_300
	jsr	gosub_ix

	; FOR X=1 TO 62

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#62
	jsr	to_ip_pb

	; SET(X,1,6)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; SET(X,28,6)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldab	#28
	jsr	ld_ir2_pb

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

LINE_205

	; FOR Y=1 TO 31

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#31
	jsr	to_ip_pb

	; SET(0,Y,6)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; SET(1,Y,6)

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; SET(62,Y,6)

	ldab	#62
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; SET(63,Y,6)

	ldab	#63
	jsr	ld_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#6
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

LINE_210

	; FOR T=1 TO 15

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#15
	jsr	to_ip_pb

	; X(T)=0

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; Y(T)=0

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; A(T)=0

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; B(T)=0

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	jsr	clr_ip

	; NEXT

	jsr	next

	; GOSUB 500

	ldx	#LINE_500
	jsr	gosub_ix

	; GOSUB 600

	ldx	#LINE_600
	jsr	gosub_ix

LINE_215

	; LL+=1

	ldx	#INTVAR_LL
	jsr	inc_ix_ix

	; IF LL>6 THEN

	ldab	#6
	ldx	#INTVAR_LL
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_220
	jsr	jmpeq_ir1_ix

	; LL=6

	ldx	#INTVAR_LL
	ldab	#6
	jsr	ld_ix_pb

LINE_220

	; FOR T=1 TO LL

	ldx	#INTVAR_T
	jsr	forone_ix

	ldx	#INTVAR_LL
	jsr	to_ip_ix

	; GOSUB 400

	ldx	#LINE_400
	jsr	gosub_ix

	; NEXT

	jsr	next

LINE_225

	; X(6)=RND(5)+28

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_X
	jsr	arrref1_ir1_ix_ir1

	ldab	#5
	jsr	irnd_ir1_pb

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

	; Y(6)=10

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_Y
	jsr	arrref1_ir1_ix_ir1

	ldab	#10
	jsr	ld_ip_pb

	; A(6)=V(RND(2)-1)

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_A
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	dec_ir1_ir1

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; B(6)=V(RND(2)-1)

	ldab	#6
	jsr	ld_ir1_pb

	ldx	#INTARR_B
	jsr	arrref1_ir1_ix_ir1

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	dec_ir1_ir1

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

LINE_230

	; I=31

	ldx	#INTVAR_I
	ldab	#31
	jsr	ld_ix_pb

	; J=26

	ldx	#INTVAR_J
	ldab	#26
	jsr	ld_ix_pb

	; SET(I,J,8)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	ld_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; SET(I-1,J+1,8)

	ldx	#INTVAR_I
	jsr	dec_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; SET(I,J+1,8)

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; SET(I+1,J+1,8)

	ldx	#INTVAR_I
	jsr	inc_ir1_ix

	ldx	#INTVAR_J
	jsr	inc_ir2_ix

	ldab	#8
	jsr	setc_ir1_ir2_pb

	; Z=9

	ldx	#INTVAR_Z
	ldab	#9
	jsr	ld_ix_pb

LINE_240

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_300

	; J=3

	ldx	#INTVAR_J
	ldab	#3
	jsr	ld_ix_pb

	; PRINT @SHIFT(J,5)+6, "ïïïïïïïïïïïïïïïïïïï";

	ldx	#INTVAR_J
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldab	#6
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	19, "\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF"

LINE_310

	; PRINT @SHIFT(J+1,5)+6, "ï€€€€€€€€€€€€€€€€€ï";

	ldx	#INTVAR_J
	jsr	inc_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldab	#6
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	19, "\xEF\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xEF"

LINE_320

	; PRINT @SHIFT(J+2,5)+6, "ï€€€€€€€€€€€€€€€€€ï";

	ldx	#INTVAR_J
	ldab	#2
	jsr	add_ir1_ix_pb

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldab	#6
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	19, "\xEF\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xEF"

LINE_330

	; PRINT @SHIFT(J+3,5)+6, "ïïïïïïïïïïïïïïïïïïï";

	ldx	#INTVAR_J
	ldab	#3
	jsr	add_ir1_ix_pb

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldab	#6
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	19, "\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF"

	; RETURN

	jsr	return

LINE_400

	; X(T)=RND(56)+3

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#56
	jsr	irnd_ir1_pb

	ldab	#3
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

	; Y(T)=RND(8)+15

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#8
	jsr	irnd_ir1_pb

	ldab	#15
	jsr	add_ir1_ir1_pb

	jsr	ld_ip_ir1

	; A(T)=V(RND(2)-1)

	ldx	#INTARR_A
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	dec_ir1_ir1

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; B(T)=V(RND(2)-1)

	ldx	#INTARR_B
	ldd	#INTVAR_T
	jsr	arrref1_ir1_ix_id

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	dec_ir1_ir1

	ldx	#INTARR_V
	jsr	arrval1_ir1_ix_ir1

	jsr	ld_ip_ir1

	; RESTORE

	jsr	restore

	; FOR K=1 TO 8

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; READ A,B

	ldx	#INTVAR_A
	jsr	read_ix

	ldx	#INTVAR_B
	jsr	read_ix

	; SET(X(T)+A,Y(T)+B,0)

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	ldx	#INTVAR_B
	jsr	add_ir2_ir2_ix

	ldab	#0
	jsr	setc_ir1_ir2_pb

	; NEXT

	jsr	next

LINE_410

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 240,1

	ldab	#240
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 235,1

	ldab	#235
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; RESTORE

	jsr	restore

	; FOR K=1 TO 8

	ldx	#INTVAR_K
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; READ A,B

	ldx	#INTVAR_A
	jsr	read_ix

	ldx	#INTVAR_B
	jsr	read_ix

	; RESET(X(T)+A,Y(T)+B)

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_A
	jsr	add_ir1_ir1_ix

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	ldx	#INTVAR_B
	jsr	add_ir2_ir2_ix

	jsr	reset_ir1_ir2

	; NEXT

	jsr	next

	; SET(X(T),Y(T),0)

	ldx	#INTARR_X
	ldd	#INTVAR_T
	jsr	arrval1_ir1_ix_id

	ldx	#INTARR_Y
	ldd	#INTVAR_T
	jsr	arrval1_ir2_ix_id

	ldab	#0
	jsr	setc_ir1_ir2_pb

	; RETURN

	jsr	return

LINE_500

	; PRINT @482, MID$(M$,D,3);

	ldd	#482
	jsr	prat_pw

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_D
	jsr	ld_ir2_ix

	ldab	#3
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_600

	; IF SC>HS THEN

	ldx	#FLTVAR_HS
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_fx_id

	ldx	#LINE_605
	jsr	jmpeq_ir1_ix

	; HS=SC

	ldd	#FLTVAR_HS
	ldx	#INTVAR_SC
	jsr	ld_fd_ix

LINE_605

	; PRINT @486, "HIGH";STR$(HS);" ";

	ldd	#486
	jsr	prat_pw

	jsr	pr_ss
	.text	4, "HIGH"

	ldx	#FLTVAR_HS
	jsr	str_sr1_fx

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

LINE_610

	; PRINT @498, "SCORE";STR$(SC);" ";

	ldd	#498
	jsr	prat_pw

	jsr	pr_ss
	.text	5, "SCORE"

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; RETURN

	jsr	return

LINE_700

	; GOSUB 600

	ldx	#LINE_600
	jsr	gosub_ix

	; PRINT @295, "PLAY AGAIN (Y/N)?";

	ldd	#295
	jsr	prat_pw

	jsr	pr_ss
	.text	17, "PLAY AGAIN (Y/N)?"

LINE_710

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 710

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_710
	jsr	jmpne_ir1_ix

LINE_720

	; WHEN M$="Y" GOTO 150

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_150
	jsr	jmpne_ir1_ix

LINE_730

	; IF M$="N" THEN

	ldx	#STRVAR_M
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_740
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_740

	; GOTO 710

	ldx	#LINE_710
	jsr	goto_ix

LINE_900

LINE_990

	; CLS

	jsr	cls

	; PRINT @448,

	ldd	#448
	jsr	prat_pw

	; M=16384

	ldx	#INTVAR_M
	ldd	#16384
	jsr	ld_ix_pw

LINE_1000

	; M$="         GALAXY JAILBREAK       "

	jsr	ld_sr1_ss
	.text	32, "         GALAXY JAILBREAK       "

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT @480, "\r";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @448,

	ldd	#448
	jsr	prat_pw

LINE_1010

	; PRINT " BY ROLAND STOKES & JIM GERRIE\r";

	jsr	pr_ss
	.text	31, " BY ROLAND STOKES & JIM GERRIE\r"

LINE_1020

	; M$="THEME:"

	jsr	ld_sr1_ss
	.text	6, "THEME:"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1030

	; PRINT "YOU HAVE CAPTURED SOME EVIL\r";

	jsr	pr_ss
	.text	28, "YOU HAVE CAPTURED SOME EVIL\r"

LINE_1040

	; PRINT "ALIEN GENERALS. HOWEVER THEIR\r";

	jsr	pr_ss
	.text	30, "ALIEN GENERALS. HOWEVER THEIR\r"

LINE_1050

	; PRINT "SOLDIERS ARE ATTEMPTING TO FREE\r";

	jsr	pr_ss
	.text	32, "SOLDIERS ARE ATTEMPTING TO FREE\r"

LINE_1060

	; PRINT "THEM BY WARPING INTO THE AREA\r";

	jsr	pr_ss
	.text	30, "THEM BY WARPING INTO THE AREA\r"

LINE_1070

	; PRINT "AND ATTACKING THE JAIL.\r";

	jsr	pr_ss
	.text	24, "AND ATTACKING THE JAIL.\r"

LINE_1080

	; M$="OBJECT:"

	jsr	ld_sr1_ss
	.text	7, "OBJECT:"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1090

	; PRINT "DEFEND THE JAIL. YOU CONTROL A\r";

	jsr	pr_ss
	.text	31, "DEFEND THE JAIL. YOU CONTROL A\r"

LINE_1100

	; PRINT "MISSILE LAUNCHER WHICH CAN FIRE\r";

	jsr	pr_ss
	.text	32, "MISSILE LAUNCHER WHICH CAN FIRE\r"

LINE_1110

	; PRINT "6 SHOTS AT A TIME. WHEN HIT,\r";

	jsr	pr_ss
	.text	29, "6 SHOTS AT A TIME. WHEN HIT,\r"

LINE_1120

	; PRINT "THE ENEMY WILL DIVE ON YOU.\r";

	jsr	pr_ss
	.text	28, "THE ENEMY WILL DIVE ON YOU.\r"

LINE_1130

	; PRINT "HOLD THE GENERAL AS LONG AS YOU\r";

	jsr	pr_ss
	.text	32, "HOLD THE GENERAL AS LONG AS YOU\r"

LINE_1140

	; PRINT "CAN BY KILLING SOLDIERS.\r";

	jsr	pr_ss
	.text	25, "CAN BY KILLING SOLDIERS.\r"

LINE_1150

	; GOSUB 1500

	ldx	#LINE_1500
	jsr	gosub_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1200

	; M$="THE KEYS USED ARE:"

	jsr	ld_sr1_ss
	.text	18, "THE KEYS USED ARE:"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1210

	; PRINT "  A     = LEFT.\r";

	jsr	pr_ss
	.text	16, "  A     = LEFT.\r"

LINE_1220

	; PRINT "  D     = RIGHT.\r";

	jsr	pr_ss
	.text	17, "  D     = RIGHT.\r"

LINE_1230

	; PRINT "  SPACE = FIRE.\r";

	jsr	pr_ss
	.text	16, "  SPACE = FIRE.\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1240

	; PRINT "EACH GENERAL SCORES 50.\r";

	jsr	pr_ss
	.text	24, "EACH GENERAL SCORES 50.\r"

LINE_1250

	; PRINT "EACH SOLDIER SCORES 20.\r";

	jsr	pr_ss
	.text	24, "EACH SOLDIER SCORES 20.\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1260

	; PRINT "EACH GENERAL THAT IS KILLED\r";

	jsr	pr_ss
	.text	28, "EACH GENERAL THAT IS KILLED\r"

LINE_1270

	; PRINT "WILL SWITCH YOU TO A NEW JAIL\r";

	jsr	pr_ss
	.text	30, "WILL SWITCH YOU TO A NEW JAIL\r"

LINE_1280

	; PRINT "WITH EVEN MORE FANATIC SOLDIERS.";

	jsr	pr_ss
	.text	32, "WITH EVEN MORE FANATIC SOLDIERS."

LINE_1290

	; PRINT "YOU GET AN ADDED LIFE FOR EVERY\r";

	jsr	pr_ss
	.text	32, "YOU GET AN ADDED LIFE FOR EVERY\r"

	; PRINT "NEW JAIL.\r";

	jsr	pr_ss
	.text	10, "NEW JAIL.\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1500

	; PRINT @480,

	ldd	#480
	jsr	prat_pw

	; M$="       ANY KEY TO CONTINUE     "

	jsr	ld_sr1_ss
	.text	31, "       ANY KEY TO CONTINUE     "

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; POKE M+511,32

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldab	#32
	jsr	poke_ir1_pb

	; FOR X=1 TO 25

	ldx	#INTVAR_X
	jsr	forone_ix

	ldab	#25
	jsr	to_ip_pb

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; NEXT

	jsr	next

LINE_1510

	; WHEN INKEY$="" GOTO 1510

	jsr	inkey_sr1

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_1510
	jsr	jmpne_ir1_ix

LINE_1520

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; RETURN

	jsr	return

LINE_2000

	; X=POS+M-1

	jsr	pos_ir1

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	dec_ir1_ir1

	ldx	#INTVAR_X
	jsr	ld_ix_ir1

	; FOR Y=1 TO LEN(M$)

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldx	#STRVAR_M
	jsr	len_ir1_sx

	jsr	to_ip_ir1

	; A=ASC(MID$(M$,Y))

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	ldx	#INTVAR_Y
	jsr	mid_sr1_sr1_ix

	jsr	asc_ir1_sr1

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; POKE X+Y,A-(A AND 64)

	ldx	#INTVAR_X
	ldd	#INTVAR_Y
	jsr	add_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldab	#64
	jsr	and_ir2_ir2_pb

	ldx	#INTVAR_A
	jsr	rsub_ir2_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT

	jsr	next

	; PRINT @X+Y-M,

	ldx	#INTVAR_X
	ldd	#INTVAR_Y
	jsr	add_ir1_ix_id

	ldx	#INTVAR_M
	jsr	sub_ir1_ir1_ix

	jsr	prat_ir1

	; RETURN

	jsr	return

LINE_2010

	; REM INSPIRED BY SINCLAIR

LINE_2020

	; REM ZX81 GAME. 2021

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

abs_ir2_ir2			; numCalls = 1
	.module	modabs_ir2_ir2
	ldaa	r2
	bpl	_rts
	ldx	#r2
	jmp	negxi
_rts
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

add_ir1_ir1_pb			; numCalls = 7
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 9
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

add_ir1_ix_pb			; numCalls = 3
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

add_ir2_ir2_ix			; numCalls = 2
	.module	modadd_ir2_ir2_ix
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ir2_ix_id			; numCalls = 7
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

add_ix_ix_ir1			; numCalls = 2
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 11
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

and_ir2_ir2_pb			; numCalls = 1
	.module	modand_ir2_ir2_pb
	andb	r2+2
	clra
	std	r2+1
	staa	r2
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

arrref1_ir1_ix_id			; numCalls = 35
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 16
	.module	modarrref1_ir1_ix_ir1
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 15
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

arrval1_ir1_ix_ir1			; numCalls = 24
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

arrval1_ir2_ix_id			; numCalls = 6
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

arrval1_ir2_ix_ir2			; numCalls = 1
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

clr_ip			; numCalls = 27
	.module	modclr_ip
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 6
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 3
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 3
	.module	modclsn_pb
	jmp	R_CLSN

com_ir2_ir2			; numCalls = 3
	.module	modcom_ir2_ir2
	com	r2+2
	com	r2+1
	com	r2
	rts

dec_ir1_ir1			; numCalls = 5
	.module	moddec_ir1_ir1
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 8
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 3
	.module	moddec_ir2_ix
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 4
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_ix_pb			; numCalls = 1
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forone_ix			; numCalls = 13
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 18
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 31
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_ir1_ix			; numCalls = 10
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir2_ix			; numCalls = 14
	.module	modinc_ir2_ix
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 5
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

irnd_ir1_pb			; numCalls = 7
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 41
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

jmpne_ir1_ix			; numCalls = 12
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

ld_fd_ix			; numCalls = 1
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

ld_fx_fr1			; numCalls = 1
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_id_ix			; numCalls = 3
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

ld_ip_pb			; numCalls = 1
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 57
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 62
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 29
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 18
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 20
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

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sr1_ss			; numCalls = 6
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 2
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 6
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ix			; numCalls = 12
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

ldeq_ir1_ir1_pb			; numCalls = 2
	.module	modldeq_ir1_ir1_pb
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ix_pb			; numCalls = 7
	.module	modldeq_ir1_ix_pb
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 1
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

ldlt_ir1_fx_id			; numCalls = 1
	.module	modldlt_ir1_fx_id
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

ldne_ir2_ir2_ix			; numCalls = 1
	.module	modldne_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	getne
	std	r2+1
	stab	r2
	rts

len_ir1_sx			; numCalls = 1
	.module	modlen_ir1_sx
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

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

mid_sr1_sr1_ix			; numCalls = 1
	.module	modmid_sr1_sr1_ix
	ldd	0,x
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	2,x
	beq	_fc_error
	ldab	r1
	incb
	subb	2,x
	bls	_zero
	stab	r1
	ldd	1,x
	subd	#1
	addd	r1+1
	std	r1+1
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

mul_ir1_ir1_ix			; numCalls = 2
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

neg_ir1_ir1			; numCalls = 3
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

neg_ix_ix			; numCalls = 2
	.module	modneg_ix_ix
	jmp	negxi

next			; numCalls = 21
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

one_ip			; numCalls = 8
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

or_ir1_ir1_ix			; numCalls = 2
	.module	modor_ir1_ir1_ix
	ldd	1,x
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	0,x
	orab	r1
	stab	r1
	rts

peek_ir1_pb			; numCalls = 3
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
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

point_ir1_ir1_ir2			; numCalls = 8
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

poke_ir1_ir2			; numCalls = 1
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 1
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_pw_ir1			; numCalls = 4
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pos_ir1			; numCalls = 1
	.module	modpos_ir1
	ldd	M_CRSR
	anda	#1
	std	r1+1
	clrb
	stab	r1
	rts

pr_sr1			; numCalls = 3
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 45
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

prat_pb			; numCalls = 2
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 8
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

read_ix			; numCalls = 4
	.module	modread_ix
	jsr	rpsbyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

reset_ir1_ir2			; numCalls = 6
	.module	modreset_ir1_ir2
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

reset_ir1_ix			; numCalls = 9
	.module	modreset_ir1_ix
	ldaa	2,x
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

restore			; numCalls = 2
	.module	modrestore
	ldx	#startdata
	stx	DP_DATA
	rts

return			; numCalls = 6
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

rsub_ir1_ir1_ix			; numCalls = 1
	.module	modrsub_ir1_ir1_ix
	ldd	1,x
	subd	r1+1
	std	r1+1
	ldab	0,x
	sbcb	r1
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

setc_ir1_ir2_pb			; numCalls = 44
	.module	modsetc_ir1_ir2_pb
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

shift_ir1_ir1_pb			; numCalls = 4
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 15
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

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

str_sr1_ix			; numCalls = 1
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

sub_ir1_ir1_ix			; numCalls = 1
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ix_ix_pb			; numCalls = 1
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

to_ip_ir1			; numCalls = 1
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

to_ip_pb			; numCalls = 10
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

true_ip			; numCalls = 1
	.module	modtrue_ip
	ldx	letptr
	ldd	#-1
	stab	0,x
	std	1,x
	rts

; data table
startdata
	.byte	-2, -2, 2, -2, -2, 2
	.byte	2, 2, -1, -1, 1, -1
	.byte	-1, 1, 1, 1
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_D	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_LL	.block	3
INTVAR_M	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_T	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
FLTVAR_HS	.block	5
; String Variables
STRVAR_M	.block	3
; Numeric Arrays
INTARR_A	.block	4	; dims=1
INTARR_B	.block	4	; dims=1
INTARR_V	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

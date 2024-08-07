; Assembly for life.bas
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

	; CLS

	jsr	cls

	; PRINT "WAIT...\r";

	jsr	pr_ss
	.text	8, "WAIT...\r"

	; DIM A(29,63),L(1,8),X,Y,A,C,B,D,H,J,I,K,NO,W,Z,L,M,P,O,Q,GN,P2,MC

	ldab	#29
	jsr	ld_ir1_pb

	ldab	#63
	jsr	ld_ir2_pb

	ldx	#INTARR_A
	jsr	arrdim2_ir1_ix

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#8
	jsr	ld_ir2_pb

	ldx	#INTARR_L
	jsr	arrdim2_ir1_ix

	; GOTO 1000

	ldx	#LINE_1000
	jsr	goto_ix

LINE_2

	; A(Y,X)=1

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; RETURN

	jsr	return

LINE_3

	; A(Y,X)=0

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	jsr	clr_ip

	; RETURN

	jsr	return

LINE_4

	; SET(X,Y,W)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_W
	jsr	setc_ir1_ir2_ix

	; RETURN

	jsr	return

LINE_5

	; A=X-W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; IF A=Q THEN

	ldx	#INTVAR_A
	ldd	#INTVAR_Q
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_6
	jsr	jmpeq_ir1_ix

	; A=H

	ldd	#INTVAR_A
	ldx	#INTVAR_H
	jsr	ld_id_ix

LINE_6

	; C=X+W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; IF C=L THEN

	ldx	#INTVAR_C
	ldd	#INTVAR_L
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_7
	jsr	jmpeq_ir1_ix

	; C=Z

	ldd	#INTVAR_C
	ldx	#INTVAR_Z
	jsr	ld_id_ix

LINE_7

	; B=Y-W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; IF B=Q THEN

	ldx	#INTVAR_B
	ldd	#INTVAR_Q
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_8
	jsr	jmpeq_ir1_ix

	; B=I

	ldd	#INTVAR_B
	ldx	#INTVAR_I
	jsr	ld_id_ix

LINE_8

	; D=Y+W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; IF D=M THEN

	ldx	#INTVAR_D
	ldd	#INTVAR_M
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_9
	jsr	jmpeq_ir1_ix

	; D=Z

	ldd	#INTVAR_D
	ldx	#INTVAR_Z
	jsr	ld_id_ix

LINE_9

	; ON L(POINT(X,Y),POINT(A,B)+POINT(X,B)+POINT(C,B)+POINT(A,Y)+POINT(C,Y)+POINT(A,D)+POINT(X,D)+POINT(C,D)) GOTO 2,3

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	point_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#INTVAR_B
	jsr	point_ir2_ir2_ix

	ldx	#INTVAR_X
	jsr	ld_ir3_ix

	ldx	#INTVAR_B
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_C
	jsr	ld_ir3_ix

	ldx	#INTVAR_B
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_A
	jsr	ld_ir3_ix

	ldx	#INTVAR_Y
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_C
	jsr	ld_ir3_ix

	ldx	#INTVAR_Y
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_A
	jsr	ld_ir3_ix

	ldx	#INTVAR_D
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_X
	jsr	ld_ir3_ix

	ldx	#INTVAR_D
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_C
	jsr	ld_ir3_ix

	ldx	#INTVAR_D
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTARR_L
	jsr	arrval2_ir1_ix_ir2

	jsr	ongoto_ir1_is
	.byte	2
	.word	LINE_2, LINE_3

	; RETURN

	jsr	return

LINE_20

	; I$="GENERATION: 0              �"

	jsr	ld_sr1_ss
	.text	28, "GENERATION: 0              \xC0"

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; PRINT @P2, I$;

	ldx	#INTVAR_P2
	jsr	prat_ix

	ldx	#STRVAR_I
	jsr	pr_sx

LINE_24

	; X=Z

	ldd	#INTVAR_X
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; A=H

	ldd	#INTVAR_A
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; C=X+W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; FOR Y=W TO P

	ldd	#INTVAR_Y
	ldx	#INTVAR_W
	jsr	for_id_ix

	ldx	#INTVAR_P
	jsr	to_ip_ix

	; B=Y-W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; D=Y+W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; NEXT

	jsr	next

	; X=H

	ldd	#INTVAR_X
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; A=X-W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; C=Z

	ldd	#INTVAR_C
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; FOR Y=W TO P

	ldd	#INTVAR_Y
	ldx	#INTVAR_W
	jsr	for_id_ix

	ldx	#INTVAR_P
	jsr	to_ip_ix

	; B=Y-W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; D=Y+W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; NEXT

	jsr	next

LINE_26

	; Y=Z

	ldd	#INTVAR_Y
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; B=I

	ldd	#INTVAR_B
	ldx	#INTVAR_I
	jsr	ld_id_ix

	; D=Y+W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

	; FOR X=W TO O

	ldd	#INTVAR_X
	ldx	#INTVAR_W
	jsr	for_id_ix

	ldx	#INTVAR_O
	jsr	to_ip_ix

	; A=X-W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; C=X+W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; NEXT

	jsr	next

	; Y=I

	ldd	#INTVAR_Y
	ldx	#INTVAR_I
	jsr	ld_id_ix

	; B=Y-W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; D=Z

	ldd	#INTVAR_D
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; FOR X=W TO O

	ldd	#INTVAR_X
	ldx	#INTVAR_W
	jsr	for_id_ix

	ldx	#INTVAR_O
	jsr	to_ip_ix

	; A=X-W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; C=X+W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; NEXT

	jsr	next

LINE_28

	; X=Z

	ldd	#INTVAR_X
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; Y=Z

	ldd	#INTVAR_Y
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; GOSUB 5

	ldx	#LINE_5
	jsr	gosub_ix

	; Y=I

	ldd	#INTVAR_Y
	ldx	#INTVAR_I
	jsr	ld_id_ix

	; GOSUB 5

	ldx	#LINE_5
	jsr	gosub_ix

	; X=H

	ldd	#INTVAR_X
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; GOSUB 5

	ldx	#LINE_5
	jsr	gosub_ix

	; Y=Z

	ldd	#INTVAR_Y
	ldx	#INTVAR_Z
	jsr	ld_id_ix

	; GOSUB 5

	ldx	#LINE_5
	jsr	gosub_ix

LINE_29

	; FOR Y=W TO P

	ldd	#INTVAR_Y
	ldx	#INTVAR_W
	jsr	for_id_ix

	ldx	#INTVAR_P
	jsr	to_ip_ix

	; FOR X=W TO O

	ldd	#INTVAR_X
	ldx	#INTVAR_W
	jsr	for_id_ix

	ldx	#INTVAR_O
	jsr	to_ip_ix

	; A=X-W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; C=X+W

	ldx	#INTVAR_X
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; B=Y-W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_B
	jsr	ld_ix_ir1

	; D=Y+W

	ldx	#INTVAR_Y
	ldd	#INTVAR_W
	jsr	add_ir1_ix_id

	ldx	#INTVAR_D
	jsr	ld_ix_ir1

LINE_30

	; ON L(POINT(X,Y),POINT(A,B)+POINT(X,B)+POINT(C,B)+POINT(A,Y)+POINT(C,Y)+POINT(A,D)+POINT(X,D)+POINT(C,D)) GOSUB 2,3

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	point_ir1_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ir2_ix

	ldx	#INTVAR_B
	jsr	point_ir2_ir2_ix

	ldx	#INTVAR_X
	jsr	ld_ir3_ix

	ldx	#INTVAR_B
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_C
	jsr	ld_ir3_ix

	ldx	#INTVAR_B
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_A
	jsr	ld_ir3_ix

	ldx	#INTVAR_Y
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_C
	jsr	ld_ir3_ix

	ldx	#INTVAR_Y
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_A
	jsr	ld_ir3_ix

	ldx	#INTVAR_D
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_X
	jsr	ld_ir3_ix

	ldx	#INTVAR_D
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTVAR_C
	jsr	ld_ir3_ix

	ldx	#INTVAR_D
	jsr	point_ir3_ir3_ix

	jsr	add_ir2_ir2_ir3

	ldx	#INTARR_L
	jsr	arrval2_ir1_ix_ir2

	jsr	ongosub_ir1_is
	.byte	2
	.word	LINE_2, LINE_3

	; NEXT

	jsr	next

LINE_41

	; POKE MC+Y,PEEK(MC+Y)-L

	ldx	#INTVAR_MC
	ldd	#INTVAR_Y
	jsr	add_ir1_ix_id

	ldx	#INTVAR_MC
	ldd	#INTVAR_Y
	jsr	add_ir2_ix_id

	jsr	peek_ir2_ir2

	ldx	#INTVAR_L
	jsr	sub_ir2_ir2_ix

	jsr	poke_ir1_ir2

	; NEXT

	jsr	next

LINE_42

	; CLS Z

	ldx	#INTVAR_Z
	jsr	clsn_ix

	; PRINT @P2, I$;

	ldx	#INTVAR_P2
	jsr	prat_ix

	ldx	#STRVAR_I
	jsr	pr_sx

	; PRINT @P2, "GENERATION:";STR$(GN);" ";

	ldx	#INTVAR_P2
	jsr	prat_ix

	jsr	pr_ss
	.text	11, "GENERATION:"

	ldx	#INTVAR_GN
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; GN+=W

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	ldx	#INTVAR_GN
	jsr	add_ix_ix_ir1

LINE_43

	; FOR Y=K TO I

	ldd	#INTVAR_Y
	ldx	#INTVAR_K
	jsr	for_id_ix

	ldx	#INTVAR_I
	jsr	to_ip_ix

	; FOR X=J TO H

	ldd	#INTVAR_X
	ldx	#INTVAR_J
	jsr	for_id_ix

	ldx	#INTVAR_H
	jsr	to_ip_ix

	; ON A(Y,X) GOSUB 4

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrval2_ir1_ix_id

	jsr	ongosub_ir1_is
	.byte	1
	.word	LINE_4

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 24

	ldx	#LINE_24
	jsr	goto_ix

LINE_500

	; H=63

	ldx	#INTVAR_H
	ldab	#63
	jsr	ld_ix_pb

	; J=0

	ldx	#INTVAR_J
	jsr	clr_ix

	; I=29

	ldx	#INTVAR_I
	ldab	#29
	jsr	ld_ix_pb

	; K=0

	ldx	#INTVAR_K
	jsr	clr_ix

	; W=1

	ldx	#INTVAR_W
	jsr	one_ix

	; Q=-1

	ldx	#INTVAR_Q
	jsr	true_ix

	; Z=0

	ldx	#INTVAR_Z
	jsr	clr_ix

	; L=64

	ldx	#INTVAR_L
	ldab	#64
	jsr	ld_ix_pb

	; M=30

	ldx	#INTVAR_M
	ldab	#30
	jsr	ld_ix_pb

LINE_505

	; P=28

	ldx	#INTVAR_P
	ldab	#28
	jsr	ld_ix_pb

	; O=62

	ldx	#INTVAR_O
	ldab	#62
	jsr	ld_ix_pb

LINE_510

	; GN=1

	ldx	#INTVAR_GN
	jsr	one_ix

	; P2=480

	ldx	#INTVAR_P2
	ldd	#480
	jsr	ld_ix_pw

LINE_520

	; FOR X=0 TO 1

	ldx	#INTVAR_X
	jsr	forclr_ix

	ldab	#1
	jsr	to_ip_pb

	; FOR Y=0 TO 8

	ldx	#INTVAR_Y
	jsr	forclr_ix

	ldab	#8
	jsr	to_ip_pb

	; READ NO

	ldx	#INTVAR_NO
	jsr	read_ix

	; L(X,Y)=NO

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTARR_L
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_NO
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

LINE_525

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_530

	; CLS

	jsr	cls

	; PRINT TAB(6);"JOHN CONWAY'S LIFE\r";

	ldab	#6
	jsr	prtab_pb

	jsr	pr_ss
	.text	19, "JOHN CONWAY'S LIFE\r"

LINE_535

	; PRINT TAB(8);"FOR THE MC-10\r";

	ldab	#8
	jsr	prtab_pb

	jsr	pr_ss
	.text	14, "FOR THE MC-10\r"

	; PRINT TAB(8);"BY JIM GERRIE\r";

	ldab	#8
	jsr	prtab_pb

	jsr	pr_ss
	.text	14, "BY JIM GERRIE\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "RUN THE R PENTOMINO (Y/N)?\r";

	jsr	pr_ss
	.text	27, "RUN THE R PENTOMINO (Y/N)?\r"

LINE_540

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; WHEN I$="" GOTO 540

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_540
	jsr	jmpne_ir1_ix

LINE_550

	; IF I$="Y" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_560
	jsr	jmpeq_ir1_ix

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; FOR NO=1 TO 5

	ldx	#INTVAR_NO
	jsr	forone_ix

	ldab	#5
	jsr	to_ip_pb

	; READ X,Y

	ldx	#INTVAR_X
	jsr	read_ix

	ldx	#INTVAR_Y
	jsr	read_ix

	; SET(X,Y,W)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_W
	jsr	setc_ir1_ir2_ix

	; A(Y,X)=W

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT NO

	ldx	#INTVAR_NO
	jsr	nextvar_ix

	jsr	next

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_560

	; WHEN I$<>"N" GOTO 540

	ldx	#STRVAR_I
	jsr	ldne_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_540
	jsr	jmpne_ir1_ix

LINE_565

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "RUN THE GLIDER (Y/N)?\r";

	jsr	pr_ss
	.text	22, "RUN THE GLIDER (Y/N)?\r"

LINE_570

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; WHEN I$="" GOTO 570

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_570
	jsr	jmpne_ir1_ix

LINE_575

	; IF I$="Y" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_580
	jsr	jmpeq_ir1_ix

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; FOR NO=1 TO 5

	ldx	#INTVAR_NO
	jsr	forone_ix

	ldab	#5
	jsr	to_ip_pb

	; READ X,Y

	ldx	#INTVAR_X
	jsr	read_ix

	ldx	#INTVAR_Y
	jsr	read_ix

	; NEXT NO

	ldx	#INTVAR_NO
	jsr	nextvar_ix

	jsr	next

	; FOR NO=1 TO 5

	ldx	#INTVAR_NO
	jsr	forone_ix

	ldab	#5
	jsr	to_ip_pb

	; READ X,Y

	ldx	#INTVAR_X
	jsr	read_ix

	ldx	#INTVAR_Y
	jsr	read_ix

	; SET(X,Y,W)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_W
	jsr	setc_ir1_ir2_ix

	; A(Y,X)=W

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	ldx	#INTVAR_W
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; NEXT NO

	ldx	#INTVAR_NO
	jsr	nextvar_ix

	jsr	next

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_580

	; WHEN I$="N" GOTO 600

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_600
	jsr	jmpne_ir1_ix

LINE_585

	; GOTO 570

	ldx	#LINE_570
	jsr	goto_ix

LINE_587

LINE_588

LINE_590

LINE_600

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; X=32

	ldx	#INTVAR_X
	ldab	#32
	jsr	ld_ix_pb

	; Y=16

	ldx	#INTVAR_Y
	ldab	#16
	jsr	ld_ix_pb

LINE_610

	; PRINT @480, "a,s,w,z=MOVE spc=ON/OFF q=QUIT";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	30, "a,s,w,z=MOVE spc=ON/OFF q=QUIT"

LINE_611

	; T=POINT(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	point_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; SET(X,Y,1)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldab	#1
	jsr	setc_ir1_ir2_pb

	; A(Y,X)=1

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; IF I$="S" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_612
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; X+=1

	ldx	#INTVAR_X
	jsr	inc_ix_ix

	; IF X>63 THEN

	ldab	#63
	ldx	#INTVAR_X
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_612
	jsr	jmpeq_ir1_ix

	; X=0

	ldx	#INTVAR_X
	jsr	clr_ix

LINE_612

	; IF I$="A" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_613
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; X-=1

	ldx	#INTVAR_X
	jsr	dec_ix_ix

	; IF X<0 THEN

	ldx	#INTVAR_X
	ldab	#0
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_613
	jsr	jmpeq_ir1_ix

	; X=63

	ldx	#INTVAR_X
	ldab	#63
	jsr	ld_ix_pb

LINE_613

	; IF I$="W" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "W"

	ldx	#LINE_614
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; Y-=1

	ldx	#INTVAR_Y
	jsr	dec_ix_ix

	; IF Y<0 THEN

	ldx	#INTVAR_Y
	ldab	#0
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_614
	jsr	jmpeq_ir1_ix

	; Y=29

	ldx	#INTVAR_Y
	ldab	#29
	jsr	ld_ix_pb

LINE_614

	; IF I$="Z" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Z"

	ldx	#LINE_615
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; Y+=1

	ldx	#INTVAR_Y
	jsr	inc_ix_ix

	; IF Y>29 THEN

	ldab	#29
	ldx	#INTVAR_Y
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_615
	jsr	jmpeq_ir1_ix

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

LINE_615

	; IF I$=" " THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, " "

	ldx	#LINE_616
	jsr	jmpeq_ir1_ix

	; T=1-T

	ldab	#1
	ldx	#INTVAR_T
	jsr	sub_ir1_pb_ix

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

LINE_616

	; IF I$="Q" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Q"

	ldx	#LINE_617
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; X=0

	ldx	#INTVAR_X
	jsr	clr_ix

	; Y=0

	ldx	#INTVAR_Y
	jsr	clr_ix

	; T=0

	ldx	#INTVAR_T
	jsr	clr_ix

	; PRINT @480, "";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	0, ""

	; FOR T=1 TO 30

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#30
	jsr	to_ip_pb

	; PRINT "�";

	jsr	pr_ss
	.text	1, "\x80"

	; NEXT

	jsr	next

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_617

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; GOTO 611

	ldx	#LINE_611
	jsr	goto_ix

LINE_620

	; IF T=0 THEN

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#LINE_621
	jsr	jmpne_ir1_ix

	; RESET(X,Y)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	reset_ir1_ix

	; A(Y,X)=0

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	jsr	clr_ip

	; RETURN

	jsr	return

LINE_621

	; SET(X,Y,T)

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ir2_ix

	ldx	#INTVAR_T
	jsr	setc_ir1_ir2_ix

	; A(Y,X)=1

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldx	#INTARR_A
	ldd	#INTVAR_X
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; RETURN

	jsr	return

LINE_1000

	; MC=16863

	ldx	#INTVAR_MC
	ldd	#16863
	jsr	ld_ix_pw

	; REM CHANGE MC=1503 FOR COCO

LINE_1020

	; GOTO 500

	ldx	#LINE_500
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

	.module	mdrpubyte
; read DATA when records are purely unsigned bytes
; EXIT:  int in tmp1+1 and tmp2
rpubyte
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

add_ir1_ix_id			; numCalls = 11
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

add_ir2_ir2_ir3			; numCalls = 14
	.module	modadd_ir2_ir2_ir3
	ldd	r2+1
	addd	r3+1
	std	r2+1
	ldab	r2
	adcb	r3
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

add_ix_ix_ir1			; numCalls = 1
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

arrdim2_ir1_ix			; numCalls = 2
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

arrref2_ir1_ix_id			; numCalls = 8
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

arrval2_ir1_ix_id			; numCalls = 1
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

arrval2_ir1_ix_ir2			; numCalls = 2
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

clr_ix			; numCalls = 8
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 2
	.module	modcls
	jmp	R_CLS

clsn_ix			; numCalls = 1
	.module	modclsn_ix
	ldd	0,x
	bne	_fcerror
	ldab	2,x
	jmp	R_CLSN
_fcerror
	ldab	#FC_ERROR
	jmp	error

clsn_pb			; numCalls = 3
	.module	modclsn_pb
	jmp	R_CLSN

dec_ix_ix			; numCalls = 2
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_id_ix			; numCalls = 8
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

forclr_ix			; numCalls = 2
	.module	modforclr_ix
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 4
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 14
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 8
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_ix_ix			; numCalls = 2
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

jmpne_ir1_ix			; numCalls = 5
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

ld_id_ix			; numCalls = 17
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

ld_ip_ir1			; numCalls = 3
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 23
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 2
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

ld_ir2_pb			; numCalls = 2
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 14
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

ld_ix_pb			; numCalls = 10
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

ld_sx_sr1			; numCalls = 1
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir1_sx_ss			; numCalls = 11
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

ldlt_ir1_pb_ix			; numCalls = 2
	.module	modldlt_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
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

next			; numCalls = 14
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

nextvar_ix			; numCalls = 3
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

one_ip			; numCalls = 3
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

peek_ir2_ir2			; numCalls = 1
	.module	modpeek_ir2_ir2
	ldx	r2+1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

point_ir1_ir1_ix			; numCalls = 3
	.module	modpoint_ir1_ir1_ix
	ldaa	2,x
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

point_ir2_ir2_ix			; numCalls = 2
	.module	modpoint_ir2_ir2_ix
	ldaa	2,x
	ldab	r2+2
	jsr	point
	stab	r2+2
	tab
	std	r2
	rts

point_ir3_ir3_ix			; numCalls = 14
	.module	modpoint_ir3_ir3_ix
	ldaa	2,x
	ldab	r3+2
	jsr	point
	stab	r3+2
	tab
	std	r3
	rts

poke_ir1_ir2			; numCalls = 1
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

pr_sr1			; numCalls = 1
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 13
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 2
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ix			; numCalls = 3
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pw			; numCalls = 2
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

progend			; numCalls = 1
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

prtab_pb			; numCalls = 3
	.module	modprtab_pb
	jmp	prtab

read_ix			; numCalls = 7
	.module	modread_ix
	jsr	rpubyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

reset_ir1_ix			; numCalls = 1
	.module	modreset_ir1_ix
	ldaa	2,x
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

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

setc_ir1_ir2_ix			; numCalls = 4
	.module	modsetc_ir1_ir2_ix
	ldab	2,x
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

setc_ir1_ir2_pb			; numCalls = 1
	.module	modsetc_ir1_ir2_pb
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

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

sub_ir1_ix_id			; numCalls = 10
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

sub_ir2_ir2_ix			; numCalls = 1
	.module	modsub_ir2_ir2_ix
	ldd	r2+1
	subd	1,x
	std	r2+1
	ldab	r2
	sbcb	0,x
	stab	r2
	rts

to_ip_ix			; numCalls = 8
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
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

true_ix			; numCalls = 1
	.module	modtrue_ix
	ldd	#-1
	stab	0,x
	std	1,x
	rts

; data table
startdata
	.byte	0, 0, 0, 1, 0, 0
	.byte	0, 0, 0, 2, 2, 0
	.byte	0, 2, 2, 2, 2, 2
	.byte	31, 10, 32, 10, 31, 11
	.byte	30, 11, 31, 12, 32, 25
	.byte	33, 26, 33, 27, 32, 27
	.byte	31, 27
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_GN	.block	3
INTVAR_H	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_M	.block	3
INTVAR_MC	.block	3
INTVAR_NO	.block	3
INTVAR_O	.block	3
INTVAR_P	.block	3
INTVAR_P2	.block	3
INTVAR_Q	.block	3
INTVAR_T	.block	3
INTVAR_W	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
; String Variables
STRVAR_I	.block	3
; Numeric Arrays
INTARR_A	.block	6	; dims=2
INTARR_L	.block	6	; dims=2
; String Arrays

; block ended by symbol
bes
	.end

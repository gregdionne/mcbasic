; Assembly for swelfoop.bas
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

LINE_1

	; CLS

	jsr	cls

	; GOTO 1030

	ldx	#LINE_1030
	jsr	goto_ix

LINE_2

	; IF (Y>B) OR (Y<0) OR (X>N) OR (X<0) THEN

	ldx	#INTVAR_B
	ldd	#INTVAR_Y
	jsr	ldlt_ir1_ix_id

	ldx	#INTVAR_Y
	ldab	#0
	jsr	ldlt_ir2_ix_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_N
	ldd	#FLTVAR_X
	jsr	ldlt_ir2_fx_fd

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_X
	ldab	#0
	jsr	ldlt_ir2_fx_pb

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_3
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_3

	; IF B(X,Y)<>L THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_fx_id

	ldx	#FLTVAR_L
	jsr	ldne_ir1_fr1_fx

	ldx	#LINE_4
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_4

	; M+=1

	ldx	#INTVAR_M
	jsr	inc_ix_ix

	; Q(M)=X

	ldx	#FLTARR_Q
	ldd	#INTVAR_M
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	jsr	ld_fp_fr1

	; R(M)=Y

	ldx	#INTARR_R
	ldd	#INTVAR_M
	jsr	arrref1_ir1_ix_id

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; Q=X

	ldd	#FLTVAR_Q
	ldx	#FLTVAR_X
	jsr	ld_fd_fx

	; R=Y

	ldd	#INTVAR_R
	ldx	#INTVAR_Y
	jsr	ld_id_ix

	; PRINT @SHIFT(R,5)+Q, "x";

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_Q
	jsr	add_fr1_ir1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "x"

	; B(X,Y)=0

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_fx_id

	jsr	clr_fp

	; YD+=1

	ldx	#INTVAR_YD
	jsr	inc_ix_ix

	; RETURN

	jsr	return

LINE_5

	; IF MD<15 THEN

	ldx	#INTVAR_MD
	ldab	#15
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_6
	jsr	jmpeq_ir1_ix

	; PRINT @SHIFT(R,5)+Q, CHR$(C(B(Q,R)));

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_Q
	jsr	add_fr1_ir1_fx

	jsr	prat_ir1

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_R
	jsr	arrval2_ir1_fx_id

	ldx	#FLTARR_C
	jsr	arrval1_ir1_fx_ir1

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	; RETURN

	jsr	return

LINE_6

	; PRINT @SHIFT(R,5)+Q, "x";

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_Q
	jsr	add_fr1_ir1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "x"

	; RETURN

	jsr	return

LINE_9

	; X=E+1

	ldx	#FLTVAR_E
	jsr	inc_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

	; Y=F

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	ld_id_ix

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

	; X=E-1

	ldx	#FLTVAR_E
	jsr	dec_fr1_fx

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

	; Y=F

	ldd	#INTVAR_Y
	ldx	#INTVAR_F
	jsr	ld_id_ix

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

	; X=E

	ldd	#FLTVAR_X
	ldx	#FLTVAR_E
	jsr	ld_fd_fx

	; Y=F-1

	ldx	#INTVAR_F
	jsr	dec_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

	; X=E

	ldd	#FLTVAR_X
	ldx	#FLTVAR_E
	jsr	ld_fd_fx

	; Y=F+1

	ldx	#INTVAR_F
	jsr	inc_ir1_ix

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 2

	ldx	#LINE_2
	jsr	gosub_ix

	; IF M=0 THEN

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#LINE_10
	jsr	jmpne_ir1_ix

	; RETURN

	jsr	return

LINE_10

	; E=Q(M)

	ldx	#FLTARR_Q
	ldd	#INTVAR_M
	jsr	arrval1_ir1_fx_id

	ldx	#FLTVAR_E
	jsr	ld_fx_fr1

	; F=R(M)

	ldx	#INTARR_R
	ldd	#INTVAR_M
	jsr	arrval1_ir1_ix_id

	ldx	#INTVAR_F
	jsr	ld_ix_ir1

	; M-=1

	ldx	#INTVAR_M
	jsr	dec_ix_ix

	; GOTO 9

	ldx	#LINE_9
	jsr	goto_ix

LINE_11

	; FOR X=0 TO N

	ldx	#FLTVAR_X
	jsr	forclr_fx

	ldx	#FLTVAR_N
	jsr	to_fp_ix

	; Y=B

	ldd	#INTVAR_Y
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; D=0

	ldx	#INTVAR_D
	jsr	clr_ix

LINE_12

	; IF B(X,Y)=0 THEN

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_fx_id

	ldx	#LINE_13
	jsr	jmpne_fr1_ix

	; D+=1

	ldx	#INTVAR_D
	jsr	inc_ix_ix

	; GOTO 14

	ldx	#LINE_14
	jsr	goto_ix

LINE_13

	; WHEN D>0 GOTO 16

	ldab	#0
	ldx	#INTVAR_D
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_16
	jsr	jmpne_ir1_ix

LINE_14

	; Y-=1

	ldx	#INTVAR_Y
	jsr	dec_ix_ix

	; WHEN Y<0 GOTO 19

	ldx	#INTVAR_Y
	ldab	#0
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_19
	jsr	jmpne_ir1_ix

LINE_15

	; GOTO 12

	ldx	#LINE_12
	jsr	goto_ix

LINE_16

	; FOR Z=Y TO 0 STEP -1

	ldd	#INTVAR_Z
	ldx	#INTVAR_Y
	jsr	for_id_ix

	ldab	#0
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; B(X,Z+D)=B(X,Z)

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_Z
	ldd	#INTVAR_D
	jsr	add_ir2_ix_id

	ldx	#FLTARR_B
	jsr	arrref2_ir1_fx_ir2

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Z
	jsr	arrval2_ir1_fx_id

	jsr	ld_fp_fr1

	; NEXT

	jsr	next

	; Y+=D

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#INTVAR_Y
	jsr	add_ix_ix_ir1

LINE_17

	; D-=1

	ldx	#INTVAR_D
	jsr	dec_ix_ix

	; B(X,D)=0

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_D
	jsr	arrref2_ir1_fx_id

	jsr	clr_fp

	; WHEN D=0 GOTO 14

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldx	#LINE_14
	jsr	jmpeq_ir1_ix

LINE_18

	; GOTO 17

	ldx	#LINE_17
	jsr	goto_ix

LINE_19

	; NEXT

	jsr	next

	; X=0

	ldx	#FLTVAR_X
	jsr	clr_fx

LINE_20

	; WHEN B(X,B)<>0 GOTO 24

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_B
	jsr	arrval2_ir1_fx_id

	ldx	#LINE_24
	jsr	jmpne_fr1_ix

LINE_21

	; IF X>N THEN

	ldx	#FLTVAR_N
	ldd	#FLTVAR_X
	jsr	ldlt_ir1_fx_fd

	ldx	#LINE_22
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_22

	; FOR S=X TO N-1

	ldd	#FLTVAR_S
	ldx	#FLTVAR_X
	jsr	for_fd_fx

	ldx	#FLTVAR_N
	jsr	dec_fr1_fx

	jsr	to_fp_fr1

	; FOR T=0 TO B

	ldx	#INTVAR_T
	jsr	forclr_ix

	ldx	#INTVAR_B
	jsr	to_ip_ix

	; B(S,T)=B(S+1,T)

	ldx	#FLTVAR_S
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_T
	jsr	arrref2_ir1_fx_id

	ldx	#FLTVAR_S
	jsr	inc_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_T
	jsr	arrval2_ir1_fx_id

	jsr	ld_fp_fr1

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; FOR T=0 TO B

	ldx	#INTVAR_T
	jsr	forclr_ix

	ldx	#INTVAR_B
	jsr	to_ip_ix

	; B(N,T)=0

	ldx	#FLTVAR_N
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_T
	jsr	arrref2_ir1_fx_id

	jsr	clr_fp

	; NEXT

	jsr	next

	; N-=1

	ldx	#FLTVAR_N
	jsr	dec_fx_fx

	; IF N<0 THEN

	ldx	#FLTVAR_N
	ldab	#0
	jsr	ldlt_ir1_fx_pb

	ldx	#LINE_23
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_23

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_24

	; X+=1

	ldx	#FLTVAR_X
	jsr	inc_fx_fx

	; WHEN X<N GOTO 20

	ldx	#FLTVAR_X
	ldd	#FLTVAR_N
	jsr	ldlt_ir1_fx_fd

	ldx	#LINE_20
	jsr	jmpne_ir1_ix

LINE_25

	; RETURN

	jsr	return

LINE_26

	; FOR R=0 TO B

	ldx	#INTVAR_R
	jsr	forclr_ix

	ldx	#INTVAR_B
	jsr	to_ip_ix

	; FOR Q=0 TO A

	ldx	#FLTVAR_Q
	jsr	forclr_fx

	ldx	#FLTVAR_A
	jsr	to_fp_ix

	; PRINT @SHIFT(R,5)+Q, CHR$(C(B(Q,R)));

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_Q
	jsr	add_fr1_ir1_fx

	jsr	prat_ir1

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_R
	jsr	arrval2_ir1_fx_id

	ldx	#FLTARR_C
	jsr	arrval1_ir1_fx_ir1

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_1000

	; REM 

LINE_1010

	; REM 

LINE_1020

	; REM 

LINE_1030

	; DIM B(15,10),Q,R,N,F,E,A,B,PY,PX,S,T,C,D,C(8),M,L

	ldab	#15
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	ldx	#FLTARR_B
	jsr	arrdim2_ir1_fx

	ldab	#8
	jsr	ld_ir1_pb

	ldx	#FLTARR_C
	jsr	arrdim1_ir1_fx

	; FOR A=0 TO 8

	ldx	#FLTVAR_A
	jsr	forclr_fx

	ldab	#8
	jsr	to_fp_pb

	; C(A)=SHIFT(A,4)+143

	ldx	#FLTARR_C
	ldd	#FLTVAR_A
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_A
	jsr	ld_fr1_fx

	ldab	#4
	jsr	shift_fr1_fr1_pb

	ldab	#143
	jsr	add_fr1_fr1_pb

	jsr	ld_fp_fr1

	; NEXT

	jsr	next

	; A=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_A
	jsr	ld_fx_fr1

LINE_1050

	; REM PSEUDO STACK FOR SEARCH

LINE_1060

	; A=15

	ldx	#FLTVAR_A
	ldab	#15
	jsr	ld_fx_pb

	; B=10

	ldx	#INTVAR_B
	ldab	#10
	jsr	ld_ix_pb

	; NC=4

	ldx	#INTVAR_NC
	ldab	#4
	jsr	ld_ix_pb

	; DIM Q(150),R(150)

	ldab	#150
	jsr	ld_ir1_pb

	ldx	#FLTARR_Q
	jsr	arrdim1_ir1_fx

	ldab	#150
	jsr	ld_ir1_pb

	ldx	#INTARR_R
	jsr	arrdim1_ir1_ix

LINE_1080

	; PRINT TAB(2);"ORIGINALLY FOR VIDEOPAC C7420\r";

	ldab	#2
	jsr	prtab_pb

	jsr	pr_ss
	.text	30, "ORIGINALLY FOR VIDEOPAC C7420\r"

LINE_1140

	; T=104

	ldx	#INTVAR_T
	ldab	#104
	jsr	ld_ix_pb

	; GOSUB 4000

	ldx	#LINE_4000
	jsr	gosub_ix

	; GOSUB 4030

	ldx	#LINE_4030
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

LINE_1190

	; PRINT TAB(4);"(C) 2012 GERTK@XS4ALL.NL\r";

	ldab	#4
	jsr	prtab_pb

	jsr	pr_ss
	.text	25, "(C) 2012 GERTK@XS4ALL.NL\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1200

	; PRINT TAB(4);"MC-10 MODS BY JIM GERRIE\r";

	ldab	#4
	jsr	prtab_pb

	jsr	pr_ss
	.text	25, "MC-10 MODS BY JIM GERRIE\r"

LINE_1210

	; FOR T=1 TO 10000

	ldx	#INTVAR_T
	jsr	forone_ix

	ldd	#10000
	jsr	to_ip_pw

	; NEXT

	jsr	next

LINE_1230

	; CLS

	jsr	cls

LINE_1260

	; PRINT "SWELL FOOP IS A PUZZLE GAME.\r";

	jsr	pr_ss
	.text	29, "SWELL FOOP IS A PUZZLE GAME.\r"

LINE_1280

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1290

	; PRINT "THE GOAL IS TO REMOVE AS MANY\r";

	jsr	pr_ss
	.text	30, "THE GOAL IS TO REMOVE AS MANY\r"

LINE_1310

	; PRINT "BLOCKS AS POSSIBLE IN AS FEW\r";

	jsr	pr_ss
	.text	29, "BLOCKS AS POSSIBLE IN AS FEW\r"

LINE_1330

	; PRINT "MOVES AS POSSIBLE.\r";

	jsr	pr_ss
	.text	19, "MOVES AS POSSIBLE.\r"

LINE_1340

	; PRINT "BLOCKS ADJACENT TO EACH OTHER\r";

	jsr	pr_ss
	.text	30, "BLOCKS ADJACENT TO EACH OTHER\r"

LINE_1350

	; PRINT "GET REMOVED AS A GROUP.\r";

	jsr	pr_ss
	.text	24, "GET REMOVED AS A GROUP.\r"

LINE_1360

	; PRINT "USE A,S,W,Z KEYS TO MOVE THE\r";

	jsr	pr_ss
	.text	29, "USE A,S,W,Z KEYS TO MOVE THE\r"

LINE_1365

	; PRINT "CURSOR AND <SPACE> TO SELECT.\r";

	jsr	pr_ss
	.text	30, "CURSOR AND <SPACE> TO SELECT.\r"

LINE_1370

	; PRINT "THE REMAINING BLOCKS THEN\r";

	jsr	pr_ss
	.text	26, "THE REMAINING BLOCKS THEN\r"

LINE_1390

	; PRINT "COLLAPSE TO FILL IN THE GAPS\r";

	jsr	pr_ss
	.text	29, "COLLAPSE TO FILL IN THE GAPS\r"

LINE_1400

	; PRINT "AND NEW GROUPS ARE FORMED.\r";

	jsr	pr_ss
	.text	27, "AND NEW GROUPS ARE FORMED.\r"

LINE_1420

	; PRINT "YOU CANNOT REMOVE SINGLE\r";

	jsr	pr_ss
	.text	25, "YOU CANNOT REMOVE SINGLE\r"

LINE_1430

	; PRINT "BLOCKS.\r";

	jsr	pr_ss
	.text	8, "BLOCKS.\r"

LINE_1440

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_1460

	; PRINT "PRESS <ENTER> TO START...";

	jsr	pr_ss
	.text	25, "PRESS <ENTER> TO START..."

LINE_1480

	; GOSUB 3570

	ldx	#LINE_3570
	jsr	gosub_ix

	; WHEN I$<>"\r" GOTO 1480

	ldx	#STRVAR_I
	jsr	ldne_ir1_sx_ss
	.text	1, "\r"

	ldx	#LINE_1480
	jsr	jmpne_ir1_ix

LINE_1490

	; REM RESET SCORE

LINE_1500

	; CLS

	jsr	cls

	; SC=0

	ldx	#INTVAR_SC
	jsr	clr_ix

	; O=RND(3)

	ldab	#3
	jsr	irnd_ir1_pb

	ldx	#INTVAR_O
	jsr	ld_ix_ir1

LINE_1590

	; REM FILL ARRAY 

LINE_1600

	; FOR X=0 TO A

	ldx	#FLTVAR_X
	jsr	forclr_fx

	ldx	#FLTVAR_A
	jsr	to_fp_ix

	; FOR Y=0 TO B

	ldx	#INTVAR_Y
	jsr	forclr_ix

	ldx	#INTVAR_B
	jsr	to_ip_ix

	; B(X,Y)=RND(NC)+O

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrref2_ir1_fx_id

	ldx	#INTVAR_NC
	jsr	rnd_fr1_ix

	ldx	#INTVAR_O
	jsr	add_fr1_fr1_ix

	jsr	ld_fp_fr1

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_1650

	; PY=B

	ldd	#INTVAR_PY
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; PX=0

	ldx	#FLTVAR_PX
	jsr	clr_fx

	; N=A

	ldd	#FLTVAR_N
	ldx	#FLTVAR_A
	jsr	ld_fd_fx

LINE_1690

	; REM MAIN LOOP

LINE_1700

	; GOSUB 3630

	ldx	#LINE_3630
	jsr	gosub_ix

	; T=384

	ldx	#INTVAR_T
	ldd	#384
	jsr	ld_ix_pw

	; GOSUB 4000

	ldx	#LINE_4000
	jsr	gosub_ix

	; T=304

	ldx	#INTVAR_T
	ldd	#304
	jsr	ld_ix_pw

	; GOSUB 4030

	ldx	#LINE_4030
	jsr	gosub_ix

	; GOSUB 3640

	ldx	#LINE_3640
	jsr	gosub_ix

	; GOSUB 26

	ldx	#LINE_26
	jsr	gosub_ix

	; GOSUB 3020

	ldx	#LINE_3020
	jsr	gosub_ix

	; GOSUB 3030

	ldx	#LINE_3030
	jsr	gosub_ix

LINE_1710

	; GOSUB 3210

	ldx	#LINE_3210
	jsr	gosub_ix

	; SOUND 60,1

	ldab	#60
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_1730

	; Q=PX

	ldd	#FLTVAR_Q
	ldx	#FLTVAR_PX
	jsr	ld_fd_fx

	; R=PY

	ldd	#INTVAR_R
	ldx	#INTVAR_PY
	jsr	ld_id_ix

LINE_1740

	; MD+=1

	ldx	#INTVAR_MD
	jsr	inc_ix_ix

	; GOSUB 5

	ldx	#LINE_5
	jsr	gosub_ix

	; IF MD>45 THEN

	ldab	#45
	ldx	#INTVAR_MD
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_1770
	jsr	jmpeq_ir1_ix

	; MD=0

	ldx	#INTVAR_MD
	jsr	clr_ix

LINE_1770

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; WHEN I$="" GOTO 1740

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_1740
	jsr	jmpne_ir1_ix

LINE_1780

	; PRINT @SHIFT(R,5)+Q, "x";

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_Q
	jsr	add_fr1_ir1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "x"

	; WHEN I$=" " GOTO 1940

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, " "

	ldx	#LINE_1940
	jsr	jmpne_ir1_ix

LINE_1800

	; PRINT @SHIFT(R,5)+Q, CHR$(C(B(Q,R)));

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldab	#5
	jsr	shift_ir1_ir1_pb

	ldx	#FLTVAR_Q
	jsr	add_fr1_ir1_fx

	jsr	prat_ir1

	ldx	#FLTVAR_Q
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_R
	jsr	arrval2_ir1_fx_id

	ldx	#FLTARR_C
	jsr	arrval1_ir1_fx_ir1

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	; IF I$="Z" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Z"

	ldx	#LINE_1860
	jsr	jmpeq_ir1_ix

	; PY+=1

	ldx	#INTVAR_PY
	jsr	inc_ix_ix

	; IF PY>B THEN

	ldx	#INTVAR_B
	ldd	#INTVAR_PY
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_1860
	jsr	jmpeq_ir1_ix

	; PY=0

	ldx	#INTVAR_PY
	jsr	clr_ix

LINE_1860

	; IF I$="W" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "W"

	ldx	#LINE_1880
	jsr	jmpeq_ir1_ix

	; PY-=1

	ldx	#INTVAR_PY
	jsr	dec_ix_ix

	; IF PY<0 THEN

	ldx	#INTVAR_PY
	ldab	#0
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_1880
	jsr	jmpeq_ir1_ix

	; PY=B

	ldd	#INTVAR_PY
	ldx	#INTVAR_B
	jsr	ld_id_ix

LINE_1880

	; IF I$="S" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_1900
	jsr	jmpeq_ir1_ix

	; PX+=1

	ldx	#FLTVAR_PX
	jsr	inc_fx_fx

	; IF PX>A THEN

	ldx	#FLTVAR_A
	ldd	#FLTVAR_PX
	jsr	ldlt_ir1_fx_fd

	ldx	#LINE_1900
	jsr	jmpeq_ir1_ix

	; PX=0

	ldx	#FLTVAR_PX
	jsr	clr_fx

LINE_1900

	; IF I$="A" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_1920
	jsr	jmpeq_ir1_ix

	; PX-=1

	ldx	#FLTVAR_PX
	jsr	dec_fx_fx

	; IF PX<0 THEN

	ldx	#FLTVAR_PX
	ldab	#0
	jsr	ldlt_ir1_fx_pb

	ldx	#LINE_1920
	jsr	jmpeq_ir1_ix

	; PX=A

	ldd	#FLTVAR_PX
	ldx	#FLTVAR_A
	jsr	ld_fd_fx

LINE_1920

	; MD=15

	ldx	#INTVAR_MD
	ldab	#15
	jsr	ld_ix_pb

	; Q=PX

	ldd	#FLTVAR_Q
	ldx	#FLTVAR_PX
	jsr	ld_fd_fx

	; R=PY

	ldd	#INTVAR_R
	ldx	#INTVAR_PY
	jsr	ld_id_ix

	; GOTO 1730

	ldx	#LINE_1730
	jsr	goto_ix

LINE_1940

	; L=B(PX,PY)

	ldx	#FLTVAR_PX
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_PY
	jsr	arrval2_ir1_fx_id

	ldx	#FLTVAR_L
	jsr	ld_fx_fr1

LINE_1960

	; IF L=0 THEN

	ldx	#FLTVAR_L
	jsr	ld_fr1_fx

	ldx	#LINE_1970
	jsr	jmpne_fr1_ix

	; SOUND 50,1

	ldab	#50
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOTO 1730

	ldx	#LINE_1730
	jsr	goto_ix

LINE_1970

	; REM SET SEARCH COORDINATES

LINE_1980

	; E=PX

	ldd	#FLTVAR_E
	ldx	#FLTVAR_PX
	jsr	ld_fd_fx

	; F=PY

	ldd	#INTVAR_F
	ldx	#INTVAR_PY
	jsr	ld_id_ix

	; YD=0

	ldx	#INTVAR_YD
	jsr	clr_ix

	; M=0

	ldx	#INTVAR_M
	jsr	clr_ix

	; GOSUB 9

	ldx	#LINE_9
	jsr	gosub_ix

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @50, "YIELD:";STR$(YD);"  ";

	ldab	#50
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "YIELD:"

	ldx	#INTVAR_YD
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, "  "

	; GOSUB 11

	ldx	#LINE_11
	jsr	gosub_ix

	; IF YD<2 THEN

	ldx	#INTVAR_YD
	ldab	#2
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_2200
	jsr	jmpeq_ir1_ix

	; SOUND 80,1

	ldab	#80
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOTO 1730

	ldx	#LINE_1730
	jsr	goto_ix

LINE_2200

	; SC+=SQ(YD-2)

	ldx	#INTVAR_YD
	ldab	#2
	jsr	sub_ir1_ix_pb

	jsr	sq_ir1_ir1

	ldx	#INTVAR_SC
	jsr	add_ix_ix_ir1

	; GOTO 1700

	ldx	#LINE_1700
	jsr	goto_ix

LINE_3020

	; PRINT @18, "SCORE:";STR$(INT(SC));" ";

	ldab	#18
	jsr	prat_pb

	jsr	pr_ss
	.text	6, "SCORE:"

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; RETURN

	jsr	return

LINE_3030

	; PRINT @178, "HIGH:";STR$(INT(HS));" ";

	ldab	#178
	jsr	prat_pb

	jsr	pr_ss
	.text	5, "HIGH:"

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; RETURN

	jsr	return

LINE_3210

	; X=0

	ldx	#FLTVAR_X
	jsr	clr_fx

LINE_3220

	; Y=B

	ldd	#INTVAR_Y
	ldx	#INTVAR_B
	jsr	ld_id_ix

LINE_3230

	; C=0

	ldx	#INTVAR_C
	jsr	clr_ix

LINE_3240

	; WHEN B(X,Y)=0 GOTO 3300

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_fx_id

	ldx	#LINE_3300
	jsr	jmpeq_fr1_ix

LINE_3250

	; GOSUB 3340

	ldx	#LINE_3340
	jsr	gosub_ix

	; IF C>0 THEN

	ldab	#0
	ldx	#INTVAR_C
	jsr	ldlt_ir1_pb_ix

	ldx	#LINE_3270
	jsr	jmpeq_ir1_ix

	; RETURN

	jsr	return

LINE_3270

	; Y-=1

	ldx	#INTVAR_Y
	jsr	dec_ix_ix

	; WHEN Y>=0 GOTO 3230

	ldx	#INTVAR_Y
	ldab	#0
	jsr	ldge_ir1_ix_pb

	ldx	#LINE_3230
	jsr	jmpne_ir1_ix

LINE_3290

	; GOTO 3310

	ldx	#LINE_3310
	jsr	goto_ix

LINE_3300

	; WHEN (X=0) AND (Y=B) GOTO 3420

	ldx	#FLTVAR_X
	ldab	#0
	jsr	ldeq_ir1_fx_pb

	ldx	#INTVAR_Y
	ldd	#INTVAR_B
	jsr	ldeq_ir2_ix_id

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_3420
	jsr	jmpne_ir1_ix

LINE_3310

	; X+=1

	ldx	#FLTVAR_X
	jsr	inc_fx_fx

	; WHEN X>N GOTO 3430

	ldx	#FLTVAR_N
	ldd	#FLTVAR_X
	jsr	ldlt_ir1_fx_fd

	ldx	#LINE_3430
	jsr	jmpne_ir1_ix

LINE_3330

	; GOTO 3220

	ldx	#LINE_3220
	jsr	goto_ix

LINE_3340

	; L=B(X,Y)

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_fx_id

	ldx	#FLTVAR_L
	jsr	ld_fx_fr1

	; WHEN (X+1)>N GOTO 3370

	ldx	#FLTVAR_X
	jsr	inc_fr1_fx

	ldx	#FLTVAR_N
	jsr	ldlt_ir1_fx_fr1

	ldx	#LINE_3370
	jsr	jmpne_ir1_ix

LINE_3360

	; WHEN B(X+1,Y)=L GOTO 3400

	ldx	#FLTVAR_X
	jsr	inc_fr1_fx

	ldx	#FLTARR_B
	ldd	#INTVAR_Y
	jsr	arrval2_ir1_fx_id

	ldx	#FLTVAR_L
	jsr	ldeq_ir1_fr1_fx

	ldx	#LINE_3400
	jsr	jmpne_ir1_ix

LINE_3370

	; WHEN Y<1 GOTO 3390

	ldx	#INTVAR_Y
	ldab	#1
	jsr	ldlt_ir1_ix_pb

	ldx	#LINE_3390
	jsr	jmpne_ir1_ix

LINE_3380

	; WHEN B(X,Y-1)=L GOTO 3400

	ldx	#FLTVAR_X
	jsr	ld_fr1_fx

	ldx	#INTVAR_Y
	jsr	dec_ir2_ix

	ldx	#FLTARR_B
	jsr	arrval2_ir1_fx_ir2

	ldx	#FLTVAR_L
	jsr	ldeq_ir1_fr1_fx

	ldx	#LINE_3400
	jsr	jmpne_ir1_ix

LINE_3390

	; RETURN

	jsr	return

LINE_3400

	; C+=1

	ldx	#INTVAR_C
	jsr	inc_ix_ix

	; RETURN

	jsr	return

LINE_3420

	; SC+=1000

	ldx	#INTVAR_SC
	ldd	#1000
	jsr	add_ix_ix_pw

	; PRINT @18, "bonus: 1000 ";

	ldab	#18
	jsr	prat_pb

	jsr	pr_ss
	.text	12, "bonus: 1000 "

	; FOR T=1 TO 20

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#20
	jsr	to_ip_pb

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; GOSUB 3020

	ldx	#LINE_3020
	jsr	gosub_ix

LINE_3430

	; GOSUB 3020

	ldx	#LINE_3020
	jsr	gosub_ix

LINE_3490

	; PRINT @306, "GAME OVER";

	ldd	#306
	jsr	prat_pw

	jsr	pr_ss
	.text	9, "GAME OVER"

LINE_3500

	; IF SC>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_3510
	jsr	jmpeq_ir1_ix

	; HS=SC

	ldd	#INTVAR_HS
	ldx	#INTVAR_SC
	jsr	ld_id_ix

LINE_3510

	; GOSUB 3030

	ldx	#LINE_3030
	jsr	gosub_ix

LINE_3520

	; PRINT @338, "PLAY AGAIN?";

	ldd	#338
	jsr	prat_pw

	jsr	pr_ss
	.text	11, "PLAY AGAIN?"

LINE_3530

	; GOSUB 3570

	ldx	#LINE_3570
	jsr	gosub_ix

LINE_3540

	; IF I$="N" THEN

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "N"

	ldx	#LINE_3550
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_3550

	; WHEN I$="Y" GOTO 1500

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#LINE_1500
	jsr	jmpne_ir1_ix

LINE_3560

	; GOTO 3530

	ldx	#LINE_3530
	jsr	goto_ix

LINE_3570

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; WHEN I$="" GOTO 3570

	ldx	#STRVAR_I
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_3570
	jsr	jmpne_ir1_ix

LINE_3610

	; RETURN

	jsr	return

LINE_3630

	; FOR T=16736 TO 16767

	ldx	#INTVAR_T
	ldd	#16736
	jsr	for_ix_pw

	ldd	#16767
	jsr	to_ip_pw

	; POKE T,147

	ldx	#INTVAR_T
	ldab	#147
	jsr	poke_ix_pb

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_3640

	; FOR T=16864 TO 16895

	ldx	#INTVAR_T
	ldd	#16864
	jsr	for_ix_pw

	ldd	#16895
	jsr	to_ip_pw

	; POKE T,159

	ldx	#INTVAR_T
	ldab	#159
	jsr	poke_ix_pb

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_4000

	; PRINT @T, "����������������";

	ldx	#INTVAR_T
	jsr	prat_ix

	jsr	pr_ss
	.text	16, "\x9E\x9C\x9C\x9E\x9F\x9E\x9E\x9C\x9C\x9E\x9F\x9F\x9E\x9F\x9F\x9F"

LINE_4010

	; PRINT @T+32, "����������������";

	ldx	#INTVAR_T
	ldab	#32
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x9A\x9C\x9C\x9A\x9F\x9A\x9A\x9C\x9F\x9A\x9F\x9F\x9A\x9F\x9F\x9F"

LINE_4020

	; PRINT @T+64, "����������������";

	ldx	#INTVAR_T
	ldab	#64
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x9E\x9C\x98\x9A\x98\x98\x9A\x9C\x9C\x9A\x9C\x9C\x9A\x9C\x9C\x9F"

	; RETURN

	jsr	return

LINE_4030

	; PRINT @T+96, "����������������";

	ldx	#INTVAR_T
	ldab	#96
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x9F\x9F\x9C\x9C\x9D\x9C\x9C\x9D\x9C\x9C\x9D\x9C\x9C\x9D\x9F\x9F"

LINE_4040

	; PRINT @T+128, "����������������";

	ldx	#INTVAR_T
	ldab	#128
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x9F\x9F\x94\x9D\x9F\x95\x9F\x95\x95\x9F\x95\x94\x9C\x95\x9F\x9F"

LINE_4050

	; PRINT @T+160, "����������������";

	ldx	#INTVAR_T
	ldab	#160
	jsr	add_ir1_ix_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	16, "\x9F\x9F\x95\x9F\x9F\x94\x9C\x95\x94\x9C\x95\x95\x9F\x9F\x9F\x9F"

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

	.module	mdrefflt
; return flt array reference in D/tmp1
refflt
	lsld
	addd	tmp1
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

	.module	mdshlflt
; multiply X by 2^ACCB for positive ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1
shlflt
	cmpb	#8
	blo	_shlbit
	stab	tmp1
	ldd	1,x
	std	0,x
	ldd	3,x
	std	2,x
	clr	4,x
	ldab	tmp1
	subb	#8
	bne	shlflt
	rts
_shlbit
	lsl	4,x
	rol	3,x
	rol	2,x
	rol	1,x
	rol	0,x
	decb
	bne	_shlbit
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

	.module	mdx2arg
; copy [X] to argv
;   ENTRY  Y in 0,x 1,x 2,x 3,x 4,x
;   EXIT   Y copied to 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
	; copy x to argv
x2arg
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	rts

add_fr1_fr1_ix			; numCalls = 1
	.module	modadd_fr1_fr1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 1
	.module	modadd_fr1_fr1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr1_ir1_fx			; numCalls = 6
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

add_ir1_ix_pb			; numCalls = 5
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

add_ix_ix_ir1			; numCalls = 2
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pw			; numCalls = 1
	.module	modadd_ix_ix_pw
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

arrdim1_ir1_fx			; numCalls = 2
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

arrdim1_ir1_ix			; numCalls = 1
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

arrdim2_ir1_fx			; numCalls = 1
	.module	modarrdim2_ir1_fx
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
	lsld
	addd	tmp3
	jmp	alloc

arrref1_ir1_fx_id			; numCalls = 2
	.module	modarrref1_ir1_fx_id
	jsr	getlw
	std	0+argv
	ldd	#5*11
	jsr	ref1
	jsr	refflt
	std	letptr
	rts

arrref1_ir1_ix_id			; numCalls = 1
	.module	modarrref1_ir1_ix_id
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_fx_id			; numCalls = 5
	.module	modarrref2_ir1_fx_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	ldd	#5*11*11
	jsr	ref2
	jsr	refflt
	std	letptr
	rts

arrref2_ir1_fx_ir2			; numCalls = 1
	.module	modarrref2_ir1_fx_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#5*11*11
	jsr	ref2
	jsr	refflt
	std	letptr
	rts

arrval1_ir1_fx_id			; numCalls = 1
	.module	modarrval1_ir1_fx_id
	jsr	getlw
	std	0+argv
	ldd	#5*11
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

arrval1_ir1_fx_ir1			; numCalls = 3
	.module	modarrval1_ir1_fx_ir1
	ldd	r1+1
	std	0+argv
	ldd	#5*11
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

arrval1_ir1_ix_id			; numCalls = 1
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

arrval2_ir1_fx_id			; numCalls = 12
	.module	modarrval2_ir1_fx_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	ldd	#5*11*11
	jsr	ref2
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	std	r1+3
	rts

arrval2_ir1_fx_ir2			; numCalls = 1
	.module	modarrval2_ir1_fx_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#5*11*11
	jsr	ref2
	jsr	refflt
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	std	r1+3
	rts

chr_sr1_ir1			; numCalls = 3
	.module	modchr_sr1_ir1
	ldd	#$0100+(charpage>>8)
	std	r1
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

clr_fp			; numCalls = 3
	.module	modclr_fp
	ldx	letptr
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

clr_fx			; numCalls = 4
	.module	modclr_fx
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

clr_ix			; numCalls = 7
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 3
	.module	modcls
	jmp	R_CLS

dec_fr1_fx			; numCalls = 2
	.module	moddec_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_fx_fx			; numCalls = 2
	.module	moddec_fx_fx
	ldd	3,x
	std	3,x
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

dec_ir1_ix			; numCalls = 1
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
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

dec_ix_ix			; numCalls = 5
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

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

for_ix_pw			; numCalls = 2
	.module	modfor_ix_pw
	stx	letptr
	clr	0,x
	std	1,x
	rts

forclr_fx			; numCalls = 4
	.module	modforclr_fx
	stx	letptr
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

forclr_ix			; numCalls = 4
	.module	modforclr_ix
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 2
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 23
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 13
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_fr1_fx			; numCalls = 4
	.module	modinc_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_fx_fx			; numCalls = 3
	.module	modinc_fx_fx
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inc_ir1_ix			; numCalls = 1
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

jmpeq_fr1_ix			; numCalls = 1
	.module	modjmpeq_fr1_ix
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	ldd	r1+3
	bne	_rts
	ins
	ins
	jmp	,x
_rts
	rts

jmpeq_ir1_ix			; numCalls = 19
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

jmpne_fr1_ix			; numCalls = 3
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

jmpne_ir1_ix			; numCalls = 16
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

ld_fd_fx			; numCalls = 8
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

ld_fp_fr1			; numCalls = 5
	.module	modld_fp_fr1
	ldx	letptr
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fr1_fx			; numCalls = 20
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 6
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_pb			; numCalls = 1
	.module	modld_fx_pb
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
	rts

ld_id_ix			; numCalls = 11
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

ld_ip_ir1			; numCalls = 1
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ir1_ix			; numCalls = 10
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

ld_ir1_pb			; numCalls = 9
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 6
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 4
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

ldeq_ir1_fr1_fx			; numCalls = 2
	.module	modldeq_ir1_fr1_fx
	ldd	r1+3
	subd	3,x
	bne	_done
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

ldeq_ir1_fx_pb			; numCalls = 1
	.module	modldeq_ir1_fx_pb
	cmpb	2,x
	bne	_done
	ldd	3,x
	bne	_done
	ldd	0,x
	bne	_done
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 9
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

ldge_ir1_ix_pb			; numCalls = 1
	.module	modldge_ir1_ix_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_fd			; numCalls = 4
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

ldlt_ir1_fx_fr1			; numCalls = 1
	.module	modldlt_ir1_fx_fr1
	ldd	3,x
	subd	r1+3
	ldd	1,x
	sbcb	r1+2
	sbca	r1+1
	ldab	0,x
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_pb			; numCalls = 2
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

ldlt_ir1_ix_id			; numCalls = 3
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

ldlt_ir1_ix_pb			; numCalls = 5
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

ldlt_ir2_fx_fd			; numCalls = 1
	.module	modldlt_ir2_fx_fd
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	std	r2+1
	ldd	3,x
	ldx	tmp1
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

ldlt_ir2_fx_pb			; numCalls = 1
	.module	modldlt_ir2_fx_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ix_pb			; numCalls = 1
	.module	modldlt_ir2_ix_pb
	clra
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_fr1_fx			; numCalls = 1
	.module	modldne_ir1_fr1_fx
	ldd	r1+3
	subd	3,x
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

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

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

or_ir1_ir1_ir2			; numCalls = 3
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

poke_ix_pb			; numCalls = 2
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

pr_sr1			; numCalls = 6
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 42
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_ir1			; numCalls = 11
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

prtab_pb			; numCalls = 3
	.module	modprtab_pb
	jmp	prtab

return			; numCalls = 20
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

shift_fr1_fr1_pb			; numCalls = 1
	.module	modshift_fr1_fr1_pb
	ldx	#r1
	jmp	shlflt

shift_ir1_ir1_pb			; numCalls = 6
	.module	modshift_ir1_ir1_pb
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 5
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

sq_ir1_ir1			; numCalls = 1
	.module	modsq_ir1_ir1
	ldx	#r1
	jsr	x2arg
	jmp	mulintx

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

str_sr1_ix			; numCalls = 3
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

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_fp_fr1			; numCalls = 1
	.module	modto_fp_fr1
	ldab	#15
	jmp	to

to_fp_ix			; numCalls = 3
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

to_ip_ix			; numCalls = 4
	.module	modto_ip_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pb			; numCalls = 2
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

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_F	.block	3
INTVAR_HS	.block	3
INTVAR_M	.block	3
INTVAR_MD	.block	3
INTVAR_NC	.block	3
INTVAR_O	.block	3
INTVAR_PY	.block	3
INTVAR_R	.block	3
INTVAR_SC	.block	3
INTVAR_T	.block	3
INTVAR_Y	.block	3
INTVAR_YD	.block	3
INTVAR_Z	.block	3
FLTVAR_A	.block	5
FLTVAR_E	.block	5
FLTVAR_L	.block	5
FLTVAR_N	.block	5
FLTVAR_PX	.block	5
FLTVAR_Q	.block	5
FLTVAR_S	.block	5
FLTVAR_X	.block	5
; String Variables
STRVAR_I	.block	3
; Numeric Arrays
INTARR_R	.block	4	; dims=1
FLTARR_B	.block	6	; dims=2
FLTARR_C	.block	4	; dims=1
FLTARR_Q	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

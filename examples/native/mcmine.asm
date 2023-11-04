; Assembly for mcmine.bas
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

	; POKE 49151,64

	ldab	#64
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; PRINT "PLEASE WAIT...\r";

	jsr	pr_ss
	.text	15, "PLEASE WAIT...\r"

LINE_1

	; DIM M(31,20),N(31,20),SX(101),SY(101),MX,MY,ST,MC,V,H,X,Y,Z,OH,OV,B,C,R

	ldab	#31
	jsr	ld_ir1_pb

	ldab	#20
	jsr	ld_ir2_pb

	ldx	#INTARR_M
	jsr	arrdim2_ir1_ix

	ldab	#31
	jsr	ld_ir1_pb

	ldab	#20
	jsr	ld_ir2_pb

	ldx	#INTARR_N
	jsr	arrdim2_ir1_ix

	ldab	#101
	jsr	ld_ir1_pb

	ldx	#FLTARR_SX
	jsr	arrdim1_ir1_fx

	ldab	#101
	jsr	ld_ir1_pb

	ldx	#FLTARR_SY
	jsr	arrdim1_ir1_fx

LINE_5

	; CLS

	jsr	cls

	; MC=16384

	ldx	#INTVAR_MC
	ldd	#16384
	jsr	ld_ix_pw

	; REM CHANGE MC=1024 FOR COCO

LINE_10

	; PRINT @11, "minefield";

	ldab	#11
	jsr	prat_pb

	jsr	pr_ss
	.text	9, "minefield"

	; POKE MC+20,33

	ldx	#INTVAR_MC
	ldab	#20
	jsr	add_ir1_ix_pb

	ldab	#33
	jsr	poke_ir1_pb

LINE_20

	; PRINT @100, "BY KENNETH REIGHARD, JR.\r";

	ldab	#100
	jsr	prat_pb

	jsr	pr_ss
	.text	25, "BY KENNETH REIGHARD, JR.\r"

LINE_30

	; PRINT @130, "MC-10 VERSION BY JIM GERRIE\r";

	ldab	#130
	jsr	prat_pb

	jsr	pr_ss
	.text	28, "MC-10 VERSION BY JIM GERRIE\r"

LINE_40

	; PRINT @268, "1. EASY\r";

	ldd	#268
	jsr	prat_pw

	jsr	pr_ss
	.text	8, "1. EASY\r"

	; PRINT @300, "2. MEDIUM\r";

	ldd	#300
	jsr	prat_pw

	jsr	pr_ss
	.text	10, "2. MEDIUM\r"

	; PRINT @332, "3. HARD\r";

	ldd	#332
	jsr	prat_pw

	jsr	pr_ss
	.text	8, "3. HARD\r"

LINE_50

	; QQ$=INKEY$

	ldx	#STRVAR_QQ
	jsr	inkey_sx

	; H=RND(10)

	ldab	#10
	jsr	irnd_ir1_pb

	ldx	#FLTVAR_H
	jsr	ld_fx_ir1

	; WHEN QQ$="" GOTO 50

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	0, ""

	ldx	#LINE_50
	jsr	jmpne_ir1_ix

LINE_55

	; WHEN (QQ$<>"1") AND (QQ$<>"2") AND (QQ$<>"3") GOTO 50

	ldx	#STRVAR_QQ
	jsr	ldne_ir1_sx_ss
	.text	1, "1"

	ldx	#STRVAR_QQ
	jsr	ldne_ir2_sx_ss
	.text	1, "2"

	jsr	and_ir1_ir1_ir2

	ldx	#STRVAR_QQ
	jsr	ldne_ir2_sx_ss
	.text	1, "3"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_50
	jsr	jmpne_ir1_ix

LINE_56

	; SK=VAL(QQ$)

	ldx	#STRVAR_QQ
	jsr	val_fr1_sx

	ldx	#FLTVAR_SK
	jsr	ld_fx_fr1

	; WHEN (SK<1) OR (SK>3) GOTO 50

	ldx	#FLTVAR_SK
	ldab	#1
	jsr	ldlt_ir1_fx_pb

	ldab	#3
	ldx	#FLTVAR_SK
	jsr	ldlt_ir2_pb_fx

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_50
	jsr	jmpne_ir1_ix

LINE_58

	; PRINT @454, "ONE MOMENT PLEASE...";

	ldd	#454
	jsr	prat_pw

	jsr	pr_ss
	.text	20, "ONE MOMENT PLEASE..."

LINE_60

	; ON SK GOTO 65,70,75

	ldx	#FLTVAR_SK
	jsr	ld_fr1_fx

	jsr	ongoto_ir1_is
	.byte	3
	.word	LINE_65, LINE_70, LINE_75

LINE_65

	; MX=9

	ldx	#INTVAR_MX
	ldab	#9
	jsr	ld_ix_pb

	; MY=9

	ldx	#INTVAR_MY
	ldab	#9
	jsr	ld_ix_pb

	; B=10

	ldx	#INTVAR_B
	ldab	#10
	jsr	ld_ix_pb

	; GOTO 80

	ldx	#LINE_80
	jsr	goto_ix

LINE_70

	; MX=19

	ldx	#INTVAR_MX
	ldab	#19
	jsr	ld_ix_pb

	; MY=12

	ldx	#INTVAR_MY
	ldab	#12
	jsr	ld_ix_pb

	; B=40

	ldx	#INTVAR_B
	ldab	#40
	jsr	ld_ix_pb

	; GOTO 80

	ldx	#LINE_80
	jsr	goto_ix

LINE_75

	; MX=31

	ldx	#INTVAR_MX
	ldab	#31
	jsr	ld_ix_pb

	; MY=14

	ldx	#INTVAR_MY
	ldab	#14
	jsr	ld_ix_pb

	; B=70

	ldx	#INTVAR_B
	ldab	#70
	jsr	ld_ix_pb

LINE_80

	; L=B

	ldd	#INTVAR_L
	ldx	#INTVAR_B
	jsr	ld_id_ix

	; R=((MX+1)*(MY+1))-B

	ldx	#INTVAR_MX
	jsr	inc_ir1_ix

	ldx	#INTVAR_MY
	jsr	inc_ir2_ix

	jsr	mul_ir1_ir1_ir2

	ldx	#INTVAR_B
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

LINE_100

	; FOR Z=1 TO B

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldx	#INTVAR_B
	jsr	to_ip_ix

LINE_105

	; H=RND(MX)

	ldx	#INTVAR_MX
	jsr	rnd_fr1_ix

	ldx	#FLTVAR_H
	jsr	ld_fx_fr1

	; V=RND(MY)

	ldx	#INTVAR_MY
	jsr	rnd_fr1_ix

	ldx	#FLTVAR_V
	jsr	ld_fx_fr1

	; WHEN M(H,V)=-1 GOTO 105

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_105
	jsr	jmpne_ir1_ix

LINE_112

	; M(H,V)=-1

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	jsr	true_ip

	; NEXT

	jsr	next

LINE_120

	; FOR V=0 TO MY

	ldx	#FLTVAR_V
	jsr	forclr_fx

	ldx	#INTVAR_MY
	jsr	to_fp_ix

	; FOR H=0 TO MX

	ldx	#FLTVAR_H
	jsr	forclr_fx

	ldx	#INTVAR_MX
	jsr	to_fp_ix

	; WHEN M(H,V)<>-1 GOTO 155

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#-1
	jsr	ldne_ir1_ir1_nb

	ldx	#LINE_155
	jsr	jmpne_ir1_ix

LINE_130

	; FOR Y=-1 TO 1

	ldx	#FLTVAR_Y
	jsr	fortrue_fx

	ldab	#1
	jsr	to_fp_pb

	; FOR X=-1 TO 1

	ldx	#FLTVAR_X
	jsr	fortrue_fx

	ldab	#1
	jsr	to_fp_pb

	; WHEN (X=0) AND (Y=0) GOTO 150

	ldx	#FLTVAR_X
	ldab	#0
	jsr	ldeq_ir1_fx_pb

	ldx	#FLTVAR_Y
	ldab	#0
	jsr	ldeq_ir2_fx_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_150
	jsr	jmpne_ir1_ix

LINE_140

	; WHEN ((H+X)<0) OR ((H+X)>MX) OR ((V+Y)<0) OR ((V+Y)>MY) GOTO 150

	ldx	#FLTVAR_H
	ldd	#FLTVAR_X
	jsr	add_fr1_fx_fd

	ldab	#0
	jsr	ldlt_ir1_fr1_pb

	ldx	#FLTVAR_H
	ldd	#FLTVAR_X
	jsr	add_fr2_fx_fd

	ldx	#INTVAR_MX
	jsr	ldlt_ir2_ix_fr2

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_V
	ldd	#FLTVAR_Y
	jsr	add_fr2_fx_fd

	ldab	#0
	jsr	ldlt_ir2_fr2_pb

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_V
	ldd	#FLTVAR_Y
	jsr	add_fr2_fx_fd

	ldx	#INTVAR_MY
	jsr	ldlt_ir2_ix_fr2

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_150
	jsr	jmpne_ir1_ix

LINE_145

	; IF M(H+X,V+Y)<>-1 THEN

	ldx	#FLTVAR_H
	ldd	#FLTVAR_X
	jsr	add_fr1_fx_fd

	ldx	#FLTVAR_V
	ldd	#FLTVAR_Y
	jsr	add_fr2_fx_fd

	ldx	#INTARR_M
	jsr	arrval2_ir1_ix_ir2

	ldab	#-1
	jsr	ldne_ir1_ir1_nb

	ldx	#LINE_150
	jsr	jmpeq_ir1_ix

	; M(H+X,V+Y)+=1

	ldx	#FLTVAR_H
	ldd	#FLTVAR_X
	jsr	add_fr1_fx_fd

	ldx	#FLTVAR_V
	ldd	#FLTVAR_Y
	jsr	add_fr2_fx_fd

	ldx	#INTARR_M
	jsr	arrref2_ir1_ix_ir2

	jsr	inc_ip_ip

LINE_150

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_155

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_160

	; CLS 0

	ldab	#0
	jsr	clsn_pb

	; FOR X=0 TO MX

	ldx	#FLTVAR_X
	jsr	forclr_fx

	ldx	#INTVAR_MX
	jsr	to_fp_ix

	; FOR Y=0 TO MY

	ldx	#FLTVAR_Y
	jsr	forclr_fx

	ldx	#INTVAR_MY
	jsr	to_fp_ix

	; PRINT @SHIFT(Y,5)+X, ".";

	ldx	#FLTVAR_Y
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_X
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "."

LINE_205

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_210

	; H=0

	ldx	#FLTVAR_H
	jsr	clr_fx

	; V=0

	ldx	#FLTVAR_V
	jsr	clr_fx

LINE_220

	; WHEN PEEK(SHIFT(V,5)+H+MC)>64 GOSUB 600

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	ldx	#INTVAR_MC
	jsr	add_fr1_fr1_ix

	jsr	peek_ir1_ir1

	ldab	#64
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_600
	jsr	jsrne_ir1_ix

LINE_230

	; PRINT @495, STR$(L);" €";

	ldd	#495
	jsr	prat_pw

	ldx	#INTVAR_L
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \x80"

	; IF R=0 THEN

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	ldx	#LINE_240
	jsr	jmpne_ir1_ix

	; PRINT @480, "YOU WIN!            ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	20, "YOU WIN!            "

	; GOTO 450

	ldx	#LINE_450
	jsr	goto_ix

LINE_240

	; Q=PEEK(17023) AND PEEK(2)

	ldd	#17023
	jsr	peek_ir1_pw

	jsr	peek2_ir2

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_Q
	jsr	ld_ix_ir1

	; WHEN Q GOTO 250

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#LINE_250
	jsr	jmpne_ir1_ix

LINE_245

	; GOTO 240

	ldx	#LINE_240
	jsr	goto_ix

LINE_250

	; QQ$=CHR$(Q)

	ldx	#INTVAR_Q
	jsr	chr_sr1_ix

	ldx	#STRVAR_QQ
	jsr	ld_sx_sr1

	; IF QQ$="A" THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "A"

	ldx	#LINE_255
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; H-=1

	ldx	#FLTVAR_H
	jsr	dec_fx_fx

	; IF H<0 THEN

	ldx	#FLTVAR_H
	ldab	#0
	jsr	ldlt_ir1_fx_pb

	ldx	#LINE_255
	jsr	jmpeq_ir1_ix

	; H=MX

	ldd	#FLTVAR_H
	ldx	#INTVAR_MX
	jsr	ld_fd_ix

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_255

	; IF QQ$="S" THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "S"

	ldx	#LINE_260
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; H+=1

	ldx	#FLTVAR_H
	jsr	inc_fx_fx

	; IF H>MX THEN

	ldx	#INTVAR_MX
	ldd	#FLTVAR_H
	jsr	ldlt_ir1_ix_fd

	ldx	#LINE_260
	jsr	jmpeq_ir1_ix

	; H=0

	ldx	#FLTVAR_H
	jsr	clr_fx

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_260

	; IF QQ$="Z" THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "Z"

	ldx	#LINE_265
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; V+=1

	ldx	#FLTVAR_V
	jsr	inc_fx_fx

	; IF V>MY THEN

	ldx	#INTVAR_MY
	ldd	#FLTVAR_V
	jsr	ldlt_ir1_ix_fd

	ldx	#LINE_265
	jsr	jmpeq_ir1_ix

	; V=0

	ldx	#FLTVAR_V
	jsr	clr_fx

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_265

	; IF QQ$="W" THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "W"

	ldx	#LINE_270
	jsr	jmpeq_ir1_ix

	; GOSUB 620

	ldx	#LINE_620
	jsr	gosub_ix

	; V-=1

	ldx	#FLTVAR_V
	jsr	dec_fx_fx

	; IF V<0 THEN

	ldx	#FLTVAR_V
	ldab	#0
	jsr	ldlt_ir1_fx_pb

	ldx	#LINE_270
	jsr	jmpeq_ir1_ix

	; V=MY

	ldd	#FLTVAR_V
	ldx	#INTVAR_MY
	jsr	ld_fd_ix

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_270

	; IF (QQ$="\r") AND (N(H,V)=0) AND (L>0) THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "\r"

	ldx	#FLTVAR_H
	jsr	ld_fr2_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrval2_ir2_ix_id

	ldab	#0
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldab	#0
	ldx	#INTVAR_L
	jsr	ldlt_ir2_pb_ix

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_272
	jsr	jmpeq_ir1_ix

	; PRINT @SHIFT(V,5)+H, "?";

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "?"

	; N(H,V)=1

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	jsr	one_ip

	; L-=1

	ldx	#INTVAR_L
	jsr	dec_ix_ix

	; FOR Z=1 TO 35

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#35
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_272

	; IF (QQ$="\r") AND (N(H,V)=1) THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "\r"

	ldx	#FLTVAR_H
	jsr	ld_fr2_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrval2_ir2_ix_id

	ldab	#1
	jsr	ldeq_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_275
	jsr	jmpeq_ir1_ix

	; PRINT @SHIFT(V,5)+H, ".";

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "."

	; N(H,V)=0

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	jsr	clr_ip

	; L+=1

	ldx	#INTVAR_L
	jsr	inc_ix_ix

	; FOR Z=1 TO 35

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#35
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_275

	; WHEN QQ$<>" " GOTO 220

	ldx	#STRVAR_QQ
	jsr	ldne_ir1_sx_ss
	.text	1, " "

	ldx	#LINE_220
	jsr	jmpne_ir1_ix

LINE_280

	; WHEN N(H,V)<>0 GOTO 220

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldx	#LINE_220
	jsr	jmpne_ir1_ix

LINE_285

	; POKE SHIFT(V,5)+H+MC,96

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	ldx	#INTVAR_MC
	jsr	add_fr1_fr1_ix

	ldab	#96
	jsr	poke_ir1_pb

	; C=M(H,V)

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldx	#INTVAR_C
	jsr	ld_ix_ir1

	; WHEN C=-1 GOTO 400

	ldx	#INTVAR_C
	ldab	#-1
	jsr	ldeq_ir1_ix_nb

	ldx	#LINE_400
	jsr	jmpne_ir1_ix

LINE_300

	; R-=1

	ldx	#INTVAR_R
	jsr	dec_ix_ix

LINE_305

	; IF C=0 THEN

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	ldx	#LINE_310
	jsr	jmpne_ir1_ix

	; N(H,V)=3

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	ldab	#3
	jsr	ld_ip_pb

	; GOTO 325

	ldx	#LINE_325
	jsr	goto_ix

LINE_310

	; PRINT @SHIFT(V,5)+H, CHR$(C+48);

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	ldx	#INTVAR_C
	ldab	#48
	jsr	add_ir1_ix_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	; N(H,V)=2

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	ldab	#2
	jsr	ld_ip_pb

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_325

	; OH=H

	ldd	#FLTVAR_OH
	ldx	#FLTVAR_H
	jsr	ld_fd_fx

	; OV=V

	ldd	#FLTVAR_OV
	ldx	#FLTVAR_V
	jsr	ld_fd_fx

	; ST=1

	ldx	#INTVAR_ST
	jsr	one_ix

	; SX(ST)=H

	ldx	#FLTARR_SX
	ldd	#INTVAR_ST
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	jsr	ld_fp_fr1

	; SY(ST)=V

	ldx	#FLTARR_SY
	ldd	#INTVAR_ST
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	jsr	ld_fp_fr1

LINE_335

	; IF ST=0 THEN

	ldx	#INTVAR_ST
	jsr	ld_ir1_ix

	ldx	#LINE_340
	jsr	jmpne_ir1_ix

	; H=OH

	ldd	#FLTVAR_H
	ldx	#FLTVAR_OH
	jsr	ld_fd_fx

	; V=OV

	ldd	#FLTVAR_V
	ldx	#FLTVAR_OV
	jsr	ld_fd_fx

	; GOTO 220

	ldx	#LINE_220
	jsr	goto_ix

LINE_340

	; X=SX(ST)

	ldx	#FLTARR_SX
	ldd	#INTVAR_ST
	jsr	arrval1_ir1_fx_id

	ldx	#FLTVAR_X
	jsr	ld_fx_fr1

	; Y=SY(ST)

	ldx	#FLTARR_SY
	ldd	#INTVAR_ST
	jsr	arrval1_ir1_fx_id

	ldx	#FLTVAR_Y
	jsr	ld_fx_fr1

	; FOR H=X-1 TO X+1

	ldx	#FLTVAR_X
	jsr	dec_fr1_fx

	ldx	#FLTVAR_H
	jsr	for_fx_fr1

	ldx	#FLTVAR_X
	jsr	inc_fr1_fx

	jsr	to_fp_fr1

	; FOR V=Y-1 TO Y+1

	ldx	#FLTVAR_Y
	jsr	dec_fr1_fx

	ldx	#FLTVAR_V
	jsr	for_fx_fr1

	ldx	#FLTVAR_Y
	jsr	inc_fr1_fx

	jsr	to_fp_fr1

LINE_350

	; WHEN (H<0) OR (H>MX) OR (V<0) OR (V>MY) GOTO 390

	ldx	#FLTVAR_H
	ldab	#0
	jsr	ldlt_ir1_fx_pb

	ldx	#INTVAR_MX
	ldd	#FLTVAR_H
	jsr	ldlt_ir2_ix_fd

	jsr	or_ir1_ir1_ir2

	ldx	#FLTVAR_V
	ldab	#0
	jsr	ldlt_ir2_fx_pb

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_MY
	ldd	#FLTVAR_V
	jsr	ldlt_ir2_ix_fd

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_390
	jsr	jmpne_ir1_ix

LINE_355

	; WHEN N(H,V)<>0 GOTO 390

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldx	#LINE_390
	jsr	jmpne_ir1_ix

LINE_360

	; IF M(H,V)>0 THEN

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#0
	jsr	ldlt_ir1_pb_ir1

	ldx	#LINE_365
	jsr	jmpeq_ir1_ix

	; N(H,V)=2

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	ldab	#2
	jsr	ld_ip_pb

	; R-=1

	ldx	#INTVAR_R
	jsr	dec_ix_ix

	; PRINT @SHIFT(V,5)+H, CHR$(M(H,V)+48);

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#48
	jsr	add_ir1_ir1_pb

	jsr	chr_sr1_ir1

	jsr	pr_sr1

	; GOTO 390

	ldx	#LINE_390
	jsr	goto_ix

LINE_365

	; WHEN M(H,V)=-1 GOTO 390

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_390
	jsr	jmpne_ir1_ix

LINE_370

	; POKE SHIFT(V,5)+H+MC,96

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	ldx	#INTVAR_MC
	jsr	add_fr1_fr1_ix

	ldab	#96
	jsr	poke_ir1_pb

	; N(H,V)=3

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrref2_ir1_ix_id

	ldab	#3
	jsr	ld_ip_pb

LINE_380

	; R-=1

	ldx	#INTVAR_R
	jsr	dec_ix_ix

	; ST+=1

	ldx	#INTVAR_ST
	jsr	inc_ix_ix

	; SX(ST)=H

	ldx	#FLTARR_SX
	ldd	#INTVAR_ST
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	jsr	ld_fp_fr1

	; SY(ST)=V

	ldx	#FLTARR_SY
	ldd	#INTVAR_ST
	jsr	arrref1_ir1_fx_id

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	jsr	ld_fp_fr1

	; GOTO 340

	ldx	#LINE_340
	jsr	goto_ix

LINE_390

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_395

	; ST-=1

	ldx	#INTVAR_ST
	jsr	dec_ix_ix

	; GOTO 335

	ldx	#LINE_335
	jsr	goto_ix

LINE_400

	; POKE SHIFT(V,5)+H+MC,42

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	ldx	#INTVAR_MC
	jsr	add_fr1_fr1_ix

	ldab	#42
	jsr	poke_ir1_pb

	; GOSUB 8000

	ldx	#LINE_8000
	jsr	gosub_ix

	; PRINT @480, "YOU LOSE.          ";

	ldd	#480
	jsr	prat_pw

	jsr	pr_ss
	.text	19, "YOU LOSE.          "

LINE_405

	; FOR V=0 TO MY

	ldx	#FLTVAR_V
	jsr	forclr_fx

	ldx	#INTVAR_MY
	jsr	to_fp_ix

	; FOR H=0 TO MX

	ldx	#FLTVAR_H
	jsr	forclr_fx

	ldx	#INTVAR_MX
	jsr	to_fp_ix

LINE_410

	; IF M(H,V)=-1 THEN

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#LINE_415
	jsr	jmpeq_ir1_ix

	; PRINT @SHIFT(V,5)+H, "*";

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "*"

LINE_415

	; IF (N(H,V)=1) AND (M(H,V)<>-1) THEN

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#1
	jsr	ldeq_ir1_ir1_pb

	ldx	#FLTVAR_H
	jsr	ld_fr2_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir2_ix_id

	ldab	#-1
	jsr	ldne_ir2_ir2_nb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_420
	jsr	jmpeq_ir1_ix

	; PRINT @SHIFT(V,5)+H, "X";

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "X"

LINE_420

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_450

	; FOR V=0 TO MY

	ldx	#FLTVAR_V
	jsr	forclr_fx

	ldx	#INTVAR_MY
	jsr	to_fp_ix

	; FOR H=0 TO MX

	ldx	#FLTVAR_H
	jsr	forclr_fx

	ldx	#INTVAR_MX
	jsr	to_fp_ix

	; IF (M(H,V)=-1) AND (N(H,V)<>1) THEN

	ldx	#FLTVAR_H
	jsr	ld_fr1_fx

	ldx	#INTARR_M
	ldd	#FLTVAR_V
	jsr	arrval2_ir1_ix_id

	ldab	#-1
	jsr	ldeq_ir1_ir1_nb

	ldx	#FLTVAR_H
	jsr	ld_fr2_fx

	ldx	#INTARR_N
	ldd	#FLTVAR_V
	jsr	arrval2_ir2_ix_id

	ldab	#1
	jsr	ldne_ir2_ir2_pb

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_460
	jsr	jmpeq_ir1_ix

	; PRINT @SHIFT(V,5)+H, "*";

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "*"

LINE_460

	; NEXT

	jsr	next

	; NEXT

	jsr	next

LINE_480

	; PRINT @495, "PLAY AGAIN (Y/N)";

	ldd	#495
	jsr	prat_pw

	jsr	pr_ss
	.text	16, "PLAY AGAIN (Y/N)"

	; POKE MC+511,127

	ldx	#INTVAR_MC
	ldd	#511
	jsr	add_ir1_ix_pw

	ldab	#127
	jsr	poke_ir1_pb

LINE_560

	; QQ$=INKEY$

	ldx	#STRVAR_QQ
	jsr	inkey_sx

	; IF (QQ$="Y") OR (QQ$="Y") THEN

	ldx	#STRVAR_QQ
	jsr	ldeq_ir1_sx_ss
	.text	1, "Y"

	ldx	#STRVAR_QQ
	jsr	ldeq_ir2_sx_ss
	.text	1, "Y"

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_570
	jsr	jmpeq_ir1_ix

	; RUN

	jsr	clear

	ldx	#LINE_0
	jsr	goto_ix

LINE_570

	; WHEN (QQ$<>"N") AND (QQ$<>"N") GOTO 560

	ldx	#STRVAR_QQ
	jsr	ldne_ir1_sx_ss
	.text	1, "N"

	ldx	#STRVAR_QQ
	jsr	ldne_ir2_sx_ss
	.text	1, "N"

	jsr	and_ir1_ir1_ir2

	ldx	#LINE_560
	jsr	jmpne_ir1_ix

LINE_580

	; SOUND 100,1

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; END

	jsr	progend

LINE_600

	; POKE SHIFT(V,5)+H+MC,PEEK(SHIFT(V,5)+H+MC)-64

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	ldx	#INTVAR_MC
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_V
	jsr	ld_fr2_fx

	ldab	#5
	jsr	shift_fr2_fr2_pb

	ldx	#FLTVAR_H
	jsr	add_fr2_fr2_fx

	ldx	#INTVAR_MC
	jsr	add_fr2_fr2_ix

	jsr	peek_ir2_ir2

	ldab	#64
	jsr	sub_ir2_ir2_pb

	jsr	poke_ir1_ir2

	; RETURN

	jsr	return

LINE_620

	; POKE SHIFT(V,5)+H+MC,PEEK(SHIFT(V,5)+H+MC)+64

	ldx	#FLTVAR_V
	jsr	ld_fr1_fx

	ldab	#5
	jsr	shift_fr1_fr1_pb

	ldx	#FLTVAR_H
	jsr	add_fr1_fr1_fx

	ldx	#INTVAR_MC
	jsr	add_fr1_fr1_ix

	ldx	#FLTVAR_V
	jsr	ld_fr2_fx

	ldab	#5
	jsr	shift_fr2_fr2_pb

	ldx	#FLTVAR_H
	jsr	add_fr2_fr2_fx

	ldx	#INTVAR_MC
	jsr	add_fr2_fr2_ix

	jsr	peek_ir2_ir2

	ldab	#64
	jsr	add_ir2_ir2_pb

	jsr	poke_ir1_ir2

	; RETURN

	jsr	return

LINE_8000

	; FOR X=1 TO 10

	ldx	#FLTVAR_X
	jsr	forone_fx

	ldab	#10
	jsr	to_fp_pb

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE 49151,64

	ldab	#64
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; FOR Z=1 TO 35

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#35
	jsr	to_ip_pb

	; NEXT

	jsr	next

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

add_fr1_fr1_fx			; numCalls = 14
	.module	modadd_fr1_fr1_fx
	ldd	r1+3
	addd	3,x
	std	r1+3
	ldd	r1+1
	adcb	2,x
	adca	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fr1_ix			; numCalls = 6
	.module	modadd_fr1_fr1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fx_fd			; numCalls = 3
	.module	modadd_fr1_fx_fd
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	3,x
	ldx	tmp1
	addd	3,x
	std	r1+3
	ldd	r1+1
	adcb	2,x
	adca	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr2_fr2_fx			; numCalls = 2
	.module	modadd_fr2_fr2_fx
	ldd	r2+3
	addd	3,x
	std	r2+3
	ldd	r2+1
	adcb	2,x
	adca	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_fr2_fr2_ix			; numCalls = 2
	.module	modadd_fr2_fr2_ix
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_fr2_fx_fd			; numCalls = 5
	.module	modadd_fr2_fx_fd
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	std	r2+1
	ldd	3,x
	ldx	tmp1
	addd	3,x
	std	r2+3
	ldd	r2+1
	adcb	2,x
	adca	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ir1_ir1_pb			; numCalls = 1
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

add_ir1_ix_pw			; numCalls = 1
	.module	modadd_ir1_ix_pw
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
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

arrref1_ir1_fx_id			; numCalls = 4
	.module	modarrref1_ir1_fx_id
	jsr	getlw
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	std	letptr
	rts

arrref2_ir1_ix_id			; numCalls = 7
	.module	modarrref2_ir1_ix_id
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix_ir2			; numCalls = 1
	.module	modarrref2_ir1_ix_ir2
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_fx_id			; numCalls = 2
	.module	modarrval1_ir1_fx_id
	jsr	getlw
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

arrval2_ir1_ix_id			; numCalls = 11
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

arrval2_ir2_ix_id			; numCalls = 4
	.module	modarrval2_ir2_ix_id
	jsr	getlw
	std	2+argv
	ldd	r2+1
	std	0+argv
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

chr_sr1_ir1			; numCalls = 2
	.module	modchr_sr1_ir1
	ldd	#$0100+(charpage>>8)
	std	r1
	rts

chr_sr1_ix			; numCalls = 1
	.module	modchr_sr1_ix
	ldab	2,x
	stab	r1+2
	ldd	#$0100+(charpage>>8)
	std	r1
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

clr_fx			; numCalls = 4
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

cls			; numCalls = 2
	.module	modcls
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jmp	R_CLSN

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

dec_ix_ix			; numCalls = 5
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_fx_fr1			; numCalls = 2
	.module	modfor_fx_fr1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	ldd	r1+3
	std	3,x
	rts

forclr_fx			; numCalls = 8
	.module	modforclr_fx
	stx	letptr
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

forone_fx			; numCalls = 1
	.module	modforone_fx
	stx	letptr
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

forone_ix			; numCalls = 4
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

fortrue_fx			; numCalls = 2
	.module	modfortrue_fx
	stx	letptr
	ldd	#0
	std	3,x
	ldd	#-1
	std	1,x
	stab	0,x
	rts

gosub_ix			; numCalls = 5
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 17
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_fr1_fx			; numCalls = 2
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

inc_fx_fx			; numCalls = 2
	.module	modinc_fx_fx
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
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

inc_ir1_ix			; numCalls = 1
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

inc_ix_ix			; numCalls = 2
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

ld_fd_fx			; numCalls = 4
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

ld_fp_fr1			; numCalls = 4
	.module	modld_fp_fr1
	ldx	letptr
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fr1_fx			; numCalls = 37
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 6
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 5
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 1
	.module	modld_fx_ir1
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
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

ld_ip_pb			; numCalls = 4
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 4
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 8
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 4
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

ld_ix_pb			; numCalls = 9
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

ld_sx_sr1			; numCalls = 1
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir1_ir1_nb			; numCalls = 4
	.module	modldeq_ir1_ir1_nb
	cmpb	r1+2
	bne	_done
	ldd	r1
	subd	#-1
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

ldeq_ir1_ix_nb			; numCalls = 1
	.module	modldeq_ir1_ix_nb
	cmpb	2,x
	bne	_done
	ldd	0,x
	subd	#-1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 8
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

ldeq_ir2_fx_pb			; numCalls = 1
	.module	modldeq_ir2_fx_pb
	cmpb	2,x
	bne	_done
	ldd	3,x
	bne	_done
	ldd	0,x
	bne	_done
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_pb			; numCalls = 2
	.module	modldeq_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_sx_ss			; numCalls = 1
	.module	modldeq_ir2_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
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

ldlt_ir1_fx_pb			; numCalls = 4
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

ldlt_ir1_ix_fd			; numCalls = 2
	.module	modldlt_ir1_ix_fd
	std	tmp1
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
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

ldlt_ir1_pb_ir1			; numCalls = 2
	.module	modldlt_ir1_pb_ir1
	clra
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_fr2_pb			; numCalls = 1
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

ldlt_ir2_ix_fd			; numCalls = 2
	.module	modldlt_ir2_ix_fd
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	std	r2+1
	ldd	#0
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

ldlt_ir2_ix_fr2			; numCalls = 2
	.module	modldlt_ir2_ix_fr2
	ldd	#0
	subd	r2+3
	ldd	1,x
	sbcb	r2+2
	sbca	r2+1
	ldab	0,x
	sbcb	r2
	jsr	getlt
	std	r2+1
	stab	r2
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

ldlt_ir2_pb_ix			; numCalls = 1
	.module	modldlt_ir2_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_nb			; numCalls = 2
	.module	modldne_ir1_ir1_nb
	cmpb	r1+2
	bne	_done
	ldd	r1
	subd	#-1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_sx_ss			; numCalls = 3
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

ldne_ir2_ir2_nb			; numCalls = 1
	.module	modldne_ir2_ir2_nb
	cmpb	r2+2
	bne	_done
	ldd	r2
	subd	#-1
_done
	jsr	getne
	std	r2+1
	stab	r2
	rts

ldne_ir2_ir2_pb			; numCalls = 1
	.module	modldne_ir2_ir2_pb
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	getne
	std	r2+1
	stab	r2
	rts

ldne_ir2_sx_ss			; numCalls = 3
	.module	modldne_ir2_sx_ss
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	jsr	streqs
	jsr	getne
	std	r2+1
	stab	r2
	rts

mul_ir1_ir1_ir2			; numCalls = 1
	.module	modmul_ir1_ir1_ir2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldx	#r1
	jmp	mulintx

next			; numCalls = 17
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

one_ip			; numCalls = 1
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

or_ir1_ir1_ir2			; numCalls = 8
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek2_ir2			; numCalls = 1
	.module	modpeek2_ir2
	jsr	R_KPOLL
	ldab	2
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir1_ir1			; numCalls = 1
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pw			; numCalls = 1
	.module	modpeek_ir1_pw
	std	tmp1
	ldx	tmp1
	jsr	peek
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

poke_ir1_ir2			; numCalls = 2
	.module	modpoke_ir1_ir2
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 5
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_pw_ir1			; numCalls = 2
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
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

pr_ss			; numCalls = 18
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

prat_ir1			; numCalls = 8
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 3
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

return			; numCalls = 3
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

rnd_fr1_ix			; numCalls = 2
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

shift_fr1_fr1_pb			; numCalls = 14
	.module	modshift_fr1_fr1_pb
	ldx	#r1
	jmp	shlflt

shift_fr2_fr2_pb			; numCalls = 2
	.module	modshift_fr2_fr2_pb
	ldx	#r2
	jmp	shlflt

sound_ir1_ir2			; numCalls = 2
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

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

sub_ir2_ir2_pb			; numCalls = 1
	.module	modsub_ir2_ir2_pb
	stab	tmp1
	ldd	r2+1
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	r2
	sbcb	#0
	stab	r2
	rts

to_fp_fr1			; numCalls = 2
	.module	modto_fp_fr1
	ldab	#15
	jmp	to

to_fp_ix			; numCalls = 8
	.module	modto_fp_ix
	ldab	0,x
	stab	r1
	ldd	1,x
	std	r1+1
	ldd	#0
	std	r1+3
	ldab	#15
	jmp	to

to_fp_pb			; numCalls = 3
	.module	modto_fp_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_ix			; numCalls = 1
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
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_L	.block	3
INTVAR_MC	.block	3
INTVAR_MX	.block	3
INTVAR_MY	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_ST	.block	3
INTVAR_Z	.block	3
FLTVAR_H	.block	5
FLTVAR_OH	.block	5
FLTVAR_OV	.block	5
FLTVAR_SK	.block	5
FLTVAR_V	.block	5
FLTVAR_X	.block	5
FLTVAR_Y	.block	5
; String Variables
STRVAR_QQ	.block	3
; Numeric Arrays
INTARR_M	.block	6	; dims=2
INTARR_N	.block	6	; dims=2
FLTARR_SX	.block	4	; dims=1
FLTARR_SY	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

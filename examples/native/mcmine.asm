; Assembly for mcmine.bas
; compiled with mcbasic

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
curinst	.block	2
nxtinst	.block	2
tmp1	.block	2
tmp2	.block	2
tmp3	.block	2
tmp4	.block	2
tmp5	.block	2
argv	.block	10

	.org	M_CODE

	.module	mdmain
	ldx	#program
	stx	nxtinst
mainloop
	ldx	nxtinst
	stx	curinst
	ldab	,x
	ldx	#catalog
	abx
	abx
	ldx	,x
	jsr	0,x
	bra	mainloop

program

	.byte	bytecode_progbegin

	.byte	bytecode_clear

LINE_0

	; CLS

	.byte	bytecode_cls

	; POKE 49151,64

	.byte	bytecode_ld_ir1_pb
	.byte	64

	.byte	bytecode_poke_pw_ir1
	.word	49151

	; PRINT "PLEASE WAIT..."

	.byte	bytecode_pr_ss
	.text	15, "PLEASE WAIT...\r"

LINE_1

	; DIM M(31,20),N(31,20),TT(4),SX(101),SY(101),MX,MY,ST,MC,V,H,X,Y,Z,OH,OV,B,C,R

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	20

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	20

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_TT

	.byte	bytecode_ld_ir1_pb
	.byte	101

	.byte	bytecode_arrdim1_ir1_fx
	.byte	bytecode_FLTARR_SX

	.byte	bytecode_ld_ir1_pb
	.byte	101

	.byte	bytecode_arrdim1_ir1_fx
	.byte	bytecode_FLTARR_SY

LINE_5

	; CLS

	.byte	bytecode_cls

	; MC=16384

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_MC
	.word	16384

	; REM CHANGE MC=1024 FOR COCO

LINE_10

	; PRINT @11, "minefield";

	.byte	bytecode_prat_pb
	.byte	11

	.byte	bytecode_pr_ss
	.text	9, "minefield"

	; POKE MC+20,33

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_add_ir1_ir1_pb
	.byte	20

	.byte	bytecode_poke_ir1_pb
	.byte	33

LINE_20

	; PRINT @100, "BY KENNETH REIGHARD, JR."

	.byte	bytecode_prat_pb
	.byte	100

	.byte	bytecode_pr_ss
	.text	25, "BY KENNETH REIGHARD, JR.\r"

LINE_30

	; PRINT @130, "MC-10 VERSION BY JIM GERRIE"

	.byte	bytecode_prat_pb
	.byte	130

	.byte	bytecode_pr_ss
	.text	28, "MC-10 VERSION BY JIM GERRIE\r"

LINE_40

	; PRINT @268, "1. EASY"

	.byte	bytecode_prat_pw
	.word	268

	.byte	bytecode_pr_ss
	.text	8, "1. EASY\r"

	; PRINT @300, "2. MEDIUM"

	.byte	bytecode_prat_pw
	.word	300

	.byte	bytecode_pr_ss
	.text	10, "2. MEDIUM\r"

	; PRINT @332, "3. HARD"

	.byte	bytecode_prat_pw
	.word	332

	.byte	bytecode_pr_ss
	.text	8, "3. HARD\r"

LINE_50

	; QQ$=INKEY$

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_QQ

	; H=RND(10)

	.byte	bytecode_irnd_ir1_pb
	.byte	10

	.byte	bytecode_ld_fx_ir1
	.byte	bytecode_FLTVAR_H

	; IF QQ$="" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_50

LINE_55

	; IF (QQ$<>"1") AND (QQ$<>"2") AND (QQ$<>"3") THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldne_ir1_sr1_ss
	.text	1, "1"

	.byte	bytecode_ld_sr2_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldne_ir2_sr2_ss
	.text	1, "2"

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_ld_sr2_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldne_ir2_sr2_ss
	.text	1, "3"

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_50

LINE_56

	; SK=VAL(QQ$)

	.byte	bytecode_val_fr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_SK

	; IF (SK<1) OR (SK>3) THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_SK

	.byte	bytecode_ldlt_ir1_fr1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_ldlt_ir2_ir2_fx
	.byte	bytecode_FLTVAR_SK

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_50

LINE_58

	; PRINT @454, "ONE MOMENT PLEASE...";

	.byte	bytecode_prat_pw
	.word	454

	.byte	bytecode_pr_ss
	.text	20, "ONE MOMENT PLEASE..."

LINE_60

	; ON SK GOTO 65,70,75

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_SK

	.byte	bytecode_ongoto_ir1_is
	.byte	3
	.word	LINE_65, LINE_70, LINE_75

LINE_65

	; MX=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MX
	.byte	9

	; MY=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MY
	.byte	9

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOTO 80

	.byte	bytecode_goto_ix
	.word	LINE_80

LINE_70

	; MX=19

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MX
	.byte	19

	; MY=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MY
	.byte	12

	; B=40

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	40

	; GOTO 80

	.byte	bytecode_goto_ix
	.word	LINE_80

LINE_75

	; MX=31

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MX
	.byte	31

	; MY=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MY
	.byte	14

	; B=70

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	70

LINE_80

	; L=B

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_L

	; R=((MX+1)*(MY+1))-B

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MX

	.byte	bytecode_add_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_MY

	.byte	bytecode_add_ir2_ir2_pb
	.byte	1

	.byte	bytecode_mul_ir1_ir1_ir2

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_R

LINE_100

	; FOR Z=1 TO B

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	1

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_B

LINE_105

	; H=RND(MX)

	.byte	bytecode_rnd_fr1_ix
	.byte	bytecode_INTVAR_MX

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_H

	; V=RND(MY)

	.byte	bytecode_rnd_fr1_ix
	.byte	bytecode_INTVAR_MY

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_V

	; IF M(H,V)=-1 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_105

LINE_112

	; M(H,V)=-1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ip_nb
	.byte	-1

	; NEXT

	.byte	bytecode_next

LINE_120

	; FOR V=0 TO MY

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MY

	; FOR H=0 TO MX

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MX

	; IF M(H,V)<>-1 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldne_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_155

LINE_130

	; FOR Y=-1 TO 1

	.byte	bytecode_for_fx_nb
	.byte	bytecode_FLTVAR_Y
	.byte	-1

	.byte	bytecode_to_fp_pb
	.byte	1

	; FOR X=-1 TO 1

	.byte	bytecode_for_fx_nb
	.byte	bytecode_FLTVAR_X
	.byte	-1

	.byte	bytecode_to_fp_pb
	.byte	1

	; IF (X=0) AND (Y=0) THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_ldeq_ir2_fr2_pb
	.byte	0

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_150

LINE_140

	; IF ((H+X)<0) OR ((H+X)>MX) OR ((V+Y)<0) OR ((V+Y)>MY) THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldlt_ir1_fr1_pb
	.byte	0

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_MX

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr3_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldlt_ir2_ir2_fr3

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_ldlt_ir2_fr2_pb
	.byte	0

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_MY

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr3_fr3_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_ldlt_ir2_ir2_fr3

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_150

LINE_145

	; IF M(H+X,V+Y)<>-1 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldne_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_150

	; M(H+X,V+Y)=M(H+X,V+Y)+1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_add_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ip_ir1

LINE_150

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_155

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_160

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; FOR X=0 TO MX

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_X
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MX

	; FOR Y=0 TO MY

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_Y
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MY

	; PRINT @(Y*32)+X, ".";

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	1, "."

LINE_205

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_210

	; H=0

	.byte	bytecode_ld_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	0

	; V=0

	.byte	bytecode_ld_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	0

	; T=0

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	0

LINE_220

	; IF (PEEK((32*V)+H+MC)-64)>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	32

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr2_fr2_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_peek_ir2_ir2

	.byte	bytecode_sub_ir2_ir2_pb
	.byte	64

	.byte	bytecode_ldlt_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_230

	; GOSUB 600

	.byte	bytecode_gosub_ix
	.word	LINE_600

LINE_230

	; PRINT @495, STR$(L);" €";

	.byte	bytecode_prat_pw
	.word	495

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \x80"

	; IF R=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_240

	; PRINT @480, "YOU WIN!            ";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	20, "YOU WIN!            "

	; GOTO 450

	.byte	bytecode_goto_ix
	.word	LINE_450

LINE_240

	; Q=PEEK(17023) AND PEEK(2)

	.byte	bytecode_peek_ir1_pw
	.word	17023

	.byte	bytecode_peek_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Q

	; IF Q THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_250

LINE_245

	; GOTO 240

	.byte	bytecode_goto_ix
	.word	LINE_240

LINE_250

	; QQ$=CHR$(Q)

	.byte	bytecode_chr_sr1_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_QQ

	; IF QQ$="A" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "A"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_255

	; GOSUB 620

	.byte	bytecode_gosub_ix
	.word	LINE_620

	; H-=1

	.byte	bytecode_sub_fx_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	1

	; IF H<0 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ldlt_ir1_fr1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_255

	; H=MX

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MX

	.byte	bytecode_ld_fx_ir1
	.byte	bytecode_FLTVAR_H

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_255

	; IF QQ$="S" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "S"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_260

	; GOSUB 620

	.byte	bytecode_gosub_ix
	.word	LINE_620

	; H+=1

	.byte	bytecode_add_fx_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	1

	; IF H>MX THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MX

	.byte	bytecode_ldlt_ir1_ir1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_260

	; H=0

	.byte	bytecode_ld_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	0

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_260

	; IF QQ$="Z" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Z"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_265

	; GOSUB 620

	.byte	bytecode_gosub_ix
	.word	LINE_620

	; V+=1

	.byte	bytecode_add_fx_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	1

	; IF V>MY THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MY

	.byte	bytecode_ldlt_ir1_ir1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_265

	; V=0

	.byte	bytecode_ld_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	0

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_265

	; IF QQ$="W" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "W"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_270

	; GOSUB 620

	.byte	bytecode_gosub_ix
	.word	LINE_620

	; V-=1

	.byte	bytecode_sub_fx_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	1

	; IF V<0 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_ldlt_ir1_fr1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_270

	; V=MY

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MY

	.byte	bytecode_ld_fx_ir1
	.byte	bytecode_FLTVAR_V

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_270

	; IF (QQ$="") AND (N(H,V)=0) AND (L>0) THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "\r"

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	0

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ldlt_ir2_ir2_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_272

	; PRINT @(V*32)+H, "?";

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	1, "?"

	; N(H,V)=1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	1

	; L-=1

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_L
	.byte	1

	; FOR Z=1 TO 35

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	1

	.byte	bytecode_to_ip_pb
	.byte	35

	; NEXT

	.byte	bytecode_next

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_272

	; IF (QQ$="") AND (N(H,V)=1) THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "\r"

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_275

	; PRINT @(V*32)+H, ".";

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	1, "."

	; N(H,V)=0

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	0

	; L+=1

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_L
	.byte	1

	; FOR Z=1 TO 35

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	1

	.byte	bytecode_to_ip_pb
	.byte	35

	; NEXT

	.byte	bytecode_next

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_275

	; IF QQ$<>" " THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldne_ir1_sr1_ss
	.text	1, " "

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_220

LINE_280

	; IF N(H,V)<>0 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ldne_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_220

LINE_285

	; POKE (V*32)+H+MC,96

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_poke_ir1_pb
	.byte	96

	; C=M(H,V)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_C

	; IF C=-1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_400

LINE_300

	; R-=1

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_R
	.byte	1

LINE_305

	; IF C=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_310

	; N(H,V)=3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	3

	; GOTO 325

	.byte	bytecode_goto_ix
	.word	LINE_325

LINE_310

	; PRINT @(V*32)+H, CHR$(C+48);

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir1_ir1_pb
	.byte	48

	.byte	bytecode_chr_sr1_ir1

	.byte	bytecode_pr_sr1

	; N(H,V)=2

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	2

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_325

	; OH=H

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_OH

	; OV=V

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_OV

	; ST=1

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_ST
	.byte	1

	; SX(ST)=H

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_arrref1_ir1_fx
	.byte	bytecode_FLTARR_SX

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fp_fr1

	; SY(ST)=V

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_arrref1_ir1_fx
	.byte	bytecode_FLTARR_SY

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_ld_fp_fr1

LINE_335

	; IF ST=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_340

	; H=OH

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_OH

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_H

	; V=OV

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_OV

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_V

	; GOTO 220

	.byte	bytecode_goto_ix
	.word	LINE_220

LINE_340

	; X=SX(ST)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_arrval1_ir1_fx
	.byte	bytecode_FLTARR_SX

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_X

	; Y=SY(ST)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_arrval1_ir1_fx
	.byte	bytecode_FLTARR_SY

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_Y

	; FOR H=X-1 TO X+1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_sub_fr1_fr1_pb
	.byte	1

	.byte	bytecode_for_fx_fr1
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_pb
	.byte	1

	.byte	bytecode_to_fp_fr1

	; FOR V=Y-1 TO Y+1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_sub_fr1_fr1_pb
	.byte	1

	.byte	bytecode_for_fx_fr1
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Y

	.byte	bytecode_add_fr1_fr1_pb
	.byte	1

	.byte	bytecode_to_fp_fr1

LINE_350

	; IF (H<0) OR (H>MX) OR (V<0) OR (V>MY) THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ldlt_ir1_fr1_pb
	.byte	0

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_MX

	.byte	bytecode_ldlt_ir2_ir2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_ldlt_ir2_fr2_pb
	.byte	0

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_MY

	.byte	bytecode_ldlt_ir2_ir2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_390

LINE_355

	; IF N(H,V)<>0 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ldne_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_390

LINE_360

	; IF M(H,V)>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldlt_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_365

	; N(H,V)=2

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	2

	; R-=1

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_R
	.byte	1

	; PRINT @(V*32)+H, CHR$(M(H,V)+48);

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_add_ir1_ir1_pb
	.byte	48

	.byte	bytecode_chr_sr1_ir1

	.byte	bytecode_pr_sr1

	; GOTO 390

	.byte	bytecode_goto_ix
	.word	LINE_390

LINE_365

	; IF M(H,V)=-1 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_390

LINE_370

	; POKE (V*32)+H+MC,96

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_poke_ir1_pb
	.byte	96

	; N(H,V)=3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	3

LINE_380

	; R-=1

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_R
	.byte	1

	; ST+=1

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_ST
	.byte	1

	; SX(ST)=H

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_arrref1_ir1_fx
	.byte	bytecode_FLTARR_SX

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fp_fr1

	; SY(ST)=V

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_ST

	.byte	bytecode_arrref1_ir1_fx
	.byte	bytecode_FLTARR_SY

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_ld_fp_fr1

	; GOTO 340

	.byte	bytecode_goto_ix
	.word	LINE_340

LINE_390

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_395

	; ST-=1

	.byte	bytecode_sub_ix_ix_pb
	.byte	bytecode_INTVAR_ST
	.byte	1

	; GOTO 335

	.byte	bytecode_goto_ix
	.word	LINE_335

LINE_400

	; POKE (V*32)+H+MC,42

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_poke_ir1_pb
	.byte	42

	; GOSUB 8000

	.byte	bytecode_gosub_ix
	.word	LINE_8000

	; PRINT @480, "YOU LOSE.          ";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	19, "YOU LOSE.          "

LINE_405

	; FOR V=0 TO MY

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MY

	; FOR H=0 TO MX

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MX

LINE_410

	; IF M(H,V)=-1 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_415

	; PRINT @(V*32)+H, "*";

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_415

	; IF (N(H,V)=1) AND (M(H,V)<>-1) THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldne_ir2_ir2_nb
	.byte	-1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_420

	; PRINT @(32*V)+H, "X";

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	1, "X"

LINE_420

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_450

	; FOR V=0 TO MY

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_V
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MY

	; FOR H=0 TO MX

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_H
	.byte	0

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_MX

	; IF (M(H,V)=-1) AND (N(H,V)<>1) THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ldne_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_460

	; PRINT @(V*32)+H, "*";

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	32

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_460

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_480

	; PRINT @495, "PLAY AGAIN (Y/N)";

	.byte	bytecode_prat_pw
	.word	495

	.byte	bytecode_pr_ss
	.text	16, "PLAY AGAIN (Y/N)"

	; POKE MC+511,127

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_add_ir1_ir1_pw
	.word	511

	.byte	bytecode_poke_ir1_pb
	.byte	127

LINE_560

	; QQ$=INKEY$

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_QQ

	; IF (QQ$="Y") OR (QQ$="Y") THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Y"

	.byte	bytecode_ld_sr2_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldeq_ir2_sr2_ss
	.text	1, "Y"

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_570

	; RUN

	.byte	bytecode_clear

	.byte	bytecode_goto_ix
	.word	LINE_0

LINE_570

	; IF (QQ$<>"N") AND (QQ$<>"N") THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldne_ir1_sr1_ss
	.text	1, "N"

	.byte	bytecode_ld_sr2_sx
	.byte	bytecode_STRVAR_QQ

	.byte	bytecode_ldne_ir2_sr2_ss
	.text	1, "N"

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_560

LINE_580

	; SOUND 100,1

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; END

	.byte	bytecode_progend

LINE_600

	; POKE (32*V)+H+MC,PEEK((32*V)+H+MC)-64

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_ld_ir2_pb
	.byte	32

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr2_fr2_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_peek_ir2_ir2

	.byte	bytecode_sub_ir2_ir2_pb
	.byte	64

	.byte	bytecode_poke_ir1_ir2

	; RETURN

	.byte	bytecode_return

LINE_620

	; POKE (32*V)+H+MC,PEEK((32*V)+H+MC)+64

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr1_fr1_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_ld_ir2_pb
	.byte	32

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_V

	.byte	bytecode_add_fr2_fr2_fx
	.byte	bytecode_FLTVAR_H

	.byte	bytecode_add_fr2_fr2_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_peek_ir2_ir2

	.byte	bytecode_add_ir2_ir2_pb
	.byte	64

	.byte	bytecode_poke_ir1_ir2

	; RETURN

	.byte	bytecode_return

LINE_8000

	; FOR X=1 TO 10

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_X
	.byte	1

	.byte	bytecode_to_fp_pb
	.byte	10

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; POKE 49151,64

	.byte	bytecode_ld_ir1_pb
	.byte	64

	.byte	bytecode_poke_pw_ir1
	.word	49151

	; FOR Z=1 TO 35

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	1

	.byte	bytecode_to_ip_pb
	.byte	35

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr1_fr1_fx	.equ	0
bytecode_add_fr1_fr1_ix	.equ	1
bytecode_add_fr1_fr1_pb	.equ	2
bytecode_add_fr2_fr2_fx	.equ	3
bytecode_add_fr2_fr2_ix	.equ	4
bytecode_add_fr3_fr3_fx	.equ	5
bytecode_add_fx_fx_pb	.equ	6
bytecode_add_ir1_ir1_pb	.equ	7
bytecode_add_ir1_ir1_pw	.equ	8
bytecode_add_ir2_ir2_pb	.equ	9
bytecode_add_ix_ix_pb	.equ	10
bytecode_and_ir1_ir1_ir2	.equ	11
bytecode_arrdim1_ir1_fx	.equ	12
bytecode_arrdim1_ir1_ix	.equ	13
bytecode_arrdim2_ir1_ix	.equ	14
bytecode_arrref1_ir1_fx	.equ	15
bytecode_arrref2_ir1_ix	.equ	16
bytecode_arrval1_ir1_fx	.equ	17
bytecode_arrval2_ir1_ix	.equ	18
bytecode_arrval2_ir2_ix	.equ	19
bytecode_chr_sr1_ir1	.equ	20
bytecode_chr_sr1_ix	.equ	21
bytecode_clear	.equ	22
bytecode_cls	.equ	23
bytecode_clsn_pb	.equ	24
bytecode_for_fx_fr1	.equ	25
bytecode_for_fx_nb	.equ	26
bytecode_for_fx_pb	.equ	27
bytecode_for_ix_pb	.equ	28
bytecode_gosub_ix	.equ	29
bytecode_goto_ix	.equ	30
bytecode_inkey_sr1	.equ	31
bytecode_irnd_ir1_pb	.equ	32
bytecode_jmpeq_ir1_ix	.equ	33
bytecode_jmpne_ir1_ix	.equ	34
bytecode_ld_fp_fr1	.equ	35
bytecode_ld_fr1_fx	.equ	36
bytecode_ld_fr2_fx	.equ	37
bytecode_ld_fr3_fx	.equ	38
bytecode_ld_fx_fr1	.equ	39
bytecode_ld_fx_ir1	.equ	40
bytecode_ld_fx_pb	.equ	41
bytecode_ld_ip_ir1	.equ	42
bytecode_ld_ip_nb	.equ	43
bytecode_ld_ip_pb	.equ	44
bytecode_ld_ir1_ix	.equ	45
bytecode_ld_ir1_pb	.equ	46
bytecode_ld_ir2_ix	.equ	47
bytecode_ld_ir2_pb	.equ	48
bytecode_ld_ix_ir1	.equ	49
bytecode_ld_ix_pb	.equ	50
bytecode_ld_ix_pw	.equ	51
bytecode_ld_sr1_sx	.equ	52
bytecode_ld_sr2_sx	.equ	53
bytecode_ld_sx_sr1	.equ	54
bytecode_ldeq_ir1_fr1_pb	.equ	55
bytecode_ldeq_ir1_ir1_nb	.equ	56
bytecode_ldeq_ir1_ir1_pb	.equ	57
bytecode_ldeq_ir1_sr1_ss	.equ	58
bytecode_ldeq_ir2_fr2_pb	.equ	59
bytecode_ldeq_ir2_ir2_pb	.equ	60
bytecode_ldeq_ir2_sr2_ss	.equ	61
bytecode_ldlt_ir1_fr1_pb	.equ	62
bytecode_ldlt_ir1_ir1_fx	.equ	63
bytecode_ldlt_ir1_ir1_ir2	.equ	64
bytecode_ldlt_ir2_fr2_pb	.equ	65
bytecode_ldlt_ir2_ir2_fr3	.equ	66
bytecode_ldlt_ir2_ir2_fx	.equ	67
bytecode_ldlt_ir2_ir2_ix	.equ	68
bytecode_ldne_ir1_ir1_nb	.equ	69
bytecode_ldne_ir1_ir1_pb	.equ	70
bytecode_ldne_ir1_sr1_ss	.equ	71
bytecode_ldne_ir2_ir2_nb	.equ	72
bytecode_ldne_ir2_ir2_pb	.equ	73
bytecode_ldne_ir2_sr2_ss	.equ	74
bytecode_mul_fr1_fr1_pb	.equ	75
bytecode_mul_fr1_ir1_fx	.equ	76
bytecode_mul_fr2_ir2_fx	.equ	77
bytecode_mul_ir1_ir1_ir2	.equ	78
bytecode_next	.equ	79
bytecode_ongoto_ir1_is	.equ	80
bytecode_or_ir1_ir1_ir2	.equ	81
bytecode_peek_ir1_pw	.equ	82
bytecode_peek_ir2_ir2	.equ	83
bytecode_peek_ir2_pb	.equ	84
bytecode_poke_ir1_ir2	.equ	85
bytecode_poke_ir1_pb	.equ	86
bytecode_poke_pw_ir1	.equ	87
bytecode_pr_sr1	.equ	88
bytecode_pr_ss	.equ	89
bytecode_prat_ir1	.equ	90
bytecode_prat_pb	.equ	91
bytecode_prat_pw	.equ	92
bytecode_progbegin	.equ	93
bytecode_progend	.equ	94
bytecode_return	.equ	95
bytecode_rnd_fr1_ix	.equ	96
bytecode_sound_ir1_ir2	.equ	97
bytecode_str_sr1_ix	.equ	98
bytecode_sub_fr1_fr1_pb	.equ	99
bytecode_sub_fx_fx_pb	.equ	100
bytecode_sub_ir1_ir1_ix	.equ	101
bytecode_sub_ir2_ir2_pb	.equ	102
bytecode_sub_ix_ix_pb	.equ	103
bytecode_to_fp_fr1	.equ	104
bytecode_to_fp_ix	.equ	105
bytecode_to_fp_pb	.equ	106
bytecode_to_ip_ix	.equ	107
bytecode_to_ip_pb	.equ	108
bytecode_val_fr1_sx	.equ	109

catalog
	.word	add_fr1_fr1_fx
	.word	add_fr1_fr1_ix
	.word	add_fr1_fr1_pb
	.word	add_fr2_fr2_fx
	.word	add_fr2_fr2_ix
	.word	add_fr3_fr3_fx
	.word	add_fx_fx_pb
	.word	add_ir1_ir1_pb
	.word	add_ir1_ir1_pw
	.word	add_ir2_ir2_pb
	.word	add_ix_ix_pb
	.word	and_ir1_ir1_ir2
	.word	arrdim1_ir1_fx
	.word	arrdim1_ir1_ix
	.word	arrdim2_ir1_ix
	.word	arrref1_ir1_fx
	.word	arrref2_ir1_ix
	.word	arrval1_ir1_fx
	.word	arrval2_ir1_ix
	.word	arrval2_ir2_ix
	.word	chr_sr1_ir1
	.word	chr_sr1_ix
	.word	clear
	.word	cls
	.word	clsn_pb
	.word	for_fx_fr1
	.word	for_fx_nb
	.word	for_fx_pb
	.word	for_ix_pb
	.word	gosub_ix
	.word	goto_ix
	.word	inkey_sr1
	.word	irnd_ir1_pb
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	ld_fp_fr1
	.word	ld_fr1_fx
	.word	ld_fr2_fx
	.word	ld_fr3_fx
	.word	ld_fx_fr1
	.word	ld_fx_ir1
	.word	ld_fx_pb
	.word	ld_ip_ir1
	.word	ld_ip_nb
	.word	ld_ip_pb
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ld_ix_pw
	.word	ld_sr1_sx
	.word	ld_sr2_sx
	.word	ld_sx_sr1
	.word	ldeq_ir1_fr1_pb
	.word	ldeq_ir1_ir1_nb
	.word	ldeq_ir1_ir1_pb
	.word	ldeq_ir1_sr1_ss
	.word	ldeq_ir2_fr2_pb
	.word	ldeq_ir2_ir2_pb
	.word	ldeq_ir2_sr2_ss
	.word	ldlt_ir1_fr1_pb
	.word	ldlt_ir1_ir1_fx
	.word	ldlt_ir1_ir1_ir2
	.word	ldlt_ir2_fr2_pb
	.word	ldlt_ir2_ir2_fr3
	.word	ldlt_ir2_ir2_fx
	.word	ldlt_ir2_ir2_ix
	.word	ldne_ir1_ir1_nb
	.word	ldne_ir1_ir1_pb
	.word	ldne_ir1_sr1_ss
	.word	ldne_ir2_ir2_nb
	.word	ldne_ir2_ir2_pb
	.word	ldne_ir2_sr2_ss
	.word	mul_fr1_fr1_pb
	.word	mul_fr1_ir1_fx
	.word	mul_fr2_ir2_fx
	.word	mul_ir1_ir1_ir2
	.word	next
	.word	ongoto_ir1_is
	.word	or_ir1_ir1_ir2
	.word	peek_ir1_pw
	.word	peek_ir2_ir2
	.word	peek_ir2_pb
	.word	poke_ir1_ir2
	.word	poke_ir1_pb
	.word	poke_pw_ir1
	.word	pr_sr1
	.word	pr_ss
	.word	prat_ir1
	.word	prat_pb
	.word	prat_pw
	.word	progbegin
	.word	progend
	.word	return
	.word	rnd_fr1_ix
	.word	sound_ir1_ir2
	.word	str_sr1_ix
	.word	sub_fr1_fr1_pb
	.word	sub_fx_fx_pb
	.word	sub_ir1_ir1_ix
	.word	sub_ir2_ir2_pb
	.word	sub_ix_ix_pb
	.word	to_fp_fr1
	.word	to_fp_ix
	.word	to_fp_pb
	.word	to_ip_ix
	.word	to_ip_pb
	.word	val_fr1_sx

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

	.module	mdbcode
noargs
	ldx	curinst
	inx
	stx	nxtinst
	rts
extend
	ldx	curinst
	inx
	ldab	,x
	inx
	stx	nxtinst
	ldx	#symstart
	abx
	rts
getaddr
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldx	1,x
	rts
getbyte
	ldx	curinst
	inx
	ldab	,x
	inx
	stx	nxtinst
	rts
getword
	ldx	curinst
	inx
	ldd	,x
	inx
	inx
	stx	nxtinst
	rts
extbyte
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	2,x
	pshb
	ldab	1,x
	ldx	#symstart
	abx
	pulb
	rts
extword
	ldd	curinst
	addd	#4
	std	nxtinst
	ldx	curinst
	ldd	2,x
	pshb
	ldab	1,x
	ldx	#symstart
	abx
	pulb
	rts
byteext
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	1,x
	pshb
	ldab	2,x
	ldx	#symstart
	abx
	pulb
	rts
wordext
	ldd	curinst
	addd	#4
	std	nxtinst
	ldx	curinst
	ldd	1,x
	pshb
	ldab	3,x
	ldx	#symstart
	abx
	pulb
	rts
immstr
	ldx	curinst
	inx
	ldab	,x
	inx
	pshx
	abx
	stx	nxtinst
	pulx
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

	.module	mdmul12
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

	.module	mdref2
; get offset from 2D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref2
	ldd	2,x
	std	tmp1
	subd	0+argv
	bls	_err
	ldd	2+argv
	std	tmp2
	subd	4,x
	bhs	_err
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

	.module	mdstreqbs
; compare string against bytecode "stack"
; ENTRY: tmp1+1 holds length, tmp2 holds compare
; EXIT:  we return correct Z flag for caller
streqbs
	jsr	immstr
	sts	tmp3
	cmpb	tmp1+1
	bne	_ne
	tstb
	beq	_eq
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
	clra
	rts
_ne
	lds	tmp3
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

	.module	mdtobc
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
	ldd	nxtinst
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

add_fr1_fr1_fx			; numCalls = 17
	.module	modadd_fr1_fr1_fx
	jsr	extend
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

add_fr1_fr1_ix			; numCalls = 5
	.module	modadd_fr1_fr1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fr1_fr1_pb			; numCalls = 2
	.module	modadd_fr1_fr1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_fr2_fr2_fx			; numCalls = 7
	.module	modadd_fr2_fr2_fx
	jsr	extend
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

add_fr2_fr2_ix			; numCalls = 3
	.module	modadd_fr2_fr2_ix
	jsr	extend
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_fr3_fr3_fx			; numCalls = 2
	.module	modadd_fr3_fr3_fx
	jsr	extend
	ldd	r3+3
	addd	3,x
	std	r3+3
	ldd	r3+1
	adcb	2,x
	adca	1,x
	std	r3+1
	ldab	r3
	adcb	0,x
	stab	r3
	rts

add_fx_fx_pb			; numCalls = 2
	.module	modadd_fx_fx_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

add_ir1_ir1_pb			; numCalls = 5
	.module	modadd_ir1_ir1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pw			; numCalls = 1
	.module	modadd_ir1_ir1_pw
	jsr	getword
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir2_ir2_pb			; numCalls = 2
	.module	modadd_ir2_ir2_pb
	jsr	getbyte
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_ix_ix_pb			; numCalls = 2
	.module	modadd_ix_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 10
	.module	modand_ir1_ir1_ir2
	jsr	noargs
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
	jsr	extend
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
	jsr	extend
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

arrdim2_ir1_ix			; numCalls = 2
	.module	modarrdim2_ir1_ix
	jsr	extend
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

arrref1_ir1_fx			; numCalls = 4
	.module	modarrref1_ir1_fx
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#55
	jsr	ref1
	jsr	refflt
	std	letptr
	rts

arrref2_ir1_ix			; numCalls = 8
	.module	modarrref2_ir1_ix
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_fx			; numCalls = 2
	.module	modarrval1_ir1_fx
	jsr	extend
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

arrval2_ir1_ix			; numCalls = 12
	.module	modarrval2_ir1_ix
	jsr	extend
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

arrval2_ir2_ix			; numCalls = 5
	.module	modarrval2_ir2_ix
	jsr	extend
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
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
	jsr	noargs
	ldd	#$0101
	std	r1
	rts

chr_sr1_ix			; numCalls = 1
	.module	modchr_sr1_ix
	jsr	extend
	ldab	2,x
	stab	r1+2
	ldd	#$0101
	std	r1
	rts

clear			; numCalls = 2
	.module	modclear
	jsr	noargs
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
	jsr	noargs
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jsr	getbyte
	jmp	R_CLSN

for_fx_fr1			; numCalls = 2
	.module	modfor_fx_fr1
	jsr	extend
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	ldd	r1+3
	std	3,x
	rts

for_fx_nb			; numCalls = 2
	.module	modfor_fx_nb
	jsr	extbyte
	stx	letptr
	ldaa	#-1
	staa	0,x
	std	1,x
	ldd	#0
	std	3,x
	rts

for_fx_pb			; numCalls = 9
	.module	modfor_fx_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
	rts

for_ix_pb			; numCalls = 4
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 6
	.module	modgosub_ix
	pulx
	jsr	getaddr
	ldd	nxtinst
	pshb
	psha
	ldab	#3
	pshb
	stx	nxtinst
	jmp	mainloop

goto_ix			; numCalls = 17
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

inkey_sr1			; numCalls = 2
	.module	modinkey_sr1
	jsr	noargs
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

irnd_ir1_pb			; numCalls = 1
	.module	modirnd_ir1_pb
	jsr	getbyte
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 20
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 15
	.module	modjmpne_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_go
	ldaa	r1
	beq	_rts
_go
	stx	nxtinst
_rts
	rts

ld_fp_fr1			; numCalls = 4
	.module	modld_fp_fr1
	jsr	noargs
	ldx	letptr
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fr1_fx			; numCalls = 49
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 28
	.module	modld_fr2_fx
	jsr	extend
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fr3_fx			; numCalls = 7
	.module	modld_fr3_fx
	jsr	extend
	ldd	3,x
	std	r3+3
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_fx_fr1			; numCalls = 9
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_ir1			; numCalls = 3
	.module	modld_fx_ir1
	jsr	extend
	ldd	#0
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_pb			; numCalls = 4
	.module	modld_fx_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
	rts

ld_ip_ir1			; numCalls = 1
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_nb			; numCalls = 1
	.module	modld_ip_nb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ip_pb			; numCalls = 6
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 20
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 14
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 5
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 9
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 4
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 11
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sr1_sx			; numCalls = 11
	.module	modld_sr1_sx
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sr2_sx			; numCalls = 4
	.module	modld_sr2_sx
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_sx_sr1			; numCalls = 3
	.module	modld_sx_sr1
	jsr	extend
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_fr1_pb			; numCalls = 1
	.module	modldeq_ir1_fr1_pb
	jsr	getbyte
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

ldeq_ir1_ir1_nb			; numCalls = 5
	.module	modldeq_ir1_ir1_nb
	jsr	getbyte
	cmpb	r1+2
	bne	_done
	ldd	r1
	subd	#-1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_ir1_pb			; numCalls = 4
	.module	modldeq_ir1_ir1_pb
	jsr	getbyte
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 8
	.module	modldeq_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqbs
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir2_fr2_pb			; numCalls = 1
	.module	modldeq_ir2_fr2_pb
	jsr	getbyte
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

ldeq_ir2_ir2_pb			; numCalls = 2
	.module	modldeq_ir2_ir2_pb
	jsr	getbyte
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_sr2_ss			; numCalls = 1
	.module	modldeq_ir2_sr2_ss
	ldab	r2
	stab	tmp1+1
	ldd	r2+1
	std	tmp2
	jsr	streqbs
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldlt_ir1_fr1_pb			; numCalls = 5
	.module	modldlt_ir1_fr1_pb
	jsr	getbyte
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

ldlt_ir1_ir1_fx			; numCalls = 2
	.module	modldlt_ir1_ir1_fx
	jsr	extend
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

ldlt_ir1_ir1_ir2			; numCalls = 2
	.module	modldlt_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_fr2_pb			; numCalls = 2
	.module	modldlt_ir2_fr2_pb
	jsr	getbyte
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

ldlt_ir2_ir2_fr3			; numCalls = 2
	.module	modldlt_ir2_ir2_fr3
	jsr	noargs
	ldd	#0
	subd	r3+3
	ldd	r2+1
	sbcb	r3+2
	sbca	r3+1
	ldab	r2
	sbcb	r3
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ir2_fx			; numCalls = 3
	.module	modldlt_ir2_ir2_fx
	jsr	extend
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

ldlt_ir2_ir2_ix			; numCalls = 1
	.module	modldlt_ir2_ir2_ix
	jsr	extend
	ldd	r2+1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_nb			; numCalls = 2
	.module	modldne_ir1_ir1_nb
	jsr	getbyte
	cmpb	r1+2
	bne	_done
	ldd	r1
	subd	#-1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_ir1_pb			; numCalls = 2
	.module	modldne_ir1_ir1_pb
	jsr	getbyte
	cmpb	r1+2
	bne	_done
	ldd	r1
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_sr1_ss			; numCalls = 3
	.module	modldne_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqbs
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir2_ir2_nb			; numCalls = 1
	.module	modldne_ir2_ir2_nb
	jsr	getbyte
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
	jsr	getbyte
	cmpb	r2+2
	bne	_done
	ldd	r2
_done
	jsr	getne
	std	r2+1
	stab	r2
	rts

ldne_ir2_sr2_ss			; numCalls = 3
	.module	modldne_ir2_sr2_ss
	ldab	r2
	stab	tmp1+1
	ldd	r2+1
	std	tmp2
	jsr	streqbs
	jsr	getne
	std	r2+1
	stab	r2
	rts

mul_fr1_fr1_pb			; numCalls = 10
	.module	modmul_fr1_fr1_pb
	jsr	getbyte
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	ldx	#r1
	jmp	mulfltx

mul_fr1_ir1_fx			; numCalls = 3
	.module	modmul_fr1_ir1_fx
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldd	3,x
	std	3+argv
	ldd	#0
	std	r1+3
	ldx	#r1
	jmp	mulfltx

mul_fr2_ir2_fx			; numCalls = 3
	.module	modmul_fr2_ir2_fx
	jsr	extend
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

mul_ir1_ir1_ir2			; numCalls = 1
	.module	modmul_ir1_ir1_ir2
	jsr	noargs
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldx	#r1
	jmp	mulintx

next			; numCalls = 17
	.module	modnext
	jsr	noargs
	pulx
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
	stx	nxtinst
	jmp	mainloop
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_idone
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
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
	stx	nxtinst
	jmp	mainloop
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
	stx	nxtinst
	jmp	mainloop
_fdone
	ldab	#15
_done
	abx
	txs
	jmp	mainloop

ongoto_ir1_is			; numCalls = 1
	.module	modongoto_ir1_is
	ldx	curinst
	inx
	ldd	r1
	bne	_fail
	ldab	r1+2
	decb
	cmpb	0,x
	bhs	_fail
	abx
	abx
	ldx	1,x
	stx	nxtinst
	rts
_fail
	ldab	,x
	abx
	abx
	inx
	stx	nxtinst
	rts

or_ir1_ir1_ir2			; numCalls = 8
	.module	modor_ir1_ir1_ir2
	jsr	noargs
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_pw			; numCalls = 1
	.module	modpeek_ir1_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
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

peek_ir2_ir2			; numCalls = 3
	.module	modpeek_ir2_ir2
	jsr	noargs
	ldx	r2+1
	cpx	#M_IKEY
	bne	_nostore
	jsr	R_KPOLL
	beq	_nostore
	staa	M_IKEY
_nostore
	ldab	,x
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir2_pb			; numCalls = 1
	.module	modpeek_ir2_pb
	jsr	getbyte
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_ir1_ir2			; numCalls = 2
	.module	modpoke_ir1_ir2
	jsr	noargs
	ldab	r2+2
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 5
	.module	modpoke_ir1_pb
	jsr	getbyte
	ldx	r1+1
	stab	,x
	rts

poke_pw_ir1			; numCalls = 2
	.module	modpoke_pw_ir1
	jsr	getword
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 3
	.module	modpr_sr1
	jsr	noargs
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
	ldx	curinst
	inx
	ldab	,x
	beq	_null
	inx
	jsr	print
	stx	nxtinst
	rts
_null
	inx
	stx	nxtinst
	rts

prat_ir1			; numCalls = 8
	.module	modprat_ir1
	jsr	noargs
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 3
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 8
	.module	modprat_pw
	jsr	getword
	jmp	prat

progbegin			; numCalls = 1
	.module	modprogbegin
	jsr	noargs
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
	jsr	noargs
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
	pulx
	stx	nxtinst
	jmp	mainloop

rnd_fr1_ix			; numCalls = 2
	.module	modrnd_fr1_ix
	jsr	extend
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

sound_ir1_ir2			; numCalls = 2
	.module	modsound_ir1_ir2
	jsr	noargs
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

str_sr1_ix			; numCalls = 1
	.module	modstr_sr1_ix
	jsr	extend
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

sub_fr1_fr1_pb			; numCalls = 2
	.module	modsub_fr1_fr1_pb
	jsr	getbyte
	stab	tmp1
	ldd	r1+1
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

sub_fx_fx_pb			; numCalls = 2
	.module	modsub_fx_fx_pb
	jsr	extbyte
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

sub_ir1_ir1_ix			; numCalls = 1
	.module	modsub_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir2_ir2_pb			; numCalls = 2
	.module	modsub_ir2_ir2_pb
	jsr	getbyte
	stab	tmp1
	ldd	r2+1
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	r2
	sbcb	#0
	stab	r2
	rts

sub_ix_ix_pb			; numCalls = 5
	.module	modsub_ix_ix_pb
	jsr	extbyte
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

to_fp_fr1			; numCalls = 2
	.module	modto_fp_fr1
	jsr	noargs
	ldab	#15
	jmp	to

to_fp_ix			; numCalls = 8
	.module	modto_fp_ix
	jsr	extend
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
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_ix			; numCalls = 1
	.module	modto_ip_ix
	jsr	extend
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
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

val_fr1_sx			; numCalls = 1
	.module	modval_fr1_sx
	jsr	extend
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

; Bytecode equates


bytecode_INTVAR_B	.equ	INTVAR_B-symstart
bytecode_INTVAR_C	.equ	INTVAR_C-symstart
bytecode_INTVAR_L	.equ	INTVAR_L-symstart
bytecode_INTVAR_MC	.equ	INTVAR_MC-symstart
bytecode_INTVAR_MX	.equ	INTVAR_MX-symstart
bytecode_INTVAR_MY	.equ	INTVAR_MY-symstart
bytecode_INTVAR_Q	.equ	INTVAR_Q-symstart
bytecode_INTVAR_R	.equ	INTVAR_R-symstart
bytecode_INTVAR_ST	.equ	INTVAR_ST-symstart
bytecode_INTVAR_T	.equ	INTVAR_T-symstart
bytecode_INTVAR_Z	.equ	INTVAR_Z-symstart
bytecode_FLTVAR_H	.equ	FLTVAR_H-symstart
bytecode_FLTVAR_OH	.equ	FLTVAR_OH-symstart
bytecode_FLTVAR_OV	.equ	FLTVAR_OV-symstart
bytecode_FLTVAR_SK	.equ	FLTVAR_SK-symstart
bytecode_FLTVAR_V	.equ	FLTVAR_V-symstart
bytecode_FLTVAR_X	.equ	FLTVAR_X-symstart
bytecode_FLTVAR_Y	.equ	FLTVAR_Y-symstart
bytecode_STRVAR_QQ	.equ	STRVAR_QQ-symstart
bytecode_INTARR_M	.equ	INTARR_M-symstart
bytecode_INTARR_N	.equ	INTARR_N-symstart
bytecode_INTARR_TT	.equ	INTARR_TT-symstart
bytecode_FLTARR_SX	.equ	FLTARR_SX-symstart
bytecode_FLTARR_SY	.equ	FLTARR_SY-symstart

symstart

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
INTVAR_T	.block	3
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
INTARR_TT	.block	4	; dims=1
FLTARR_SX	.block	4	; dims=1
FLTARR_SY	.block	4	; dims=1
; String Arrays

; block ended by symbol
bes
	.end

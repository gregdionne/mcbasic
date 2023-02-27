; Assembly for rubik.bas
; compiled with mcbasic

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
r4	.block	5
rend
curinst	.block	2
nxtinst	.block	2
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

LINE_100

	; REM CLOAD MAGAZINE MARCH 1982

LINE_500

	; CLS

	.byte	bytecode_cls

	; CLEAR 1000

	.byte	bytecode_clear

	; DIM A1$(6,3,3)

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_ld_ir3_pb
	.byte	3

	.byte	bytecode_arrdim3_ir1_sx
	.byte	bytecode_STRARR_A1

	; DIM QQ(6,3,3)

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_ld_ir3_pb
	.byte	3

	.byte	bytecode_arrdim3_ir1_ix
	.byte	bytecode_INTARR_QQ

LINE_510

	; DIM Q3(1,12,3)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	12

	.byte	bytecode_ld_ir3_pb
	.byte	3

	.byte	bytecode_arrdim3_ir1_ix
	.byte	bytecode_INTARR_Q3

	; DIM Q1(40)

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Q1

	; DIM BL(300)

	.byte	bytecode_ld_ir1_pw
	.word	300

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_BL

	; F=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_F

	; X=1

	.byte	bytecode_one_fx
	.byte	bytecode_FLTVAR_X

	; BP=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_BP

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; B1=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B1

	; B2=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B2

	; B3=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B3

LINE_520

	; GOTO 1320

	.byte	bytecode_goto_ix
	.word	LINE_1320

LINE_530

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; PRINT @64, "SIMULATION OF";

	.byte	bytecode_prat_pb
	.byte	64

	.byte	bytecode_pr_ss
	.text	13, "SIMULATION OF"

LINE_531

	; PRINT @363, "bACK";

	.byte	bytecode_prat_pw
	.word	363

	.byte	bytecode_pr_ss
	.text	4, "bACK"

LINE_532

	; PRINT @384, "uNDER lEFT tOP rIGHT";

	.byte	bytecode_prat_pw
	.word	384

	.byte	bytecode_pr_ss
	.text	20, "uNDER lEFT tOP rIGHT"

LINE_533

	; PRINT @427, "fRONT";

	.byte	bytecode_prat_pw
	.word	427

	.byte	bytecode_pr_ss
	.text	5, "fRONT"

LINE_535

	; PRINT @376, "6 4 1 3";

	.byte	bytecode_prat_pw
	.word	376

	.byte	bytecode_pr_ss
	.text	7, "6 4 1 3"

	; PRINT @348, "5";

	.byte	bytecode_prat_pw
	.word	348

	.byte	bytecode_pr_ss
	.text	1, "5"

	; PRINT @412, "2";

	.byte	bytecode_prat_pw
	.word	412

	.byte	bytecode_pr_ss
	.text	1, "2"

	; PRINT @439, "FACE #'S";

	.byte	bytecode_prat_pw
	.word	439

	.byte	bytecode_pr_ss
	.text	8, "FACE #'S"

LINE_540

	; PRINT @96, "RUBIK'S CUBE ";

	.byte	bytecode_prat_pb
	.byte	96

	.byte	bytecode_pr_ss
	.text	13, "RUBIK'S CUBE "

LINE_590

	; RETURN

	.byte	bytecode_return

LINE_600

	; GOSUB 530

	.byte	bytecode_gosub_ix
	.word	LINE_530

LINE_605

	; PRINT @480, "ENTER YOUR MOVE       X TO EXIT";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	31, "ENTER YOUR MOVE       X TO EXIT"

LINE_606

	; QA=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_QA

LINE_610

	; GOSUB 630

	.byte	bytecode_gosub_ix
	.word	LINE_630

LINE_620

	; GOTO 1040

	.byte	bytecode_goto_ix
	.word	LINE_1040

LINE_630

	; FOR X=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	6

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; C=64

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	64

LINE_640

	; GOSUB 2400

	.byte	bytecode_gosub_ix
	.word	LINE_2400

LINE_700

	; FOR Y=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	3

	; FOR Z=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	3

LINE_710

	; PRINT @SHIFT((Z*C)+(Y*B)+NA,-1), A1$(X,Y,Z);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_mul_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_mul_ir2_ir2_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_NA

	.byte	bytecode_hlf_fr1_ir1

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_pr_sr1

LINE_720

	; NEXT Z,Y,X

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_next

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_730

	; FOR Y=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	3

	; A1$(D,Y,E)=A1$(F,Y,G)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; NEXT Y

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_740

	; FOR Z=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	3

	; A1$(D,E,Z)=A1$(F,G,Z)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; NEXT Z

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_750

	; FOR Z=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	3

	; A1$(D,Z,E)=A1$(F,G,Z)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; NEXT Z

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_760

	; FOR Z=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	3

	; A1$(D,E,Z)=A1$(F,Z,G)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; NEXT Z

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_770

	; D=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_D

	; E=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_E

	; F=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	4

	; G=H

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_G
	.byte	bytecode_INTVAR_H

	; GOSUB 730

	.byte	bytecode_gosub_ix
	.word	LINE_730

LINE_780

	; D=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	4

	; E=H

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_H

	; F=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_F

	; GOSUB 730

	.byte	bytecode_gosub_ix
	.word	LINE_730

LINE_790

	; D=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_D

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; G=-G+(4)

	.byte	bytecode_rsub_ix_ix_pb
	.byte	bytecode_INTVAR_G
	.byte	4

	; GOSUB 730

	.byte	bytecode_gosub_ix
	.word	LINE_730

LINE_800

	; D=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	3

	; E=G

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_G

	; F=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	6

	; GOSUB 730

	.byte	bytecode_gosub_ix
	.word	LINE_730

LINE_810

	; D=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	6

	; F=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_F

	; G=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_G

	; GOSUB 730

	.byte	bytecode_gosub_ix
	.word	LINE_730

LINE_820

	; IF H=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_830

	; H1=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H1
	.byte	5

	; GOSUB 1010

	.byte	bytecode_gosub_ix
	.word	LINE_1010

LINE_830

	; IF H=3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_840

	; H1=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H1
	.byte	2

	; GOSUB 1010

	.byte	bytecode_gosub_ix
	.word	LINE_1010

LINE_840

	; RETURN

	.byte	bytecode_return

LINE_850

	; D=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_D

	; E=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_E

	; F=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_F

	; G=H

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_G
	.byte	bytecode_INTVAR_H

	; GOSUB 740

	.byte	bytecode_gosub_ix
	.word	LINE_740

LINE_860

	; D=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_D

	; E=G

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_G

	; F=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	2

	; GOSUB 740

	.byte	bytecode_gosub_ix
	.word	LINE_740

LINE_870

	; D=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	2

	; F=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	6

	; G=-G+(4)

	.byte	bytecode_rsub_ix_ix_pb
	.byte	bytecode_INTVAR_G
	.byte	4

	; GOSUB 740

	.byte	bytecode_gosub_ix
	.word	LINE_740

LINE_880

	; D=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	6

	; E=G

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_G

	; F=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	5

	; GOSUB 740

	.byte	bytecode_gosub_ix
	.word	LINE_740

LINE_890

	; D=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	5

	; F=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_F

	; G=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_G

	; GOSUB 740

	.byte	bytecode_gosub_ix
	.word	LINE_740

LINE_900

	; IF H=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_910

	; H1=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H1
	.byte	4

	; GOSUB 1010

	.byte	bytecode_gosub_ix
	.word	LINE_1010

LINE_910

	; IF H=3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_920

	; H1=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H1
	.byte	3

	; GOSUB 1010

	.byte	bytecode_gosub_ix
	.word	LINE_1010

LINE_920

	; RETURN

	.byte	bytecode_return

LINE_930

	; D=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_D

	; E=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_E

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; G=H

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_G
	.byte	bytecode_INTVAR_H

	; GOSUB 740

	.byte	bytecode_gosub_ix
	.word	LINE_740

LINE_940

	; D=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	3

	; E=G

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_G

	; F=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	2

	; GOSUB 760

	.byte	bytecode_gosub_ix
	.word	LINE_760

LINE_950

	; D=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	2

	; F=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	4

	; G=-G+(4)

	.byte	bytecode_rsub_ix_ix_pb
	.byte	bytecode_INTVAR_G
	.byte	4

	; GOSUB 750

	.byte	bytecode_gosub_ix
	.word	LINE_750

LINE_960

	; D=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	4

	; E=G

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_G

	; F=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	5

	; GOSUB 760

	.byte	bytecode_gosub_ix
	.word	LINE_760

LINE_970

	; D=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	5

	; F=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_F

	; G=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_G

	; GOSUB 750

	.byte	bytecode_gosub_ix
	.word	LINE_750

LINE_980

	; IF H=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_990

	; H1=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_H1

	; GOSUB 1010

	.byte	bytecode_gosub_ix
	.word	LINE_1010

LINE_990

	; IF H=3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1000

	; H1=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H1
	.byte	6

	; GOSUB 1010

	.byte	bytecode_gosub_ix
	.word	LINE_1010

LINE_1000

	; RETURN

	.byte	bytecode_return

LINE_1010

	; FOR X=1 TO 2

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	2

	; A1$(0,0,X)=A1$(H1,1,X)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; A1$(H1,1,X)=A1$(H1,4-X,1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_sub_fr2_pb_fx
	.byte	4
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

LINE_1020

	; A1$(H1,4-X,1)=A1$(H1,3,4-X)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_sub_fr2_pb_fx
	.byte	4
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sub_fr3_pb_fx
	.byte	4
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; A1$(H1,3,4-X)=A1$(H1,X,3)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sub_fr3_pb_fx
	.byte	4
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	3

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

LINE_1030

	; A1$(H1,X,3)=A1$(0,0,X)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	3

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_1040

	; J=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_J

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; M=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_M

	; PRINT @0, "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	32, "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80"

	; PRINT @0,

	.byte	bytecode_prat_pb
	.byte	0

LINE_1045

	; IF QA THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_QA

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1050

	; PRINT @480, "SOLVED. HIT X TO RETURN TO MENU";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	31, "SOLVED. HIT X TO RETURN TO MENU"

LINE_1050

	; B$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_B

	; WHEN B$="" GOTO 1050

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1050

LINE_1060

	; WHEN B$="\x08" GOTO 1040

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "\x08"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1040

LINE_1080

	; IF B$="*" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "*"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1090

	; I=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_I

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

	; GOTO 1050

	.byte	bytecode_goto_ix
	.word	LINE_1050

LINE_1090

	; IF B$="R" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "R"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1100

	; J=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	; H=3-I

	.byte	bytecode_sub_ir1_pb_ix
	.byte	3
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

LINE_1100

	; IF B$="L" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "L"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1110

	; J=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	; H=I+1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

	; M=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_M

LINE_1110

	; IF B$="B" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "B"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1120

	; J=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_J

	; H=I+1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

LINE_1120

	; IF B$="F" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "F"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1130

	; J=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_J

	; H=3-I

	.byte	bytecode_sub_ir1_pb_ix
	.byte	3
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

	; M=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_M

LINE_1130

	; IF B$="T" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "T"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1140

	; J=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	3

	; H=I+1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

	; M=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_M

LINE_1140

	; IF B$="U" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "U"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1160

	; J=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	3

	; H=3-I

	.byte	bytecode_sub_ir1_pb_ix
	.byte	3
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

LINE_1160

	; WHEN B$="X" GOTO 1440

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "X"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1440

LINE_1170

	; WHEN J=0 GOTO 1050

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1050

LINE_1180

	; PRINT B$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

LINE_1190

	; B$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_B

	; WHEN B$="" GOTO 1190

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1190

LINE_1200

	; WHEN B$="\x08" GOTO 1040

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "\x08"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1040

LINE_1210

	; K=VAL(B$)

	.byte	bytecode_val_fr1_sx
	.byte	bytecode_STRVAR_B

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_K

	; WHEN (K=1) OR (K=2) OR (K=3) GOTO 1230

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_K

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_K

	.byte	bytecode_ldeq_ir2_fr2_pb
	.byte	2

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_K

	.byte	bytecode_ldeq_ir2_fr2_pb
	.byte	3

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1230

LINE_1220

	; GOTO 1190

	.byte	bytecode_goto_ix
	.word	LINE_1190

LINE_1230

	; PRINT STR$(K);" ";

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_K

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

LINE_1240

	; IF M=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1250

	; K=-K+(4)

	.byte	bytecode_rsub_fx_fx_pb
	.byte	bytecode_FLTVAR_K
	.byte	4

LINE_1250

	; FOR L=1 TO K

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_to_ip_ix
	.byte	bytecode_FLTVAR_K

	; ON J GOSUB 770,850,930

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ongosub_ir1_is
	.byte	3
	.word	LINE_770, LINE_850, LINE_930

	; NEXT L

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_next

LINE_1260

	; GOSUB 630

	.byte	bytecode_gosub_ix
	.word	LINE_630

	; GOTO 1040

	.byte	bytecode_goto_ix
	.word	LINE_1040

LINE_1270

	; PRINT "SHUFFLING...\r";

	.byte	bytecode_pr_ss
	.text	13, "SHUFFLING...\r"

	; FOR L=1 TO 20

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_to_ip_pb
	.byte	20

	; J=RND(3)

	.byte	bytecode_irnd_ir1_pb
	.byte	3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; H=RND(3)

	.byte	bytecode_irnd_ir1_pb
	.byte	3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

	; ON J GOSUB 770,850,930

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ongosub_ir1_is
	.byte	3
	.word	LINE_770, LINE_850, LINE_930

LINE_1280

	; NEXT L

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_next

LINE_1290

	; PRINT "COMPUTER SOLVE THE CUBE (Y/N)?";

	.byte	bytecode_pr_ss
	.text	30, "COMPUTER SOLVE THE CUBE (Y/N)?"

LINE_1300

	; A$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_A

	; WHEN A$="" GOTO 1300

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1300

LINE_1301

	; PRINT A$;"\r";

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; IF A$="Y" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Y"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1310

	; QA=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_QA

	; GOTO 1640

	.byte	bytecode_goto_ix
	.word	LINE_1640

LINE_1310

	; GOTO 600

	.byte	bytecode_goto_ix
	.word	LINE_600

LINE_1320

	; PRINT "USE ORIGINAL COLORS (Y/N)?";

	.byte	bytecode_pr_ss
	.text	26, "USE ORIGINAL COLORS (Y/N)?"

LINE_1340

	; A$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_A

	; WHEN A$="" GOTO 1340

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1340

LINE_1341

	; PRINT A$;"\r";

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; WHEN A$="N" GOTO 1430

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "N"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1430

LINE_1342

	; PRINT "ONE MOMENT...\r";

	.byte	bytecode_pr_ss
	.text	14, "ONE MOMENT...\r"

LINE_1350

	; A$(1)="ˇˇ"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xFF\xFF"

	.byte	bytecode_ld_sp_sr1

	; A$(2)="üü"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x9F\x9F"

	.byte	bytecode_ld_sp_sr1

	; A$(3)="ØØ"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xAF\xAF"

	.byte	bytecode_ld_sp_sr1

	; A$(4)="èè"

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x8F\x8F"

	.byte	bytecode_ld_sp_sr1

	; A$(5)="œœ"

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xCF\xCF"

	.byte	bytecode_ld_sp_sr1

	; A$(6)="øø"

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xBF\xBF"

	.byte	bytecode_ld_sp_sr1

LINE_1360

	; FOR X=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	6

	; FOR Y=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	3

	; FOR Z=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	3

	; A1$(X,Y,Z)=A$(X)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sp_sr1

	; NEXT Z,Y,X

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_next

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_1380

	; PRINT "SHUFFLE CUBE (Y/N)?";

	.byte	bytecode_pr_ss
	.text	19, "SHUFFLE CUBE (Y/N)?"

LINE_1390

	; A$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_A

	; WHEN A$="" GOTO 1390

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1390

LINE_1391

	; PRINT A$;"\r";

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; WHEN A$="Y" GOTO 1270

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Y"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1270

LINE_1400

	; PRINT "CERTAIN SETUP (Y/N)?";

	.byte	bytecode_pr_ss
	.text	20, "CERTAIN SETUP (Y/N)?"

LINE_1410

	; A$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_A

	; WHEN A$="" GOTO 1410

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1410

LINE_1411

	; PRINT A$;"\r";

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; WHEN A$="Y" GOTO 1470

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Y"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1470

LINE_1415

	; QA=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_QA

LINE_1420

	; GOTO 600

	.byte	bytecode_goto_ix
	.word	LINE_600

LINE_1430

	; PRINT "ENTER THE SIX COLORS (TOP,FRONT,RIGHT,LEFT,BEHIND,UNDER). SHIFT-Q TWICE FOR EACH";

	.byte	bytecode_pr_ss
	.text	80, "ENTER THE SIX COLORS (TOP,FRONT,RIGHT,LEFT,BEHIND,UNDER). SHIFT-Q TWICE FOR EACH"

LINE_1431

	; INPUT A$(1),A$(2),A$(3),A$(4),A$(5),A$(6)

	.byte	bytecode_input

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ignxtra

	; GOTO 1360

	.byte	bytecode_goto_ix
	.word	LINE_1360

LINE_1440

	; CLS

	.byte	bytecode_cls

	; PRINT "START OVER FROM BEGINNING (Y/N)?";

	.byte	bytecode_pr_ss
	.text	32, "START OVER FROM BEGINNING (Y/N)?"

LINE_1450

	; A$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_A

	; WHEN A$="" GOTO 1450

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1450

LINE_1451

	; PRINT A$;"\r";

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; WHEN A$="Y" GOTO 500

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Y"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_500

LINE_1460

	; GOTO 1290

	.byte	bytecode_goto_ix
	.word	LINE_1290

LINE_1470

	; FOR M1=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_to_fp_pb
	.byte	6

	; FOR M2=1 TO 3

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_to_fp_pb
	.byte	3

	; FOR M3=1 TO 3

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_to_fp_pb
	.byte	3

	; A1$(M1,M2,M3)="--"

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sr1_ss
	.text	2, "--"

	.byte	bytecode_ld_sp_sr1

LINE_1480

	; NEXT M3,M2,M1

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_next

	; GOSUB 530

	.byte	bytecode_gosub_ix
	.word	LINE_530

LINE_1485

	; PRINT @480, "CTRL-0 OR CTRL-A THEN HIT ENTER";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	31, "CTRL-0 OR CTRL-A THEN HIT ENTER"

	; POKE 17026,191

	.byte	bytecode_ld_ir1_pb
	.byte	191

	.byte	bytecode_poke_pw_ir1
	.word	17026

LINE_1490

	; FOR M1=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_to_fp_pb
	.byte	6

	; FOR M2=1 TO 3

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_to_fp_pb
	.byte	3

	; FOR M3=1 TO 3

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_to_fp_pb
	.byte	3

LINE_1500

	; PRINT @0, "ADDRESS (FACE,C,R):";STR$(M1);" ";STR$(M2);" ";STR$(M3);" ";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	19, "ADDRESS (FACE,C,R):"

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

LINE_1510

	; A$=CHR$(PEEK(17026)-((PEEK(17026)<128) AND -128))

	.byte	bytecode_peek_ir1_pw
	.word	17026

	.byte	bytecode_peek_ir2_pw
	.word	17026

	.byte	bytecode_ldlt_ir2_ir2_pb
	.byte	128

	.byte	bytecode_and_ir2_ir2_nb
	.byte	-128

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_chr_sr1_ir1

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_A

	; A1$(M1,M2,M3)=A$+A$

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_strcat_sr1_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ld_sp_sr1

	; GOSUB 2470

	.byte	bytecode_gosub_ix
	.word	LINE_2470

LINE_1520

	; A$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_A

	; WHEN A$="" GOTO 1510

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1510

LINE_1522

	; IF A$="\x08" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "\x08"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1523

	; PRINT "\x08\x08ÄÄ";

	.byte	bytecode_pr_ss
	.text	4, "\x08\x08\x80\x80"

	; M3+=M3>1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ldlt_ir1_ir1_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_add_fx_fx_ir1
	.byte	bytecode_FLTVAR_M3

	; GOTO 1500

	.byte	bytecode_goto_ix
	.word	LINE_1500

LINE_1523

	; WHEN A$<>"\r" GOTO 1510

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ldne_ir1_sr1_ss
	.text	1, "\r"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1510

LINE_1530

	; NEXT M3,M2,M1

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_next

LINE_1540

	; FOR X=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	6

	; A2$(X)="123"

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A2

	.byte	bytecode_ld_sr1_ss
	.text	3, "123"

	.byte	bytecode_ld_sp_sr1

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_1550

	; M4=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_M4

	; FOR M1=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_to_fp_pb
	.byte	6

	; FOR M2=1 TO 3

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_to_fp_pb
	.byte	3

	; FOR M3=1 TO 3

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_to_fp_pb
	.byte	3

LINE_1560

	; FOR M5=1 TO M4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_M5

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_M4

	; WHEN A1$(M1,M2,M3)=A2$(M5) GOTO 1565

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M5

	.byte	bytecode_arrval1_ir2_sx
	.byte	bytecode_STRARR_A2

	.byte	bytecode_ldeq_ir1_sr1_sr2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1565

LINE_1561

	; GOTO 1570

	.byte	bytecode_goto_ix
	.word	LINE_1570

LINE_1565

	; M(M5)+=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_inc_ip_ip

	; WHEN M(M5)>9 GOTO 1590

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M5

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldlt_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1590

LINE_1566

	; GOTO 1580

	.byte	bytecode_goto_ix
	.word	LINE_1580

LINE_1570

	; NEXT M5

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_M5

	.byte	bytecode_next

	; M4+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_M4

	; WHEN M4>6 GOTO 1590

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_M4

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_1590

LINE_1571

	; M(M4)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_one_ip

	; A2$(M4)=A1$(M1,M2,M3)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M4

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A2

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

LINE_1580

	; NEXT M3,M2,M1

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_next

	; CLS

	.byte	bytecode_cls

	; GOTO 1290

	.byte	bytecode_goto_ix
	.word	LINE_1290

LINE_1590

	; GOSUB 530

	.byte	bytecode_gosub_ix
	.word	LINE_530

	; GOSUB 630

	.byte	bytecode_gosub_ix
	.word	LINE_630

	; PRINT @0, "ENTER CORRECTIONS (0,0,0=DONE)";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	30, "ENTER CORRECTIONS (0,0,0=DONE)"

	; PRINT @448, "                                ";

	.byte	bytecode_prat_pw
	.word	448

	.byte	bytecode_pr_ss
	.text	32, "                                "

LINE_1610

	; PRINT @448, "";

	.byte	bytecode_prat_pw
	.word	448

	.byte	bytecode_pr_ss
	.text	0, ""

	; INPUT "ENTER FACE,C,R"; M1,M2,M3

	.byte	bytecode_pr_ss
	.text	14, "ENTER FACE,C,R"

	.byte	bytecode_input

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_ignxtra

LINE_1620

	; WHEN M1=0 GOTO 1540

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_jmpeq_fr1_ix
	.word	LINE_1540

LINE_1625

	; PRINT @448,

	.byte	bytecode_prat_pw
	.word	448

LINE_1626

	; A1$(M1,M2,M3)="??"

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sr1_ss
	.text	2, "??"

	.byte	bytecode_ld_sp_sr1

	; GOSUB 2470

	.byte	bytecode_gosub_ix
	.word	LINE_2470

LINE_1630

	; PRINT @448, "\r";

	.byte	bytecode_prat_pw
	.word	448

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; PRINT @448,

	.byte	bytecode_prat_pw
	.word	448

	; INPUT "INPUT COLOR BLOCKS"; A1$(M1,M2,M3)

	.byte	bytecode_pr_ss
	.text	18, "INPUT COLOR BLOCKS"

	.byte	bytecode_input

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrref3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_readbuf_sp

	.byte	bytecode_ignxtra

	; GOSUB 2470

	.byte	bytecode_gosub_ix
	.word	LINE_2470

	; GOTO 1610

	.byte	bytecode_goto_ix
	.word	LINE_1610

LINE_1640

	; FOR X=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	6

	; A$(X)=A1$(X,2,2)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ld_sp_sr1

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; PRINT "THE COMPUTER IS THINKING...\r";

	.byte	bytecode_pr_ss
	.text	28, "THE COMPUTER IS THINKING...\r"

LINE_1660

	; FOR X=1 TO 6

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	6

	; FOR Y=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	3

	; FOR Z=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	3

LINE_1670

	; FOR Q=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_to_ip_pb
	.byte	6

	; IF A$(Q)=A1$(X,Y,Z) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir4_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir2_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_ldeq_ir1_sr1_sr2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1680

	; QQ(X,Y,Z)=Q

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_QQ

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_ld_ip_ir1

	; GOTO 1690

	.byte	bytecode_goto_ix
	.word	LINE_1690

LINE_1680

	; NEXT Q

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_next

	; GOTO 1590

	.byte	bytecode_goto_ix
	.word	LINE_1590

LINE_1690

	; NEXT Z,Y,X

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_next

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_1700

	; RESTORE

	.byte	bytecode_restore

	; FOR B=1 TO 8

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_to_ip_pb
	.byte	8

	; FOR C=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	3

LINE_1710

	; READ X,Z,Y

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_read_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_read_ix
	.byte	bytecode_INTVAR_Y

	; Q3(0,B,C)=QQ(X,Y,Z)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_QQ

	.byte	bytecode_ld_ip_ir1

	; NEXT C,B

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_next

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_next

LINE_1720

LINE_1730

LINE_1740

LINE_1750

LINE_1760

	; FOR X=1 TO 8

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	8

	; B=Q3(0,X,1)+Q3(0,X,2)+Q3(0,X,3)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir4_pb
	.byte	2

	.byte	bytecode_arrval3_ir2_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir4_pb
	.byte	3

	.byte	bytecode_arrval3_ir2_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

LINE_1770

	; IF B=10 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	10

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1780

	; Q3(0,X,0)=1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_one_ip

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1780

	; IF B=7 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	7

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1790

	; Q3(0,X,0)=2

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	2

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1790

	; IF B=6 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	6

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1800

	; Q3(0,X,0)=3

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	3

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1800

	; IF B=9 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1810

	; Q3(0,X,0)=4

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	4

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1810

	; IF B=15 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	15

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1820

	; Q3(0,X,0)=5

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	5

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1820

	; IF B=12 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	12

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1830

	; Q3(0,X,0)=6

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	6

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1830

	; IF B=11 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	11

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1840

	; Q3(0,X,0)=7

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	7

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1840

	; IF B=14 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	14

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1850

	; Q3(0,X,0)=8

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	8

	; GOTO 1860

	.byte	bytecode_goto_ix
	.word	LINE_1860

LINE_1850

	; GOTO 1590

	.byte	bytecode_goto_ix
	.word	LINE_1590

LINE_1860

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_1870

	; FOR X=1 TO 8

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	8

	; FOR Y=1 TO 3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	3

	; IF (Q3(0,X,Y)=1) OR (Q3(0,X,Y)=6) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir4_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir2_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	6

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1880

	; Q3(0,X,1)=Y

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; GOTO 1890

	.byte	bytecode_goto_ix
	.word	LINE_1890

LINE_1880

	; NEXT Y

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	; GOTO 1590

	.byte	bytecode_goto_ix
	.word	LINE_1590

LINE_1890

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_1900

	; FOR B=1 TO 12

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_to_ip_pb
	.byte	12

	; FOR C=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	2

	; READ X,Y,Z

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_read_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_read_ix
	.byte	bytecode_INTVAR_Z

	; Q3(1,B,C)=QQ(X,Y,Z)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_QQ

	.byte	bytecode_ld_ip_ir1

	; NEXT C,B

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_next

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_next

LINE_1910

LINE_1920

LINE_1930

LINE_1940

	; FOR X=1 TO 12

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	12

	; B=Q3(1,X,1)+Q3(1,X,2)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir4_pb
	.byte	2

	.byte	bytecode_arrval3_ir2_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; C=Q3(1,X,1)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_C

	; IF Q3(1,X,2)<C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1950

	; C=Q3(1,X,2)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_C

LINE_1950

	; IF B=5 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1960

	; IF C=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1960

	; Q3(1,X,0)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_one_ip

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_1960

	; IF B=3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1970

	; Q3(1,X,0)=2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	2

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_1970

	; IF B=4 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1980

	; Q3(1,X,0)=3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	3

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_1980

	; IF B=6 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	6

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1990

	; IF C=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_1990

	; Q3(1,X,0)=4

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	4

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_1990

	; IF B=9 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2000

	; IF C=4 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2000

	; Q3(1,X,0)=5

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	5

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2000

	; IF B=6 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	6

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2010

	; Q3(1,X,0)=6

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	6

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2010

	; IF B=5 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2020

	; Q3(1,X,0)=7

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	7

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2020

	; IF B=8 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	8

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2030

	; IF C=3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2030

	; Q3(1,X,0)=8

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	8

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2030

	; IF B=10 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	10

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2040

	; Q3(1,X,0)=9

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	9

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2040

	; IF B=8 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	8

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2050

	; Q3(1,X,0)=10

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	10

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2050

	; IF B=9 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2060

	; Q3(1,X,0)=11

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	11

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2060

	; IF B=11 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	11

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2070

	; Q3(1,X,0)=12

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_pb
	.byte	12

	; GOTO 2080

	.byte	bytecode_goto_ix
	.word	LINE_2080

LINE_2070

	; GOTO 1590

	.byte	bytecode_goto_ix
	.word	LINE_1590

LINE_2080

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_2090

	; FOR X=1 TO 12

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	12

	; FOR Y=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	2

	; IF (Q3(1,X,Y)=1) OR (Q3(1,X,Y)=6) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir4_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir2_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	6

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2100

	; Q3(1,X,1)=Y

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; GOTO 2120

	.byte	bytecode_goto_ix
	.word	LINE_2120

LINE_2100

	; NEXT Y

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	; FOR Y=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	2

	; IF (Q3(1,X,Y)=5) OR (Q3(1,X,Y)=2) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir4_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir2_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2110

	; Q3(1,X,1)=Y

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; GOTO 2120

	.byte	bytecode_goto_ix
	.word	LINE_2120

LINE_2110

	; NEXT Y

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_next

	; GOTO 1590

	.byte	bytecode_goto_ix
	.word	LINE_1590

LINE_2120

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_2130

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; FOR X=1 TO 8

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	8

	; Q1(B)=SHIFT(Q3(0,X,0),1)-1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(B+1)=Q3(0,X,1)

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_ir1

	; B+=2

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_2140

	; FOR X=1 TO 12

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	12

	; Q1(B)=SHIFT(Q3(1,X,0),1)+15

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	15

	.byte	bytecode_ld_ip_ir1

	; Q1(B+1)=Q3(1,X,1)

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_Q3

	.byte	bytecode_ld_ip_ir1

	; B+=2

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_2180

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_2190

	; GOTO 2520

	.byte	bytecode_goto_ix
	.word	LINE_2520

LINE_2220

	; Q1(0)=Q1(5)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(5)=Q1(13)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(13)=Q1(15)

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(15)=Q1(7)

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(7)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(6)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2221

	; Q1(6)=Q1(14)+1

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(14)=Q1(16)+2

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

	; Q1(16)=Q1(8)+1

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(8)=Q1(0)+2

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

LINE_2230

	; Q1(0)=Q1(21)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	21

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(21)=Q1(29)

	.byte	bytecode_ld_ir1_pb
	.byte	21

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	29

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(29)=Q1(37)

	.byte	bytecode_ld_ir1_pb
	.byte	29

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(37)=Q1(31)

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(31)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2231

	; Q1(0)=Q1(22)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	22

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(22)=Q1(30)

	.byte	bytecode_ld_ir1_pb
	.byte	22

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	30

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(30)=Q1(38)

	.byte	bytecode_ld_ir1_pb
	.byte	30

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	38

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(38)=Q1(32)

	.byte	bytecode_ld_ir1_pb
	.byte	38

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(32)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; GOTO 2340

	.byte	bytecode_goto_ix
	.word	LINE_2340

LINE_2240

	; Q1(0)=Q1(1)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(1)=Q1(9)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(9)=Q1(11)

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(11)=Q1(3)

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(3)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2241

	; Q1(0)=Q1(2)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(2)=Q1(10)+1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(10)=Q1(12)+2

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

	; Q1(12)=Q1(4)+1

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(4)=Q1(0)+2

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

LINE_2250

	; Q1(0)=Q1(17)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	17

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(17)=Q1(25)

	.byte	bytecode_ld_ir1_pb
	.byte	17

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(25)=Q1(33)

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(33)=Q1(27)

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	27

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(27)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	27

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(18)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	18

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2251

	; Q1(18)=Q1(26)

	.byte	bytecode_ld_ir1_pb
	.byte	18

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	26

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(26)=Q1(34)

	.byte	bytecode_ld_ir1_pb
	.byte	26

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	34

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(34)=Q1(28)

	.byte	bytecode_ld_ir1_pb
	.byte	34

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	28

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(28)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	28

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; GOTO 2340

	.byte	bytecode_goto_ix
	.word	LINE_2340

LINE_2260

	; Q1(0)=Q1(1)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(1)=Q1(7)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(7)=Q1(15)

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(15)=Q1(9)

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(9)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(2)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2261

	; Q1(2)=Q1(8)+2

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

	; Q1(8)=Q1(16)+1

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(16)=Q1(10)+2

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

	; Q1(10)=Q1(0)+1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

LINE_2270

	; Q1(0)=Q1(23)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	23

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(23)=Q1(31)

	.byte	bytecode_ld_ir1_pb
	.byte	23

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(31)=Q1(39)

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(39)=Q1(25)

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(25)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(24)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	24

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2271

	; Q1(24)=Q1(32)+1

	.byte	bytecode_ld_ir1_pb
	.byte	24

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(32)=Q1(40)+1

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(40)=Q1(26)+1

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	26

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(26)=Q1(0)+1

	.byte	bytecode_ld_ir1_pb
	.byte	26

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; GOTO 2340

	.byte	bytecode_goto_ix
	.word	LINE_2340

LINE_2280

	; Q1(0)=Q1(3)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(3)=Q1(11)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(11)=Q1(13)

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(13)=Q1(5)

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(5)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(4)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2281

	; Q1(4)=Q1(12)+1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(12)=Q1(14)+2

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

	; Q1(14)=Q1(6)+1

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(6)=Q1(0)+2

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ip_ir1

LINE_2290

	; Q1(0)=Q1(19)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	19

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(19)=Q1(27)

	.byte	bytecode_ld_ir1_pb
	.byte	19

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	27

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(27)=Q1(35)

	.byte	bytecode_ld_ir1_pb
	.byte	27

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(35)=Q1(29)

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	29

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(29)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	29

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(20)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	20

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2291

	; Q1(20)=Q1(28)+1

	.byte	bytecode_ld_ir1_pb
	.byte	20

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	28

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(28)=Q1(36)+1

	.byte	bytecode_ld_ir1_pb
	.byte	28

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	36

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(36)=Q1(30)+1

	.byte	bytecode_ld_ir1_pb
	.byte	36

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	30

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; Q1(30)=Q1(0)+1

	.byte	bytecode_ld_ir1_pb
	.byte	30

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; GOTO 2340

	.byte	bytecode_goto_ix
	.word	LINE_2340

LINE_2300

	; Q1(0)=Q1(1)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(1)=Q1(3)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(3)=Q1(5)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(5)=Q1(7)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(7)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(2)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(2)=Q1(4)

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(4)=Q1(6)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(6)=Q1(8)

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(8)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2310

	; Q1(0)=Q1(17)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	17

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(17)=Q1(19)

	.byte	bytecode_ld_ir1_pb
	.byte	17

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	19

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(19)=Q1(21)

	.byte	bytecode_ld_ir1_pb
	.byte	19

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	21

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(21)=Q1(23)

	.byte	bytecode_ld_ir1_pb
	.byte	21

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	23

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(23)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	23

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(18)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	18

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2311

	; Q1(18)=Q1(20)

	.byte	bytecode_ld_ir1_pb
	.byte	18

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	20

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(20)=Q1(22)

	.byte	bytecode_ld_ir1_pb
	.byte	20

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	22

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(22)=Q1(24)

	.byte	bytecode_ld_ir1_pb
	.byte	22

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	24

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(24)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	24

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; GOTO 2340

	.byte	bytecode_goto_ix
	.word	LINE_2340

LINE_2320

	; Q1(0)=Q1(9)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(9)=Q1(15)

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(15)=Q1(13)

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(13)=Q1(11)

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(11)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(10)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2321

	; Q1(10)=Q1(16)

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(16)=Q1(14)

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(14)=Q1(12)

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(12)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2330

	; Q1(0)=Q1(40)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(40)=Q1(38)

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	38

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(38)=Q1(36)

	.byte	bytecode_ld_ir1_pb
	.byte	38

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	36

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(36)=Q1(34)

	.byte	bytecode_ld_ir1_pb
	.byte	36

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	34

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(34)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	34

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(0)=Q1(39)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2331

	; Q1(39)=Q1(37)

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(37)=Q1(35)

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(35)=Q1(33)

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

	; Q1(33)=Q1(0)

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ip_ir1

LINE_2340

	; FOR X=2 TO 16 STEP 2

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_X
	.byte	2

	.byte	bytecode_to_fp_pb
	.byte	16

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_step_fp_ir1

	; IF Q1(X)>3 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldlt_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2350

	; Q1(X)-=3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ip_ip_pb
	.byte	3

LINE_2350

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_2360

	; FOR X=20 TO 40 STEP 2

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_X
	.byte	20

	.byte	bytecode_to_fp_pb
	.byte	40

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_step_fp_ir1

LINE_2370

	; IF Q1(X)=3 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2380

	; Q1(X)=1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_one_ip

LINE_2380

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_2390

	; RETURN

	.byte	bytecode_return

LINE_2400

	; IF X=1 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2410

	; NA=285

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_NA
	.word	285

LINE_2410

	; IF X=2 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2420

	; NA=477

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_NA
	.word	477

LINE_2420

	; IF X=3 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2430

	; NA=552

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_NA
	.word	552

	; C=-C

	.byte	bytecode_neg_ix_ix
	.byte	bytecode_INTVAR_C

LINE_2430

	; IF X=4 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2440

	; NA=272

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_NA
	.word	272

LINE_2440

	; IF X=5 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	5

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2450

	; NA=109

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NA
	.byte	109

	; B=-B

	.byte	bytecode_neg_ix_ix
	.byte	bytecode_INTVAR_B

LINE_2450

	; IF X=6 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_ldeq_ir1_fr1_pb
	.byte	6

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_2460

	; NA=517

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_NA
	.word	517

	; C=-C

	.byte	bytecode_neg_ix_ix
	.byte	bytecode_INTVAR_C

LINE_2460

	; RETURN

	.byte	bytecode_return

LINE_2470

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; C=64

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	64

	; X=M1

	.byte	bytecode_ld_fd_fx
	.byte	bytecode_FLTVAR_X
	.byte	bytecode_FLTVAR_M1

	; GOSUB 2400

	.byte	bytecode_gosub_ix
	.word	LINE_2400

	; PRINT @SHIFT((C*M3)+(B*M2)+NA,-1), A1$(M1,M2,M3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_mul_fr1_ir1_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_mul_fr2_ir2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_add_fr1_fr1_fr2

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_NA

	.byte	bytecode_hlf_fr1_fr1

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_M1

	.byte	bytecode_ld_fr2_fx
	.byte	bytecode_FLTVAR_M2

	.byte	bytecode_ld_fr3_fx
	.byte	bytecode_FLTVAR_M3

	.byte	bytecode_arrval3_ir1_sx
	.byte	bytecode_STRARR_A1

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_2480

	; BP+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_BP

	; BL(BP)=B

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_BP

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ip_ir1

	; B1=IDIV(B,3)

	.byte	bytecode_idiv3_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B1

	; B2=B+1-(B1*3)

	.byte	bytecode_mul3_ir1_ix
	.byte	bytecode_INTVAR_B1

	.byte	bytecode_rsub_ir1_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B2

LINE_2490

	; FOR B3=1 TO B2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_B3

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_B2

	; ON B1+1 GOSUB 2220,2240,2260,2280,2300,2320,2510

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_B1

	.byte	bytecode_ongosub_ir1_is
	.byte	7
	.word	LINE_2220, LINE_2240, LINE_2260, LINE_2280, LINE_2300, LINE_2320, LINE_2510

LINE_2500

	; NEXT B3

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_B3

	.byte	bytecode_next

LINE_2510

	; RETURN

	.byte	bytecode_return

LINE_2520

	; BP=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_BP

LINE_2530

	; C=19

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	19

	; GOSUB 5000

	.byte	bytecode_gosub_ix
	.word	LINE_5000

	; C=21

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	21

	; GOSUB 5000

	.byte	bytecode_gosub_ix
	.word	LINE_5000

	; C=23

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	23

	; GOSUB 5000

	.byte	bytecode_gosub_ix
	.word	LINE_5000

	; C=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	17

	; GOSUB 5000

	.byte	bytecode_gosub_ix
	.word	LINE_5000

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_2540

	; GOSUB 5300

	.byte	bytecode_gosub_ix
	.word	LINE_5300

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; GOSUB 5430

	.byte	bytecode_gosub_ix
	.word	LINE_5430

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_2550

	; GOSUB 5500

	.byte	bytecode_gosub_ix
	.word	LINE_5500

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_2560

	; GOSUB 5670

	.byte	bytecode_gosub_ix
	.word	LINE_5670

LINE_2570

	; GOSUB 5700

	.byte	bytecode_gosub_ix
	.word	LINE_5700

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

LINE_2580

	; GOSUB 5740

	.byte	bytecode_gosub_ix
	.word	LINE_5740

	; GOSUB 5830

	.byte	bytecode_gosub_ix
	.word	LINE_5830

LINE_2590

	; IF Q1(9)<>9 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldne_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_3900

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 2590

	.byte	bytecode_goto_ix
	.word	LINE_2590

LINE_3900

	; PRINT "*";

	.byte	bytecode_pr_ss
	.text	1, "*"

	; GOSUB 4100

	.byte	bytecode_gosub_ix
	.word	LINE_4100

LINE_3910

	; FOR X=1 TO 39 STEP 2

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	39

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_step_fp_ir1

	; IF Q1(X)<>X THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldne_ir1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_3911

	; WHEN Q1(X+1)<>1 GOTO 3915

	.byte	bytecode_inc_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldne_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_3915

LINE_3911

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

	; GOTO 3920

	.byte	bytecode_goto_ix
	.word	LINE_3920

LINE_3915

	; PRINT "ERROR";

	.byte	bytecode_pr_ss
	.text	5, "ERROR"

LINE_3920

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; INPUT "COMPUTER READY, HIT ENTER"; A$

	.byte	bytecode_pr_ss
	.text	25, "COMPUTER READY, HIT ENTER"

	.byte	bytecode_input

	.byte	bytecode_readbuf_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ignxtra

LINE_4000

	; GOSUB 5130

	.byte	bytecode_gosub_ix
	.word	LINE_5130

	; GOTO 1040

	.byte	bytecode_goto_ix
	.word	LINE_1040

LINE_4100

	; FOR X=2 TO BP

	.byte	bytecode_for_fx_pb
	.byte	bytecode_FLTVAR_X
	.byte	2

	.byte	bytecode_to_fp_ix
	.byte	bytecode_INTVAR_BP

	; B=IDIV(BL(X),3)*3

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_idiv3_ir1_ir1

	.byte	bytecode_mul3_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; C=BL(X)-B

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_C

	; D=IDIV(BL(X-1),3)*3

	.byte	bytecode_dec_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_idiv3_ir1_ir1

	.byte	bytecode_mul3_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_D

	; E=BL(X-1)-D

	.byte	bytecode_dec_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_E

	; IF B=D THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_D

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_4110

	; BL(X-1)=18

	.byte	bytecode_dec_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_ld_ip_pb
	.byte	18

	; BL(X)+=E+1

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_add_ip_ip_ir1

	; GOTO 4120

	.byte	bytecode_goto_ix
	.word	LINE_4120

LINE_4110

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_4120

	; IF (C+E)=2 THEN

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_C
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_4130

	; BL(X)=18

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_ld_ip_pb
	.byte	18

LINE_4130

	; IF (C+E)>2 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_C
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ldlt_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_4140

	; BL(X)-=4

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_sub_ip_ip_pb
	.byte	4

LINE_4140

	; IF BL(X)=19 THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	19

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_4150

	; BL(X)=18

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_ld_ip_pb
	.byte	18

LINE_4150

	; GOTO 4110

	.byte	bytecode_goto_ix
	.word	LINE_4110

LINE_5000

	; D=18

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	18

	; IF Q1(29)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	29

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5010

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5010

	; IF Q1(17)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	17

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5020

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5020

	; IF Q1(19)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	19

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5030

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5030

	; IF Q1(21)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	21

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5040

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5040

	; IF Q1(23)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	23

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5050

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5050

	; IF Q1(27)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	27

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5060

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5060

	; IF Q1(31)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5070

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; D=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	6

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5070

	; IF Q1(25)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	25

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5080

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; D=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	8

	; GOTO 5090

	.byte	bytecode_goto_ix
	.word	LINE_5090

LINE_5080

	; GOTO 5100

	.byte	bytecode_goto_ix
	.word	LINE_5100

LINE_5090

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

LINE_5100

	; WHEN Q1(35)=C GOTO 5110

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5110

LINE_5101

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5100

	.byte	bytecode_goto_ix
	.word	LINE_5100

LINE_5110

	; B=D

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_D

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; IF Q1(36)=1 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	36

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5120

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	12

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_5120

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	12

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_5130

	; B1=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B1

	; GOSUB 530

	.byte	bytecode_gosub_ix
	.word	LINE_530

LINE_5132

	; FOR J1=1 TO BP

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J1

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_BP

	; J2=BL(J1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J1

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_BL

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J2

	; J3=IDIV(J2,3)

	.byte	bytecode_idiv3_ir1_ix
	.byte	bytecode_INTVAR_J2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J3

	; J2+=1-(J3*3)

	.byte	bytecode_mul3_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	1

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_J2

	; WHEN J3=6 GOTO 5210

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	6

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5210

LINE_5135

	; PRINT @0, "MOVE  ";STR$(J2);" ";TAB(16);"# OF MOVES";STR$(B1);" ";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	6, "MOVE  "

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_J2

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	.byte	bytecode_prtab_pb
	.byte	16

	.byte	bytecode_pr_ss
	.text	10, "# OF MOVES"

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_B1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; B1+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_B1

LINE_5140

	; IF J3=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5150

	; J=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	; H=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H
	.byte	3

	; PRINT @6, "R";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "R"

	; GOTO 5200

	.byte	bytecode_goto_ix
	.word	LINE_5200

LINE_5150

	; IF J3=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5160

	; J=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	; H=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_H

	; J2=-J2+(4)

	.byte	bytecode_rsub_ix_ix_pb
	.byte	bytecode_INTVAR_J2
	.byte	4

	; PRINT @6, "L";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "L"

	; GOTO 5200

	.byte	bytecode_goto_ix
	.word	LINE_5200

LINE_5160

	; IF J3=2 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5170

	; J=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_J

	; H=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_H

	; PRINT @6, "B";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "B"

	; GOTO 5200

	.byte	bytecode_goto_ix
	.word	LINE_5200

LINE_5170

	; IF J3=3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5180

	; J=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_J

	; H=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H
	.byte	3

	; J2=-J2+(4)

	.byte	bytecode_rsub_ix_ix_pb
	.byte	bytecode_INTVAR_J2
	.byte	4

	; PRINT @6, "F";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "F"

	; GOTO 5200

	.byte	bytecode_goto_ix
	.word	LINE_5200

LINE_5180

	; IF J3=4 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5190

	; J=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	3

	; H=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_H

	; J2=-J2+(4)

	.byte	bytecode_rsub_ix_ix_pb
	.byte	bytecode_INTVAR_J2
	.byte	4

	; PRINT @6, "T";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "T"

	; GOTO 5200

	.byte	bytecode_goto_ix
	.word	LINE_5200

LINE_5190

	; IF J3=5 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J3

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5200

	; J=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	3

	; H=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_H
	.byte	3

	; PRINT @6, "U";

	.byte	bytecode_prat_pb
	.byte	6

	.byte	bytecode_pr_ss
	.text	1, "U"

LINE_5200

	; FOR L=1 TO J2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_J2

	; ON J GOSUB 770,850,930

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ongosub_ir1_is
	.byte	3
	.word	LINE_770, LINE_850, LINE_930

	; NEXT L

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_next

	; GOTO 5220

	.byte	bytecode_goto_ix
	.word	LINE_5220

LINE_5210

	; NEXT J1

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_J1

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_5220

	; GOSUB 630

	.byte	bytecode_gosub_ix
	.word	LINE_630

LINE_5230

	; IF CC$="C" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_CC

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "C"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5231

	; IF INKEY$="" THEN

	.byte	bytecode_inkey_sr1

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5231

	; PRINT @480, "HIT ANY KEY FOR SINGLE STEP    ";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	31, "HIT ANY KEY FOR SINGLE STEP    "

	; GOTO 5210

	.byte	bytecode_goto_ix
	.word	LINE_5210

LINE_5231

	; PRINT @480, "C=CONTINUOUS, OR SPACE FOR NEXT";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	31, "C=CONTINUOUS, OR SPACE FOR NEXT"

LINE_5232

	; CC$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_CC

	; WHEN CC$="" GOTO 5232

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_CC

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5232

LINE_5233

	; WHEN CC$="C" GOTO 5230

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_CC

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "C"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5230

LINE_5234

	; WHEN CC$=" " GOTO 5210

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_CC

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, " "

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5210

LINE_5235

	; GOTO 5232

	.byte	bytecode_goto_ix
	.word	LINE_5232

LINE_5300

	; C=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	5

	; FOR X=1 TO 4

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	4

	; C1(X)=0

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_clr_ip

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

	; FOR X=1 TO 7 STEP 2

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	7

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_step_fp_ir1

	; IF Q1(X)=X THEN

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5310

	; IF Q1(X+1)=1 THEN

	.byte	bytecode_inc_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5310

	; C1(SHIFT(X+1,-1))=1

	.byte	bytecode_inc_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_hlf_fr1_fr1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

LINE_5310

	; NEXT X

	.byte	bytecode_nextvar_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_next

LINE_5320

	; IF C1(1)=1 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5330

	; IF C1(2)=1 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5330

	; IF C1(3)=1 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5330

	; IF C1(4)=1 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5330

	; RETURN

	.byte	bytecode_return

LINE_5330

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

LINE_5340

	; IF (Q1(14)=3) AND ((Q1(13)=1) OR (Q1(13)=3) OR (Q1(13)=5) OR (Q1(13)=7)) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	13

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	3

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	5

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	7

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5350

	; GOSUB 5400

	.byte	bytecode_gosub_ix
	.word	LINE_5400

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5320

	.byte	bytecode_goto_ix
	.word	LINE_5320

LINE_5350

	; IF (Q1(14)=2) AND ((Q1(13)=1) OR (Q1(13)=3) OR (Q1(13)=5) OR (Q1(13)=7)) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	13

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	3

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	5

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	7

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5360

	; GOSUB 5400

	.byte	bytecode_gosub_ix
	.word	LINE_5400

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5320

	.byte	bytecode_goto_ix
	.word	LINE_5320

LINE_5360

	; WHEN (Q1(14)=1) AND ((Q1(13)=1) OR (Q1(13)=3) OR (Q1(13)=5) OR (Q1(13)=7)) GOTO 5365

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	13

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	3

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	5

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	7

	.byte	bytecode_or_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5365

LINE_5361

	; GOTO 5370

	.byte	bytecode_goto_ix
	.word	LINE_5370

LINE_5365

	; GOSUB 5400

	.byte	bytecode_gosub_ix
	.word	LINE_5400

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	16

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5320

	.byte	bytecode_goto_ix
	.word	LINE_5320

LINE_5370

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

LINE_5380

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; IF C1(F)=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5390

	; GOSUB 5430

	.byte	bytecode_gosub_ix
	.word	LINE_5430

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5330

	.byte	bytecode_goto_ix
	.word	LINE_5330

LINE_5390

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5400

	; IF Q1(13)=C THEN

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5410

	; C1(SHIFT(C+1,-1))=1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_hlf_fr1_ir1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; RETURN

	.byte	bytecode_return

LINE_5410

	; B=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	12

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; C+=2

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	2

	; IF C=9 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5420

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

LINE_5420

	; GOTO 5400

	.byte	bytecode_goto_ix
	.word	LINE_5400

LINE_5430

	; IF (C+1)=SHIFT(F,1) THEN

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_dbl_ir2_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5440

	; RETURN

	.byte	bytecode_return

LINE_5440

	; B=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	12

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; C+=2

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	2

	; IF C=9 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5450

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

LINE_5450

	; GOTO 5430

	.byte	bytecode_goto_ix
	.word	LINE_5430

LINE_5500

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; C1(F)=0

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_clr_ip

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5510

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; IF (Q1(SHIFT(F,1)+23)=(SHIFT(F,1)+23)) AND (Q1(SHIFT(F,1)+24)=1) THEN

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_add_ir1_ir1_pb
	.byte	23

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_dbl_ir2_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_add_ir2_ir2_pb
	.byte	23

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_dbl_ir2_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_add_ir2_ir2_pb
	.byte	24

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5520

	; C1(F)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

LINE_5520

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5530

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN C1(F)=0 GOTO 5540

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5540

LINE_5531

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_5540

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN (Q1(37)=27) AND (Q1(38)=2) GOTO 5545

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	27

	.byte	bytecode_ld_ir2_pb
	.byte	38

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5545

LINE_5541

	; GOTO 5550

	.byte	bytecode_goto_ix
	.word	LINE_5550

LINE_5545

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; C1(2)=1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5550

	; IF (Q1(39)=27) AND (Q1(40)=1) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	27

	.byte	bytecode_ld_ir2_pb
	.byte	40

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5560

	; GOSUB 6020

	.byte	bytecode_gosub_ix
	.word	LINE_6020

	; C1(2)=1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5560

	; WHEN (Q1(39)=29) AND (Q1(40)=1) GOTO 5565

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	29

	.byte	bytecode_ld_ir2_pb
	.byte	40

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5565

LINE_5561

	; GOTO 5570

	.byte	bytecode_goto_ix
	.word	LINE_5570

LINE_5565

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; C1(3)=1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5570

	; IF (Q1(33)=29) AND (Q1(34)=2) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	29

	.byte	bytecode_ld_ir2_pb
	.byte	34

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5580

	; GOSUB 6030

	.byte	bytecode_gosub_ix
	.word	LINE_6030

	; C1(3)=1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5580

	; WHEN (Q1(33)=31) AND (Q1(34)=2) GOTO 5585

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	34

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5585

LINE_5581

	; GOTO 5590

	.byte	bytecode_goto_ix
	.word	LINE_5590

LINE_5585

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; C1(4)=1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5590

	; IF (Q1(35)=31) AND (Q1(36)=1) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	36

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5600

	; GOSUB 6040

	.byte	bytecode_gosub_ix
	.word	LINE_6040

	; C1(4)=1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5600

	; WHEN (Q1(35)=25) AND (Q1(36)=1) GOTO 5605

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	25

	.byte	bytecode_ld_ir2_pb
	.byte	36

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5605

LINE_5601

	; GOTO 5610

	.byte	bytecode_goto_ix
	.word	LINE_5610

LINE_5605

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; C1(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5610

	; IF (Q1(37)=25) AND (Q1(38)=2) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	25

	.byte	bytecode_ld_ir2_pb
	.byte	38

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5620

	; GOSUB 6010

	.byte	bytecode_gosub_ix
	.word	LINE_6010

	; C1(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_one_ip

	; GOTO 5530

	.byte	bytecode_goto_ix
	.word	LINE_5530

LINE_5620

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5630

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN C1(F)=0 GOTO 5650

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_C1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5650

LINE_5640

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5650

	; ON F GOSUB 6010,6020,6030,6040

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ongosub_ir1_is
	.byte	4
	.word	LINE_6010, LINE_6020, LINE_6030, LINE_6040

LINE_5660

	; GOTO 5540

	.byte	bytecode_goto_ix
	.word	LINE_5540

LINE_5670

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN ((Q1(13)-2)=Q1(15)) OR ((Q1(13)+6)=Q1(15)) GOTO 5675

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	13

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_add_ir2_ir2_pb
	.byte	6

	.byte	bytecode_ld_ir3_pb
	.byte	15

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_ir3

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5675

LINE_5671

	; GOTO 5680

	.byte	bytecode_goto_ix
	.word	LINE_5680

LINE_5675

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

LINE_5676

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

LINE_5680

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_5700

	; FOR F=10 TO 14 STEP 2

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	10

	.byte	bytecode_to_ip_pb
	.byte	14

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_step_ip_ir1

	; WHEN Q1(F)<>1 GOTO 5710

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldne_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5710

LINE_5701

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_5710

	; FOR F=2 TO 3

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	3

	; WHEN ((Q1(10)=F)+(Q1(12)=F)+(Q1(14)=F)+(Q1(16)=F))=-3 GOTO 5800

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_ld_ir2_pb
	.byte	12

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	14

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-3

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5800

LINE_5711

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5720

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN ((Q1(10)=2)+(Q1(12)=2)+(Q1(14)=1)+(Q1(16)=2))=-1 GOTO 5725

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	12

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	14

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	16

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_nb
	.byte	-1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5725

LINE_5721

	; GOTO 5730

	.byte	bytecode_goto_ix
	.word	LINE_5730

LINE_5725

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	16

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5800

	.byte	bytecode_goto_ix
	.word	LINE_5800

LINE_5730

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5740

	; WHEN (Q1(40)=2) AND (Q1(36)=2) AND (Q1(38)=1) GOTO 6190

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	36

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	38

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_6190

LINE_5750

	; IF (Q1(40)=1) AND (Q1(36)=1) AND (Q1(38)=2) THEN

	.byte	bytecode_ld_ir1_pb
	.byte	40

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	36

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	38

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_5760

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 6190

	.byte	bytecode_goto_ix
	.word	LINE_6190

LINE_5760

	; RETURN

	.byte	bytecode_return

LINE_5800

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN (Q1(12)=2) AND (Q1(14)=1) GOTO 5805

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	14

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5805

LINE_5801

	; GOTO 5810

	.byte	bytecode_goto_ix
	.word	LINE_5810

LINE_5805

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	16

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_5810

	; WHEN (Q1(12)=3) AND (Q1(10)=1) GOTO 5815

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	10

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	1

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5815

LINE_5811

	; GOTO 5820

	.byte	bytecode_goto_ix
	.word	LINE_5820

LINE_5815

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	16

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_5820

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5825

	; STOP

	.byte	bytecode_stop

LINE_5830

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN (Q1(34)=2) AND (Q1(40)=2) GOTO 6100

	.byte	bytecode_ld_ir1_pb
	.byte	34

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	40

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_6100

LINE_5831

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5840

	; WHEN ((Q1(35)-Q1(15))=24) AND ((Q1(39)-Q1(11))=24) GOTO 5845

	.byte	bytecode_ld_ir1_pb
	.byte	35

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	24

	.byte	bytecode_ld_ir2_pb
	.byte	39

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir3_pb
	.byte	11

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir2_ir2_ir3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	24

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5845

LINE_5841

	; GOTO 5850

	.byte	bytecode_goto_ix
	.word	LINE_5850

LINE_5845

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=13

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	13

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

LINE_5846

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_5850

	; FOR F=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	2

	; WHEN ((Q1(37)-Q1(15))=24) AND ((Q1(39)-Q1(13))=24) GOTO 5855

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	24

	.byte	bytecode_ld_ir2_pb
	.byte	39

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir2_ir2_ir3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	24

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_5855

LINE_5851

	; GOTO 5860

	.byte	bytecode_goto_ix
	.word	LINE_5860

LINE_5855

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	12

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

LINE_5856

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	14

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	7

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_5860

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5870

	; FOR F=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN ((Q1(39)-Q1(15))=24) AND ((Q1(37)-Q1(13))<>24) GOTO 6190

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	24

	.byte	bytecode_ld_ir2_pb
	.byte	37

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir3_pb
	.byte	13

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir2_ir2_ir3

	.byte	bytecode_ldne_ir2_ir2_pb
	.byte	24

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_6190

LINE_5871

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; NEXT F

	.byte	bytecode_nextvar_ix
	.byte	bytecode_INTVAR_F

	.byte	bytecode_next

LINE_5880

	; RETURN

	.byte	bytecode_return

LINE_6010

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_6020

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_6030

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_6040

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	15

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=17

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	17

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_6100

	; WHEN ((Q1(39)-Q1(9))=24) OR ((Q1(33)-Q1(11))=24) OR (((Q1(35)-Q1(15))=24) AND (Q1(36)=1)) GOTO 6105

	.byte	bytecode_ld_ir1_pb
	.byte	39

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir2_pb
	.byte	9

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	24

	.byte	bytecode_ld_ir2_pb
	.byte	33

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir3_pb
	.byte	11

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir2_ir2_ir3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	24

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_pb
	.byte	35

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir3_pb
	.byte	15

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir2_ir2_ir3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	24

	.byte	bytecode_ld_ir3_pb
	.byte	36

	.byte	bytecode_arrval1_ir3_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ldeq_ir3_ir3_pb
	.byte	1

	.byte	bytecode_and_ir2_ir2_ir3

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_6105

LINE_6101

	; GOTO 6110

	.byte	bytecode_goto_ix
	.word	LINE_6110

LINE_6105

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	16

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	6

LINE_6106

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	9

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	8

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; GOTO 5830

	.byte	bytecode_goto_ix
	.word	LINE_5830

LINE_6110

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	16

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

LINE_6111

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	11

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

LINE_6120

	; GOTO 5830

	.byte	bytecode_goto_ix
	.word	LINE_5830

LINE_6190

	; BM=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_BM
	.byte	14

	; IF (Q1(37)-Q1(11))=24 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	37

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_ld_ir2_pb
	.byte	11

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Q1

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	24

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_6200

	; BM=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_BM
	.byte	12

LINE_6200

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=BM

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_BM

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	3

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	10

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

LINE_6201

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	5

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=BM

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_BM

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; B=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	4

	; GOSUB 2480

	.byte	bytecode_gosub_ix
	.word	LINE_2480

	; RETURN

	.byte	bytecode_return

LINE_6210

	; REM MC-10 EDITS JIM GERRIE

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr1_fr1_fr2	.equ	0
bytecode_add_fr1_fr1_ix	.equ	1
bytecode_add_fx_fx_ir1	.equ	2
bytecode_add_ip_ip_ir1	.equ	3
bytecode_add_ir1_ir1_ir2	.equ	4
bytecode_add_ir1_ir1_ix	.equ	5
bytecode_add_ir1_ir1_pb	.equ	6
bytecode_add_ir1_ix_id	.equ	7
bytecode_add_ir2_ir2_pb	.equ	8
bytecode_add_ir2_ix_id	.equ	9
bytecode_add_ix_ix_ir1	.equ	10
bytecode_add_ix_ix_pb	.equ	11
bytecode_and_ir1_ir1_ir2	.equ	12
bytecode_and_ir2_ir2_ir3	.equ	13
bytecode_and_ir2_ir2_nb	.equ	14
bytecode_arrdim1_ir1_ix	.equ	15
bytecode_arrdim3_ir1_ix	.equ	16
bytecode_arrdim3_ir1_sx	.equ	17
bytecode_arrref1_ir1_ix	.equ	18
bytecode_arrref1_ir1_sx	.equ	19
bytecode_arrref3_ir1_ix	.equ	20
bytecode_arrref3_ir1_sx	.equ	21
bytecode_arrval1_ir1_ix	.equ	22
bytecode_arrval1_ir1_sx	.equ	23
bytecode_arrval1_ir2_ix	.equ	24
bytecode_arrval1_ir2_sx	.equ	25
bytecode_arrval1_ir3_ix	.equ	26
bytecode_arrval3_ir1_ix	.equ	27
bytecode_arrval3_ir1_sx	.equ	28
bytecode_arrval3_ir2_ix	.equ	29
bytecode_arrval3_ir2_sx	.equ	30
bytecode_chr_sr1_ir1	.equ	31
bytecode_clear	.equ	32
bytecode_clr_ip	.equ	33
bytecode_clr_ix	.equ	34
bytecode_cls	.equ	35
bytecode_clsn_pb	.equ	36
bytecode_dbl_ir1_ir1	.equ	37
bytecode_dbl_ir1_ix	.equ	38
bytecode_dbl_ir2_ix	.equ	39
bytecode_dec_fr1_fx	.equ	40
bytecode_dec_ir1_ir1	.equ	41
bytecode_for_fx_pb	.equ	42
bytecode_for_ix_pb	.equ	43
bytecode_forone_fx	.equ	44
bytecode_forone_ix	.equ	45
bytecode_gosub_ix	.equ	46
bytecode_goto_ix	.equ	47
bytecode_hlf_fr1_fr1	.equ	48
bytecode_hlf_fr1_ir1	.equ	49
bytecode_idiv3_ir1_ir1	.equ	50
bytecode_idiv3_ir1_ix	.equ	51
bytecode_ignxtra	.equ	52
bytecode_inc_fr1_fx	.equ	53
bytecode_inc_ip_ip	.equ	54
bytecode_inc_ir1_ir1	.equ	55
bytecode_inc_ir1_ix	.equ	56
bytecode_inc_ix_ix	.equ	57
bytecode_inkey_sr1	.equ	58
bytecode_inkey_sx	.equ	59
bytecode_input	.equ	60
bytecode_irnd_ir1_pb	.equ	61
bytecode_jmpeq_fr1_ix	.equ	62
bytecode_jmpeq_ir1_ix	.equ	63
bytecode_jmpne_ir1_ix	.equ	64
bytecode_ld_fd_fx	.equ	65
bytecode_ld_fr1_fx	.equ	66
bytecode_ld_fr2_fx	.equ	67
bytecode_ld_fr3_fx	.equ	68
bytecode_ld_fx_fr1	.equ	69
bytecode_ld_id_ix	.equ	70
bytecode_ld_ip_ir1	.equ	71
bytecode_ld_ip_pb	.equ	72
bytecode_ld_ir1_ix	.equ	73
bytecode_ld_ir1_pb	.equ	74
bytecode_ld_ir1_pw	.equ	75
bytecode_ld_ir2_ix	.equ	76
bytecode_ld_ir2_pb	.equ	77
bytecode_ld_ir3_ix	.equ	78
bytecode_ld_ir3_pb	.equ	79
bytecode_ld_ir4_ix	.equ	80
bytecode_ld_ir4_pb	.equ	81
bytecode_ld_ix_ir1	.equ	82
bytecode_ld_ix_pb	.equ	83
bytecode_ld_ix_pw	.equ	84
bytecode_ld_sp_sr1	.equ	85
bytecode_ld_sr1_ss	.equ	86
bytecode_ld_sr1_sx	.equ	87
bytecode_ld_sx_sr1	.equ	88
bytecode_ldeq_ir1_fr1_pb	.equ	89
bytecode_ldeq_ir1_ir1_fx	.equ	90
bytecode_ldeq_ir1_ir1_ir2	.equ	91
bytecode_ldeq_ir1_ir1_ix	.equ	92
bytecode_ldeq_ir1_ir1_nb	.equ	93
bytecode_ldeq_ir1_ir1_pb	.equ	94
bytecode_ldeq_ir1_ix_id	.equ	95
bytecode_ldeq_ir1_sr1_sr2	.equ	96
bytecode_ldeq_ir1_sr1_ss	.equ	97
bytecode_ldeq_ir2_fr2_pb	.equ	98
bytecode_ldeq_ir2_ir2_ir3	.equ	99
bytecode_ldeq_ir2_ir2_ix	.equ	100
bytecode_ldeq_ir2_ir2_pb	.equ	101
bytecode_ldeq_ir3_ir3_pb	.equ	102
bytecode_ldlt_ir1_ir1_fx	.equ	103
bytecode_ldlt_ir1_ir1_ir2	.equ	104
bytecode_ldlt_ir1_ir1_ix	.equ	105
bytecode_ldlt_ir2_ir2_pb	.equ	106
bytecode_ldne_ir1_ir1_fx	.equ	107
bytecode_ldne_ir1_ir1_pb	.equ	108
bytecode_ldne_ir1_sr1_ss	.equ	109
bytecode_ldne_ir2_ir2_pb	.equ	110
bytecode_mul3_ir1_ir1	.equ	111
bytecode_mul3_ir1_ix	.equ	112
bytecode_mul_fr1_ir1_fx	.equ	113
bytecode_mul_fr2_ir2_fx	.equ	114
bytecode_mul_ir1_ir1_ix	.equ	115
bytecode_mul_ir2_ir2_ix	.equ	116
bytecode_neg_ix_ix	.equ	117
bytecode_next	.equ	118
bytecode_nextvar_fx	.equ	119
bytecode_nextvar_ix	.equ	120
bytecode_one_fx	.equ	121
bytecode_one_ip	.equ	122
bytecode_one_ix	.equ	123
bytecode_ongosub_ir1_is	.equ	124
bytecode_or_ir1_ir1_ir2	.equ	125
bytecode_or_ir2_ir2_ir3	.equ	126
bytecode_peek_ir1_pw	.equ	127
bytecode_peek_ir2_pw	.equ	128
bytecode_poke_pw_ir1	.equ	129
bytecode_pr_sr1	.equ	130
bytecode_pr_ss	.equ	131
bytecode_pr_sx	.equ	132
bytecode_prat_ir1	.equ	133
bytecode_prat_pb	.equ	134
bytecode_prat_pw	.equ	135
bytecode_progbegin	.equ	136
bytecode_progend	.equ	137
bytecode_prtab_pb	.equ	138
bytecode_read_fx	.equ	139
bytecode_read_ix	.equ	140
bytecode_readbuf_fx	.equ	141
bytecode_readbuf_sp	.equ	142
bytecode_readbuf_sx	.equ	143
bytecode_restore	.equ	144
bytecode_return	.equ	145
bytecode_rsub_fx_fx_pb	.equ	146
bytecode_rsub_ir1_ir1_ix	.equ	147
bytecode_rsub_ir1_ir1_pb	.equ	148
bytecode_rsub_ix_ix_pb	.equ	149
bytecode_step_fp_ir1	.equ	150
bytecode_step_ip_ir1	.equ	151
bytecode_stop	.equ	152
bytecode_str_sr1_fx	.equ	153
bytecode_str_sr1_ix	.equ	154
bytecode_strcat_sr1_sr1_sx	.equ	155
bytecode_strinit_sr1_sx	.equ	156
bytecode_sub_fr2_pb_fx	.equ	157
bytecode_sub_fr3_pb_fx	.equ	158
bytecode_sub_ip_ip_pb	.equ	159
bytecode_sub_ir1_ir1_ir2	.equ	160
bytecode_sub_ir1_ir1_ix	.equ	161
bytecode_sub_ir1_ir1_pb	.equ	162
bytecode_sub_ir1_pb_ix	.equ	163
bytecode_sub_ir2_ir2_ir3	.equ	164
bytecode_to_fp_ix	.equ	165
bytecode_to_fp_pb	.equ	166
bytecode_to_ip_ix	.equ	167
bytecode_to_ip_pb	.equ	168
bytecode_val_fr1_sx	.equ	169

catalog
	.word	add_fr1_fr1_fr2
	.word	add_fr1_fr1_ix
	.word	add_fx_fx_ir1
	.word	add_ip_ip_ir1
	.word	add_ir1_ir1_ir2
	.word	add_ir1_ir1_ix
	.word	add_ir1_ir1_pb
	.word	add_ir1_ix_id
	.word	add_ir2_ir2_pb
	.word	add_ir2_ix_id
	.word	add_ix_ix_ir1
	.word	add_ix_ix_pb
	.word	and_ir1_ir1_ir2
	.word	and_ir2_ir2_ir3
	.word	and_ir2_ir2_nb
	.word	arrdim1_ir1_ix
	.word	arrdim3_ir1_ix
	.word	arrdim3_ir1_sx
	.word	arrref1_ir1_ix
	.word	arrref1_ir1_sx
	.word	arrref3_ir1_ix
	.word	arrref3_ir1_sx
	.word	arrval1_ir1_ix
	.word	arrval1_ir1_sx
	.word	arrval1_ir2_ix
	.word	arrval1_ir2_sx
	.word	arrval1_ir3_ix
	.word	arrval3_ir1_ix
	.word	arrval3_ir1_sx
	.word	arrval3_ir2_ix
	.word	arrval3_ir2_sx
	.word	chr_sr1_ir1
	.word	clear
	.word	clr_ip
	.word	clr_ix
	.word	cls
	.word	clsn_pb
	.word	dbl_ir1_ir1
	.word	dbl_ir1_ix
	.word	dbl_ir2_ix
	.word	dec_fr1_fx
	.word	dec_ir1_ir1
	.word	for_fx_pb
	.word	for_ix_pb
	.word	forone_fx
	.word	forone_ix
	.word	gosub_ix
	.word	goto_ix
	.word	hlf_fr1_fr1
	.word	hlf_fr1_ir1
	.word	idiv3_ir1_ir1
	.word	idiv3_ir1_ix
	.word	ignxtra
	.word	inc_fr1_fx
	.word	inc_ip_ip
	.word	inc_ir1_ir1
	.word	inc_ir1_ix
	.word	inc_ix_ix
	.word	inkey_sr1
	.word	inkey_sx
	.word	input
	.word	irnd_ir1_pb
	.word	jmpeq_fr1_ix
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	ld_fd_fx
	.word	ld_fr1_fx
	.word	ld_fr2_fx
	.word	ld_fr3_fx
	.word	ld_fx_fr1
	.word	ld_id_ix
	.word	ld_ip_ir1
	.word	ld_ip_pb
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir1_pw
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ir3_ix
	.word	ld_ir3_pb
	.word	ld_ir4_ix
	.word	ld_ir4_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ld_ix_pw
	.word	ld_sp_sr1
	.word	ld_sr1_ss
	.word	ld_sr1_sx
	.word	ld_sx_sr1
	.word	ldeq_ir1_fr1_pb
	.word	ldeq_ir1_ir1_fx
	.word	ldeq_ir1_ir1_ir2
	.word	ldeq_ir1_ir1_ix
	.word	ldeq_ir1_ir1_nb
	.word	ldeq_ir1_ir1_pb
	.word	ldeq_ir1_ix_id
	.word	ldeq_ir1_sr1_sr2
	.word	ldeq_ir1_sr1_ss
	.word	ldeq_ir2_fr2_pb
	.word	ldeq_ir2_ir2_ir3
	.word	ldeq_ir2_ir2_ix
	.word	ldeq_ir2_ir2_pb
	.word	ldeq_ir3_ir3_pb
	.word	ldlt_ir1_ir1_fx
	.word	ldlt_ir1_ir1_ir2
	.word	ldlt_ir1_ir1_ix
	.word	ldlt_ir2_ir2_pb
	.word	ldne_ir1_ir1_fx
	.word	ldne_ir1_ir1_pb
	.word	ldne_ir1_sr1_ss
	.word	ldne_ir2_ir2_pb
	.word	mul3_ir1_ir1
	.word	mul3_ir1_ix
	.word	mul_fr1_ir1_fx
	.word	mul_fr2_ir2_fx
	.word	mul_ir1_ir1_ix
	.word	mul_ir2_ir2_ix
	.word	neg_ix_ix
	.word	next
	.word	nextvar_fx
	.word	nextvar_ix
	.word	one_fx
	.word	one_ip
	.word	one_ix
	.word	ongosub_ir1_is
	.word	or_ir1_ir1_ir2
	.word	or_ir2_ir2_ir3
	.word	peek_ir1_pw
	.word	peek_ir2_pw
	.word	poke_pw_ir1
	.word	pr_sr1
	.word	pr_ss
	.word	pr_sx
	.word	prat_ir1
	.word	prat_pb
	.word	prat_pw
	.word	progbegin
	.word	progend
	.word	prtab_pb
	.word	read_fx
	.word	read_ix
	.word	readbuf_fx
	.word	readbuf_sp
	.word	readbuf_sx
	.word	restore
	.word	return
	.word	rsub_fx_fx_pb
	.word	rsub_ir1_ir1_ix
	.word	rsub_ir1_ir1_pb
	.word	rsub_ix_ix_pb
	.word	step_fp_ir1
	.word	step_ip_ir1
	.word	stop
	.word	str_sr1_fx
	.word	str_sr1_ix
	.word	strcat_sr1_sr1_sx
	.word	strinit_sr1_sx
	.word	sub_fr2_pb_fx
	.word	sub_fr3_pb_fx
	.word	sub_ip_ip_pb
	.word	sub_ir1_ir1_ir2
	.word	sub_ir1_ir1_ix
	.word	sub_ir1_ir1_pb
	.word	sub_ir1_pb_ix
	.word	sub_ir2_ir2_ir3
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
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
	ldx	#symtbl
	abx
	abx
	ldx	,x
	pulb
	rts
extdex
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	2,x
	ldx	#symtbl
	abx
	abx
	ldd	,x
	pshb
	ldx	curinst
	ldab	1,x
	ldx	#symtbl
	abx
	abx
	ldx	,x
	pulb
	rts
dexext
	ldd	curinst
	addd	#3
	std	nxtinst
	ldx	curinst
	ldab	1,x
	ldx	#symtbl
	abx
	abx
	ldd	,x
	pshb
	ldx	curinst
	ldab	2,x
	ldx	#symtbl
	abx
	abx
	ldx	,x
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

	.module	mdmul3i
; multiply X by 3
; result in X
; clobbers TMP1+1
mul3i
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	lsld
	rol	tmp1+1
	addd	1,x
	std	1,x
	ldab	0,x
	adcb	tmp1+1
	stab	0,x
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
	subd	2,x
	bhi	_err
	ldd	0+argv
	std	tmp1
	lsld
	rts
_err
	ldab	#BS_ERROR
	jmp	error

	.module	mdref3
; get offset from 3D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref3
	ldd	4,x
	std	tmp1
	subd	2+argv
	bls	_err
	ldd	4+argv
	std	tmp2
	subd	6,x
	bhs	_err
	jsr	mul12
	addd	2+argv
	std	tmp2
	ldd	2,x
	std	tmp1
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
	ldx	tmp2
	jsr	strrel
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

	.module	mdstreqx
streqx
	ldab	0,x
	cmpb	tmp1+1
	bne	_frts
	tstb
	beq	_frts
	ldx	1,x
	jsr	strrel
	pshx
	ldx	tmp2
	jsr	strrel
	pulx
	sts	tmp3
	txs
	ldx	tmp2
_nxtchr
	pula
	cmpa	,x
	bne	_ne
	inx
	decb
	bne	_nxtchr
	lds	tmp3
	clra
	rts
_ne
	lds	tmp3
	rts
_frts
	tpa
	ldx	1,x
	jsr	strrel
	ldx	tmp2
	jsr	strrel
	tap
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

	.module	mdtobc
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

add_fr1_fr1_fr2			; numCalls = 1
	.module	modadd_fr1_fr1_fr2
	jsr	noargs
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

add_fr1_fr1_ix			; numCalls = 1
	.module	modadd_fr1_fr1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_fx_fx_ir1			; numCalls = 1
	.module	modadd_fx_fx_ir1
	jsr	extend
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ip_ip_ir1			; numCalls = 1
	.module	modadd_ip_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ir1_ir1_ir2			; numCalls = 10
	.module	modadd_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 1
	.module	modadd_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 10
	.module	modadd_ir1_ir1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 1
	.module	modadd_ir1_ix_id
	jsr	extdex
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

add_ir2_ir2_pb			; numCalls = 3
	.module	modadd_ir2_ir2_pb
	jsr	getbyte
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_ir2_ix_id			; numCalls = 1
	.module	modadd_ir2_ix_id
	jsr	extdex
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
	jsr	extend
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 4
	.module	modadd_ix_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 22
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

and_ir2_ir2_ir3			; numCalls = 1
	.module	modand_ir2_ir2_ir3
	jsr	noargs
	ldd	r3+1
	andb	r2+2
	anda	r2+1
	std	r2+1
	ldab	r3
	andb	r2
	stab	r2
	rts

and_ir2_ir2_nb			; numCalls = 1
	.module	modand_ir2_ir2_nb
	jsr	getbyte
	andb	r2+2
	stab	r2+2
	rts

arrdim1_ir1_ix			; numCalls = 2
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

arrdim3_ir1_ix			; numCalls = 2
	.module	modarrdim3_ir1_ix
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
	std	tmp1
	ldd	r3+1
	addd	#1
	std	6,x
	std	tmp2
	jsr	mul12
	std	tmp3
	lsld
	addd	tmp3
	jmp	alloc

arrdim3_ir1_sx			; numCalls = 1
	.module	modarrdim3_ir1_sx
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
	std	tmp1
	ldd	r3+1
	addd	#1
	std	6,x
	std	tmp2
	jsr	mul12
	std	tmp3
	lsld
	addd	tmp3
	jmp	alloc

arrref1_ir1_ix			; numCalls = 147
	.module	modarrref1_ir1_ix
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx			; numCalls = 15
	.module	modarrref1_ir1_sx
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref3_ir1_ix			; numCalls = 26
	.module	modarrref3_ir1_ix
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	std	letptr
	rts

arrref3_ir1_sx			; numCalls = 14
	.module	modarrref3_ir1_sx
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 176
	.module	modarrval1_ir1_ix
	jsr	extend
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

arrval1_ir1_sx			; numCalls = 2
	.module	modarrval1_ir1_sx
	jsr	extend
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

arrval1_ir2_ix			; numCalls = 39
	.module	modarrval1_ir2_ix
	jsr	extend
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

arrval1_ir2_sx			; numCalls = 1
	.module	modarrval1_ir2_sx
	jsr	extend
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

arrval1_ir3_ix			; numCalls = 16
	.module	modarrval1_ir3_ix
	jsr	extend
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

arrval3_ir1_ix			; numCalls = 14
	.module	modarrval3_ir1_ix
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval3_ir1_sx			; numCalls = 14
	.module	modarrval3_ir1_sx
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval3_ir2_ix			; numCalls = 6
	.module	modarrval3_ir2_ix
	jsr	extend
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
	ldd	r2+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval3_ir2_sx			; numCalls = 1
	.module	modarrval3_ir2_sx
	jsr	extend
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
	ldd	r2+1+10
	std	4+argv
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

chr_sr1_ir1			; numCalls = 1
	.module	modchr_sr1_ir1
	jsr	noargs
	ldd	#$0100+(charpage>>8)
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
	stx	DP_DATA
	rts

clr_ip			; numCalls = 2
	.module	modclr_ip
	jsr	noargs
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 31
	.module	modclr_ix
	jsr	extend
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 3
	.module	modcls
	jsr	noargs
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jsr	getbyte
	jmp	R_CLSN

dbl_ir1_ir1			; numCalls = 2
	.module	moddbl_ir1_ir1
	jsr	noargs
	ldx	#r1
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dbl_ir1_ix			; numCalls = 1
	.module	moddbl_ir1_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dbl_ir2_ix			; numCalls = 3
	.module	moddbl_ir2_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r2+1
	ldab	0,x
	rolb
	stab	r2
	rts

dec_fr1_fx			; numCalls = 3
	.module	moddec_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir1_ir1			; numCalls = 1
	.module	moddec_ir1_ir1
	jsr	noargs
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

for_fx_pb			; numCalls = 3
	.module	modfor_fx_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	clrb
	std	3,x
	rts

for_ix_pb			; numCalls = 2
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forone_fx			; numCalls = 24
	.module	modforone_fx
	jsr	extend
	stx	letptr
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

forone_ix			; numCalls = 37
	.module	modforone_ix
	jsr	extend
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 232
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

goto_ix			; numCalls = 104
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

hlf_fr1_fr1			; numCalls = 2
	.module	modhlf_fr1_fr1
	jsr	noargs
	ldx	#r1
	asr	0,x
	ror	1,x
	ror	2,x
	ror	3,x
	ror	4,x
	rts

hlf_fr1_ir1			; numCalls = 2
	.module	modhlf_fr1_ir1
	jsr	noargs
	asr	r1
	ror	r1+1
	ror	r1+2
	ldd	#0
	rora
	std	r1+3
	rts

idiv3_ir1_ir1			; numCalls = 2
	.module	modidiv3_ir1_ir1
	jsr	noargs
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	ldd	#$AA03
	jsr	idiv35
	ldd	tmp2
	std	r1+1
	ldab	tmp1+1
	stab	r1
	rts

idiv3_ir1_ix			; numCalls = 2
	.module	modidiv3_ir1_ix
	jsr	extend
	ldab	0,x
	stab	tmp1+1
	ldd	1,x
	std	tmp2
	ldd	#$AA03
	jsr	idiv35
	ldd	tmp2
	std	r1+1
	ldab	tmp1+1
	stab	r1
	rts

ignxtra			; numCalls = 4
	.module	modignxtra
	jsr	noargs
	ldx	inptptr
	ldaa	,x
	beq	_rts
	ldx	#R_EXTRA
	ldab	#15
	jmp	print
_rts
	rts

inc_fr1_fx			; numCalls = 3
	.module	modinc_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ip_ip			; numCalls = 1
	.module	modinc_ip_ip
	jsr	noargs
	ldx	letptr
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inc_ir1_ir1			; numCalls = 17
	.module	modinc_ir1_ir1
	jsr	noargs
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 9
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ix_ix			; numCalls = 3
	.module	modinc_ix_ix
	jsr	extend
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sr1			; numCalls = 1
	.module	modinkey_sr1
	jsr	noargs
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

inkey_sx			; numCalls = 9
	.module	modinkey_sx
	jsr	extend
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

input			; numCalls = 4
	.module	modinput
	jsr	noargs
	ldx	curinst
	stx	redoptr
	jmp	inputqs

irnd_ir1_pb			; numCalls = 2
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

jmpeq_fr1_ix			; numCalls = 1
	.module	modjmpeq_fr1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	ldd	r1+3
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpeq_ir1_ix			; numCalls = 98
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 45
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

ld_fd_fx			; numCalls = 1
	.module	modld_fd_fx
	jsr	dexext
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

ld_fr1_fx			; numCalls = 37
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fr2_fx			; numCalls = 48
	.module	modld_fr2_fx
	jsr	extend
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fr3_fx			; numCalls = 17
	.module	modld_fr3_fx
	jsr	extend
	ldd	3,x
	std	r3+3
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_fx_fr1			; numCalls = 1
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_id_ix			; numCalls = 12
	.module	modld_id_ix
	jsr	dexext
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	ldx	tmp1
	std	1,x
	ldab	0+argv
	stab	0,x
	rts

ld_ip_ir1			; numCalls = 131
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 21
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 83
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 354
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir1_pw			; numCalls = 1
	.module	modld_ir1_pw
	jsr	getword
	std	r1+1
	ldab	#0
	stab	r1
	rts

ld_ir2_ix			; numCalls = 19
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 52
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 19
	.module	modld_ir3_ix
	jsr	extend
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ir3_pb			; numCalls = 56
	.module	modld_ir3_pb
	jsr	getbyte
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ir4_ix			; numCalls = 4
	.module	modld_ir4_ix
	jsr	extend
	ldd	1,x
	std	r4+1
	ldab	0,x
	stab	r4
	rts

ld_ir4_pb			; numCalls = 3
	.module	modld_ir4_pb
	jsr	getbyte
	stab	r4+2
	ldd	#0
	std	r4
	rts

ld_ix_ir1			; numCalls = 20
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 215
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 5
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 22
	.module	modld_sp_sr1
	jsr	noargs
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 9
	.module	modld_sr1_ss
	ldx	curinst
	inx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	stx	nxtinst
	rts

ld_sr1_sx			; numCalls = 29
	.module	modld_sr1_sx
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 1
	.module	modld_sx_sr1
	jsr	extend
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_fr1_pb			; numCalls = 7
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

ldeq_ir1_ir1_fx			; numCalls = 1
	.module	modldeq_ir1_ir1_fx
	jsr	extend
	ldd	3,x
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

ldeq_ir1_ir1_ir2			; numCalls = 3
	.module	modldeq_ir1_ir1_ir2
	jsr	noargs
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

ldeq_ir1_ir1_ix			; numCalls = 11
	.module	modldeq_ir1_ir1_ix
	jsr	extend
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

ldeq_ir1_ir1_nb			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 73
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

ldeq_ir1_ix_id			; numCalls = 1
	.module	modldeq_ir1_ix_id
	jsr	extdex
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

ldeq_ir1_sr1_sr2			; numCalls = 2
	.module	modldeq_ir1_sr1_sr2
	jsr	noargs
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	ldx	#r2
	jsr	streqx
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sr1_ss			; numCalls = 29
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

ldeq_ir2_fr2_pb			; numCalls = 2
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

ldeq_ir2_ir2_ir3			; numCalls = 1
	.module	modldeq_ir2_ir2_ir3
	jsr	noargs
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

ldeq_ir2_ir2_ix			; numCalls = 3
	.module	modldeq_ir2_ir2_ix
	jsr	extend
	ldd	r2+1
	subd	1,x
	bne	_done
	ldab	r2
	cmpb	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_ir2_pb			; numCalls = 29
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

ldeq_ir3_ir3_pb			; numCalls = 10
	.module	modldeq_ir3_ir3_pb
	jsr	getbyte
	cmpb	r3+2
	bne	_done
	ldd	r3
_done
	jsr	geteq
	std	r3+1
	stab	r3
	rts

ldlt_ir1_ir1_fx			; numCalls = 1
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

ldlt_ir1_ir1_ir2			; numCalls = 3
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

ldlt_ir1_ir1_ix			; numCalls = 2
	.module	modldlt_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_ir2_pb			; numCalls = 1
	.module	modldlt_ir2_ir2_pb
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

ldne_ir1_ir1_fx			; numCalls = 1
	.module	modldne_ir1_ir1_fx
	jsr	extend
	ldd	3,x
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

ldne_ir1_ir1_pb			; numCalls = 3
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

ldne_ir1_sr1_ss			; numCalls = 1
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

mul3_ir1_ir1			; numCalls = 2
	.module	modmul3_ir1_ir1
	jsr	noargs
	ldx	#r1
	jmp	mul3i

mul3_ir1_ix			; numCalls = 2
	.module	modmul3_ir1_ix
	jsr	extend
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

mul_fr1_ir1_fx			; numCalls = 1
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

mul_fr2_ir2_fx			; numCalls = 1
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

mul_ir1_ir1_ix			; numCalls = 1
	.module	modmul_ir1_ir1_ix
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir2_ir2_ix			; numCalls = 1
	.module	modmul_ir2_ir2_ix
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r2
	jmp	mulintx

neg_ix_ix			; numCalls = 3
	.module	modneg_ix_ix
	jsr	extend
	jmp	negxi

next			; numCalls = 66
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
	stx	nxtinst
	jmp	mainloop
_iopp
	ldd	6,x
	subd	r1+1
	ldab	5,x
	sbcb	r1
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop
_done
	ldab	0,x
	abx
	txs
	jmp	mainloop
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
	blt	_done
	ldx	3,x
	stx	nxtinst
	jmp	mainloop

nextvar_fx			; numCalls = 27
	.module	modnextvar_fx
	jsr	extend
	stx	letptr
	pulx
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
	jmp	mainloop

nextvar_ix			; numCalls = 39
	.module	modnextvar_ix
	jsr	extend
	stx	letptr
	pulx
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
	jmp	mainloop

one_fx			; numCalls = 1
	.module	modone_fx
	jsr	extend
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

one_ip			; numCalls = 15
	.module	modone_ip
	jsr	noargs
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 33
	.module	modone_ix
	jsr	extend
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongosub_ir1_is			; numCalls = 5
	.module	modongosub_ir1_is
	pulx
	ldx	curinst
	inx
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
	stx	nxtinst
	jmp	mainloop
_fail
	ldab	,x
	abx
	abx
	inx
	stx	nxtinst
	jmp	mainloop

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

or_ir2_ir2_ir3			; numCalls = 9
	.module	modor_ir2_ir2_ir3
	jsr	noargs
	ldd	r3+1
	orab	r2+2
	oraa	r2+1
	std	r2+1
	ldab	r3
	orab	r2
	stab	r2
	rts

peek_ir1_pw			; numCalls = 1
	.module	modpeek_ir1_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_pw			; numCalls = 1
	.module	modpeek_ir2_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_pw_ir1			; numCalls = 1
	.module	modpoke_pw_ir1
	jsr	getword
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 8
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

pr_ss			; numCalls = 63
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

pr_sx			; numCalls = 6
	.module	modpr_sx
	jsr	extend
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 2
	.module	modprat_ir1
	jsr	noargs
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 13
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 17
	.module	modprat_pw
	jsr	getword
	jmp	prat

progbegin			; numCalls = 1
	.module	modprogbegin
	jsr	noargs
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
OV_ERROR	.equ	10
OM_ERROR	.equ	12
BS_ERROR	.equ	16
DD_ERROR	.equ	18
LS_ERROR	.equ	28
error
	jmp	R_ERROR

prtab_pb			; numCalls = 1
	.module	modprtab_pb
	jsr	getbyte
	jmp	prtab

read_fx			; numCalls = 2
	.module	modread_fx
	jsr	extend
	jsr	rpubyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts

read_ix			; numCalls = 4
	.module	modread_ix
	jsr	extend
	jsr	rpubyte
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

readbuf_fx			; numCalls = 3
	.module	modreadbuf_fx
	jsr	extend
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
	stx	nxtinst
_rts
	rts

readbuf_sp			; numCalls = 7
	.module	modreadbuf_sp
	jsr	noargs
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
	stx	nxtinst
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

readbuf_sx			; numCalls = 1
	.module	modreadbuf_sx
	jsr	extend
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
	stx	nxtinst
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

restore			; numCalls = 1
	.module	modrestore
	jsr	noargs
	ldx	#startdata
	stx	DP_DATA
	rts

return			; numCalls = 35
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

rsub_fx_fx_pb			; numCalls = 1
	.module	modrsub_fx_fx_pb
	jsr	extbyte
	stab	tmp1
	ldd	#0
	subd	3,x
	std	3,x
	ldab	tmp1
	sbcb	2,x
	stab	2,x
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	0,x
	rts

rsub_ir1_ir1_ix			; numCalls = 1
	.module	modrsub_ir1_ir1_ix
	jsr	extend
	ldd	1,x
	subd	r1+1
	std	r1+1
	ldab	0,x
	sbcb	r1
	stab	r1
	rts

rsub_ir1_ir1_pb			; numCalls = 1
	.module	modrsub_ir1_ir1_pb
	jsr	getbyte
	clra
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

rsub_ix_ix_pb			; numCalls = 6
	.module	modrsub_ix_ix_pb
	jsr	extbyte
	clra
	subd	1,x
	std	1,x
	ldab	#0
	sbcb	0,x
	stab	0,x
	rts

step_fp_ir1			; numCalls = 4
	.module	modstep_fp_ir1
	jsr	noargs
	tsx
	ldab	r1
	stab	12,x
	ldd	r1+1
	std	13,x
	ldd	#0
	std	15,x
	ldd	nxtinst
	std	5,x
	rts

step_ip_ir1			; numCalls = 1
	.module	modstep_ip_ir1
	jsr	noargs
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
	ldd	nxtinst
	std	5,x
	rts

stop			; numCalls = 1
	.module	modstop
	jsr	noargs
	ldx	#R_BKMSG-1
	jmp	R_BREAK

str_sr1_fx			; numCalls = 4
	.module	modstr_sr1_fx
	jsr	extend
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

str_sr1_ix			; numCalls = 2
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

strcat_sr1_sr1_sx			; numCalls = 1
	.module	modstrcat_sr1_sr1_sx
	jsr	extend
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

strinit_sr1_sx			; numCalls = 1
	.module	modstrinit_sr1_sx
	jsr	extend
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

sub_fr2_pb_fx			; numCalls = 2
	.module	modsub_fr2_pb_fx
	jsr	byteext
	stab	tmp1
	ldd	#0
	subd	3,x
	std	r2+3
	ldab	tmp1
	sbcb	2,x
	stab	r2+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r2
	rts

sub_fr3_pb_fx			; numCalls = 2
	.module	modsub_fr3_pb_fx
	jsr	byteext
	stab	tmp1
	ldd	#0
	subd	3,x
	std	r3+3
	ldab	tmp1
	sbcb	2,x
	stab	r3+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r3
	rts

sub_ip_ip_pb			; numCalls = 2
	.module	modsub_ip_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

sub_ir1_ir1_ir2			; numCalls = 6
	.module	modsub_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
	stab	r1
	rts

sub_ir1_ir1_ix			; numCalls = 2
	.module	modsub_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir1_ir1_pb			; numCalls = 1
	.module	modsub_ir1_ir1_pb
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

sub_ir1_pb_ix			; numCalls = 3
	.module	modsub_ir1_pb_ix
	jsr	byteext
	subb	2,x
	stab	r1+2
	ldd	#0
	sbcb	1,x
	sbca	0,x
	std	r1
	rts

sub_ir2_ir2_ir3			; numCalls = 5
	.module	modsub_ir2_ir2_ir3
	jsr	noargs
	ldd	r2+1
	subd	r3+1
	std	r2+1
	ldab	r2
	sbcb	r3
	stab	r2
	rts

to_fp_ix			; numCalls = 1
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

to_fp_pb			; numCalls = 26
	.module	modto_fp_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_ix			; numCalls = 5
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

to_ip_pb			; numCalls = 34
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
	.byte	1, 1, 1, 5, 3, 3
	.byte	4, 1, 3, 1, 3, 1
	.byte	4, 3, 3, 2, 1, 1
	.byte	1, 3, 3, 2, 1, 3
	.byte	3, 1, 1, 1, 1, 3
	.byte	3, 3, 1, 5, 3, 1
	.byte	6, 3, 3, 4, 1, 1
	.byte	5, 1, 3, 6, 1, 3
	.byte	2, 3, 1, 4, 3, 1
	.byte	6, 1, 1, 3, 1, 3
	.byte	2, 3, 3, 6, 3, 1
	.byte	5, 1, 1, 3, 3, 3
	.byte	1, 1, 2, 4, 3, 2
	.byte	1, 2, 3, 2, 2, 1
	.byte	1, 3, 2, 3, 1, 2
	.byte	1, 2, 1, 5, 2, 3
	.byte	5, 3, 2, 4, 2, 1
	.byte	2, 1, 2, 4, 2, 3
	.byte	2, 3, 2, 3, 2, 1
	.byte	5, 1, 2, 3, 2, 3
	.byte	6, 3, 2, 4, 1, 2
	.byte	6, 2, 1, 2, 2, 3
	.byte	6, 1, 2, 3, 3, 2
	.byte	6, 2, 3, 5, 2, 1
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_B	.equ	0
bytecode_INTVAR_B1	.equ	1
bytecode_INTVAR_B2	.equ	2
bytecode_INTVAR_B3	.equ	3
bytecode_INTVAR_BM	.equ	4
bytecode_INTVAR_BP	.equ	5
bytecode_INTVAR_C	.equ	6
bytecode_INTVAR_D	.equ	7
bytecode_INTVAR_E	.equ	8
bytecode_INTVAR_F	.equ	9
bytecode_INTVAR_G	.equ	10
bytecode_INTVAR_H	.equ	11
bytecode_INTVAR_H1	.equ	12
bytecode_INTVAR_I	.equ	13
bytecode_INTVAR_J	.equ	14
bytecode_INTVAR_J1	.equ	15
bytecode_INTVAR_J2	.equ	16
bytecode_INTVAR_J3	.equ	17
bytecode_INTVAR_L	.equ	18
bytecode_INTVAR_M	.equ	19
bytecode_INTVAR_M4	.equ	20
bytecode_INTVAR_M5	.equ	21
bytecode_INTVAR_NA	.equ	22
bytecode_INTVAR_Q	.equ	23
bytecode_INTVAR_QA	.equ	24
bytecode_INTVAR_Y	.equ	25
bytecode_INTVAR_Z	.equ	26
bytecode_FLTVAR_K	.equ	27
bytecode_FLTVAR_M1	.equ	28
bytecode_FLTVAR_M2	.equ	29
bytecode_FLTVAR_M3	.equ	30
bytecode_FLTVAR_X	.equ	31
bytecode_STRVAR_A	.equ	32
bytecode_STRVAR_B	.equ	33
bytecode_STRVAR_CC	.equ	34
bytecode_INTARR_BL	.equ	35
bytecode_INTARR_C1	.equ	36
bytecode_INTARR_M	.equ	37
bytecode_INTARR_Q1	.equ	38
bytecode_INTARR_Q3	.equ	39
bytecode_INTARR_QQ	.equ	40
bytecode_STRARR_A	.equ	41
bytecode_STRARR_A1	.equ	42
bytecode_STRARR_A2	.equ	43

symtbl

	.word	INTVAR_B
	.word	INTVAR_B1
	.word	INTVAR_B2
	.word	INTVAR_B3
	.word	INTVAR_BM
	.word	INTVAR_BP
	.word	INTVAR_C
	.word	INTVAR_D
	.word	INTVAR_E
	.word	INTVAR_F
	.word	INTVAR_G
	.word	INTVAR_H
	.word	INTVAR_H1
	.word	INTVAR_I
	.word	INTVAR_J
	.word	INTVAR_J1
	.word	INTVAR_J2
	.word	INTVAR_J3
	.word	INTVAR_L
	.word	INTVAR_M
	.word	INTVAR_M4
	.word	INTVAR_M5
	.word	INTVAR_NA
	.word	INTVAR_Q
	.word	INTVAR_QA
	.word	INTVAR_Y
	.word	INTVAR_Z
	.word	FLTVAR_K
	.word	FLTVAR_M1
	.word	FLTVAR_M2
	.word	FLTVAR_M3
	.word	FLTVAR_X
	.word	STRVAR_A
	.word	STRVAR_B
	.word	STRVAR_CC
	.word	INTARR_BL
	.word	INTARR_C1
	.word	INTARR_M
	.word	INTARR_Q1
	.word	INTARR_Q3
	.word	INTARR_QQ
	.word	STRARR_A
	.word	STRARR_A1
	.word	STRARR_A2


; block started by symbol
bss

; Numeric Variables
INTVAR_B	.block	3
INTVAR_B1	.block	3
INTVAR_B2	.block	3
INTVAR_B3	.block	3
INTVAR_BM	.block	3
INTVAR_BP	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_H1	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_J1	.block	3
INTVAR_J2	.block	3
INTVAR_J3	.block	3
INTVAR_L	.block	3
INTVAR_M	.block	3
INTVAR_M4	.block	3
INTVAR_M5	.block	3
INTVAR_NA	.block	3
INTVAR_Q	.block	3
INTVAR_QA	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
FLTVAR_K	.block	5
FLTVAR_M1	.block	5
FLTVAR_M2	.block	5
FLTVAR_M3	.block	5
FLTVAR_X	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
STRVAR_CC	.block	3
; Numeric Arrays
INTARR_BL	.block	4	; dims=1
INTARR_C1	.block	4	; dims=1
INTARR_M	.block	4	; dims=1
INTARR_Q1	.block	4	; dims=1
INTARR_Q3	.block	8	; dims=3
INTARR_QQ	.block	8	; dims=3
; String Arrays
STRARR_A	.block	4	; dims=1
STRARR_A1	.block	8	; dims=3
STRARR_A2	.block	4	; dims=1

; block ended by symbol
bes
	.end

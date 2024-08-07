; Assembly for mahjong.bas
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

LINE_0

	; CLEAR 1200

	.byte	bytecode_clear

	; POKE 49151,64

	.byte	bytecode_ld_ir1_pb
	.byte	64

	.byte	bytecode_poke_pw_ir1
	.word	49151

	; GOTO 900

	.byte	bytecode_goto_ix
	.word	LINE_900

LINE_1

	; ON ABS(L(X,Y,Z)) GOTO 2,3,4,5

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_abs_ir1_ir1

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_2, LINE_3, LINE_4, LINE_5

	; STOP

	.byte	bytecode_stop

LINE_2

	; L(13,5,1)+=N

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ip_ip_ir1

	; RETURN

	.byte	bytecode_return

LINE_3

	; L(2,5,1)+=N

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ip_ip_ir1

	; RETURN

	.byte	bytecode_return

LINE_4

	; L(8,4,4)+=SHIFT(N,1)

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	4

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ip_ip_ir1

	; L(7,5,4)+=SHIFT(N,1)

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_ld_ir3_pb
	.byte	4

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ip_ip_ir1

	; L(8,5,4)+=SHIFT(N,1)

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_ld_ir3_pb
	.byte	4

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ip_ip_ir1

	; RETURN

	.byte	bytecode_return

LINE_5

	; L(14,4,1)+=N*3

	.byte	bytecode_ld_ir1_pb
	.byte	14

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_mul3_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ip_ip_ir1

	; RETURN

	.byte	bytecode_return

LINE_6

	; C=SHIFT(X-1,1)+SHIFT(Y-1,6)

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir2_ir2_pb
	.byte	6

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_C

	; IF Z<2 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_7

	; IF Y=4 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_7

	; IF (X>13) OR (X<2) THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	13
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ldlt_ir2_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_7

	; C+=32

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	32

	; GOTO 8

	.byte	bytecode_goto_ix
	.word	LINE_8

LINE_7

	; IF X=7 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	7

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_8

	; IF Y=4 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_8

	; IF (Z=5) OR (Z=0) THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	5

	.byte	bytecode_ldeq_ir2_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	0

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_8

	; IF L(X,Y,0)=5 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_8

	; C+=33

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	33

LINE_8

	; PRINT @C, MID$(A$(Z),A,2);

	.byte	bytecode_prat_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_A
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	2

	.byte	bytecode_pr_sr1

	; PRINT @C+32, MID$(B$(Z),A,2);

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	32

	.byte	bytecode_prat_ir1

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_B
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	2

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_9

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; RETURN

	.byte	bytecode_return

LINE_10

	; Q=X

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Q
	.byte	bytecode_INTVAR_X

	; R=Y

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_R
	.byte	bytecode_INTVAR_Y

	; IF I THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_11

	; Z=L(X,Y,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; X=I

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_I

	; Y=J

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_J

	; Z=L(X,Y,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; A=SHIFT(L(X,Y,6)-1,1)+1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; J=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_J

	; X=Q

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_Q

	; Y=R

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_R

LINE_11

	; RETURN

	.byte	bytecode_return

LINE_12

	; T=36

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	36

	; NEXT

	.byte	bytecode_next

	; S=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_S
	.byte	2

	; NEXT

	.byte	bytecode_next

	; FF+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_FF

	; PRINT @32, "FAILURES:\r";

	.byte	bytecode_prat_pb
	.byte	32

	.byte	bytecode_pr_ss
	.text	10, "FAILURES:\r"

	; PRINT @58, STR$(FF);" ";

	.byte	bytecode_prat_pb
	.byte	58

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_FF

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; GOTO 3000

	.byte	bytecode_goto_ix
	.word	LINE_3000

LINE_20

	; CLS

	.byte	bytecode_cls

	; PRINT "YOUR TURTLE APPROACHES...\r";

	.byte	bytecode_pr_ss
	.text	26, "YOUR TURTLE APPROACHES...\r"

	; PRINT @172, "MAHJONG\r";

	.byte	bytecode_prat_pb
	.byte	172

	.byte	bytecode_pr_ss
	.text	8, "MAHJONG\r"

	; PRINT @228, "BY CHARLIE & JIM GERRIE\r";

	.byte	bytecode_prat_pb
	.byte	228

	.byte	bytecode_pr_ss
	.text	24, "BY CHARLIE & JIM GERRIE\r"

LINE_21

	; PRINT @258, "USING GREG DIONNE'S MCBASIC\r";

	.byte	bytecode_prat_pw
	.word	258

	.byte	bytecode_pr_ss
	.text	28, "USING GREG DIONNE'S MCBASIC\r"

	; GOSUB 5500

	.byte	bytecode_gosub_ix
	.word	LINE_5500

LINE_25

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

	; FOR S=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_to_ip_pb
	.byte	2

	; FOR T=1 TO 36

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	36

	; PRINT @26, STR$(P-C);" \r";

	.byte	bytecode_prat_pb
	.byte	26

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_P
	.byte	bytecode_INTVAR_C

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

LINE_30

	; I=INT(RND(P))

	.byte	bytecode_rnd_fr1_ix
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_I

	; WHEN L(X(I),Y(I),Z(I))>2 GOTO 30

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_Z
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_30

LINE_50

	; FOR A=1 TO 500

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_to_ip_pw
	.word	500

	; J=INT(RND(P))

	.byte	bytecode_rnd_fr1_ix
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; IF L(X(J),Y(J),Z(J))>2 THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_Z
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_60

	; NEXT

	.byte	bytecode_next

	; GOTO 12

	.byte	bytecode_goto_ix
	.word	LINE_12

LINE_60

	; IF I=J THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_I
	.byte	bytecode_INTVAR_J

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_70

	; NEXT

	.byte	bytecode_next

	; GOTO 12

	.byte	bytecode_goto_ix
	.word	LINE_12

LINE_70

	; A=500

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_A
	.word	500

	; NEXT

	.byte	bytecode_next

	; P(C)=I

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ip_ir1

	; T(C)=T

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_ir1

	; C+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_C

	; P(C)=J

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ip_ir1

	; T(C)=T

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_ir1

	; C+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_C

LINE_71

	; X=X(I)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(I)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(I)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_Z
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; L(X-1,Y,Z)-=1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_dec_ip_ip

	; L(X+1,Y,Z)-=1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_dec_ip_ip

	; L(X,Y,Z-1)-=2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_sub_ip_ip_pb
	.byte	2

	; WHEN L(X,Y,Z)<0 GOSUB 1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_1

LINE_72

	; P$(Z,Y)=LEFT$(P$(Z,Y),X-1)+CHR$(T)+MID$(P$(Z,Y),X+1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_left_sr1_sr1_ir2

	.byte	bytecode_strinit_sr1_sr1

	.byte	bytecode_chr_sr2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir2_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_inc_ir3_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_mid_sr2_sr2_ir3

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sp_sr1

	; L(X,Y,Z)=9

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_pb
	.byte	9

LINE_73

	; X=X(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_Z
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; L(X-1,Y,Z)-=1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_dec_ip_ip

	; L(X+1,Y,Z)-=1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_dec_ip_ip

	; L(X,Y,Z-1)-=2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_sub_ip_ip_pb
	.byte	2

	; WHEN L(X,Y,Z)<0 GOSUB 1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_1

LINE_74

	; P$(Z,Y)=LEFT$(P$(Z,Y),X-1)+CHR$(T)+MID$(P$(Z,Y),X+1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_left_sr1_sr1_ir2

	.byte	bytecode_strinit_sr1_sr1

	.byte	bytecode_chr_sr2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir2_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_inc_ir3_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_mid_sr2_sr2_ir3

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sp_sr1

	; L(X,Y,Z)=9

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_pb
	.byte	9

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_75

	; PRINT @26, "\r";

	.byte	bytecode_prat_pb
	.byte	26

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; PRINT "JUST A LITTLE LONGER...\r";

	.byte	bytecode_pr_ss
	.text	24, "JUST A LITTLE LONGER...\r"

	; GOSUB 3100

	.byte	bytecode_gosub_ix
	.word	LINE_3100

	; GOSUB 89

	.byte	bytecode_gosub_ix
	.word	LINE_89

	; GOTO 100

	.byte	bytecode_goto_ix
	.word	LINE_100

LINE_80

	; K=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_K

	; M$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_M

	; IF M$<>"" THEN

	.byte	bytecode_ldne_ir1_sx_ss
	.byte	bytecode_STRVAR_M
	.text	0, ""

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_81

	; K=ASC(M$)

	.byte	bytecode_asc_ir1_sx
	.byte	bytecode_STRVAR_M

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

LINE_81

	; RETURN

	.byte	bytecode_return

LINE_84

	; IF Y<1 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_85

	; Y=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	8

LINE_85

	; IF X<1 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_86

	; X=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	15

LINE_86

	; IF X>15 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	15
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_87

	; X=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_X

LINE_87

	; IF Y>8 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	8
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_88

	; Y=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_Y

LINE_88

	; GOTO 130

	.byte	bytecode_goto_ix
	.word	LINE_130

LINE_89

	; CLS

	.byte	bytecode_cls

	; C=53

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	53

	; FOR T=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	5

	; POKE SHIFT(T+10,5)+MC+1,C+64

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	10

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	64

	.byte	bytecode_poke_ir1_ir2

	; PRINT @SHIFT(T+10,5), MID$("�����",T,1);

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	10

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_sr1_ss
	.text	5, "\x9F\xFF\xEF\xDF\xCF"

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_pr_sr1

	; C-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_C

	; NEXT

	.byte	bytecode_next

LINE_90

	; FOR T=1 TO P

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_P

	; X=X(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; A=SHIFT(T(T)-1,1)+1

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; WHEN L(X,Y,0)=Z GOSUB 6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_6

LINE_95

	; NEXT

	.byte	bytecode_next

	; FOR Z=4 TO 5

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	4

	.byte	bytecode_to_ip_pb
	.byte	5

	; X=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	7

	; Y=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	; T=ASC(MID$(P$(Z,Y),X,1))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_asc_ir1_sr1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; A=SHIFT(T-1,1)+1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; WHEN L(X,Y,0)=5 GOSUB 6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_6

LINE_96

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_100

	; X=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	7

	; Y=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_Y

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; J=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_J

	; L(0,7,2)=P

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ip_ir1

	; L(0,0,5)=0

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_ir3_pb
	.byte	5

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_clr_ip

	; L(0,5,2)+=1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_inc_ip_ip

LINE_110

	; GOSUB 880

	.byte	bytecode_gosub_ix
	.word	LINE_880

	; GOSUB 580

	.byte	bytecode_gosub_ix
	.word	LINE_580

LINE_130

	; Z=L(X,Y,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; IF Z=4 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_131

	; IF L(7,4,0)=5 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_131

	; X=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	7

	; Y=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	; GOTO 130

	.byte	bytecode_goto_ix
	.word	LINE_130

LINE_131

	; IF (X<2) OR (X>13) THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_ldlt_ir2_pb_ix
	.byte	13
	.byte	bytecode_INTVAR_X

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_132

	; IF Y<>4 THEN

	.byte	bytecode_ldne_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_132

	; Y=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	; GOTO 130

	.byte	bytecode_goto_ix
	.word	LINE_130

LINE_132

	; IF X=I THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_I

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_133

	; IF Y=J THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_J

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_133

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

LINE_133

	; A=SHIFT(L(X,Y,6)-1,1)+1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_135

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; FOR T=1 TO 150

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	150

	; GOSUB 80

	.byte	bytecode_gosub_ix
	.word	LINE_80

	; IF K THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_140

	; T=999

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_T
	.word	999

LINE_140

	; NEXT

	.byte	bytecode_next

	; PRINT @C, "��";

	.byte	bytecode_prat_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_pr_ss
	.text	2, "\xBF\xBF"

	; PRINT @C+32, "��";

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	32

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	2, "\xBF\xBF"

	; IF K THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_150

	; FOR T=1 TO 100

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	100

	; NEXT

	.byte	bytecode_next

	; GOTO 160

	.byte	bytecode_goto_ix
	.word	LINE_160

LINE_150

	; FOR T=1 TO 70

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	70

	; GOSUB 80

	.byte	bytecode_gosub_ix
	.word	LINE_80

	; IF K THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_151

	; T=999

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_T
	.word	999

LINE_151

	; NEXT

	.byte	bytecode_next

	; WHEN K=0 GOTO 135

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_135

LINE_160

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

LINE_161

	; IF K=65 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	65

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_162

	; X-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_X

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_162

	; IF K=68 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	68

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_163

	; WHEN L(X,Y,0)=5 GOSUB 178

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_178

	; X+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_X

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_163

	; IF K=87 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	87

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_164

	; Y-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_Y

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_164

	; IF K=83 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	83

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_165

	; WHEN L(X,Y,0)=5 GOSUB 179

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	5

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_179

	; Y+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_Y

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_165

	; WHEN K=32 GOTO 180

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	32

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_180

LINE_170

	; WHEN K=85 GOSUB 400

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	85

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_400

LINE_171

	; IF K=72 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	72

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_172

	; GOSUB 500

	.byte	bytecode_gosub_ix
	.word	LINE_500

	; WHEN K<>0 GOTO 130

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_130

	; GOSUB 585

	.byte	bytecode_gosub_ix
	.word	LINE_585

	; GOTO 230

	.byte	bytecode_goto_ix
	.word	LINE_230

LINE_172

	; IF K=82 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	82

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_177

	; GOSUB 700

	.byte	bytecode_gosub_ix
	.word	LINE_700

	; GOSUB 580

	.byte	bytecode_gosub_ix
	.word	LINE_580

	; IF I$="Y" THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "Y"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_177

	; GOSUB 585

	.byte	bytecode_gosub_ix
	.word	LINE_585

	; GOTO 230

	.byte	bytecode_goto_ix
	.word	LINE_230

LINE_177

	; GOTO 130

	.byte	bytecode_goto_ix
	.word	LINE_130

LINE_178

	; X+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_X

	; RETURN

	.byte	bytecode_return

LINE_179

	; Y+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_Y

	; RETURN

	.byte	bytecode_return

LINE_180

	; WHEN I GOTO 190

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_190

LINE_181

	; WHEN Z=0 GOTO 192

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_192

LINE_182

	; IF L(X,Y,Z)<3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_183

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; SOUND 200-L(0,7,2),1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; I=X

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_I
	.byte	bytecode_INTVAR_X

	; J=Y

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_J
	.byte	bytecode_INTVAR_Y

	; GOTO 130

	.byte	bytecode_goto_ix
	.word	LINE_130

LINE_183

	; GOTO 192

	.byte	bytecode_goto_ix
	.word	LINE_192

LINE_190

	; WHEN Z=0 GOTO 192

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_192

LINE_191

	; IF L(X,Y,Z)<3 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	3

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_192

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; WHEN L(X,Y,6)=L(I,J,6) GOTO 200

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ir3_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir4_pb
	.byte	6

	.byte	bytecode_arrval3_ir2_ix_ir4
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_200

LINE_192

	; GOSUB 10

	.byte	bytecode_gosub_ix
	.word	LINE_10

	; GOSUB 9

	.byte	bytecode_gosub_ix
	.word	LINE_9

	; GOTO 130

	.byte	bytecode_goto_ix
	.word	LINE_130

LINE_200

	; Q=X

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Q
	.byte	bytecode_INTVAR_X

	; R=Y

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_R
	.byte	bytecode_INTVAR_Y

	; X=I

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_I

	; Y=J

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_J

	; S=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_S
	.byte	5

	; GOSUB 270

	.byte	bytecode_gosub_ix
	.word	LINE_270

	; X=Q

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_Q

	; Y=R

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_R

	; S=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_S
	.byte	6

	; GOSUB 270

	.byte	bytecode_gosub_ix
	.word	LINE_270

LINE_210

	; X=Q

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_Q

	; Y=R

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_R

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; J=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_J

	; SOUND 200-L(0,7,2),1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; L(0,7,2)-=2

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_sub_ip_ip_pb
	.byte	2

	; GOSUB 880

	.byte	bytecode_gosub_ix
	.word	LINE_880

	; WHEN L(0,7,2)>0 GOTO 130

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	0

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_130

LINE_220

	; GOSUB 590

	.byte	bytecode_gosub_ix
	.word	LINE_590

LINE_230

	; GOSUB 710

	.byte	bytecode_gosub_ix
	.word	LINE_710

	; WHEN I$="Y" GOTO 2180

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "Y"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_2180

LINE_250

	; IF I$="N" THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "N"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_260

	; END

	.byte	bytecode_progend

LINE_260

	; GOTO 230

	.byte	bytecode_goto_ix
	.word	LINE_230

LINE_270

	; Z=L(X,Y,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; L(0,8,S)=L(X,Y,0)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_ir1

	; L(0,5,S)=L(X-1,Y,Z)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_ir1

	; L(0,6,S)=L(X+1,Y,Z)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_ir1

	; L(0,7,S)=L(X,Y,Z-1)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_ir1

LINE_271

	; L(X-1,Y,Z)-=1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_dec_ip_ip

	; L(X+1,Y,Z)-=1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_dec_ip_ip

	; L(X,Y,Z-1)-=2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_sub_ip_ip_pb
	.byte	2

	; WHEN L(X,Y,Z)<0 GOSUB 1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_1

LINE_272

	; L(0,4,S)=L(X,Y,Z)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_ir1

	; L(X,Y,Z)=9

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_pb
	.byte	9

	; L(0,0,S)=X

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ip_ir1

	; L(0,1,S)=Y

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; L(0,2,S)=Z

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_ir1

	; L(0,3,S)=L(X,Y,6)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_ir1

LINE_280

	; L(X,Y,0)-=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dec_ip_ip

	; IF L(X,Y,0)<1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_281

	; L(X,Y,0)=0

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_clr_ip

	; L(X,Y,6)=37

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	37

	; A=73

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	73

	; GOTO 282

	.byte	bytecode_goto_ix
	.word	LINE_282

LINE_281

	; Z=L(X,Y,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; T=ASC(MID$(P$(Z,Y),X,1))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_asc_ir1_sr1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; L(X,Y,6)=T

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_ir1

	; A=SHIFT(T-1,1)+1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_282

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; IF X=7 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	7

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_283

	; IF Y=4 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_283

	; WHEN Z=4 GOTO 289

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	4

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_289

LINE_283

	; RETURN

	.byte	bytecode_return

LINE_289

	; FOR Y=4 TO 5

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	.byte	bytecode_to_ip_pb
	.byte	5

	; FOR X=7 TO 8

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	7

	.byte	bytecode_to_ip_pb
	.byte	8

	; T=ASC(MID$(P$(Z,Y),X,1))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_asc_ir1_sr1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; A=SHIFT(T-1,1)+1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_290

	; FOR T=1 TO P

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_P

	; IF Z(P(T))=Z THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_291

	; IF Y(P(T))=Y THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_291

	; IF X(P(T))=X THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_291

	; K=T

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_K
	.byte	bytecode_INTVAR_T

	; T=P

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_T
	.byte	bytecode_INTVAR_P

LINE_291

	; NEXT

	.byte	bytecode_next

	; T=K

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_T
	.byte	bytecode_INTVAR_K

	; RETURN

	.byte	bytecode_return

LINE_400

	; GOSUB 10

	.byte	bytecode_gosub_ix
	.word	LINE_10

	; WHEN L(0,0,5)=0 GOTO 9

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_ir3_pb
	.byte	5

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_9

LINE_405

	; Q=X

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Q
	.byte	bytecode_INTVAR_X

	; R=Y

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_R
	.byte	bytecode_INTVAR_Y

	; N=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_N

	; FOR S=5 TO 6

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_S
	.byte	5

	.byte	bytecode_to_ip_pb
	.byte	6

	; X=L(0,0,S)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=L(0,1,S)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=L(0,2,S)

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; L(X,Y,6)=L(0,3,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ip_ir1

	; L(X,Y,Z)=L(0,4,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ip_ir1

	; WHEN L(X,Y,Z)<0 GOSUB 1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_1

LINE_410

	; L(X-1,Y,Z)=L(0,5,S)

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ip_ir1

	; L(X+1,Y,Z)=L(0,6,S)

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ip_ir1

	; L(X,Y,Z-1)=L(0,7,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir3_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ip_ir1

	; L(X,Y,0)=L(0,8,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ld_ip_ir1

LINE_430

	; A=SHIFT(L(X,Y,6)-1,1)+1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; NEXT

	.byte	bytecode_next

	; N=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_N

	; L(0,0,5)=0

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_ld_ir3_pb
	.byte	5

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_clr_ip

	; X=Q

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_Q

	; Y=R

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_R

	; L(0,7,2)+=2

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_add_ip_ip_pb
	.byte	2

	; GOTO 880

	.byte	bytecode_goto_ix
	.word	LINE_880

LINE_500

	; GOSUB 582

	.byte	bytecode_gosub_ix
	.word	LINE_582

	; GOSUB 10

	.byte	bytecode_gosub_ix
	.word	LINE_10

	; K=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_K

	; FOR S=1 TO P

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_P

	; X=X(P(S))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_S

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(S))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_S

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(P(S))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_S

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; IF L(X,Y,Z)>2 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_550

	; NEXT

	.byte	bytecode_next

	; GOTO 568

	.byte	bytecode_goto_ix
	.word	LINE_568

LINE_550

	; FOR T=1 TO P

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_P

	; X=X(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; IF L(X,Y,Z)>2 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_551

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 568

	.byte	bytecode_goto_ix
	.word	LINE_568

LINE_551

	; IF T=S THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_T
	.byte	bytecode_INTVAR_S

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_552

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 568

	.byte	bytecode_goto_ix
	.word	LINE_568

LINE_552

	; IF T(T)<>T(S) THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ldne_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_560

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 568

	.byte	bytecode_goto_ix
	.word	LINE_568

LINE_560

	; K+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_K

	; A=SHIFT(T(T)-1,1)+1

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; X=X(P(S))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_S

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(S))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_S

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; A=SHIFT(T(S)-1,1)+1

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_S

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; GOSUB 581

	.byte	bytecode_gosub_ix
	.word	LINE_581

LINE_565

	; Z=Z(P(S))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_S

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; A=SHIFT(T(S)-1,1)+1

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_S

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; X=X(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; A=SHIFT(T(T)-1,1)+1

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; WHEN I$="Y" GOTO 567

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "Y"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_567

LINE_566

	; T=P

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_T
	.byte	bytecode_INTVAR_P

	; S=P

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_S
	.byte	bytecode_INTVAR_P

LINE_567

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_568

	; X=Q

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_Q

	; Y=R

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_R

	; GOTO 580

	.byte	bytecode_goto_ix
	.word	LINE_580

LINE_577

	; PRINT @64, MID$(STR$(L(0,6,2)),2);"/";MID$(STR$(L(0,5,2)),2);

	.byte	bytecode_prat_pb
	.byte	64

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_mid_sr1_sr1_pb
	.byte	2

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, "/"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_mid_sr1_sr1_pb
	.byte	2

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_580

	; PRINT @86, "    h=HELP";

	.byte	bytecode_prat_pb
	.byte	86

	.byte	bytecode_pr_ss
	.text	10, "    h=HELP"

	; PRINT @118, "    u=UNDO";

	.byte	bytecode_prat_pb
	.byte	118

	.byte	bytecode_pr_ss
	.text	10, "    u=UNDO"

	; PRINT @152, "  r=QUIT";

	.byte	bytecode_prat_pb
	.byte	152

	.byte	bytecode_pr_ss
	.text	8, "  r=QUIT"

	; RETURN

	.byte	bytecode_return

LINE_581

	; PRINT @86, " CONTINUE?";

	.byte	bytecode_prat_pb
	.byte	86

	.byte	bytecode_pr_ss
	.text	10, " CONTINUE?"

	; PRINT @121, "(y/n)\r";

	.byte	bytecode_prat_pb
	.byte	121

	.byte	bytecode_pr_ss
	.text	6, "(y/n)\r"

	; GOSUB 710

	.byte	bytecode_gosub_ix
	.word	LINE_710

LINE_582

	; PRINT @86, " SEARCHING";

	.byte	bytecode_prat_pb
	.byte	86

	.byte	bytecode_pr_ss
	.text	10, " SEARCHING"

	; PRINT @118, "\r";

	.byte	bytecode_prat_pb
	.byte	118

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; GOTO 596

	.byte	bytecode_goto_ix
	.word	LINE_596

LINE_585

	; PRINT @86, "GAME OVER.";

	.byte	bytecode_prat_pb
	.byte	86

	.byte	bytecode_pr_ss
	.text	10, "GAME OVER."

	; GOTO 595

	.byte	bytecode_goto_ix
	.word	LINE_595

LINE_586

	; PRINT @86, "  ARE YOU\r";

	.byte	bytecode_prat_pb
	.byte	86

	.byte	bytecode_pr_ss
	.text	10, "  ARE YOU\r"

	; PRINT @118, "   SURE?\r";

	.byte	bytecode_prat_pb
	.byte	118

	.byte	bytecode_pr_ss
	.text	9, "   SURE?\r"

LINE_587

	; PRINT @153, "(y/n)\r";

	.byte	bytecode_prat_pb
	.byte	153

	.byte	bytecode_pr_ss
	.text	6, "(y/n)\r"

	; RETURN

	.byte	bytecode_return

LINE_590

	; PRINT @86, " YOU WON! ";

	.byte	bytecode_prat_pb
	.byte	86

	.byte	bytecode_pr_ss
	.text	10, " YOU WON! "

	; PRINT @118, "\r";

	.byte	bytecode_prat_pb
	.byte	118

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; GOSUB 596

	.byte	bytecode_gosub_ix
	.word	LINE_596

	; GOSUB 600

	.byte	bytecode_gosub_ix
	.word	LINE_600

	; FOR K=1 TO 15

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_to_ip_pb
	.byte	15

	; SOUND 171,1

	.byte	bytecode_ld_ir1_pb
	.byte	171

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

LINE_595

	; GOSUB 577

	.byte	bytecode_gosub_ix
	.word	LINE_577

	; PRINT @118, "TRY AGAIN?";

	.byte	bytecode_prat_pb
	.byte	118

	.byte	bytecode_pr_ss
	.text	10, "TRY AGAIN?"

	; GOTO 587

	.byte	bytecode_goto_ix
	.word	LINE_587

LINE_596

	; PRINT @152, "\r";

	.byte	bytecode_prat_pb
	.byte	152

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; RETURN

	.byte	bytecode_return

LINE_600

	; L(0,6,2)+=1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_inc_ip_ip

	; WHEN L(0,6,2)>2 GOTO 610

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_610

LINE_601

	; PRINT @160, "            ���������                      �����������                    �������������               ";

	.byte	bytecode_prat_pb
	.byte	160

	.byte	bytecode_pr_ss
	.text	102, "            \x8E\x88\x81\x83\x83\x80\x80\x84\x8D                      \x88\x87\x8F\x8F\x8F\x88\x80\x80\x83\x80\x84                    \x8A\x80\x8F\x8F\x8F\x8F\x82\x80\x80\x80\x80\x80\x85               "

LINE_602

	; PRINT "     �����������                      ���������\r";

	.byte	bytecode_pr_ss
	.text	48, "     \x82\x8D\x8F\x8C\x8F\x8F\x8A\x80\x80\x80\x81                      \x8B\x84\x8C\x8C\x88\x80\x80\x81\x87\r"

	; RETURN

	.byte	bytecode_return

LINE_610

	; PRINT @166, "�������������������\r";

	.byte	bytecode_prat_pb
	.byte	166

	.byte	bytecode_pr_ss
	.text	20, "\xCF\xCF\xCF\xCF\xCB\xCD\xCF\xCF\xCF\xCF\xCF\xCF\xCF\xCE\xCF\xCE\xC7\xCF\xCF\r"

	; PRINT @198, "�������������������\r";

	.byte	bytecode_prat_pb
	.byte	198

	.byte	bytecode_pr_ss
	.text	20, "\xCF\xCF\xCC\xCC\xC3\xC3\xC3\xC3\xCF\xCF\xCF\xCF\xC5\xCA\xCE\xC5\xC1\xCF\xCF\r"

	; PRINT @230, "�������������������\r";

	.byte	bytecode_prat_pb
	.byte	230

	.byte	bytecode_pr_ss
	.text	20, "\xCF\xCF\xC5\xCE\xCE\xCF\xCA\xCC\xCF\xCF\xCF\xCF\xC3\xC2\xCF\xC9\xCA\xCF\xCF\r"

LINE_620

	; PRINT @262, "�������������������\r";

	.byte	bytecode_prat_pw
	.word	262

	.byte	bytecode_pr_ss
	.text	20, "\xCF\xCE\xC7\xC2\xC7\xCB\xC2\xCD\xCF\xCF\xCF\xCF\xCE\xC8\xCE\xCC\xC8\xC3\xC7\r"

	; PRINT @294, "�������������������\r";

	.byte	bytecode_prat_pw
	.word	294

	.byte	bytecode_pr_ss
	.text	20, "\xCF\xCA\xCF\xC8\xC6\xCE\xC2\xCB\xCD\xCF\xCF\xC3\xC5\xCA\xCF\xC6\xCA\xCF\xCF\r"

	; PRINT @326, "�������������������\r";

	.byte	bytecode_prat_pw
	.word	326

	.byte	bytecode_pr_ss
	.text	20, "\xCF\xC5\xC9\xCA\xCF\xC7\xCA\xCF\xCB\xC7\xCF\xC9\xCF\xCA\xCF\xCF\xCA\xCF\xCF\r"

LINE_630

	; PRINT @358, "�������������������";

	.byte	bytecode_prat_pw
	.word	358

	.byte	bytecode_pr_ss
	.text	19, "\xCF\xC7\xCF\xCB\xCF\xCF\xCB\xCF\xCF\xCF\xCF\xCF\xCF\xC7\xCF\xCF\xC7\xCF\xCF"

	; RETURN

	.byte	bytecode_return

LINE_700

	; GOSUB 586

	.byte	bytecode_gosub_ix
	.word	LINE_586

LINE_710

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; IF (I$="Y") OR (I$="N") THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "Y"

	.byte	bytecode_ldeq_ir2_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "N"

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_730

	; RETURN

	.byte	bytecode_return

LINE_730

	; GOTO 710

	.byte	bytecode_goto_ix
	.word	LINE_710

LINE_880

	; PRINT @378, "TILES";

	.byte	bytecode_prat_pw
	.word	378

	.byte	bytecode_pr_ss
	.text	5, "TILES"

	; PRINT @410, STR$(L(0,7,2));" ";

	.byte	bytecode_prat_pw
	.word	410

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_ld_ir3_pb
	.byte	2

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; RETURN

	.byte	bytecode_return

LINE_900

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; DIM L(16,8,6),X(144),Y(144),Z(144),P(144),T(144),A$(5),B$(5),L$(5,8),T,I,J,X,Y,Z,S,A,C,K,P$(5,8),P,N,Q,R

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrdim3_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	144

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_pb
	.byte	144

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ir1_pb
	.byte	144

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ir1_pb
	.byte	144

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_ld_ir1_pb
	.byte	144

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_T

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrdim2_ir1_sx
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrdim2_ir1_sx
	.byte	bytecode_STRARR_P

LINE_910

	; EVAL RND(-TIMER)

	.byte	bytecode_timer_ir1

	.byte	bytecode_neg_ir1_ir1

	.byte	bytecode_rnd_fr1_ir1

	; P=144

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_P
	.byte	144

	; N=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_N

	; MC=16384

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_MC
	.word	16384

LINE_920

	; A$(0)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xA9\xAD\xA2\xAF\xA2\xAF\xA2\xAD\xA4\xAD\xAA\xA7\xA8\xA7\xA3\xA5\xA8\xA5\xAA\xA5\xA8\xAD\xA0\xAD\xA1\xA7\xA1\xAD\xA0\xA7\xA0\xA7\xA1\xAD\xA4\xA5\xA2\xA7\xAD\xA5\xA4\xA7\xA5\xAF\xA0\xA5\xA1\xAD\xA1\xA5\xA0\xA5\xA0\xA5\xA0\xAD\xAA\xA7\xA2\xA7\xA5\xA5\xA5\xA5\xA4\xA5\xA6\xA7\xA6\xA7\xA2\xAF  "

	.byte	bytecode_ld_sp_sr1

LINE_930

	; B$(0)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xAB\xAF\xAB\xAF\xAF\xA7\xA3\xAF\xAB\xAF\xA7\xAF\xA3\xAF\xAB\xAF\xA3\xAF\xA3\xAF\xA7\xA7\xA3\xA7\xA3\xA7\xA3\xAF\xA3\xA7\xA7\xAF\xA3\xA7\xA7\xA7\xA3\xA7\xA3\xA7\xA7\xA7\xA3\xA7\xA7\xA7\xA7\xA7\xA3\xA7\xA7\xAF\xAF\xA7\xA7\xA7\xA3\xAF\xAB\xAF\xA3\xA7\xAB\xAF\xA3\xA7\xA7\xA7\xAB\xAF\xAB\xA7  "

	.byte	bytecode_ld_sp_sr1

LINE_1000

	; A$(1)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xC9\xCD\xC2\xCF\xC2\xCF\xC2\xCD\xC4\xCD\xCA\xC7\xC8\xC7\xC3\xC5\xC8\xC5\xCA\xC5\xC8\xCD\xC0\xCD\xC1\xC7\xC1\xCD\xC0\xC7\xC0\xC7\xC1\xCD\xC4\xC5\xC2\xC7\xCD\xC5\xC4\xC7\xC5\xCF\xC0\xC5\xC1\xCD\xC1\xC5\xC0\xC5\xC0\xC5\xC0\xCD\xCA\xC7\xC2\xC7\xC5\xC5\xC5\xC5\xC4\xC5\xC6\xC7\xC6\xC7\xC2\xCF  "

	.byte	bytecode_ld_sp_sr1

LINE_1010

	; B$(1)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xCB\xCF\xCB\xCF\xCF\xC7\xC3\xCF\xCB\xCF\xC7\xCF\xC3\xCF\xCB\xCF\xC3\xCF\xC3\xCF\xC7\xC7\xC3\xC7\xC3\xC7\xC3\xCF\xC3\xC7\xC7\xCF\xC3\xC7\xC7\xC7\xC3\xC7\xC3\xC7\xC7\xC7\xC3\xC7\xC7\xC7\xC7\xC7\xC3\xC7\xC7\xCF\xCF\xC7\xC7\xC7\xC3\xCF\xCB\xCF\xC3\xC7\xCB\xCF\xC3\xC7\xC7\xC7\xCB\xCF\xCB\xC7  "

	.byte	bytecode_ld_sp_sr1

LINE_1020

	; A$(2)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xD9\xDD\xD2\xDF\xD2\xDF\xD2\xDD\xD4\xDD\xDA\xD7\xD8\xD7\xD3\xD5\xD8\xD5\xDA\xD5\xD8\xDD\xD0\xDD\xD1\xD7\xD1\xDD\xD0\xD7\xD0\xD7\xD1\xDD\xD4\xD5\xD2\xD7\xDD\xD5\xD4\xD7\xD5\xDF\xD0\xD5\xD1\xDD\xD1\xD5\xD0\xD5\xD0\xD5\xD0\xDD\xDA\xD7\xD2\xD7\xD5\xD5\xD5\xD5\xD4\xD5\xD6\xD7\xD6\xD7\xD2\xDF  "

	.byte	bytecode_ld_sp_sr1

LINE_1030

	; B$(2)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xDB\xDF\xDB\xDF\xDF\xD7\xD3\xDF\xDB\xDF\xD7\xDF\xD3\xDF\xDB\xDF\xD3\xDF\xD3\xDF\xD7\xD7\xD3\xD7\xD3\xD7\xD3\xDF\xD3\xD7\xD7\xDF\xD3\xD7\xD7\xD7\xD3\xD7\xD3\xD7\xD7\xD7\xD3\xD7\xD7\xD7\xD7\xD7\xD3\xD7\xD7\xDF\xDF\xD7\xD7\xD7\xD3\xDF\xDB\xDF\xD3\xD7\xDB\xDF\xD3\xD7\xD7\xD7\xDB\xDF\xDB\xD7  "

	.byte	bytecode_ld_sp_sr1

LINE_1040

	; A$(3)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xE9\xED\xE2\xEF\xE2\xEF\xE2\xED\xE4\xED\xEA\xE7\xE8\xE7\xE3\xE5\xE8\xE5\xEA\xE5\xE8\xED\xE0\xED\xE1\xE7\xE1\xED\xE0\xE7\xE0\xE7\xE1\xED\xE4\xE5\xE2\xE7\xED\xE5\xE4\xE7\xE5\xEF\xE0\xE5\xE1\xED\xE1\xE5\xE0\xE5\xE0\xE5\xE0\xED\xEA\xE7\xE2\xE7\xE5\xE5\xE5\xE5\xE4\xE5\xE6\xE7\xE6\xE7\xE2\xEF  "

	.byte	bytecode_ld_sp_sr1

LINE_1050

	; B$(3)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xEB\xEF\xEB\xEF\xEF\xE7\xE3\xEF\xEB\xEF\xE7\xEF\xE3\xEF\xEB\xEF\xE3\xEF\xE3\xEF\xE7\xE7\xE3\xE7\xE3\xE7\xE3\xEF\xE3\xE7\xE7\xEF\xE3\xE7\xE7\xE7\xE3\xE7\xE3\xE7\xE7\xE7\xE3\xE7\xE7\xE7\xE7\xE7\xE3\xE7\xE7\xEF\xEF\xE7\xE7\xE7\xE3\xEF\xEB\xEF\xE3\xE7\xEB\xEF\xE3\xE7\xE7\xE7\xEB\xEF\xEB\xE7  "

	.byte	bytecode_ld_sp_sr1

LINE_1060

	; A$(4)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xF9\xFD\xF2\xFF\xF2\xFF\xF2\xFD\xF4\xFD\xFA\xF7\xF8\xF7\xF3\xF5\xF8\xF5\xFA\xF5\xF8\xFD\xF0\xFD\xF1\xF7\xF1\xFD\xF0\xF7\xF0\xF7\xF1\xFD\xF4\xF5\xF2\xF7\xFD\xF5\xF4\xF7\xF5\xFF\xF0\xF5\xF1\xFD\xF1\xF5\xF0\xF5\xF0\xF5\xF0\xFD\xFA\xF7\xF2\xF7\xF5\xF5\xF5\xF5\xF4\xF5\xF6\xF7\xF6\xF7\xF2\xFF  "

	.byte	bytecode_ld_sp_sr1

LINE_1070

	; B$(4)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	74, "\xFB\xFF\xFB\xFF\xFF\xF7\xF3\xFF\xFB\xFF\xF7\xFF\xF3\xFF\xFB\xFF\xF3\xFF\xF3\xFF\xF7\xF7\xF3\xF7\xF3\xF7\xF3\xFF\xF3\xF7\xF7\xFF\xF3\xF7\xF7\xF7\xF3\xF7\xF3\xF7\xF7\xF7\xF3\xF7\xF7\xF7\xF7\xF7\xF3\xF7\xF7\xFF\xFF\xF7\xF7\xF7\xF3\xFF\xFB\xFF\xF3\xF7\xFB\xFF\xF3\xF7\xF7\xF7\xFB\xFF\xFB\xF7  "

	.byte	bytecode_ld_sp_sr1

LINE_1080

	; A$(5)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	74, "\x99\x9D\x92\x9F\x92\x9F\x92\x9D\x94\x9D\x9A\x97\x98\x97\x93\x95\x98\x95\x9A\x95\x98\x9D\x90\x9D\x91\x97\x91\x9D\x90\x97\x90\x97\x91\x9D\x94\x95\x92\x97\x9D\x95\x94\x97\x95\x9F\x90\x95\x91\x9D\x91\x95\x90\x95\x90\x95\x90\x9D\x9A\x97\x92\x97\x95\x95\x95\x95\x94\x95\x96\x97\x96\x97\x92\x9F  "

	.byte	bytecode_ld_sp_sr1

LINE_1090

	; B$(5)="������������������������������������������������������������������������  "

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	74, "\x9B\x9F\x9B\x9F\x9F\x97\x93\x9F\x9B\x9F\x97\x9F\x93\x9F\x9B\x9F\x93\x9F\x93\x9F\x97\x97\x93\x97\x93\x97\x93\x9F\x93\x97\x97\x9F\x93\x97\x97\x97\x93\x97\x93\x97\x97\x97\x93\x97\x97\x97\x97\x97\x93\x97\x97\x9F\x9F\x97\x97\x97\x93\x9F\x9B\x9F\x93\x97\x9B\x9F\x93\x97\x97\x97\x9B\x9F\x9B\x97  "

	.byte	bytecode_ld_sp_sr1

LINE_2001

	; L$(0,1)="011111111111100"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "011111111111100"

	.byte	bytecode_ld_sp_sr1

	; L$(0,2)="000122222210000"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000122222210000"

	.byte	bytecode_ld_sp_sr1

	; L$(0,3)="001123333211000"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "001123333211000"

	.byte	bytecode_ld_sp_sr1

	; L$(0,4)="111123543211111"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "111123543211111"

	.byte	bytecode_ld_sp_sr1

LINE_2005

	; L$(0,5)="011123443211100"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "011123443211100"

	.byte	bytecode_ld_sp_sr1

	; L$(0,6)="001123333211000"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "001123333211000"

	.byte	bytecode_ld_sp_sr1

	; L$(0,7)="000122222210000"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000122222210000"

	.byte	bytecode_ld_sp_sr1

	; L$(0,8)="011111111111100"

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "011111111111100"

	.byte	bytecode_ld_sp_sr1

LINE_2011

	; L$(1,1)="023333333333200"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "023333333333200"

	.byte	bytecode_ld_sp_sr1

	; L$(1,2)="000255555520000"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000255555520000"

	.byte	bytecode_ld_sp_sr1

	; L$(1,3)="002355555532000"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "002355555532000"

	.byte	bytecode_ld_sp_sr1

	; L$(1,4)="233355555533332"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "233355555533332"

	.byte	bytecode_ld_sp_sr1

LINE_2015

	; L$(1,5)="033355555533300"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "033355555533300"

	.byte	bytecode_ld_sp_sr1

	; L$(1,6)="002355555532000"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "002355555532000"

	.byte	bytecode_ld_sp_sr1

	; L$(1,7)="000255555520000"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000255555520000"

	.byte	bytecode_ld_sp_sr1

	; L$(1,8)="023333333333200"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "023333333333200"

	.byte	bytecode_ld_sp_sr1

LINE_2021

	; L$(2,1)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(2,2)="000023333200000"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000023333200000"

	.byte	bytecode_ld_sp_sr1

	; L$(2,3)="000025555200000"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000025555200000"

	.byte	bytecode_ld_sp_sr1

	; L$(2,4)="000025555200000"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000025555200000"

	.byte	bytecode_ld_sp_sr1

LINE_2025

	; L$(2,5)="000025555200000"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000025555200000"

	.byte	bytecode_ld_sp_sr1

	; L$(2,6)="000025555200000"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000025555200000"

	.byte	bytecode_ld_sp_sr1

	; L$(2,7)="000023333200000"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000023333200000"

	.byte	bytecode_ld_sp_sr1

	; L$(2,8)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

LINE_2031

	; L$(3,1)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(3,2)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(3,3)="000002332000000"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000002332000000"

	.byte	bytecode_ld_sp_sr1

	; L$(3,4)="000002552000000"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000002552000000"

	.byte	bytecode_ld_sp_sr1

LINE_2035

	; L$(3,5)="000002552000000"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000002552000000"

	.byte	bytecode_ld_sp_sr1

	; L$(3,6)="000002332000000"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000002332000000"

	.byte	bytecode_ld_sp_sr1

	; L$(3,7)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(3,8)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

LINE_2041

	; L$(4,1)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(4,2)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(4,3)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(4,4)="000000440000000"

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000000440000000"

	.byte	bytecode_ld_sp_sr1

LINE_2045

	; L$(4,5)="000000440000000"

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000000440000000"

	.byte	bytecode_ld_sp_sr1

	; L$(4,6)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(4,7)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(4,8)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

LINE_2051

	; L$(5,1)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(5,2)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(5,3)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(5,4)="000000100000000"

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sr1_ss
	.text	15, "000000100000000"

	.byte	bytecode_ld_sp_sr1

	; L$(5,5)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

LINE_2056

	; L$(5,6)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(5,7)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	7

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; L$(5,8)=L$(2,1)

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrref2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_sx_ir2
	.byte	bytecode_STRARR_L

	.byte	bytecode_ld_sp_sr1

	; FOR Z=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	5

	; FOR Y=1 TO 8

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	8

	; P$(Z,Y)=L$(Z,Y)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_L
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_sp_sr1

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_2100

	; CLS 5

	.byte	bytecode_clsn_pb
	.byte	5

	; PRINT @3, MID$(A$(1),21,26);

	.byte	bytecode_prat_pb
	.byte	3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir2_pb
	.byte	21

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	26

	.byte	bytecode_pr_sr1

	; PRINT @35, MID$(B$(1),21,26);

	.byte	bytecode_prat_pb
	.byte	35

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir2_pb
	.byte	21

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	26

	.byte	bytecode_pr_sr1

	; PRINT @67, MID$(A$(1),47,26);

	.byte	bytecode_prat_pb
	.byte	67

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir2_pb
	.byte	47

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	26

	.byte	bytecode_pr_sr1

LINE_2130

	; PRINT @99, MID$(B$(1),47,26);

	.byte	bytecode_prat_pb
	.byte	99

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir2_pb
	.byte	47

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	26

	.byte	bytecode_pr_sr1

	; PRINT @134, MID$(A$(1),1,20);

	.byte	bytecode_prat_pb
	.byte	134

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	20

	.byte	bytecode_pr_sr1

	; PRINT @166, MID$(B$(1),1,20);

	.byte	bytecode_prat_pb
	.byte	166

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	20

	.byte	bytecode_pr_sr1

LINE_2140

	; FOR T=1 TO 7

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	7

	; A=ASC(MID$("MAHJONG",T,1))

	.byte	bytecode_ld_sr1_ss
	.text	7, "MAHJONG"

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_asc_ir1_sr1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; A=SHIFT(A+-55,1)+1

	.byte	bytecode_add_ir1_ix_nb
	.byte	bytecode_INTVAR_A
	.byte	-55

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

LINE_2150

	; PRINT @SHIFT(T+3,1)+225, MID$(A$(1),A,2);

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	3

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	225

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	2

	.byte	bytecode_pr_sr1

	; PRINT @SHIFT(T+3,1)+257, MID$(B$(1),A,2);

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	3

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_add_ir1_ir1_pw
	.word	257

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	2

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

LINE_2160

	; GOSUB 5500

	.byte	bytecode_gosub_ix
	.word	LINE_5500

	; PRINT @486, "HIT ANY KEY TO BEGIN";

	.byte	bytecode_prat_pw
	.word	486

	.byte	bytecode_pr_ss
	.text	20, "HIT ANY KEY TO BEGIN"

LINE_2170

	; M$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_M

	; WHEN M$="" GOTO 2170

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_M
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_2170

LINE_2180

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; POKE 49151,0

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_poke_pw_ir1
	.word	49151

LINE_3000

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

	; FOR Z=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	5

	; FOR Y=1 TO 8

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	8

	; FOR X=1 TO 15

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	15

	; L(X,Y,Z)=VAL(MID$(L$(Z,Y),X,1))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_L
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_val_fr1_sr1

	.byte	bytecode_ld_ip_ir1

	; IF L(X,Y,Z) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_3010

	; X(C)=X

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ip_ir1

	; Y(C)=Y

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; Z(C)=Z

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_Z
	.byte	bytecode_INTVAR_C

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ip_ir1

	; C+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_C

LINE_3010

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; L(15,4,1)=-4

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_nb
	.byte	-4

	; L(1,4,1)=-2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_nb
	.byte	-2

	; L(7,4,5)=-3

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	5

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_nb
	.byte	-3

LINE_3020

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_3100

	; FOR Z=0 TO 5

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pb
	.byte	5

	; FOR Y=1 TO 8

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	8

	; FOR X=1 TO 15

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	15

	; L(X,Y,Z)=VAL(MID$(L$(Z,Y),X,1))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref3_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_L
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_val_fr1_sr1

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; L(15,4,1)=-4

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_nb
	.byte	-4

	; L(1,4,1)=-2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_nb
	.byte	-2

	; L(7,4,5)=-3

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_ld_ir3_pb
	.byte	5

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_nb
	.byte	-3

LINE_3170

	; FOR Y=1 TO 8

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	8

	; FOR X=1 TO 15

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	15

	; L(X,Y,6)=37

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	37

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; FOR T=1 TO P

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_P

	; X=X(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; IF L(X,Y,0)=Z THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_3210

	; L(X,Y,6)=T(T)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	6

	.byte	bytecode_arrref3_ir1_ix_ir3
	.byte	bytecode_INTARR_L

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_ir1

LINE_3210

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_4000

	; FOR T=1 TO P

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_P

	; X=X(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; Z=Z(P(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_P
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_Z

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z

	; P$(Z,Y)=LEFT$(P$(Z,Y),X-1)+CHR$(T(T))+MID$(P$(Z,Y),X+1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrref2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir1_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_left_sr1_sr1_ir2

	.byte	bytecode_strinit_sr1_sr1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_chr_sr2_ir2

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_arrval2_ir2_sx_id
	.byte	bytecode_STRARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_inc_ir3_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_mid_sr2_sr2_ir3

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sp_sr1

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_5500

	; PRINT @323, "MATCH TILES OPEN ON LEFT  ";

	.byte	bytecode_prat_pw
	.word	323

	.byte	bytecode_pr_ss
	.text	26, "MATCH TILES OPEN ON LEFT  "

	; PRINT @355, "OR RIGHT SIDE. USE W,A,S,D";

	.byte	bytecode_prat_pw
	.word	355

	.byte	bytecode_pr_ss
	.text	26, "OR RIGHT SIDE. USE W,A,S,D"

LINE_5520

	; PRINT @387, "TO MOVE & SPACE TO SELECT.";

	.byte	bytecode_prat_pw
	.word	387

	.byte	bytecode_pr_ss
	.text	26, "TO MOVE & SPACE TO SELECT."

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_abs_ir1_ir1	.equ	0
bytecode_add_ip_ip_ir1	.equ	1
bytecode_add_ip_ip_pb	.equ	2
bytecode_add_ir1_ir1_ir2	.equ	3
bytecode_add_ir1_ir1_ix	.equ	4
bytecode_add_ir1_ir1_pb	.equ	5
bytecode_add_ir1_ir1_pw	.equ	6
bytecode_add_ir1_ix_nb	.equ	7
bytecode_add_ir1_ix_pb	.equ	8
bytecode_add_ir2_ix_pb	.equ	9
bytecode_add_ix_ix_pb	.equ	10
bytecode_arrdim1_ir1_ix	.equ	11
bytecode_arrdim1_ir1_sx	.equ	12
bytecode_arrdim2_ir1_sx	.equ	13
bytecode_arrdim3_ir1_ix	.equ	14
bytecode_arrref1_ir1_ix_id	.equ	15
bytecode_arrref1_ir1_sx_ir1	.equ	16
bytecode_arrref2_ir1_sx_id	.equ	17
bytecode_arrref2_ir1_sx_ir2	.equ	18
bytecode_arrref3_ir1_ix_id	.equ	19
bytecode_arrref3_ir1_ix_ir3	.equ	20
bytecode_arrval1_ir1_ix_id	.equ	21
bytecode_arrval1_ir1_ix_ir1	.equ	22
bytecode_arrval1_ir1_sx_id	.equ	23
bytecode_arrval1_ir1_sx_ir1	.equ	24
bytecode_arrval1_ir2_ix_id	.equ	25
bytecode_arrval1_ir3_ix_id	.equ	26
bytecode_arrval2_ir1_sx_id	.equ	27
bytecode_arrval2_ir1_sx_ir2	.equ	28
bytecode_arrval2_ir2_sx_id	.equ	29
bytecode_arrval3_ir1_ix_id	.equ	30
bytecode_arrval3_ir1_ix_ir3	.equ	31
bytecode_arrval3_ir2_ix_ir4	.equ	32
bytecode_asc_ir1_sr1	.equ	33
bytecode_asc_ir1_sx	.equ	34
bytecode_chr_sr2_ir2	.equ	35
bytecode_chr_sr2_ix	.equ	36
bytecode_clear	.equ	37
bytecode_clr_ip	.equ	38
bytecode_clr_ix	.equ	39
bytecode_cls	.equ	40
bytecode_clsn_pb	.equ	41
bytecode_dbl_ir1_ir1	.equ	42
bytecode_dbl_ir1_ix	.equ	43
bytecode_dec_ip_ip	.equ	44
bytecode_dec_ir1_ir1	.equ	45
bytecode_dec_ir1_ix	.equ	46
bytecode_dec_ir2_ix	.equ	47
bytecode_dec_ir3_ix	.equ	48
bytecode_dec_ix_ix	.equ	49
bytecode_for_ix_pb	.equ	50
bytecode_forclr_ix	.equ	51
bytecode_forone_ix	.equ	52
bytecode_gosub_ix	.equ	53
bytecode_goto_ix	.equ	54
bytecode_inc_ip_ip	.equ	55
bytecode_inc_ir1_ir1	.equ	56
bytecode_inc_ir1_ix	.equ	57
bytecode_inc_ir3_ix	.equ	58
bytecode_inc_ix_ix	.equ	59
bytecode_inkey_sx	.equ	60
bytecode_jmpeq_ir1_ix	.equ	61
bytecode_jmpne_ir1_ix	.equ	62
bytecode_jsrne_ir1_ix	.equ	63
bytecode_ld_id_ix	.equ	64
bytecode_ld_ip_ir1	.equ	65
bytecode_ld_ip_nb	.equ	66
bytecode_ld_ip_pb	.equ	67
bytecode_ld_ir1_ix	.equ	68
bytecode_ld_ir1_pb	.equ	69
bytecode_ld_ir2_ix	.equ	70
bytecode_ld_ir2_pb	.equ	71
bytecode_ld_ir3_ix	.equ	72
bytecode_ld_ir3_pb	.equ	73
bytecode_ld_ir4_pb	.equ	74
bytecode_ld_ix_ir1	.equ	75
bytecode_ld_ix_pb	.equ	76
bytecode_ld_ix_pw	.equ	77
bytecode_ld_sp_sr1	.equ	78
bytecode_ld_sr1_ss	.equ	79
bytecode_ldeq_ir1_ir1_ir2	.equ	80
bytecode_ldeq_ir1_ir1_ix	.equ	81
bytecode_ldeq_ir1_ir1_pb	.equ	82
bytecode_ldeq_ir1_ix_id	.equ	83
bytecode_ldeq_ir1_ix_pb	.equ	84
bytecode_ldeq_ir1_sx_ss	.equ	85
bytecode_ldeq_ir2_ix_pb	.equ	86
bytecode_ldeq_ir2_sx_ss	.equ	87
bytecode_ldlt_ir1_ir1_pb	.equ	88
bytecode_ldlt_ir1_ix_pb	.equ	89
bytecode_ldlt_ir1_pb_ir1	.equ	90
bytecode_ldlt_ir1_pb_ix	.equ	91
bytecode_ldlt_ir2_ix_pb	.equ	92
bytecode_ldlt_ir2_pb_ix	.equ	93
bytecode_ldne_ir1_ir1_ir2	.equ	94
bytecode_ldne_ir1_ix_pb	.equ	95
bytecode_ldne_ir1_sx_ss	.equ	96
bytecode_left_sr1_sr1_ir2	.equ	97
bytecode_midT_sr1_sr1_pb	.equ	98
bytecode_mid_sr1_sr1_pb	.equ	99
bytecode_mid_sr2_sr2_ir3	.equ	100
bytecode_mul3_ir1_ix	.equ	101
bytecode_neg_ir1_ir1	.equ	102
bytecode_next	.equ	103
bytecode_one_ix	.equ	104
bytecode_ongoto_ir1_is	.equ	105
bytecode_or_ir1_ir1_ir2	.equ	106
bytecode_poke_ir1_ir2	.equ	107
bytecode_poke_pw_ir1	.equ	108
bytecode_pr_sr1	.equ	109
bytecode_pr_ss	.equ	110
bytecode_prat_ir1	.equ	111
bytecode_prat_ix	.equ	112
bytecode_prat_pb	.equ	113
bytecode_prat_pw	.equ	114
bytecode_progbegin	.equ	115
bytecode_progend	.equ	116
bytecode_return	.equ	117
bytecode_rnd_fr1_ir1	.equ	118
bytecode_rnd_fr1_ix	.equ	119
bytecode_rsub_ir1_ir1_pb	.equ	120
bytecode_shift_ir1_ir1_pb	.equ	121
bytecode_shift_ir2_ir2_pb	.equ	122
bytecode_sound_ir1_ir2	.equ	123
bytecode_stop	.equ	124
bytecode_str_sr1_ir1	.equ	125
bytecode_str_sr1_ix	.equ	126
bytecode_strcat_sr1_sr1_sr2	.equ	127
bytecode_strinit_sr1_sr1	.equ	128
bytecode_sub_ip_ip_pb	.equ	129
bytecode_sub_ir1_ix_id	.equ	130
bytecode_timer_ir1	.equ	131
bytecode_to_ip_ix	.equ	132
bytecode_to_ip_pb	.equ	133
bytecode_to_ip_pw	.equ	134
bytecode_true_ix	.equ	135
bytecode_val_fr1_sr1	.equ	136

catalog
	.word	abs_ir1_ir1
	.word	add_ip_ip_ir1
	.word	add_ip_ip_pb
	.word	add_ir1_ir1_ir2
	.word	add_ir1_ir1_ix
	.word	add_ir1_ir1_pb
	.word	add_ir1_ir1_pw
	.word	add_ir1_ix_nb
	.word	add_ir1_ix_pb
	.word	add_ir2_ix_pb
	.word	add_ix_ix_pb
	.word	arrdim1_ir1_ix
	.word	arrdim1_ir1_sx
	.word	arrdim2_ir1_sx
	.word	arrdim3_ir1_ix
	.word	arrref1_ir1_ix_id
	.word	arrref1_ir1_sx_ir1
	.word	arrref2_ir1_sx_id
	.word	arrref2_ir1_sx_ir2
	.word	arrref3_ir1_ix_id
	.word	arrref3_ir1_ix_ir3
	.word	arrval1_ir1_ix_id
	.word	arrval1_ir1_ix_ir1
	.word	arrval1_ir1_sx_id
	.word	arrval1_ir1_sx_ir1
	.word	arrval1_ir2_ix_id
	.word	arrval1_ir3_ix_id
	.word	arrval2_ir1_sx_id
	.word	arrval2_ir1_sx_ir2
	.word	arrval2_ir2_sx_id
	.word	arrval3_ir1_ix_id
	.word	arrval3_ir1_ix_ir3
	.word	arrval3_ir2_ix_ir4
	.word	asc_ir1_sr1
	.word	asc_ir1_sx
	.word	chr_sr2_ir2
	.word	chr_sr2_ix
	.word	clear
	.word	clr_ip
	.word	clr_ix
	.word	cls
	.word	clsn_pb
	.word	dbl_ir1_ir1
	.word	dbl_ir1_ix
	.word	dec_ip_ip
	.word	dec_ir1_ir1
	.word	dec_ir1_ix
	.word	dec_ir2_ix
	.word	dec_ir3_ix
	.word	dec_ix_ix
	.word	for_ix_pb
	.word	forclr_ix
	.word	forone_ix
	.word	gosub_ix
	.word	goto_ix
	.word	inc_ip_ip
	.word	inc_ir1_ir1
	.word	inc_ir1_ix
	.word	inc_ir3_ix
	.word	inc_ix_ix
	.word	inkey_sx
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	jsrne_ir1_ix
	.word	ld_id_ix
	.word	ld_ip_ir1
	.word	ld_ip_nb
	.word	ld_ip_pb
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ir3_ix
	.word	ld_ir3_pb
	.word	ld_ir4_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ld_ix_pw
	.word	ld_sp_sr1
	.word	ld_sr1_ss
	.word	ldeq_ir1_ir1_ir2
	.word	ldeq_ir1_ir1_ix
	.word	ldeq_ir1_ir1_pb
	.word	ldeq_ir1_ix_id
	.word	ldeq_ir1_ix_pb
	.word	ldeq_ir1_sx_ss
	.word	ldeq_ir2_ix_pb
	.word	ldeq_ir2_sx_ss
	.word	ldlt_ir1_ir1_pb
	.word	ldlt_ir1_ix_pb
	.word	ldlt_ir1_pb_ir1
	.word	ldlt_ir1_pb_ix
	.word	ldlt_ir2_ix_pb
	.word	ldlt_ir2_pb_ix
	.word	ldne_ir1_ir1_ir2
	.word	ldne_ir1_ix_pb
	.word	ldne_ir1_sx_ss
	.word	left_sr1_sr1_ir2
	.word	midT_sr1_sr1_pb
	.word	mid_sr1_sr1_pb
	.word	mid_sr2_sr2_ir3
	.word	mul3_ir1_ix
	.word	neg_ir1_ir1
	.word	next
	.word	one_ix
	.word	ongoto_ir1_is
	.word	or_ir1_ir1_ir2
	.word	poke_ir1_ir2
	.word	poke_pw_ir1
	.word	pr_sr1
	.word	pr_ss
	.word	prat_ir1
	.word	prat_ix
	.word	prat_pb
	.word	prat_pw
	.word	progbegin
	.word	progend
	.word	return
	.word	rnd_fr1_ir1
	.word	rnd_fr1_ix
	.word	rsub_ir1_ir1_pb
	.word	shift_ir1_ir1_pb
	.word	shift_ir2_ir2_pb
	.word	sound_ir1_ir2
	.word	stop
	.word	str_sr1_ir1
	.word	str_sr1_ix
	.word	strcat_sr1_sr1_sr2
	.word	strinit_sr1_sr1
	.word	sub_ip_ip_pb
	.word	sub_ir1_ix_id
	.word	timer_ir1
	.word	to_ip_ix
	.word	to_ip_pb
	.word	to_ip_pw
	.word	true_ix
	.word	val_fr1_sr1

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
eistr
	ldx	curinst
	inx
	pshx
	ldab	0,x
	ldx	#symtbl
	abx
	abx
	ldd	,x
	std	tmp3
	pulx
	inx
	ldab	,x
	inx
	pshx
	abx
	stx	nxtinst
	pulx
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

	.module	mdref3
; validate offset from 3D descriptor X and argv.
; if empty desc, then alloc D bytes in array memory
; and 11 elements in each dimension (1331 total elements).
; return word offset in D and byte offset in tmp1
ref3
	std	tmp1
	ldd	,x
	bne	_preexist
	ldd	strbuf
	std	,x
	ldd	#11
	std	2,x
	std	4,x
	std	6,x
	ldd	tmp1
	pshx
	jsr	alloc
	pulx
_preexist
	ldd	4+argv
	std	tmp1
	subd	6,x
	bhs	_err
	ldd	4,x
	std	tmp2
	subd	2+argv
	bls	_err
	jsr	mul12
	addd	2+argv
	std	tmp1
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

	.module	mdstreqx
; equality comparison with string release
; ENTRY:  X holds descriptor of LHS
;         tmp1+1 and tmp2 are RHS
; EXIT:  Z CCR flag set
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

abs_ir1_ir1			; numCalls = 1
	.module	modabs_ir1_ir1
	jsr	noargs
	ldaa	r1
	bpl	_rts
	ldx	#r1
	jmp	negxi
_rts
	rts

add_ip_ip_ir1			; numCalls = 6
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

add_ip_ip_pb			; numCalls = 1
	.module	modadd_ip_ip_pb
	jsr	getbyte
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

add_ir1_ir1_pb			; numCalls = 1
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

add_ir1_ix_nb			; numCalls = 1
	.module	modadd_ir1_ix_nb
	jsr	extbyte
	ldaa	#-1
	addd	1,x
	std	r1+1
	ldab	#-1
	adcb	0,x
	stab	r1
	rts

add_ir1_ix_pb			; numCalls = 6
	.module	modadd_ir1_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ix_pb			; numCalls = 1
	.module	modadd_ir2_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r2+1
	ldab	#0
	adcb	0,x
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

arrdim1_ir1_ix			; numCalls = 5
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

arrdim1_ir1_sx			; numCalls = 2
	.module	modarrdim1_ir1_sx
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

arrdim2_ir1_sx			; numCalls = 2
	.module	modarrdim2_ir1_sx
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

arrdim3_ir1_ix			; numCalls = 1
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

arrref1_ir1_ix_id			; numCalls = 7
	.module	modarrref1_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx_ir1			; numCalls = 12
	.module	modarrref1_ir1_sx_ir1
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_sx_id			; numCalls = 4
	.module	modarrref2_ir1_sx_id
	jsr	extdex
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrref2_ir1_sx_ir2			; numCalls = 48
	.module	modarrref2_ir1_sx_ir2
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrref3_ir1_ix_id			; numCalls = 23
	.module	modarrref3_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	4+argv
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#3*11*11*11
	jsr	ref3
	jsr	refint
	std	letptr
	rts

arrref3_ir1_ix_ir3			; numCalls = 31
	.module	modarrref3_ir1_ix_ir3
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	ldd	#3*11*11*11
	jsr	ref3
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 39
	.module	modarrval1_ir1_ix_id
	jsr	extdex
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

arrval1_ir1_ix_ir1			; numCalls = 24
	.module	modarrval1_ir1_ix_ir1
	jsr	extend
	ldd	r1+1
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

arrval1_ir1_sx_id			; numCalls = 2
	.module	modarrval1_ir1_sx_id
	jsr	extdex
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

arrval1_ir1_sx_ir1			; numCalls = 8
	.module	modarrval1_ir1_sx_ir1
	jsr	extend
	ldd	r1+1
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

arrval1_ir2_ix_id			; numCalls = 4
	.module	modarrval1_ir2_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval1_ir3_ix_id			; numCalls = 2
	.module	modarrval1_ir3_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#3*11
	jsr	ref1
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r3
	ldd	1,x
	std	r3+1
	rts

arrval2_ir1_sx_id			; numCalls = 9
	.module	modarrval2_ir1_sx_id
	jsr	extdex
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

arrval2_ir1_sx_ir2			; numCalls = 19
	.module	modarrval2_ir1_sx_ir2
	jsr	extend
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

arrval2_ir2_sx_id			; numCalls = 3
	.module	modarrval2_ir2_sx_id
	jsr	extdex
	jsr	getlw
	std	2+argv
	ldd	r2+1
	std	0+argv
	ldd	#3*11*11
	jsr	ref2
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

arrval3_ir1_ix_id			; numCalls = 22
	.module	modarrval3_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	4+argv
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	#3*11*11*11
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval3_ir1_ix_ir3			; numCalls = 30
	.module	modarrval3_ir1_ix_ir3
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	ldd	r1+1+10
	std	4+argv
	ldd	#3*11*11*11
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r1
	ldd	1,x
	std	r1+1
	rts

arrval3_ir2_ix_ir4			; numCalls = 1
	.module	modarrval3_ir2_ix_ir4
	jsr	extend
	ldd	r2+1
	std	0+argv
	ldd	r2+1+5
	std	2+argv
	ldd	r2+1+10
	std	4+argv
	ldd	#3*11*11*11
	jsr	ref3
	jsr	refint
	ldx	tmp1
	ldab	,x
	stab	r2
	ldd	1,x
	std	r2+1
	rts

asc_ir1_sr1			; numCalls = 4
	.module	modasc_ir1_sr1
	jsr	noargs
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

asc_ir1_sx			; numCalls = 1
	.module	modasc_ir1_sx
	jsr	extend
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

chr_sr2_ir2			; numCalls = 1
	.module	modchr_sr2_ir2
	jsr	noargs
	ldd	#$0100+(charpage>>8)
	std	r2
	rts

chr_sr2_ix			; numCalls = 2
	.module	modchr_sr2_ix
	jsr	extend
	ldab	2,x
	stab	r2+2
	ldd	#$0100+(charpage>>8)
	std	r2
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

clr_ip			; numCalls = 3
	.module	modclr_ip
	jsr	noargs
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 12
	.module	modclr_ix
	jsr	extend
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 2
	.module	modcls
	jsr	noargs
	jmp	R_CLS

clsn_pb			; numCalls = 3
	.module	modclsn_pb
	jsr	getbyte
	jmp	R_CLSN

dbl_ir1_ir1			; numCalls = 15
	.module	moddbl_ir1_ir1
	jsr	noargs
	ldx	#r1
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dbl_ir1_ix			; numCalls = 3
	.module	moddbl_ir1_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dec_ip_ip			; numCalls = 7
	.module	moddec_ip_ip
	jsr	noargs
	ldx	letptr
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

dec_ir1_ir1			; numCalls = 8
	.module	moddec_ir1_ir1
	jsr	noargs
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 9
	.module	moddec_ir1_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 4
	.module	moddec_ir2_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ir3_ix			; numCalls = 5
	.module	moddec_ir3_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r3+1
	ldab	0,x
	sbcb	#0
	stab	r3
	rts

dec_ix_ix			; numCalls = 3
	.module	moddec_ix_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_ix_pb			; numCalls = 4
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 1
	.module	modforclr_ix
	jsr	extend
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 24
	.module	modforone_ix
	jsr	extend
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 42
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

goto_ix			; numCalls = 33
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

inc_ip_ip			; numCalls = 2
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

inc_ir1_ir1			; numCalls = 13
	.module	modinc_ir1_ir1
	jsr	noargs
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 5
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir3_ix			; numCalls = 3
	.module	modinc_ir3_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r3+1
	ldab	0,x
	adcb	#0
	stab	r3
	rts

inc_ix_ix			; numCalls = 9
	.module	modinc_ix_ix
	jsr	extend
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 3
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

jmpeq_ir1_ix			; numCalls = 51
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 11
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

jsrne_ir1_ix			; numCalls = 9
	.module	modjsrne_ir1_ix
	pulx
	jsr	getaddr
	ldd	r1+1
	bne	_go
	ldaa	r1
	beq	_rts
_go
	ldd	nxtinst
	pshb
	psha
	ldab	#3
	pshb
	stx	nxtinst
_rts
	jmp	mainloop

ld_id_ix			; numCalls = 27
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

ld_ip_ir1			; numCalls = 27
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_nb			; numCalls = 6
	.module	modld_ip_nb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ip_pb			; numCalls = 5
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 84
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 148
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 73
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 127
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 1
	.module	modld_ir3_ix
	jsr	extend
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ir3_pb			; numCalls = 55
	.module	modld_ir3_pb
	jsr	getbyte
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ir4_pb			; numCalls = 1
	.module	modld_ir4_pb
	jsr	getbyte
	stab	r4+2
	ldd	#0
	std	r4
	rts

ld_ix_ir1			; numCalls = 55
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 15
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 4
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 64
	.module	modld_sp_sr1
	jsr	noargs
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 43
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

ldeq_ir1_ir1_ir2			; numCalls = 1
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

ldeq_ir1_ir1_ix			; numCalls = 5
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

ldeq_ir1_ir1_pb			; numCalls = 5
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

ldeq_ir1_ix_id			; numCalls = 4
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

ldeq_ir1_ix_pb			; numCalls = 16
	.module	modldeq_ir1_ix_pb
	jsr	extbyte
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir1_sx_ss			; numCalls = 6
	.module	modldeq_ir1_sx_ss
	jsr	eistr
	stab	tmp1+1
	stx	tmp2
	ldx	tmp3
	jsr	streqx
	jsr	geteq
	std	r1+1
	stab	r1
	rts

ldeq_ir2_ix_pb			; numCalls = 1
	.module	modldeq_ir2_ix_pb
	jsr	extbyte
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldeq_ir2_sx_ss			; numCalls = 1
	.module	modldeq_ir2_sx_ss
	jsr	eistr
	stab	tmp1+1
	stx	tmp2
	ldx	tmp3
	jsr	streqx
	jsr	geteq
	std	r2+1
	stab	r2
	rts

ldlt_ir1_ir1_pb			; numCalls = 7
	.module	modldlt_ir1_ir1_pb
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

ldlt_ir1_ix_pb			; numCalls = 4
	.module	modldlt_ir1_ix_pb
	jsr	extbyte
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

ldlt_ir1_pb_ir1			; numCalls = 6
	.module	modldlt_ir1_pb_ir1
	jsr	getbyte
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
	jsr	byteext
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir2_ix_pb			; numCalls = 1
	.module	modldlt_ir2_ix_pb
	jsr	extbyte
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

ldlt_ir2_pb_ix			; numCalls = 1
	.module	modldlt_ir2_pb_ix
	jsr	byteext
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldne_ir1_ir1_ir2			; numCalls = 1
	.module	modldne_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	subd	r2+1
	bne	_done
	ldab	r1
	cmpb	r2
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_ix_pb			; numCalls = 1
	.module	modldne_ir1_ix_pb
	jsr	extbyte
	cmpb	2,x
	bne	_done
	ldd	0,x
_done
	jsr	getne
	std	r1+1
	stab	r1
	rts

ldne_ir1_sx_ss			; numCalls = 1
	.module	modldne_ir1_sx_ss
	jsr	eistr
	stab	tmp1+1
	stx	tmp2
	ldx	tmp3
	jsr	streqx
	jsr	getne
	std	r1+1
	stab	r1
	rts

left_sr1_sr1_ir2			; numCalls = 3
	.module	modleft_sr1_sr1_ir2
	jsr	noargs
	ldd	r2
	beq	_ok
	bmi	_fc_error
	bne	_rts
_ok
	ldab	r2+2
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

midT_sr1_sr1_pb			; numCalls = 17
	.module	modmidT_sr1_sr1_pb
	jsr	getbyte
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

mid_sr1_sr1_pb			; numCalls = 2
	.module	modmid_sr1_sr1_pb
	jsr	getbyte
	tstb
	beq	_fc_error
	ldaa	r1
	inca
	sba
	bls	_zero
	staa	r1
	clra
	addd	r1+1
	subd	#1
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

mid_sr2_sr2_ir3			; numCalls = 3
	.module	modmid_sr2_sr2_ir3
	jsr	noargs
	ldd	r3
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	r3+2
	beq	_fc_error
	ldab	r2
	incb
	subb	r3+2
	bls	_zero
	stab	r2
	ldd	r3+1
	subd	#1
	addd	r2+1
	std	r2+1
	rts
_zero
	pshx
	ldx	r2+1
	jsr	strrel
	pulx
	ldd	#$0100
	std	r2+1
	stab	r2
_rts
	rts
_fc_error
	ldab	#FC_ERROR
	jmp	error

mul3_ir1_ix			; numCalls = 1
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

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	jsr	noargs
	ldx	#r1
	jmp	negxi

next			; numCalls = 40
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

one_ix			; numCalls = 6
	.module	modone_ix
	jsr	extend
	ldd	#1
	staa	0,x
	std	1,x
	rts

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

or_ir1_ir1_ir2			; numCalls = 4
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

poke_ir1_ir2			; numCalls = 1
	.module	modpoke_ir1_ir2
	jsr	noargs
	ldab	r2+2
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

pr_sr1			; numCalls = 16
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

pr_ss			; numCalls = 42
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

prat_ir1			; numCalls = 5
	.module	modprat_ir1
	jsr	noargs
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 2
	.module	modprat_ix
	jsr	extend
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 32
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 11
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

return			; numCalls = 25
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

rnd_fr1_ir1			; numCalls = 1
	.module	modrnd_fr1_ir1
	jsr	noargs
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

rsub_ir1_ir1_pb			; numCalls = 2
	.module	modrsub_ir1_ir1_pb
	jsr	getbyte
	clra
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

shift_ir1_ir1_pb			; numCalls = 2
	.module	modshift_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jmp	shlint

shift_ir2_ir2_pb			; numCalls = 1
	.module	modshift_ir2_ir2_pb
	jsr	getbyte
	ldx	#r2
	jmp	shlint

sound_ir1_ir2			; numCalls = 5
	.module	modsound_ir1_ir2
	jsr	noargs
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

stop			; numCalls = 1
	.module	modstop
	jsr	noargs
	ldx	#R_BKMSG-1
	jmp	R_BREAK

str_sr1_ir1			; numCalls = 4
	.module	modstr_sr1_ir1
	jsr	noargs
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

strcat_sr1_sr1_sr2			; numCalls = 6
	.module	modstrcat_sr1_sr1_sr2
	jsr	noargs
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

strinit_sr1_sr1			; numCalls = 3
	.module	modstrinit_sr1_sr1
	jsr	noargs
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

sub_ip_ip_pb			; numCalls = 4
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

sub_ir1_ix_id			; numCalls = 1
	.module	modsub_ir1_ix_id
	jsr	extdex
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

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	jsr	noargs
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_ip_ix			; numCalls = 6
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

to_ip_pb			; numCalls = 22
	.module	modto_ip_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 1
	.module	modto_ip_pw
	jsr	getword
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

true_ix			; numCalls = 2
	.module	modtrue_ix
	jsr	extend
	ldd	#-1
	stab	0,x
	std	1,x
	rts

val_fr1_sr1			; numCalls = 2
	.module	modval_fr1_sr1
	jsr	noargs
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

; Bytecode symbol lookup table


bytecode_INTVAR_A	.equ	0
bytecode_INTVAR_C	.equ	1
bytecode_INTVAR_FF	.equ	2
bytecode_INTVAR_I	.equ	3
bytecode_INTVAR_J	.equ	4
bytecode_INTVAR_K	.equ	5
bytecode_INTVAR_MC	.equ	6
bytecode_INTVAR_N	.equ	7
bytecode_INTVAR_P	.equ	8
bytecode_INTVAR_Q	.equ	9
bytecode_INTVAR_R	.equ	10
bytecode_INTVAR_S	.equ	11
bytecode_INTVAR_T	.equ	12
bytecode_INTVAR_X	.equ	13
bytecode_INTVAR_Y	.equ	14
bytecode_INTVAR_Z	.equ	15
bytecode_STRVAR_I	.equ	16
bytecode_STRVAR_M	.equ	17
bytecode_INTARR_L	.equ	18
bytecode_INTARR_P	.equ	19
bytecode_INTARR_T	.equ	20
bytecode_INTARR_X	.equ	21
bytecode_INTARR_Y	.equ	22
bytecode_INTARR_Z	.equ	23
bytecode_STRARR_A	.equ	24
bytecode_STRARR_B	.equ	25
bytecode_STRARR_L	.equ	26
bytecode_STRARR_P	.equ	27

symtbl

	.word	INTVAR_A
	.word	INTVAR_C
	.word	INTVAR_FF
	.word	INTVAR_I
	.word	INTVAR_J
	.word	INTVAR_K
	.word	INTVAR_MC
	.word	INTVAR_N
	.word	INTVAR_P
	.word	INTVAR_Q
	.word	INTVAR_R
	.word	INTVAR_S
	.word	INTVAR_T
	.word	INTVAR_X
	.word	INTVAR_Y
	.word	INTVAR_Z
	.word	STRVAR_I
	.word	STRVAR_M
	.word	INTARR_L
	.word	INTARR_P
	.word	INTARR_T
	.word	INTARR_X
	.word	INTARR_Y
	.word	INTARR_Z
	.word	STRARR_A
	.word	STRARR_B
	.word	STRARR_L
	.word	STRARR_P


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_C	.block	3
INTVAR_FF	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_MC	.block	3
INTVAR_N	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_T	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
; String Variables
STRVAR_I	.block	3
STRVAR_M	.block	3
; Numeric Arrays
INTARR_L	.block	8	; dims=3
INTARR_P	.block	4	; dims=1
INTARR_T	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
INTARR_Z	.block	4	; dims=1
; String Arrays
STRARR_A	.block	4	; dims=1
STRARR_B	.block	4	; dims=1
STRARR_L	.block	6	; dims=2
STRARR_P	.block	6	; dims=2

; block ended by symbol
bes
	.end

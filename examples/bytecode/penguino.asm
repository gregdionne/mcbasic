; Assembly for penguino.bas
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

	; CLEAR 500

	.byte	bytecode_clear

	; POKE 16925,0

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_poke_pw_ir1
	.word	16925

	; POKE 16926,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_poke_pw_ir1
	.word	16926

	; GOSUB 2000

	.byte	bytecode_gosub_ix
	.word	LINE_2000

	; GOTO 100

	.byte	bytecode_goto_ix
	.word	LINE_100

LINE_1

	; RETURN

	.byte	bytecode_return

LINE_2

	; PRINT @A(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; RETURN

	.byte	bytecode_return

LINE_3

	; PRINT @A(X,Y), A$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_A
	.byte	bytecode_INTVAR_D

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_B
	.byte	bytecode_INTVAR_D

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_4

	; WHEN X<2 GOTO 40

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_40

	; ON K(PEEK(A(X-2,Y)+M)) GOTO 40,40,42,40

	.byte	bytecode_sub_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_40, LINE_40, LINE_42, LINE_40

	; GOTO 42

	.byte	bytecode_goto_ix
	.word	LINE_42

LINE_5

	; WHEN X>13 GOTO 50

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	13
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_50

	; ON K(PEEK(A(X+2,Y)+M)) GOTO 50,50,52,50

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_50, LINE_50, LINE_52, LINE_50

	; GOTO 52

	.byte	bytecode_goto_ix
	.word	LINE_52

LINE_6

	; WHEN Y<2 GOTO 60

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_60

	; ON K(PEEK(A(X,Y-2)+M)) GOTO 60,60,62,60

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sub_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_60, LINE_60, LINE_62, LINE_60

	; GOTO 62

	.byte	bytecode_goto_ix
	.word	LINE_62

LINE_7

	; WHEN Y>5 GOTO 70

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	5
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_70

	; ON K(PEEK(A(X,Y+2)+M)) GOTO 70,70,72,70

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_70, LINE_70, LINE_72, LINE_70

	; GOTO 72

	.byte	bytecode_goto_ix
	.word	LINE_72

LINE_8

	; ON K(PEEK(A(X-1,Y)+M)) GOTO 4,90,80,1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_4, LINE_90, LINE_80, LINE_1

	; PRINT @A(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; X-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_X

	; D=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	6

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_9

	; ON K(PEEK(A(X+1,Y)+M)) GOTO 5,91,81,1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_5, LINE_91, LINE_81, LINE_1

	; PRINT @A(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; X+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_X

	; D=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	5

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_10

	; ON K(PEEK(A(X,Y-1)+M)) GOTO 6,92,82,1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_6, LINE_92, LINE_82, LINE_1

	; PRINT @A(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; Y-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_Y

	; D=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	7

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_11

	; ON K(PEEK(A(X,Y+1)+M)) GOTO 7,93,83,1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_7, LINE_93, LINE_83, LINE_1

	; PRINT @A(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; Y+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_Y

	; D=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	7

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_12

	; A=M(J)+SGN(X-M(J))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_rsub_ir2_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sgn_ir2_ir2

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=N(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; ON L(A+2,B+2) GOTO 13

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	2

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_L

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_13

	; ON K(PEEK(A(A,B)+M)) GOTO 13,13,13,13,85

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_13, LINE_13, LINE_13, LINE_13, LINE_85

	; V(J)=RND(4)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_J

	.byte	bytecode_irnd_ir1_pb
	.byte	4

	.byte	bytecode_ld_ip_ir1

	; GOTO 18

	.byte	bytecode_goto_ix
	.word	LINE_18

LINE_13

	; A=M(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=N(J)+SGN(Y-N(J))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_rsub_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_sgn_ir2_ir2

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; ON L(A+2,B+2) GOTO 14

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	2

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_L

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_14

	; ON K(PEEK(A(A,B)+M)) GOTO 14,14,14,14,85

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_14, LINE_14, LINE_14, LINE_14, LINE_85

	; V(J)=RND(4)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_J

	.byte	bytecode_irnd_ir1_pb
	.byte	4

	.byte	bytecode_ld_ip_ir1

	; GOTO 18

	.byte	bytecode_goto_ix
	.word	LINE_18

LINE_14

	; A=M(J)+D(V(J))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_D

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=N(J)+I(V(J))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_I

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; ON L(A+2,B+2) GOTO 15

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	2

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_L

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_15

	; ON K(PEEK(A(A,B)+M)) GOTO 15,15,15,15,85

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_15, LINE_15, LINE_15, LINE_15, LINE_85

	; GOTO 18

	.byte	bytecode_goto_ix
	.word	LINE_18

LINE_15

	; FOR D=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_to_ip_pb
	.byte	4

	; A=M(J)+D(D)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_D

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=N(J)+I(D)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_D

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; ON L(A+2,B+2) GOTO 16

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	2

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_L

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_16

	; ON K(PEEK(A(A,B)+M)) GOTO 16,16,16,16,85

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_16, LINE_16, LINE_16, LINE_16, LINE_85

	; V(J)=D

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_ld_ip_ir1

	; D=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	4

	; NEXT

	.byte	bytecode_next

	; GOTO 18

	.byte	bytecode_goto_ix
	.word	LINE_18

LINE_16

	; NEXT

	.byte	bytecode_next

	; ON RND(2) GOTO 17

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_17

	; A=M(J)+SGN(X-M(J))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_rsub_ir2_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sgn_ir2_ir2

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=N(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; PRINT @A(A,B), A$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(A,B), B$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; GOTO 18

	.byte	bytecode_goto_ix
	.word	LINE_18

LINE_17

	; A=M(J)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_A

	; B=N(J)+SGN(Y-N(J))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_rsub_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_sgn_ir2_ir2

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; PRINT @A(A,B), A$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(A,B), B$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

LINE_18

	; PRINT @A(M(J),N(J)), B$;

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(M(J),N(J)), B$;

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; M(J)=A

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_ld_ip_ir1

	; N(J)=B

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ip_ir1

	; D=RND(2)

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_D

	; PRINT @A(A,B), A$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_A
	.byte	bytecode_INTVAR_D

	.byte	bytecode_pr_sr1

	; PRINT @B(A,B), B$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_B
	.byte	bytecode_INTVAR_D

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_20

	; FOR T=1 TO E

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_E

	; FOR J=1 TO L

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_L

	; ON RND(G(J)) GOSUB 12,13

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_rnd_fr1_ir1

	.byte	bytecode_ongosub_ir1_is
	.byte	2
	.word	LINE_12, LINE_13

	; FOR ZZ=1 TO 300

	.byte	bytecode_forone_fx
	.byte	bytecode_FLTVAR_ZZ

	.byte	bytecode_to_fp_pw
	.word	300

	; NEXT

	.byte	bytecode_next

	; IF PEEK(2)=0 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_21

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 26

	.byte	bytecode_goto_ix
	.word	LINE_26

LINE_21

	; IF NOT PEEK(16946) AND 1 THEN

	.byte	bytecode_peek_ir1_pw
	.word	16946

	.byte	bytecode_com_ir1_ir1

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_22

	; IF X>0 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	0
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_22

	; GOSUB 8

	.byte	bytecode_gosub_ix
	.word	LINE_8

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 26

	.byte	bytecode_goto_ix
	.word	LINE_26

LINE_22

	; IF NOT PEEK(16949) AND 1 THEN

	.byte	bytecode_peek_ir1_pw
	.word	16949

	.byte	bytecode_com_ir1_ir1

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_23

	; IF X<15 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	15

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_23

	; GOSUB 9

	.byte	bytecode_gosub_ix
	.word	LINE_9

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 26

	.byte	bytecode_goto_ix
	.word	LINE_26

LINE_23

	; IF NOT PEEK(16952) AND 4 THEN

	.byte	bytecode_peek_ir1_pw
	.word	16952

	.byte	bytecode_com_ir1_ir1

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_24

	; IF Y>0 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	0
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_24

	; GOSUB 10

	.byte	bytecode_gosub_ix
	.word	LINE_10

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 26

	.byte	bytecode_goto_ix
	.word	LINE_26

LINE_24

	; IF NOT PEEK(16948) AND 4 THEN

	.byte	bytecode_peek_ir1_pw
	.word	16948

	.byte	bytecode_com_ir1_ir1

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_25

	; IF Y<7 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	7

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_25

	; GOSUB 11

	.byte	bytecode_gosub_ix
	.word	LINE_11

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 26

	.byte	bytecode_goto_ix
	.word	LINE_26

LINE_25

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_26

	; ON T+Z-E GOTO 30,94,95,97,97,98

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_T
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_sub_ir1_ir1_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ongoto_ir1_is
	.byte	6
	.word	LINE_30, LINE_94, LINE_95, LINE_97, LINE_97, LINE_98

LINE_30

	; FOR J=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	4

	; ON G(J) GOTO 31,31

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ongoto_ir1_is
	.byte	2
	.word	LINE_31, LINE_31

	; GOSUB 550

	.byte	bytecode_gosub_ix
	.word	LINE_550

	; SOUND 1,3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; SOUND 10,2

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; I-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_I

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

	; NEXT

	.byte	bytecode_next

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_31

	; NEXT

	.byte	bytecode_next

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_40

	; PRINT @A(X-1,Y), A$(10);

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X-1,Y), B$(10);

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @A(X-1,Y), B$;

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X-1,Y), B$;

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; RETURN

	.byte	bytecode_return

LINE_42

	; H=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_H

	; FOR C=X-1 TO 1 STEP -1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_for_ix_ir1
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	1

	.byte	bytecode_ld_ir1_nb
	.byte	-1

	.byte	bytecode_step_ip_ir1

	; ON K(PEEK(A(C-1,Y)+M)) GOTO 49,49,46,49

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_49, LINE_49, LINE_46, LINE_49

	; PRINT @A(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

LINE_44

	; PRINT @A(C-1,Y), A$(3);

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(C-1,Y), B$(3);

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_46

	; PRINT @A(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @A(C-1,Y), A$(9);

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(C-1,Y), B$(9);

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 100,3

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

LINE_47

	; FOR J=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN ((C-1)<>M(J)) OR (N(J)<>Y) GOTO 48

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldne_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldne_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_48

	; M(J)=-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_true_ip

	; G(J)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_clr_ip

	; H+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_H

	; I+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_I

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

	; NEXT

	.byte	bytecode_next

	; GOTO 44

	.byte	bytecode_goto_ix
	.word	LINE_44

LINE_48

	; NEXT

	.byte	bytecode_next

	; STOP

	.byte	bytecode_stop

	; GOTO 44

	.byte	bytecode_goto_ix
	.word	LINE_44

LINE_49

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_50

	; PRINT @A(X+1,Y), A$(10);

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X+1,Y), B$(10);

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @A(X+1,Y), B$;

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X+1,Y), B$;

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; RETURN

	.byte	bytecode_return

LINE_52

	; H=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_H

	; FOR C=X+1 TO 14

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_for_ix_ir1
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	14

	; ON K(PEEK(A(C+1,Y)+M)) GOTO 59,59,56,59

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_59, LINE_59, LINE_56, LINE_59

	; PRINT @A(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

LINE_54

	; PRINT @A(C+1,Y), A$(3);

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(C+1,Y), B$(3);

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_56

	; PRINT @A(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(C,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @A(C+1,Y), A$(9);

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(C+1,Y), B$(9);

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 100,3

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

LINE_57

	; FOR J=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	4

	; WHEN ((C+1)<>M(J)) OR (N(J)<>Y) GOTO 58

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldne_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldne_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_58

	; M(J)=-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_true_ip

	; G(J)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_clr_ip

	; H+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_H

	; I+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_I

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

	; NEXT

	.byte	bytecode_next

	; GOTO 54

	.byte	bytecode_goto_ix
	.word	LINE_54

LINE_58

	; NEXT

	.byte	bytecode_next

	; STOP

	.byte	bytecode_stop

	; GOTO 54

	.byte	bytecode_goto_ix
	.word	LINE_54

LINE_59

	; C=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	14

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_60

	; PRINT @A(X,Y-1), A$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y-1), B$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @A(X,Y-1), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y-1), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; RETURN

	.byte	bytecode_return

LINE_62

	; H=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_H

	; FOR C=Y-1 TO 1 STEP -1

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_for_ix_ir1
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	1

	.byte	bytecode_ld_ir1_nb
	.byte	-1

	.byte	bytecode_step_ip_ir1

	; ON K(PEEK(A(X,C-1)+M)) GOTO 69,69,66,69

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_69, LINE_69, LINE_66, LINE_69

	; PRINT @A(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

LINE_64

	; PRINT @A(X,C-1), A$(3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,C-1), B$(3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_66

	; PRINT @A(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @A(X,C-1), A$(9);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,C-1), B$(9);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 100,3

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

LINE_67

	; FOR J=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	4

	; IF (M(J)=X) AND ((C-1)=N(J)) THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_68

	; M(J)=-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_true_ip

	; G(J)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_clr_ip

	; H+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_H

	; I+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_I

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

	; NEXT

	.byte	bytecode_next

	; GOTO 64

	.byte	bytecode_goto_ix
	.word	LINE_64

LINE_68

	; NEXT

	.byte	bytecode_next

	; STOP

	.byte	bytecode_stop

	; GOTO 64

	.byte	bytecode_goto_ix
	.word	LINE_64

LINE_69

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_70

	; PRINT @A(X,Y+1), A$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y+1), B$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @A(X,Y+1), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y+1), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; RETURN

	.byte	bytecode_return

LINE_72

	; H=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_H

	; FOR C=Y+1 TO 6

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_for_ix_ir1
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	6

	; ON K(PEEK(A(X,C+1)+M)) GOTO 79,79,76,79

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_79, LINE_79, LINE_76, LINE_79

	; PRINT @A(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

LINE_74

	; PRINT @A(X,C+1), A$(3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,C+1), B$(3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_76

	; PRINT @A(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,C), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_C

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @A(X,C+1), A$(9);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,C+1), B$(9);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 100,3

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

LINE_77

	; FOR J=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	4

	; IF (M(J)=X) AND ((C+1)=N(J)) THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_78

	; M(J)=-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_true_ip

	; G(J)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_clr_ip

	; H+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_H

	; I+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_I

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

	; NEXT

	.byte	bytecode_next

	; GOTO 74

	.byte	bytecode_goto_ix
	.word	LINE_74

LINE_78

	; NEXT

	.byte	bytecode_next

	; STOP

	.byte	bytecode_stop

	; GOTO 74

	.byte	bytecode_goto_ix
	.word	LINE_74

LINE_79

	; C=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	6

	; NEXT

	.byte	bytecode_next

	; GOTO 88

	.byte	bytecode_goto_ix
	.word	LINE_88

LINE_80

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; X-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_X

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_81

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; X+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_X

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_82

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; Y-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_Y

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_83

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; Y+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_Y

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_84

	; FOR T=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	5

	; D=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	7

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; SOUND 200,5

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_sound_ir1_ir2

	; D=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	8

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; SOUND 1,3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

	; D=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_D

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; T=E+2

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_E
	.byte	2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

	; K=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_K

	; RETURN

	.byte	bytecode_return

LINE_85

	; GOSUB 18

	.byte	bytecode_gosub_ix
	.word	LINE_18

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; GOTO 84

	.byte	bytecode_goto_ix
	.word	LINE_84

LINE_86

	; FOR T=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	5

	; PRINT @363, "+ 5000 bonus";

	.byte	bytecode_prat_pw
	.word	363

	.byte	bytecode_pr_ss
	.text	12, "+ 5000 bonus"

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 205,1

	.byte	bytecode_ld_ir1_pb
	.byte	205

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; PRINT "\x08\x08\x08\x08\x08";

	.byte	bytecode_pr_ss
	.text	5, "\x08\x08\x08\x08\x08"

LINE_87

	; PRINT "BONUS";

	.byte	bytecode_pr_ss
	.text	5, "BONUS"

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 205,1

	.byte	bytecode_ld_ir1_pb
	.byte	205

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

	; SC+=5000

	.byte	bytecode_add_ix_ix_pw
	.byte	bytecode_INTVAR_SC
	.word	5000

	; RETURN

	.byte	bytecode_return

LINE_88

	; IF I>=4 THEN

	.byte	bytecode_ldge_ir1_ix_pb
	.byte	bytecode_INTVAR_I
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_89

	; T=E+1

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; J=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	4

LINE_89

	; SC+=SQ(H)*100

	.byte	bytecode_sq_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	100

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_SC

	; RETURN

	.byte	bytecode_return

LINE_90

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; X-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_X

	; D=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	6

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 205,1

	.byte	bytecode_ld_ir1_pb
	.byte	205

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SC+=500

	.byte	bytecode_add_ix_ix_pw
	.byte	bytecode_INTVAR_SC
	.word	500

	; S+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_S

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_91

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; X+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_X

	; D=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	5

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 205,1

	.byte	bytecode_ld_ir1_pb
	.byte	205

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SC+=500

	.byte	bytecode_add_ix_ix_pw
	.byte	bytecode_INTVAR_SC
	.word	500

	; S+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_S

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_92

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; Y-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_Y

	; D=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	7

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 205,1

	.byte	bytecode_ld_ir1_pb
	.byte	205

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SC+=500

	.byte	bytecode_add_ix_ix_pw
	.byte	bytecode_INTVAR_SC
	.word	500

	; S+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_S

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_93

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; Y+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_Y

	; D=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	7

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 205,1

	.byte	bytecode_ld_ir1_pb
	.byte	205

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SC+=500

	.byte	bytecode_add_ix_ix_pw
	.byte	bytecode_INTVAR_SC
	.word	500

	; S+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_S

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_94

	; PRINT @0, "SCORE:";STR$(SC);" ";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	6, "SCORE:"

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; FOR T=1 TO 1500

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pw
	.word	1500

	; NEXT

	.byte	bytecode_next

	; GOTO 110

	.byte	bytecode_goto_ix
	.word	LINE_110

LINE_95

	; MN-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_MN

	; POKE 16863,MN+48

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	48

	.byte	bytecode_poke_pw_ir1
	.word	16863

	; IF MN=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MN

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_96

	; PRINT @0, "SCORE:";STR$(SC);" ";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	6, "SCORE:"

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; GOSUB 700

	.byte	bytecode_gosub_ix
	.word	LINE_700

	; GOSUB 3000

	.byte	bytecode_gosub_ix
	.word	LINE_3000

	; GOSUB 4000

	.byte	bytecode_gosub_ix
	.word	LINE_4000

	; GOTO 105

	.byte	bytecode_goto_ix
	.word	LINE_105

LINE_96

	; GOSUB 540

	.byte	bytecode_gosub_ix
	.word	LINE_540

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; FOR T=1 TO 1000

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pw
	.word	1000

	; NEXT

	.byte	bytecode_next

	; K=17023

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_K
	.word	17023

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_97

	; CLS

	.byte	bytecode_cls

	; PRINT @231, "CHALLENGE STAGE OVER";

	.byte	bytecode_prat_pb
	.byte	231

	.byte	bytecode_pr_ss
	.text	20, "CHALLENGE STAGE OVER"

	; PRINT @299, "SCORE:";STR$(SC);" ";

	.byte	bytecode_prat_pw
	.word	299

	.byte	bytecode_pr_ss
	.text	6, "SCORE:"

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; ON 1-(S>9) GOSUB 1,86

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	9
	.byte	bytecode_INTVAR_S

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ongosub_ir1_is
	.byte	2
	.word	LINE_1, LINE_86

	; FOR T=1 TO 4000

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pw
	.word	4000

	; NEXT

	.byte	bytecode_next

	; GOTO 110

	.byte	bytecode_goto_ix
	.word	LINE_110

LINE_98

	; MN-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_MN

	; POKE 16863,MN+48

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	48

	.byte	bytecode_poke_pw_ir1
	.word	16863

	; IF MN=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_MN

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_99

	; PRINT @0, "SCORE:";STR$(SC);" ";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	6, "SCORE:"

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; GOSUB 700

	.byte	bytecode_gosub_ix
	.word	LINE_700

	; GOSUB 3000

	.byte	bytecode_gosub_ix
	.word	LINE_3000

	; GOSUB 4000

	.byte	bytecode_gosub_ix
	.word	LINE_4000

	; GOTO 105

	.byte	bytecode_goto_ix
	.word	LINE_105

LINE_99

	; GOTO 97

	.byte	bytecode_goto_ix
	.word	LINE_97

LINE_100

	; DIM A$(11),B$(11),B$,A(16,8),B(16,8),K(255),J,T,K,X,Y,A,B,M,D,M(4),N(4),D(4),I(4),V(4),L(19,22),G(4),L,C,E,H,I,S

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_ld_ir2_pb
	.byte	8

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ir1_pb
	.byte	255

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_D

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_V

	.byte	bytecode_ld_ir1_pb
	.byte	19

	.byte	bytecode_ld_ir2_pb
	.byte	22

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_G

LINE_101

	; DIM X(100),Y(100),I,MN,XX,YY,A,I$

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Y

	; GOSUB 1000

	.byte	bytecode_gosub_ix
	.word	LINE_1000

	; FOR X=0 TO 15

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	15

	; FOR Y=0 TO 7

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	7

	; A(X,Y)=SHIFT(Y,6)+SHIFT(X,1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	6

	.byte	bytecode_dbl_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ip_ir1

	; B(X,Y)=SHIFT(Y,6)+SHIFT(X,1)+32

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	6

	.byte	bytecode_dbl_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	32

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_102

	; ZZ=RND(-TIMER)

	.byte	bytecode_timer_ir1

	.byte	bytecode_neg_ir1_ir1

	.byte	bytecode_rnd_fr1_ir1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_ZZ

LINE_105

	; MN=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	3

	; LV=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_LV

	; SC=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_SC

	; GOSUB 800

	.byte	bytecode_gosub_ix
	.word	LINE_800

LINE_110

	; RESTORE

	.byte	bytecode_restore

	; GOSUB 150

	.byte	bytecode_gosub_ix
	.word	LINE_150

	; GOSUB 200

	.byte	bytecode_gosub_ix
	.word	LINE_200

	; GOSUB 500

	.byte	bytecode_gosub_ix
	.word	LINE_500

	; GOSUB 700

	.byte	bytecode_gosub_ix
	.word	LINE_700

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_150

	; E=50

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_E
	.byte	50

	; EG=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_EG
	.byte	3

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

	; L=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_L
	.byte	4

	; S=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_S

	; LV+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_LV

	; IF FRACT(LV/6)=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LV

	.byte	bytecode_div_fr1_ir1_pb
	.byte	6

	.byte	bytecode_fract_fr1_fr1

	.byte	bytecode_jmpne_fr1_ix
	.word	LINE_160

	; MN+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_MN

LINE_160

	; IF MN>9 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	9
	.byte	bytecode_INTVAR_MN

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_170

	; MN=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	9

LINE_170

	; WHEN FRACT(LV/5)=0 GOSUB 190

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LV

	.byte	bytecode_div_fr1_ir1_pb
	.byte	5

	.byte	bytecode_fract_fr1_fr1

	.byte	bytecode_jsreq_fr1_ix
	.word	LINE_190

LINE_180

	; RETURN

	.byte	bytecode_return

LINE_190

	; CLS

	.byte	bytecode_cls

	; PRINT @233, "CHALLENGE STAGE";

	.byte	bytecode_prat_pb
	.byte	233

	.byte	bytecode_pr_ss
	.text	15, "CHALLENGE STAGE"

	; PRINT @290, "GET AS MANY EGGS AS YOU CAN!";

	.byte	bytecode_prat_pw
	.word	290

	.byte	bytecode_pr_ss
	.text	28, "GET AS MANY EGGS AS YOU CAN!"

LINE_195

	; E=56

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_E
	.byte	56

	; EG=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_EG
	.byte	10

	; Z=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Z
	.byte	3

	; L=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_L

	; FOR T=1 TO 25

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	25

	; SOUND (RND(10)*10)+20,1

	.byte	bytecode_irnd_ir1_pb
	.byte	10

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	10

	.byte	bytecode_add_ir1_ir1_pb
	.byte	20

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_200

	; CLS 3

	.byte	bytecode_clsn_pb
	.byte	3

	; X=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	4

	; Y=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	3

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; Y+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_Y

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; X(0)=X

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ip_ir1

	; Y(0)=Y

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; K=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_K

LINE_210

	; IF X<14 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	14

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_220

	; WHEN K(PEEK(A(X+2,Y)+M))=1 GOTO 260

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_260

LINE_220

	; IF X>1 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	1
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_230

	; WHEN K(PEEK(A(X-2,Y)+M))=1 GOTO 260

	.byte	bytecode_sub_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_260

LINE_230

	; IF Y<6 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	6

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_240

	; WHEN K(PEEK(A(X,Y+2)+M))=1 GOTO 260

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_260

LINE_240

	; IF Y>1 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	1
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_250

	; WHEN K(PEEK(A(X,Y-2)+M))=1 GOTO 260

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sub_ir2_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_260

LINE_250

	; GOTO 350

	.byte	bytecode_goto_ix
	.word	LINE_350

LINE_260

	; ON RND(4) GOTO 270,280,290,300

	.byte	bytecode_irnd_ir1_pb
	.byte	4

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_270, LINE_280, LINE_290, LINE_300

LINE_270

	; XX=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_XX

	; YY=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_YY

	; IF Y>1 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	1
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_275

	; IF K(PEEK(A(X,Y+YY+YY)+M))=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_275

	; FOR C=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	2

	; PRINT @A(X,(YY*C)+Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_mul_ir2_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,(YY*C)+Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_mul_ir2_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; NEXT

	.byte	bytecode_next

	; GOTO 330

	.byte	bytecode_goto_ix
	.word	LINE_330

LINE_275

	; GOTO 260

	.byte	bytecode_goto_ix
	.word	LINE_260

LINE_280

	; XX=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_XX

	; YY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_YY

	; IF Y<6 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	6

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_285

	; IF K(PEEK(A(X,Y+YY+YY)+M))=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_285

	; FOR C=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	2

	; PRINT @A(X,(YY*C)+Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_mul_ir2_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,(YY*C)+Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_mul_ir2_ir2_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir2_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; NEXT

	.byte	bytecode_next

	; GOTO 330

	.byte	bytecode_goto_ix
	.word	LINE_330

LINE_285

	; GOTO 260

	.byte	bytecode_goto_ix
	.word	LINE_260

LINE_290

	; XX=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_XX

	; YY=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_YY

	; IF X<14 THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	14

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_295

	; IF K(PEEK(A(X+XX+XX,Y)+M))=1 THEN

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_295

	; FOR C=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	2

	; PRINT @A((XX*C)+X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_mul_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B((XX*C)+X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_mul_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; NEXT

	.byte	bytecode_next

	; GOTO 330

	.byte	bytecode_goto_ix
	.word	LINE_330

LINE_295

	; GOTO 260

	.byte	bytecode_goto_ix
	.word	LINE_260

LINE_300

	; XX=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_XX

	; YY=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_YY

	; IF X>1 THEN

	.byte	bytecode_ldlt_ir1_pb_ix
	.byte	1
	.byte	bytecode_INTVAR_X

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_305

	; IF K(PEEK(A(X+XX+XX,Y)+M))=1 THEN

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_305

	; FOR C=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_to_ip_pb
	.byte	2

	; PRINT @A((XX*C)+X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_mul_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B((XX*C)+X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_mul_ir1_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; NEXT

	.byte	bytecode_next

	; GOTO 330

	.byte	bytecode_goto_ix
	.word	LINE_330

LINE_305

	; GOTO 260

	.byte	bytecode_goto_ix
	.word	LINE_260

LINE_330

	; X+=SHIFT(XX,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y+=SHIFT(YY,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_Y

	; X(K)=X

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ip_ir1

	; Y(K)=Y

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_ir1

	; K+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_K

	; GOTO 210

	.byte	bytecode_goto_ix
	.word	LINE_210

LINE_350

	; K-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_K

	; X=X(K)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=Y(K)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

LINE_360

	; WHEN K=0 GOTO 400

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_400

LINE_370

	; GOTO 210

	.byte	bytecode_goto_ix
	.word	LINE_210

LINE_400

	; K=17023

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_K
	.word	17023

	; Y=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	7

	; FOR T=1 TO LV+20

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_LV
	.byte	20

	.byte	bytecode_to_ip_ir1

	; X=RND(14)-1

	.byte	bytecode_irnd_ir1_pb
	.byte	14

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=RND(7)

	.byte	bytecode_irnd_ir1_pb
	.byte	7

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; GOSUB 2

	.byte	bytecode_gosub_ix
	.word	LINE_2

	; NEXT

	.byte	bytecode_next

	; X=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	15

	; FOR Y=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	6

	; ON RND(2) GOSUB 2

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_ongosub_ir1_is
	.byte	1
	.word	LINE_2

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_500

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; POKE 16862,12

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_poke_pw_ir1
	.word	16862

LINE_505

	; IF FRACT(LV/6)=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LV

	.byte	bytecode_div_fr1_ir1_pb
	.byte	6

	.byte	bytecode_fract_fr1_fr1

	.byte	bytecode_jmpne_fr1_ix
	.word	LINE_507

	; FOR T=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	5

	; POKE 16863,MN+112

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	112

	.byte	bytecode_poke_pw_ir1
	.word	16863

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; POKE 16863,MN+48

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	48

	.byte	bytecode_poke_pw_ir1
	.word	16863

	; SOUND 225,1

	.byte	bytecode_ld_ir1_pb
	.byte	225

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

LINE_507

	; POKE 16863,MN+48

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	48

	.byte	bytecode_poke_pw_ir1
	.word	16863

	; LV$=RIGHT$(STR$(LV),2)

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_LV

	.byte	bytecode_right_sr1_sr1_pb
	.byte	2

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_LV

	; POKE 16894,ASC(MID$(LV$,1,1))

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_LV

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_asc_ir1_sr1

	.byte	bytecode_poke_pw_ir1
	.word	16894

	; POKE 16895,ASC(MID$(LV$,2,1))

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_LV

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_asc_ir1_sr1

	.byte	bytecode_poke_pw_ir1
	.word	16895

LINE_510

	; FOR J=1 TO L

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_L

	; GOSUB 550

	.byte	bytecode_gosub_ix
	.word	LINE_550

	; NEXT

	.byte	bytecode_next

LINE_520

	; FOR J=1 TO EG

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_EG

LINE_530

	; D=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	4

	; X=RND(16)-1

	.byte	bytecode_irnd_ir1_pb
	.byte	16

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=RND(7)-1

	.byte	bytecode_irnd_ir1_pb
	.byte	7

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; ON K(PEEK(A(X,Y)+M)) GOTO 530,530,530,530,530

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_530, LINE_530, LINE_530, LINE_530, LINE_530

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; NEXT

	.byte	bytecode_next

LINE_540

	; D=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	5

	; X=RND(14)

	.byte	bytecode_irnd_ir1_pb
	.byte	14

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=RND(6)

	.byte	bytecode_irnd_ir1_pb
	.byte	6

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; ON K(PEEK(A(X,Y)+M)) GOTO 540,540,540,540,540

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_540, LINE_540, LINE_540, LINE_540, LINE_540

	; GOTO 570

	.byte	bytecode_goto_ix
	.word	LINE_570

LINE_550

	; M(J)=RND(15)-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_irnd_ir1_pb
	.byte	15

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; N(J)=RND(8)-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_irnd_ir1_pb
	.byte	8

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; ON K(PEEK(A(M(J),N(J))+M)) GOTO 550,550,550,550,550

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_550, LINE_550, LINE_550, LINE_550, LINE_550

	; PRINT @A(M(J),N(J)), A$(1);

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

LINE_560

	; PRINT @B(M(J),N(J)), B$(1);

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_M
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; V(J)=RND(4)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_J

	.byte	bytecode_irnd_ir1_pb
	.byte	4

	.byte	bytecode_ld_ip_ir1

	; G(J)=2

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ip_pb
	.byte	2

	; RETURN

	.byte	bytecode_return

LINE_570

	; ON K(PEEK(A(X-1,Y)+M)) GOTO 575,575,540

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	3
	.word	LINE_575, LINE_575, LINE_540

LINE_575

	; ON K(PEEK(A(X+1,Y)+M)) GOTO 580,580,540

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	3
	.word	LINE_580, LINE_580, LINE_540

LINE_580

	; ON K(PEEK(A(X,Y-1)+M)) GOTO 590,590,540

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	3
	.word	LINE_590, LINE_590, LINE_540

LINE_590

	; ON K(PEEK(A(X,Y+1)+M)) GOTO 595,595,540

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	3
	.word	LINE_595, LINE_595, LINE_540

LINE_595

	; GOTO 3

	.byte	bytecode_goto_ix
	.word	LINE_3

LINE_600

LINE_610

LINE_620

LINE_630

LINE_640

LINE_650

LINE_660

LINE_670

LINE_700

	; READ A,B

	.byte	bytecode_read_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_read_ix
	.byte	bytecode_INTVAR_B

LINE_710

	; IF (A<0) AND (B<0) THEN

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	0

	.byte	bytecode_ldlt_ir2_ix_pb
	.byte	bytecode_INTVAR_B
	.byte	0

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_720

	; RETURN

	.byte	bytecode_return

LINE_720

	; SOUND A,B

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_sound_ir1_ir2

LINE_740

	; GOTO 700

	.byte	bytecode_goto_ix
	.word	LINE_700

LINE_800

	; WHEN SF=1 GOTO 820

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_SF
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_820

LINE_810

	; SF=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_SF

	; GOSUB 2000

	.byte	bytecode_gosub_ix
	.word	LINE_2000

	; X=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	14

	; Y=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	; D=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_D

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; X=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	14

	; Y=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	4

	; D=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	3

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; X=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	14

	; Y=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	6

	; D=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	4

	; GOSUB 3

	.byte	bytecode_gosub_ix
	.word	LINE_3

	; PRINT @496, "p=PLAY s=SCORES";

	.byte	bytecode_prat_pw
	.word	496

	.byte	bytecode_pr_ss
	.text	15, "p=PLAY s=SCORES"

	; GOTO 890

	.byte	bytecode_goto_ix
	.word	LINE_890

LINE_820

	; GOSUB 2000

	.byte	bytecode_gosub_ix
	.word	LINE_2000

	; GOSUB 3100

	.byte	bytecode_gosub_ix
	.word	LINE_3100

	; PRINT @496, "p=PLAY h=HELP  ";

	.byte	bytecode_prat_pw
	.word	496

	.byte	bytecode_pr_ss
	.text	15, "p=PLAY h=HELP  "

LINE_890

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; WHEN I$="" GOTO 890

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_890

LINE_891

	; WHEN I$="P" GOTO 896

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "P"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_896

LINE_892

	; WHEN I$="H" GOTO 810

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "H"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_810

LINE_893

	; WHEN I$="S" GOTO 820

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "S"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_820

LINE_894

	; IF I$="Q" THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "Q"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_895

	; END

	.byte	bytecode_progend

LINE_895

	; GOTO 890

	.byte	bytecode_goto_ix
	.word	LINE_890

LINE_896

	; RETURN

	.byte	bytecode_return

LINE_1000

	; A$(1)="žž"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x9E\x9E"

	.byte	bytecode_ld_sp_sr1

LINE_1010

	; B$(1)="Ÿ—"

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x9F\x97"

	.byte	bytecode_ld_sp_sr1

LINE_1020

	; A$(2)=""

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x9D\x9D"

	.byte	bytecode_ld_sp_sr1

LINE_1030

	; B$(2)="›Ÿ"

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x9B\x9F"

	.byte	bytecode_ld_sp_sr1

LINE_1040

	; A$(3)="¯¯"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xAF\xAF"

	.byte	bytecode_ld_sp_sr1

LINE_1050

	; B$(3)="¯¯"

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xAF\xAF"

	.byte	bytecode_ld_sp_sr1

LINE_1060

	; A$(4)="ÇË"

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xC7\xCB"

	.byte	bytecode_ld_sp_sr1

LINE_1070

	; B$(4)="ÍÎ"

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xCD\xCE"

	.byte	bytecode_ld_sp_sr1

LINE_1100

	; A$(5)="µ»"

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB5\xBB"

	.byte	bytecode_ld_sp_sr1

LINE_1110

	; B$(5)="¶¹"

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB6\xB9"

	.byte	bytecode_ld_sp_sr1

LINE_1130

	; A$(6)="·º"

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB7\xBA"

	.byte	bytecode_ld_sp_sr1

LINE_1140

	; B$(6)="¶¹"

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB6\xB9"

	.byte	bytecode_ld_sp_sr1

LINE_1160

	; A$(7)="·»"

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB7\xBB"

	.byte	bytecode_ld_sp_sr1

LINE_1170

	; B$(7)="¶¹"

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB6\xB9"

	.byte	bytecode_ld_sp_sr1

LINE_1190

	; A$(8)="¹¶"

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB9\xB6"

	.byte	bytecode_ld_sp_sr1

LINE_1200

	; B$(8)="½¾"

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xBD\xBE"

	.byte	bytecode_ld_sp_sr1

LINE_1210

	; B$="°°"

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB0\xB0"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_B

LINE_1220

	; A$(9)="¹¹"

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB9\xB9"

	.byte	bytecode_ld_sp_sr1

LINE_1230

	; B$(9)="¹¹"

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xB9\xB9"

	.byte	bytecode_ld_sp_sr1

LINE_1240

	; A$(10)="©©"

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xA9\xA9"

	.byte	bytecode_ld_sp_sr1

LINE_1250

	; B$(10)="©©"

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_sr1_ss
	.text	2, "\xA9\xA9"

	.byte	bytecode_ld_sp_sr1

LINE_1300

	; K(65)=1

	.byte	bytecode_ld_ir1_pb
	.byte	65

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_one_ip

	; K(83)=2

	.byte	bytecode_ld_ir1_pb
	.byte	83

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(87)=3

	.byte	bytecode_ld_ir1_pb
	.byte	87

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	3

	; K(90)=4

	.byte	bytecode_ld_ir1_pb
	.byte	90

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	4

	; K(71)=1

	.byte	bytecode_ld_ir1_pb
	.byte	71

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_one_ip

	; K(74)=2

	.byte	bytecode_ld_ir1_pb
	.byte	74

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(89)=3

	.byte	bytecode_ld_ir1_pb
	.byte	89

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	3

	; K(72)=4

	.byte	bytecode_ld_ir1_pb
	.byte	72

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	4

LINE_1310

	; M=16384

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_M
	.word	16384

LINE_1320

	; K(175)=1

	.byte	bytecode_ld_ir1_pb
	.byte	175

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_one_ip

	; K(199)=2

	.byte	bytecode_ld_ir1_pb
	.byte	199

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(157)=3

	.byte	bytecode_ld_ir1_pb
	.byte	157

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	3

	; K(158)=3

	.byte	bytecode_ld_ir1_pb
	.byte	158

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	3

	; K(12)=4

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	4

	; K(181)=5

	.byte	bytecode_ld_ir1_pb
	.byte	181

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	5

	; K(183)=5

	.byte	bytecode_ld_ir1_pb
	.byte	183

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	5

LINE_1330

	; D(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_D

	.byte	bytecode_one_ip

	; I(1)=0

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_I

	.byte	bytecode_clr_ip

	; D(2)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_D

	.byte	bytecode_true_ip

	; I(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_I

	.byte	bytecode_clr_ip

	; D(3)=0

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_D

	.byte	bytecode_clr_ip

	; I(3)=1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_I

	.byte	bytecode_one_ip

	; D(4)=0

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_D

	.byte	bytecode_clr_ip

	; I(4)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_I

	.byte	bytecode_true_ip

LINE_1400

	; FOR X=0 TO 19

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	19

	; FOR Y=0 TO 11

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	11

	; L(X,Y)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_one_ip

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_1410

	; FOR X=2 TO 17

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	17

	; FOR Y=2 TO 9

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	9

	; L(X,Y)=2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_L
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ip_pb
	.byte	2

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; FOR X=1 TO 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	10

	; NM$(X)="---"

	.byte	bytecode_arrref1_ir1_sx_id
	.byte	bytecode_STRARR_NM
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_sr1_ss
	.text	3, "---"

	.byte	bytecode_ld_sp_sr1

	; NEXT

	.byte	bytecode_next

LINE_1500

	; RETURN

	.byte	bytecode_return

LINE_2000

	; CLS

	.byte	bytecode_cls

LINE_2001

	; PRINT "    PENGUINO    BY JIM GERRIE\r";

	.byte	bytecode_pr_ss
	.text	30, "    PENGUINO    BY JIM GERRIE\r"

LINE_2005

	; PRINT "      ÀÀÀÀ      RETROSPECTIVA\r";

	.byte	bytecode_pr_ss
	.text	30, "      \xC0\xC0\xC0\xC0      RETROSPECTIVA\r"

LINE_2010

	; PRINT "     ÀÀÀÀÀÀ     BASIC GAME\r";

	.byte	bytecode_pr_ss
	.text	27, "     \xC0\xC0\xC0\xC0\xC0\xC0     BASIC GAME\r"

LINE_2020

	; PRINT "    ÏÏÏÀÀÏÏÏ    CONTEST 2012\r";

	.byte	bytecode_pr_ss
	.text	29, "    \xCF\xCF\xCF\xC0\xC0\xCF\xCF\xCF    CONTEST 2012\r"

LINE_2030

	; PRINT "    ÏÀÏÀÀÏÀÏ       \r";

	.byte	bytecode_pr_ss
	.text	20, "    \xCF\xC0\xCF\xC0\xC0\xCF\xC0\xCF       \r"

LINE_2040

	; PRINT "    ÏÏÏÀÿÏÏÏ    SQUASH\r";

	.byte	bytecode_pr_ss
	.text	23, "    \xCF\xCF\xCF\xC0\xFF\xCF\xCF\xCF    SQUASH\r"

LINE_2050

	; PRINT "     ÏÏÏÏÏÏ     SNOW-BEES 100PTS";

	.byte	bytecode_pr_ss
	.text	32, "     \xCF\xCF\xCF\xCF\xCF\xCF     SNOW-BEES 100PTS"

LINE_2060

	; PRINT "     ¿ÏÏÏÏ¿     BY PUSHING\r";

	.byte	bytecode_pr_ss
	.text	27, "     \xBF\xCF\xCF\xCF\xCF\xBF     BY PUSHING\r"

LINE_2070

	; PRINT "    °¿¿¿¿¿¿°    ICE BLOCKS.\r";

	.byte	bytecode_pr_ss
	.text	28, "    \xB0\xBF\xBF\xBF\xBF\xBF\xBF\xB0    ICE BLOCKS.\r"

LINE_2080

	; PRINT "   °¿¿¿¿¿¿¿¿°   COLLECT\r";

	.byte	bytecode_pr_ss
	.text	24, "   \xB0\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xB0   COLLECT\r"

LINE_2090

	; PRINT "   °¿¿¿¿¿¿¿¿°   PENGUIN \r";

	.byte	bytecode_pr_ss
	.text	25, "   \xB0\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xB0   PENGUIN \r"

LINE_2100

	; PRINT "  °°¿¿¿¿¿¿¿¿°°  EGGS FOR 500PTS\r";

	.byte	bytecode_pr_ss
	.text	32, "  \xB0\xB0\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xB0\xB0  EGGS FOR 500PTS\r"

LINE_2110

	; PRINT "   ¿¿¿¿¿¿¿¿¿¿   USE:   W\r";

	.byte	bytecode_pr_ss
	.text	25, "   \xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF   USE:   W\r"

LINE_2120

	; PRINT "    ¿¿¿¿¿¿¿¿         A S D\r";

	.byte	bytecode_pr_ss
	.text	27, "    \xBF\xBF\xBF\xBF\xBF\xBF\xBF\xBF         A S D\r"

LINE_2130

	; PRINT "     ¿¿¿¿¿¿\r";

	.byte	bytecode_pr_ss
	.text	12, "     \xBF\xBF\xBF\xBF\xBF\xBF\r"

LINE_2140

	; PRINT "    ÿÿÿ¿¿ÿÿÿ";

	.byte	bytecode_pr_ss
	.text	12, "    \xFF\xFF\xFF\xBF\xBF\xFF\xFF\xFF"

	; RETURN

	.byte	bytecode_return

LINE_3000

	; SW=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_SW

LINE_3010

	; FOR I=1 TO 9

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_to_ip_pb
	.byte	9

	; IF HS(I)<HS(I+1) THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_HS
	.byte	bytecode_INTVAR_I

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_HS

	.byte	bytecode_ldlt_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_3030

	; TM=HS(I)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_HS
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_TM

	; TM$=NM$(I)

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_NM
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_TM

	; HS(I)=HS(I+1)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_HS
	.byte	bytecode_INTVAR_I

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_HS

	.byte	bytecode_ld_ip_ir1

	; NM$(I)=NM$(I+1)

	.byte	bytecode_arrref1_ir1_sx_id
	.byte	bytecode_STRARR_NM
	.byte	bytecode_INTVAR_I

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_NM

	.byte	bytecode_ld_sp_sr1

	; HS(I+1)=TM

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_HS

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_TM

	.byte	bytecode_ld_ip_ir1

	; NM$(I+1)=TM$

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrref1_ir1_sx_ir1
	.byte	bytecode_STRARR_NM

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_TM

	.byte	bytecode_ld_sp_sr1

	; SW+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_SW

LINE_3030

	; NEXT

	.byte	bytecode_next

LINE_3090

	; WHEN SW<>0 GOTO 3000

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SW

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_3000

LINE_3095

	; RETURN

	.byte	bytecode_return

LINE_3100

	; PRINT @48, "     TOP 10     ";

	.byte	bytecode_prat_pb
	.byte	48

	.byte	bytecode_pr_ss
	.text	16, "     TOP 10     "

	; PRINT @80, "   HIGH SCORES  ";

	.byte	bytecode_prat_pb
	.byte	80

	.byte	bytecode_pr_ss
	.text	16, "   HIGH SCORES  "

	; PRINT @112, "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯";

	.byte	bytecode_prat_pb
	.byte	112

	.byte	bytecode_pr_ss
	.text	16, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_3110

	; FOR A=1 TO 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_to_ip_pb
	.byte	10

	; PRINT @SHIFT(A+3,5)+16, "¯              ¯";

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	3

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_add_ir1_ir1_pb
	.byte	16

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_ss
	.text	16, "\xAF              \xAF"

	; NEXT

	.byte	bytecode_next

LINE_3120

	; PRINT @464, "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯";

	.byte	bytecode_prat_pw
	.word	464

	.byte	bytecode_pr_ss
	.text	16, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_3200

	; FOR A=1 TO 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_to_ip_pb
	.byte	10

	; PRINT @SHIFT(A+3,5)+17, MID$(STR$(A)+"  ",1,4);NM$(A);STR$(HS(A));" ";

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_A
	.byte	3

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_add_ir1_ir1_pb
	.byte	17

	.byte	bytecode_prat_ir1

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_strinit_sr1_sr1

	.byte	bytecode_strcat_sr1_sr1_ss
	.text	2, "  "

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	4

	.byte	bytecode_pr_sr1

	.byte	bytecode_arrval1_ir1_sx_id
	.byte	bytecode_STRARR_NM
	.byte	bytecode_INTVAR_A

	.byte	bytecode_pr_sr1

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_HS
	.byte	bytecode_INTVAR_A

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; NEXT

	.byte	bytecode_next

LINE_3210

	; RETURN

	.byte	bytecode_return

LINE_4000

	; WHEN HS(10)<SC GOTO 4050

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_HS

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_4050

LINE_4020

	; RETURN

	.byte	bytecode_return

LINE_4050

	; CLS

	.byte	bytecode_cls

	; PRINT "YOU MADE THE TOP 10!\r";

	.byte	bytecode_pr_ss
	.text	21, "YOU MADE THE TOP 10!\r"

LINE_4060

	; INPUT "INITIALS (MAX 3)"; TM$

	.byte	bytecode_pr_ss
	.text	16, "INITIALS (MAX 3)"

	.byte	bytecode_input

	.byte	bytecode_readbuf_sx
	.byte	bytecode_STRVAR_TM

	.byte	bytecode_ignxtra

	; NM$=LEFT$(TM$+"   ",3)

	.byte	bytecode_strinit_sr1_sx
	.byte	bytecode_STRVAR_TM

	.byte	bytecode_strcat_sr1_sr1_ss
	.text	3, "   "

	.byte	bytecode_left_sr1_sr1_pb
	.byte	3

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_NM

	; IF (NM$="ASS") OR (NM$="FUC") OR (NM$="BUM") OR (NM$="CFG") THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_NM
	.text	3, "ASS"

	.byte	bytecode_ldeq_ir2_sx_ss
	.byte	bytecode_STRVAR_NM
	.text	3, "FUC"

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir2_sx_ss
	.byte	bytecode_STRVAR_NM
	.text	3, "BUM"

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ldeq_ir2_sx_ss
	.byte	bytecode_STRVAR_NM
	.text	3, "CFG"

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_4070

	; NM$="!@#"

	.byte	bytecode_ld_sr1_ss
	.text	3, "!@#"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_NM

LINE_4070

	; FOR X=10 TO 1 STEP -1

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	10

	.byte	bytecode_to_ip_pb
	.byte	1

	.byte	bytecode_ld_ir1_nb
	.byte	-1

	.byte	bytecode_step_ip_ir1

LINE_4080

	; IF (HS(X-1)<SC) AND (X>1) THEN

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_HS

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ldlt_ir2_pb_ix
	.byte	1
	.byte	bytecode_INTVAR_X

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_4090

	; HS(X)=HS(X-1)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_HS
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_HS

	.byte	bytecode_ld_ip_ir1

	; NM$(X)=NM$(X-1)

	.byte	bytecode_arrref1_ir1_sx_id
	.byte	bytecode_STRARR_NM
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrval1_ir1_sx_ir1
	.byte	bytecode_STRARR_NM

	.byte	bytecode_ld_sp_sr1

	; GOTO 4100

	.byte	bytecode_goto_ix
	.word	LINE_4100

LINE_4090

	; HS(X)=SC

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_HS
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ld_ip_ir1

	; NM$(X)=NM$

	.byte	bytecode_arrref1_ir1_sx_id
	.byte	bytecode_STRARR_NM
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_NM

	.byte	bytecode_ld_sp_sr1

	; X=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_X

LINE_4100

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_ir1_ir1_ir2	.equ	0
bytecode_add_ir1_ir1_ix	.equ	1
bytecode_add_ir1_ir1_pb	.equ	2
bytecode_add_ir1_ix_id	.equ	3
bytecode_add_ir1_ix_pb	.equ	4
bytecode_add_ir2_ir2_ix	.equ	5
bytecode_add_ir2_ix_id	.equ	6
bytecode_add_ir2_ix_pb	.equ	7
bytecode_add_ix_ix_ir1	.equ	8
bytecode_add_ix_ix_pw	.equ	9
bytecode_and_ir1_ir1_ir2	.equ	10
bytecode_and_ir1_ir1_pb	.equ	11
bytecode_arrdim1_ir1_ix	.equ	12
bytecode_arrdim1_ir1_sx	.equ	13
bytecode_arrdim2_ir1_ix	.equ	14
bytecode_arrref1_ir1_ix_id	.equ	15
bytecode_arrref1_ir1_ix_ir1	.equ	16
bytecode_arrref1_ir1_sx_id	.equ	17
bytecode_arrref1_ir1_sx_ir1	.equ	18
bytecode_arrref2_ir1_ix_id	.equ	19
bytecode_arrval1_ir1_ix_id	.equ	20
bytecode_arrval1_ir1_ix_ir1	.equ	21
bytecode_arrval1_ir1_sx_id	.equ	22
bytecode_arrval1_ir1_sx_ir1	.equ	23
bytecode_arrval1_ir2_ix_id	.equ	24
bytecode_arrval1_ir2_ix_ir2	.equ	25
bytecode_arrval1_ir3_ix_id	.equ	26
bytecode_arrval2_ir1_ix_id	.equ	27
bytecode_arrval2_ir1_ix_ir2	.equ	28
bytecode_asc_ir1_sr1	.equ	29
bytecode_clear	.equ	30
bytecode_clr_ip	.equ	31
bytecode_clr_ix	.equ	32
bytecode_cls	.equ	33
bytecode_clsn_pb	.equ	34
bytecode_com_ir1_ir1	.equ	35
bytecode_dbl_ir1_ix	.equ	36
bytecode_dbl_ir2_ix	.equ	37
bytecode_dec_ir1_ir1	.equ	38
bytecode_dec_ir1_ix	.equ	39
bytecode_dec_ir2_ix	.equ	40
bytecode_dec_ix_ix	.equ	41
bytecode_div_fr1_ir1_pb	.equ	42
bytecode_for_ix_ir1	.equ	43
bytecode_for_ix_pb	.equ	44
bytecode_forclr_ix	.equ	45
bytecode_forone_fx	.equ	46
bytecode_forone_ix	.equ	47
bytecode_fract_fr1_fr1	.equ	48
bytecode_gosub_ix	.equ	49
bytecode_goto_ix	.equ	50
bytecode_ignxtra	.equ	51
bytecode_inc_ir1_ix	.equ	52
bytecode_inc_ir2_ix	.equ	53
bytecode_inc_ix_ix	.equ	54
bytecode_inkey_sx	.equ	55
bytecode_input	.equ	56
bytecode_irnd_ir1_pb	.equ	57
bytecode_jmpeq_ir1_ix	.equ	58
bytecode_jmpne_fr1_ix	.equ	59
bytecode_jmpne_ir1_ix	.equ	60
bytecode_jsreq_fr1_ix	.equ	61
bytecode_ld_fx_fr1	.equ	62
bytecode_ld_ip_ir1	.equ	63
bytecode_ld_ip_pb	.equ	64
bytecode_ld_ir1_ix	.equ	65
bytecode_ld_ir1_nb	.equ	66
bytecode_ld_ir1_pb	.equ	67
bytecode_ld_ir2_ix	.equ	68
bytecode_ld_ir2_pb	.equ	69
bytecode_ld_ix_ir1	.equ	70
bytecode_ld_ix_pb	.equ	71
bytecode_ld_ix_pw	.equ	72
bytecode_ld_sp_sr1	.equ	73
bytecode_ld_sr1_ss	.equ	74
bytecode_ld_sr1_sx	.equ	75
bytecode_ld_sx_sr1	.equ	76
bytecode_ldeq_ir1_ir1_ix	.equ	77
bytecode_ldeq_ir1_ir1_pb	.equ	78
bytecode_ldeq_ir1_ix_pb	.equ	79
bytecode_ldeq_ir1_sx_ss	.equ	80
bytecode_ldeq_ir2_ir2_ir3	.equ	81
bytecode_ldeq_ir2_sx_ss	.equ	82
bytecode_ldge_ir1_ix_pb	.equ	83
bytecode_ldlt_ir1_ir1_ir2	.equ	84
bytecode_ldlt_ir1_ir1_ix	.equ	85
bytecode_ldlt_ir1_ix_pb	.equ	86
bytecode_ldlt_ir1_pb_ix	.equ	87
bytecode_ldlt_ir2_ix_pb	.equ	88
bytecode_ldlt_ir2_pb_ix	.equ	89
bytecode_ldne_ir1_ir1_ir2	.equ	90
bytecode_ldne_ir2_ir2_ix	.equ	91
bytecode_left_sr1_sr1_pb	.equ	92
bytecode_midT_sr1_sr1_pb	.equ	93
bytecode_mul_ir1_ir1_ix	.equ	94
bytecode_mul_ir1_ir1_pb	.equ	95
bytecode_mul_ir2_ir2_ix	.equ	96
bytecode_neg_ir1_ir1	.equ	97
bytecode_next	.equ	98
bytecode_one_ip	.equ	99
bytecode_one_ix	.equ	100
bytecode_ongosub_ir1_is	.equ	101
bytecode_ongoto_ir1_is	.equ	102
bytecode_or_ir1_ir1_ir2	.equ	103
bytecode_peek2_ir1	.equ	104
bytecode_peek_ir1_ir1	.equ	105
bytecode_peek_ir1_pw	.equ	106
bytecode_poke_pw_ir1	.equ	107
bytecode_pr_sr1	.equ	108
bytecode_pr_ss	.equ	109
bytecode_pr_sx	.equ	110
bytecode_prat_ir1	.equ	111
bytecode_prat_pb	.equ	112
bytecode_prat_pw	.equ	113
bytecode_progbegin	.equ	114
bytecode_progend	.equ	115
bytecode_read_ix	.equ	116
bytecode_readbuf_sx	.equ	117
bytecode_restore	.equ	118
bytecode_return	.equ	119
bytecode_right_sr1_sr1_pb	.equ	120
bytecode_rnd_fr1_ir1	.equ	121
bytecode_rsub_ir1_ir1_pb	.equ	122
bytecode_rsub_ir2_ir2_ix	.equ	123
bytecode_sgn_ir2_ir2	.equ	124
bytecode_shift_ir1_ir1_pb	.equ	125
bytecode_sound_ir1_ir2	.equ	126
bytecode_sq_ir1_ix	.equ	127
bytecode_step_ip_ir1	.equ	128
bytecode_stop	.equ	129
bytecode_str_sr1_ir1	.equ	130
bytecode_str_sr1_ix	.equ	131
bytecode_strcat_sr1_sr1_ss	.equ	132
bytecode_strinit_sr1_sr1	.equ	133
bytecode_strinit_sr1_sx	.equ	134
bytecode_sub_ir1_ir1_ix	.equ	135
bytecode_sub_ir1_ix_pb	.equ	136
bytecode_sub_ir2_ix_pb	.equ	137
bytecode_timer_ir1	.equ	138
bytecode_to_fp_pw	.equ	139
bytecode_to_ip_ir1	.equ	140
bytecode_to_ip_ix	.equ	141
bytecode_to_ip_pb	.equ	142
bytecode_to_ip_pw	.equ	143
bytecode_true_ip	.equ	144
bytecode_true_ix	.equ	145

catalog
	.word	add_ir1_ir1_ir2
	.word	add_ir1_ir1_ix
	.word	add_ir1_ir1_pb
	.word	add_ir1_ix_id
	.word	add_ir1_ix_pb
	.word	add_ir2_ir2_ix
	.word	add_ir2_ix_id
	.word	add_ir2_ix_pb
	.word	add_ix_ix_ir1
	.word	add_ix_ix_pw
	.word	and_ir1_ir1_ir2
	.word	and_ir1_ir1_pb
	.word	arrdim1_ir1_ix
	.word	arrdim1_ir1_sx
	.word	arrdim2_ir1_ix
	.word	arrref1_ir1_ix_id
	.word	arrref1_ir1_ix_ir1
	.word	arrref1_ir1_sx_id
	.word	arrref1_ir1_sx_ir1
	.word	arrref2_ir1_ix_id
	.word	arrval1_ir1_ix_id
	.word	arrval1_ir1_ix_ir1
	.word	arrval1_ir1_sx_id
	.word	arrval1_ir1_sx_ir1
	.word	arrval1_ir2_ix_id
	.word	arrval1_ir2_ix_ir2
	.word	arrval1_ir3_ix_id
	.word	arrval2_ir1_ix_id
	.word	arrval2_ir1_ix_ir2
	.word	asc_ir1_sr1
	.word	clear
	.word	clr_ip
	.word	clr_ix
	.word	cls
	.word	clsn_pb
	.word	com_ir1_ir1
	.word	dbl_ir1_ix
	.word	dbl_ir2_ix
	.word	dec_ir1_ir1
	.word	dec_ir1_ix
	.word	dec_ir2_ix
	.word	dec_ix_ix
	.word	div_fr1_ir1_pb
	.word	for_ix_ir1
	.word	for_ix_pb
	.word	forclr_ix
	.word	forone_fx
	.word	forone_ix
	.word	fract_fr1_fr1
	.word	gosub_ix
	.word	goto_ix
	.word	ignxtra
	.word	inc_ir1_ix
	.word	inc_ir2_ix
	.word	inc_ix_ix
	.word	inkey_sx
	.word	input
	.word	irnd_ir1_pb
	.word	jmpeq_ir1_ix
	.word	jmpne_fr1_ix
	.word	jmpne_ir1_ix
	.word	jsreq_fr1_ix
	.word	ld_fx_fr1
	.word	ld_ip_ir1
	.word	ld_ip_pb
	.word	ld_ir1_ix
	.word	ld_ir1_nb
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ld_ix_pw
	.word	ld_sp_sr1
	.word	ld_sr1_ss
	.word	ld_sr1_sx
	.word	ld_sx_sr1
	.word	ldeq_ir1_ir1_ix
	.word	ldeq_ir1_ir1_pb
	.word	ldeq_ir1_ix_pb
	.word	ldeq_ir1_sx_ss
	.word	ldeq_ir2_ir2_ir3
	.word	ldeq_ir2_sx_ss
	.word	ldge_ir1_ix_pb
	.word	ldlt_ir1_ir1_ir2
	.word	ldlt_ir1_ir1_ix
	.word	ldlt_ir1_ix_pb
	.word	ldlt_ir1_pb_ix
	.word	ldlt_ir2_ix_pb
	.word	ldlt_ir2_pb_ix
	.word	ldne_ir1_ir1_ir2
	.word	ldne_ir2_ir2_ix
	.word	left_sr1_sr1_pb
	.word	midT_sr1_sr1_pb
	.word	mul_ir1_ir1_ix
	.word	mul_ir1_ir1_pb
	.word	mul_ir2_ir2_ix
	.word	neg_ir1_ir1
	.word	next
	.word	one_ip
	.word	one_ix
	.word	ongosub_ir1_is
	.word	ongoto_ir1_is
	.word	or_ir1_ir1_ir2
	.word	peek2_ir1
	.word	peek_ir1_ir1
	.word	peek_ir1_pw
	.word	poke_pw_ir1
	.word	pr_sr1
	.word	pr_ss
	.word	pr_sx
	.word	prat_ir1
	.word	prat_pb
	.word	prat_pw
	.word	progbegin
	.word	progend
	.word	read_ix
	.word	readbuf_sx
	.word	restore
	.word	return
	.word	right_sr1_sr1_pb
	.word	rnd_fr1_ir1
	.word	rsub_ir1_ir1_pb
	.word	rsub_ir2_ir2_ix
	.word	sgn_ir2_ir2
	.word	shift_ir1_ir1_pb
	.word	sound_ir1_ir2
	.word	sq_ir1_ix
	.word	step_ip_ir1
	.word	stop
	.word	str_sr1_ir1
	.word	str_sr1_ix
	.word	strcat_sr1_sr1_ss
	.word	strinit_sr1_sr1
	.word	strinit_sr1_sx
	.word	sub_ir1_ir1_ix
	.word	sub_ir1_ix_pb
	.word	sub_ir2_ix_pb
	.word	timer_ir1
	.word	to_fp_pw
	.word	to_ip_ir1
	.word	to_ip_ix
	.word	to_ip_pb
	.word	to_ip_pw
	.word	true_ip
	.word	true_ix

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

	.module	mdrpsword
; read DATA when records are purely signed words
; EXIT:  flt in tmp1+1, tmp2, tmp3
rpsword
	pshx
	ldx	DP_DATA
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldd	,x
	inx
	inx
	stx	DP_DATA
	std	tmp2
	clrb
	stab	tmp3
	stab	tmp3+1
	lsla
	sbcb	#0
	stab	tmp1+1
	pulx
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

add_ir1_ir1_ix			; numCalls = 37
	.module	modadd_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 4
	.module	modadd_ir1_ir1_pb
	jsr	getbyte
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 3
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

add_ir1_ix_pb			; numCalls = 15
	.module	modadd_ir1_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir2_ir2_ix			; numCalls = 6
	.module	modadd_ir2_ir2_ix
	jsr	extend
	ldd	r2+1
	addd	1,x
	std	r2+1
	ldab	r2
	adcb	0,x
	stab	r2
	rts

add_ir2_ix_id			; numCalls = 2
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

add_ir2_ix_pb			; numCalls = 6
	.module	modadd_ir2_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r2+1
	ldab	#0
	adcb	0,x
	stab	r2
	rts

add_ix_ix_ir1			; numCalls = 3
	.module	modadd_ix_ix_ir1
	jsr	extend
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pw			; numCalls = 5
	.module	modadd_ix_ix_pw
	jsr	extword
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 4
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

and_ir1_ir1_pb			; numCalls = 4
	.module	modand_ir1_ir1_pb
	jsr	getbyte
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

arrdim1_ir1_ix			; numCalls = 9
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

arrdim2_ir1_ix			; numCalls = 3
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

arrref1_ir1_ix_id			; numCalls = 22
	.module	modarrref1_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 26
	.module	modarrref1_ir1_ix_ir1
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx_id			; numCalls = 4
	.module	modarrref1_ir1_sx_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx_ir1			; numCalls = 21
	.module	modarrref1_ir1_sx_ir1
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_ix_id			; numCalls = 4
	.module	modarrref2_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 26
	.module	modarrval1_ir1_ix_id
	jsr	extdex
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

arrval1_ir1_ix_ir1			; numCalls = 35
	.module	modarrval1_ir1_ix_ir1
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

arrval1_ir1_sx_id			; numCalls = 6
	.module	modarrval1_ir1_sx_id
	jsr	extdex
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

arrval1_ir1_sx_ir1			; numCalls = 32
	.module	modarrval1_ir1_sx_ir1
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

arrval1_ir2_ix_id			; numCalls = 17
	.module	modarrval1_ir2_ix_id
	jsr	extdex
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

arrval1_ir3_ix_id			; numCalls = 2
	.module	modarrval1_ir3_ix_id
	jsr	extdex
	jsr	getlw
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

arrval2_ir1_ix_id			; numCalls = 72
	.module	modarrval2_ir1_ix_id
	jsr	extdex
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

arrval2_ir1_ix_ir2			; numCalls = 41
	.module	modarrval2_ir1_ix_ir2
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

asc_ir1_sr1			; numCalls = 2
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

clr_ip			; numCalls = 8
	.module	modclr_ip
	jsr	noargs
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 15
	.module	modclr_ix
	jsr	extend
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 4
	.module	modcls
	jsr	noargs
	jmp	R_CLS

clsn_pb			; numCalls = 1
	.module	modclsn_pb
	jsr	getbyte
	jmp	R_CLSN

com_ir1_ir1			; numCalls = 4
	.module	modcom_ir1_ir1
	jsr	noargs
	com	r1+2
	com	r1+1
	com	r1
	rts

dbl_ir1_ix			; numCalls = 2
	.module	moddbl_ir1_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dbl_ir2_ix			; numCalls = 2
	.module	moddbl_ir2_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r2+1
	ldab	0,x
	rolb
	stab	r2
	rts

dec_ir1_ir1			; numCalls = 5
	.module	moddec_ir1_ir1
	jsr	noargs
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 17
	.module	moddec_ir1_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 12
	.module	moddec_ir2_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 10
	.module	moddec_ix_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

div_fr1_ir1_pb			; numCalls = 3
	.module	moddiv_fr1_ir1_pb
	jsr	getbyte
	stab	2+argv
	ldd	#0
	std	0+argv
	std	3+argv
	std	r1+3
	ldx	#r1
	jmp	divflt

for_ix_ir1			; numCalls = 4
	.module	modfor_ix_ir1
	jsr	extend
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 3
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 4
	.module	modforclr_ix
	jsr	extend
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_fx			; numCalls = 1
	.module	modforone_fx
	jsr	extend
	stx	letptr
	ldd	#0
	std	3,x
	std	0,x
	ldab	#1
	stab	2,x
	rts

forone_ix			; numCalls = 27
	.module	modforone_ix
	jsr	extend
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

fract_fr1_fr1			; numCalls = 3
	.module	modfract_fr1_fr1
	jsr	noargs
	ldd	#0
	stab	r1
	std	r1+1
	rts

gosub_ix			; numCalls = 46
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

goto_ix			; numCalls = 70
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

ignxtra			; numCalls = 1
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

inc_ir1_ix			; numCalls = 19
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir2_ix			; numCalls = 13
	.module	modinc_ir2_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 23
	.module	modinc_ix_ix
	jsr	extend
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 1
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

input			; numCalls = 1
	.module	modinput
	jsr	noargs
	ldx	curinst
	stx	redoptr
	jmp	inputqs

irnd_ir1_pb			; numCalls = 16
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

jmpeq_ir1_ix			; numCalls = 30
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_fr1_ix			; numCalls = 2
	.module	modjmpne_fr1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_go
	ldaa	r1
	bne	_go
	ldd	r1+3
	beq	_rts
_go
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 20
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

jsreq_fr1_ix			; numCalls = 1
	.module	modjsreq_fr1_ix
	pulx
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	ldd	r1+3
	bne	_rts
	ldd	nxtinst
	pshb
	psha
	ldab	#3
	pshb
	stx	nxtinst
_rts
	jmp	mainloop

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

ld_ip_ir1			; numCalls = 18
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 14
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 99
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_nb			; numCalls = 3
	.module	modld_ir1_nb
	jsr	getbyte
	stab	r1+2
	ldd	#-1
	std	r1
	rts

ld_ir1_pb			; numCalls = 124
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

ld_ir2_pb			; numCalls = 38
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 24
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 42
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 3
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 25
	.module	modld_sp_sr1
	jsr	noargs
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 23
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

ld_sr1_sx			; numCalls = 4
	.module	modld_sr1_sx
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sx_sr1			; numCalls = 5
	.module	modld_sx_sr1
	jsr	extend
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ix			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 8
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

ldeq_ir1_ix_pb			; numCalls = 1
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

ldeq_ir2_ir2_ir3			; numCalls = 2
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

ldeq_ir2_sx_ss			; numCalls = 3
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

ldge_ir1_ix_pb			; numCalls = 1
	.module	modldge_ir1_ix_pb
	jsr	extbyte
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

ldlt_ir1_ir1_ir2			; numCalls = 1
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

ldlt_ir1_ix_pb			; numCalls = 9
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

ldlt_ir1_pb_ix			; numCalls = 10
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

ldne_ir1_ir1_ir2			; numCalls = 2
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

ldne_ir2_ir2_ix			; numCalls = 2
	.module	modldne_ir2_ir2_ix
	jsr	extend
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

left_sr1_sr1_pb			; numCalls = 1
	.module	modleft_sr1_sr1_pb
	jsr	getbyte
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

midT_sr1_sr1_pb			; numCalls = 3
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

mul_ir1_ir1_ix			; numCalls = 4
	.module	modmul_ir1_ir1_ix
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir1_ir1_pb			; numCalls = 2
	.module	modmul_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

mul_ir2_ir2_ix			; numCalls = 4
	.module	modmul_ir2_ir2_ix
	jsr	extend
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r2
	jmp	mulintx

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	jsr	noargs
	ldx	#r1
	jmp	negxi

next			; numCalls = 59
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

one_ip			; numCalls = 6
	.module	modone_ip
	jsr	noargs
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 10
	.module	modone_ix
	jsr	extend
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongosub_ir1_is			; numCalls = 3
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

ongoto_ir1_is			; numCalls = 31
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

or_ir1_ir1_ir2			; numCalls = 5
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

peek2_ir1			; numCalls = 1
	.module	modpeek2_ir1
	jsr	noargs
	jsr	R_KPOLL
	ldab	2
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ir1			; numCalls = 31
	.module	modpeek_ir1_ir1
	jsr	noargs
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pw			; numCalls = 4
	.module	modpeek_ir1_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

poke_pw_ir1			; numCalls = 10
	.module	modpoke_pw_ir1
	jsr	getword
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 41
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

pr_ss			; numCalls = 40
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

pr_sx			; numCalls = 44
	.module	modpr_sx
	jsr	extend
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 80
	.module	modprat_ir1
	jsr	noargs
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 8
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 6
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

read_ix			; numCalls = 2
	.module	modread_ix
	jsr	extend
	jsr	rpsword
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	rts

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

return			; numCalls = 23
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

right_sr1_sr1_pb			; numCalls = 1
	.module	modright_sr1_sr1_pb
	jsr	getbyte
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

rnd_fr1_ir1			; numCalls = 2
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

rsub_ir2_ir2_ix			; numCalls = 4
	.module	modrsub_ir2_ir2_ix
	jsr	extend
	ldd	1,x
	subd	r2+1
	std	r2+1
	ldab	0,x
	sbcb	r2
	stab	r2
	rts

sgn_ir2_ir2			; numCalls = 4
	.module	modsgn_ir2_ir2
	jsr	noargs
	ldab	r2
	bmi	_neg
	bne	_pos
	ldd	r2+1
	bne	_pos
	ldd	#0
	stab	r2+2
	bra	_done
_pos
	ldd	#1
	stab	r2+2
	clrb
	bra	_done
_neg
	ldd	#-1
	stab	r2+2
_done
	std	r2
	rts

shift_ir1_ir1_pb			; numCalls = 4
	.module	modshift_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 33
	.module	modsound_ir1_ir2
	jsr	noargs
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

sq_ir1_ix			; numCalls = 1
	.module	modsq_ir1_ix
	jsr	extend
	jsr	x2arg
	jsr	mulint
	ldx	#r1
	jmp	tmp2xi

step_ip_ir1			; numCalls = 3
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

stop			; numCalls = 4
	.module	modstop
	jsr	noargs
	ldx	#R_BKMSG-1
	jmp	R_BREAK

str_sr1_ir1			; numCalls = 1
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

str_sr1_ix			; numCalls = 6
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

strcat_sr1_sr1_ss			; numCalls = 2
	.module	modstrcat_sr1_sr1_ss
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	ldx	curinst
	inx
	ldab	,x
	addb	r1
	bcs	_lserror
	stab	r1
	ldab	,x
	inx
	pshx
	abx
	stx	nxtinst
	pulx
	jmp	strcat
_lserror
	ldab	#LS_ERROR
	jmp	error

strinit_sr1_sr1			; numCalls = 1
	.module	modstrinit_sr1_sr1
	jsr	noargs
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

strinit_sr1_sx			; numCalls = 1
	.module	modstrinit_sr1_sx
	jsr	extend
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
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

sub_ir1_ix_pb			; numCalls = 2
	.module	modsub_ir1_ix_pb
	jsr	extbyte
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

sub_ir2_ix_pb			; numCalls = 2
	.module	modsub_ir2_ix_pb
	jsr	extbyte
	stab	tmp1
	ldd	1,x
	subb	tmp1
	sbca	#0
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	jsr	noargs
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_fp_pw			; numCalls = 1
	.module	modto_fp_pw
	jsr	getword
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#15
	jmp	to

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
	jsr	noargs
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_ix			; numCalls = 4
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

to_ip_pb			; numCalls = 30
	.module	modto_ip_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 3
	.module	modto_ip_pw
	jsr	getword
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

true_ip			; numCalls = 6
	.module	modtrue_ip
	jsr	noargs
	ldx	letptr
	ldd	#-1
	stab	0,x
	std	1,x
	rts

true_ix			; numCalls = 2
	.module	modtrue_ix
	jsr	extend
	ldd	#-1
	stab	0,x
	std	1,x
	rts

; data table
startdata
	.word	170, 2, 170, 2
	.word	176, 2, 185, 2
	.word	185, 2, 176, 2
	.word	170, 2, 159, 2
	.word	147, 2, 147, 2
	.word	159, 2, 170, 2
	.word	170, 3, 159, 1
	.word	159, 4, 170, 2
	.word	170, 2, 176, 2
	.word	185, 2, 185, 2
	.word	176, 2, 170, 2
	.word	159, 2, 147, 2
	.word	147, 2, 159, 2
	.word	170, 2, 159, 3
	.word	147, 1, 147, 4
	.word	-1, -1, 159, 2
	.word	159, 2, 170, 2
	.word	147, 2, 159, 2
	.word	170, 1, 176, 1
	.word	170, 2, 147, 2
	.word	159, 2, 170, 1
	.word	176, 1, 170, 2
	.word	159, 2, 147, 2
	.word	159, 2, 108, 4
	.word	170, 2, 170, 2
	.word	176, 2, 185, 2
	.word	185, 2, 176, 2
	.word	170, 2, 159, 2
	.word	147, 2, 147, 2
	.word	159, 2, 170, 2
	.word	159, 3, 147, 1
	.word	147, 4, -1, -1
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_A	.equ	0
bytecode_INTVAR_B	.equ	1
bytecode_INTVAR_C	.equ	2
bytecode_INTVAR_D	.equ	3
bytecode_INTVAR_E	.equ	4
bytecode_INTVAR_EG	.equ	5
bytecode_INTVAR_H	.equ	6
bytecode_INTVAR_I	.equ	7
bytecode_INTVAR_J	.equ	8
bytecode_INTVAR_K	.equ	9
bytecode_INTVAR_L	.equ	10
bytecode_INTVAR_LV	.equ	11
bytecode_INTVAR_M	.equ	12
bytecode_INTVAR_MN	.equ	13
bytecode_INTVAR_S	.equ	14
bytecode_INTVAR_SC	.equ	15
bytecode_INTVAR_SF	.equ	16
bytecode_INTVAR_SW	.equ	17
bytecode_INTVAR_T	.equ	18
bytecode_INTVAR_TM	.equ	19
bytecode_INTVAR_X	.equ	20
bytecode_INTVAR_XX	.equ	21
bytecode_INTVAR_Y	.equ	22
bytecode_INTVAR_YY	.equ	23
bytecode_INTVAR_Z	.equ	24
bytecode_FLTVAR_ZZ	.equ	25
bytecode_STRVAR_B	.equ	26
bytecode_STRVAR_I	.equ	27
bytecode_STRVAR_LV	.equ	28
bytecode_STRVAR_NM	.equ	29
bytecode_STRVAR_TM	.equ	30
bytecode_INTARR_A	.equ	31
bytecode_INTARR_B	.equ	32
bytecode_INTARR_D	.equ	33
bytecode_INTARR_G	.equ	34
bytecode_INTARR_HS	.equ	35
bytecode_INTARR_I	.equ	36
bytecode_INTARR_K	.equ	37
bytecode_INTARR_L	.equ	38
bytecode_INTARR_M	.equ	39
bytecode_INTARR_N	.equ	40
bytecode_INTARR_V	.equ	41
bytecode_INTARR_X	.equ	42
bytecode_INTARR_Y	.equ	43
bytecode_STRARR_A	.equ	44
bytecode_STRARR_B	.equ	45
bytecode_STRARR_NM	.equ	46

symtbl

	.word	INTVAR_A
	.word	INTVAR_B
	.word	INTVAR_C
	.word	INTVAR_D
	.word	INTVAR_E
	.word	INTVAR_EG
	.word	INTVAR_H
	.word	INTVAR_I
	.word	INTVAR_J
	.word	INTVAR_K
	.word	INTVAR_L
	.word	INTVAR_LV
	.word	INTVAR_M
	.word	INTVAR_MN
	.word	INTVAR_S
	.word	INTVAR_SC
	.word	INTVAR_SF
	.word	INTVAR_SW
	.word	INTVAR_T
	.word	INTVAR_TM
	.word	INTVAR_X
	.word	INTVAR_XX
	.word	INTVAR_Y
	.word	INTVAR_YY
	.word	INTVAR_Z
	.word	FLTVAR_ZZ
	.word	STRVAR_B
	.word	STRVAR_I
	.word	STRVAR_LV
	.word	STRVAR_NM
	.word	STRVAR_TM
	.word	INTARR_A
	.word	INTARR_B
	.word	INTARR_D
	.word	INTARR_G
	.word	INTARR_HS
	.word	INTARR_I
	.word	INTARR_K
	.word	INTARR_L
	.word	INTARR_M
	.word	INTARR_N
	.word	INTARR_V
	.word	INTARR_X
	.word	INTARR_Y
	.word	STRARR_A
	.word	STRARR_B
	.word	STRARR_NM


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_EG	.block	3
INTVAR_H	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_MN	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_SF	.block	3
INTVAR_SW	.block	3
INTVAR_T	.block	3
INTVAR_TM	.block	3
INTVAR_X	.block	3
INTVAR_XX	.block	3
INTVAR_Y	.block	3
INTVAR_YY	.block	3
INTVAR_Z	.block	3
FLTVAR_ZZ	.block	5
; String Variables
STRVAR_B	.block	3
STRVAR_I	.block	3
STRVAR_LV	.block	3
STRVAR_NM	.block	3
STRVAR_TM	.block	3
; Numeric Arrays
INTARR_A	.block	6	; dims=2
INTARR_B	.block	6	; dims=2
INTARR_D	.block	4	; dims=1
INTARR_G	.block	4	; dims=1
INTARR_HS	.block	4	; dims=0
INTARR_I	.block	4	; dims=1
INTARR_K	.block	4	; dims=1
INTARR_L	.block	6	; dims=2
INTARR_M	.block	4	; dims=1
INTARR_N	.block	4	; dims=1
INTARR_V	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays
STRARR_A	.block	4	; dims=1
STRARR_B	.block	4	; dims=1
STRARR_NM	.block	4	; dims=0

; block ended by symbol
bes
	.end

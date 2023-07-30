; Assembly for berzerk.bas
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

LINE_1

	; CLS

	.byte	bytecode_cls

	; GOTO 64

	.byte	bytecode_goto_ix
	.word	LINE_64

LINE_2

	; RETURN

	.byte	bytecode_return

LINE_3

	; G=Q

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_G
	.byte	bytecode_INTVAR_Q

	; A=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_A

	; J=E(X(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=F(Y(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

	; ON POINT(J,K) GOTO 28,45,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

	; ON POINT(J,K+2) GOTO 28,45,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	2

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

LINE_4

	; PRINT @A(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; X(T)+=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_inc_ip_ip

	; PRINT @A(X(T),Y(T)), A$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_5

	; A=W

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_A
	.byte	bytecode_INTVAR_W

	; J=G(X(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_G

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=F(Y(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

	; ON POINT(J,K) GOTO 28,45,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

	; ON POINT(J,K+2) GOTO 28,45,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	2

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

LINE_6

	; PRINT @A(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; X(T)-=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_dec_ip_ip

	; PRINT @A(X(T),Y(T)), A$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_7

	; B=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_B

	; J=F(X(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=E(Y(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

	; ON POINT(J,K) GOTO 28,45,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

	; ON POINT(J+2,K) GOTO 28,45,2,2,2

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

LINE_8

	; PRINT @A(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; Y(T)+=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_inc_ip_ip

	; PRINT @A(X(T),Y(T)), A$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_9

	; B=W

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_B
	.byte	bytecode_INTVAR_W

	; J=F(X(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=G(Y(T))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_G

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

	; ON POINT(J,K) GOTO 28,45,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

	; ON POINT(J+2,K) GOTO 28,45,2,2,2

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_28, LINE_45, LINE_2, LINE_2, LINE_2

LINE_10

	; PRINT @A(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; Y(T)-=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_dec_ip_ip

	; PRINT @A(X(T),Y(T)), A$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_11

	; C=A

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_C
	.byte	bytecode_INTVAR_A

	; U=SHIFT(A,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_U

	; Z=B

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_Z
	.byte	bytecode_INTVAR_B

	; V=SHIFT(B,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_V

	; R=SHIFT(X(T),1)+O(A+1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_O

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_R

	; S=SHIFT(Y(T),1)+P(B+1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_S

	; ON POINT(R,S) GOTO 27,30,27,27,27

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_27, LINE_30, LINE_27, LINE_27, LINE_27

	; SET(R,S,4)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

	; RETURN

	.byte	bytecode_return

LINE_12

	; RESET(R,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_reset_ir1_ix
	.byte	bytecode_INTVAR_S

	; ON POINT(R+U,S+V) GOTO 27,30,27,27,27

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_R
	.byte	bytecode_INTVAR_U

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_S
	.byte	bytecode_INTVAR_V

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_27, LINE_30, LINE_27, LINE_27, LINE_27

	; R+=U

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_U

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_R

	; S+=V

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_V

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_S

	; ON POINT(R+C,S+Z) GOSUB 2,30,2,2

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_R
	.byte	bytecode_INTVAR_C

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_S
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongosub_ir1_is
	.byte	4
	.word	LINE_2, LINE_30, LINE_2, LINE_2

	; SET(R,S,4)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

	; RETURN

	.byte	bytecode_return

LINE_13

	; RESET(L,M)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_reset_ir1_ix
	.byte	bytecode_INTVAR_M

	; ON POINT(L+H,M+I) GOTO 36,30,32,32,32,32,36

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_L
	.byte	bytecode_INTVAR_H

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_M
	.byte	bytecode_INTVAR_I

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	7
	.word	LINE_36, LINE_30, LINE_32, LINE_32, LINE_32, LINE_32, LINE_36

	; ON POINT(L+N,M+O) GOTO 36,30,32,32,32,32,36

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_L
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_M
	.byte	bytecode_INTVAR_O

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	7
	.word	LINE_36, LINE_30, LINE_32, LINE_32, LINE_32, LINE_32, LINE_36

	; L+=N

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_L

	; M+=O

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_O

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_M

	; SET(L,M,7)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	7

	; RETURN

	.byte	bytecode_return

LINE_14

	; FOR E=1 TO 50

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_to_ip_pb
	.byte	50

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; G=F

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_G
	.byte	bytecode_INTVAR_F

	; ON RND(R(T)) GOTO 16,16,16,16,26,26

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_rnd_fr1_ir1

	.byte	bytecode_ongoto_ir1_is
	.byte	6
	.word	LINE_16, LINE_16, LINE_16, LINE_16, LINE_26, LINE_26

	; A=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_A

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; ON SGN(X-X(T))+2 GOSUB 5,2,3

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_rsub_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_sgn_ir1_ir1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ongosub_ir1_is
	.byte	3
	.word	LINE_5, LINE_2, LINE_3

	; ON SGN(Y-Y(T))+2 GOSUB 9,2,7

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_rsub_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_sgn_ir1_ir1

	.byte	bytecode_add_ir1_ir1_pb
	.byte	2

	.byte	bytecode_ongosub_ir1_is
	.byte	3
	.word	LINE_9, LINE_2, LINE_7

LINE_15

	; IF R=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_16

	; GOSUB 11

	.byte	bytecode_gosub_ix
	.word	LINE_11

	; GOTO 17

	.byte	bytecode_goto_ix
	.word	LINE_17

LINE_16

	; WHEN R>1 GOSUB 12

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_12

LINE_17

	; FOR Z2=1 TO 2

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z2

	.byte	bytecode_to_ip_pb
	.byte	2

	; WHEN L GOSUB 13

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_13

LINE_18

	; NEXT

	.byte	bytecode_next

	; FOR Z2=1 TO Z3

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z2

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_Z3

	; NEXT

	.byte	bytecode_next

	; GOSUB 300

	.byte	bytecode_gosub_ix
	.word	LINE_300

	; IF J=9 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_19

	; GOSUB 40

	.byte	bytecode_gosub_ix
	.word	LINE_40

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 48

	.byte	bytecode_goto_ix
	.word	LINE_48

LINE_19

	; IF J THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_20

	; GOSUB 21

	.byte	bytecode_gosub_ix
	.word	LINE_21

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 48

	.byte	bytecode_goto_ix
	.word	LINE_48

LINE_20

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOTO 48

	.byte	bytecode_goto_ix
	.word	LINE_48

LINE_21

	; H=N(J)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_H

	; I=Q(J)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_I

	; D=L(J)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_D

	; J=F(X+H)

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_H

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=F(Y+I)

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

	; ON POINT(J,K) GOTO 33,22,33,42,44,33

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	6
	.word	LINE_33, LINE_22, LINE_33, LINE_42, LINE_44, LINE_33

LINE_22

	; ON POINT(J+2,K) GOTO 33,23,33,42,44,33

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	6
	.word	LINE_33, LINE_23, LINE_33, LINE_42, LINE_44, LINE_33

LINE_23

	; ON POINT(J,K+2) GOTO 33,24,33,42,44,33

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	2

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	6
	.word	LINE_33, LINE_24, LINE_33, LINE_42, LINE_44, LINE_33

LINE_24

	; ON POINT(J+2,K+2) GOTO 33,25,33,42,44,33

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	2

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_ongoto_ir1_is
	.byte	6
	.word	LINE_33, LINE_25, LINE_33, LINE_42, LINE_44, LINE_33

LINE_25

	; PRINT @A(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X,Y), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; X+=H

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y+=I

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_Y

	; PRINT @A(X,Y), A$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; RETURN

	.byte	bytecode_return

LINE_26

	; A=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_A

	; B=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_B

	; ON RND(4) GOSUB 3,5,7,9

	.byte	bytecode_irnd_ir1_pb
	.byte	4

	.byte	bytecode_ongosub_ir1_is
	.byte	4
	.word	LINE_3, LINE_5, LINE_7, LINE_9

	; GOTO 16

	.byte	bytecode_goto_ix
	.word	LINE_16

LINE_27

	; R=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_R

	; S=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_S

	; C=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_C

	; Z=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_Z

	; RETURN

	.byte	bytecode_return

LINE_28

	; PRINT @A(X(T),Y(T)), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

LINE_29

	; PRINT @A(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; R(T)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_one_ip

	; G=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_G

	; RETURN

	.byte	bytecode_return

LINE_30

	; RESET(R,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_reset_ir1_ix
	.byte	bytecode_INTVAR_S

	; SET(R+U,S+V,4)

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_R
	.byte	bytecode_INTVAR_U

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_S
	.byte	bytecode_INTVAR_V

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

	; SOUND 100,2

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; GOSUB 27

	.byte	bytecode_gosub_ix
	.word	LINE_27

	; PRINT @A(X,Y), A$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; HT+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_HT

	; SET(1,1,4)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

	; WHEN HT>2 GOTO 34

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_HT

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_34

LINE_31

	; RETURN

	.byte	bytecode_return

LINE_32

	; L=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_L

	; M=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_M

	; N=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_N

	; O=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_O

	; RETURN

	.byte	bytecode_return

LINE_33

	; GOSUB 25

	.byte	bytecode_gosub_ix
	.word	LINE_25

	; PRINT @A(X,Y), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 200,4

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; GOTO 35

	.byte	bytecode_goto_ix
	.word	LINE_35

LINE_34

	; FOR T=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	5

	; PRINT @A(X,Y), A$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(10);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; PRINT @A(X,Y), A$(9);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(9);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	9

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 100,1

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

LINE_35

	; PRINT @480, "OUCH!";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	5, "OUCH!"

	; SOUND 200,4

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; E=65000

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_E
	.word	65000

	; T=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	6

	; G=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_G

	; LF-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_LF

	; HT=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_HT

	; EV=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_EV
	.byte	2

	; RETURN

	.byte	bytecode_return

LINE_36

	; SET(L+N,M+O,7)

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_L
	.byte	bytecode_INTVAR_N

	.byte	bytecode_add_ir2_ix_id
	.byte	bytecode_INTVAR_M
	.byte	bytecode_INTVAR_O

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	7

	; FOR M=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_to_ip_pb
	.byte	6

	; ON R(M) GOTO 38

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_38

	; J=SHIFT(X(M),1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=SHIFT(Y(M),1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_dbl_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

LINE_37

	; WHEN (POINT(J,K)=7) OR (POINT(J+2,K)=7) OR (POINT(J,K+2)=7) OR (POINT(J+2,K+2)=7) GOSUB 39

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	7

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_point_ir2_ir2_ix
	.byte	bytecode_INTVAR_K

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	7

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_add_ir3_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	2

	.byte	bytecode_point_ir2_ir2_ir3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	7

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_add_ir2_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_add_ir3_ix_pb
	.byte	bytecode_INTVAR_K
	.byte	2

	.byte	bytecode_point_ir2_ir2_ir3

	.byte	bytecode_ldeq_ir2_ir2_pb
	.byte	7

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_39

LINE_38

	; NEXT

	.byte	bytecode_next

	; GOTO 32

	.byte	bytecode_goto_ix
	.word	LINE_32

LINE_39

	; PRINT @A(X(M),Y(M)), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @B(X(M),Y(M)), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; PRINT @A(X(M),Y(M)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(M),Y(M)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; R(M)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_one_ip

	; SC+=100

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_SC
	.byte	100

	; RETURN

	.byte	bytecode_return

LINE_40

	; IF L THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_41

	; RETURN

	.byte	bytecode_return

LINE_41

	; N=SHIFT(H,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_N

	; O=SHIFT(I,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_O

	; L=SHIFT(X,1)+O(H+1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_H

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_O

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_L

	; M=SHIFT(Y,1)+P(I+1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_inc_ir2_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; ON POINT(L,M) GOTO 36,30,32,32,32

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_36, LINE_30, LINE_32, LINE_32, LINE_32

	; SET(L,M,7)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	7

	; RETURN

	.byte	bytecode_return

LINE_42

	; GOSUB 25

	.byte	bytecode_gosub_ix
	.word	LINE_25

	; SET(R,S,4)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

	; SOUND 100,2

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; GOSUB 27

	.byte	bytecode_gosub_ix
	.word	LINE_27

	; PRINT @A(X,Y), A$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; HT+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_HT

	; SET(1,1,4)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

	; WHEN HT>2 GOTO 35

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_HT

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_35

LINE_43

	; RETURN

	.byte	bytecode_return

LINE_44

	; GOSUB 25

	.byte	bytecode_gosub_ix
	.word	LINE_25

	; PRINT @480, "YOU ESCAPED!";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	12, "YOU ESCAPED!"

	; SOUND 100,3

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; SOUND 50,3

	.byte	bytecode_ld_ir1_pb
	.byte	50

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,10

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	10

	.byte	bytecode_sound_ir1_ir2

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; GOSUB 58

	.byte	bytecode_gosub_ix
	.word	LINE_58

	; NEXT

	.byte	bytecode_next

	; E=65000

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_E
	.word	65000

	; T=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	6

	; EV=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_EV

	; RETURN

	.byte	bytecode_return

LINE_45

	; PRINT @A(X,Y), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(11);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	11

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

LINE_46

	; PRINT @A(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @B(X(T),Y(T)), B$;

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; Y(T)+=B

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_B

	.byte	bytecode_add_ip_ip_ir1

	; X(T)+=A

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_A

	.byte	bytecode_add_ip_ip_ir1

	; PRINT @A(X(T),Y(T)), A$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

LINE_47

	; SOUND 200,4

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; GOTO 35

	.byte	bytecode_goto_ix
	.word	LINE_35

LINE_48

	; IF E<65000 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_ldlt_ir1_ir1_pw
	.word	65000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_49

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; GOSUB 29

	.byte	bytecode_gosub_ix
	.word	LINE_29

	; NEXT

	.byte	bytecode_next

	; PRINT @A(X,Y), A$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(D);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; R(RND(6))=20

	.byte	bytecode_irnd_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_ld_ip_pb
	.byte	20

	; F=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	12

	; Q=12

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Q
	.byte	12

	; GOTO 14

	.byte	bytecode_goto_ix
	.word	LINE_14

LINE_49

	; IF EV=2 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EV

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_50

	; IF LF>=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LF

	.byte	bytecode_ldge_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_50

	; SOUND 1,5

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_sound_ir1_ir2

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; GOTO 74

	.byte	bytecode_goto_ix
	.word	LINE_74

LINE_50

	; IF (EV=1) AND (BN<>6) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EV

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_BN

	.byte	bytecode_ldne_ir2_ir2_pb
	.byte	6

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_51

	; PRINT @480, "CHICKEN! FIGHT LIKE A ROBOT!";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	28, "CHICKEN! FIGHT LIKE A ROBOT!"

	; FOR T=1 TO 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	10

	; SOUND 101-(T*10),1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	10

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	101

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

	; GOTO 52

	.byte	bytecode_goto_ix
	.word	LINE_52

LINE_51

	; IF EV=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EV

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_52

	; PRINT @480, "LEVEL CLEARED.";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	14, "LEVEL CLEARED."

	; FOR T=1 TO 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	10

	; SOUND 100,1

	.byte	bytecode_ld_ir1_pb
	.byte	100

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

	; SC+=250

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_SC
	.byte	250

	; HT=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_HT

LINE_52

	; IF EV=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EV

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_53

	; PRINT @480, "GET READY FOR NEXT LEVEL ...";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	28, "GET READY FOR NEXT LEVEL ..."

	; FOR T=1 TO 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	10

	; SOUND T*10,1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	10

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

	; EN=NE

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_EN
	.byte	bytecode_INTVAR_NE

	; EX=EX(RND(3))

	.byte	bytecode_irnd_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_EX

	; GOTO 72

	.byte	bytecode_goto_ix
	.word	LINE_72

LINE_53

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; RESET(2,0)

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_reset_ir1_pb
	.byte	0

	; PRINT @480, "YOU ARE DEAD. PLAY AGAIN (Y/N)";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	30, "YOU ARE DEAD. PLAY AGAIN (Y/N)"

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

	; PRINT @16, "HIGH:";STR$(HS);" ";

	.byte	bytecode_prat_pb
	.byte	16

	.byte	bytecode_pr_ss
	.text	5, "HIGH:"

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_HS

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

LINE_54

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; WHEN I$="" GOTO 54

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_54

LINE_55

	; WHEN I$="Y" GOTO 62

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "Y"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_62

LINE_56

	; IF I$="N" THEN

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	1, "N"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_57

	; END

	.byte	bytecode_progend

LINE_57

	; GOTO 54

	.byte	bytecode_goto_ix
	.word	LINE_54

LINE_58

	; IF R(T)=1 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_59

	; BN+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_BN

LINE_59

	; RETURN

	.byte	bytecode_return

LINE_60

	; FOR Q=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_to_ip_pb
	.byte	6

	; IF DR(EN,Q,0)=J(Y,0) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_J

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_61

	; IF DR(EN,Q,1)=I(X,0) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval2_ir2_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_61

	; Q=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Q
	.byte	6

	; NEXT

	.byte	bytecode_next

	; GOTO 75

	.byte	bytecode_goto_ix
	.word	LINE_75

LINE_61

	; NEXT

	.byte	bytecode_next

	; X(T)=I(X,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_ld_ip_ir1

	; Y(T)=J(Y,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_J

	.byte	bytecode_ld_ip_ir1

	; I(X,1)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_one_ip

	; J(Y,1)=1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_J

	.byte	bytecode_one_ip

	; NEXT

	.byte	bytecode_next

	; GOTO 77

	.byte	bytecode_goto_ix
	.word	LINE_77

LINE_62

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; LV=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_LV
	.byte	5

	; LF=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_LF
	.byte	2

	; M(1)=9

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ip_pb
	.byte	9

	; HT=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_HT

	; EN=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_EN
	.byte	4

	; EX=RND(3)

	.byte	bytecode_irnd_ir1_pb
	.byte	3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_EX

	; IF SC>HS THEN

	.byte	bytecode_ldlt_ir1_ix_id
	.byte	bytecode_INTVAR_HS
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_63

	; HS=SC

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_HS
	.byte	bytecode_INTVAR_SC

LINE_63

	; SC=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_SC

	; GOTO 73

	.byte	bytecode_goto_ix
	.word	LINE_73

LINE_64

	; DIM A$(13),B$(13),X(6),Y(6),R(6),O(2),P(2),K(255),A(31,14),B(31,14),E(64),F(64),G(64),I(12,1),J(6,1)

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrdim1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_O

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_ld_ir1_pb
	.byte	255

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	14

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	14

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ir1_pb
	.byte	64

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ir1_pb
	.byte	64

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ir1_pb
	.byte	64

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_G

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_J

LINE_65

	; DIM T,D,X,Y,A,B,C,E,F,H,I,G,R,L,S,M,W,J,K,N,O,Q,U,V,Z,B$,M(12),N(8),Q(8),L(8),DR(4,6,1),EX(3)

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	6

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrdim3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_EX

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

LINE_66

	; DIM LV,EV,SC,EN,EX,BN,HS,XX,YY,CX,CY,XC,YC,PC,RR,HT,I$,A$

	; B$="€€"

	.byte	bytecode_ld_sr1_ss
	.text	2, "\x80\x80"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_B

	; LV=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_LV
	.byte	8

	; LF=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_LF
	.byte	3

	; GOSUB 103

	.byte	bytecode_gosub_ix
	.word	LINE_103

	; GOSUB 96

	.byte	bytecode_gosub_ix
	.word	LINE_96

LINE_67

	; GOSUB 162

	.byte	bytecode_gosub_ix
	.word	LINE_162

	; FOR T=0 TO 13

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	13

	; FOR Y=0 TO 3

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	3

	; READ A$

	.byte	bytecode_read_sx
	.byte	bytecode_STRVAR_A

	; FOR X=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	4

	; I=VAL(MID$(A$,X,1))

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_val_fr1_sr1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_I

	; IF I>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_68

	; SET(X-1,Y,I)

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_ix
	.byte	bytecode_INTVAR_I

LINE_68

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; A$(T)=CHR$(PEEK(16384))+CHR$(PEEK(16385))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_peek_ir1_pw
	.word	16384

	.byte	bytecode_chr_sr1_ir1

	.byte	bytecode_strinit_sr1_sr1

	.byte	bytecode_peek_ir2_pw
	.word	16385

	.byte	bytecode_chr_sr2_ir2

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sp_sr1

	; B$(T)=CHR$(PEEK(16416))+CHR$(PEEK(16417))

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_peek_ir1_pw
	.word	16416

	.byte	bytecode_chr_sr1_ir1

	.byte	bytecode_strinit_sr1_sr1

	.byte	bytecode_peek_ir2_pw
	.word	16417

	.byte	bytecode_chr_sr2_ir2

	.byte	bytecode_strcat_sr1_sr1_sr2

	.byte	bytecode_ld_sp_sr1

LINE_69

	; GOSUB 99

	.byte	bytecode_gosub_ix
	.word	LINE_99

	; NEXT

	.byte	bytecode_next

	; GOSUB 400

	.byte	bytecode_gosub_ix
	.word	LINE_400

	; GOSUB 117

	.byte	bytecode_gosub_ix
	.word	LINE_117

	; GOSUB 100

	.byte	bytecode_gosub_ix
	.word	LINE_100

	; W=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_W

	; O(0)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_O

	.byte	bytecode_true_ip

	; O(1)=3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_O

	.byte	bytecode_ld_ip_pb
	.byte	3

	; O(2)=5

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_O

	.byte	bytecode_ld_ip_pb
	.byte	5

	; P(0)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_true_ip

	; P(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_one_ip

	; P(2)=5

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_P

	.byte	bytecode_ld_ip_pb
	.byte	5

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; GOSUB 161

	.byte	bytecode_gosub_ix
	.word	LINE_161

LINE_70

	; FOR T=1 TO 12

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	12

	; READ C1

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_C1

	; I(T,0)=INT(C1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_FLTVAR_C1

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; READ C1

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_C1

	; J(T,0)=INT(C1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_FLTVAR_C1

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; FOR EN=1 TO 4

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_to_ip_pb
	.byte	4

LINE_71

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; READ C1

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_C1

	; DR(EN,T,0)=INT(C1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_FLTVAR_C1

	.byte	bytecode_ld_ip_ir1

	; READ C1

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_C1

	; DR(EN,T,1)=INT(C1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrref3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_FLTVAR_C1

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; EN=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_EN
	.byte	4

	; EX=RND(3)

	.byte	bytecode_irnd_ir1_pb
	.byte	3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_EX

LINE_72

	; FOR T=1 TO 12

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	12

	; READ C1

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_C1

	; M(T)=INT(C1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_FLTVAR_C1

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

LINE_73

	; IF M(1)=9 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ldeq_ir1_ir1_pb
	.byte	9

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_74

	; LV+=3

	.byte	bytecode_add_ix_ix_pb
	.byte	bytecode_INTVAR_LV
	.byte	3

	; LF+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_LF

	; RESTORE

	.byte	bytecode_restore

	; FOR T=1 TO 56

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	56

	; READ A$

	.byte	bytecode_read_sx
	.byte	bytecode_STRVAR_A

	; NEXT

	.byte	bytecode_next

	; FOR T=1 TO 66

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	66

	; READ C1

	.byte	bytecode_read_fx
	.byte	bytecode_FLTVAR_C1

	; C=INT(C1)

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_C
	.byte	bytecode_FLTVAR_C1

	; NEXT

	.byte	bytecode_next

	; GOSUB 151

	.byte	bytecode_gosub_ix
	.word	LINE_151

	; GOTO 72

	.byte	bytecode_goto_ix
	.word	LINE_72

LINE_74

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; R(T)=LV

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_R

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LV

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; FOR T=1 TO 12

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	12

	; I(T,1)=0

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_clr_ip

	; NEXT

	.byte	bytecode_next

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; J(T,1)=0

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_J

	.byte	bytecode_clr_ip

	; NEXT

	.byte	bytecode_next

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

LINE_75

	; X=RND(12)

	.byte	bytecode_irnd_ir1_pb
	.byte	12

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; Y=RND(6)

	.byte	bytecode_irnd_ir1_pb
	.byte	6

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; IF I(X,1)=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_I

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_76

	; WHEN J(Y,1)=0 GOTO 60

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_J

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_60

LINE_76

	; GOTO 75

	.byte	bytecode_goto_ix
	.word	LINE_75

LINE_77

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; FOR X=1 TO 63

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	63

	; SET(X,1,3)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(X,11,3)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	11

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(X,21,3)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	21

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(X,31,3)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	31

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; NEXT

	.byte	bytecode_next

LINE_78

	; FOR Y=1 TO 31

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	31

	; SET(1,Y,3)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(17,Y,3)

	.byte	bytecode_ld_ir1_pb
	.byte	17

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(33,Y,3)

	.byte	bytecode_ld_ir1_pb
	.byte	33

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(49,Y,3)

	.byte	bytecode_ld_ir1_pb
	.byte	49

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; SET(63,Y,3)

	.byte	bytecode_ld_ir1_pb
	.byte	63

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; NEXT

	.byte	bytecode_next

LINE_79

	; IF LF>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_LF

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_80

	; FOR T=1 TO LF

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_LF

	; SET(SHIFT(T,1),0,3)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir2_pb
	.byte	0

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; NEXT

	.byte	bytecode_next

LINE_80

	; IF HT>0 THEN

	.byte	bytecode_ld_ir1_pb
	.byte	0

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_HT

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_81

	; SET(1,1,4)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	4

LINE_81

	; GOSUB 84

	.byte	bytecode_gosub_ix
	.word	LINE_84

	; FOR Y=1 TO 30

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	30

	; SET(63,Y,3)

	.byte	bytecode_ld_ir1_pb
	.byte	63

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	3

	; NEXT

	.byte	bytecode_next

	; GOSUB 91

	.byte	bytecode_gosub_ix
	.word	LINE_91

LINE_82

	; Y=DR(EN,1,0)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_ir3_pb
	.byte	0

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Y

	; X=DR(EN,1,1)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EN

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_ld_ir3_pb
	.byte	1

	.byte	bytecode_arrval3_ir1_ix
	.byte	bytecode_INTARR_DR

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_X

	; FOR T=1 TO 6

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	6

	; G=RND(2)

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_G

	; PRINT @A(X(T),Y(T)), A$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X(T),Y(T)), B$(G);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_G

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

LINE_83

	; PRINT @A(X,Y), A$(3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; PRINT @B(X,Y), B$(3);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrval2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; R=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_R

	; H=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_H

	; I=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_I

	; D=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	3

	; J=F(X+H)

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_X
	.byte	bytecode_INTVAR_H

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; K=F(Y+I)

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_Y
	.byte	bytecode_INTVAR_I

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_K

	; F=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_F

	; Q=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Q
	.byte	2

	; BN=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_BN

	; GOSUB 32

	.byte	bytecode_gosub_ix
	.word	LINE_32

	; GOSUB 27

	.byte	bytecode_gosub_ix
	.word	LINE_27

	; GOTO 14

	.byte	bytecode_goto_ix
	.word	LINE_14

LINE_84

	; C=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_C

	; FOR Y=1 TO 30 STEP 10

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	30

	.byte	bytecode_ld_ir1_pb
	.byte	10

	.byte	bytecode_step_ip_ir1

	; FOR X=1 TO 62 STEP 16

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	62

	.byte	bytecode_ld_ir1_pb
	.byte	16

	.byte	bytecode_step_ip_ir1

LINE_85

	; T=M(C)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_C

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_M

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; C+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_C

	; ON T GOSUB 86,88,89

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ongosub_ir1_is
	.byte	3
	.word	LINE_86, LINE_88, LINE_89

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_86

	; FOR R=X+1 TO X+15

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_for_ix_ir1
	.byte	bytecode_INTVAR_R

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	15

	.byte	bytecode_to_ip_ir1

	; IF R<64 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	64

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_87

	; RESET(R,Y)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_R

	.byte	bytecode_reset_ir1_ix
	.byte	bytecode_INTVAR_Y

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_87

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_88

	; FOR S=Y+1 TO Y+9

	.byte	bytecode_inc_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_for_ix_ir1
	.byte	bytecode_INTVAR_S

	.byte	bytecode_add_ir1_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	9

	.byte	bytecode_to_ip_ir1

	; RESET(X,S)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_reset_ir1_ix
	.byte	bytecode_INTVAR_S

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_89

	; GOSUB 86

	.byte	bytecode_gosub_ix
	.word	LINE_86

	; GOSUB 88

	.byte	bytecode_gosub_ix
	.word	LINE_88

	; IF POINT(X,Y-1)=0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_point_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_90

	; IF POINT(X-1,Y)=0 THEN

	.byte	bytecode_dec_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_point_ir1_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_90

	; RESET(X,Y)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_reset_ir1_ix
	.byte	bytecode_INTVAR_Y

LINE_90

	; RETURN

	.byte	bytecode_return

LINE_91

	; ON EX GOTO 92,93,94,95

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_EX

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_92, LINE_93, LINE_94, LINE_95

	; RETURN

	.byte	bytecode_return

LINE_92

	; FOR X=18 TO 31

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	18

	.byte	bytecode_to_ip_pb
	.byte	31

	; SET(X,1,5)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; NEXT

	.byte	bytecode_next

	; NE=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NE
	.byte	4

	; EX(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_one_ip

	; EX(2)=2

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	2

	; EX(3)=3

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	3

	; RETURN

	.byte	bytecode_return

LINE_93

	; FOR Y=12 TO 18

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	12

	.byte	bytecode_to_ip_pb
	.byte	18

	; SET(1,Y,5)

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; NEXT

	.byte	bytecode_next

	; NE=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NE
	.byte	3

	; EX(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_one_ip

	; EX(2)=2

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	2

	; EX(3)=4

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	4

	; RETURN

	.byte	bytecode_return

LINE_94

	; FOR Y=12 TO 18

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_Y
	.byte	12

	.byte	bytecode_to_ip_pb
	.byte	18

	; SET(63,Y,5)

	.byte	bytecode_ld_ir1_pb
	.byte	63

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; NEXT

	.byte	bytecode_next

	; NE=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NE
	.byte	2

	; EX(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_one_ip

	; EX(2)=3

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	3

	; EX(3)=4

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	4

	; RETURN

	.byte	bytecode_return

LINE_95

	; FOR X=34 TO 46

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_X
	.byte	34

	.byte	bytecode_to_ip_pb
	.byte	46

	; SET(X,31,5)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_pb
	.byte	31

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	5

	; NEXT

	.byte	bytecode_next

	; NE=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NE

	; EX(1)=2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	2

	; EX(2)=3

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	3

	; EX(3)=4

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_EX

	.byte	bytecode_ld_ip_pb
	.byte	4

	; RETURN

	.byte	bytecode_return

LINE_96

	; FOR X=0 TO 31

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	31

	; FOR Y=0 TO 14

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	14

	; A(X,Y)=SHIFT(Y,5)+X

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ip_ir1

	; B(X,Y)=SHIFT(Y,5)+X+32

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_arrref2_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir1_ir1_pb
	.byte	32

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_97

	; FOR X=0 TO 64

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_to_ip_pb
	.byte	64

	; E(X)=SHIFT(X,1)+5

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_E

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_add_ir1_ir1_pb
	.byte	5

	.byte	bytecode_ld_ip_ir1

	; F(X)=SHIFT(X,1)+1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; G(X)=SHIFT(X,1)-1

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_G

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_X

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_99

	; PRINT @0, B$;

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; PRINT @32, B$;

	.byte	bytecode_prat_pb
	.byte	32

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_B

	; RETURN

	.byte	bytecode_return

LINE_100

	; PRINT @483, "PRESS ANY KEY TO CONTINUE";

	.byte	bytecode_prat_pw
	.word	483

	.byte	bytecode_pr_ss
	.text	25, "PRESS ANY KEY TO CONTINUE"

LINE_101

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; T=RND(1000)

	.byte	bytecode_irnd_ir1_pw
	.word	1000

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_T

	; WHEN I$="" GOTO 101

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_ldeq_ir1_sr1_ss
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_101

LINE_102

	; RETURN

	.byte	bytecode_return

LINE_103

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; PRINT @4, "THE ASTRO DATE IS 3200\r";

	.byte	bytecode_prat_pb
	.byte	4

	.byte	bytecode_pr_ss
	.text	23, "THE ASTRO DATE IS 3200\r"

	; A$="BERZERK"

	.byte	bytecode_ld_sr1_ss
	.text	7, "BERZERK"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_A

	; FOR T=1 TO LEN(A$)

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_len_ir1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_to_ip_ir1

	; PRINT @SHIFT(T,5)+RND(3)+95, MID$(A$,T,1);

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_irnd_ir2_pb
	.byte	3

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	95

	.byte	bytecode_prat_ir1

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_pr_sr1

	; NEXT

	.byte	bytecode_next

LINE_104

	; PRINT @36, "AND YOU ARE THE LAST\r";

	.byte	bytecode_prat_pb
	.byte	36

	.byte	bytecode_pr_ss
	.text	21, "AND YOU ARE THE LAST\r"

LINE_105

	; PRINT @68, "SURVIVOR OF A SMALL GROUP\r";

	.byte	bytecode_prat_pb
	.byte	68

	.byte	bytecode_pr_ss
	.text	26, "SURVIVOR OF A SMALL GROUP\r"

LINE_106

	; PRINT @100, "OF EARTH PEOPLE WHO CAME\r";

	.byte	bytecode_prat_pb
	.byte	100

	.byte	bytecode_pr_ss
	.text	25, "OF EARTH PEOPLE WHO CAME\r"

LINE_107

	; PRINT @132, "TO EXPLORE THE PLANET\r";

	.byte	bytecode_prat_pb
	.byte	132

	.byte	bytecode_pr_ss
	.text	22, "TO EXPLORE THE PLANET\r"

LINE_108

	; PRINT @164, "MAZEON. SOON AFTER LANDING\r";

	.byte	bytecode_prat_pb
	.byte	164

	.byte	bytecode_pr_ss
	.text	27, "MAZEON. SOON AFTER LANDING\r"

LINE_109

	; PRINT @196, "YOU DISCOVERED THE PLANET\r";

	.byte	bytecode_prat_pb
	.byte	196

	.byte	bytecode_pr_ss
	.text	26, "YOU DISCOVERED THE PLANET\r"

LINE_110

	; PRINT @228, "IS A DARK UNINHABITABLE\r";

	.byte	bytecode_prat_pb
	.byte	228

	.byte	bytecode_pr_ss
	.text	24, "IS A DARK UNINHABITABLE\r"

LINE_111

	; PRINT @260, "PLACE. BUT BY THEN IT WAS\r";

	.byte	bytecode_prat_pw
	.word	260

	.byte	bytecode_pr_ss
	.text	26, "PLACE. BUT BY THEN IT WAS\r"

LINE_112

	; PRINT @292, "TOO LATE TO TURN BACK\r";

	.byte	bytecode_prat_pw
	.word	292

	.byte	bytecode_pr_ss
	.text	22, "TOO LATE TO TURN BACK\r"

LINE_113

	; PRINT @324, "BECAUSE YOUR SPACECRAFT\r";

	.byte	bytecode_prat_pw
	.word	324

	.byte	bytecode_pr_ss
	.text	24, "BECAUSE YOUR SPACECRAFT\r"

LINE_114

	; PRINT @356, "HAD BEEN DESTROYED BY THE\r";

	.byte	bytecode_prat_pw
	.word	356

	.byte	bytecode_pr_ss
	.text	26, "HAD BEEN DESTROYED BY THE\r"

LINE_115

	; PRINT @388, "AUTO-MAZEONS. NOW YOU ARE\r";

	.byte	bytecode_prat_pw
	.word	388

	.byte	bytecode_pr_ss
	.text	26, "AUTO-MAZEONS. NOW YOU ARE\r"

LINE_116

	; PRINT @420, "A PRISONER HERE.\r";

	.byte	bytecode_prat_pw
	.word	420

	.byte	bytecode_pr_ss
	.text	17, "A PRISONER HERE.\r"

	; PRINT @491, "BY JIM GERRIE";

	.byte	bytecode_prat_pw
	.word	491

	.byte	bytecode_pr_ss
	.text	13, "BY JIM GERRIE"

	; RETURN

	.byte	bytecode_return

LINE_117

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; PRINT "YOU ARE TRAPPED IN A MAZE\r";

	.byte	bytecode_pr_ss
	.text	26, "YOU ARE TRAPPED IN A MAZE\r"

LINE_118

	; PRINT "WHERE EVEN THE WALLS ARE\r";

	.byte	bytecode_pr_ss
	.text	25, "WHERE EVEN THE WALLS ARE\r"

LINE_119

	; PRINT "DEATH TO TOUCH. GRIM ROBOT\r";

	.byte	bytecode_pr_ss
	.text	27, "DEATH TO TOUCH. GRIM ROBOT\r"

LINE_120

	; PRINT "THUGS STALK YOU RELENTLESSLY...\r";

	.byte	bytecode_pr_ss
	.text	32, "THUGS STALK YOU RELENTLESSLY...\r"

LINE_121

	; PRINT @160, "USE:";

	.byte	bytecode_prat_pb
	.byte	160

	.byte	bytecode_pr_ss
	.text	4, "USE:"

LINE_122

	; PRINT @224, "DIAGONAL";

	.byte	bytecode_prat_pb
	.byte	224

	.byte	bytecode_pr_ss
	.text	8, "DIAGONAL"

	; PRINT @202, "  UP/DOWN ";

	.byte	bytecode_prat_pb
	.byte	202

	.byte	bytecode_pr_ss
	.text	10, "  UP/DOWN "

LINE_123

	; PRINT @256, "  A S   ";

	.byte	bytecode_prat_pw
	.word	256

	.byte	bytecode_pr_ss
	.text	8, "  A S   "

LINE_124

	; PRINT @288, "   Z X  ";

	.byte	bytecode_prat_pw
	.word	288

	.byte	bytecode_pr_ss
	.text	8, "   Z X  "

LINE_125

	; PRINT @234, "LEFT/RIGHT";

	.byte	bytecode_prat_pb
	.byte	234

	.byte	bytecode_pr_ss
	.text	10, "LEFT/RIGHT"

LINE_126

	; PRINT @266, "    I     ";

	.byte	bytecode_prat_pw
	.word	266

	.byte	bytecode_pr_ss
	.text	10, "    I     "

LINE_127

	; PRINT @298, "  J K L   ";

	.byte	bytecode_prat_pw
	.word	298

	.byte	bytecode_pr_ss
	.text	10, "  J K L   "

LINE_128

	; PRINT @246, "SPACE";

	.byte	bytecode_prat_pb
	.byte	246

	.byte	bytecode_pr_ss
	.text	5, "SPACE"

LINE_129

	; PRINT @278, " TO  ";

	.byte	bytecode_prat_pw
	.word	278

	.byte	bytecode_pr_ss
	.text	5, " TO  "

LINE_130

	; PRINT @310, " FIRE";

	.byte	bytecode_prat_pw
	.word	310

	.byte	bytecode_pr_ss
	.text	5, " FIRE"

LINE_131

	; PRINT @352, "THE WHITE DOOR IS THE EXIT. YOU\r";

	.byte	bytecode_prat_pw
	.word	352

	.byte	bytecode_pr_ss
	.text	32, "THE WHITE DOOR IS THE EXIT. YOU\r"

LINE_132

	; PRINT "GET EXTRA HEALTH EVERY LEVEL\r";

	.byte	bytecode_pr_ss
	.text	29, "GET EXTRA HEALTH EVERY LEVEL\r"

LINE_133

	; PRINT "CLEARED AND A LIFE EVERY 10.\r";

	.byte	bytecode_pr_ss
	.text	29, "CLEARED AND A LIFE EVERY 10.\r"

LINE_134

	; RETURN

	.byte	bytecode_return

LINE_135

	; XC=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_XC

	; YC=RR

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_YC
	.byte	bytecode_INTVAR_RR

	; PC=3-SHIFT(RR,1)

	.byte	bytecode_dbl_ir1_ix
	.byte	bytecode_INTVAR_RR

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	3

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_PC

LINE_136

	; GOSUB 142

	.byte	bytecode_gosub_ix
	.word	LINE_142

LINE_137

	; IF PC<0 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_PC

	.byte	bytecode_ldlt_ir1_ir1_pb
	.byte	0

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_138

	; PC+=SHIFT(XC,2)+6

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	6

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_PC

	; GOTO 139

	.byte	bytecode_goto_ix
	.word	LINE_139

LINE_138

	; PC+=SHIFT(XC-YC,2)+10

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_XC
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	2

	.byte	bytecode_add_ir1_ir1_pb
	.byte	10

	.byte	bytecode_add_ix_ix_ir1
	.byte	bytecode_INTVAR_PC

	; YC-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_YC

LINE_139

	; XC+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_XC

	; WHEN XC<YC GOTO 136

	.byte	bytecode_ldlt_ir1_ix_id
	.byte	bytecode_INTVAR_XC
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_136

LINE_140

	; WHEN XC=YC GOSUB 142

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_XC
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_142

LINE_141

	; RETURN

	.byte	bytecode_return

LINE_142

	; XX=CX+XC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY+YC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_143

	; XX=CX-XC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY+YC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_144

	; XX=CX+XC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY-YC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_145

	; XX=CX-XC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY-YC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_146

	; XX=CX+YC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY+XC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_147

	; XX=CX-YC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY+XC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_148

	; XX=CX+YC

	.byte	bytecode_add_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY-XC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_149

	; XX=CX-YC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CX
	.byte	bytecode_INTVAR_YC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_XX

	; YY=CY-XC

	.byte	bytecode_sub_ir1_ix_id
	.byte	bytecode_INTVAR_CY
	.byte	bytecode_INTVAR_XC

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_YY

	; SET(XX,YY,6)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_XX

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_YY

	.byte	bytecode_setc_ir1_ir2_pb
	.byte	6

LINE_150

	; RETURN

	.byte	bytecode_return

LINE_151

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; WHEN SC=0 GOTO 161

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_161

LINE_152

	; IF SC<15000 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ldlt_ir1_ir1_pw
	.word	15000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_153

	; A$="THE HUMANOID MUST NOT ESCAPE!"

	.byte	bytecode_ld_sr1_ss
	.text	29, "THE HUMANOID MUST NOT ESCAPE!"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_A

	; SM=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_SM

LINE_153

	; IF (SC>=15000) AND (SC<30000) THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ldge_ir1_ir1_pw
	.word	15000

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ldlt_ir2_ir2_pw
	.word	30000

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_154

	; A$="THE HUMANOID IS ABOUT TO ESCAPE"

	.byte	bytecode_ld_sr1_ss
	.text	31, "THE HUMANOID IS ABOUT TO ESCAPE"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_A

	; SM=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_SM

LINE_154

	; IF SC>=25000 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ldge_ir1_ir1_pw
	.word	25000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_155

	; A$="THE HUMANOID ESCAPED!"

	.byte	bytecode_ld_sr1_ss
	.text	21, "THE HUMANOID ESCAPED!"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_A

	; SM=-1

	.byte	bytecode_true_ix
	.byte	bytecode_INTVAR_SM

LINE_155

	; RR=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_RR
	.byte	5

	; CX=31

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_CX
	.byte	31

	; CY=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_CY
	.byte	15

	; GOSUB 135

	.byte	bytecode_gosub_ix
	.word	LINE_135

	; PRINT @239, A$(12);

	.byte	bytecode_prat_pb
	.byte	239

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_A

	.byte	bytecode_pr_sr1

	; IF SM THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SM

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_156

	; PRINT @271, B$(12);

	.byte	bytecode_prat_pw
	.word	271

	.byte	bytecode_ld_ir1_pb
	.byte	12

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

	; GOTO 157

	.byte	bytecode_goto_ix
	.word	LINE_157

LINE_156

	; PRINT @271, B$(13);

	.byte	bytecode_prat_pw
	.word	271

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrval1_ir1_sx
	.byte	bytecode_STRARR_B

	.byte	bytecode_pr_sr1

LINE_157

	; PRINT @INT(SHIFT(32-LEN(A$),-1))+480,

	.byte	bytecode_len_ir1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_rsub_ir1_ir1_pb
	.byte	32

	.byte	bytecode_hlf_fr1_ir1

	.byte	bytecode_add_ir1_ir1_pw
	.word	480

	.byte	bytecode_prat_ir1

	; FOR T=1 TO LEN(A$)

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_len_ir1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_to_ip_ir1

	; PRINT MID$(A$,T,1);

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_ld_ir2_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_midT_sr1_sr1_pb
	.byte	1

	.byte	bytecode_pr_sr1

	; SOUND 222,1

	.byte	bytecode_ld_ir1_pb
	.byte	222

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

LINE_158

	; FOR T=1 TO 2000

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pw
	.word	2000

	; NEXT

	.byte	bytecode_next

LINE_159

	; IF SC>=25000 THEN

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_SC

	.byte	bytecode_ldge_ir1_ir1_pw
	.word	25000

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_160

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

	; PRINT "DEDICATED TO P,M,C & N\r";

	.byte	bytecode_pr_ss
	.text	23, "DEDICATED TO P,M,C & N\r"

	; END

	.byte	bytecode_progend

LINE_160

	; RETURN

	.byte	bytecode_return

LINE_161

	; FOR T=3 TO 4

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	3

	.byte	bytecode_to_ip_pb
	.byte	4

	; CLS T

	.byte	bytecode_clsn_ix
	.byte	bytecode_INTVAR_T

	; PRINT @233, "INTRUDER ALERT!";

	.byte	bytecode_prat_pb
	.byte	233

	.byte	bytecode_pr_ss
	.text	15, "INTRUDER ALERT!"

	; SOUND 50,2

	.byte	bytecode_ld_ir1_pb
	.byte	50

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; SOUND 5,2

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; SOUND 1,2

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_162

	; K(76)=1

	.byte	bytecode_ld_ir1_pb
	.byte	76

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_one_ip

	; K(83)=2

	.byte	bytecode_ld_ir1_pb
	.byte	83

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(88)=3

	.byte	bytecode_ld_ir1_pb
	.byte	88

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	3

	; K(74)=4

	.byte	bytecode_ld_ir1_pb
	.byte	74

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	4

	; K(65)=5

	.byte	bytecode_ld_ir1_pb
	.byte	65

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	5

	; K(90)=6

	.byte	bytecode_ld_ir1_pb
	.byte	90

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	6

	; K(75)=7

	.byte	bytecode_ld_ir1_pb
	.byte	75

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	7

	; K(73)=8

	.byte	bytecode_ld_ir1_pb
	.byte	73

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	8

	; K(32)=9

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	9

LINE_163

	; N(1)=1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_one_ip

	; Q(1)=0

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_clr_ip

	; L(1)=3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	3

	; N(2)=1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_one_ip

	; Q(2)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_true_ip

	; L(2)=4

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	4

	; N(3)=1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_one_ip

	; Q(3)=1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_one_ip

	; L(3)=5

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	5

	; N(4)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_true_ip

	; Q(4)=0

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_clr_ip

	; L(4)=6

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	6

LINE_164

	; N(5)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_true_ip

	; Q(5)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_true_ip

	; L(5)=7

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	7

	; N(6)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_true_ip

	; Q(6)=1

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_one_ip

	; L(6)=8

	.byte	bytecode_ld_ir1_pb
	.byte	6

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	8

	; N(7)=0

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_clr_ip

	; Q(7)=1

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_one_ip

	; L(7)=9

	.byte	bytecode_ld_ir1_pb
	.byte	7

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	9

	; N(8)=0

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_clr_ip

	; Q(8)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_Q

	.byte	bytecode_true_ip

	; L(8)=9

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrref1_ir1_ix
	.byte	bytecode_INTARR_L

	.byte	bytecode_ld_ip_pb
	.byte	9

	; RETURN

	.byte	bytecode_return

LINE_169

LINE_170

LINE_171

LINE_172

LINE_173

LINE_174

LINE_175

LINE_176

LINE_177

LINE_178

LINE_179

LINE_180

LINE_181

LINE_182

LINE_183

LINE_184

LINE_185

LINE_186

LINE_187

LINE_188

LINE_189

LINE_190

LINE_191

LINE_192

LINE_193

LINE_194

LINE_195

LINE_196

LINE_197

LINE_198

LINE_199

LINE_200

LINE_201

LINE_202

LINE_203

LINE_204

LINE_205

LINE_206

LINE_207

LINE_208

LINE_209

LINE_210

LINE_211

LINE_212

LINE_213

LINE_214

LINE_215

LINE_216

LINE_217

LINE_218

LINE_219

LINE_220

LINE_221

LINE_222

LINE_223

LINE_224

LINE_225

LINE_226

LINE_227

LINE_228

LINE_229

LINE_230

LINE_231

LINE_232

LINE_233

LINE_234

LINE_235

LINE_236

LINE_237

LINE_238

LINE_239

LINE_240

LINE_300

	; J=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_J

	; IF PEEK(2) AND NOT PEEK(16952) AND 8 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16952

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	8

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_310

	; J=K(32)

	.byte	bytecode_ld_ir1_pb
	.byte	32

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_310

	; IF PEEK(2) AND NOT PEEK(16946) AND 2 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16946

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_320

	; J=K(73)

	.byte	bytecode_ld_ir1_pb
	.byte	73

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_320

	; IF PEEK(2) AND NOT PEEK(16947) AND 2 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16947

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_330

	; J=K(74)

	.byte	bytecode_ld_ir1_pb
	.byte	74

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_330

	; IF PEEK(2) AND NOT PEEK(16948) AND 2 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16948

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_340

	; J=K(75)

	.byte	bytecode_ld_ir1_pb
	.byte	75

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_340

	; IF PEEK(2) AND NOT PEEK(16949) AND 2 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16949

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_350

	; J=K(76)

	.byte	bytecode_ld_ir1_pb
	.byte	76

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_350

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16946

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_360

	; J=K(65)

	.byte	bytecode_ld_ir1_pb
	.byte	65

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_360

	; IF PEEK(2) AND NOT PEEK(16948) AND 4 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16948

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_370

	; J=K(83)

	.byte	bytecode_ld_ir1_pb
	.byte	83

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_370

	; IF PEEK(2) AND NOT PEEK(16947) AND 8 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16947

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	8

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_380

	; J=K(90)

	.byte	bytecode_ld_ir1_pb
	.byte	90

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_380

	; IF PEEK(2) AND NOT PEEK(16945) AND 8 THEN

	.byte	bytecode_peek_ir1_pb
	.byte	2

	.byte	bytecode_peek_ir2_pw
	.word	16945

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	8

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_390

	; J=K(88)

	.byte	bytecode_ld_ir1_pb
	.byte	88

	.byte	bytecode_arrval1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_J

	; RETURN

	.byte	bytecode_return

LINE_390

	; RETURN

	.byte	bytecode_return

LINE_400

	; PRINT @482, "SELECT LEVEL OF PLAY (1-3)?";

	.byte	bytecode_prat_pw
	.word	482

	.byte	bytecode_pr_ss
	.text	27, "SELECT LEVEL OF PLAY (1-3)?"

LINE_401

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; WHEN (I$<"1") OR (I$>"3") GOTO 401

	.byte	bytecode_ld_sr1_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_ldlt_ir1_sr1_ss
	.text	1, "1"

	.byte	bytecode_ld_sr2_ss
	.text	1, "3"

	.byte	bytecode_ldlt_ir2_sr2_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_401

LINE_402

	; Z3=550-(INT(VAL(I$))*50)

	.byte	bytecode_val_fr1_sx
	.byte	bytecode_STRVAR_I

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	50

	.byte	bytecode_rsub_ir1_ir1_pw
	.word	550

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_Z3

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_ip_ip_ir1	.equ	0
bytecode_add_ir1_ir1_ir2	.equ	1
bytecode_add_ir1_ir1_ix	.equ	2
bytecode_add_ir1_ir1_pb	.equ	3
bytecode_add_ir1_ir1_pw	.equ	4
bytecode_add_ir1_ix_id	.equ	5
bytecode_add_ir1_ix_pb	.equ	6
bytecode_add_ir2_ix_id	.equ	7
bytecode_add_ir2_ix_pb	.equ	8
bytecode_add_ir3_ix_pb	.equ	9
bytecode_add_ix_ix_ir1	.equ	10
bytecode_add_ix_ix_pb	.equ	11
bytecode_and_ir1_ir1_ir2	.equ	12
bytecode_and_ir1_ir1_pb	.equ	13
bytecode_arrdim1_ir1_ix	.equ	14
bytecode_arrdim1_ir1_sx	.equ	15
bytecode_arrdim2_ir1_ix	.equ	16
bytecode_arrdim3_ir1_ix	.equ	17
bytecode_arrref1_ir1_ix	.equ	18
bytecode_arrref1_ir1_sx	.equ	19
bytecode_arrref2_ir1_ix	.equ	20
bytecode_arrref3_ir1_ix	.equ	21
bytecode_arrval1_ir1_ix	.equ	22
bytecode_arrval1_ir1_sx	.equ	23
bytecode_arrval1_ir2_ix	.equ	24
bytecode_arrval2_ir1_ix	.equ	25
bytecode_arrval2_ir2_ix	.equ	26
bytecode_arrval3_ir1_ix	.equ	27
bytecode_chr_sr1_ir1	.equ	28
bytecode_chr_sr2_ir2	.equ	29
bytecode_clear	.equ	30
bytecode_clr_ip	.equ	31
bytecode_clr_ix	.equ	32
bytecode_cls	.equ	33
bytecode_clsn_ix	.equ	34
bytecode_clsn_pb	.equ	35
bytecode_com_ir2_ir2	.equ	36
bytecode_dbl_ir1_ir1	.equ	37
bytecode_dbl_ir1_ix	.equ	38
bytecode_dec_ip_ip	.equ	39
bytecode_dec_ir1_ir1	.equ	40
bytecode_dec_ir1_ix	.equ	41
bytecode_dec_ir2_ix	.equ	42
bytecode_dec_ix_ix	.equ	43
bytecode_for_ix_ir1	.equ	44
bytecode_for_ix_pb	.equ	45
bytecode_forclr_ix	.equ	46
bytecode_forone_ix	.equ	47
bytecode_gosub_ix	.equ	48
bytecode_goto_ix	.equ	49
bytecode_hlf_fr1_ir1	.equ	50
bytecode_inc_ip_ip	.equ	51
bytecode_inc_ir1_ir1	.equ	52
bytecode_inc_ir1_ix	.equ	53
bytecode_inc_ir2_ix	.equ	54
bytecode_inc_ix_ix	.equ	55
bytecode_inkey_sx	.equ	56
bytecode_irnd_ir1_pb	.equ	57
bytecode_irnd_ir1_pw	.equ	58
bytecode_irnd_ir2_pb	.equ	59
bytecode_jmpeq_ir1_ix	.equ	60
bytecode_jmpne_ir1_ix	.equ	61
bytecode_jsrne_ir1_ix	.equ	62
bytecode_ld_id_ix	.equ	63
bytecode_ld_ip_ir1	.equ	64
bytecode_ld_ip_pb	.equ	65
bytecode_ld_ir1_ix	.equ	66
bytecode_ld_ir1_pb	.equ	67
bytecode_ld_ir2_ix	.equ	68
bytecode_ld_ir2_pb	.equ	69
bytecode_ld_ir3_pb	.equ	70
bytecode_ld_ix_ir1	.equ	71
bytecode_ld_ix_pb	.equ	72
bytecode_ld_ix_pw	.equ	73
bytecode_ld_sp_sr1	.equ	74
bytecode_ld_sr1_ss	.equ	75
bytecode_ld_sr1_sx	.equ	76
bytecode_ld_sr2_ss	.equ	77
bytecode_ld_sx_sr1	.equ	78
bytecode_ldeq_ir1_ir1_ir2	.equ	79
bytecode_ldeq_ir1_ir1_pb	.equ	80
bytecode_ldeq_ir1_ix_id	.equ	81
bytecode_ldeq_ir1_sr1_ss	.equ	82
bytecode_ldeq_ir2_ir2_pb	.equ	83
bytecode_ldge_ir1_ir1_pb	.equ	84
bytecode_ldge_ir1_ir1_pw	.equ	85
bytecode_ldlt_ir1_ir1_ix	.equ	86
bytecode_ldlt_ir1_ir1_pb	.equ	87
bytecode_ldlt_ir1_ir1_pw	.equ	88
bytecode_ldlt_ir1_ix_id	.equ	89
bytecode_ldlt_ir1_sr1_ss	.equ	90
bytecode_ldlt_ir2_ir2_pw	.equ	91
bytecode_ldlt_ir2_sr2_sx	.equ	92
bytecode_ldne_ir2_ir2_pb	.equ	93
bytecode_len_ir1_sx	.equ	94
bytecode_midT_sr1_sr1_pb	.equ	95
bytecode_mul_ir1_ir1_pb	.equ	96
bytecode_next	.equ	97
bytecode_one_ip	.equ	98
bytecode_one_ix	.equ	99
bytecode_ongosub_ir1_is	.equ	100
bytecode_ongoto_ir1_is	.equ	101
bytecode_or_ir1_ir1_ir2	.equ	102
bytecode_peek_ir1_pb	.equ	103
bytecode_peek_ir1_pw	.equ	104
bytecode_peek_ir2_pw	.equ	105
bytecode_point_ir1_ir1_ir2	.equ	106
bytecode_point_ir1_ir1_ix	.equ	107
bytecode_point_ir2_ir2_ir3	.equ	108
bytecode_point_ir2_ir2_ix	.equ	109
bytecode_poke_pw_ir1	.equ	110
bytecode_pr_sr1	.equ	111
bytecode_pr_ss	.equ	112
bytecode_pr_sx	.equ	113
bytecode_prat_ir1	.equ	114
bytecode_prat_pb	.equ	115
bytecode_prat_pw	.equ	116
bytecode_progbegin	.equ	117
bytecode_progend	.equ	118
bytecode_read_fx	.equ	119
bytecode_read_sx	.equ	120
bytecode_reset_ir1_ix	.equ	121
bytecode_reset_ir1_pb	.equ	122
bytecode_restore	.equ	123
bytecode_return	.equ	124
bytecode_rnd_fr1_ir1	.equ	125
bytecode_rsub_ir1_ir1_ix	.equ	126
bytecode_rsub_ir1_ir1_pb	.equ	127
bytecode_rsub_ir1_ir1_pw	.equ	128
bytecode_setc_ir1_ir2_ix	.equ	129
bytecode_setc_ir1_ir2_pb	.equ	130
bytecode_sgn_ir1_ir1	.equ	131
bytecode_shift_ir1_ir1_pb	.equ	132
bytecode_sound_ir1_ir2	.equ	133
bytecode_step_ip_ir1	.equ	134
bytecode_str_sr1_ix	.equ	135
bytecode_strcat_sr1_sr1_sr2	.equ	136
bytecode_strinit_sr1_sr1	.equ	137
bytecode_sub_ir1_ix_id	.equ	138
bytecode_to_ip_ir1	.equ	139
bytecode_to_ip_ix	.equ	140
bytecode_to_ip_pb	.equ	141
bytecode_to_ip_pw	.equ	142
bytecode_true_ip	.equ	143
bytecode_true_ix	.equ	144
bytecode_val_fr1_sr1	.equ	145
bytecode_val_fr1_sx	.equ	146

catalog
	.word	add_ip_ip_ir1
	.word	add_ir1_ir1_ir2
	.word	add_ir1_ir1_ix
	.word	add_ir1_ir1_pb
	.word	add_ir1_ir1_pw
	.word	add_ir1_ix_id
	.word	add_ir1_ix_pb
	.word	add_ir2_ix_id
	.word	add_ir2_ix_pb
	.word	add_ir3_ix_pb
	.word	add_ix_ix_ir1
	.word	add_ix_ix_pb
	.word	and_ir1_ir1_ir2
	.word	and_ir1_ir1_pb
	.word	arrdim1_ir1_ix
	.word	arrdim1_ir1_sx
	.word	arrdim2_ir1_ix
	.word	arrdim3_ir1_ix
	.word	arrref1_ir1_ix
	.word	arrref1_ir1_sx
	.word	arrref2_ir1_ix
	.word	arrref3_ir1_ix
	.word	arrval1_ir1_ix
	.word	arrval1_ir1_sx
	.word	arrval1_ir2_ix
	.word	arrval2_ir1_ix
	.word	arrval2_ir2_ix
	.word	arrval3_ir1_ix
	.word	chr_sr1_ir1
	.word	chr_sr2_ir2
	.word	clear
	.word	clr_ip
	.word	clr_ix
	.word	cls
	.word	clsn_ix
	.word	clsn_pb
	.word	com_ir2_ir2
	.word	dbl_ir1_ir1
	.word	dbl_ir1_ix
	.word	dec_ip_ip
	.word	dec_ir1_ir1
	.word	dec_ir1_ix
	.word	dec_ir2_ix
	.word	dec_ix_ix
	.word	for_ix_ir1
	.word	for_ix_pb
	.word	forclr_ix
	.word	forone_ix
	.word	gosub_ix
	.word	goto_ix
	.word	hlf_fr1_ir1
	.word	inc_ip_ip
	.word	inc_ir1_ir1
	.word	inc_ir1_ix
	.word	inc_ir2_ix
	.word	inc_ix_ix
	.word	inkey_sx
	.word	irnd_ir1_pb
	.word	irnd_ir1_pw
	.word	irnd_ir2_pb
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	jsrne_ir1_ix
	.word	ld_id_ix
	.word	ld_ip_ir1
	.word	ld_ip_pb
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_ix
	.word	ld_ir2_pb
	.word	ld_ir3_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ld_ix_pw
	.word	ld_sp_sr1
	.word	ld_sr1_ss
	.word	ld_sr1_sx
	.word	ld_sr2_ss
	.word	ld_sx_sr1
	.word	ldeq_ir1_ir1_ir2
	.word	ldeq_ir1_ir1_pb
	.word	ldeq_ir1_ix_id
	.word	ldeq_ir1_sr1_ss
	.word	ldeq_ir2_ir2_pb
	.word	ldge_ir1_ir1_pb
	.word	ldge_ir1_ir1_pw
	.word	ldlt_ir1_ir1_ix
	.word	ldlt_ir1_ir1_pb
	.word	ldlt_ir1_ir1_pw
	.word	ldlt_ir1_ix_id
	.word	ldlt_ir1_sr1_ss
	.word	ldlt_ir2_ir2_pw
	.word	ldlt_ir2_sr2_sx
	.word	ldne_ir2_ir2_pb
	.word	len_ir1_sx
	.word	midT_sr1_sr1_pb
	.word	mul_ir1_ir1_pb
	.word	next
	.word	one_ip
	.word	one_ix
	.word	ongosub_ir1_is
	.word	ongoto_ir1_is
	.word	or_ir1_ir1_ir2
	.word	peek_ir1_pb
	.word	peek_ir1_pw
	.word	peek_ir2_pw
	.word	point_ir1_ir1_ir2
	.word	point_ir1_ir1_ix
	.word	point_ir2_ir2_ir3
	.word	point_ir2_ir2_ix
	.word	poke_pw_ir1
	.word	pr_sr1
	.word	pr_ss
	.word	pr_sx
	.word	prat_ir1
	.word	prat_pb
	.word	prat_pw
	.word	progbegin
	.word	progend
	.word	read_fx
	.word	read_sx
	.word	reset_ir1_ix
	.word	reset_ir1_pb
	.word	restore
	.word	return
	.word	rnd_fr1_ir1
	.word	rsub_ir1_ir1_ix
	.word	rsub_ir1_ir1_pb
	.word	rsub_ir1_ir1_pw
	.word	setc_ir1_ir2_ix
	.word	setc_ir1_ir2_pb
	.word	sgn_ir1_ir1
	.word	shift_ir1_ir1_pb
	.word	sound_ir1_ir2
	.word	step_ip_ir1
	.word	str_sr1_ix
	.word	strcat_sr1_sr1_sr2
	.word	strinit_sr1_sr1
	.word	sub_ir1_ix_id
	.word	to_ip_ir1
	.word	to_ip_ix
	.word	to_ip_pb
	.word	to_ip_pw
	.word	true_ip
	.word	true_ix
	.word	val_fr1_sr1
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

	.module	mdgetge
getge
	bge	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdgetlo
getlo
	blo	_1
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

	.module	mdref3
; get offset from 3D descriptor X and argv.
; return word offset in D and byte offset in tmp1
ref3
	ldd	,x
	beq	_err
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

	.module	mdrnstrng
; read numeric DATA when records are pure strings
; EXIT:  flt in tmp1+1, tmp2, tmp3
rnstrng
	pshx
	jsr	rpstrng
	ldx	#tmp1+1
	jsr	strval
	pulx
	rts

	.module	mdrpstrng
; read string DATA when records are pure strings
; EXIT:  data string descriptor in tmp1+1, tmp2
rpstrng
	pshx
	ldx	DP_DATA
	cpx	#enddata
	blo	_ok
	ldab	#OD_ERROR
	jmp	error
_ok
	ldab	,x
	stab	tmp1+1
	inx
	stx	tmp2
	abx
	stx	DP_DATA
	pulx
	rts

	.module	mdrsstrng
; read string DATA when records are pure strings
; ENTRY: X holds destination string descriptor
; EXIT:  data table read, and perm string created in X
rsstrng
	jsr	strdel
	jsr	rpstrng
	ldab	tmp1+1
	stab	0,X
	ldd	tmp2
	std	1,X
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

	.module	mdstrlo
strlo
	stab	tmp1+1
	ldx	1+argv
	jsr	strrel
	ldx	tmp2
	jsr	strrel
	cmpb	0+argv
	bls	_ok
	ldab	0+argv
_ok
	sts	tmp3
	lds	1+argv
	des
	ldx	tmp2
	tstb
	beq	_tie
	dex
_nxtchr
	inx
	pula
	cmpa	,x
	bne	_done
	decb
	bne	_nxtchr
_tie
	ldab	0+argv
	cmpb	tmp1+1
_done
	tpa
	lds	tmp3
	tap
	rts

	.module	mdstrlobs
strlobs
	jsr	immstr
	stx	tmp2
	bra	strlo

	.module	mdstrlox
strlox
	ldab	,x
	ldx	1,x
	stx	tmp2
	bra	strlo

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

add_ip_ip_ir1			; numCalls = 2
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

add_ir1_ir1_ir2			; numCalls = 5
	.module	modadd_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 2
	.module	modadd_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 7
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

add_ir1_ix_id			; numCalls = 18
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

add_ir2_ix_id			; numCalls = 6
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

add_ir3_ix_pb			; numCalls = 2
	.module	modadd_ir3_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	r3+1
	ldab	#0
	adcb	0,x
	stab	r3
	rts

add_ix_ix_ir1			; numCalls = 8
	.module	modadd_ix_ix_ir1
	jsr	extend
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 3
	.module	modadd_ix_ix_pb
	jsr	extbyte
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 11
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

and_ir1_ir1_pb			; numCalls = 9
	.module	modand_ir1_ir1_pb
	jsr	getbyte
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

arrdim1_ir1_ix			; numCalls = 14
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

arrdim2_ir1_ix			; numCalls = 4
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

arrref1_ir1_ix			; numCalls = 68
	.module	modarrref1_ir1_ix
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx			; numCalls = 2
	.module	modarrref1_ir1_sx
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
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

arrref3_ir1_ix			; numCalls = 2
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

arrval1_ir1_ix			; numCalls = 74
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

arrval1_ir1_sx			; numCalls = 37
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

arrval1_ir2_ix			; numCalls = 34
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

arrval2_ir1_ix			; numCalls = 54
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

arrval2_ir2_ix			; numCalls = 2
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

arrval3_ir1_ix			; numCalls = 4
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

chr_sr1_ir1			; numCalls = 2
	.module	modchr_sr1_ir1
	jsr	noargs
	ldd	#$0100+(charpage>>8)
	std	r1
	rts

chr_sr2_ir2			; numCalls = 2
	.module	modchr_sr2_ir2
	jsr	noargs
	ldd	#$0100+(charpage>>8)
	std	r2
	rts

clear			; numCalls = 1
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

clr_ip			; numCalls = 6
	.module	modclr_ip
	jsr	noargs
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 22
	.module	modclr_ix
	jsr	extend
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 1
	.module	modcls
	jsr	noargs
	jmp	R_CLS

clsn_ix			; numCalls = 1
	.module	modclsn_ix
	jsr	extend
	ldd	0,x
	bne	_fcerror
	ldab	2,x
	jmp	R_CLSN
_fcerror
	ldab	#FC_ERROR
	jmp	error

clsn_pb			; numCalls = 6
	.module	modclsn_pb
	jsr	getbyte
	jmp	R_CLSN

com_ir2_ir2			; numCalls = 9
	.module	modcom_ir2_ir2
	jsr	noargs
	com	r2+2
	com	r2+1
	com	r2
	rts

dbl_ir1_ir1			; numCalls = 4
	.module	moddbl_ir1_ir1
	jsr	noargs
	ldx	#r1
	rol	2,x
	rol	1,x
	rol	0,x
	rts

dbl_ir1_ix			; numCalls = 11
	.module	moddbl_ir1_ix
	jsr	extend
	ldd	1,x
	lsld
	std	r1+1
	ldab	0,x
	rolb
	stab	r1
	rts

dec_ip_ip			; numCalls = 2
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

dec_ir1_ix			; numCalls = 2
	.module	moddec_ir1_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ir2_ix			; numCalls = 1
	.module	moddec_ir2_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	r2+1
	ldab	0,x
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 2
	.module	moddec_ix_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_ix_ir1			; numCalls = 2
	.module	modfor_ix_ir1
	jsr	extend
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 5
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

forclr_ix			; numCalls = 5
	.module	modforclr_ix
	jsr	extend
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 34
	.module	modforone_ix
	jsr	extend
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 28
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

goto_ix			; numCalls = 22
	.module	modgoto_ix
	jsr	getaddr
	stx	nxtinst
	rts

hlf_fr1_ir1			; numCalls = 1
	.module	modhlf_fr1_ir1
	jsr	noargs
	asr	r1
	ror	r1+1
	ror	r1+2
	ldd	#0
	rora
	std	r1+3
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

inc_ir1_ir1			; numCalls = 1
	.module	modinc_ir1_ir1
	jsr	noargs
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 2
	.module	modinc_ir1_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir2_ix			; numCalls = 4
	.module	modinc_ir2_ix
	jsr	extend
	ldd	1,x
	addd	#1
	std	r2+1
	ldab	0,x
	adcb	#0
	stab	r2
	rts

inc_ix_ix			; numCalls = 6
	.module	modinc_ix_ix
	jsr	extend
	inc	2,x
	bne	_rts
	inc	1,x
	bne	_rts
	inc	0,x
_rts
	rts

inkey_sx			; numCalls = 4
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

irnd_ir1_pb			; numCalls = 8
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

irnd_ir1_pw			; numCalls = 1
	.module	modirnd_ir1_pw
	jsr	getword
	clr	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

irnd_ir2_pb			; numCalls = 1
	.module	modirnd_ir2_pb
	jsr	getbyte
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r2+1
	ldab	tmp1
	stab	r2
	rts

jmpeq_ir1_ix			; numCalls = 37
	.module	modjmpeq_ir1_ix
	jsr	getaddr
	ldd	r1+1
	bne	_rts
	ldaa	r1
	bne	_rts
	stx	nxtinst
_rts
	rts

jmpne_ir1_ix			; numCalls = 10
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

jsrne_ir1_ix			; numCalls = 4
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

ld_id_ix			; numCalls = 10
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

ld_ip_ir1			; numCalls = 13
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 30
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 204
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 146
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 86
	.module	modld_ir2_ix
	jsr	extend
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 53
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_pb			; numCalls = 9
	.module	modld_ir3_pb
	jsr	getbyte
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ix_ir1			; numCalls = 63
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 20
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 2
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 2
	.module	modld_sp_sr1
	jsr	noargs
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 5
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

ld_sr1_sx			; numCalls = 8
	.module	modld_sr1_sx
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sr2_ss			; numCalls = 1
	.module	modld_sr2_ss
	ldx	curinst
	inx
	ldab	,x
	stab	r2
	inx
	stx	r2+1
	abx
	stx	nxtinst
	rts

ld_sx_sr1			; numCalls = 5
	.module	modld_sx_sr1
	jsr	extend
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ldeq_ir1_ir1_ir2			; numCalls = 2
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

ldeq_ir1_ir1_pb			; numCalls = 9
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

ldeq_ir1_sr1_ss			; numCalls = 4
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

ldeq_ir2_ir2_pb			; numCalls = 3
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

ldge_ir1_ir1_pb			; numCalls = 1
	.module	modldge_ir1_ir1_pb
	jsr	getbyte
	clra
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_ir1_pw			; numCalls = 3
	.module	modldge_ir1_ir1_pw
	jsr	getword
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ix			; numCalls = 6
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

ldlt_ir1_ir1_pb			; numCalls = 2
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

ldlt_ir1_ir1_pw			; numCalls = 2
	.module	modldlt_ir1_ir1_pw
	jsr	getword
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
	jsr	extdex
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

ldlt_ir1_sr1_ss			; numCalls = 1
	.module	modldlt_ir1_sr1_ss
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jsr	strlobs
	jsr	getlo
	std	r1+1
	stab	r1
	rts

ldlt_ir2_ir2_pw			; numCalls = 1
	.module	modldlt_ir2_ir2_pw
	jsr	getword
	std	tmp1
	ldd	r2+1
	subd	tmp1
	ldab	r2
	sbcb	#0
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_sr2_sx			; numCalls = 1
	.module	modldlt_ir2_sr2_sx
	jsr	extend
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	jsr	strlox
	jsr	getlo
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

len_ir1_sx			; numCalls = 3
	.module	modlen_ir1_sx
	jsr	extend
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

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

mul_ir1_ir1_pb			; numCalls = 3
	.module	modmul_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

next			; numCalls = 52
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

one_ip			; numCalls = 15
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

ongoto_ir1_is			; numCalls = 20
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

peek_ir1_pb			; numCalls = 9
	.module	modpeek_ir1_pb
	jsr	getbyte
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pw			; numCalls = 2
	.module	modpeek_ir1_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_pw			; numCalls = 11
	.module	modpeek_ir2_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

point_ir1_ir1_ir2			; numCalls = 9
	.module	modpoint_ir1_ir1_ir2
	jsr	noargs
	ldaa	r2+2
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

point_ir1_ir1_ix			; numCalls = 12
	.module	modpoint_ir1_ir1_ix
	jsr	extend
	ldaa	2,x
	ldab	r1+2
	jsr	point
	stab	r1+2
	tab
	std	r1
	rts

point_ir2_ir2_ir3			; numCalls = 2
	.module	modpoint_ir2_ir2_ir3
	jsr	noargs
	ldaa	r3+2
	ldab	r2+2
	jsr	point
	stab	r2+2
	tab
	std	r2
	rts

point_ir2_ir2_ix			; numCalls = 1
	.module	modpoint_ir2_ir2_ix
	jsr	extend
	ldaa	2,x
	ldab	r2+2
	jsr	point
	stab	r2+2
	tab
	std	r2
	rts

poke_pw_ir1			; numCalls = 2
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

pr_ss			; numCalls = 48
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

pr_sx			; numCalls = 18
	.module	modpr_sx
	jsr	extend
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 52
	.module	modprat_ir1
	jsr	noargs
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 19
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 24
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

progend			; numCalls = 3
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

read_fx			; numCalls = 6
	.module	modread_fx
	jsr	extend
	jsr	rnstrng
	ldab	tmp1+1
	stab	0,x
	ldd	tmp2
	std	1,x
	ldd	tmp3
	std	3,x
	rts

read_sx			; numCalls = 2
	.module	modread_sx
	jsr	extend
	jmp	rsstrng

reset_ir1_ix			; numCalls = 6
	.module	modreset_ir1_ix
	jsr	extend
	ldaa	2,x
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

reset_ir1_pb			; numCalls = 1
	.module	modreset_ir1_pb
	jsr	getbyte
	tba
	ldab	r1+2
	jsr	getxym
	jmp	R_CLRPX

restore			; numCalls = 1
	.module	modrestore
	jsr	noargs
	ldx	#startdata
	stx	DP_DATA
	rts

return			; numCalls = 51
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

rsub_ir1_ir1_ix			; numCalls = 2
	.module	modrsub_ir1_ir1_ix
	jsr	extend
	ldd	1,x
	subd	r1+1
	std	r1+1
	ldab	0,x
	sbcb	r1
	stab	r1
	rts

rsub_ir1_ir1_pb			; numCalls = 3
	.module	modrsub_ir1_ir1_pb
	jsr	getbyte
	clra
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

rsub_ir1_ir1_pw			; numCalls = 1
	.module	modrsub_ir1_ir1_pw
	jsr	getword
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

setc_ir1_ir2_ix			; numCalls = 1
	.module	modsetc_ir1_ir2_ix
	jsr	extend
	ldab	2,x
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

setc_ir1_ir2_pb			; numCalls = 33
	.module	modsetc_ir1_ir2_pb
	jsr	getbyte
	pshb
	ldaa	r2+2
	ldab	r1+2
	jsr	getxym
	pulb
	jmp	setc

sgn_ir1_ir1			; numCalls = 2
	.module	modsgn_ir1_ir1
	jsr	noargs
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

shift_ir1_ir1_pb			; numCalls = 5
	.module	modshift_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 26
	.module	modsound_ir1_ir2
	jsr	noargs
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 2
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

strcat_sr1_sr1_sr2			; numCalls = 2
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

strinit_sr1_sr1			; numCalls = 2
	.module	modstrinit_sr1_sr1
	jsr	noargs
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

sub_ir1_ix_id			; numCalls = 9
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

to_ip_ir1			; numCalls = 4
	.module	modto_ip_ir1
	jsr	noargs
	ldd	#0
	std	r1+3
	ldab	#11
	jmp	to

to_ip_ix			; numCalls = 2
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

to_ip_pb			; numCalls = 39
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

true_ip			; numCalls = 8
	.module	modtrue_ip
	jsr	noargs
	ldx	letptr
	ldd	#-1
	stab	0,x
	std	1,x
	rts

true_ix			; numCalls = 3
	.module	modtrue_ix
	jsr	extend
	ldd	#-1
	stab	0,x
	std	1,x
	rts

val_fr1_sr1			; numCalls = 1
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
	.text	4, "...."
	.text	4, "...."
	.text	4, "...."
	.text	4, "...."
	.text	4, "1111"
	.text	4, ".111"
	.text	4, "1111"
	.text	4, "1..1"
	.text	4, "1111"
	.text	4, "111."
	.text	4, "1111"
	.text	4, "1..1"
	.text	4, ".2.."
	.text	4, "2222"
	.text	4, ".2.."
	.text	4, "2.2."
	.text	4, ".2.2"
	.text	4, "222."
	.text	4, ".2.."
	.text	4, "2.2."
	.text	4, ".2.."
	.text	4, "222."
	.text	4, ".2.2"
	.text	4, "2.2."
	.text	4, "..2."
	.text	4, "2222"
	.text	4, "..2."
	.text	4, ".2.2"
	.text	4, "2.2."
	.text	4, ".222"
	.text	4, "..2."
	.text	4, ".2.2"
	.text	4, "..2."
	.text	4, ".222"
	.text	4, "2.2."
	.text	4, ".2.2"
	.text	4, "..2."
	.text	4, ".222"
	.text	4, "..2."
	.text	4, ".2.2"
	.text	4, "..8."
	.text	4, ".888"
	.text	4, "..8."
	.text	4, ".8.8"
	.text	4, "4.4."
	.text	4, ".4.4"
	.text	4, "4.4."
	.text	4, ".4.4"
	.text	4, "6..6"
	.text	4, "...."
	.text	4, "6..6"
	.text	4, ".66."
	.text	4, "6..6"
	.text	4, "...."
	.text	4, ".66."
	.text	4, "6..6"
	.text	1, "1"
	.text	1, "3"
	.text	1, "5"
	.text	1, "9"
	.text	2, "11"
	.text	2, "13"
	.text	2, "17"
	.text	2, "19"
	.text	2, "21"
	.text	2, "25"
	.text	2, "27"
	.text	2, "29"
	.text	1, "1"
	.text	1, "3"
	.text	1, "6"
	.text	1, "8"
	.text	2, "11"
	.text	2, "13"
	.text	1, "1"
	.text	2, "11"
	.text	1, "1"
	.text	1, "9"
	.text	1, "1"
	.text	2, "13"
	.text	1, "3"
	.text	1, "9"
	.text	1, "3"
	.text	2, "11"
	.text	1, "1"
	.text	2, "13"
	.text	1, "6"
	.text	1, "1"
	.text	1, "6"
	.text	1, "3"
	.text	1, "6"
	.text	1, "5"
	.text	1, "8"
	.text	1, "1"
	.text	1, "8"
	.text	1, "3"
	.text	1, "8"
	.text	1, "5"
	.text	1, "6"
	.text	2, "29"
	.text	1, "6"
	.text	2, "25"
	.text	1, "6"
	.text	2, "27"
	.text	1, "8"
	.text	2, "25"
	.text	1, "8"
	.text	2, "27"
	.text	1, "8"
	.text	2, "29"
	.text	2, "13"
	.text	2, "19"
	.text	2, "11"
	.text	2, "17"
	.text	2, "11"
	.text	2, "19"
	.text	2, "11"
	.text	2, "21"
	.text	2, "13"
	.text	2, "17"
	.text	2, "13"
	.text	2, "21"
	.text	1, "0"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "2"
	.text	1, "3"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "3"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "2"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "0"
	.text	1, "1"
	.text	1, "3"
	.text	1, "3"
	.text	1, "1"
	.text	1, "3"
	.text	1, "2"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "0"
	.text	1, "0"
	.text	1, "3"
	.text	1, "3"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "3"
	.text	1, "3"
	.text	1, "1"
	.text	1, "3"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "2"
	.text	1, "0"
	.text	1, "3"
	.text	1, "3"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "1"
	.text	1, "3"
	.text	1, "3"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "2"
	.text	1, "1"
	.text	1, "0"
	.text	1, "2"
	.text	1, "1"
	.text	1, "1"
	.text	1, "3"
	.text	1, "3"
	.text	1, "3"
	.text	1, "0"
	.text	1, "2"
	.text	1, "2"
	.text	1, "0"
	.text	1, "0"
	.text	1, "3"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "3"
	.text	1, "1"
	.text	1, "3"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
	.text	1, "9"
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_A	.equ	0
bytecode_INTVAR_B	.equ	1
bytecode_INTVAR_BN	.equ	2
bytecode_INTVAR_C	.equ	3
bytecode_INTVAR_CX	.equ	4
bytecode_INTVAR_CY	.equ	5
bytecode_INTVAR_D	.equ	6
bytecode_INTVAR_E	.equ	7
bytecode_INTVAR_EN	.equ	8
bytecode_INTVAR_EV	.equ	9
bytecode_INTVAR_EX	.equ	10
bytecode_INTVAR_F	.equ	11
bytecode_INTVAR_G	.equ	12
bytecode_INTVAR_H	.equ	13
bytecode_INTVAR_HS	.equ	14
bytecode_INTVAR_HT	.equ	15
bytecode_INTVAR_I	.equ	16
bytecode_INTVAR_J	.equ	17
bytecode_INTVAR_K	.equ	18
bytecode_INTVAR_L	.equ	19
bytecode_INTVAR_LF	.equ	20
bytecode_INTVAR_LV	.equ	21
bytecode_INTVAR_M	.equ	22
bytecode_INTVAR_N	.equ	23
bytecode_INTVAR_NE	.equ	24
bytecode_INTVAR_O	.equ	25
bytecode_INTVAR_PC	.equ	26
bytecode_INTVAR_Q	.equ	27
bytecode_INTVAR_R	.equ	28
bytecode_INTVAR_RR	.equ	29
bytecode_INTVAR_S	.equ	30
bytecode_INTVAR_SC	.equ	31
bytecode_INTVAR_SM	.equ	32
bytecode_INTVAR_T	.equ	33
bytecode_INTVAR_U	.equ	34
bytecode_INTVAR_V	.equ	35
bytecode_INTVAR_W	.equ	36
bytecode_INTVAR_X	.equ	37
bytecode_INTVAR_XC	.equ	38
bytecode_INTVAR_XX	.equ	39
bytecode_INTVAR_Y	.equ	40
bytecode_INTVAR_YC	.equ	41
bytecode_INTVAR_YY	.equ	42
bytecode_INTVAR_Z	.equ	43
bytecode_INTVAR_Z2	.equ	44
bytecode_INTVAR_Z3	.equ	45
bytecode_FLTVAR_C1	.equ	46
bytecode_STRVAR_A	.equ	47
bytecode_STRVAR_B	.equ	48
bytecode_STRVAR_I	.equ	49
bytecode_INTARR_A	.equ	50
bytecode_INTARR_B	.equ	51
bytecode_INTARR_DR	.equ	52
bytecode_INTARR_E	.equ	53
bytecode_INTARR_EX	.equ	54
bytecode_INTARR_F	.equ	55
bytecode_INTARR_G	.equ	56
bytecode_INTARR_I	.equ	57
bytecode_INTARR_J	.equ	58
bytecode_INTARR_K	.equ	59
bytecode_INTARR_L	.equ	60
bytecode_INTARR_M	.equ	61
bytecode_INTARR_N	.equ	62
bytecode_INTARR_O	.equ	63
bytecode_INTARR_P	.equ	64
bytecode_INTARR_Q	.equ	65
bytecode_INTARR_R	.equ	66
bytecode_INTARR_X	.equ	67
bytecode_INTARR_Y	.equ	68
bytecode_STRARR_A	.equ	69
bytecode_STRARR_B	.equ	70

symtbl

	.word	INTVAR_A
	.word	INTVAR_B
	.word	INTVAR_BN
	.word	INTVAR_C
	.word	INTVAR_CX
	.word	INTVAR_CY
	.word	INTVAR_D
	.word	INTVAR_E
	.word	INTVAR_EN
	.word	INTVAR_EV
	.word	INTVAR_EX
	.word	INTVAR_F
	.word	INTVAR_G
	.word	INTVAR_H
	.word	INTVAR_HS
	.word	INTVAR_HT
	.word	INTVAR_I
	.word	INTVAR_J
	.word	INTVAR_K
	.word	INTVAR_L
	.word	INTVAR_LF
	.word	INTVAR_LV
	.word	INTVAR_M
	.word	INTVAR_N
	.word	INTVAR_NE
	.word	INTVAR_O
	.word	INTVAR_PC
	.word	INTVAR_Q
	.word	INTVAR_R
	.word	INTVAR_RR
	.word	INTVAR_S
	.word	INTVAR_SC
	.word	INTVAR_SM
	.word	INTVAR_T
	.word	INTVAR_U
	.word	INTVAR_V
	.word	INTVAR_W
	.word	INTVAR_X
	.word	INTVAR_XC
	.word	INTVAR_XX
	.word	INTVAR_Y
	.word	INTVAR_YC
	.word	INTVAR_YY
	.word	INTVAR_Z
	.word	INTVAR_Z2
	.word	INTVAR_Z3
	.word	FLTVAR_C1
	.word	STRVAR_A
	.word	STRVAR_B
	.word	STRVAR_I
	.word	INTARR_A
	.word	INTARR_B
	.word	INTARR_DR
	.word	INTARR_E
	.word	INTARR_EX
	.word	INTARR_F
	.word	INTARR_G
	.word	INTARR_I
	.word	INTARR_J
	.word	INTARR_K
	.word	INTARR_L
	.word	INTARR_M
	.word	INTARR_N
	.word	INTARR_O
	.word	INTARR_P
	.word	INTARR_Q
	.word	INTARR_R
	.word	INTARR_X
	.word	INTARR_Y
	.word	STRARR_A
	.word	STRARR_B


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_BN	.block	3
INTVAR_C	.block	3
INTVAR_CX	.block	3
INTVAR_CY	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_EN	.block	3
INTVAR_EV	.block	3
INTVAR_EX	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_HS	.block	3
INTVAR_HT	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_LF	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_N	.block	3
INTVAR_NE	.block	3
INTVAR_O	.block	3
INTVAR_PC	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_RR	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_SM	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_W	.block	3
INTVAR_X	.block	3
INTVAR_XC	.block	3
INTVAR_XX	.block	3
INTVAR_Y	.block	3
INTVAR_YC	.block	3
INTVAR_YY	.block	3
INTVAR_Z	.block	3
INTVAR_Z2	.block	3
INTVAR_Z3	.block	3
FLTVAR_C1	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
STRVAR_I	.block	3
; Numeric Arrays
INTARR_A	.block	6	; dims=2
INTARR_B	.block	6	; dims=2
INTARR_DR	.block	8	; dims=3
INTARR_E	.block	4	; dims=1
INTARR_EX	.block	4	; dims=1
INTARR_F	.block	4	; dims=1
INTARR_G	.block	4	; dims=1
INTARR_I	.block	6	; dims=2
INTARR_J	.block	6	; dims=2
INTARR_K	.block	4	; dims=1
INTARR_L	.block	4	; dims=1
INTARR_M	.block	4	; dims=1
INTARR_N	.block	4	; dims=1
INTARR_O	.block	4	; dims=1
INTARR_P	.block	4	; dims=1
INTARR_Q	.block	4	; dims=1
INTARR_R	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
; String Arrays
STRARR_A	.block	4	; dims=1
STRARR_B	.block	4	; dims=1

; block ended by symbol
bes
	.end

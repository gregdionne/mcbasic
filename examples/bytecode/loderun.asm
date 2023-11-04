; Assembly for loderun.bas
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

	; CLS

	.byte	bytecode_cls

	; GOSUB 100

	.byte	bytecode_gosub_ix
	.word	LINE_100

	; GOTO 90

	.byte	bytecode_goto_ix
	.word	LINE_90

LINE_1

	; FOR ZZ=1 TO Z1

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_ZZ

	.byte	bytecode_to_ip_ix
	.byte	bytecode_FLTVAR_Z1

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_2

	; RETURN

	.byte	bytecode_return

LINE_3

	; M=C(T)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_C
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; GOTO 7

	.byte	bytecode_goto_ix
	.word	LINE_7

LINE_4

	; C(T)=W(RND(2))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_C
	.byte	bytecode_INTVAR_T

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_W

	.byte	bytecode_ld_ip_ir1

	; M=C(T)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_C
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; GOTO 7

	.byte	bytecode_goto_ix
	.word	LINE_7

LINE_5

	; ON K(N(1)) GOTO 2,2,2,2,8

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_N

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_2, LINE_2, LINE_2, LINE_2, LINE_8

	; RETURN

	.byte	bytecode_return

LINE_6

	; P=PEEK(P(A(T),B(T)+Y(M)))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ir2_ir2_ir3

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; ON K(P) GOTO 9,3,15,9,9,42,3,9,9,61

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_K
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ongoto_ir1_is
	.byte	10
	.word	LINE_9, LINE_3, LINE_15, LINE_9, LINE_9, LINE_42, LINE_3, LINE_9, LINE_9, LINE_61

LINE_7

	; P=PEEK(P(A(T)+X(M),B(T)))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; ON K(P) GOTO 9,12,15,9,9,42,12,9,9,61

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_K
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ongoto_ir1_is
	.byte	10
	.word	LINE_9, LINE_12, LINE_15, LINE_9, LINE_9, LINE_42, LINE_12, LINE_9, LINE_9, LINE_61

LINE_8

	; P=PEEK(P(A(T)+X(M),B(T)+Y(M)))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ir2_ir2_ir3

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; ON K(P) GOTO 9,2,15,9,9,42,2,9,9,61

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_K
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ongoto_ir1_is
	.byte	10
	.word	LINE_9, LINE_2, LINE_15, LINE_9, LINE_9, LINE_42, LINE_2, LINE_9, LINE_9, LINE_61

LINE_9

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; B=N(T)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; POKE A,B

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_B

	; N(T)=P

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ld_ip_ir1

	; A(T)+=X(M)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ip_ip_ir1

	; B(T)+=Y(M)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_Y
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ip_ip_ir1

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; B=D(M,T)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_B

	; POKE A,B

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_B

	; GOSUB 1

	.byte	bytecode_gosub_ix
	.word	LINE_1

LINE_10

	; F(T)=PEEK(P(A(T),B(T)+1))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; ON K(N(T)) GOTO 11,2,2,2,11

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_11, LINE_2, LINE_2, LINE_2, LINE_11

	; RETURN

	.byte	bytecode_return

LINE_11

	; F(T)=2

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	2

	; RETURN

	.byte	bytecode_return

LINE_12

	; C(T)=W2(M)

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_C
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_W2
	.byte	bytecode_INTVAR_M

	.byte	bytecode_ld_ip_ir1

	; M=C(T)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_C
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; P=PEEK(P(A(T)+X(M),B(T)))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_X
	.byte	bytecode_INTVAR_M

	.byte	bytecode_add_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; ON K(P) GOTO 9,2,15,9,9,42,2,9,9,61

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_K
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ongoto_ir1_is
	.byte	10
	.word	LINE_9, LINE_2, LINE_15, LINE_9, LINE_9, LINE_42, LINE_2, LINE_9, LINE_9, LINE_61

LINE_13

	; M=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_M
	.byte	5

	; GOSUB 8

	.byte	bytecode_gosub_ix
	.word	LINE_8

	; GOTO 22

	.byte	bytecode_goto_ix
	.word	LINE_22

LINE_14

	; M=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_M
	.byte	5

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_15

	; P=G

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_P
	.byte	bytecode_INTVAR_G

	; G(T)+=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ip_ip

	; SOUND 100,1

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; WHEN G(T)<>W GOTO 9

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ldne_ir1_ir1_ix
	.byte	bytecode_INTVAR_W

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_9

LINE_16

	; A=P(E(1),E(2))

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_E

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,240

	.byte	bytecode_poke_ix_pb
	.byte	bytecode_FLTVAR_A
	.byte	240

	; GOSUB 9

	.byte	bytecode_gosub_ix
	.word	LINE_9

	; SOUND 50,1

	.byte	bytecode_ld_ir1_pb
	.byte	50

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; SOUND 20,2

	.byte	bytecode_ld_ir1_pb
	.byte	20

	.byte	bytecode_ld_ir2_pb
	.byte	2

	.byte	bytecode_sound_ir1_ir2

	; SOUND 100,3

	.byte	bytecode_ld_ir1_pb
	.byte	100

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; RETURN

	.byte	bytecode_return

LINE_17

	; ON K(N(T)) GOSUB 3,3,3,3,6,42,3

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongosub_ir1_is
	.byte	7
	.word	LINE_3, LINE_3, LINE_3, LINE_3, LINE_6, LINE_42, LINE_3

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_18

	; GOSUB 6

	.byte	bytecode_gosub_ix
	.word	LINE_6

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_19

	; GOSUB 7

	.byte	bytecode_gosub_ix
	.word	LINE_7

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_20

	; FOR Z=1 TO 64000

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_Z

	.byte	bytecode_to_ip_pw
	.word	64000

	; FOR S=1 TO V

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_S

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_V

	; FOR C=2 TO F

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	2

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_F

	; T=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_T

	; ON K(F(T)) GOTO 13,21,13,13,21,21,21,38,39

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	9
	.word	LINE_13, LINE_21, LINE_13, LINE_13, LINE_21, LINE_21, LINE_21, LINE_38, LINE_39

LINE_21

	; GOSUB 83

	.byte	bytecode_gosub_ix
	.word	LINE_83

	; ON M GOSUB 25,8,5,8,8,27,80

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_ongosub_ir1_is
	.byte	7
	.word	LINE_25, LINE_8, LINE_5, LINE_8, LINE_8, LINE_27, LINE_80

LINE_22

	; T=C

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_T
	.byte	bytecode_INTVAR_C

	; ON K(F(T)) GOTO 14,23,23,14,23,14,23,30,31

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	9
	.word	LINE_14, LINE_23, LINE_23, LINE_14, LINE_23, LINE_14, LINE_23, LINE_30, LINE_31

LINE_23

	; M=U(B(T)+L-B(1))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_L

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_U

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; ON M GOTO 24,24,17,24,18

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_ongoto_ir1_is
	.byte	5
	.word	LINE_24, LINE_24, LINE_17, LINE_24, LINE_18

	; M=V(A(T)+N-A(1))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_N

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_A

	.byte	bytecode_sub_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_V

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; ON M GOTO 24,19,24,19

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_ongoto_ir1_is
	.byte	4
	.word	LINE_24, LINE_19, LINE_24, LINE_19

LINE_24

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_25

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,141

	.byte	bytecode_poke_ix_pb
	.byte	bytecode_FLTVAR_A
	.byte	141

	; P=PEEK(P(A(T)-1,B(T)))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; IF (P=G) OR (P=Q) THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_P
	.byte	bytecode_INTVAR_G

	.byte	bytecode_ldeq_ir2_ix_id
	.byte	bytecode_INTVAR_P
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_26

	; IF PEEK(P(A(T)-1,B(T)+1))=I THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_26

	; S=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_S

	; O+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_O

	; H(O)=A(T)-1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_O

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; GOTO 49

	.byte	bytecode_goto_ix
	.word	LINE_49

LINE_26

	; RETURN

	.byte	bytecode_return

LINE_27

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,G1

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_G1

	; P=PEEK(P(A(T)+1,B(T)))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; IF (P=G) OR (P=Q) THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_P
	.byte	bytecode_INTVAR_G

	.byte	bytecode_ldeq_ir2_ix_id
	.byte	bytecode_INTVAR_P
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_28

	; IF PEEK(P(A(T)+1,B(T)+1))=I THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ldeq_ir1_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_28

	; S=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_S

	; O+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_O

	; H(O)=A(T)+1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_O

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; GOTO 49

	.byte	bytecode_goto_ix
	.word	LINE_49

LINE_28

	; RETURN

	.byte	bytecode_return

LINE_29

	; I(J)=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_J

	.byte	bytecode_one_ip

	; J=15

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	15

	; NEXT

	.byte	bytecode_next

	; B(T)-=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ip_ip

	; RETURN

	.byte	bytecode_return

LINE_30

	; WHEN G(T)>0 GOTO 37

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	0

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_37

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,G

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_G

	; B(T)+=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ip_ip

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,G2

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_G2

	; F(T)=144

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	144

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_31

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,RND(2)+D

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_add_ir1_ir1_ix
	.byte	bytecode_INTVAR_D

	.byte	bytecode_poke_ix_ir1
	.byte	bytecode_FLTVAR_A

	; T(T)+=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ip_ip

	; IF T(T)<E THEN

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ldlt_ir1_ir1_ix
	.byte	bytecode_INTVAR_E

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_32

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_32

	; P=PEEK(P(A(T),B(T)-1))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_P

	; ON K(P) GOSUB 2,2,35,34,2,41,2,2,2

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_K
	.byte	bytecode_INTVAR_P

	.byte	bytecode_ongosub_ir1_is
	.byte	9
	.word	LINE_2, LINE_2, LINE_35, LINE_34, LINE_2, LINE_41, LINE_2, LINE_2, LINE_2

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_33

	; FOR J=1 TO 15

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	15

	; WHEN (H(J)=A(T)) AND (I(J)=B(T)) GOTO 29

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ldeq_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_29

	; NEXT

	.byte	bytecode_next

	; RETURN

	.byte	bytecode_return

LINE_34

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,I

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_I

	; POKE P(A(T),B(T)-1),G2

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_poke_ir1_ix
	.byte	bytecode_INTVAR_G2

	; F(T)=I

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ip_ir1

	; T(T)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_clr_ip

	; SOUND 1,1

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; GOTO 33

	.byte	bytecode_goto_ix
	.word	LINE_33

LINE_35

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,I

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_I

	; POKE P(A(T),B(T)-1),G2

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_poke_ir1_ix
	.byte	bytecode_INTVAR_G2

	; F(T)=I

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_I

	.byte	bytecode_ld_ip_ir1

	; T(T)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_clr_ip

	; SOUND 200,1

	.byte	bytecode_ld_ir1_pb
	.byte	200

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_sound_ir1_ir2

	; G(T)+=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ip_ip

	; GOTO 33

	.byte	bytecode_goto_ix
	.word	LINE_33

LINE_37

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,146

	.byte	bytecode_poke_ix_pb
	.byte	bytecode_FLTVAR_A
	.byte	146

	; G(T)-=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_T

	.byte	bytecode_dec_ip_ip

	; B(T)+=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ip_ip

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,G2

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_G2

	; F(T)=144

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	144

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

	; GOSUB 43

	.byte	bytecode_gosub_ix
	.word	LINE_43

	; NEXT

	.byte	bytecode_next

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_38

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,N(T)

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_poke_ix_ir1
	.byte	bytecode_FLTVAR_A

	; B(T)+=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ip_ip

	; WHEN B(T)>14 GOTO 54

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ldlt_ir1_pb_ir1
	.byte	14

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_54

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,D(M,T)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_poke_ix_ir1
	.byte	bytecode_FLTVAR_A

	; F(T)=PEEK(P(A(T),B(T)+1))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; N(T)=Q

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Q

	.byte	bytecode_ld_ip_ir1

	; GOTO 22

	.byte	bytecode_goto_ix
	.word	LINE_22

LINE_39

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,D(M,T)

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_M

	.byte	bytecode_arrval2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_poke_ix_ir1
	.byte	bytecode_FLTVAR_A

	; F(T)=144

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	144

	; GOTO 22

	.byte	bytecode_goto_ix
	.word	LINE_22

LINE_40

	; PRINT @0, "YOU GOT CAUGHT!";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	15, "YOU GOT CAUGHT!"

	; Z=65000

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_Z
	.word	65000

	; C=F

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_C
	.byte	bytecode_INTVAR_F

	; S=999

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_S
	.word	999

	; RETURN

	.byte	bytecode_return

LINE_41

	; GOSUB 35

	.byte	bytecode_gosub_ix
	.word	LINE_35

	; GOTO 40

	.byte	bytecode_goto_ix
	.word	LINE_40

LINE_42

	; GOSUB 9

	.byte	bytecode_gosub_ix
	.word	LINE_9

	; GOTO 40

	.byte	bytecode_goto_ix
	.word	LINE_40

LINE_43

	; IF U=O THEN

	.byte	bytecode_ldeq_ir1_ix_id
	.byte	bytecode_INTVAR_U
	.byte	bytecode_INTVAR_O

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_44

	; RETURN

	.byte	bytecode_return

LINE_44

	; U+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_U

	; ON U GOTO 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_U

	.byte	bytecode_ongoto_ir1_is
	.byte	15
	.word	LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45, LINE_45

	; U=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_U

LINE_45

	; ON I(U) GOTO 2

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_U

	.byte	bytecode_ongoto_ir1_is
	.byte	1
	.word	LINE_2

	; ON K(PEEK(P(H(U),I(U)))) GOTO 82,82,82,82,82,47,47,46,82,82

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_U

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_U

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ongoto_ir1_is
	.byte	10
	.word	LINE_82, LINE_82, LINE_82, LINE_82, LINE_82, LINE_47, LINE_47, LINE_46, LINE_82, LINE_82

LINE_46

	; A=P(H(U),I(U))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_U

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_U

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,I

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_I

	; I(U)=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_U

	.byte	bytecode_one_ip

	; RETURN

	.byte	bytecode_return

LINE_47

	; FOR J=2 TO F

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_J
	.byte	2

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_F

	; WHEN (H(U)=A(J)) AND (I(U)=B(J)) GOTO 48

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_U

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir1_ir1_ir2

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_U

	.byte	bytecode_arrval1_ir3_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ldeq_ir2_ir2_ir3

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_48

	; NEXT

	.byte	bytecode_next

	; GOSUB 40

	.byte	bytecode_gosub_ix
	.word	LINE_40

	; PRINT @0, "BURIED ALIVE!!!";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	15, "BURIED ALIVE!!!"

	; RETURN

	.byte	bytecode_return

LINE_48

	; N(J)=PEEK(P(NX,NY))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_NX

	.byte	bytecode_arrval2_ir1_fx_id
	.byte	bytecode_FLTARR_P
	.byte	bytecode_INTVAR_NY

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; A(J)=NX

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_NX

	.byte	bytecode_ld_ip_ir1

	; B(J)=NY

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_J

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_NY

	.byte	bytecode_ld_ip_ir1

	; POKE P(A(J),B(J)),G2

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_poke_ir1_ix
	.byte	bytecode_INTVAR_G2

	; SOUND 1,5

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_sound_ir1_ir2

	; F(J)=PEEK(P(A(J),B(J)+1))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_J

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_J

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; T(J)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_J

	.byte	bytecode_clr_ip

	; J=F

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_J
	.byte	bytecode_INTVAR_F

	; NEXT

	.byte	bytecode_next

	; GOTO 46

	.byte	bytecode_goto_ix
	.word	LINE_46

LINE_49

	; I(O)=B(T)+1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_O

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; A=P(H(O),I(O))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_O

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_O

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,Q

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_Q

	; ON O GOTO 2,2,2,2,2,2,2,2,2,2,2,2,2,2

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_O

	.byte	bytecode_ongoto_ir1_is
	.byte	14
	.word	LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2, LINE_2

	; O=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_O

	; RETURN

	.byte	bytecode_return

LINE_50

	; IF S>=999 THEN

	.byte	bytecode_ldge_ir1_ix_pw
	.byte	bytecode_INTVAR_S
	.word	999

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_51

	; MN-=1

	.byte	bytecode_dec_ix_ix
	.byte	bytecode_INTVAR_MN

LINE_51

	; PRINT @480, "LIVES=";STR$(MN);" ";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	6, "LIVES="

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_MN

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; PRINT @502, "HIT c KEY";

	.byte	bytecode_prat_pw
	.word	502

	.byte	bytecode_pr_ss
	.text	9, "HIT c KEY"

LINE_52

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; WHEN I$<>"C" GOTO 52

	.byte	bytecode_ldne_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "C"

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_52

LINE_53

	; GOTO 900

	.byte	bytecode_goto_ix
	.word	LINE_900

LINE_54

	; PRINT @0, "OOPS!";

	.byte	bytecode_prat_pb
	.byte	0

	.byte	bytecode_pr_ss
	.text	5, "OOPS!"

	; Z=65000

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_Z
	.word	65000

	; C=F

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_C
	.byte	bytecode_INTVAR_F

	; S=999

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_S
	.word	999

	; GOTO 22

	.byte	bytecode_goto_ix
	.word	LINE_22

LINE_55

	; PRINT @480, "PLAY AGAIN (y/n)?¯¯¯¯¯¯¯¯¯¯¯¯¯¯";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	31, "PLAY AGAIN (y/n)?\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

LINE_56

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; WHEN I$="" GOTO 56

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_56

LINE_57

	; IF I$="Y" THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "Y"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_58

	; LC=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_LC

	; MN=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	5

	; S=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_S

	; LV=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_LV

	; GOTO 900

	.byte	bytecode_goto_ix
	.word	LINE_900

LINE_58

	; IF I$="N" THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "N"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_59

	; CLS

	.byte	bytecode_cls

	; GOTO 70

	.byte	bytecode_goto_ix
	.word	LINE_70

LINE_59

	; GOTO 56

	.byte	bytecode_goto_ix
	.word	LINE_56

LINE_61

	; GOSUB 9

	.byte	bytecode_gosub_ix
	.word	LINE_9

	; SOUND 193,3

	.byte	bytecode_ld_ir1_pb
	.byte	193

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; SOUND 204,3

	.byte	bytecode_ld_ir1_pb
	.byte	204

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; SOUND 204,3

	.byte	bytecode_ld_ir1_pb
	.byte	204

	.byte	bytecode_ld_ir2_pb
	.byte	3

	.byte	bytecode_sound_ir1_ir2

	; LC+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_LC

	; Z=65000

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_Z
	.word	65000

	; C=F

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_C
	.byte	bytecode_INTVAR_F

	; S=V

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_S
	.byte	bytecode_INTVAR_V

	; MN+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_MN

	; PRINT @480, "LIVES=";STR$(MN);" ";

	.byte	bytecode_prat_pw
	.word	480

	.byte	bytecode_pr_ss
	.text	6, "LIVES="

	.byte	bytecode_str_sr1_ix
	.byte	bytecode_INTVAR_MN

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	1, " "

	; RETURN

	.byte	bytecode_return

LINE_65

	; CLS

	.byte	bytecode_cls

	; PRINT "  mc-lode runner by jim gerrie\r";

	.byte	bytecode_pr_ss
	.text	31, "  mc-lode runner by jim gerrie\r"

LINE_66

	; PRINT "        and greg dionne\r";

	.byte	bytecode_pr_ss
	.text	24, "        and greg dionne\r"

	; RETURN

	.byte	bytecode_return

LINE_70

	; GOSUB 65

	.byte	bytecode_gosub_ix
	.word	LINE_65

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

LINE_71

	; PRINT "YOU COMPLETED";STR$(LC*10);"% OF THE\r";

	.byte	bytecode_pr_ss
	.text	13, "YOU COMPLETED"

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LC

	.byte	bytecode_mul_ir1_ir1_pb
	.byte	10

	.byte	bytecode_str_sr1_ir1

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	9, "% OF THE\r"

	; PRINT "SCREENS AT LEVEL";STR$(Z2);" \r";

	.byte	bytecode_pr_ss
	.text	16, "SCREENS AT LEVEL"

	.byte	bytecode_str_sr1_fx
	.byte	bytecode_FLTVAR_Z2

	.byte	bytecode_pr_sr1

	.byte	bytecode_pr_ss
	.text	2, " \r"

	; END

	.byte	bytecode_progend

LINE_80

	; MN=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_MN

	; GOTO 40

	.byte	bytecode_goto_ix
	.word	LINE_40

LINE_82

	; I(U)=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_U

	.byte	bytecode_one_ip

	; RETURN

	.byte	bytecode_return

LINE_83

	; M=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_M

	; IF PEEK(2) AND NOT PEEK(16949) AND 1 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16949

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_84

	; M=K(68)

	.byte	bytecode_ld_ir1_pb
	.byte	68

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; RETURN

	.byte	bytecode_return

LINE_84

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16946

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	1

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_85

	; M=K(65)

	.byte	bytecode_ld_ir1_pb
	.byte	65

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; RETURN

	.byte	bytecode_return

LINE_85

	; IF PEEK(2) AND NOT PEEK(16948) AND 4 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16948

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_86

	; M=K(83)

	.byte	bytecode_ld_ir1_pb
	.byte	83

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; RETURN

	.byte	bytecode_return

LINE_86

	; IF PEEK(2) AND NOT PEEK(16952) AND 4 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16952

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	4

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_87

	; M=K(87)

	.byte	bytecode_ld_ir1_pb
	.byte	87

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; RETURN

	.byte	bytecode_return

LINE_87

	; IF PEEK(2) AND NOT PEEK(16949) AND 32 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16949

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	32

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_88

	; M=K(44)

	.byte	bytecode_ld_ir1_pb
	.byte	44

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; RETURN

	.byte	bytecode_return

LINE_88

	; IF PEEK(2) AND NOT PEEK(16951) AND 32 THEN

	.byte	bytecode_peek2_ir1

	.byte	bytecode_peek_ir2_pw
	.word	16951

	.byte	bytecode_com_ir2_ir2

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_and_ir1_ir1_pb
	.byte	32

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_89

	; M=K(46)

	.byte	bytecode_ld_ir1_pb
	.byte	46

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ix_ir1
	.byte	bytecode_INTVAR_M

	; RETURN

	.byte	bytecode_return

LINE_89

	; RETURN

	.byte	bytecode_return

LINE_90

	; DIM P(31,15),A(5),B(5),M,P,S,V,C,F,T,A,B,K(255),V(63),F(5),G(8),X(5),Y(5),D(5,5),N(5),C(5),U(31),T(5),W(2),W2(4)

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_ld_ir2_pb
	.byte	15

	.byte	bytecode_arrdim2_ir1_fx
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ir1_pb
	.byte	255

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ir1_pb
	.byte	63

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_V

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ir1_pb
	.byte	8

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_G

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_X

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_Y

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	5

	.byte	bytecode_arrdim2_ir1_ix
	.byte	bytecode_INTARR_D

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_C

	.byte	bytecode_ld_ir1_pb
	.byte	31

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_U

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_T

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_W

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_W2

LINE_91

	; DIM H(15),I(15),G,Q,I,O,D,E,J,L,N,U,W,X,Y,Z,LV,LC,NX,NY,G1,G2,MC,I$,A$,MN

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_H

	.byte	bytecode_ld_ir1_pb
	.byte	15

	.byte	bytecode_arrdim1_ir1_ix
	.byte	bytecode_INTARR_I

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

	; GOSUB 800

	.byte	bytecode_gosub_ix
	.word	LINE_800

	; GOTO 50

	.byte	bytecode_goto_ix
	.word	LINE_50

LINE_100

	; CLS

	.byte	bytecode_cls

	; GOSUB 65

	.byte	bytecode_gosub_ix
	.word	LINE_65

LINE_120

	; PRINT "TO MOVE USE:\r";

	.byte	bytecode_pr_ss
	.text	13, "TO MOVE USE:\r"

LINE_130

	; PRINT "    W\r";

	.byte	bytecode_pr_ss
	.text	6, "    W\r"

LINE_140

	; PRINT "  A  S  D\r";

	.byte	bytecode_pr_ss
	.text	10, "  A  S  D\r"

LINE_155

	; PRINT "              TO DIG USE: \r";

	.byte	bytecode_pr_ss
	.text	27, "              TO DIG USE: \r"

LINE_156

	; PRINT "                 ,  .\r";

	.byte	bytecode_pr_ss
	.text	22, "                 ,  .\r"

LINE_160

	; PRINT "       FOR LEFT AND RIGHT HOLES\r";

	.byte	bytecode_pr_ss
	.text	32, "       FOR LEFT AND RIGHT HOLES\r"

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

LINE_180

	; PRINT "AFTER SCREEN IS DISPLAYED PRESS\r";

	.byte	bytecode_pr_ss
	.text	32, "AFTER SCREEN IS DISPLAYED PRESS\r"

LINE_190

	; PRINT "N TO SKIP TO NEXT SCREEN. GUARDS";

	.byte	bytecode_pr_ss
	.text	32, "N TO SKIP TO NEXT SCREEN. GUARDS"

LINE_195

	; PRINT "ONLY GIVE UP ONE GOLD WHEN THEY\r";

	.byte	bytecode_pr_ss
	.text	32, "ONLY GIVE UP ONE GOLD WHEN THEY\r"

LINE_196

	; PRINT "FALL IN PITS. THERE ARE 10\r";

	.byte	bytecode_pr_ss
	.text	27, "FALL IN PITS. THERE ARE 10\r"

LINE_197

	; PRINT "SCREENS. ENTER=ABORT A SCREEN.\r";

	.byte	bytecode_pr_ss
	.text	31, "SCREENS. ENTER=ABORT A SCREEN.\r"

	; PRINT "\r";

	.byte	bytecode_pr_ss
	.text	1, "\r"

LINE_198

	; PRINT @456, "";

	.byte	bytecode_prat_pw
	.word	456

	.byte	bytecode_pr_ss
	.text	0, ""

	; INPUT "LEVEL (1-3)"; Z2

	.byte	bytecode_pr_ss
	.text	11, "LEVEL (1-3)"

	.byte	bytecode_input

	.byte	bytecode_readbuf_fx
	.byte	bytecode_FLTVAR_Z2

	.byte	bytecode_ignxtra

	; WHEN (Z2<1) OR (Z2>3) GOTO 198

	.byte	bytecode_ldlt_ir1_fx_pb
	.byte	bytecode_FLTVAR_Z2
	.byte	1

	.byte	bytecode_ldlt_ir2_pb_fx
	.byte	3
	.byte	bytecode_FLTVAR_Z2

	.byte	bytecode_or_ir1_ir1_ir2

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_198

LINE_199

	; Z1=500-(Z2*100)

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_Z2

	.byte	bytecode_mul_fr1_fr1_pb
	.byte	100

	.byte	bytecode_rsub_fr1_fr1_pw
	.word	500

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_Z1

LINE_200

	; RETURN

	.byte	bytecode_return

LINE_800

	; X=RND(-TIMER)

	.byte	bytecode_timer_ir1

	.byte	bytecode_neg_ir1_ir1

	.byte	bytecode_rnd_fr1_ir1

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_X

	; W2(4)=2

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_W2

	.byte	bytecode_ld_ip_pb
	.byte	2

	; W2(2)=4

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_W2

	.byte	bytecode_ld_ip_pb
	.byte	4

	; D=188

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_D
	.byte	188

	; Q=160

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_Q
	.byte	160

LINE_805

	; K(44)=1

	.byte	bytecode_ld_ir1_pb
	.byte	44

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_one_ip

	; K(65)=2

	.byte	bytecode_ld_ir1_pb
	.byte	65

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

	; K(68)=4

	.byte	bytecode_ld_ir1_pb
	.byte	68

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	4

	; K(83)=5

	.byte	bytecode_ld_ir1_pb
	.byte	83

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	5

	; K(46)=6

	.byte	bytecode_ld_ir1_pb
	.byte	46

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	6

	; MC=16384

	.byte	bytecode_ld_ix_pw
	.byte	bytecode_INTVAR_MC
	.word	16384

	; G=128

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_G
	.byte	128

	; I=175

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_I
	.byte	175

	; L=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_L
	.byte	16

	; N=32

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_N
	.byte	32

	; W(1)=4

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_W

	.byte	bytecode_ld_ip_pb
	.byte	4

	; W(2)=2

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_W

	.byte	bytecode_ld_ip_pb
	.byte	2

LINE_806

	; K(70)=2

	.byte	bytecode_ld_ir1_pb
	.byte	70

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(84)=3

	.byte	bytecode_ld_ir1_pb
	.byte	84

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

	; K(71)=5

	.byte	bytecode_ld_ir1_pb
	.byte	71

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	5

	; K(13)=7

	.byte	bytecode_ld_ir1_pb
	.byte	13

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	7

	; G1=142

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_G1
	.byte	142

	; G2=190

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_G2
	.byte	190

LINE_810

	; FOR T=1 TO 5

	.byte	bytecode_forone_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	5

	; C(T)=W(RND(2))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_C
	.byte	bytecode_INTVAR_T

	.byte	bytecode_irnd_ir1_pb
	.byte	2

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_W

	.byte	bytecode_ld_ip_ir1

	; NEXT

	.byte	bytecode_next

	; K(176)=2

	.byte	bytecode_ld_ir1_pb
	.byte	176

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

LINE_815

	; K(204)=1

	.byte	bytecode_ld_ir1_pb
	.byte	204

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_one_ip

	; K(175)=2

	.byte	bytecode_ld_ir1_pb
	.byte	175

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(239)=2

	.byte	bytecode_ld_ir1_pb
	.byte	239

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	2

	; K(146)=3

	.byte	bytecode_ld_ir1_pb
	.byte	146

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	3

	; K(128)=4

	.byte	bytecode_ld_ir1_pb
	.byte	128

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	4

	; K(220)=5

	.byte	bytecode_ld_ir1_pb
	.byte	220

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	5

	; K(142)=6

	.byte	bytecode_ld_ir1_pb
	.byte	142

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	6

	; K(141)=6

	.byte	bytecode_ld_ir1_pb
	.byte	141

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	6

	; K(189)=7

	.byte	bytecode_ld_ir1_pb
	.byte	189

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	7

	; K(190)=7

	.byte	bytecode_ld_ir1_pb
	.byte	190

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	7

	; K(160)=8

	.byte	bytecode_ld_ir1_pb
	.byte	160

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	8

	; K(144)=9

	.byte	bytecode_ld_ir1_pb
	.byte	144

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	9

	; K(240)=10

	.byte	bytecode_ld_ir1_pb
	.byte	240

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_K

	.byte	bytecode_ld_ip_pb
	.byte	10

LINE_820

	; FOR X=0 TO 31

	.byte	bytecode_forclr_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_to_fp_pb
	.byte	31

	; FOR Y=0 TO 15

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_to_ip_pb
	.byte	15

	; P(X,Y)=SHIFT(Y,5)+X+MC

	.byte	bytecode_ld_fr1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_arrref2_ir1_fx_id
	.byte	bytecode_FLTARR_P
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_Y

	.byte	bytecode_shift_ir1_ir1_pb
	.byte	5

	.byte	bytecode_add_fr1_ir1_fx
	.byte	bytecode_FLTVAR_X

	.byte	bytecode_add_fr1_fr1_ix
	.byte	bytecode_INTVAR_MC

	.byte	bytecode_ld_fp_fr1

	; NEXT

	.byte	bytecode_next

	; NEXT

	.byte	bytecode_next

LINE_830

	; X(2)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_true_ip

	; Y(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_clr_ip

	; D(2,1)=141

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix_ir2
	.byte	bytecode_INTARR_D

	.byte	bytecode_ld_ip_pb
	.byte	141

	; FOR T=2 TO 5

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	5

	; D(2,T)=189

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	189

	; NEXT

	.byte	bytecode_next

LINE_831

	; X(3)=0

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_clr_ip

	; Y(3)=-1

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_true_ip

	; D(3,1)=141

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix_ir2
	.byte	bytecode_INTARR_D

	.byte	bytecode_ld_ip_pb
	.byte	141

	; FOR T=2 TO 5

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	5

	; D(3,T)=189

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	189

	; NEXT

	.byte	bytecode_next

LINE_832

	; X(4)=1

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_one_ip

	; Y(4)=0

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_clr_ip

	; D(4,1)=142

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix_ir2
	.byte	bytecode_INTARR_D

	.byte	bytecode_ld_ip_pb
	.byte	142

	; FOR T=2 TO 5

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	5

	; D(4,T)=190

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	190

	; NEXT

	.byte	bytecode_next

LINE_833

	; X(5)=0

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_X

	.byte	bytecode_clr_ip

	; Y(5)=1

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_Y

	.byte	bytecode_one_ip

	; D(5,1)=142

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrref2_ir1_ix_ir2
	.byte	bytecode_INTARR_D

	.byte	bytecode_ld_ip_pb
	.byte	142

	; FOR T=2 TO 5

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	2

	.byte	bytecode_to_ip_pb
	.byte	5

	; D(5,T)=190

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref2_ir1_ix_id
	.byte	bytecode_INTARR_D
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	190

	; NEXT

	.byte	bytecode_next

LINE_840

	; FOR T=0 TO 15

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	15

	; U(T)=5

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_U
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	5

	; NEXT

	.byte	bytecode_next

	; FOR T=17 TO 31

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	17

	.byte	bytecode_to_ip_pb
	.byte	31

	; U(T)=3

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_U
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	3

	; NEXT

	.byte	bytecode_next

LINE_845

	; FOR T=0 TO 31

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_T

	.byte	bytecode_to_ip_pb
	.byte	31

	; V(T)=4

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	4

	; NEXT

	.byte	bytecode_next

	; FOR T=33 TO 63

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	33

	.byte	bytecode_to_ip_pb
	.byte	63

	; V(T)=2

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_V
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	2

	; NEXT

	.byte	bytecode_next

LINE_860

	; A$="¯¯¯"

	.byte	bytecode_ld_sr1_ss
	.text	3, "\xAF\xAF\xAF"

	.byte	bytecode_ld_sx_sr1
	.byte	bytecode_STRVAR_A

	; MN=5

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	5

	; RETURN

	.byte	bytecode_return

LINE_870

	; SOUND 38,4

	.byte	bytecode_ld_ir1_pb
	.byte	38

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 58,4

	.byte	bytecode_ld_ir1_pb
	.byte	58

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 78,4

	.byte	bytecode_ld_ir1_pb
	.byte	78

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 89,4

	.byte	bytecode_ld_ir1_pb
	.byte	89

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 108,4

	.byte	bytecode_ld_ir1_pb
	.byte	108

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 125,4

	.byte	bytecode_ld_ir1_pb
	.byte	125

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 133,4

	.byte	bytecode_ld_ir1_pb
	.byte	133

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 147,4

	.byte	bytecode_ld_ir1_pb
	.byte	147

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

LINE_880

	; SOUND 159,4

	.byte	bytecode_ld_ir1_pb
	.byte	159

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 170,4

	.byte	bytecode_ld_ir1_pb
	.byte	170

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 176,4

	.byte	bytecode_ld_ir1_pb
	.byte	176

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; SOUND 185,4

	.byte	bytecode_ld_ir1_pb
	.byte	185

	.byte	bytecode_ld_ir2_pb
	.byte	4

	.byte	bytecode_sound_ir1_ir2

	; RETURN

	.byte	bytecode_return

LINE_900

	; WHEN S>=999 GOTO 904

	.byte	bytecode_ldge_ir1_ix_pw
	.byte	bytecode_INTVAR_S
	.word	999

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_904

LINE_901

	; LV+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_LV

	; WHEN (LV=10) AND (LC=10) GOSUB 870

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_LV
	.byte	10

	.byte	bytecode_ldeq_ir2_ix_pb
	.byte	bytecode_INTVAR_LC
	.byte	10

	.byte	bytecode_and_ir1_ir1_ir2

	.byte	bytecode_jsrne_ir1_ix
	.word	LINE_870

LINE_902

	; IF LV=11 THEN

	.byte	bytecode_ldeq_ir1_ix_pb
	.byte	bytecode_INTVAR_LV
	.byte	11

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_904

	; PRINT "GAME OVER.\r";

	.byte	bytecode_pr_ss
	.text	11, "GAME OVER.\r"

	; GOTO 71

	.byte	bytecode_goto_ix
	.word	LINE_71

LINE_904

	; WHEN MN<1 GOTO 55

	.byte	bytecode_ldlt_ir1_ix_pb
	.byte	bytecode_INTVAR_MN
	.byte	1

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_55

LINE_905

	; CLS 0

	.byte	bytecode_clsn_pb
	.byte	0

	; FOR T=16384 TO 16415

	.byte	bytecode_for_ix_pw
	.byte	bytecode_INTVAR_T
	.word	16384

	.byte	bytecode_to_ip_pw
	.word	16415

	; POKE T,175

	.byte	bytecode_poke_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	175

	; NEXT

	.byte	bytecode_next

	; PRINT @32, "";

	.byte	bytecode_prat_pb
	.byte	32

	.byte	bytecode_pr_ss
	.text	0, ""

	; ON LV GOSUB 1000,1100,1200,1300,1400,1500,1600,1700,1800,1900

	.byte	bytecode_ld_ir1_ix
	.byte	bytecode_INTVAR_LV

	.byte	bytecode_ongosub_ir1_is
	.byte	10
	.word	LINE_1000, LINE_1100, LINE_1200, LINE_1300, LINE_1400, LINE_1500, LINE_1600, LINE_1700, LINE_1800, LINE_1900

	; E=V

	.byte	bytecode_ld_id_ix
	.byte	bytecode_INTVAR_E
	.byte	bytecode_INTVAR_V

LINE_910

	; FOR C=16864 TO 16895

	.byte	bytecode_for_ix_pw
	.byte	bytecode_INTVAR_C
	.word	16864

	.byte	bytecode_to_ip_pw
	.word	16895

	; POKE C,175

	.byte	bytecode_poke_ix_pb
	.byte	bytecode_INTVAR_C
	.byte	175

	; NEXT

	.byte	bytecode_next

LINE_930

	; N(1)=128

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_N

	.byte	bytecode_ld_ip_pb
	.byte	128

	; POKE P(A(1),B(1)),141

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_poke_ir1_pb
	.byte	141

	; F(1)=PEEK(P(A(1),B(1)+1))

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_F

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrval1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ir2_pb
	.byte	1

	.byte	bytecode_arrval1_ir2_ix_ir2
	.byte	bytecode_INTARR_B

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; G(1)=0

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_G

	.byte	bytecode_clr_ip

LINE_940

	; F+=1

	.byte	bytecode_inc_ix_ix
	.byte	bytecode_INTVAR_F

	; FOR T=2 TO F

	.byte	bytecode_for_ix_pb
	.byte	bytecode_INTVAR_T
	.byte	2

	.byte	bytecode_to_ip_ix
	.byte	bytecode_INTVAR_F

	; N(T)=128

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_N
	.byte	bytecode_INTVAR_T

	.byte	bytecode_ld_ip_pb
	.byte	128

	; A=P(A(T),B(T))

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_ld_fx_fr1
	.byte	bytecode_FLTVAR_A

	; POKE A,G2

	.byte	bytecode_poke_id_ix
	.byte	bytecode_FLTVAR_A
	.byte	bytecode_INTVAR_G2

	; F(T)=PEEK(P(A(T),B(T)+1))

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_F
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir1_ix_id
	.byte	bytecode_INTARR_A
	.byte	bytecode_INTVAR_T

	.byte	bytecode_arrval1_ir2_ix_id
	.byte	bytecode_INTARR_B
	.byte	bytecode_INTVAR_T

	.byte	bytecode_inc_ir2_ir2

	.byte	bytecode_arrval2_ir1_fx_ir2
	.byte	bytecode_FLTARR_P

	.byte	bytecode_peek_ir1_ir1

	.byte	bytecode_ld_ip_ir1

	; G(T)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_G
	.byte	bytecode_INTVAR_T

	.byte	bytecode_clr_ip

	; T(T)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_T
	.byte	bytecode_INTVAR_T

	.byte	bytecode_clr_ip

	; NEXT

	.byte	bytecode_next

LINE_950

	; U=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_U

	; O=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_O

	; FOR J=0 TO 15

	.byte	bytecode_forclr_ix
	.byte	bytecode_INTVAR_J

	.byte	bytecode_to_ip_pb
	.byte	15

	; H(J)=0

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_H
	.byte	bytecode_INTVAR_J

	.byte	bytecode_clr_ip

	; I(J)=1

	.byte	bytecode_arrref1_ir1_ix_id
	.byte	bytecode_INTARR_I
	.byte	bytecode_INTVAR_J

	.byte	bytecode_one_ip

	; NEXT

	.byte	bytecode_next

LINE_960

	; I$=INKEY$

	.byte	bytecode_inkey_sx
	.byte	bytecode_STRVAR_I

	; WHEN I$="" GOTO 960

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	0, ""

	.byte	bytecode_jmpne_ir1_ix
	.word	LINE_960

LINE_970

	; IF I$="N" THEN

	.byte	bytecode_ldeq_ir1_sx_ss
	.byte	bytecode_STRVAR_I
	.text	1, "N"

	.byte	bytecode_jmpeq_ir1_ix
	.word	LINE_990

	; S=0

	.byte	bytecode_clr_ix
	.byte	bytecode_INTVAR_S

	; GOTO 900

	.byte	bytecode_goto_ix
	.word	LINE_900

LINE_990

	; GOTO 20

	.byte	bytecode_goto_ix
	.word	LINE_20

LINE_1000

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT A$;"€€€€’€€€€€€€€€€€€Ü€€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1002

	; PRINT A$;"¯¯¯¯¯¯Ü¯¯¯¯¯¯¯€€€Ü€€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1003

	; PRINT A$;"€€€€€€ÜÌÌÌÌÌÌÌÌÌÌÜ€€€€’€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\xDC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xDC\x80\x80\x80\x80\x92\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1004

	; PRINT A$;"€€€€€€Ü€€€€¯¯Ü€€€¯¯¯¯¯¯Ü¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xAF\xAF\xDC\x80\x80\x80\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1005

	; PRINT A$;"€€€€€€Ü€€€€¯¯Ü€€€€€€€€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1006

	; PRINT A$;"€€€€€€Ü€€€€¯¯Ü€€€€€€€’€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x92\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1007

	; PRINT A$;"¯¯Ü¯¯¯¯€€€€¯¯¯¯¯¯¯¯Ü¯¯¯¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xDC\xAF\xAF\xAF\xAF\x80\x80\x80\x80\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1008

	; PRINT A$;"€€Ü€€€€€€€€€€€€€€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1009

	; PRINT A$;"€€Ü€€€€€€€€€€€€€€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1010

	; PRINT A$;"¯¯¯¯¯¯¯¯Ü¯¯¯¯¯¯¯¯¯¯Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1011

	; PRINT A$;"€€€€€€€€Ü€€€€€€€€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1012

	; PRINT A$;"€€€€€€’€ÜÌÌÌÌÌÌÌÌÌÌÜ€€’€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x92\x80\xDC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xDC\x80\x80\x92\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1013

	; PRINT A$;"€€€€Ü¯¯¯¯¯€€€€€€€€€¯¯¯¯¯¯Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\x80\x80\x80\x80\x80\x80\x80\x80\x80\xAF\xAF\xAF\xAF\xAF\xAF\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1014

	; PRINT A$;"€€€€Ü€€€€€€€€€€€’€€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1015

	; W=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	6

	; E(1)=20

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	20

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=16

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	16

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=8

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	8

	; B(2)=6

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	6

	; A(3)=25

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	25

	; B(3)=6

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	6

	; A(4)=16

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	16

	; B(4)=9

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	9

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1100

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT A$;"€€€’€€€€€€€€€€€€€€€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1102

	; PRINT A$;"Ü¯¯ï¯¯Ü€€€€€€€€€€’€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xAF\xAF\xEF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1103

	; PRINT A$;"Ü€€€€€Ü€€€€Ü¯¯¯¯¯¯¯¯Ü€’€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x92\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1104

	; PRINT A$;"Ü€’€€€Ü€€€€Ü€€€€€€€€Ü¯¯¯°Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x92\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xB0\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1105

	; PRINT A$;"Üï¯ï¯ïÜ€€€€Ü€€€€€€€€Ü€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xEF\xAF\xEF\xAF\xEF\xDC\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1106

	; PRINT A$;"Ü€€€€€ÜÌÌÌÌÜÌÌÌÌÌ€€€Ü€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\xCC\xCC\xCC\xCC\xDC\xCC\xCC\xCC\xCC\xCC\x80\x80\x80\xDC\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1107

	; PRINT A$;"Ü€€€€€Ü€€€€Ü€€€€Ü¯¯¯ïïïïïÜ";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xEF\xEF\xEF\xEF\xEF\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1108

	; PRINT A$;"Ü€€€€€Ü€€€€Ü€’€€Ü€€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\x80\x92\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1109

	; PRINT A$;"Ü€€€€€Ü€’€€Ü¯¯¯¯Ü€€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x92\x80\x80\xDC\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1110

	; PRINT A$;"ï¯¯¯ï¯¯ï¯¯ïÜ€€€€€€€€Ü¯¯Ü¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xEF\xAF\xAF\xAF\xEF\xAF\xAF\xEF\xAF\xAF\xEF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xDC\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1111

	; PRINT A$;"ï¯¯¯ï€€€€€€Ü€€€€€€€€Ü€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xEF\xAF\xAF\xAF\xEF\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1112

	; PRINT A$;"ï’€€ï€€€€€€Ü€€ÌÌÌÌÌÌÜ€€Ü€’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xEF\x92\x80\x80\xEF\x80\x80\x80\x80\x80\x80\xDC\x80\x80\xCC\xCC\xCC\xCC\xCC\xCC\xDC\x80\x80\xDC\x80\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1113

	; PRINT A$;"ï¯¯¯ï¯¯¯Ü¯¯¯ïïï€€€€€Ü€¯¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xEF\xAF\xAF\xAF\xEF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xEF\xEF\xEF\x80\x80\x80\x80\x80\xDC\x80\xAF\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1114

	; PRINT A$;"€€€€€€€€Ü€€€€€€€€€€€Ü€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1115

	; W=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	8

	; E(1)=28

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	28

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=15

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	15

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=7

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	7

	; B(2)=4

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	4

	; A(3)=22

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	22

	; B(3)=6

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	6

	; A(4)=7

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	7

	; B(4)=9

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	9

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1200

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT A$;"ÌÌÌÌÌÌÌÌÌ€€€’€€€€€€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1202

	; PRINT A$;"Ü’€€€€€€Ü¯¯¯¯¯¯¯¯¯Ü€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x92\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1203

	; PRINT A$;"¯¯¯¯Ü€€€Ü€€€€€€€€€Üïïïïïïï";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xEF\xEF\xEF\xEF\xEF\xEF\xEF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1204

	; PRINT A$;"€€€€Ü€€€Ü€€€€’€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\x80\x80\x80\xDC\x80\x80\x80\x80\x92\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1205

	; PRINT A$;"€€€€Ü¯¯¯¯¯Ü¯¯¯¯¯Ü¯¯€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1206

	; PRINT A$;"€’€€Ü€€€€€Ü€€€€€Ü€€ÌÌ€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x92\x80\x80\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\xCC\xCC\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1207

	; PRINT A$;"¯¯¯Ü¯€€€€€Ü€€€€€Ü€€€€ÌÌ€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xDC\xAF\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xCC\xCC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1208

	; PRINT A$;"€€€Ü€€€€Ü¯¯¯¯¯Ü¯¯€€€€€€ÌÌ’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\x80\x80\x80\x80\x80\x80\xCC\xCC\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1209

	; PRINT A$;"€€€ÜÌÌÌÌÜ€€€€€Ü€€€€€€€€€€¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\xDC\xCC\xCC\xCC\xCC\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1210

	; PRINT A$;"€€€Ü€€€€€€Ü¯¯¯¯¯¯¯¯¯Ü€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1211

	; PRINT A$;"€€€Ü€€€€€€Ü¯¯¯¯¯¯¯¯¯Ü€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1212

	; PRINT A$;"¯¯Ü¯¯¯¯¯¯¯¯¯€€€’€€€¯¯¯¯¯Ü¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\x80\x80\x92\x80\x80\x80\xAF\xAF\xAF\xAF\xAF\xDC\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1213

	; PRINT A$;"¯¯Ü¯¯¯¯¯¯¯¯¯€Ü¯¯¯Ü€¯¯¯¯¯Ü¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\xDC\xAF\xAF\xAF\xDC\x80\xAF\xAF\xAF\xAF\xAF\xDC\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1214

	; PRINT A$;"€€Ü€€€€€€€€€€Ü¯¯¯Ü€€€€€€Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1215

	; W=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	6

	; E(1)=28

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	28

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=12

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	12

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=9

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	9

	; B(2)=4

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	4

	; A(3)=16

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	16

	; B(3)=7

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	7

	; A(4)=20

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	20

	; B(4)=9

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	9

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1300

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT A$;"ÜÌÌÌÌÌÌÌÌÌÌ€€€€€€€€€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1302

	; PRINT A$;"Ü€€€€Ü€€€€€¯€’€¯€€€€€Ü€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xAF\x80\x92\x80\xAF\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1303

	; PRINT A$;"Ü’€€ÜÜÜ€€’€¯¯¯¯¯€’€€ÜÜÜ€€’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x92\x80\x80\xDC\xDC\xDC\x80\x80\x92\x80\xAF\xAF\xAF\xAF\xAF\x80\x92\x80\x80\xDC\xDC\xDC\x80\x80\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1304

	; PRINT A$;"€ÜÜ€€Ü€€ÜÜ€€€€€€€ÜÜ€€Ü€€ÜÜ";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\xDC\x80\x80\xDC\x80\x80\xDC\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\xDC\x80\x80\xDC\x80\x80\xDC\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1305

	; PRINT A$;"€Ü€ÜÜÜÜÜ€Ü€€€€€€€Ü€ÜÜÜÜÜ€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\x80\xDC\xDC\xDC\xDC\xDC\x80\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\x80\xDC\xDC\xDC\xDC\xDC\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1306

	; PRINT A$;"€Ü€€’€’€€Ü€€€Ü€€€Ü€€’€’€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\x80\x80\x92\x80\x92\x80\x80\xDC\x80\x80\x80\xDC\x80\x80\x80\xDC\x80\x80\x92\x80\x92\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1307

	; PRINT A$;"Ü€Ü¯¯¯¯¯Ü€€€ÜÜÜ€€€Ü¯¯¯¯¯Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xDC\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\xDC\xDC\xDC\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1308

	; PRINT A$;"Ü€€ÜÜÜÜÜ€ÜÜ€€Ü€€ÜÜ€ÜÜÜÜÜ€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\xDC\xDC\xDC\xDC\xDC\x80\xDC\xDC\x80\x80\xDC\x80\x80\xDC\xDC\x80\xDC\xDC\xDC\xDC\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1309

	; PRINT A$;"Ü€€€€€€€€Ü€ÜÜÜÜÜ€Ü€€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\xDC\xDC\xDC\xDC\xDC\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1310

	; PRINT A$;"Ü€€€’€€€€Ü€€’€’€€Ü€€€€’€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x92\x80\x80\x80\x80\xDC\x80\x80\x92\x80\x92\x80\x80\xDC\x80\x80\x80\x80\x92\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1311

	; PRINT A$;"Ü¯¯¯¯¯Ü€€€Ü¯¯¯¯¯Ü€€Ü¯¯¯¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1312

	; PRINT A$;"Ü€€€€€Ü€€€€ÜÜÜÜÜ€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\xDC\xDC\xDC\xDC\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1313

	; PRINT A$;"Ü€€€€€Ü€€€€€€€€€€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1314

	; PRINT A$;"Ü€€€€€Ü€€€€€€€’€€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1315

	; W=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	14

	; E(1)=3

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	3

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=20

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	20

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=8

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	8

	; B(2)=6

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	6

	; A(3)=24

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	24

	; B(3)=6

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	6

	; A(4)=16

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	16

	; B(4)=10

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	10

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1400

	; V=10

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	10

	; PRINT A$;"€€€€€€€€ÜÌÌÌ€€€€€€’€€€€€Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xCC\xCC\xCC\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1402

	; PRINT A$;"€€€€’€€€Ü€€€¯¯¯¯¯¯¯¯€€€€Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x92\x80\x80\x80\xDC\x80\x80\x80\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\x80\x80\x80\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1403

	; PRINT A$;"¯¯¯¯¯¯¯¯¯¯Ü€€€€€€€€’€€€€Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1404

	; PRINT A$;"€€€€€€€€€€Ü¯¯¯¯¯¯Ü¯¯¯¯Ü¯¯€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xDC\xAF\xAF\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1405

	; PRINT A$;"€€€€€€€€€€Ü€€€€€€Ü€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1406

	; PRINT A$;"¯¯¯¯¯¯¯¯¯¯Ü€€€€€€Ü€€€€Ü€€’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xDC\x80\x80\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1407

	; PRINT A$;"¯¯¯¯¯¯¯¯¯¯Ü¯¯¯¯¯¯¯ïï€€Ü¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xEF\xEF\x80\x80\xDC\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1408

	; PRINT A$;"¯¯¯¯¯¯¯¯¯¯Ü€€€€€€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1409

	; PRINT A$;"¯¯¯¯¯¯¯¯¯¯Ü€€€€€€’€ÌÌÌÜ€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x92\x80\xCC\xCC\xCC\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1410

	; PRINT A$;"¯¯€€€€€€¯¯Ü€€€€€€¯¯€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\x80\x80\x80\x80\x80\x80\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\xAF\xAF\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1411

	; PRINT A$;"¯¯€€’’€€¯¯Ü€€€€’€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\x80\x80\x92\x92\x80\x80\xAF\xAF\xDC\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1412

	; PRINT A$;"¯¯¯¯¯¯¯¯¯¯¯Ü¯¯¯¯¯¯Ü€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1413

	; PRINT A$;"€€€€€€€€€€€Ü€€€€€€¯¯¯¯¯¯¯Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1414

	; PRINT A$;"€€€€’€€€€€€Ü€€€€€€€€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1415

	; W=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	9

	; E(1)=27

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	27

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=12

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	12

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=2

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	2

	; A(2)=3

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	3

	; B(2)=5

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	5

	; A(3)=21

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	21

	; B(3)=6

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	6

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1500

	; V=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	6

	; PRINT A$;"€€€€€€€€€Ü€€€€€€€’€€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1502

	; PRINT A$;"¯¯¯€€€€€€Ü€€€€€€¯¯¯Ü¯¯¯¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1503

	; PRINT A$;"€€€¯€€€€€Ü€€€€€¯¯€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\xAF\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xAF\xAF\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1504

	; PRINT A$;"€€€¯¯€€€€Ü€€€€¯¯€€€Ü€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\xAF\xAF\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xAF\xAF\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1505

	; PRINT A$;"’€€¯¯¯€€€Ü€€’¯¯¯€€€Ü€€€’€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x92\x80\x80\xAF\xAF\xAF\x80\x80\x80\xDC\x80\x80\x92\xAF\xAF\xAF\x80\x80\x80\xDC\x80\x80\x80\x92\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1506

	; PRINT A$;"¯¯Ü¯¯¯¯€€Ü€€¯¯¯¯Ü¯¯Ü¯¯¯¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xDC\xAF\xAF\xAF\xAF\x80\x80\xDC\x80\x80\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1507

	; PRINT A$;"€€Ü€€€¯¯€Ü€¯¯€€€Ü€€€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\xDC\x80\x80\x80\xAF\xAF\x80\xDC\x80\xAF\xAF\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1508

	; PRINT A$;"€€Ü’€€€¯¯Ü¯¯€€€€Ü€€€€’€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\xDC\x92\x80\x80\x80\xAF\xAF\xDC\xAF\xAF\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x92\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1509

	; PRINT A$;"Ü¯¯¯Ü€€€€Ü€€€€€¯Ü¯Ü¯¯¯€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xAF\xAF\xAF\xDC\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xAF\xDC\xAF\xDC\xAF\xAF\xAF\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1510

	; PRINT A$;"Ü€€€Ü€€€€€€€€€€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1511

	; PRINT A$;"Ü€€€Ü€€€€’€€€€€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\xDC\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1512

	; PRINT A$;"Ü€€€Ü¯¯¯¯¯¯¯Ü¯¯¯¯¯Ü¯¯¯¯Ü¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xDC\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1513

	; PRINT A$;"Ü€€€€€€€€€€€Ü€€€€€€€€€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1514

	; PRINT A$;"Ü€€€€€€€€€€€Ü€€€€€€€€€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1515

	; W=7

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	7

	; E(1)=12

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	12

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=18

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	18

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	4

	; A(2)=26

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	26

	; B(2)=1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_one_ip

	; A(3)=4

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	4

	; B(3)=5

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	5

	; A(4)=7

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	7

	; B(4)=8

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	8

	; A(5)=18

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	18

	; B(5)=11

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	11

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1600

	; V=6

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	6

	; PRINT A$;"€Ü€€€€€€€€€€€€€€€€ÌÌÌÌÌÌÌÌ";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1602

	; PRINT A$;"€Ü€€€€€€€€€€€€€€€€Ü€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1603

	; PRINT A$;"¯¯¯¯Ü¯€€€¯Ü¯¯¯€€€€Ü€€€€’€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xDC\xAF\x80\x80\x80\xAF\xDC\xAF\xAF\xAF\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x92\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1604

	; PRINT A$;"€€€€Ü€€€€€Ü€€€€¯¯¯Ü¯¯¯¯¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1605

	; PRINT A$;"€€€€Ü€€’€€Ü€€€€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\x80\x80\x92\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1606

	; PRINT A$;"¯¯¯¯Ü¯¯¯€€Ü€€€€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1607

	; PRINT A$;"€€€€Ü€€€€€Ü€€€€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1608

	; PRINT A$;"€’€€Ü€€’€€Ü€€€€€€€Ü€€€€€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x92\x80\x80\xDC\x80\x80\x92\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1609

	; PRINT A$;"¯Ü¯¯¯¯¯¯¯¯¯¯¯Ü€€€€Ü€¯¯¯¯€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\xDC\x80\xAF\xAF\xAF\xAF\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1610

	; PRINT A$;"€Ü€€€€€€€€€€€Ü€’€€Ü€¯¯¯¯€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x92\x80\x80\xDC\x80\xAF\xAF\xAF\xAF\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1611

	; PRINT A$;"€Ü€€’€€€€€€€€ÜÌÌÌÌÜ€¯€’¯€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\xDC\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xCC\xCC\xCC\xCC\xDC\x80\xAF\x80\x92\xAF\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1612

	; PRINT A$;"¯¯¯¯¯¯Ü€€€€€€€€€€€Ü€¯¯¯¯¯Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\xAF\xAF\xAF\xAF\xAF\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1613

	; PRINT A$;"€€€€€€Ü€€€€€€€€€€€Ü€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1614

	; PRINT A$;"€€€€€€Ü€€€€€€€€€’€Ü€€€€€€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x92\x80\xDC\x80\x80\x80\x80\x80\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1615

	; W=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	8

	; E(1)=4

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	4

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=11

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	11

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=4

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	4

	; A(2)=14

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	14

	; B(2)=2

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	2

	; A(3)=20

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	20

	; B(3)=3

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	3

	; A(4)=4

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	4

	; B(4)=5

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	5

	; A(5)=24

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	24

	; B(5)=14

	.byte	bytecode_ld_ir1_pb
	.byte	5

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1700

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT A$;"€€€€€€’€€€€’€€€€€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\x80\x92\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1702

	; PRINT A$;"Ü¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯Ü€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1703

	; PRINT A$;"Ü€€€€€€€€€€€€’€€ÜÌÌÌÌÌÜ€€’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x92\x80\x80\xDC\xCC\xCC\xCC\xCC\xCC\xDC\x80\x80\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1704

	; PRINT A$;"¯¯¯¯¯¯¯¯¯Ü¯¯¯¯¯¯¯€€€€€Ü¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1705

	; PRINT A$;"¯¯¯¯¯¯¯¯ÜÜ€€€€€€€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1706

	; PRINT A$;"¯¯¯¯¯¯¯ÜÜÌÌÌÌÌÌÜ€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xDC\xCC\xCC\xCC\xCC\xCC\xCC\xDC\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1707

	; PRINT A$;"¯’€’¯¯ÜÜ€€€€€€€Ü€’€€€€Ü€€’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\x92\x80\x92\xAF\xAF\xDC\xDC\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x92\x80\x80\x80\x80\xDC\x80\x80\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1708

	; PRINT A$;"¯¯¯¯¯ÜÜ€€€€Ü¯¯¯¯ïï¯¯¯¯Ü¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xAF\xAF\xAF\xAF\xAF\xDC\xDC\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xEF\xEF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1709

	; PRINT A$;"€€€€€Ü€€€€€Ü€€€€€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1710

	; PRINT A$;"€€€€€Ü€€€’€ÜÌÌÌÌÌÌÌÌÌÌÜ€€’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x92\x80\xDC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xCC\xDC\x80\x80\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1711

	; PRINT A$;"Ü¯¯¯¯¯¯¯¯¯¯Ü€€’€€€€’€€Ü¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x92\x80\x80\x80\x80\x92\x80\x80\xDC\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1712

	; PRINT A$;"Ü€€€€€€€€€€Ü€¯¯¯¯¯¯¯¯€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1713

	; PRINT A$;"Ü€€€€€€€€€€Ü€€€€€€€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1714

	; PRINT A$;"Ü€€€€€€’€€€Ü€€€€€€’€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x92\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1715

	; W=14

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	14

	; E(1)=25

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	25

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=19

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	19

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=16

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	16

	; B(2)=7

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	7

	; A(3)=23

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	23

	; B(3)=7

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	7

	; A(4)=7

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	7

	; B(4)=10

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	10

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1800

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT A$;"€€€€€€€€€€€€€€€€€€€€€€€€Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1802

	; PRINT A$;"Ü¯¯¯¯¯¯¯¯¯¯Ü€€€€€’€€€’€€Ü€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x92\x80\x80\x80\x92\x80\x80\xDC\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1803

	; PRINT A$;"Ü€€€€€€€€€€Ü¯¯¯¯¯Ü€€¯¯Ü¯¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\xAF\xAF\xDC\xAF\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1804

	; PRINT A$;"Ü€’€€€€€€’€Ü€€€€ïÜ€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x92\x80\x80\x80\x80\x80\x80\x92\x80\xDC\x80\x80\x80\x80\xEF\xDC\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1805

	; PRINT A$;"Ü€¯€€¯¯¯€¯€Ü€’’€ïÜ€€€€Ü€€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\x80\x80\xAF\xAF\xAF\x80\xAF\x80\xDC\x80\x92\x92\x80\xEF\xDC\x80\x80\x80\x80\xDC\x80\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1806

	; PRINT A$;"Ü€¯€¯¯¯€€¯€Ü€ïï€ï¯¯¯¯¯¯¯¯ï";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\x80\xAF\xAF\xAF\x80\x80\xAF\x80\xDC\x80\xEF\xEF\x80\xEF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xEF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1807

	; PRINT A$;"Ü€¯€€¯¯¯€¯€Ü€ïï€€€€€€€€€ï’";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\x80\x80\xAF\xAF\xAF\x80\xAF\x80\xDC\x80\xEF\xEF\x80\x80\x80\x80\x80\x80\x80\x80\x80\xEF\x92"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1808

	; PRINT A$;"Ü€¯€¯¯¯€€¯€Ü€ïÌÌÌÌÌÌ€’€€ïÜ";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\x80\xAF\xAF\xAF\x80\x80\xAF\x80\xDC\x80\xEF\xCC\xCC\xCC\xCC\xCC\xCC\x80\x92\x80\x80\xEF\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1809

	; PRINT A$;"Ü€¯’€¯¯¯€¯€Ü€ï’€€€€€¯¯¯ÜïÜ";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\x92\x80\xAF\xAF\xAF\x80\xAF\x80\xDC\x80\xEF\x92\x80\x80\x80\x80\x80\xAF\xAF\xAF\xDC\xEF\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1810

	; PRINT A$;"Ü€¯¯¯¯¯€€¯€Ü€ïï€€€€€€€€Ü€Ü";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\xAF\xAF\xAF\xAF\x80\x80\xAF\x80\xDC\x80\xEF\xEF\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\xDC"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1811

	; PRINT A$;"Ü€¯¯¯¯¯¯¯¯€Ü€ïï€€€’€€€€Ü¯¯";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\x80\xDC\x80\xEF\xEF\x80\x80\x80\x92\x80\x80\x80\x80\xDC\xAF\xAF"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1812

	; PRINT A$;"Ü€€€€€€€€€€Ü€ïï€¯¯¯¯€€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\xEF\xEF\x80\xAF\xAF\xAF\xAF\x80\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1813

	; PRINT A$;"Üïïïïïïïï¯ïïïïï€€€€€€€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xAF\xEF\xEF\xEF\xEF\xEF\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1814

	; PRINT A$;"Ü€€€€€€€€€€€€€€€€€€€€€€Ü€€";A$;

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

	.byte	bytecode_pr_ss
	.text	26, "\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80"

	.byte	bytecode_pr_sx
	.byte	bytecode_STRVAR_A

LINE_1815

	; W=11

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	11

	; E(1)=27

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	27

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=17

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	17

	; B(1)=14

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	14

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=8

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	8

	; B(2)=1

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_one_ip

	; A(3)=17

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	17

	; B(3)=2

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	2

	; A(4)=23

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	23

	; B(4)=5

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	5

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LINE_1900

	; V=8

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_V
	.byte	8

	; PRINT "¯€€€€€€€€€€€€€€€Ü€€€€€€€€€€€€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xDC\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\xAF"

LINE_1902

	; PRINT "¯€€€ÌÌÌÌÌ€€€€€€Ü¯Ü€€€€€€ÌÌÌÌÌ€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\xCC\xCC\xCC\xCC\xCC\x80\x80\x80\x80\x80\x80\xDC\xAF\xDC\x80\x80\x80\x80\x80\x80\xCC\xCC\xCC\xCC\xCC\x80\x80\xAF"

LINE_1903

	; PRINT "¯€€€€€€€ÜÌÌÌÜ¯’Ü¯Ü’¯ÜÌÌÌÜ€€€€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xCC\xCC\xCC\xDC\xAF\x92\xDC\xAF\xDC\x92\xAF\xDC\xCC\xCC\xCC\xDC\x80\x80\x80\x80\x80\x80\xAF"

LINE_1904

	; PRINT "¯€€€Ü¯’¯Ü€€€Ü¯¯¯¯¯¯¯Ü€€€Ü¯’¯Ü€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\xDC\xAF\x92\xAF\xDC\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\xDC\xAF\x92\xAF\xDC\x80\x80\xAF"

LINE_1905

	; PRINT "¯€€€Ü¯¯¯€€€€ÜÌÜ¯€¯ÜÌÜ€€€€¯¯¯Ü€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\xDC\xAF\xAF\xAF\x80\x80\x80\x80\xDC\xCC\xDC\xAF\x80\xAF\xDC\xCC\xDC\x80\x80\x80\x80\xAF\xAF\xAF\xDC\x80\x80\xAF"

LINE_1906

	; PRINT "¯€€€ÜÜ¯€€€€€€€Ü¯¯¯Ü€€€€€€€¯ÜÜ€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\xDC\xDC\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\xAF\xDC\xDC\x80\x80\xAF"

LINE_1907

	; PRINT "¯€€€€Ü¯€€€€€€€Ü¯€¯Ü€€€€€€€¯Ü€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\xDC\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\x80\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\xAF\xDC\x80\x80\x80\xAF"

LINE_1908

	; PRINT "¯€€€€Ü¯€€€€€€€Ü¯¯¯Ü€€€€€€€¯Ü€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\xDC\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\xAF\xDC\x80\x80\x80\xAF"

LINE_1909

	; PRINT "¯€€€€Ü¯€€€€€€€Ü¯€¯Ü€€€€€€€¯Ü€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\xDC\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\x80\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\xAF\xDC\x80\x80\x80\xAF"

LINE_1910

	; PRINT "¯€€€€Ü¯€€€€€€€Ü¯¯¯Ü€€€€€€€¯Ü€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\xDC\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\xAF\xDC\x80\x80\x80\xAF"

LINE_1911

	; PRINT "¯€€€€Ü¯€€€€€€€Ü¯€¯Ü€€€€€€€¯Ü€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\xDC\xAF\x80\x80\x80\x80\x80\x80\x80\xDC\xAF\x80\xAF\xDC\x80\x80\x80\x80\x80\x80\x80\xAF\xDC\x80\x80\x80\xAF"

LINE_1912

	; PRINT "¯€€€€Ü¯¯¯¯¯¯¯¯Ü¯¯¯Ü¯¯¯¯¯¯¯¯Ü€€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x80\x80\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xDC\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xAF\xDC\x80\x80\x80\xAF"

LINE_1913

	; PRINT "¯€€’€Ü¯€€€’€€¯Ü€’€Ü¯€€’€€€¯Ü’€€¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\x80\x80\x92\x80\xDC\xAF\x80\x80\x80\x92\x80\x80\xAF\xDC\x80\x92\x80\xDC\xAF\x80\x80\x92\x80\x80\x80\xAF\xDC\x92\x80\x80\xAF"

LINE_1914

	; PRINT "¯ïïïïïïïïïïïïïïïïïïïïïïïïïïïïïï¯";

	.byte	bytecode_pr_ss
	.text	32, "\xAF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xEF\xAF"

LINE_1915

	; W=9

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_W
	.byte	9

	; E(1)=16

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_ld_ip_pb
	.byte	16

	; E(2)=0

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_E

	.byte	bytecode_clr_ip

	; A(1)=20

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	20

	; B(1)=11

	.byte	bytecode_ld_ir1_pb
	.byte	1

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	11

	; F=3

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_F
	.byte	3

	; A(2)=12

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	12

	; B(2)=2

	.byte	bytecode_ld_ir1_pb
	.byte	2

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	2

	; A(3)=20

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	20

	; B(3)=2

	.byte	bytecode_ld_ir1_pb
	.byte	3

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	2

	; A(4)=24

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_A

	.byte	bytecode_ld_ip_pb
	.byte	24

	; B(4)=11

	.byte	bytecode_ld_ir1_pb
	.byte	4

	.byte	bytecode_arrref1_ir1_ix_ir1
	.byte	bytecode_INTARR_B

	.byte	bytecode_ld_ip_pb
	.byte	11

	; NX=16

	.byte	bytecode_ld_ix_pb
	.byte	bytecode_INTVAR_NX
	.byte	16

	; NY=1

	.byte	bytecode_one_ix
	.byte	bytecode_INTVAR_NY

	; RETURN

	.byte	bytecode_return

LLAST

	; END

	.byte	bytecode_progend

; Library Catalog
bytecode_add_fr1_fr1_ix	.equ	0
bytecode_add_fr1_ir1_fx	.equ	1
bytecode_add_ip_ip_ir1	.equ	2
bytecode_add_ir1_ir1_ir2	.equ	3
bytecode_add_ir1_ir1_ix	.equ	4
bytecode_add_ir2_ir2_ir3	.equ	5
bytecode_and_ir1_ir1_ir2	.equ	6
bytecode_and_ir1_ir1_pb	.equ	7
bytecode_arrdim1_ir1_ix	.equ	8
bytecode_arrdim2_ir1_fx	.equ	9
bytecode_arrdim2_ir1_ix	.equ	10
bytecode_arrref1_ir1_ix_id	.equ	11
bytecode_arrref1_ir1_ix_ir1	.equ	12
bytecode_arrref2_ir1_fx_id	.equ	13
bytecode_arrref2_ir1_ix_id	.equ	14
bytecode_arrref2_ir1_ix_ir2	.equ	15
bytecode_arrval1_ir1_ix_id	.equ	16
bytecode_arrval1_ir1_ix_ir1	.equ	17
bytecode_arrval1_ir2_ix_id	.equ	18
bytecode_arrval1_ir2_ix_ir2	.equ	19
bytecode_arrval1_ir3_ix_id	.equ	20
bytecode_arrval2_ir1_fx_id	.equ	21
bytecode_arrval2_ir1_fx_ir2	.equ	22
bytecode_arrval2_ir1_ix_id	.equ	23
bytecode_clear	.equ	24
bytecode_clr_ip	.equ	25
bytecode_clr_ix	.equ	26
bytecode_cls	.equ	27
bytecode_clsn_pb	.equ	28
bytecode_com_ir2_ir2	.equ	29
bytecode_dec_ip_ip	.equ	30
bytecode_dec_ir1_ir1	.equ	31
bytecode_dec_ir2_ir2	.equ	32
bytecode_dec_ix_ix	.equ	33
bytecode_for_ix_pb	.equ	34
bytecode_for_ix_pw	.equ	35
bytecode_forclr_fx	.equ	36
bytecode_forclr_ix	.equ	37
bytecode_forone_ix	.equ	38
bytecode_gosub_ix	.equ	39
bytecode_goto_ix	.equ	40
bytecode_ignxtra	.equ	41
bytecode_inc_ip_ip	.equ	42
bytecode_inc_ir1_ir1	.equ	43
bytecode_inc_ir2_ir2	.equ	44
bytecode_inc_ix_ix	.equ	45
bytecode_inkey_sx	.equ	46
bytecode_input	.equ	47
bytecode_irnd_ir1_pb	.equ	48
bytecode_jmpeq_ir1_ix	.equ	49
bytecode_jmpne_ir1_ix	.equ	50
bytecode_jsrne_ir1_ix	.equ	51
bytecode_ld_fp_fr1	.equ	52
bytecode_ld_fr1_fx	.equ	53
bytecode_ld_fx_fr1	.equ	54
bytecode_ld_id_ix	.equ	55
bytecode_ld_ip_ir1	.equ	56
bytecode_ld_ip_pb	.equ	57
bytecode_ld_ir1_ix	.equ	58
bytecode_ld_ir1_pb	.equ	59
bytecode_ld_ir2_pb	.equ	60
bytecode_ld_ix_ir1	.equ	61
bytecode_ld_ix_pb	.equ	62
bytecode_ld_ix_pw	.equ	63
bytecode_ld_sr1_ss	.equ	64
bytecode_ld_sx_sr1	.equ	65
bytecode_ldeq_ir1_ir1_ir2	.equ	66
bytecode_ldeq_ir1_ir1_ix	.equ	67
bytecode_ldeq_ir1_ix_id	.equ	68
bytecode_ldeq_ir1_ix_pb	.equ	69
bytecode_ldeq_ir1_sx_ss	.equ	70
bytecode_ldeq_ir2_ir2_ir3	.equ	71
bytecode_ldeq_ir2_ix_id	.equ	72
bytecode_ldeq_ir2_ix_pb	.equ	73
bytecode_ldge_ir1_ix_pw	.equ	74
bytecode_ldlt_ir1_fx_pb	.equ	75
bytecode_ldlt_ir1_ir1_ix	.equ	76
bytecode_ldlt_ir1_ix_pb	.equ	77
bytecode_ldlt_ir1_pb_ir1	.equ	78
bytecode_ldlt_ir2_pb_fx	.equ	79
bytecode_ldne_ir1_ir1_ix	.equ	80
bytecode_ldne_ir1_sx_ss	.equ	81
bytecode_mul_fr1_fr1_pb	.equ	82
bytecode_mul_ir1_ir1_pb	.equ	83
bytecode_neg_ir1_ir1	.equ	84
bytecode_next	.equ	85
bytecode_one_ip	.equ	86
bytecode_one_ix	.equ	87
bytecode_ongosub_ir1_is	.equ	88
bytecode_ongoto_ir1_is	.equ	89
bytecode_or_ir1_ir1_ir2	.equ	90
bytecode_peek2_ir1	.equ	91
bytecode_peek_ir1_ir1	.equ	92
bytecode_peek_ir2_pw	.equ	93
bytecode_poke_id_ix	.equ	94
bytecode_poke_ir1_ix	.equ	95
bytecode_poke_ir1_pb	.equ	96
bytecode_poke_ix_ir1	.equ	97
bytecode_poke_ix_pb	.equ	98
bytecode_poke_pw_ir1	.equ	99
bytecode_pr_sr1	.equ	100
bytecode_pr_ss	.equ	101
bytecode_pr_sx	.equ	102
bytecode_prat_pb	.equ	103
bytecode_prat_pw	.equ	104
bytecode_progbegin	.equ	105
bytecode_progend	.equ	106
bytecode_readbuf_fx	.equ	107
bytecode_return	.equ	108
bytecode_rnd_fr1_ir1	.equ	109
bytecode_rsub_fr1_fr1_pw	.equ	110
bytecode_shift_ir1_ir1_pb	.equ	111
bytecode_sound_ir1_ir2	.equ	112
bytecode_str_sr1_fx	.equ	113
bytecode_str_sr1_ir1	.equ	114
bytecode_str_sr1_ix	.equ	115
bytecode_sub_ir1_ir1_ir2	.equ	116
bytecode_timer_ir1	.equ	117
bytecode_to_fp_pb	.equ	118
bytecode_to_ip_ix	.equ	119
bytecode_to_ip_pb	.equ	120
bytecode_to_ip_pw	.equ	121
bytecode_true_ip	.equ	122

catalog
	.word	add_fr1_fr1_ix
	.word	add_fr1_ir1_fx
	.word	add_ip_ip_ir1
	.word	add_ir1_ir1_ir2
	.word	add_ir1_ir1_ix
	.word	add_ir2_ir2_ir3
	.word	and_ir1_ir1_ir2
	.word	and_ir1_ir1_pb
	.word	arrdim1_ir1_ix
	.word	arrdim2_ir1_fx
	.word	arrdim2_ir1_ix
	.word	arrref1_ir1_ix_id
	.word	arrref1_ir1_ix_ir1
	.word	arrref2_ir1_fx_id
	.word	arrref2_ir1_ix_id
	.word	arrref2_ir1_ix_ir2
	.word	arrval1_ir1_ix_id
	.word	arrval1_ir1_ix_ir1
	.word	arrval1_ir2_ix_id
	.word	arrval1_ir2_ix_ir2
	.word	arrval1_ir3_ix_id
	.word	arrval2_ir1_fx_id
	.word	arrval2_ir1_fx_ir2
	.word	arrval2_ir1_ix_id
	.word	clear
	.word	clr_ip
	.word	clr_ix
	.word	cls
	.word	clsn_pb
	.word	com_ir2_ir2
	.word	dec_ip_ip
	.word	dec_ir1_ir1
	.word	dec_ir2_ir2
	.word	dec_ix_ix
	.word	for_ix_pb
	.word	for_ix_pw
	.word	forclr_fx
	.word	forclr_ix
	.word	forone_ix
	.word	gosub_ix
	.word	goto_ix
	.word	ignxtra
	.word	inc_ip_ip
	.word	inc_ir1_ir1
	.word	inc_ir2_ir2
	.word	inc_ix_ix
	.word	inkey_sx
	.word	input
	.word	irnd_ir1_pb
	.word	jmpeq_ir1_ix
	.word	jmpne_ir1_ix
	.word	jsrne_ir1_ix
	.word	ld_fp_fr1
	.word	ld_fr1_fx
	.word	ld_fx_fr1
	.word	ld_id_ix
	.word	ld_ip_ir1
	.word	ld_ip_pb
	.word	ld_ir1_ix
	.word	ld_ir1_pb
	.word	ld_ir2_pb
	.word	ld_ix_ir1
	.word	ld_ix_pb
	.word	ld_ix_pw
	.word	ld_sr1_ss
	.word	ld_sx_sr1
	.word	ldeq_ir1_ir1_ir2
	.word	ldeq_ir1_ir1_ix
	.word	ldeq_ir1_ix_id
	.word	ldeq_ir1_ix_pb
	.word	ldeq_ir1_sx_ss
	.word	ldeq_ir2_ir2_ir3
	.word	ldeq_ir2_ix_id
	.word	ldeq_ir2_ix_pb
	.word	ldge_ir1_ix_pw
	.word	ldlt_ir1_fx_pb
	.word	ldlt_ir1_ir1_ix
	.word	ldlt_ir1_ix_pb
	.word	ldlt_ir1_pb_ir1
	.word	ldlt_ir2_pb_fx
	.word	ldne_ir1_ir1_ix
	.word	ldne_ir1_sx_ss
	.word	mul_fr1_fr1_pb
	.word	mul_ir1_ir1_pb
	.word	neg_ir1_ir1
	.word	next
	.word	one_ip
	.word	one_ix
	.word	ongosub_ir1_is
	.word	ongoto_ir1_is
	.word	or_ir1_ir1_ir2
	.word	peek2_ir1
	.word	peek_ir1_ir1
	.word	peek_ir2_pw
	.word	poke_id_ix
	.word	poke_ir1_ix
	.word	poke_ir1_pb
	.word	poke_ix_ir1
	.word	poke_ix_pb
	.word	poke_pw_ir1
	.word	pr_sr1
	.word	pr_ss
	.word	pr_sx
	.word	prat_pb
	.word	prat_pw
	.word	progbegin
	.word	progend
	.word	readbuf_fx
	.word	return
	.word	rnd_fr1_ir1
	.word	rsub_fr1_fr1_pw
	.word	shift_ir1_ir1_pb
	.word	sound_ir1_ir2
	.word	str_sr1_fx
	.word	str_sr1_ir1
	.word	str_sr1_ix
	.word	sub_ir1_ir1_ir2
	.word	timer_ir1
	.word	to_fp_pb
	.word	to_ip_ix
	.word	to_ip_pb
	.word	to_ip_pw
	.word	true_ip

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

add_fr1_ir1_fx			; numCalls = 1
	.module	modadd_fr1_ir1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

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

add_ir1_ir1_ir2			; numCalls = 3
	.module	modadd_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 3
	.module	modadd_ir1_ir1_ix
	jsr	extend
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir2_ir2_ir3			; numCalls = 2
	.module	modadd_ir2_ir2_ir3
	jsr	noargs
	ldd	r2+1
	addd	r3+1
	std	r2+1
	ldab	r2
	adcb	r3
	stab	r2
	rts

and_ir1_ir1_ir2			; numCalls = 9
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

and_ir1_ir1_pb			; numCalls = 6
	.module	modand_ir1_ir1_pb
	jsr	getbyte
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

arrdim1_ir1_ix			; numCalls = 16
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

arrdim2_ir1_fx			; numCalls = 1
	.module	modarrdim2_ir1_fx
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
	lsld
	addd	tmp3
	jmp	alloc

arrdim2_ir1_ix			; numCalls = 1
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

arrref1_ir1_ix_id			; numCalls = 46
	.module	modarrref1_ir1_ix_id
	jsr	extdex
	jsr	getlw
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_ix_ir1			; numCalls = 142
	.module	modarrref1_ir1_ix_ir1
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref2_ir1_fx_id			; numCalls = 1
	.module	modarrref2_ir1_fx_id
	jsr	extdex
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
	jsr	ref2
	jsr	refflt
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

arrref2_ir1_ix_ir2			; numCalls = 4
	.module	modarrref2_ir1_ix_ir2
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
	jsr	ref2
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix_id			; numCalls = 63
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

arrval1_ir1_ix_ir1			; numCalls = 20
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

arrval1_ir2_ix_id			; numCalls = 41
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

arrval1_ir2_ix_ir2			; numCalls = 5
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

arrval1_ir3_ix_id			; numCalls = 4
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

arrval2_ir1_fx_id			; numCalls = 1
	.module	modarrval2_ir1_fx_id
	jsr	extdex
	jsr	getlw
	std	2+argv
	ldd	r1+1
	std	0+argv
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

arrval2_ir1_fx_ir2			; numCalls = 37
	.module	modarrval2_ir1_fx_ir2
	jsr	extend
	ldd	r1+1
	std	0+argv
	ldd	r1+1+5
	std	2+argv
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

arrval2_ir1_ix_id			; numCalls = 3
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

clr_ip			; numCalls = 21
	.module	modclr_ip
	jsr	noargs
	ldx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

clr_ix			; numCalls = 8
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

com_ir2_ir2			; numCalls = 6
	.module	modcom_ir2_ir2
	jsr	noargs
	com	r2+2
	com	r2+1
	com	r2
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

dec_ir1_ir1			; numCalls = 3
	.module	moddec_ir1_ir1
	jsr	noargs
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir2_ir2			; numCalls = 3
	.module	moddec_ir2_ir2
	jsr	noargs
	ldd	r2+1
	subd	#1
	std	r2+1
	ldab	r2
	sbcb	#0
	stab	r2
	rts

dec_ix_ix			; numCalls = 1
	.module	moddec_ix_ix
	jsr	extend
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_ix_pb			; numCalls = 9
	.module	modfor_ix_pb
	jsr	extbyte
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

for_ix_pw			; numCalls = 2
	.module	modfor_ix_pw
	jsr	extword
	stx	letptr
	clr	0,x
	std	1,x
	rts

forclr_fx			; numCalls = 1
	.module	modforclr_fx
	jsr	extend
	stx	letptr
	ldd	#0
	std	3,x
	std	1,x
	stab	0,x
	rts

forclr_ix			; numCalls = 4
	.module	modforclr_ix
	jsr	extend
	stx	letptr
	ldd	#0
	stab	0,x
	std	1,x
	rts

forone_ix			; numCalls = 5
	.module	modforone_ix
	jsr	extend
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 24
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

goto_ix			; numCalls = 32
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

inc_ip_ip			; numCalls = 6
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

inc_ir1_ir1			; numCalls = 4
	.module	modinc_ir1_ir1
	jsr	noargs
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir2_ir2			; numCalls = 7
	.module	modinc_ir2_ir2
	jsr	noargs
	inc	r2+2
	bne	_rts
	inc	r2+1
	bne	_rts
	inc	r2
_rts
	rts

inc_ix_ix			; numCalls = 7
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

input			; numCalls = 1
	.module	modinput
	jsr	noargs
	ldx	curinst
	stx	redoptr
	jmp	inputqs

irnd_ir1_pb			; numCalls = 3
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

jmpeq_ir1_ix			; numCalls = 17
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

jsrne_ir1_ix			; numCalls = 1
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

ld_fp_fr1			; numCalls = 1
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

ld_fr1_fx			; numCalls = 2
	.module	modld_fr1_fx
	jsr	extend
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 20
	.module	modld_fx_fr1
	jsr	extend
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_id_ix			; numCalls = 8
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

ld_ip_ir1			; numCalls = 18
	.module	modld_ip_ir1
	jsr	noargs
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 135
	.module	modld_ip_pb
	jsr	getbyte
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 18
	.module	modld_ir1_ix
	jsr	extend
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 202
	.module	modld_ir1_pb
	jsr	getbyte
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_pb			; numCalls = 33
	.module	modld_ir2_pb
	jsr	getbyte
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ix_ir1			; numCalls = 20
	.module	modld_ix_ir1
	jsr	extend
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pb			; numCalls = 53
	.module	modld_ix_pb
	jsr	extbyte
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 6
	.module	modld_ix_pw
	jsr	extword
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sr1_ss			; numCalls = 1
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

ld_sx_sr1			; numCalls = 1
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

ldeq_ir1_ix_id			; numCalls = 3
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

ldeq_ir1_ix_pb			; numCalls = 2
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

ldeq_ir1_sx_ss			; numCalls = 5
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

ldeq_ir2_ix_id			; numCalls = 2
	.module	modldeq_ir2_ix_id
	jsr	extdex
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

ldge_ir1_ix_pw			; numCalls = 2
	.module	modldge_ir1_ix_pw
	jsr	extword
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldlt_ir1_fx_pb			; numCalls = 1
	.module	modldlt_ir1_fx_pb
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

ldlt_ir1_ir1_ix			; numCalls = 1
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

ldlt_ir1_ix_pb			; numCalls = 1
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

ldlt_ir1_pb_ir1			; numCalls = 2
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

ldlt_ir2_pb_fx			; numCalls = 1
	.module	modldlt_ir2_pb_fx
	jsr	byteext
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

ldne_ir1_ir1_ix			; numCalls = 1
	.module	modldne_ir1_ir1_ix
	jsr	extend
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
	jsr	eistr
	stab	tmp1+1
	stx	tmp2
	ldx	tmp3
	jsr	streqx
	jsr	getne
	std	r1+1
	stab	r1
	rts

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_pb			; numCalls = 1
	.module	modmul_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	jsr	noargs
	ldx	#r1
	jmp	negxi

next			; numCalls = 47
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

one_ip			; numCalls = 10
	.module	modone_ip
	jsr	noargs
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 15
	.module	modone_ix
	jsr	extend
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongosub_ir1_is			; numCalls = 4
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

ongoto_ir1_is			; numCalls = 14
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

or_ir1_ir1_ir2			; numCalls = 3
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

peek2_ir1			; numCalls = 6
	.module	modpeek2_ir1
	jsr	noargs
	jsr	R_KPOLL
	ldab	2
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ir1			; numCalls = 16
	.module	modpeek_ir1_ir1
	jsr	noargs
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_pw			; numCalls = 6
	.module	modpeek_ir2_pw
	jsr	getword
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_id_ix			; numCalls = 11
	.module	modpoke_id_ix
	jsr	dexext
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ir1_ix			; numCalls = 3
	.module	modpoke_ir1_ix
	jsr	extend
	ldab	2,x
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 1
	.module	modpoke_ir1_pb
	jsr	getbyte
	ldx	r1+1
	stab	,x
	rts

poke_ix_ir1			; numCalls = 4
	.module	modpoke_ix_ir1
	jsr	extend
	ldab	r1+2
	ldx	1,x
	stab	,x
	rts

poke_ix_pb			; numCalls = 5
	.module	modpoke_ix_pb
	jsr	extbyte
	ldx	1,x
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

pr_sr1			; numCalls = 4
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

pr_ss			; numCalls = 173
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

pr_sx			; numCalls = 252
	.module	modpr_sx
	jsr	extend
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_pb			; numCalls = 4
	.module	modprat_pb
	jsr	getbyte
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 5
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

readbuf_fx			; numCalls = 1
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

return			; numCalls = 38
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

rsub_fr1_fr1_pw			; numCalls = 1
	.module	modrsub_fr1_fr1_pw
	jsr	getword
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

shift_ir1_ir1_pb			; numCalls = 1
	.module	modshift_ir1_ir1_pb
	jsr	getbyte
	ldx	#r1
	jmp	shlint

sound_ir1_ir2			; numCalls = 22
	.module	modsound_ir1_ir2
	jsr	noargs
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

str_sr1_fx			; numCalls = 1
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

sub_ir1_ir1_ir2			; numCalls = 2
	.module	modsub_ir1_ir1_ir2
	jsr	noargs
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
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

to_fp_pb			; numCalls = 1
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

to_ip_pb			; numCalls = 12
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

true_ip			; numCalls = 2
	.module	modtrue_ip
	jsr	noargs
	ldx	letptr
	ldd	#-1
	stab	0,x
	std	1,x
	rts

; data table
startdata
enddata

; Bytecode symbol lookup table


bytecode_INTVAR_B	.equ	0
bytecode_INTVAR_C	.equ	1
bytecode_INTVAR_D	.equ	2
bytecode_INTVAR_E	.equ	3
bytecode_INTVAR_F	.equ	4
bytecode_INTVAR_G	.equ	5
bytecode_INTVAR_G1	.equ	6
bytecode_INTVAR_G2	.equ	7
bytecode_INTVAR_I	.equ	8
bytecode_INTVAR_J	.equ	9
bytecode_INTVAR_L	.equ	10
bytecode_INTVAR_LC	.equ	11
bytecode_INTVAR_LV	.equ	12
bytecode_INTVAR_M	.equ	13
bytecode_INTVAR_MC	.equ	14
bytecode_INTVAR_MN	.equ	15
bytecode_INTVAR_N	.equ	16
bytecode_INTVAR_NX	.equ	17
bytecode_INTVAR_NY	.equ	18
bytecode_INTVAR_O	.equ	19
bytecode_INTVAR_P	.equ	20
bytecode_INTVAR_Q	.equ	21
bytecode_INTVAR_S	.equ	22
bytecode_INTVAR_T	.equ	23
bytecode_INTVAR_U	.equ	24
bytecode_INTVAR_V	.equ	25
bytecode_INTVAR_W	.equ	26
bytecode_INTVAR_Y	.equ	27
bytecode_INTVAR_Z	.equ	28
bytecode_INTVAR_ZZ	.equ	29
bytecode_FLTVAR_A	.equ	30
bytecode_FLTVAR_X	.equ	31
bytecode_FLTVAR_Z1	.equ	32
bytecode_FLTVAR_Z2	.equ	33
bytecode_STRVAR_A	.equ	34
bytecode_STRVAR_I	.equ	35
bytecode_INTARR_A	.equ	36
bytecode_INTARR_B	.equ	37
bytecode_INTARR_C	.equ	38
bytecode_INTARR_D	.equ	39
bytecode_INTARR_E	.equ	40
bytecode_INTARR_F	.equ	41
bytecode_INTARR_G	.equ	42
bytecode_INTARR_H	.equ	43
bytecode_INTARR_I	.equ	44
bytecode_INTARR_K	.equ	45
bytecode_INTARR_N	.equ	46
bytecode_INTARR_T	.equ	47
bytecode_INTARR_U	.equ	48
bytecode_INTARR_V	.equ	49
bytecode_INTARR_W	.equ	50
bytecode_INTARR_W2	.equ	51
bytecode_INTARR_X	.equ	52
bytecode_INTARR_Y	.equ	53
bytecode_FLTARR_P	.equ	54

symtbl

	.word	INTVAR_B
	.word	INTVAR_C
	.word	INTVAR_D
	.word	INTVAR_E
	.word	INTVAR_F
	.word	INTVAR_G
	.word	INTVAR_G1
	.word	INTVAR_G2
	.word	INTVAR_I
	.word	INTVAR_J
	.word	INTVAR_L
	.word	INTVAR_LC
	.word	INTVAR_LV
	.word	INTVAR_M
	.word	INTVAR_MC
	.word	INTVAR_MN
	.word	INTVAR_N
	.word	INTVAR_NX
	.word	INTVAR_NY
	.word	INTVAR_O
	.word	INTVAR_P
	.word	INTVAR_Q
	.word	INTVAR_S
	.word	INTVAR_T
	.word	INTVAR_U
	.word	INTVAR_V
	.word	INTVAR_W
	.word	INTVAR_Y
	.word	INTVAR_Z
	.word	INTVAR_ZZ
	.word	FLTVAR_A
	.word	FLTVAR_X
	.word	FLTVAR_Z1
	.word	FLTVAR_Z2
	.word	STRVAR_A
	.word	STRVAR_I
	.word	INTARR_A
	.word	INTARR_B
	.word	INTARR_C
	.word	INTARR_D
	.word	INTARR_E
	.word	INTARR_F
	.word	INTARR_G
	.word	INTARR_H
	.word	INTARR_I
	.word	INTARR_K
	.word	INTARR_N
	.word	INTARR_T
	.word	INTARR_U
	.word	INTARR_V
	.word	INTARR_W
	.word	INTARR_W2
	.word	INTARR_X
	.word	INTARR_Y
	.word	FLTARR_P


; block started by symbol
bss

; Numeric Variables
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_G1	.block	3
INTVAR_G2	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_L	.block	3
INTVAR_LC	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_MC	.block	3
INTVAR_MN	.block	3
INTVAR_N	.block	3
INTVAR_NX	.block	3
INTVAR_NY	.block	3
INTVAR_O	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_S	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_W	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
INTVAR_ZZ	.block	3
FLTVAR_A	.block	5
FLTVAR_X	.block	5
FLTVAR_Z1	.block	5
FLTVAR_Z2	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_I	.block	3
; Numeric Arrays
INTARR_A	.block	4	; dims=1
INTARR_B	.block	4	; dims=1
INTARR_C	.block	4	; dims=1
INTARR_D	.block	6	; dims=2
INTARR_E	.block	4	; dims=0
INTARR_F	.block	4	; dims=1
INTARR_G	.block	4	; dims=1
INTARR_H	.block	4	; dims=1
INTARR_I	.block	4	; dims=1
INTARR_K	.block	4	; dims=1
INTARR_N	.block	4	; dims=1
INTARR_T	.block	4	; dims=1
INTARR_U	.block	4	; dims=1
INTARR_V	.block	4	; dims=1
INTARR_W	.block	4	; dims=1
INTARR_W2	.block	4	; dims=1
INTARR_X	.block	4	; dims=1
INTARR_Y	.block	4	; dims=1
FLTARR_P	.block	6	; dims=2
; String Arrays

; block ended by symbol
bes
	.end

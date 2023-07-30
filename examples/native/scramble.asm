; Assembly for scramble.bas
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
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_1

	; CLS

	jsr	cls

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

	; CLEAR 9096

	jsr	clear

	; GOSUB 83

	ldx	#LINE_83
	jsr	gosub_ix

	; GOTO 77

	ldx	#LINE_77
	jsr	goto_ix

LINE_2

	; FOR C=P+N TO E STEP R

	ldx	#INTVAR_P
	ldd	#INTVAR_N
	jsr	add_ir1_ix_id

	ldx	#INTVAR_C
	jsr	for_ix_ir1

	ldx	#INTVAR_E
	jsr	to_ip_ix

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; ON K(PEEK(C)) GOTO 6

	ldx	#INTVAR_C
	jsr	peek_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_6

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_3

	; P-=Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	sub_ix_ix_ir1

	; H-=1

	ldx	#INTVAR_H
	jsr	dec_ix_ix

	; RETURN

	jsr	return

LINE_4

	; P+=Q

	ldx	#INTVAR_Q
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	add_ix_ix_ir1

	; H+=1

	ldx	#INTVAR_H
	jsr	inc_ix_ix

	; RETURN

	jsr	return

LINE_5

	; X=H

	ldd	#INTVAR_X
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; A=109

	ldx	#INTVAR_A
	ldab	#109
	jsr	ld_ix_pb

	; N=1

	ldx	#INTVAR_N
	jsr	one_ix

	; U=P+N

	ldx	#INTVAR_P
	ldd	#INTVAR_N
	jsr	add_ir1_ix_id

	ldx	#INTVAR_U
	jsr	ld_ix_ir1

	; I=0

	ldx	#INTVAR_I
	jsr	clr_ix

	; RETURN

	jsr	return

LINE_6

	; U(M)=C

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrref1_ir1_ix

	ldx	#INTVAR_C
	jsr	ld_ir1_ix

	jsr	ld_ip_ir1

	; M(M)=1

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_M
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; SOUND 240,1

	ldab	#240
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; C=E

	ldd	#INTVAR_C
	ldx	#INTVAR_E
	jsr	ld_id_ix

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_7

	; X=H

	ldd	#INTVAR_X
	ldx	#INTVAR_H
	jsr	ld_id_ix

	; S=1

	ldx	#INTVAR_S
	jsr	one_ix

	; A=106

	ldx	#INTVAR_A
	ldab	#106
	jsr	ld_ix_pb

	; N=33

	ldx	#INTVAR_N
	ldab	#33
	jsr	ld_ix_pb

	; U=P+N

	ldx	#INTVAR_P
	ldd	#INTVAR_N
	jsr	add_ir1_ix_id

	ldx	#INTVAR_U
	jsr	ld_ix_ir1

	; I=1

	ldx	#INTVAR_I
	jsr	one_ix

	; RETURN

	jsr	return

LINE_8

	; U(M)-=33

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrref1_ir1_ix

	ldab	#33
	jsr	sub_ip_ip_pb

	; ON K(PEEK(U(M))) GOTO 32,32,10,11

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrval1_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	4
	.word	LINE_32, LINE_32, LINE_10, LINE_11

	; POKE U(M),J

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_U
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_J
	jsr	poke_ir1_ix

	; RETURN

	jsr	return

LINE_9

	; FOR S=S TO S+11

	ldd	#INTVAR_S
	ldx	#INTVAR_S
	jsr	for_id_ix

	ldx	#INTVAR_S
	ldab	#11
	jsr	add_ir1_ix_pb

	jsr	to_ip_ir1

	; L=PEEK(U)

	ldx	#INTVAR_U
	jsr	peek_ir1_ix

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; GOSUB 98

	ldx	#LINE_98
	jsr	gosub_ix

	; X+=I

	ldx	#INTVAR_I
	jsr	ld_ir1_ix

	ldx	#INTVAR_X
	jsr	add_ix_ix_ir1

	; ON K(L) GOTO 34,35,36,35,33

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	5
	.word	LINE_34, LINE_35, LINE_36, LINE_35, LINE_33

	; POKE U,V

	ldd	#INTVAR_U
	ldx	#INTVAR_V
	jsr	poke_id_ix

	; U+=N

	ldx	#INTVAR_N
	jsr	ld_ir1_ix

	ldx	#INTVAR_U
	jsr	add_ix_ix_ir1

	; NEXT

	jsr	next

	; S-=1

	ldx	#INTVAR_S
	jsr	dec_ix_ix

	; U-=1

	ldx	#INTVAR_U
	jsr	dec_ix_ix

	; NEXT

	jsr	next

	; GOTO 17

	ldx	#LINE_17
	jsr	goto_ix

LINE_10

	; GOSUB 39

	ldx	#LINE_39
	jsr	gosub_ix

	; GOSUB 12

	ldx	#LINE_12
	jsr	gosub_ix

	; IF LV<1 THEN

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_11
	jsr	jmpeq_ir1_ix

	; Y=5

	ldx	#INTVAR_Y
	ldab	#5
	jsr	ld_ix_pb

	; Z=132

	ldx	#INTVAR_Z
	ldab	#132
	jsr	ld_ix_pb

	; FU=-1

	ldx	#INTVAR_FU
	jsr	true_ix

LINE_11

	; M(M)=RND(2)+1

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_M
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	irnd_ir1_pb

	jsr	inc_ir1_ir1

	jsr	ld_ip_ir1

	; RETURN

	jsr	return

LINE_12

	; LV=(LV>0) AND LV

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_LV
	jsr	ldlt_ir1_ir1_ix

	ldx	#INTVAR_LV
	jsr	and_ir1_ir1_ix

	ldx	#INTVAR_LV
	jsr	ld_ix_ir1

	; S$=STR$(LV)

	ldx	#INTVAR_LV
	jsr	str_sr1_ix

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; PRINT @29, S$;

	ldab	#29
	jsr	prat_pb

	ldx	#STRVAR_S
	jsr	pr_sx

	; FOR T=B+29 TO LEN(S$)+B+28

	ldx	#INTVAR_B
	ldab	#29
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_T
	jsr	for_ix_ir1

	ldx	#STRVAR_S
	jsr	len_ir1_sx

	ldx	#INTVAR_B
	jsr	add_ir1_ir1_ix

	ldab	#28
	jsr	add_ir1_ir1_pb

	jsr	to_ip_ir1

	; POKE T,PEEK(T)-F

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#INTVAR_F
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_13

	; FU+=1

	ldx	#INTVAR_FU
	jsr	inc_ix_ix

	; S$=STR$(FU)

	ldx	#INTVAR_FU
	jsr	str_sr1_ix

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; PRINT @23, S$;

	ldab	#23
	jsr	prat_pb

	ldx	#STRVAR_S
	jsr	pr_sx

	; FOR T=B+23 TO LEN(S$)+B+22

	ldx	#INTVAR_B
	ldab	#23
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_T
	jsr	for_ix_ir1

	ldx	#STRVAR_S
	jsr	len_ir1_sx

	ldx	#INTVAR_B
	jsr	add_ir1_ir1_ix

	ldab	#22
	jsr	add_ir1_ir1_pb

	jsr	to_ip_ir1

	; POKE T,PEEK(T)-F

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#INTVAR_F
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_14

	; FOR Y=1 TO 3

	ldx	#INTVAR_Y
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; FOR Z=ZZ TO 132

	ldd	#INTVAR_Z
	ldx	#INTVAR_ZZ
	jsr	for_id_ix

	ldab	#132
	jsr	to_ip_pb

	; FOR Z2=1 TO Z3

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldx	#FLTVAR_Z3
	jsr	to_ip_ix

	; NEXT

	jsr	next

	; GOSUB 183

	ldx	#LINE_183
	jsr	gosub_ix

	; ON Z2+1 GOSUB 96,3,4,7,5

	ldx	#INTVAR_Z2
	jsr	inc_ir1_ix

	jsr	ongosub_ir1_is
	.byte	5
	.word	LINE_96, LINE_3, LINE_4, LINE_7, LINE_5

	; PRINT @F, A$;MID$(B$,Z,32);MID$(C$,Z,32);

	ldx	#INTVAR_F
	jsr	prat_ix

	ldx	#STRVAR_A
	jsr	pr_sx

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_C
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

LINE_15

	; PRINT MID$(D$,Z,32);MID$(E$,Z,32);MID$(F$,Z,32);MID$(G$,Z,32);MID$(H$,Z,32);MID$(I$,Z,32);MID$(J$,Z,32);

	ldx	#STRVAR_D
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_F
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_G
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_J
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

LINE_16

	; ON K(PEEK(P)) GOSUB 30,30,30,4,13

	ldx	#INTVAR_P
	jsr	peek_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongosub_ir1_is
	.byte	5
	.word	LINE_30, LINE_30, LINE_30, LINE_4, LINE_13

	; GOSUB 97

	ldx	#LINE_97
	jsr	gosub_ix

	; FOR M=1 TO 3

	ldx	#INTVAR_M
	jsr	forone_ix

	ldab	#3
	jsr	to_ip_pb

	; ON M(M) GOSUB 8,2,95

	ldx	#INTVAR_M
	jsr	ld_ir1_ix

	ldx	#INTARR_M
	jsr	arrval1_ir1_ix

	jsr	ongosub_ir1_is
	.byte	3
	.word	LINE_8, LINE_2, LINE_95

	; NEXT

	jsr	next

	; ON S GOTO 9,9,9,9,9,9,9,9,9,9,9,9,9

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	13
	.word	LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9, LINE_9

	; NEXT

	jsr	next

LINE_17

	; ZZ=Q

	ldd	#INTVAR_ZZ
	ldx	#INTVAR_Q
	jsr	ld_id_ix

	; IF FU=0 THEN

	ldx	#INTVAR_FU
	jsr	ld_ir1_ix

	ldx	#LINE_18
	jsr	jmpne_ir1_ix

	; S$="RETURN TO BASE"

	jsr	ld_sr1_ss
	.text	14, "RETURN TO BASE"

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; C=50

	ldx	#INTVAR_C
	ldab	#50
	jsr	ld_ix_pb

	; GOSUB 53

	ldx	#LINE_53
	jsr	gosub_ix

	; Y=4

	ldx	#INTVAR_Y
	ldab	#4
	jsr	ld_ix_pb

	; SOUND 80,20

	ldab	#80
	jsr	ld_ir1_pb

	ldab	#20
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

LINE_18

	; GOSUB 37

	ldx	#LINE_37
	jsr	gosub_ix

	; FU=0

	ldx	#INTVAR_FU
	jsr	clr_ix

	; POKE B+24,48

	ldx	#INTVAR_B
	ldab	#24
	jsr	add_ir1_ix_pb

	ldab	#48
	jsr	poke_ir1_pb

	; POKE B+23,Q

	ldx	#INTVAR_B
	ldab	#23
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_Q
	jsr	poke_ir1_ix

	; NEXT

	jsr	next

	; IF Y=4 THEN

	ldx	#INTVAR_Y
	jsr	ld_ir1_ix

	ldab	#4
	jsr	ldeq_ir1_ir1_pb

	ldx	#LINE_19
	jsr	jmpeq_ir1_ix

	; GOSUB 55

	ldx	#LINE_55
	jsr	gosub_ix

	; WHEN LV>0 GOTO 79

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_LV
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_79
	jsr	jmpne_ir1_ix

LINE_19

	; POKE P,62

	ldx	#INTVAR_P
	ldab	#62
	jsr	poke_ix_pb

	; S$="PLAY AGAIN (Y/N)?"

	jsr	ld_sr1_ss
	.text	17, "PLAY AGAIN (Y/N)?"

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; C=32

	ldx	#INTVAR_C
	ldab	#32
	jsr	ld_ix_pb

	; GOSUB 53

	ldx	#LINE_53
	jsr	gosub_ix

LINE_20

	; I$=INKEY$

	ldx	#STRVAR_I
	jsr	inkey_sx

	; WHEN I$="" GOTO 20

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_20
	jsr	jmpne_ir1_ix

	; WHEN I$="Y" GOTO 77

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_77
	jsr	jmpne_ir1_ix

	; ON 1-(I$<>"N") GOTO 94,20

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	jsr	ldne_ir1_sr1_ss
	.text	1, "N"

	ldab	#1
	jsr	rsub_ir1_ir1_pb

	jsr	ongoto_ir1_is
	.byte	2
	.word	LINE_94, LINE_20

LINE_21

	; B$=LEFT$(B$,S+Z+2)+CHR$(Q)+MID$(B$,S+Z+4)

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_B
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_22

	; C$=LEFT$(C$,S+Z+2)+CHR$(Q)+MID$(C$,S+Z+4)

	ldx	#STRVAR_C
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_C
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_23

	; D$=LEFT$(D$,S+Z+2)+CHR$(Q)+MID$(D$,S+Z+4)

	ldx	#STRVAR_D
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_24

	; E$=LEFT$(E$,S+Z+2)+CHR$(Q)+MID$(E$,S+Z+4)

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_25

	; F$=LEFT$(F$,S+Z+2)+CHR$(Q)+MID$(F$,S+Z+4)

	ldx	#STRVAR_F
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_26

	; G$=LEFT$(G$,S+Z+2)+CHR$(Q)+MID$(G$,S+Z+4)

	ldx	#STRVAR_G
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_G
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_27

	; H$=LEFT$(H$,S+Z+2)+CHR$(Q)+MID$(H$,S+Z+4)

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_28

	; I$=LEFT$(I$,S+Z+2)+CHR$(Q)+MID$(I$,S+Z+4)

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_I
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_29

	; J$=LEFT$(J$,S+Z+2)+CHR$(Q)+MID$(J$,S+Z+4)

	ldx	#STRVAR_J
	jsr	ld_sr1_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir2_ix_id

	ldab	#2
	jsr	add_ir2_ir2_pb

	jsr	left_sr1_sr1_ir2

	jsr	strinit_sr1_sr1

	ldx	#INTVAR_Q
	jsr	chr_sr2_ix

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_J
	jsr	ld_sr2_sx

	ldx	#INTVAR_S
	ldd	#INTVAR_Z
	jsr	add_ir3_ix_id

	ldab	#4
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_30

	; Z4=PEEK(P)

	ldx	#INTVAR_P
	jsr	peek_ir1_ix

	ldx	#INTVAR_Z4
	jsr	ld_ix_ir1

	; Z2=PEEK(P-1)

	ldx	#INTVAR_P
	jsr	dec_ir1_ix

	jsr	peek_ir1_ir1

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; POKE P,62

	ldx	#INTVAR_P
	ldab	#62
	jsr	poke_ix_pb

	; FU=-1

	ldx	#INTVAR_FU
	jsr	true_ix

	; LV-=1

	ldx	#INTVAR_LV
	jsr	dec_ix_ix

	; GOSUB 12

	ldx	#LINE_12
	jsr	gosub_ix

LINE_31

	; SOUND 1,9

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#9
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 10,9

	ldab	#10
	jsr	ld_ir1_pb

	ldab	#9
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE P,Z4

	ldd	#INTVAR_P
	ldx	#INTVAR_Z4
	jsr	poke_id_ix

	; POKE P-1,Z2

	ldx	#INTVAR_P
	jsr	dec_ir1_ix

	ldx	#INTVAR_Z2
	jsr	poke_ir1_ix

	; P=B+67

	ldx	#INTVAR_B
	ldab	#67
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

	; H=-2

	ldx	#INTVAR_H
	ldab	#-2
	jsr	ld_ix_nb

	; WHEN LV>0 GOTO 99

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#INTVAR_LV
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_99
	jsr	jmpne_ir1_ix

	; Y=6

	ldx	#INTVAR_Y
	ldab	#6
	jsr	ld_ix_pb

	; Z=132

	ldx	#INTVAR_Z
	ldab	#132
	jsr	ld_ix_pb

LINE_32

	; RETURN

	jsr	return

LINE_33

	; POKE U,17

	ldx	#INTVAR_U
	ldab	#17
	jsr	poke_ix_pb

	; SOUND D,1

	ldx	#INTVAR_D
	jsr	ld_ir1_ix

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOSUB 13

	ldx	#LINE_13
	jsr	gosub_ix

	; GOSUB 38

	ldx	#LINE_38
	jsr	gosub_ix

	; S=99

	ldx	#INTVAR_S
	ldab	#99
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 17

	ldx	#LINE_17
	jsr	goto_ix

LINE_34

	; POKE U,159

	ldx	#INTVAR_U
	ldab	#159
	jsr	poke_ix_pb

	; ON X GOSUB 21,22,23,24,25,26,27,28,29

	ldx	#INTVAR_X
	jsr	ld_ir1_ix

	jsr	ongosub_ir1_is
	.byte	9
	.word	LINE_21, LINE_22, LINE_23, LINE_24, LINE_25, LINE_26, LINE_27, LINE_28, LINE_29

	; POKE U,V

	ldd	#INTVAR_U
	ldx	#INTVAR_V
	jsr	poke_id_ix

	; S=99

	ldx	#INTVAR_S
	ldab	#99
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 17

	ldx	#LINE_17
	jsr	goto_ix

LINE_35

	; POKE U,128

	ldx	#INTVAR_U
	ldab	#128
	jsr	poke_ix_pb

	; S=99

	ldx	#INTVAR_S
	ldab	#99
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 17

	ldx	#LINE_17
	jsr	goto_ix

LINE_36

	; POKE U,126

	ldx	#INTVAR_U
	ldab	#126
	jsr	poke_ix_pb

	; S=99

	ldx	#INTVAR_S
	ldab	#99
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; GOTO 17

	ldx	#LINE_17
	jsr	goto_ix

LINE_37

	; SC+=FU*10

	ldx	#INTVAR_FU
	jsr	ld_ir1_ix

	ldab	#10
	jsr	mul_ir1_ir1_pb

	ldx	#INTVAR_SC
	jsr	add_ix_ix_ir1

LINE_38

	; SC+=10

	ldx	#INTVAR_SC
	ldab	#10
	jsr	add_ix_ix_pb

	; S$=STR$(SC)

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; PRINT @0, S$;

	ldab	#0
	jsr	prat_pb

	ldx	#STRVAR_S
	jsr	pr_sx

	; FOR T=B TO LEN(S$)+B-1

	ldd	#INTVAR_T
	ldx	#INTVAR_B
	jsr	for_id_ix

	ldx	#STRVAR_S
	jsr	len_ir1_sx

	ldx	#INTVAR_B
	jsr	add_ir1_ir1_ix

	jsr	dec_ir1_ir1

	jsr	to_ip_ir1

	; POKE T,PEEK(T)-F

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#INTVAR_F
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_39

	; POKE P,42

	ldx	#INTVAR_P
	ldab	#42
	jsr	poke_ix_pb

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; LV-=1

	ldx	#INTVAR_LV
	jsr	dec_ix_ix

	; RETURN

	jsr	return

LINE_40

	; ON T GOTO 42,43,44,45,46,47,48,49

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	jsr	ongoto_ir1_is
	.byte	8
	.word	LINE_42, LINE_43, LINE_44, LINE_45, LINE_46, LINE_47, LINE_48, LINE_49

LINE_41

	; B$=B$+B$(Z)

	ldx	#STRVAR_B
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_42

	; C$=C$+B$(Z)

	ldx	#STRVAR_C
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_43

	; D$=D$+B$(Z)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_44

	; E$=E$+B$(Z)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_45

	; F$=F$+B$(Z)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_46

	; G$=G$+B$(Z)

	ldx	#STRVAR_G
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_47

	; H$=H$+B$(Z)

	ldx	#STRVAR_H
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_48

	; I$=I$+B$(Z)

	ldx	#STRVAR_I
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_49

	; J$=J$+B$(Z)

	ldx	#STRVAR_J
	jsr	strinit_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldx	#STRARR_B
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_50

	; FOR T=8 TO 0 STEP -1

	ldx	#INTVAR_T
	ldab	#8
	jsr	for_ix_pb

	ldab	#0
	jsr	to_ip_pb

	ldab	#-1
	jsr	ld_ir1_nb

	jsr	step_ip_ir1

	; Z=2

	ldx	#INTVAR_Z
	ldab	#2
	jsr	ld_ix_pb

	; IF H>T THEN

	ldx	#INTVAR_T
	ldd	#INTVAR_H
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_51
	jsr	jmpeq_ir1_ix

	; Z=1

	ldx	#INTVAR_Z
	jsr	one_ix

LINE_51

	; IF H=T THEN

	ldx	#INTVAR_H
	ldd	#INTVAR_T
	jsr	ldeq_ir1_ix_id

	ldx	#LINE_52
	jsr	jmpeq_ir1_ix

	; Z=L(RND(4))

	ldab	#4
	jsr	irnd_ir1_pb

	ldx	#INTARR_L
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z
	jsr	ld_ix_ir1

LINE_52

	; GOSUB 40

	ldx	#LINE_40
	jsr	gosub_ix

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_53

	; PRINT @C, S$;

	ldx	#INTVAR_C
	jsr	prat_ix

	ldx	#STRVAR_S
	jsr	pr_sx

	; FOR T=B+C TO LEN(S$)+B+C-1

	ldx	#INTVAR_B
	ldd	#INTVAR_C
	jsr	add_ir1_ix_id

	ldx	#INTVAR_T
	jsr	for_ix_ir1

	ldx	#STRVAR_S
	jsr	len_ir1_sx

	ldx	#INTVAR_B
	jsr	add_ir1_ir1_ix

	ldx	#INTVAR_C
	jsr	add_ir1_ir1_ix

	jsr	dec_ir1_ir1

	jsr	to_ip_ir1

	; POKE T,PEEK(T)-F

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#INTVAR_F
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_54

	; M$=S$

	ldd	#STRVAR_M
	ldx	#STRVAR_S
	jsr	ld_sd_sx

	; GOSUB 30

	ldx	#LINE_30
	jsr	gosub_ix

	; S$=M$

	ldd	#STRVAR_S
	ldx	#STRVAR_M
	jsr	ld_sd_sx

	; LV+=Z=132

	ldx	#INTVAR_Z
	jsr	ld_ir1_ix

	ldab	#132
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_LV
	jsr	add_ix_ix_ir1

	; RETURN

	jsr	return

LINE_55

	; FOR T=1 TO 10

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND 185,1

	ldab	#185
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; Y=((LV<9) AND -LV)+25

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	ldab	#9
	jsr	ldlt_ir1_ir1_pb

	ldx	#INTVAR_LV
	jsr	neg_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldab	#25
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_Y
	jsr	ld_ix_ir1

	; GOSUB 73

	ldx	#LINE_73
	jsr	gosub_ix

LINE_56

	; S$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; S$=S$+LEFT$(A$,32)

	ldx	#STRVAR_S
	jsr	strinit_sr1_sx

	ldx	#STRVAR_A
	jsr	ld_sr2_sx

	ldab	#32
	jsr	left_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; M$="_"+LEFT$(A$,24)

	jsr	strinit_sr1_ss
	.text	1, "_"

	ldx	#STRVAR_A
	jsr	ld_sr2_sx

	ldab	#24
	jsr	left_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; FOR T=1 TO 96

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#96
	jsr	to_ip_pb

	; S$=S$+MID$(M$,RND(Y),1)

	ldx	#STRVAR_S
	jsr	strinit_sr1_sx

	ldx	#STRVAR_M
	jsr	ld_sr2_sx

	ldx	#INTVAR_Y
	jsr	rnd_fr3_ix

	ldab	#1
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

LINE_57

	; S$=S$+A$

	ldx	#STRVAR_S
	jsr	strinit_sr1_sx

	ldx	#STRVAR_A
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; B$=B$+MID$(S$,RND(32)+32)

	ldx	#STRVAR_B
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	irnd_ir3_pb

	ldab	#32
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; C$=C$+MID$(S$,RND(32)+32)

	ldx	#STRVAR_C
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	irnd_ir3_pb

	ldab	#32
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; D$=D$+MID$(S$,RND(32)+32)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	irnd_ir3_pb

	ldab	#32
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=E$+MID$(S$,RND(32)+32)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	irnd_ir3_pb

	ldab	#32
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

LINE_58

	; F$=F$+MID$(S$,RND(32)+32)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	irnd_ir3_pb

	ldab	#32
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; G$=G$+MID$(S$,RND(32)+32)

	ldx	#STRVAR_G
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	irnd_ir3_pb

	ldab	#32
	jsr	add_ir3_ir3_pb

	jsr	mid_sr2_sr2_ir3

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; H$=H$+MID$(S$,32)

	ldx	#STRVAR_H
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	mid_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; I$=I$+MID$(S$,32)

	ldx	#STRVAR_I
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	mid_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; J$=J$+MID$(S$,32)

	ldx	#STRVAR_J
	jsr	strinit_sr1_sx

	ldx	#STRVAR_S
	jsr	ld_sr2_sx

	ldab	#32
	jsr	mid_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

LINE_59

	; FOR Z=1 TO 132

	ldx	#INTVAR_Z
	jsr	forone_ix

	ldab	#132
	jsr	to_ip_pb

	; PRINT @F, MID$(S$,Z,32);MID$(S$,Z,32);MID$(S$,Z,32);MID$(B$,Z,32);MID$(C$,Z,32);MID$(D$,Z,32);

	ldx	#INTVAR_F
	jsr	prat_ix

	ldx	#STRVAR_S
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_S
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_S
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_C
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_D
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

LINE_60

	; PRINT MID$(E$,Z,32);MID$(F$,Z,32);MID$(G$,Z,32);MID$(H$,Z,32);MID$(I$,Z,32);MID$(J$,Z,32);

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_F
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_G
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	ldx	#STRVAR_J
	jsr	ld_sr1_sx

	ldx	#INTVAR_Z
	jsr	ld_ir2_ix

	ldab	#32
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; ON K(PEEK(P)) GOSUB 39,54,39,4

	ldx	#INTVAR_P
	jsr	peek_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongosub_ir1_is
	.byte	4
	.word	LINE_39, LINE_54, LINE_39, LINE_4

LINE_61

	; GOSUB 97

	ldx	#LINE_97
	jsr	gosub_ix

	; GOSUB 96

	ldx	#LINE_96
	jsr	gosub_ix

	; GOSUB 96

	ldx	#LINE_96
	jsr	gosub_ix

	; GOSUB 96

	ldx	#LINE_96
	jsr	gosub_ix

	; GOSUB 183

	ldx	#LINE_183
	jsr	gosub_ix

	; ON Z2 GOSUB 3,4

	ldx	#INTVAR_Z2
	jsr	ld_ir1_ix

	jsr	ongosub_ir1_is
	.byte	2
	.word	LINE_3, LINE_4

	; NEXT

	jsr	next

	; LV+=1

	ldx	#INTVAR_LV
	jsr	inc_ix_ix

	; GOTO 12

	ldx	#LINE_12
	jsr	goto_ix

LINE_62

	; MN+=1

	ldx	#INTVAR_MN
	jsr	inc_ix_ix

	; PRINT @O, "GET READY FOR MISSION";STR$(MN);" \r";

	ldx	#INTVAR_O
	jsr	prat_ix

	jsr	pr_ss
	.text	21, "GET READY FOR MISSION"

	ldx	#INTVAR_MN
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

	; GOSUB 68

	ldx	#LINE_68
	jsr	gosub_ix

	; GOSUB 69

	ldx	#LINE_69
	jsr	gosub_ix

LINE_63

	; FOR M=1 TO 100

	ldx	#INTVAR_M
	jsr	forone_ix

	ldab	#100
	jsr	to_ip_pb

	; H=INT(RND(4)+5)

	ldab	#4
	jsr	irnd_ir1_pb

	ldab	#5
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; S=INT(SHIFT(6-RND(12),-1))

	ldab	#12
	jsr	irnd_ir1_pb

	ldab	#6
	jsr	rsub_ir1_ir1_pb

	jsr	hlf_fr1_ir1

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; R=RND(25)

	ldab	#25
	jsr	irnd_ir1_pb

	ldx	#INTVAR_R
	jsr	ld_ix_ir1

	; FOR G=1 TO R

	ldx	#INTVAR_G
	jsr	forone_ix

	ldx	#INTVAR_R
	jsr	to_ip_ix

	; IF SHIFT(R,-1)<>G THEN

	ldx	#INTVAR_R
	jsr	hlf_fr1_ix

	ldx	#INTVAR_G
	jsr	ldne_ir1_fr1_ix

	ldx	#LINE_64
	jsr	jmpeq_ir1_ix

	; H+=S

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#INTVAR_H
	jsr	add_ix_ix_ir1

	; IF H>=0 THEN

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_64
	jsr	jmpeq_ir1_ix

	; WHEN H<9 GOTO 66

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#9
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_66
	jsr	jmpne_ir1_ix

LINE_64

	; S=IDIV(-S,RND(2))

	ldx	#INTVAR_S
	jsr	neg_ir1_ix

	ldab	#2
	jsr	irnd_ir2_pb

	jsr	idiv_ir1_ir1_ir2

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; H+=S

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#INTVAR_H
	jsr	add_ix_ix_ir1

	; IF H>=0 THEN

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#0
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_65
	jsr	jmpeq_ir1_ix

	; WHEN H<9 GOTO 66

	ldx	#INTVAR_H
	jsr	ld_ir1_ix

	ldab	#9
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_66
	jsr	jmpne_ir1_ix

LINE_65

	; H=RND(4)+5

	ldab	#4
	jsr	irnd_ir1_pb

	ldab	#5
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

LINE_66

	; GOSUB 50

	ldx	#LINE_50
	jsr	gosub_ix

	; M+=1

	ldx	#INTVAR_M
	jsr	inc_ix_ix

	; PRINT @V, STR$(101-M);" ";

	ldx	#INTVAR_V
	jsr	prat_ix

	ldab	#101
	ldx	#INTVAR_M
	jsr	sub_ir1_pb_ix

	jsr	str_sr1_ir1

	jsr	pr_sr1

	jsr	pr_ss
	.text	1, " "

	; IF M>99 THEN

	ldab	#99
	jsr	ld_ir1_pb

	ldx	#INTVAR_M
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_67
	jsr	jmpeq_ir1_ix

	; G=R

	ldd	#INTVAR_G
	ldx	#INTVAR_R
	jsr	ld_id_ix

LINE_67

	; NEXT

	jsr	next

	; M-=1

	ldx	#INTVAR_M
	jsr	dec_ix_ix

	; NEXT

	jsr	next

	; R=66

	ldx	#INTVAR_R
	ldab	#66
	jsr	ld_ix_pb

	; GOTO 71

	ldx	#LINE_71
	jsr	goto_ix

LINE_68

	; B$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; C$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; D$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; G$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; H$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; I$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; J$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_69

	; B$=LEFT$(A$,32)+B$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_B
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; C$=LEFT$(A$,32)+C$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_C
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; D$=LEFT$(A$,32)+D$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_D
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=LEFT$(A$,32)+E$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_E
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=LEFT$(A$,32)+F$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_F
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

LINE_70

	; G$=LEFT$(A$,32)+G$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_G
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; H$=LEFT$(A$,32)+H$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_H
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; I$=LEFT$(A$,32)+I$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_I
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; J$=LEFT$(A$,32)+J$

	ldx	#STRVAR_A
	jsr	ld_sr1_sx

	ldab	#32
	jsr	left_sr1_sr1_pb

	jsr	strinit_sr1_sr1

	ldx	#STRVAR_J
	jsr	strcat_sr1_sr1_sx

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_71

	; B$=B$+MID$(B$,32,32)

	ldx	#STRVAR_B
	jsr	strinit_sr1_sx

	ldx	#STRVAR_B
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; C$=C$+MID$(C$,32,32)

	ldx	#STRVAR_C
	jsr	strinit_sr1_sx

	ldx	#STRVAR_C
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; D$=D$+MID$(D$,32,32)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldx	#STRVAR_D
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=E$+MID$(E$,32,32)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldx	#STRVAR_E
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=F$+MID$(F$,32,32)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldx	#STRVAR_F
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

LINE_72

	; G$=G$+MID$(G$,32,32)

	ldx	#STRVAR_G
	jsr	strinit_sr1_sx

	ldx	#STRVAR_G
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; H$=H$+MID$(H$,32,32)

	ldx	#STRVAR_H
	jsr	strinit_sr1_sx

	ldx	#STRVAR_H
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; I$=I$+MID$(I$,32,32)

	ldx	#STRVAR_I
	jsr	strinit_sr1_sx

	ldx	#STRVAR_I
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; J$=J$+MID$(J$,32,32)

	ldx	#STRVAR_J
	jsr	strinit_sr1_sx

	ldx	#STRVAR_J
	jsr	ld_sr2_sx

	ldab	#32
	jsr	ld_ir3_pb

	ldab	#32
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_73

	; B$=RIGHT$(B$,32)

	ldx	#STRVAR_B
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

	; C$=RIGHT$(C$,32)

	ldx	#STRVAR_C
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

	; D$=RIGHT$(D$,32)

	ldx	#STRVAR_D
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=RIGHT$(E$,32)

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=RIGHT$(F$,32)

	ldx	#STRVAR_F
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

LINE_74

	; G$=RIGHT$(G$,32)

	ldx	#STRVAR_G
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_G
	jsr	ld_sx_sr1

	; H$=RIGHT$(H$,32)

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; I$=RIGHT$(I$,32)

	ldx	#STRVAR_I
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_I
	jsr	ld_sx_sr1

	; J$=RIGHT$(J$,32)

	ldx	#STRVAR_J
	jsr	ld_sr1_sx

	ldab	#32
	jsr	right_sr1_sr1_pb

	ldx	#STRVAR_J
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_75

	; FOR T=16384 TO 16447

	ldx	#INTVAR_T
	ldd	#16384
	jsr	for_ix_pw

	ldd	#16447
	jsr	to_ip_pw

	; POKE T,Q

	ldd	#INTVAR_T
	ldx	#INTVAR_Q
	jsr	poke_id_ix

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_76

	; FOR T=16832 TO 16895

	ldx	#INTVAR_T
	ldd	#16832
	jsr	for_ix_pw

	ldd	#16895
	jsr	to_ip_pw

	; POKE T,128

	ldx	#INTVAR_T
	ldab	#128
	jsr	poke_ix_pb

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_77

	; CLS

	jsr	cls

	; IF SC>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_78
	jsr	jmpeq_ir1_ix

	; HS=SC

	ldd	#INTVAR_HS
	ldx	#INTVAR_SC
	jsr	ld_id_ix

LINE_78

	; SC=-10

	ldx	#INTVAR_SC
	ldab	#-10
	jsr	ld_ix_nb

	; LV=5

	ldx	#INTVAR_LV
	ldab	#5
	jsr	ld_ix_pb

	; FU=-1

	ldx	#INTVAR_FU
	jsr	true_ix

	; MN=0

	ldx	#INTVAR_MN
	jsr	clr_ix

	; P=B+259

	ldx	#INTVAR_B
	ldd	#259
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_P
	jsr	ld_ix_ir1

LINE_79

	; S$=""

	jsr	ld_sr1_ss
	.text	0, ""

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; GOSUB 62

	ldx	#LINE_62
	jsr	gosub_ix

	; GOSUB 75

	ldx	#LINE_75
	jsr	gosub_ix

	; GOSUB 76

	ldx	#LINE_76
	jsr	gosub_ix

	; S$="        HI         FUEL     >   "

	jsr	ld_sr1_ss
	.text	32, "        HI         FUEL     >   "

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; C=0

	ldx	#INTVAR_C
	jsr	clr_ix

	; GOSUB 53

	ldx	#LINE_53
	jsr	gosub_ix

LINE_80

	; S$=STR$(HS)

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; PRINT @10, S$;

	ldab	#10
	jsr	prat_pb

	ldx	#STRVAR_S
	jsr	pr_sx

	; FOR T=B+10 TO LEN(S$)+B+9

	ldx	#INTVAR_B
	ldab	#10
	jsr	add_ir1_ix_pb

	ldx	#INTVAR_T
	jsr	for_ix_ir1

	ldx	#STRVAR_S
	jsr	len_ir1_sx

	ldx	#INTVAR_B
	jsr	add_ir1_ir1_ix

	ldab	#9
	jsr	add_ir1_ir1_pb

	jsr	to_ip_ir1

	; POKE T,PEEK(T)-F

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#INTVAR_F
	jsr	sub_ir1_ir1_ix

	ldx	#INTVAR_T
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

LINE_81

	; GOSUB 12

	ldx	#LINE_12
	jsr	gosub_ix

	; GOSUB 38

	ldx	#LINE_38
	jsr	gosub_ix

	; GOSUB 13

	ldx	#LINE_13
	jsr	gosub_ix

LINE_82

	; S=0

	ldx	#INTVAR_S
	jsr	clr_ix

	; H=INT(SHIFT(P-B-3,-5)-4)

	ldx	#INTVAR_P
	ldd	#INTVAR_B
	jsr	sub_ir1_ix_id

	ldab	#3
	jsr	sub_ir1_ir1_pb

	ldab	#-5
	jsr	shift_fr1_ir1_nb

	ldab	#4
	jsr	sub_fr1_fr1_pb

	ldx	#INTVAR_H
	jsr	ld_ix_ir1

	; ZZ=1

	ldx	#INTVAR_ZZ
	jsr	one_ix

	; FOR T=1 TO 4

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#4
	jsr	to_ip_pb

	; M(T)=2

	ldx	#INTVAR_T
	jsr	ld_ir1_ix

	ldx	#INTARR_M
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; NEXT

	jsr	next

	; GOTO 14

	ldx	#LINE_14
	jsr	goto_ix

LINE_83

	; DIM A$,B$,C$,D$,E$,F$,G$,H$,I$,J$,B$(4),K(128),M(4),U(4),Z

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrdim1_ir1_sx

	ldab	#128
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrdim1_ir1_ix

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_M
	jsr	arrdim1_ir1_ix

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_U
	jsr	arrdim1_ir1_ix

	; POKE 49151,64

	ldab	#64
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; PRINT "   MC-SCRAMBLE BY JIM GERRIE\r";

	jsr	pr_ss
	.text	29, "   MC-SCRAMBLE BY JIM GERRIE\r"

LINE_84

	; FOR Z=16384 TO 16415

	ldx	#INTVAR_Z
	ldd	#16384
	jsr	for_ix_pw

	ldd	#16415
	jsr	to_ip_pw

	; POKE Z,PEEK(Z)-64

	ldx	#INTVAR_Z
	jsr	peek_ir1_ix

	ldab	#64
	jsr	sub_ir1_ir1_pb

	ldx	#INTVAR_Z
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

	; PRINT "FLY YOUR AIRCRAFT '>' OVER THE\r";

	jsr	pr_ss
	.text	31, "FLY YOUR AIRCRAFT '>' OVER THE\r"

	; PRINT "MOUNTAINOUS TERRAIN SHOOTING\r";

	jsr	pr_ss
	.text	29, "MOUNTAINOUS TERRAIN SHOOTING\r"

LINE_85

	; PRINT "AT ANTI-AIRCRAFT EMPLACEMENTS\r";

	jsr	pr_ss
	.text	30, "AT ANTI-AIRCRAFT EMPLACEMENTS\r"

	; PRINT "'A' THAT WILL SHOOT BACK AT YOU\r";

	jsr	pr_ss
	.text	32, "'A' THAT WILL SHOOT BACK AT YOU\r"

	; PRINT "UNLESS YOU DESTROY THEM WITH\r";

	jsr	pr_ss
	.text	29, "UNLESS YOU DESTROY THEM WITH\r"

LINE_86

	; PRINT "YOUR GUNS 'SPACE BAR.'  USE\r";

	jsr	pr_ss
	.text	28, "YOUR GUNS 'SPACE BAR.'  USE\r"

	; PRINT "GUNS OR BOMBS 'B' TO ATTACK THE\r";

	jsr	pr_ss
	.text	32, "GUNS OR BOMBS 'B' TO ATTACK THE\r"

	; PRINT "FUEL EMPLACEMENTS 'Q' OF THE\r";

	jsr	pr_ss
	.text	29, "FUEL EMPLACEMENTS 'Q' OF THE\r"

LINE_87

	; PRINT "ENEMY. YOU MUST ATTACK ENOUGH\r";

	jsr	pr_ss
	.text	30, "ENEMY. YOU MUST ATTACK ENOUGH\r"

	; PRINT "FUEL EMPLACEMENTS OR YOU WILL\r";

	jsr	pr_ss
	.text	30, "FUEL EMPLACEMENTS OR YOU WILL\r"

	; PRINT "BE RE-CALLED FROM YOUR MISSION.\r";

	jsr	pr_ss
	.text	32, "BE RE-CALLED FROM YOUR MISSION.\r"

LINE_88

	; PRINT "NAVIGATE THE FINAL ONSLAUGHT,\r";

	jsr	pr_ss
	.text	30, "NAVIGATE THE FINAL ONSLAUGHT,\r"

	; PRINT "AND YOU WILL BE ASSIGNED NEW\r";

	jsr	pr_ss
	.text	29, "AND YOU WILL BE ASSIGNED NEW\r"

	; PRINT "MISSIONS. 'A'=UP & 'Z'=DOWN.\r";

	jsr	pr_ss
	.text	29, "MISSIONS. 'A'=UP & 'Z'=DOWN.\r"

LINE_89

	; DIM M,T,P,D,S,A,U,B,Y,C,X,R,E,G,H,I,J,L,N,Q,V,L(4),O,F,S$,ZZ,LV,FU,MN

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrdim1_ir1_ix

LINE_90

	; Z3=RND(-TIMER)

	jsr	timer_ir1

	jsr	neg_ir1_ir1

	jsr	rnd_fr1_ir1

	ldx	#FLTVAR_Z3
	jsr	ld_fx_fr1

	; B$(1)=" "

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, " "

	jsr	ld_sp_sr1

	; B$(2)="€"

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "\x80"

	jsr	ld_sp_sr1

	; B$(3)="A"

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "A"

	jsr	ld_sp_sr1

	; B$(4)="Q"

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#STRARR_B
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	1, "Q"

	jsr	ld_sp_sr1

	; Q=32

	ldx	#INTVAR_Q
	ldab	#32
	jsr	ld_ix_pb

LINE_91

	; D=126

	ldx	#INTVAR_D
	ldab	#126
	jsr	ld_ix_pb

	; F=64

	ldx	#INTVAR_F
	ldab	#64
	jsr	ld_ix_pb

	; E=16832

	ldx	#INTVAR_E
	ldd	#16832
	jsr	ld_ix_pw

	; J=94

	ldx	#INTVAR_J
	ldab	#94
	jsr	ld_ix_pb

	; B=16384

	ldx	#INTVAR_B
	ldd	#16384
	jsr	ld_ix_pw

	; HS=0

	ldx	#INTVAR_HS
	jsr	clr_ix

	; V=96

	ldx	#INTVAR_V
	ldab	#96
	jsr	ld_ix_pb

	; FOR T=1 TO 96

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#96
	jsr	to_ip_pb

	; A$=A$+" "

	ldx	#STRVAR_A
	jsr	strinit_sr1_sx

	jsr	strcat_sr1_sr1_ss
	.text	1, " "

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

	; O=256

	ldx	#INTVAR_O
	ldd	#256
	jsr	ld_ix_pw

	; K(65)=1

	ldab	#65
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(32)=4

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; K(90)=2

	ldab	#90
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

	; K(66)=3

	ldab	#66
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(128)=2

	ldab	#128
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#2
	jsr	ld_ip_pb

LINE_92

	; K(126)=3

	ldab	#126
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; K(95)=1

	ldab	#95
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	jsr	one_ip

	; K(81)=5

	ldab	#81
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrref1_ir1_ix

	ldab	#5
	jsr	ld_ip_pb

	; L(1)=3

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; L(2)=3

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; L(3)=3

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#3
	jsr	ld_ip_pb

	; L(4)=4

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTARR_L
	jsr	arrref1_ir1_ix

	ldab	#4
	jsr	ld_ip_pb

	; S$="LEVEL OF PLAY (1-3)?"

	jsr	ld_sr1_ss
	.text	20, "LEVEL OF PLAY (1-3)?"

	ldx	#STRVAR_S
	jsr	ld_sx_sr1

	; C=486

	ldx	#INTVAR_C
	ldd	#486
	jsr	ld_ix_pw

	; GOSUB 53

	ldx	#LINE_53
	jsr	gosub_ix

LINE_93

	; GOTO 100

	ldx	#LINE_100
	jsr	goto_ix

LINE_94

	; END

	jsr	progend

LINE_95

	; FOR C=P TO E STEP R

	ldd	#INTVAR_C
	ldx	#INTVAR_P
	jsr	for_id_ix

	ldx	#INTVAR_E
	jsr	to_ip_ix

	ldx	#INTVAR_R
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; ON K(PEEK(C)) GOTO 6

	ldx	#INTVAR_C
	jsr	peek_ir1_ix

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	jsr	ongoto_ir1_is
	.byte	1
	.word	LINE_6

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_96

	; FOR Z2=1 TO SHIFT(Z3,-2)

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldx	#FLTVAR_Z3
	jsr	ld_fr1_fx

	ldab	#-2
	jsr	shift_fr1_fr1_nb

	jsr	to_ip_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_97

	; POKE P,D

	ldd	#INTVAR_P
	ldx	#INTVAR_D
	jsr	poke_id_ix

	; POKE P-1,99

	ldx	#INTVAR_P
	jsr	dec_ir1_ix

	ldab	#99
	jsr	poke_ir1_pb

	; FOR Z2=1 TO 80

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#80
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; POKE P-1,96

	ldx	#INTVAR_P
	jsr	dec_ir1_ix

	ldab	#96
	jsr	poke_ir1_pb

	; RETURN

	jsr	return

LINE_98

	; POKE U,106

	ldx	#INTVAR_U
	ldab	#106
	jsr	poke_ix_pb

	; Z2=PEEK(9) AND 128

	ldab	#9
	jsr	peek_ir1_pb

	ldab	#128
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; POKE 49151,Z2

	ldd	#49151
	ldx	#INTVAR_Z2
	jsr	poke_pw_ix

	; POKE U,A

	ldd	#INTVAR_U
	ldx	#INTVAR_A
	jsr	poke_id_ix

	; FOR Z2=1 TO 25

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldab	#25
	jsr	to_ip_pb

	; NEXT

	jsr	next

	; Z2=PEEK(9) AND 128

	ldab	#9
	jsr	peek_ir1_pb

	ldab	#128
	jsr	and_ir1_ir1_pb

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; POKE 49151,Z2

	ldd	#49151
	ldx	#INTVAR_Z2
	jsr	poke_pw_ix

	; RETURN

	jsr	return

LINE_99

	; FOR Z4=1 TO 10

	ldx	#INTVAR_Z4
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; POKE P,D

	ldd	#INTVAR_P
	ldx	#INTVAR_D
	jsr	poke_id_ix

	; POKE P-1,99

	ldx	#INTVAR_P
	jsr	dec_ir1_ix

	ldab	#99
	jsr	poke_ir1_pb

	; FOR Z2=1 TO 500

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldd	#500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; GOSUB 97

	ldx	#LINE_97
	jsr	gosub_ix

	; POKE P,96

	ldx	#INTVAR_P
	ldab	#96
	jsr	poke_ix_pb

	; POKE P-1,96

	ldx	#INTVAR_P
	jsr	dec_ir1_ix

	ldab	#96
	jsr	poke_ir1_pb

	; FOR Z2=1 TO 500

	ldx	#INTVAR_Z2
	jsr	forone_ix

	ldd	#500
	jsr	to_ip_pw

	; NEXT

	jsr	next

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_100

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 100

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_100
	jsr	jmpne_ir1_ix

LINE_110

	; WHEN (VAL(M$)<0) OR (VAL(M$)>3) GOTO 100

	ldx	#STRVAR_M
	jsr	val_fr1_sx

	ldab	#0
	jsr	ldlt_ir1_fr1_pb

	ldab	#3
	jsr	ld_ir2_pb

	ldx	#STRVAR_M
	jsr	val_fr3_sx

	jsr	ldlt_ir2_ir2_fr3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_100
	jsr	jmpne_ir1_ix

LINE_120

	; Z3=650-(VAL(M$)*100)

	ldx	#STRVAR_M
	jsr	val_fr1_sx

	ldab	#100
	jsr	mul_fr1_fr1_pb

	ldd	#650
	jsr	rsub_fr1_fr1_pw

	ldx	#FLTVAR_Z3
	jsr	ld_fx_fr1

	; POKE 49151,0

	ldab	#0
	jsr	ld_ir1_pb

	ldd	#49151
	jsr	poke_pw_ir1

	; RETURN

	jsr	return

LINE_183

	; IF PEEK(2) AND NOT PEEK(16946) AND 1 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16946
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_185
	jsr	jmpeq_ir1_ix

	; Z2=K(65)

	ldab	#65
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_185

	; IF PEEK(2) AND NOT PEEK(16947) AND 8 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16947
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#8
	jsr	and_ir1_ir1_pb

	ldx	#LINE_186
	jsr	jmpeq_ir1_ix

	; Z2=K(90)

	ldab	#90
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_186

	; IF PEEK(2) AND NOT PEEK(16947) AND 1 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16947
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#1
	jsr	and_ir1_ir1_pb

	ldx	#LINE_187
	jsr	jmpeq_ir1_ix

	; Z2=K(66)

	ldab	#66
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_187

	; IF PEEK(2) AND NOT PEEK(16952) AND 8 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16952
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#8
	jsr	and_ir1_ir1_pb

	ldx	#LINE_188
	jsr	jmpeq_ir1_ix

	; Z2=K(32)

	ldab	#32
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_188

	; IF PEEK(2) AND NOT PEEK(16946) AND 4 THEN

	ldab	#2
	jsr	peek_ir1_pb

	ldd	#16946
	jsr	peek_ir2_pw

	jsr	com_ir2_ir2

	jsr	and_ir1_ir1_ir2

	ldab	#4
	jsr	and_ir1_ir1_pb

	ldx	#LINE_189
	jsr	jmpeq_ir1_ix

	; Z2=K(81)

	ldab	#81
	jsr	ld_ir1_pb

	ldx	#INTARR_K
	jsr	arrval1_ir1_ix

	ldx	#INTVAR_Z2
	jsr	ld_ix_ir1

	; RETURN

	jsr	return

LINE_189

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

	.module	mddivflti
; divide X by Y and mask off fraction
;   ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)
;                     scratch in  (5,x 6,x 7,x 8,x 9,x)
;          Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv
;   EXIT   INT(X/Y) in (0,x 1,x 2,x)
;          uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4
idivflt
	ldaa	#8*3
	bsr	divmod
	tst	tmp4
	bmi	_neg
	ldd	8,x
	comb
	coma
	std	1,x
	ldab	7,x
	comb
	stab	0,x
	rts
_neg
	ldd	3,x
	bne	_copy
	ldd	1,x
	bne	_copy
	ldab	,x
	bne	_copy
	ldd	8,x
	addd	#1
	std	1,x
	ldab	7,x
	adcb	#0
	stab	0,x
	rts
_copy
	ldd	8,x
	std	1,x
	ldab	7,x
	stab	0,x
	rts

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

	.module	mdshrflt
; divide X by 2^ACCB for positive ACCB
;   ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)
;   EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)
;          uses tmp1
shrint
	clr	3,x
	clr	4,x
shrflt
	cmpb	#8
	blo	_shrbit
	stab	tmp1
	ldd	2,x
	std	3,x
	ldd	0,x
	std	1,x
	clrb
	lsla
	sbcb	#0
	stab	0,x
	ldab	tmp1
	subb	#8
	bne	shrflt
	rts
_shrbit
	asr	0,x
	ror	1,x
	ror	2,x
	ror	3,x
	ror	4,x
	decb
	bne	_shrbit
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

add_ir1_ir1_ix			; numCalls = 6
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 6
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 4
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

add_ir1_ix_pb			; numCalls = 7
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

add_ir2_ir2_pb			; numCalls = 9
	.module	modadd_ir2_ir2_pb
	clra
	addd	r2+1
	std	r2+1
	ldab	#0
	adcb	r2
	stab	r2
	rts

add_ir2_ix_id			; numCalls = 9
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

add_ir3_ir3_pb			; numCalls = 15
	.module	modadd_ir3_ir3_pb
	clra
	addd	r3+1
	std	r3+1
	ldab	#0
	adcb	r3
	stab	r3
	rts

add_ir3_ix_id			; numCalls = 9
	.module	modadd_ir3_ix_id
	std	tmp1
	ldab	0,x
	stab	r3
	ldd	1,x
	ldx	tmp1
	addd	1,x
	std	r3+1
	ldab	r3
	adcb	0,x
	stab	r3
	rts

add_ix_ix_ir1			; numCalls = 7
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 1
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 6
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

and_ir1_ir1_ix			; numCalls = 1
	.module	modand_ir1_ir1_ix
	ldd	1,x
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	0,x
	andb	r1
	stab	r1
	rts

and_ir1_ir1_pb			; numCalls = 7
	.module	modand_ir1_ir1_pb
	andb	r1+2
	clra
	std	r1+1
	staa	r1
	rts

arrdim1_ir1_ix			; numCalls = 4
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

arrdim1_ir1_sx			; numCalls = 1
	.module	modarrdim1_ir1_sx
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

arrref1_ir1_ix			; numCalls = 17
	.module	modarrref1_ir1_ix
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrref1_ir1_sx			; numCalls = 4
	.module	modarrref1_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_ix			; numCalls = 15
	.module	modarrval1_ir1_ix
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

arrval1_ir2_sx			; numCalls = 9
	.module	modarrval1_ir2_sx
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

chr_sr2_ix			; numCalls = 9
	.module	modchr_sr2_ix
	ldab	2,x
	stab	r2+2
	ldd	#$0100+(charpage>>8)
	std	r2
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

clr_ix			; numCalls = 6
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 2
	.module	modcls
	jmp	R_CLS

com_ir2_ir2			; numCalls = 5
	.module	modcom_ir2_ir2
	com	r2+2
	com	r2+1
	com	r2
	rts

dec_ir1_ir1			; numCalls = 2
	.module	moddec_ir1_ir1
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 6
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ix_ix			; numCalls = 6
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
	stab	0,x
	rts

for_id_ix			; numCalls = 4
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

for_ix_ir1			; numCalls = 5
	.module	modfor_ix_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

for_ix_pb			; numCalls = 1
	.module	modfor_ix_pb
	stx	letptr
	clra
	staa	0,x
	std	1,x
	rts

for_ix_pw			; numCalls = 3
	.module	modfor_ix_pw
	stx	letptr
	clr	0,x
	std	1,x
	rts

forone_ix			; numCalls = 16
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 33
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 10
	.module	modgoto_ix
	ins
	ins
	jmp	,x

hlf_fr1_ir1			; numCalls = 1
	.module	modhlf_fr1_ir1
	asr	r1
	ror	r1+1
	ror	r1+2
	ldd	#0
	rora
	std	r1+3
	rts

hlf_fr1_ix			; numCalls = 1
	.module	modhlf_fr1_ix
	ldab	0,x
	asrb
	stab	r1
	ldd	1,x
	rora
	rorb
	std	r1+1
	ldd	#0
	rora
	std	r1+3
	rts

idiv_ir1_ir1_ir2			; numCalls = 1
	.module	modidiv_ir1_ir1_ir2
	ldab	r2
	stab	0+argv
	ldd	r2+1
	std	1+argv
	ldd	#0
	std	3+argv
	std	r1+3
	ldx	#r1
	jmp	idivflt

inc_ir1_ir1			; numCalls = 1
	.module	modinc_ir1_ir1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
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

inc_ix_ix			; numCalls = 5
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

irnd_ir1_pb			; numCalls = 6
	.module	modirnd_ir1_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r1+1
	ldab	tmp1
	stab	r1
	rts

irnd_ir2_pb			; numCalls = 1
	.module	modirnd_ir2_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r2+1
	ldab	tmp1
	stab	r2
	rts

irnd_ir3_pb			; numCalls = 6
	.module	modirnd_ir3_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r3+1
	ldab	tmp1
	stab	r3
	rts

jmpeq_ir1_ix			; numCalls = 14
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

jmpne_ir1_ix			; numCalls = 9
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

ld_fr1_fx			; numCalls = 1
	.module	modld_fr1_fx
	ldd	3,x
	std	r1+3
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_fx_fr1			; numCalls = 2
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_id_ix			; numCalls = 6
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

ld_ip_ir1			; numCalls = 2
	.module	modld_ip_ir1
	ldx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ip_pb			; numCalls = 11
	.module	modld_ip_pb
	ldx	letptr
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ir1_ix			; numCalls = 33
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

ld_ir1_pb			; numCalls = 40
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 30
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 8
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_pb			; numCalls = 9
	.module	modld_ir3_pb
	stab	r3+2
	ldd	#0
	std	r3
	rts

ld_ix_ir1			; numCalls = 23
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_nb			; numCalls = 2
	.module	modld_ix_nb
	stab	2,x
	ldd	#-1
	std	0,x
	rts

ld_ix_pb			; numCalls = 22
	.module	modld_ix_pb
	stab	2,x
	ldd	#0
	std	0,x
	rts

ld_ix_pw			; numCalls = 4
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sd_sx			; numCalls = 2
	.module	modld_sd_sx
	std	tmp1
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	tmp1
	jmp	strprm

ld_sp_sr1			; numCalls = 4
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 19
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 52
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sr2_sx			; numCalls = 30
	.module	modld_sr2_sx
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_sx_sr1			; numCalls = 78
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir1_ix_id			; numCalls = 1
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

ldeq_ir1_sr1_ss			; numCalls = 3
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

ldge_ir1_ir1_pb			; numCalls = 2
	.module	modldge_ir1_ir1_pb
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

ldlt_ir1_ir1_ix			; numCalls = 4
	.module	modldlt_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	ldab	r1
	sbcb	0,x
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_pb			; numCalls = 4
	.module	modldlt_ir1_ir1_pb
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

ldlt_ir1_ix_id			; numCalls = 2
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

ldlt_ir2_ir2_fr3			; numCalls = 1
	.module	modldlt_ir2_ir2_fr3
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

ldne_ir1_fr1_ix			; numCalls = 1
	.module	modldne_ir1_fr1_ix
	ldd	r1+3
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

ldne_ir1_sr1_ss			; numCalls = 1
	.module	modldne_ir1_sr1_ss
	ldab	r1
	stab	tmp1+1
	ldd	r1+1
	std	tmp2
	jsr	streqs
	jsr	getne
	std	r1+1
	stab	r1
	rts

left_sr1_sr1_ir2			; numCalls = 9
	.module	modleft_sr1_sr1_ir2
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

left_sr1_sr1_pb			; numCalls = 9
	.module	modleft_sr1_sr1_pb
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

left_sr2_sr2_pb			; numCalls = 2
	.module	modleft_sr2_sr2_pb
	tstb
	beq	_zero
	cmpb	r2
	bhs	_rts
	stab	r2
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

len_ir1_sx			; numCalls = 5
	.module	modlen_ir1_sx
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

midT_sr1_sr1_pb			; numCalls = 21
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

midT_sr2_sr2_pb			; numCalls = 10
	.module	modmidT_sr2_sr2_pb
	clra
	std	tmp1
	ldd	5+r2
	beq	_ok
	bmi	_fc_error
	bne	_zero
_ok
	ldab	5+r2+2
	beq	_fc_error
	ldab	r2
	subb	5+r2+2
	blo	_zero
	incb
	stab	r2
	ldd	5+r2+1
	subd	#1
	addd	r2+1
	std	r2+1
	ldab	tmp1+1
	cmpb	r2
	bhs	_rts
	stab	r2
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

mid_sr2_sr2_ir3			; numCalls = 15
	.module	modmid_sr2_sr2_ir3
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

mid_sr2_sr2_pb			; numCalls = 3
	.module	modmid_sr2_sr2_pb
	tstb
	beq	_fc_error
	ldaa	r2
	inca
	sba
	bls	_zero
	staa	r2
	clra
	addd	r2+1
	subd	#1
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

mul_fr1_fr1_pb			; numCalls = 1
	.module	modmul_fr1_fr1_pb
	ldx	#r1
	jsr	mulbytf
	jmp	tmp2xf

mul_ir1_ir1_pb			; numCalls = 1
	.module	modmul_ir1_ir1_pb
	ldx	#r1
	jsr	mulbyti
	jmp	tmp2xi

neg_ir1_ir1			; numCalls = 1
	.module	modneg_ir1_ir1
	ldx	#r1
	jmp	negxi

neg_ir1_ix			; numCalls = 1
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

neg_ir2_ix			; numCalls = 1
	.module	modneg_ir2_ix
	ldd	#0
	subd	1,x
	std	r2+1
	ldab	#0
	sbcb	0,x
	stab	r2
	rts

next			; numCalls = 39
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

one_ip			; numCalls = 3
	.module	modone_ip
	ldx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

one_ix			; numCalls = 6
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

ongosub_ir1_is			; numCalls = 6
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

ongoto_ir1_is			; numCalls = 7
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

or_ir1_ir1_ir2			; numCalls = 1
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_ir1			; numCalls = 2
	.module	modpeek_ir1_ir1
	ldx	r1+1
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_ix			; numCalls = 12
	.module	modpeek_ir1_ix
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pb			; numCalls = 7
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_pw			; numCalls = 5
	.module	modpeek_ir2_pw
	std	tmp1
	ldx	tmp1
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

poke_id_ix			; numCalls = 7
	.module	modpoke_id_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ir1_ix			; numCalls = 3
	.module	modpoke_ir1_ix
	ldab	2,x
	ldx	r1+1
	stab	,x
	rts

poke_ir1_pb			; numCalls = 5
	.module	modpoke_ir1_pb
	ldx	r1+1
	stab	,x
	rts

poke_ix_ir1			; numCalls = 6
	.module	modpoke_ix_ir1
	ldab	r1+2
	ldx	1,x
	stab	,x
	rts

poke_ix_pb			; numCalls = 10
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

poke_pw_ir1			; numCalls = 4
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

poke_pw_ix			; numCalls = 2
	.module	modpoke_pw_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	stab	,x
	rts

pr_sr1			; numCalls = 23
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

pr_sx			; numCalls = 6
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ix			; numCalls = 5
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

return			; numCalls = 52
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

right_sr1_sr1_pb			; numCalls = 9
	.module	modright_sr1_sr1_pb
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

rnd_fr3_ix			; numCalls = 1
	.module	modrnd_fr3_ix
	ldab	0,x
	stab	tmp1+1
	bmi	_neg
	ldd	1,x
	std	tmp2
	beq	_flt
	jsr	irnd
	std	r3+1
	ldab	tmp1
	stab	r3
	ldd	#0
	std	r3+3
	rts
_neg
	ldd	1,x
	std	tmp2
_flt
	jsr	rnd
	std	r3+3
	ldd	#0
	std	r3+1
	stab	r3
	rts

rsub_fr1_fr1_pw			; numCalls = 1
	.module	modrsub_fr1_fr1_pw
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

rsub_ir1_ir1_pb			; numCalls = 2
	.module	modrsub_ir1_ir1_pb
	clra
	subd	r1+1
	std	r1+1
	ldab	#0
	sbcb	r1
	stab	r1
	rts

shift_fr1_fr1_nb			; numCalls = 1
	.module	modshift_fr1_fr1_nb
	ldx	#r1
	negb
	jmp	shrflt

shift_fr1_ir1_nb			; numCalls = 1
	.module	modshift_fr1_ir1_nb
	ldx	#r1
	negb
	jmp	shrint

sound_ir1_ir2			; numCalls = 7
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 3
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

str_sr1_ir1			; numCalls = 1
	.module	modstr_sr1_ir1
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

str_sr1_ix			; numCalls = 5
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

strcat_sr1_sr1_sr2			; numCalls = 48
	.module	modstrcat_sr1_sr1_sr2
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

strcat_sr1_sr1_ss			; numCalls = 1
	.module	modstrcat_sr1_sr1_ss
	ldx	r1+1
	ldab	r1
	abx
	stx	strfree
	tsx
	ldx	,x
	ldab	,x
	addb	r1
	bcs	_lserror
	stab	r1
	ldab	,x
	inx
	jsr	strcat
	pulx
	ldab	,x
	abx
	jmp	1,x
_lserror
	ldab	#LS_ERROR
	jmp	error

strcat_sr1_sr1_sx			; numCalls = 10
	.module	modstrcat_sr1_sr1_sx
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

strinit_sr1_sr1			; numCalls = 18
	.module	modstrinit_sr1_sr1
	ldab	r1
	stab	r1
	ldx	r1+1
	jsr	strtmp
	std	r1+1
	rts

strinit_sr1_ss			; numCalls = 1
	.module	modstrinit_sr1_ss
	tsx
	ldx	,x
	ldab	,x
	stab	r1
	inx
	jsr	strtmp
	std	r1+1
	pulx
	ldab	,x
	abx
	jmp	1,x

strinit_sr1_sx			; numCalls = 31
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

sub_fr1_fr1_pb			; numCalls = 1
	.module	modsub_fr1_fr1_pb
	stab	tmp1
	ldd	r1+1
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

sub_ip_ip_pb			; numCalls = 1
	.module	modsub_ip_ip_pb
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

sub_ir1_ir1_ix			; numCalls = 5
	.module	modsub_ir1_ir1_ix
	ldd	r1+1
	subd	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir1_ir1_pb			; numCalls = 2
	.module	modsub_ir1_ir1_pb
	stab	tmp1
	ldd	r1+1
	subb	tmp1
	sbca	#0
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

sub_ir1_ix_id			; numCalls = 1
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

sub_ix_ix_ir1			; numCalls = 1
	.module	modsub_ix_ix_ir1
	ldd	1,x
	subd	r1+1
	std	1,x
	ldab	0,x
	sbcb	r1
	stab	0,x
	rts

timer_ir1			; numCalls = 1
	.module	modtimer_ir1
	ldd	DP_TIMR
	std	r1+1
	clrb
	stab	r1
	rts

to_ip_ir1			; numCalls = 7
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
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

to_ip_pb			; numCalls = 13
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

to_ip_pw			; numCalls = 5
	.module	modto_ip_pw
	std	r1+1
	ldd	#0
	stab	r1
	std	r1+3
	ldab	#11
	jmp	to

true_ix			; numCalls = 3
	.module	modtrue_ix
	ldd	#-1
	stab	0,x
	std	1,x
	rts

val_fr1_sx			; numCalls = 2
	.module	modval_fr1_sx
	jsr	strval
	ldab	tmp1+1
	stab	r1
	ldd	tmp2
	std	r1+1
	ldd	tmp3
	std	r1+3
	rts

val_fr3_sx			; numCalls = 1
	.module	modval_fr3_sx
	jsr	strval
	ldab	tmp1+1
	stab	r3
	ldd	tmp2
	std	r3+1
	ldd	tmp3
	std	r3+3
	rts

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_B	.block	3
INTVAR_C	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_FU	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_HS	.block	3
INTVAR_I	.block	3
INTVAR_J	.block	3
INTVAR_L	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_MN	.block	3
INTVAR_N	.block	3
INTVAR_O	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_R	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
INTVAR_Z	.block	3
INTVAR_Z2	.block	3
INTVAR_Z4	.block	3
INTVAR_ZZ	.block	3
FLTVAR_Z3	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
STRVAR_C	.block	3
STRVAR_D	.block	3
STRVAR_E	.block	3
STRVAR_F	.block	3
STRVAR_G	.block	3
STRVAR_H	.block	3
STRVAR_I	.block	3
STRVAR_J	.block	3
STRVAR_M	.block	3
STRVAR_S	.block	3
; Numeric Arrays
INTARR_K	.block	4	; dims=1
INTARR_L	.block	4	; dims=1
INTARR_M	.block	4	; dims=1
INTARR_U	.block	4	; dims=1
; String Arrays
STRARR_B	.block	4	; dims=1

; block ended by symbol
bes
	.end

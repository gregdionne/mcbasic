; Assembly for decoy.bas
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

	; CLEAR 5000

	jsr	clear

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

	; GOTO 970

	ldx	#LINE_970
	jsr	goto_ix

LINE_1

	; IF K>V THEN

	ldx	#INTVAR_V
	ldd	#INTVAR_K
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_2
	jsr	jmpeq_ir1_ix

	; PRINT @P, " ";

	ldx	#INTVAR_P
	jsr	prat_ix

	jsr	pr_ss
	.text	1, " "

	; PRINT @P+V, "   ";

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "   "

	; PRINT @P+R, "  ";

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	jsr	pr_ss
	.text	2, "  "

	; P+=(K=65)+(((K=87)-(K=83))*V)-(K=68)

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldab	#65
	jsr	ldeq_ir1_ir1_pb

	ldx	#INTVAR_K
	jsr	ld_ir2_ix

	ldab	#87
	jsr	ldeq_ir2_ir2_pb

	ldx	#INTVAR_K
	jsr	ld_ir3_ix

	ldab	#83
	jsr	ldeq_ir3_ir3_pb

	jsr	sub_ir2_ir2_ir3

	ldx	#INTVAR_V
	jsr	mul_ir2_ir2_ix

	jsr	add_ir1_ir1_ir2

	ldx	#INTVAR_K
	jsr	ld_ir2_ix

	ldab	#68
	jsr	ldeq_ir2_ir2_pb

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_P
	jsr	add_ix_ix_ir1

	; GOTO 23

	ldx	#LINE_23
	jsr	goto_ix

LINE_2

	; T=P+V+M+3

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldab	#3
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; FOR T=T TO T+D STEP 2

	ldd	#INTVAR_T
	ldx	#INTVAR_T
	jsr	for_id_ix

	ldx	#INTVAR_T
	ldd	#INTVAR_D
	jsr	add_ir1_ix_id

	jsr	to_ip_ir1

	ldab	#2
	jsr	ld_ir1_pb

	jsr	step_ip_ir1

	; WHEN PEEK(T)<V GOTO 4

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#INTVAR_V
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_4
	jsr	jmpne_ir1_ix

LINE_3

	; NEXT

	jsr	next

	; PRINT @P+V+3, "éåååååååååå";

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldab	#3
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	11, "\x8E\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C"

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @P+V+3, "           ";

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldab	#3
	jsr	add_ir1_ir1_pb

	jsr	prat_ir1

	jsr	pr_ss
	.text	11, "           "

	; GOTO 23

	ldx	#LINE_23
	jsr	goto_ix

LINE_4

	; T=M+511

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; NEXT

	jsr	next

	; PRINT @P, A$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_A
	jsr	pr_sx

	; PRINT @P+V, B$;

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @P+R, C$;

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; T=P+V+3

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldab	#3
	jsr	add_ir1_ir1_pb

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; PRINT @T, "éåååååååååå";

	ldx	#INTVAR_T
	jsr	prat_ix

	jsr	pr_ss
	.text	11, "\x8E\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C\x8C"

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; SOUND 86,3

	ldab	#86
	jsr	ld_ir1_pb

	ldab	#3
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @T, "            ";

	ldx	#INTVAR_T
	jsr	prat_ix

	jsr	pr_ss
	.text	12, "            "

LINE_5

	; PRINT @T-V, "            ";

	ldx	#INTVAR_T
	ldd	#INTVAR_V
	jsr	sub_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	12, "            "

	; PRINT @T+V, "            ";

	ldx	#INTVAR_T
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	12, "            "

	; L=1

	ldx	#INTVAR_L
	jsr	one_ix

	; SC+=100

	ldx	#INTVAR_SC
	ldab	#100
	jsr	add_ix_ix_pb

	; F+=1

	ldx	#INTVAR_F
	jsr	inc_ix_ix

	; IF F>7 THEN

	ldab	#7
	jsr	ld_ir1_pb

	ldx	#INTVAR_F
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_6
	jsr	jmpeq_ir1_ix

	; L=223

	ldx	#INTVAR_L
	ldab	#223
	jsr	ld_ix_pb

LINE_6

	; GOTO 23

	ldx	#LINE_23
	jsr	goto_ix

LINE_7

	; PRINT M$;

	ldx	#STRVAR_M
	jsr	pr_sx

	; L=POS+M-1

	jsr	pos_ir1

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	jsr	dec_ir1_ir1

	ldx	#INTVAR_L
	jsr	ld_ix_ir1

	; FOR T=L+1-LEN(M$) TO L

	ldx	#STRVAR_M
	jsr	len_ir1_sx

	ldx	#INTVAR_L
	jsr	rsub_ir1_ir1_ix

	jsr	inc_ir1_ir1

	ldx	#INTVAR_T
	jsr	for_ix_ir1

	ldx	#INTVAR_L
	jsr	to_ip_ix

	; POKE T,PEEK(T)-R

	ldx	#INTVAR_T
	jsr	peek_ir1_ix

	ldx	#FLTVAR_R
	jsr	sub_fr1_ir1_fx

	ldx	#INTVAR_T
	jsr	poke_ix_ir1

	; NEXT

	jsr	next

	; RETURN

	jsr	return

LINE_8

	; POKE S,U

	ldd	#INTVAR_S
	ldx	#INTVAR_U
	jsr	poke_id_ix

	; POKE M+511,N

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_N
	jsr	poke_ir1_ix

	; S=RND(30)+M+448

	ldab	#30
	jsr	irnd_ir1_pb

	ldx	#INTVAR_M
	jsr	add_ir1_ir1_ix

	ldd	#448
	jsr	add_ir1_ir1_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; A=-V

	ldx	#INTVAR_V
	jsr	neg_ir1_ix

	ldx	#INTVAR_A
	jsr	ld_ix_ir1

	; GOTO 24

	ldx	#LINE_24
	jsr	goto_ix

LINE_9

	; POKE S,U

	ldd	#INTVAR_S
	ldx	#INTVAR_U
	jsr	poke_id_ix

	; A=0

	ldx	#INTVAR_A
	jsr	clr_ix

	; S=M+511

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; POKE S,N

	ldd	#INTVAR_S
	ldx	#INTVAR_N
	jsr	poke_id_ix

	; GOTO 21

	ldx	#LINE_21
	jsr	goto_ix

LINE_20

	; FOR L=1 TO 224 STEP LV

	ldx	#INTVAR_L
	jsr	forone_ix

	ldab	#224
	jsr	to_ip_pb

	ldx	#INTVAR_LV
	jsr	ld_ir1_ix

	jsr	step_ip_ir1

	; PRINT @E-V, "\r";

	ldx	#INTVAR_E
	ldd	#INTVAR_V
	jsr	sub_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @E+U, "\r";

	ldx	#INTVAR_E
	ldd	#INTVAR_U
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	1, "\r"

	; PRINT @E, MID$(D$,L,V);

	ldx	#INTVAR_E
	jsr	prat_ix

	ldx	#STRVAR_D
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_V
	jsr	midT_sr1_sr1_ix

	jsr	pr_sr1

	; PRINT @E+V, MID$(E$,L,V);

	ldx	#INTVAR_E
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_V
	jsr	midT_sr1_sr1_ix

	jsr	pr_sr1

	; PRINT @E+R, MID$(F$,L,V);

	ldx	#INTVAR_E
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_F
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_V
	jsr	midT_sr1_sr1_ix

	jsr	pr_sr1

	; WHEN (M+R)>S GOTO 9

	ldx	#INTVAR_S
	jsr	ld_ir1_ix

	ldx	#INTVAR_M
	ldd	#FLTVAR_R
	jsr	add_fr2_ix_fd

	jsr	ldlt_ir1_ir1_fr2

	ldx	#LINE_9
	jsr	jmpne_ir1_ix

LINE_21

	; POKE S,U

	ldd	#INTVAR_S
	ldx	#INTVAR_U
	jsr	poke_id_ix

	; S+=A

	ldx	#INTVAR_A
	jsr	ld_ir1_ix

	ldx	#INTVAR_S
	jsr	add_ix_ix_ir1

	; POKE S,H

	ldd	#INTVAR_S
	ldx	#INTVAR_H
	jsr	poke_id_ix

	; T=P+M

	ldx	#INTVAR_P
	ldd	#INTVAR_M
	jsr	add_ir1_ix_id

	ldx	#INTVAR_T
	jsr	ld_ix_ir1

	; WHEN (PEEK(T)>G) OR (PEEK(T+1)>U) OR (PEEK(T+66)>U) GOTO 90

	ldx	#INTVAR_G
	jsr	ld_ir1_ix

	ldx	#INTVAR_T
	jsr	peek_ir2_ix

	jsr	ldlt_ir1_ir1_ir2

	ldx	#INTVAR_U
	jsr	ld_ir2_ix

	ldx	#INTVAR_T
	jsr	inc_ir3_ix

	jsr	peek_ir3_ir3

	jsr	ldlt_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	ldx	#INTVAR_U
	jsr	ld_ir2_ix

	ldx	#INTVAR_T
	ldab	#66
	jsr	add_ir3_ix_pb

	jsr	peek_ir3_ir3

	jsr	ldlt_ir2_ir2_ir3

	jsr	or_ir1_ir1_ir2

	ldx	#LINE_90
	jsr	jmpne_ir1_ix

LINE_22

	; K=PEEK(2) AND PEEK(Q)

	ldab	#2
	jsr	peek_ir1_pb

	ldx	#INTVAR_Q
	jsr	peek_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_K
	jsr	ld_ix_ir1

	; WHEN K GOTO 1

	ldx	#INTVAR_K
	jsr	ld_ir1_ix

	ldx	#LINE_1
	jsr	jmpne_ir1_ix

LINE_23

	; PRINT @P, A$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_A
	jsr	pr_sx

	; PRINT @P+V, B$;

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @P+R, C$;

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; E+=(E>V) AND (E<I) AND ((2-RND(3))*V)

	ldx	#INTVAR_V
	ldd	#INTVAR_E
	jsr	ldlt_ir1_ix_id

	ldx	#INTVAR_E
	ldd	#INTVAR_I
	jsr	ldlt_ir2_ix_id

	jsr	and_ir1_ir1_ir2

	ldab	#3
	jsr	irnd_ir2_pb

	ldab	#2
	jsr	rsub_ir2_ir2_pb

	ldx	#INTVAR_V
	jsr	mul_ir2_ir2_ix

	jsr	and_ir1_ir1_ir2

	ldx	#INTVAR_E
	jsr	add_ix_ix_ir1

	; E+=((E=I)-(E=V))*V

	ldx	#INTVAR_E
	ldd	#INTVAR_I
	jsr	ldeq_ir1_ix_id

	ldx	#INTVAR_E
	ldd	#INTVAR_V
	jsr	ldeq_ir2_ix_id

	jsr	sub_ir1_ir1_ir2

	ldx	#INTVAR_V
	jsr	mul_ir1_ir1_ix

	ldx	#INTVAR_E
	jsr	add_ix_ix_ir1

	; PRINT @480, MID$(H$,L,31);

	ldd	#480
	jsr	prat_pw

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldab	#31
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; WHEN RND(99)<D GOTO 8

	ldab	#99
	jsr	irnd_ir1_pb

	ldx	#INTVAR_D
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_8
	jsr	jmpne_ir1_ix

LINE_24

	; NEXT

	jsr	next

	; PRINT @0, "»¿¬¿¬¿¿¿»¬¿»¿»¬¿¬»¿»¿¬¿¿¬¿¿¬»»¿¬";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	32, "\xC8\xC0\xC2\xC0\xC2\xC0\xC0\xC0\xC8\xC2\xC0\xC8\xC0\xC8\xC2\xC0\xC2\xC8\xC0\xC8\xC0\xC2\xC0\xC0\xC2\xC0\xC0\xC2\xC8\xC8\xC0\xC2"

	; FOR T=1 TO 10

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#10
	jsr	to_ip_pb

	; SOUND 200,1

	ldab	#200
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

	; L=0

	ldx	#INTVAR_L
	jsr	clr_ix

	; SC+=224

	ldx	#INTVAR_SC
	ldab	#224
	jsr	add_ix_ix_pb

	; F=0

	ldx	#INTVAR_F
	jsr	clr_ix

	; LV+=1

	ldx	#INTVAR_LV
	jsr	inc_ix_ix

	; IF LV>4 THEN

	ldab	#4
	jsr	ld_ir1_pb

	ldx	#INTVAR_LV
	jsr	ldlt_ir1_ir1_ix

	ldx	#LINE_25
	jsr	jmpeq_ir1_ix

	; LV=4

	ldx	#INTVAR_LV
	ldab	#4
	jsr	ld_ix_pb

LINE_25

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_90

	; FOR T=1 TO 8

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#8
	jsr	to_ip_pb

	; POKE 49151,R

	ldd	#49151
	ldx	#FLTVAR_R
	jsr	poke_pw_ix

	; PRINT @P, A$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_A
	jsr	pr_sx

	; PRINT @P+V, B$;

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @P+R, C$;

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

LINE_100

	; PRINT @E, MID$(D$,L,V);

	ldx	#INTVAR_E
	jsr	prat_ix

	ldx	#STRVAR_D
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_V
	jsr	midT_sr1_sr1_ix

	jsr	pr_sr1

	; PRINT @E+V, MID$(E$,L,V);

	ldx	#INTVAR_E
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_E
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_V
	jsr	midT_sr1_sr1_ix

	jsr	pr_sr1

	; PRINT @E+R, MID$(F$,L,V);

	ldx	#INTVAR_E
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_F
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldx	#INTVAR_V
	jsr	midT_sr1_sr1_ix

	jsr	pr_sr1

LINE_110

	; PRINT @0, "»¿¬¿¬¿¿¿»¬¿»¿»¬¿¬»¿»¿¬¿¿¬¿¿¬»»¿¬";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	32, "\xC8\xC0\xC2\xC0\xC2\xC0\xC0\xC0\xC8\xC2\xC0\xC8\xC0\xC8\xC2\xC0\xC2\xC8\xC0\xC8\xC0\xC2\xC0\xC0\xC2\xC0\xC0\xC2\xC8\xC8\xC0\xC2"

	; PRINT @480, MID$(H$,L,31);

	ldd	#480
	jsr	prat_pw

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldab	#31
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; POKE S,191

	ldx	#INTVAR_S
	ldab	#191
	jsr	poke_ix_pb

LINE_120

	; PRINT @P, A$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_A
	jsr	pr_sx

	; PRINT @P+V, B$;

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @P+R, C$;

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; SOUND RND(100),1

	ldab	#100
	jsr	irnd_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; NEXT

	jsr	next

LINE_121

	; IF ABS(S-M-P)<128 THEN

	ldx	#INTVAR_S
	ldd	#INTVAR_M
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_P
	jsr	sub_ir1_ir1_ix

	jsr	abs_ir1_ir1

	ldab	#128
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_130
	jsr	jmpeq_ir1_ix

	; POKE S-1,191

	ldx	#INTVAR_S
	jsr	dec_ir1_ix

	ldab	#191
	jsr	poke_ir1_pb

	; POKE S-V,191

	ldx	#INTVAR_S
	ldd	#INTVAR_V
	jsr	sub_ir1_ix_id

	ldab	#191
	jsr	poke_ir1_pb

	; POKE S+V,191

	ldx	#INTVAR_S
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldab	#191
	jsr	poke_ir1_pb

	; POKE S+1,191

	ldx	#INTVAR_S
	jsr	inc_ir1_ix

	ldab	#191
	jsr	poke_ir1_pb

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; POKE S-1,U

	ldx	#INTVAR_S
	jsr	dec_ir1_ix

	ldx	#INTVAR_U
	jsr	poke_ir1_ix

	; POKE S-V,U

	ldx	#INTVAR_S
	ldd	#INTVAR_V
	jsr	sub_ir1_ix_id

	ldx	#INTVAR_U
	jsr	poke_ir1_ix

	; POKE S+V,U

	ldx	#INTVAR_S
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	ldx	#INTVAR_U
	jsr	poke_ir1_ix

	; POKE S+1,U

	ldx	#INTVAR_S
	jsr	inc_ir1_ix

	ldx	#INTVAR_U
	jsr	poke_ir1_ix

LINE_130

	; N-=1

	ldx	#INTVAR_N
	jsr	dec_ix_ix

	; IF N<49 THEN

	ldx	#INTVAR_N
	jsr	ld_ir1_ix

	ldab	#49
	jsr	ldlt_ir1_ir1_pb

	ldx	#LINE_135
	jsr	jmpeq_ir1_ix

	; SC+=L

	ldx	#INTVAR_L
	jsr	ld_ir1_ix

	ldx	#INTVAR_SC
	jsr	add_ix_ix_ir1

	; POKE M+511,N

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_N
	jsr	poke_ir1_ix

	; L=224

	ldx	#INTVAR_L
	ldab	#224
	jsr	ld_ix_pb

	; NEXT

	jsr	next

	; GOTO 200

	ldx	#LINE_200
	jsr	goto_ix

LINE_135

	; PRINT @P, " ";

	ldx	#INTVAR_P
	jsr	prat_ix

	jsr	pr_ss
	.text	1, " "

	; PRINT @P+V, "   ";

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	jsr	pr_ss
	.text	3, "   "

	; PRINT @P+R, "  ";

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	jsr	pr_ss
	.text	2, "  "

	; PRINT @0, "»¿¬¿¬¿¿¿»¬¿»¿»¬¿¬»¿»¿¬¿¿¬¿¿¬»»¿¬";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	32, "\xC8\xC0\xC2\xC0\xC2\xC0\xC0\xC0\xC8\xC2\xC0\xC8\xC0\xC8\xC2\xC0\xC2\xC8\xC0\xC8\xC0\xC2\xC0\xC0\xC2\xC0\xC0\xC2\xC8\xC8\xC0\xC2"

LINE_136

	; PRINT @480, MID$(H$,L,31);

	ldd	#480
	jsr	prat_pw

	ldx	#STRVAR_H
	jsr	ld_sr1_sx

	ldx	#INTVAR_L
	jsr	ld_ir2_ix

	ldab	#31
	jsr	midT_sr1_sr1_pb

	jsr	pr_sr1

	; IF P<V THEN

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_138
	jsr	jmpeq_ir1_ix

	; P+=V

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	add_ix_ix_ir1

LINE_138

	; IF P>I THEN

	ldx	#INTVAR_I
	ldd	#INTVAR_P
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_140
	jsr	jmpeq_ir1_ix

	; P-=V

	ldx	#INTVAR_V
	jsr	ld_ir1_ix

	ldx	#INTVAR_P
	jsr	sub_ix_ix_ir1

LINE_140

	; SOUND 1,1

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; L=1

	ldx	#INTVAR_L
	jsr	one_ix

	; POKE S,U

	ldd	#INTVAR_S
	ldx	#INTVAR_U
	jsr	poke_id_ix

	; A=0

	ldx	#INTVAR_A
	jsr	clr_ix

	; S=M+511

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; POKE S,N

	ldd	#INTVAR_S
	ldx	#INTVAR_N
	jsr	poke_id_ix

	; SOUND 100,1

	ldab	#100
	jsr	ld_ir1_pb

	ldab	#1
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; GOTO 22

	ldx	#LINE_22
	jsr	goto_ix

LINE_200

	; PRINT @P, A$;

	ldx	#INTVAR_P
	jsr	prat_ix

	ldx	#STRVAR_A
	jsr	pr_sx

	; PRINT @P+V, B$;

	ldx	#INTVAR_P
	ldd	#INTVAR_V
	jsr	add_ir1_ix_id

	jsr	prat_ir1

	ldx	#STRVAR_B
	jsr	pr_sx

	; PRINT @P+R, C$;

	ldx	#INTVAR_P
	ldd	#FLTVAR_R
	jsr	add_fr1_ix_fd

	jsr	prat_ir1

	ldx	#STRVAR_C
	jsr	pr_sx

	; SOUND 1,10

	ldab	#1
	jsr	ld_ir1_pb

	ldab	#10
	jsr	ld_ir2_pb

	jsr	sound_ir1_ir2

	; PRINT @8,

	ldab	#8
	jsr	prat_pb

	; M$="PLAY AGAIN (Y/N)?"

	jsr	ld_sr1_ss
	.text	17, "PLAY AGAIN (Y/N)?"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

LINE_210

	; M$=INKEY$

	ldx	#STRVAR_M
	jsr	inkey_sx

	; WHEN M$="" GOTO 210

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	0, ""

	ldx	#LINE_210
	jsr	jmpne_ir1_ix

LINE_220

	; WHEN M$="Y" GOTO 300

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "Y"

	ldx	#LINE_300
	jsr	jmpne_ir1_ix

LINE_230

	; IF M$="N" THEN

	ldx	#STRVAR_M
	jsr	ld_sr1_sx

	jsr	ldeq_ir1_sr1_ss
	.text	1, "N"

	ldx	#LINE_240
	jsr	jmpeq_ir1_ix

	; END

	jsr	progend

LINE_240

	; GOTO 210

	ldx	#LINE_210
	jsr	goto_ix

LINE_300

	; CLS

	jsr	cls

LINE_310

	; PRINT @136, "FINAL SCORE ";STR$(SC);" \r";

	ldab	#136
	jsr	prat_pb

	jsr	pr_ss
	.text	12, "FINAL SCORE "

	ldx	#INTVAR_SC
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_320

	; IF SC>HS THEN

	ldx	#INTVAR_HS
	ldd	#INTVAR_SC
	jsr	ldlt_ir1_ix_id

	ldx	#LINE_330
	jsr	jmpeq_ir1_ix

	; HS=SC

	ldd	#INTVAR_HS
	ldx	#INTVAR_SC
	jsr	ld_id_ix

LINE_330

	; PRINT @200, " HIGH SCORE ";STR$(HS);" \r";

	ldab	#200
	jsr	prat_pb

	jsr	pr_ss
	.text	12, " HIGH SCORE "

	ldx	#INTVAR_HS
	jsr	str_sr1_ix

	jsr	pr_sr1

	jsr	pr_ss
	.text	2, " \r"

LINE_340

	; PRINT @322,

	ldd	#322
	jsr	prat_pw

	; GOSUB 3110

	ldx	#LINE_3110
	jsr	gosub_ix

LINE_900

	; SC=0

	ldx	#INTVAR_SC
	jsr	clr_ix

	; LV=1

	ldx	#INTVAR_LV
	jsr	one_ix

	; F=0

	ldx	#INTVAR_F
	jsr	clr_ix

	; GOSUB 2000

	ldx	#LINE_2000
	jsr	gosub_ix

LINE_950

	; P=164

	ldx	#INTVAR_P
	ldab	#164
	jsr	ld_ix_pb

	; E=256

	ldx	#INTVAR_E
	ldd	#256
	jsr	ld_ix_pw

	; S=M+511

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldx	#INTVAR_S
	jsr	ld_ix_ir1

	; A=0

	ldx	#INTVAR_A
	jsr	clr_ix

	; CLS

	jsr	cls

	; POKE M+511,128

	ldx	#INTVAR_M
	ldd	#511
	jsr	add_ir1_ix_pw

	ldab	#128
	jsr	poke_ir1_pb

	; D=10

	ldx	#INTVAR_D
	ldab	#10
	jsr	ld_ix_pb

LINE_960

	; N=51

	ldx	#INTVAR_N
	ldab	#51
	jsr	ld_ix_pb

	; PRINT @0, "»¿¬¿¬¿¿¿»¬¿»¿»¬¿¬»¿»¿¬¿¿¬¿¿¬»»¿¬";

	ldab	#0
	jsr	prat_pb

	jsr	pr_ss
	.text	32, "\xC8\xC0\xC2\xC0\xC2\xC0\xC0\xC0\xC8\xC2\xC0\xC8\xC0\xC8\xC2\xC0\xC2\xC8\xC0\xC8\xC0\xC2\xC0\xC0\xC2\xC0\xC0\xC2\xC8\xC8\xC0\xC2"

	; GOTO 20

	ldx	#LINE_20
	jsr	goto_ix

LINE_970

	; DIM E,P,K,L,V,M,T,A$,B$,C$,D$,E$,H$,S,U,Q,R,D,N,A,F,G,H,I,M$,E$(3),D$(3)

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_E
	jsr	arrdim1_ir1_sx

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrdim1_ir1_sx

LINE_980

	; M=16384

	ldx	#INTVAR_M
	ldd	#16384
	jsr	ld_ix_pw

	; V=32

	ldx	#INTVAR_V
	ldab	#32
	jsr	ld_ix_pb

	; Q=17023

	ldx	#INTVAR_Q
	ldd	#17023
	jsr	ld_ix_pw

	; U=96

	ldx	#INTVAR_U
	ldab	#96
	jsr	ld_ix_pb

	; R=64

	ldx	#FLTVAR_R
	ldab	#64
	jsr	ld_fx_pb

	; G=142

	ldx	#INTVAR_G
	ldab	#142
	jsr	ld_ix_pb

	; H=240

	ldx	#INTVAR_H
	ldab	#240
	jsr	ld_ix_pb

	; I=384

	ldx	#INTVAR_I
	ldd	#384
	jsr	ld_ix_pw

	; GOSUB 3000

	ldx	#LINE_3000
	jsr	gosub_ix

	; GOSUB 1000

	ldx	#LINE_1000
	jsr	gosub_ix

	; GOTO 900

	ldx	#LINE_900
	jsr	goto_ix

LINE_1000

	; A$="é"

	jsr	ld_sr1_ss
	.text	1, "\x8E"

	ldx	#STRVAR_A
	jsr	ld_sx_sr1

LINE_1001

	; B$="àîå"

	jsr	ld_sr1_ss
	.text	3, "\x88\x94\x8C"

	ldx	#STRVAR_B
	jsr	ld_sx_sr1

LINE_1002

	; C$="ãÉ"

	jsr	ld_sr1_ss
	.text	2, "\x8B\x83"

	ldx	#STRVAR_C
	jsr	ld_sx_sr1

LINE_1003

	; D$(1)="            ˇˇ                  "

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "            \xFF\xFF                  "

	jsr	ld_sp_sr1

LINE_1004

	; E$(1)="           ˇ``ˇ                 "

	ldab	#1
	jsr	ld_ir1_pb

	ldx	#STRARR_E
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "           \xFF``\xFF                 "

	jsr	ld_sp_sr1

LINE_1006

	; D$(2)="                   ˇˇ           "

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "                   \xFF\xFF           "

	jsr	ld_sp_sr1

LINE_1007

	; E$(2)="                  ˇ``ˇ          "

	ldab	#2
	jsr	ld_ir1_pb

	ldx	#STRARR_E
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "                  \xFF``\xFF          "

	jsr	ld_sp_sr1

LINE_1009

	; D$(3)="     ˇˇ                ˇˇ       "

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "     \xFF\xFF                \xFF\xFF       "

	jsr	ld_sp_sr1

LINE_1010

	; E$(3)="    ˇ\x7F\x7Fˇ              ˇ\x7F\x7Fˇ      "

	ldab	#3
	jsr	ld_ir1_pb

	ldx	#STRARR_E
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "    \xFF\x7F\x7F\xFF              \xFF\x7F\x7F\xFF      "

	jsr	ld_sp_sr1

LINE_1013

	; D$(0)="                                "

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrref1_ir1_sx

	jsr	ld_sr1_ss
	.text	32, "                                "

	jsr	ld_sp_sr1

LINE_1020

	; M$="îúüîïüüîùüöòúêúúêêîúúúîòîúòîúîòî"

	jsr	ld_sr1_ss
	.text	32, "\x94\x9C\x9F\x94\x95\x9F\x9F\x94\x9D\x9F\x9A\x98\x9C\x90\x9C\x9C\x90\x90\x94\x9C\x9C\x9C\x94\x98\x94\x9C\x98\x94\x9C\x94\x98\x94"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; FOR T=1 TO 14

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#14
	jsr	to_ip_pb

	; H$=H$+MID$(M$,RND(14),16)

	ldx	#STRVAR_H
	jsr	strinit_sr1_sx

	ldx	#STRVAR_M
	jsr	ld_sr2_sx

	ldab	#14
	jsr	irnd_ir3_pb

	ldab	#16
	jsr	midT_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

	; H$=H$+LEFT$(H$,31)

	ldx	#STRVAR_H
	jsr	strinit_sr1_sx

	ldx	#STRVAR_H
	jsr	ld_sr2_sx

	ldab	#31
	jsr	left_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_H
	jsr	ld_sx_sr1

	; RETURN

	jsr	return

LINE_2000

	; D$=D$(0)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=D$(0)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=D$(0)

	ldab	#0
	jsr	ld_ir1_pb

	ldx	#STRARR_D
	jsr	arrval1_ir1_sx

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; FOR T=1 TO 6

	ldx	#INTVAR_T
	jsr	forone_ix

	ldab	#6
	jsr	to_ip_pb

	; R=RND(LV)

	ldx	#INTVAR_LV
	jsr	rnd_fr1_ix

	ldx	#FLTVAR_R
	jsr	ld_fx_fr1

	; D$=D$+D$(R)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldx	#FLTVAR_R
	jsr	ld_fr2_fx

	ldx	#STRARR_D
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=E$+E$(R)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldx	#FLTVAR_R
	jsr	ld_fr2_fx

	ldx	#STRARR_E
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=F$+D$(R)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldx	#FLTVAR_R
	jsr	ld_fr2_fx

	ldx	#STRARR_D
	jsr	arrval1_ir2_sx

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; NEXT

	jsr	next

LINE_2005

	; D$=D$+LEFT$(D$,31)

	ldx	#STRVAR_D
	jsr	strinit_sr1_sx

	ldx	#STRVAR_D
	jsr	ld_sr2_sx

	ldab	#31
	jsr	left_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_D
	jsr	ld_sx_sr1

	; E$=E$+LEFT$(E$,31)

	ldx	#STRVAR_E
	jsr	strinit_sr1_sx

	ldx	#STRVAR_E
	jsr	ld_sr2_sx

	ldab	#31
	jsr	left_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_E
	jsr	ld_sx_sr1

	; F$=F$+LEFT$(F$,31)

	ldx	#STRVAR_F
	jsr	strinit_sr1_sx

	ldx	#STRVAR_F
	jsr	ld_sr2_sx

	ldab	#31
	jsr	left_sr2_sr2_pb

	jsr	strcat_sr1_sr1_sr2

	ldx	#STRVAR_F
	jsr	ld_sx_sr1

	; R=64

	ldx	#FLTVAR_R
	ldab	#64
	jsr	ld_fx_pb

LINE_2010

	; RETURN

	jsr	return

LINE_2140

	; REM JIM GERRIE 2020

LINE_3000

	; CLS

	jsr	cls

	; PRINT @42,

	ldab	#42
	jsr	prat_pb

	; M$="D  E  C  O  Y"

	jsr	ld_sr1_ss
	.text	13, "D  E  C  O  Y"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

	; PRINT "\r";

	jsr	pr_ss
	.text	1, "\r"

LINE_3020

	; PRINT "USE WASD KEYS TO MOVE SHUTTLE,\r";

	jsr	pr_ss
	.text	31, "USE WASD KEYS TO MOVE SHUTTLE,\r"

LINE_3030

	; PRINT "AND SPACE BAR TO FIRE.\r";

	jsr	pr_ss
	.text	23, "AND SPACE BAR TO FIRE.\r"

LINE_3040

	; PRINT "YOU ARE TO FLY OVER A PART\r";

	jsr	pr_ss
	.text	27, "YOU ARE TO FLY OVER A PART\r"

LINE_3050

	; PRINT "OF THE PLANET ZELTA WHILE OUR\r";

	jsr	pr_ss
	.text	30, "OF THE PLANET ZELTA WHILE OUR\r"

LINE_3060

	; PRINT "FIGHTERS ARE TO ATTACK ON\r";

	jsr	pr_ss
	.text	26, "FIGHTERS ARE TO ATTACK ON\r"

LINE_3070

	; PRINT "THE OTHER SIDE OF THE PLANET.\r";

	jsr	pr_ss
	.text	30, "THE OTHER SIDE OF THE PLANET.\r"

LINE_3080

	; PRINT "YOU ARE THE DECOY FOR THEIR\r";

	jsr	pr_ss
	.text	28, "YOU ARE THE DECOY FOR THEIR\r"

LINE_3090

	; PRINT "SHIPS AND GROUND FIRE...\r";

	jsr	pr_ss
	.text	25, "SHIPS AND GROUND FIRE...\r"

LINE_3100

	; M$="WARNING:"

	jsr	ld_sr1_ss
	.text	8, "WARNING:"

	ldx	#STRVAR_M
	jsr	ld_sx_sr1

	; GOSUB 7

	ldx	#LINE_7
	jsr	gosub_ix

	; PRINT " DON'T LEAVE THE\r";

	jsr	pr_ss
	.text	17, " DON'T LEAVE THE\r"

LINE_3105

	; PRINT "ATMOSPHERE.\r";

	jsr	pr_ss
	.text	12, "ATMOSPHERE.\r"

LINE_3110

	; PRINT "GOOD LUCK... PRESS B TO BEGIN\r";

	jsr	pr_ss
	.text	30, "GOOD LUCK... PRESS B TO BEGIN\r"

LINE_3120

	; WHEN INKEY$<>"B" GOTO 3120

	jsr	inkey_sr1

	jsr	ldne_ir1_sr1_ss
	.text	1, "B"

	ldx	#LINE_3120
	jsr	jmpne_ir1_ix

LINE_3130

	; CLS

	jsr	cls

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
	subd	2,x
	bhi	_err
	ldd	0+argv
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

abs_ir1_ir1			; numCalls = 1
	.module	modabs_ir1_ir1
	ldaa	r1
	bpl	_rts
	ldx	#r1
	jmp	negxi
_rts
	rts

add_fr1_ix_fd			; numCalls = 9
	.module	modadd_fr1_ix_fd
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
	ldd	3,x
	std	r1+3
	rts

add_fr2_ix_fd			; numCalls = 1
	.module	modadd_fr2_ix_fd
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
	ldd	3,x
	std	r2+3
	rts

add_ir1_ir1_ir2			; numCalls = 1
	.module	modadd_ir1_ir1_ir2
	ldd	r1+1
	addd	r2+1
	std	r1+1
	ldab	r1
	adcb	r2
	stab	r1
	rts

add_ir1_ir1_ix			; numCalls = 3
	.module	modadd_ir1_ir1_ix
	ldd	r1+1
	addd	1,x
	std	r1+1
	ldab	r1
	adcb	0,x
	stab	r1
	rts

add_ir1_ir1_pb			; numCalls = 4
	.module	modadd_ir1_ir1_pb
	clra
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ir1_pw			; numCalls = 1
	.module	modadd_ir1_ir1_pw
	addd	r1+1
	std	r1+1
	ldab	#0
	adcb	r1
	stab	r1
	rts

add_ir1_ix_id			; numCalls = 19
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

add_ir1_ix_pw			; numCalls = 7
	.module	modadd_ir1_ix_pw
	addd	1,x
	std	r1+1
	ldab	#0
	adcb	0,x
	stab	r1
	rts

add_ir3_ix_pb			; numCalls = 1
	.module	modadd_ir3_ix_pb
	clra
	addd	1,x
	std	r3+1
	ldab	#0
	adcb	0,x
	stab	r3
	rts

add_ix_ix_ir1			; numCalls = 6
	.module	modadd_ix_ix_ir1
	ldd	1,x
	addd	r1+1
	std	1,x
	ldab	0,x
	adcb	r1
	stab	0,x
	rts

add_ix_ix_pb			; numCalls = 2
	.module	modadd_ix_ix_pb
	clra
	addd	1,x
	std	1,x
	ldab	#0
	adcb	0,x
	stab	0,x
	rts

and_ir1_ir1_ir2			; numCalls = 3
	.module	modand_ir1_ir1_ir2
	ldd	r2+1
	andb	r1+2
	anda	r1+1
	std	r1+1
	ldab	r2
	andb	r1
	stab	r1
	rts

arrdim1_ir1_sx			; numCalls = 2
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

arrref1_ir1_sx			; numCalls = 7
	.module	modarrref1_ir1_sx
	ldd	r1+1
	std	0+argv
	ldd	#33
	jsr	ref1
	jsr	refint
	std	letptr
	rts

arrval1_ir1_sx			; numCalls = 3
	.module	modarrval1_ir1_sx
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

arrval1_ir2_sx			; numCalls = 3
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

clr_ix			; numCalls = 7
	.module	modclr_ix
	ldd	#0
	stab	0,x
	std	1,x
	rts

cls			; numCalls = 5
	.module	modcls
	jmp	R_CLS

dec_ir1_ir1			; numCalls = 1
	.module	moddec_ir1_ir1
	ldd	r1+1
	subd	#1
	std	r1+1
	ldab	r1
	sbcb	#0
	stab	r1
	rts

dec_ir1_ix			; numCalls = 2
	.module	moddec_ir1_ix
	ldd	1,x
	subd	#1
	std	r1+1
	ldab	0,x
	sbcb	#0
	stab	r1
	rts

dec_ix_ix			; numCalls = 1
	.module	moddec_ix_ix
	ldd	1,x
	subd	#1
	std	1,x
	ldab	0,x
	sbcb	#0
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

for_ix_ir1			; numCalls = 1
	.module	modfor_ix_ir1
	stx	letptr
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

forone_ix			; numCalls = 5
	.module	modforone_ix
	stx	letptr
	ldd	#1
	staa	0,x
	std	1,x
	rts

gosub_ix			; numCalls = 8
	.module	modgosub_ix
	ldab	#3
	pshb
	jmp	,x

goto_ix			; numCalls = 12
	.module	modgoto_ix
	ins
	ins
	jmp	,x

inc_ir1_ir1			; numCalls = 1
	.module	modinc_ir1_ir1
	inc	r1+2
	bne	_rts
	inc	r1+1
	bne	_rts
	inc	r1
_rts
	rts

inc_ir1_ix			; numCalls = 2
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

inc_ir3_ix			; numCalls = 1
	.module	modinc_ir3_ix
	ldd	1,x
	addd	#1
	std	r3+1
	ldab	0,x
	adcb	#0
	stab	r3
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

inkey_sr1			; numCalls = 1
	.module	modinkey_sr1
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

inkey_sx			; numCalls = 1
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

irnd_ir1_pb			; numCalls = 3
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

irnd_ir3_pb			; numCalls = 1
	.module	modirnd_ir3_pb
	clra
	staa	tmp1+1
	std	tmp2
	jsr	irnd
	std	r3+1
	ldab	tmp1
	stab	r3
	rts

jmpeq_ir1_ix			; numCalls = 9
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

jmpne_ir1_ix			; numCalls = 8
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

ld_fr2_fx			; numCalls = 3
	.module	modld_fr2_fx
	ldd	3,x
	std	r2+3
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_fx_fr1			; numCalls = 1
	.module	modld_fx_fr1
	ldd	r1+3
	std	3,x
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_fx_pb			; numCalls = 2
	.module	modld_fx_pb
	stab	2,x
	ldd	#0
	std	3,x
	std	0,x
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

ld_ir1_ix			; numCalls = 10
	.module	modld_ir1_ix
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_ir1_pb			; numCalls = 25
	.module	modld_ir1_pb
	stab	r1+2
	ldd	#0
	std	r1
	rts

ld_ir2_ix			; numCalls = 13
	.module	modld_ir2_ix
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_ir2_pb			; numCalls = 9
	.module	modld_ir2_pb
	stab	r2+2
	ldd	#0
	std	r2
	rts

ld_ir3_ix			; numCalls = 1
	.module	modld_ir3_ix
	ldd	1,x
	std	r3+1
	ldab	0,x
	stab	r3
	rts

ld_ix_ir1			; numCalls = 11
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

ld_ix_pw			; numCalls = 4
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ld_sp_sr1			; numCalls = 7
	.module	modld_sp_sr1
	ldx	letptr
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

ld_sr1_ss			; numCalls = 14
	.module	modld_sr1_ss
	pulx
	ldab	,x
	stab	r1
	inx
	stx	r1+1
	abx
	jmp	,x

ld_sr1_sx			; numCalls = 12
	.module	modld_sr1_sx
	ldd	1,x
	std	r1+1
	ldab	0,x
	stab	r1
	rts

ld_sr2_sx			; numCalls = 5
	.module	modld_sr2_sx
	ldd	1,x
	std	r2+1
	ldab	0,x
	stab	r2
	rts

ld_sx_sr1			; numCalls = 18
	.module	modld_sx_sr1
	ldab	r1
	stab	0+argv
	ldd	r1+1
	std	1+argv
	jmp	strprm

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

ldeq_ir3_ir3_pb			; numCalls = 1
	.module	modldeq_ir3_ir3_pb
	cmpb	r3+2
	bne	_done
	ldd	r3
_done
	jsr	geteq
	std	r3+1
	stab	r3
	rts

ldlt_ir1_ir1_fr2			; numCalls = 1
	.module	modldlt_ir1_ir1_fr2
	ldd	#0
	subd	r2+3
	ldd	r1+1
	sbcb	r2+2
	sbca	r2+1
	ldab	r1
	sbcb	r2
	jsr	getlt
	std	r1+1
	stab	r1
	rts

ldlt_ir1_ir1_ir2			; numCalls = 1
	.module	modldlt_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	ldab	r1
	sbcb	r2
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

ldlt_ir1_ir1_pb			; numCalls = 2
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

ldlt_ir1_ix_id			; numCalls = 5
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

ldlt_ir2_ir2_ir3			; numCalls = 2
	.module	modldlt_ir2_ir2_ir3
	ldd	r2+1
	subd	r3+1
	ldab	r2
	sbcb	r3
	jsr	getlt
	std	r2+1
	stab	r2
	rts

ldlt_ir2_ix_id			; numCalls = 1
	.module	modldlt_ir2_ix_id
	std	tmp1
	ldab	0,x
	stab	r2
	ldd	1,x
	ldx	tmp1
	subd	1,x
	ldab	r2
	sbcb	0,x
	jsr	getlt
	std	r2+1
	stab	r2
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

left_sr2_sr2_pb			; numCalls = 4
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

len_ir1_sx			; numCalls = 1
	.module	modlen_ir1_sx
	ldab	0,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

midT_sr1_sr1_ix			; numCalls = 6
	.module	modmidT_sr1_sr1_ix
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
	ldab	2,x
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

midT_sr2_sr2_pb			; numCalls = 1
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

mul_ir1_ir1_ix			; numCalls = 1
	.module	modmul_ir1_ir1_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r1
	jmp	mulintx

mul_ir2_ir2_ix			; numCalls = 2
	.module	modmul_ir2_ir2_ix
	ldab	0,x
	stab	0+argv
	ldd	1,x
	std	1+argv
	ldx	#r2
	jmp	mulintx

neg_ir1_ix			; numCalls = 1
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

next			; numCalls = 9
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

one_ix			; numCalls = 3
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

or_ir1_ir1_ir2			; numCalls = 2
	.module	modor_ir1_ir1_ir2
	ldd	r2+1
	orab	r1+2
	oraa	r1+1
	std	r1+1
	ldab	r2
	orab	r1
	stab	r1
	rts

peek_ir1_ix			; numCalls = 2
	.module	modpeek_ir1_ix
	ldx	1,x
	jsr	peek
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir1_pb			; numCalls = 1
	.module	modpeek_ir1_pb
	clra
	std	tmp1
	ldx	tmp1
	ldab	,x
	stab	r1+2
	ldd	#0
	std	r1
	rts

peek_ir2_ix			; numCalls = 2
	.module	modpeek_ir2_ix
	ldx	1,x
	jsr	peek
	stab	r2+2
	ldd	#0
	std	r2
	rts

peek_ir3_ir3			; numCalls = 2
	.module	modpeek_ir3_ir3
	ldx	r3+1
	jsr	peek
	stab	r3+2
	ldd	#0
	std	r3
	rts

poke_id_ix			; numCalls = 7
	.module	modpoke_id_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	ldx	1,x
	stab	,x
	rts

poke_ir1_ix			; numCalls = 6
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

poke_ix_ir1			; numCalls = 1
	.module	modpoke_ix_ir1
	ldab	r1+2
	ldx	1,x
	stab	,x
	rts

poke_ix_pb			; numCalls = 1
	.module	modpoke_ix_pb
	ldx	1,x
	stab	,x
	rts

poke_pw_ir1			; numCalls = 2
	.module	modpoke_pw_ir1
	std	tmp1
	ldab	r1+2
	ldx	tmp1
	stab	,x
	rts

poke_pw_ix			; numCalls = 1
	.module	modpoke_pw_ix
	std	tmp1
	ldab	2,x
	ldx	tmp1
	stab	,x
	rts

pos_ir1			; numCalls = 1
	.module	modpos_ir1
	ldd	M_CRSR
	anda	#1
	std	r1+1
	clrb
	stab	r1
	rts

pr_sr1			; numCalls = 11
	.module	modpr_sr1
	ldab	r1
	beq	_rts
	ldx	r1+1
	jsr	print
	ldx	r1+1
	jmp	strrel
_rts
	rts

pr_ss			; numCalls = 35
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

pr_sx			; numCalls = 16
	.module	modpr_sx
	ldab	0,x
	beq	_rts
	ldx	1,x
	jmp	print
_rts
	rts

prat_ir1			; numCalls = 24
	.module	modprat_ir1
	ldaa	r1
	bne	_fcerror
	ldd	r1+1
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_ix			; numCalls = 11
	.module	modprat_ix
	ldaa	0,x
	bne	_fcerror
	ldd	1,x
	jmp	prat
_fcerror
	ldab	#FC_ERROR
	jmp	error

prat_pb			; numCalls = 8
	.module	modprat_pb
	ldaa	#$40
	std	M_CRSR
	rts

prat_pw			; numCalls = 4
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
LS_ERROR	.equ	28
error
	jmp	R_ERROR

return			; numCalls = 4
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

rsub_ir1_ir1_ix			; numCalls = 1
	.module	modrsub_ir1_ir1_ix
	ldd	1,x
	subd	r1+1
	std	r1+1
	ldab	0,x
	sbcb	r1
	stab	r1
	rts

rsub_ir2_ir2_pb			; numCalls = 1
	.module	modrsub_ir2_ir2_pb
	clra
	subd	r2+1
	std	r2+1
	ldab	#0
	sbcb	r2
	stab	r2
	rts

sound_ir1_ir2			; numCalls = 9
	.module	modsound_ir1_ir2
	ldaa	r1+2
	ldab	r2+2
	jmp	R_SOUND

step_ip_ir1			; numCalls = 2
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

str_sr1_ix			; numCalls = 2
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

strcat_sr1_sr1_sr2			; numCalls = 8
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

strinit_sr1_sx			; numCalls = 8
	.module	modstrinit_sr1_sx
	ldab	0,x
	stab	r1
	ldx	1,x
	jsr	strtmp
	std	r1+1
	rts

sub_fr1_ir1_fx			; numCalls = 1
	.module	modsub_fr1_ir1_fx
	ldd	#0
	subd	3,x
	std	r1+3
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	std	r1+1
	ldab	r1
	sbcb	0,x
	stab	r1
	rts

sub_ir1_ir1_ir2			; numCalls = 2
	.module	modsub_ir1_ir1_ir2
	ldd	r1+1
	subd	r2+1
	std	r1+1
	ldab	r1
	sbcb	r2
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

sub_ir1_ix_id			; numCalls = 5
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

sub_ir2_ir2_ir3			; numCalls = 1
	.module	modsub_ir2_ir2_ir3
	ldd	r2+1
	subd	r3+1
	std	r2+1
	ldab	r2
	sbcb	r3
	stab	r2
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

to_ip_ir1			; numCalls = 1
	.module	modto_ip_ir1
	ldd	#0
	std	r1+3
	ldab	#11
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

to_ip_pb			; numCalls = 5
	.module	modto_ip_pb
	stab	r1+2
	ldd	#0
	std	r1
	std	r1+3
	ldab	#11
	jmp	to

; data table
startdata
enddata


; block started by symbol
bss

; Numeric Variables
INTVAR_A	.block	3
INTVAR_D	.block	3
INTVAR_E	.block	3
INTVAR_F	.block	3
INTVAR_G	.block	3
INTVAR_H	.block	3
INTVAR_HS	.block	3
INTVAR_I	.block	3
INTVAR_K	.block	3
INTVAR_L	.block	3
INTVAR_LV	.block	3
INTVAR_M	.block	3
INTVAR_N	.block	3
INTVAR_P	.block	3
INTVAR_Q	.block	3
INTVAR_S	.block	3
INTVAR_SC	.block	3
INTVAR_T	.block	3
INTVAR_U	.block	3
INTVAR_V	.block	3
FLTVAR_R	.block	5
; String Variables
STRVAR_A	.block	3
STRVAR_B	.block	3
STRVAR_C	.block	3
STRVAR_D	.block	3
STRVAR_E	.block	3
STRVAR_F	.block	3
STRVAR_H	.block	3
STRVAR_M	.block	3
; Numeric Arrays
; String Arrays
STRARR_D	.block	4	; dims=1
STRARR_E	.block	4	; dims=1

; block ended by symbol
bes
	.end

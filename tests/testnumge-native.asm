; Assembly for testnumge-native.bas
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
rend
argv	.block	10


; main program
	.org	M_CODE

	jsr	progbegin

	jsr	clear

LINE_1

	; X=1

	ldx	#INTVAR_X
	jsr	one_ix

	; NX=-X

	ldx	#INTVAR_X
	jsr	neg_ir1_ix

	ldx	#INTVAR_NX
	jsr	ld_ix_ir1

LINE_2

	; Y=1000

	ldx	#INTVAR_Y
	ldd	#1000
	jsr	ld_ix_pw

	; NY=-Y

	ldx	#INTVAR_Y
	jsr	neg_ir1_ix

	ldx	#INTVAR_NY
	jsr	ld_ix_ir1

LINE_3

	; Z=1.1

	ldd	#FLTVAR_Z
	ldx	#FLT_1p10000
	jsr	ld_fd_fx

LINE_10

	; IF X>=1 THEN

	ldx	#INTVAR_X
	ldab	#1
	jsr	ldge_ir1_ix_pb

	ldx	#LINE_20
	jsr	jmpeq_ir1_ix

	; PRINT "OK10\r";

	jsr	pr_ss
	.text	5, "OK10\r"

LINE_20

	; IF NX>=-1 THEN

	ldx	#INTVAR_NX
	ldab	#-1
	jsr	ldge_ir1_ix_nb

	ldx	#LINE_30
	jsr	jmpeq_ir1_ix

	; PRINT "OK20\r";

	jsr	pr_ss
	.text	5, "OK20\r"

LINE_30

	; IF Y>=1000 THEN

	ldx	#INTVAR_Y
	ldd	#1000
	jsr	ldge_ir1_ix_pw

	ldx	#LINE_40
	jsr	jmpeq_ir1_ix

	; PRINT "OK30\r";

	jsr	pr_ss
	.text	5, "OK30\r"

LINE_40

	; IF NY>=-1000 THEN

	ldx	#INTVAR_NY
	ldd	#-1000
	jsr	ldge_ir1_ix_nw

	ldx	#LINE_50
	jsr	jmpeq_ir1_ix

	; PRINT "OK40\r";

	jsr	pr_ss
	.text	5, "OK40\r"

LINE_50

	; IF Y>=-1000 THEN

	ldx	#INTVAR_Y
	ldd	#-1000
	jsr	ldge_ir1_ix_nw

	ldx	#LINE_60
	jsr	jmpeq_ir1_ix

	; PRINT "OK50\r";

	jsr	pr_ss
	.text	5, "OK50\r"

LINE_60

	; IF X<=1 THEN

	ldab	#1
	ldx	#INTVAR_X
	jsr	ldge_ir1_pb_ix

	ldx	#LINE_70
	jsr	jmpeq_ir1_ix

	; PRINT "OK60\r";

	jsr	pr_ss
	.text	5, "OK60\r"

LINE_70

	; IF NX<=1 THEN

	ldab	#1
	ldx	#INTVAR_NX
	jsr	ldge_ir1_pb_ix

	ldx	#LINE_80
	jsr	jmpeq_ir1_ix

	; PRINT "OK70\r";

	jsr	pr_ss
	.text	5, "OK70\r"

LINE_80

	; IF Y<=1000 THEN

	ldd	#1000
	ldx	#INTVAR_Y
	jsr	ldge_ir1_pw_ix

	ldx	#LINE_90
	jsr	jmpeq_ir1_ix

	; PRINT "OK80\r";

	jsr	pr_ss
	.text	5, "OK80\r"

LINE_90

	; IF NY<=-1000 THEN

	ldd	#-1000
	ldx	#INTVAR_NY
	jsr	ldge_ir1_nw_ix

	ldx	#LINE_100
	jsr	jmpeq_ir1_ix

	; PRINT "OK90\r";

	jsr	pr_ss
	.text	5, "OK90\r"

LINE_100

	; IF Z>=1.1 THEN

	ldx	#FLTVAR_Z
	ldd	#FLT_1p10000
	jsr	ldge_ir1_fx_fd

	ldx	#LINE_110
	jsr	jmpeq_ir1_ix

	; PRINT "OK100\r";

	jsr	pr_ss
	.text	6, "OK100\r"

LINE_110

	; IF Z<=1.1 THEN

	ldx	#FLT_1p10000
	ldd	#FLTVAR_Z
	jsr	ldge_ir1_fx_fd

	ldx	#LINE_120
	jsr	jmpeq_ir1_ix

	; PRINT "OK110\r";

	jsr	pr_ss
	.text	6, "OK110\r"

LINE_120

	; IF (X+1)>=2 THEN

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldab	#2
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_130
	jsr	jmpeq_ir1_ix

	; PRINT "OK120\r";

	jsr	pr_ss
	.text	6, "OK120\r"

LINE_130

	; IF (NX+1)>=0 THEN

	ldx	#INTVAR_NX
	jsr	inc_ir1_ix

	ldab	#0
	jsr	ldge_ir1_ir1_pb

	ldx	#LINE_140
	jsr	jmpeq_ir1_ix

	; PRINT "OK130\r";

	jsr	pr_ss
	.text	6, "OK130\r"

LINE_140

	; IF (Y+1)>=1001 THEN

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldd	#1001
	jsr	ldge_ir1_ir1_pw

	ldx	#LINE_150
	jsr	jmpeq_ir1_ix

	; PRINT "OK140\r";

	jsr	pr_ss
	.text	6, "OK140\r"

LINE_150

	; IF (NY+1)>=-999 THEN

	ldx	#INTVAR_NY
	jsr	inc_ir1_ix

	ldd	#-999
	jsr	ldge_ir1_ir1_nw

	ldx	#LINE_160
	jsr	jmpeq_ir1_ix

	; PRINT "OK150\r";

	jsr	pr_ss
	.text	6, "OK150\r"

LINE_160

	; IF (Y+1)>=-999 THEN

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldd	#-999
	jsr	ldge_ir1_ir1_nw

	ldx	#LINE_170
	jsr	jmpeq_ir1_ix

	; PRINT "OK160\r";

	jsr	pr_ss
	.text	6, "OK160\r"

LINE_170

	; IF (X+1)<=2 THEN

	ldx	#INTVAR_X
	jsr	inc_ir1_ix

	ldab	#2
	jsr	ldge_ir1_pb_ir1

	ldx	#LINE_180
	jsr	jmpeq_ir1_ix

	; PRINT "OK170\r";

	jsr	pr_ss
	.text	6, "OK170\r"

LINE_180

	; IF (NX+1)<=0 THEN

	ldx	#INTVAR_NX
	jsr	inc_ir1_ix

	ldab	#0
	jsr	ldge_ir1_pb_ir1

	ldx	#LINE_190
	jsr	jmpeq_ir1_ix

	; PRINT "OK180\r";

	jsr	pr_ss
	.text	6, "OK180\r"

LINE_190

	; IF (Y+1)<=1001 THEN

	ldx	#INTVAR_Y
	jsr	inc_ir1_ix

	ldd	#1001
	jsr	ldge_ir1_pw_ir1

	ldx	#LINE_200
	jsr	jmpeq_ir1_ix

	; PRINT "OK190\r";

	jsr	pr_ss
	.text	6, "OK190\r"

LINE_200

	; IF (NY+1)<=999 THEN

	ldx	#INTVAR_NY
	jsr	inc_ir1_ix

	ldd	#999
	jsr	ldge_ir1_pw_ir1

	ldx	#LINE_210
	jsr	jmpeq_ir1_ix

	; PRINT "OK200\r";

	jsr	pr_ss
	.text	6, "OK200\r"

LINE_210

	; IF (Z+1)>=2.1 THEN

	ldx	#FLTVAR_Z
	jsr	inc_fr1_fx

	ldx	#FLT_2p10000
	jsr	ldge_ir1_fr1_fx

	ldx	#LINE_220
	jsr	jmpeq_ir1_ix

	; PRINT "OK210\r";

	jsr	pr_ss
	.text	6, "OK210\r"

LINE_220

	; IF (Z+1)<=2.1 THEN

	ldx	#FLTVAR_Z
	jsr	inc_fr1_fx

	ldx	#FLT_2p10000
	jsr	ldge_ir1_fx_fr1

	ldx	#LINE_230
	jsr	jmpeq_ir1_ix

	; PRINT "OK220\r";

	jsr	pr_ss
	.text	6, "OK220\r"

LINE_230

	; IF Z>=1 THEN

	ldx	#FLTVAR_Z
	ldab	#1
	jsr	ldge_ir1_fx_pb

	ldx	#LINE_240
	jsr	jmpeq_ir1_ix

	; PRINT "OK230\r";

	jsr	pr_ss
	.text	6, "OK230\r"

LINE_240

	; IF Z>=-1000 THEN

	ldx	#FLTVAR_Z
	ldd	#-1000
	jsr	ldge_ir1_fx_nw

	ldx	#LINE_250
	jsr	jmpeq_ir1_ix

	; PRINT "OK240\r";

	jsr	pr_ss
	.text	6, "OK240\r"

LINE_250

	; PRINT "DONE\r";

	jsr	pr_ss
	.text	5, "DONE\r"

LLAST

	; END

	jsr	progend

	.module	mdgetge
getge
	bge	_1
	ldd	#0
	rts
_1
	ldd	#-1
	rts

	.module	mdprint
print
_loop
	ldaa	,x
	jsr	R_PUTC
	inx
	decb
	bne	_loop
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

inc_ir1_ix			; numCalls = 9
	.module	modinc_ir1_ix
	ldd	1,x
	addd	#1
	std	r1+1
	ldab	0,x
	adcb	#0
	stab	r1
	rts

jmpeq_ir1_ix			; numCalls = 24
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

ld_fd_fx			; numCalls = 1
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

ld_ix_ir1			; numCalls = 2
	.module	modld_ix_ir1
	ldd	r1+1
	std	1,x
	ldab	r1
	stab	0,x
	rts

ld_ix_pw			; numCalls = 1
	.module	modld_ix_pw
	std	1,x
	ldab	#0
	stab	0,x
	rts

ldge_ir1_fr1_fx			; numCalls = 1
	.module	modldge_ir1_fr1_fx
	ldd	r1+3
	subd	3,x
	ldd	r1+1
	sbcb	2,x
	sbca	1,x
	ldab	r1
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_fx_fd			; numCalls = 2
	.module	modldge_ir1_fx_fd
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
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_fx_fr1			; numCalls = 1
	.module	modldge_ir1_fx_fr1
	ldd	3,x
	subd	r1+3
	ldd	1,x
	sbcb	r1+2
	sbca	r1+1
	ldab	0,x
	sbcb	r1
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_fx_nw			; numCalls = 1
	.module	modldge_ir1_fx_nw
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_fx_pb			; numCalls = 1
	.module	modldge_ir1_fx_pb
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

ldge_ir1_ir1_nw			; numCalls = 2
	.module	modldge_ir1_ir1_nw
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#-1
	jsr	getge
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

ldge_ir1_ir1_pw			; numCalls = 1
	.module	modldge_ir1_ir1_pw
	std	tmp1
	ldd	r1+1
	subd	tmp1
	ldab	r1
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_ix_nb			; numCalls = 1
	.module	modldge_ir1_ix_nb
	ldaa	#-1
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_ix_nw			; numCalls = 2
	.module	modldge_ir1_ix_nw
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#-1
	jsr	getge
	std	r1+1
	stab	r1
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

ldge_ir1_ix_pw			; numCalls = 1
	.module	modldge_ir1_ix_pw
	std	tmp1
	ldd	1,x
	subd	tmp1
	ldab	0,x
	sbcb	#0
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_nw_ix			; numCalls = 1
	.module	modldge_ir1_nw_ix
	subd	1,x
	ldab	#-1
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_pb_ir1			; numCalls = 2
	.module	modldge_ir1_pb_ir1
	clra
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_pb_ix			; numCalls = 2
	.module	modldge_ir1_pb_ix
	clra
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_pw_ir1			; numCalls = 2
	.module	modldge_ir1_pw_ir1
	subd	r1+1
	ldab	#0
	sbcb	r1
	jsr	getge
	std	r1+1
	stab	r1
	rts

ldge_ir1_pw_ix			; numCalls = 1
	.module	modldge_ir1_pw_ix
	subd	1,x
	ldab	#0
	sbcb	0,x
	jsr	getge
	std	r1+1
	stab	r1
	rts

neg_ir1_ix			; numCalls = 2
	.module	modneg_ir1_ix
	ldd	#0
	subd	1,x
	std	r1+1
	ldab	#0
	sbcb	0,x
	stab	r1
	rts

one_ix			; numCalls = 1
	.module	modone_ix
	ldd	#1
	staa	0,x
	std	1,x
	rts

pr_ss			; numCalls = 25
	.module	modpr_ss
	pulx
	ldab	,x
	beq	_null
	inx
	jsr	print
	jmp	,x
_null
	jmp	1,x

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

progend			; numCalls = 1
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

; data table
startdata
enddata


; fixed-point constants
FLT_1p10000	.byte	$00, $00, $01, $19, $9a
FLT_2p10000	.byte	$00, $00, $02, $19, $9a

; block started by symbol
bss

; Numeric Variables
INTVAR_NX	.block	3
INTVAR_NY	.block	3
INTVAR_X	.block	3
INTVAR_Y	.block	3
FLTVAR_Z	.block	5
; String Variables
; Numeric Arrays
; String Arrays

; block ended by symbol
bes
	.end

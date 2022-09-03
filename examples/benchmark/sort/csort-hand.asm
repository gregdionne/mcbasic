scnpos	.equ	$C9
tmpcnt	.equ	$CB
cntidx	.equ	$CD
scntop	.equ	$4000
scnsiz	.equ	512
cntsiz	.equ	512

	.org	$8000

	; clear count table
	ldx	#counts
	ldd	#0
nxtclr	std	,x
	inx
	inx
	cpx	#counts+cntsiz
	bne	nxtclr

	; count number of occurrences
	; of each element on screen
	ldx	#scntop
nxtbyt	stx	scnpos
	ldab	,x
stcmp	ldx	#counts
	abx
	abx
	inc	1,x
	bne	doninc
	inc	0,x
doninc	ldx	scnpos
	inx
	cpx	#scntop+scnsiz
	bne	nxtbyt

	; for each value in table
	clr	cntidx
	ldx	#scntop
	stx	scnpos

nxtcnt	ldx	#counts
	ldab	cntidx
	abx
	abx
	ldd	,x
	beq	czero
	std	tmpcnt
	ldx	scnpos
	ldab	cntidx
nxtdec	stab	,x
	inx
	dec	tmpcnt+1
	bne	nxtdec
	dec	tmpcnt
	bpl	nxtdec
	stx	scnpos
czero	inc	cntidx
	bne	nxtcnt
	rts

counts	.block	cntsiz
	.end

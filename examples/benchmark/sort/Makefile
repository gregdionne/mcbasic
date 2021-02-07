MCBASIC ?= ../../../mcbasic

BSORT ?= bsort-hand.c10 bsort-bytecode.c10 bsort-native.c10
QSORT ?= qsort-hand.c10 qsort-bytecode.c10 qsort-native.c10

.PRECIOUS: %-native.asm %-bytecode.asm

all: $(BSORT) $(QSORT)

%.c10: %.asm
	tasm $<

%-native.bas: %.bas
	cp $< $@

%-native.asm: %-native.bas $(MCBASIC)
	mcbasic -native $<

%-bytecode.bas: %.bas
	cp $< $@

%-bytecode.asm: %-bytecode.bas $(MCBASIC)
	mcbasic $<

clean:
	rm -f *.lst *.obj *.c10 qsort.asm bsort.asm *-bytecode.asm *-native.asm *-native.bas *-bytecode.bas


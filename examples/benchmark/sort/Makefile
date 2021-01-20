MCBASIC ?= ../../../mcbasic

BSORT ?= bsort-hand.c10 bsort-bytecode.c10 bsort-native.c10
QSORT ?= qsort-hand.c10 qsort-bytecode.c10 qsort-native.c10

.PRECIOUS: %-native.asm %-bytecode.asm

all: $(BSORT) $(QSORT)

%.c10: %.asm
	tasm $<

%-native.asm: %.bas $(MCBASIC)
	mcbasic -native $<
	mv $(<:.bas=.asm) $@

%-bytecode.asm: %.bas $(MCBASIC)
	mcbasic $<
	mv $(<:.bas=.asm) $@

clean:
	rm -f *.lst *.obj *.c10 qsort.asm bsort.asm *-bytecode.asm *-native.asm


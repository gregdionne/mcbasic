MCBASIC ?= ../../../mcbasic

BSORT ?= bsort-hand.c10 bsort-bytecode.c10 bsort-native.c10
QSORT ?= qsort-hand.c10 qsort-bytecode.c10 qsort-native.c10
CSORT ?= csort-hand.c10 csort-bytecode.c10 csort-native.c10

.PRECIOUS: %-native.asm %-bytecode.asm

all: $(BSORT) $(QSORT) $(CSORT)

%.c10: %.asm
	tasm $<

%-native.bas: %.bas
	cp $< $@

%-native.asm: %-native.bas $(MCBASIC)
	$(MCBASIC) -native $<

%-bytecode.bas: %.bas
	cp $< $@

%-bytecode.asm: %-bytecode.bas $(MCBASIC)
	$(MCBASIC) $<

clean:
	rm -f *.lst *.obj *.c10 qsort.asm bsort.asm *-bytecode.asm *-native.asm *-native.bas *-bytecode.bas


MCBASIC := ../../../mcbasic

SRCS := $(shell find . -name \*.bas)
BC10S := $(SRCS:%.bas=%-bytecode.c10)
NC10S := $(SRCS:%.bas=%-native.c10)
C10S := $(BC10S) $(NC10S)

.PRECIOUS: %-native.asm %-bytecode.asm

all: $(C10S)

%.c10: %.asm
	tasm $<

%-native.asm: %.bas $(MCBASIC)
	mcbasic -native $<
	mv $(<:.bas=.asm) $@

%-bytecode.asm: %.bas $(MCBASIC)
	mcbasic $<
	mv $(<:.bas=.asm) $@

clean:
	rm -f *.lst *.obj *.c10 *.asm


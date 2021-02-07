MCBASIC := ../mcbasic

SRCS := $(shell find . -depth 1 -name \*.bas)
BC10S := $(SRCS:%.bas=%-bytecode.c10)
NC10S := $(SRCS:%.bas=%-native.c10)
C10S := $(BC10S) $(NC10S)

.PRECIOUS: %-native.asm %-bytecode.asm

all: $(C10S)

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
	rm -f *.lst *.obj *.c10 *.asm *-native.bas *-bytecode.bas


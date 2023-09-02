MCBASIC ?= ../../../mcbasic

SRCS := $(shell find . -name \*.bas)

BASMS := $(SRCS:%.bas=%-bytecode.asm)
NASMS := $(SRCS:%.bas=%-native.asm)
ASMS := $(BASMS) $(NASMS)

BC10S := $(SRCS:%.bas=%-bytecode.c10)
NC10S := $(SRCS:%.bas=%-native.c10)
C10S := $(BC10S) $(NC10S)


all: $(ASMS) $(C10S)

%-bytecode.bas: %.bas
	cp $< $@

%-native.bas: %.bas
	cp $< $@


%-bytecode.asm: %-bytecode.bas $(MCBASIC)
	$(MCBASIC) -S $<

%-native.asm: %-native.bas $(MCBASIC)
	$(MCBASIC) -native -S $<


%-bytecode.c10: %-bytecode.bas $(MCBASIC)
	$(MCBASIC) $<

%-native.c10: %-native.bas $(MCBASIC)
	$(MCBASIC) -native $<


clean:
	rm -f *.lst *.obj *.c10 *.asm *-bytecode.bas *-native.bas


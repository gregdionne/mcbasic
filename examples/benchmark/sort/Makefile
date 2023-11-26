MCBASIC ?= ../../../mcbasic

BC10S ?= bsort-hand.c10 bsort-bytecode.c10 bsort-native.c10
QC10S ?= qsort-hand.c10 qsort-bytecode.c10 qsort-native.c10
CC10S ?= csort-hand.c10 csort-bytecode.c10 csort-native.c10

BASMS ?= bsort-bytecode.asm bsort-native.asm
QASMS ?= qsort-bytecode.asm qsort-native.asm
CASMS ?= csort-bytecode.asm csort-native.asm

MCBASICFLAGS ?=

all: $(BC10S) $(QC10S) $(CC10S) $(BASMS) $(QASMS) $(CASMS)

%-hand.c10: %-hand.asm
	$(MCBASIC) $<


%-bytecode.bas: %.bas
	cp $< $@

%-native.bas: %.bas
	cp $< $@


%-bytecode.asm: %-bytecode.bas $(MCBASIC)
	$(MCBASIC) -S $<

%-native.asm: %-native.bas $(MCBASIC)
	$(MCBASIC) -native -S $<


%-bytecode.c10: %-bytecode.bas $(MCBASIC)
	$(MCBASIC) $(MCBASICFLAGS) $<

%-native.c10: %-native.bas $(MCBASIC)
	$(MCBASIC) -native $(MCBASICFLAGS) $<


clean:
	rm -f *.lst *.obj *.c10 *-bytecode.asm *-native.asm *-native.bas *-bytecode.bas


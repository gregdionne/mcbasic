MCBASIC ?= ../../mcbasic
SRCS := $(shell find . -name \*.bas)
ASMS := $(SRCS:%.bas=%.asm)
C10S := $(SRCS:%.bas=%.c10)

MCBASICFLAGS ?=

all: $(ASMS) $(C10S)

%.c10: %.bas $(MCBASIC)
	$(MCBASIC) -native $(MCBASICFLAGS) $<

%.asm: %.bas $(MCBASIC)
	$(MCBASIC) -native -S $<

clean:
	$(RM) -f *.lst *.obj *.c10 *.asm


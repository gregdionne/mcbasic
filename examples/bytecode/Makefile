MCBASIC ?= ../../mcbasic
SRCS := $(shell find . -name \*.bas)
ASMS := $(SRCS:%.bas=%.asm)
C10S := $(SRCS:%.bas=%.c10)

MCBASICFLAGS ?=

all: $(ASMS) $(C10S)

%.c10: %.bas $(MCBAIC)
	$(MCBASIC) $(MCBASICFLAGS) $<

%.asm: %.bas $(MCBASIC)
	$(MCBASIC) -S $<

clean:
	$(RM) -f *.lst *.obj *.c10 *.asm


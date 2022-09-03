MCBASIC ?= ../../mcbasic
SRCS := $(shell find . -name \*.bas)
ASMS := $(SRCS:%.bas=%.asm)
C10S := $(SRCS:%.bas=%.c10)

all: $(ASMS) $(C10S)

%.c10: %.asm
	tasm $<

%.asm: %.bas $(MCBASIC)
	$(MCBASIC) -native $<

clean:
	$(RM) -f *.lst *.obj *.c10 *.asm


MCBASIC := ../../mcbasic
SRCS := $(shell find . -name \*.bas)
ASMS := $(SRCS:%.bas=%.asm)
C10S := $(SRCS:%.bas=%.c10)

all: $(ASMS) $(C10S)

%.c10: %.asm
	tasm $<

# if you don't have mcbasic in your path
# then use $(MCBASIC) for the command instead of mcbasic

%.asm: %.bas $(MCBASIC)
	mcbasic -native $<

clean:
	$(RM) -f *.lst *.obj *.c10 *.asm


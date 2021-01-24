src      := src
examples := examples
tests    := tests
targets  := $(examples) $(tests)

cleansrc      := $(addsuffix .clean, $(src))
cleantargets  := $(addsuffix .clean, $(targets))

.PHONY: all $(src) (targets)

all: $(targets)

$(targets) $(src):
	$(MAKE) -C $@

$(targets): $(src)

clean: $(cleansrc) $(cleantargets)

$(cleansrc) $(cleantargets):
	$(MAKE) -C $(basename $@) clean


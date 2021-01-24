makes    := $(shell find . -mindepth 2 -name Makefile) 
dirs     := $(dir $(makes))
dirclean := $(addsuffix .clean, $(dirs))

.PHONY: all $(dirs)

all: $(dirs)

$(dirs):
	$(MAKE) -C $@

$(dirclean):
	$(MAKE) -C $(basename $@) clean

clean: $(dirclean)
	echo "cleaning complete: " $(dirs)

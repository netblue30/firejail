.SUFFIXES:
MAKEFLAGS += -r

ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: _firejail

_firejail: _firejail.in $(ROOT)/config.mk
	gawk -f ../man/preproc.awk -- $(MANFLAGS) < $< > $@.tmp
	sed "s|_SYSCONFDIR_|$(sysconfdir)|" < $@.tmp > $@
	rm $@.tmp

.PHONY: clean
clean:
	rm -fr _firejail

.PHONY: distclean
distclean: clean

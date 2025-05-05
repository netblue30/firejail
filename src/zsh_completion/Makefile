.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

GAWK ?= gawk
RM ?= rm -f

.PHONY: all
all: _firejail

_firejail: _firejail.in $(ROOT)/config.mk
	$(GAWK) -f ../man/preproc.awk -- $(MANFLAGS) < $< > $@.tmp
	sed "s|@sysconfdir@|$(sysconfdir)|" < $@.tmp > $@
	$(RM) $@.tmp

.PHONY: clean
clean:
	$(RM) -r _firejail

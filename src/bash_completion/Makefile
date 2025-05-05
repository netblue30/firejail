.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

GAWK ?= gawk
RM ?= rm -f

.PHONY: all
all: firejail.bash_completion

firejail.bash_completion: firejail.bash_completion.in $(ROOT)/config.mk
	$(GAWK) -f ../man/preproc.awk -- $(MANFLAGS) < $< > $@.tmp
	sed "s|@sysconfdir@|$(sysconfdir)|" < $@.tmp > $@
	$(RM) $@.tmp

.PHONY: clean
clean:
	$(RM) -r firejail.bash_completion

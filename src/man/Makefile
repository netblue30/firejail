.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: firecfg.man firejail.man firejail-login.man firejail-users.man firejail-profile.man firemon.man jailcheck.man

%.man: %.txt $(ROOT)/config.mk
	gawk -f ./preproc.awk -- $(MANFLAGS) < $< > $@

.PHONY: clean
clean:; rm -fr *.man

.PHONY: distclean
distclean: clean

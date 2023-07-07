.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

all: firecfg.1.gz firejail.1.gz firejail-login.5.gz firejail-users.5.gz firejail-profile.5.gz firemon.1.gz jailcheck.1.gz

#firecfg.1.gz: firecfg.txt
#	gawk -f ./preproc.awk -- $(MANFLAGS) < $< > firecfg.1
#	./mkman.sh $(VERSION) firecfg.1
#	gzip -n9 firecfg.1

# a small function to build a manpage
define build
	gawk -f ./preproc.awk -- $(MANFLAGS) < $1 > $2
	./mkman.sh $(VERSION) ./$2
	rm -f $2.gz
	gzip -n9 $2
endef

firecfg.1.gz: firecfg.txt
	$(call build,firecfg.txt,firecfg.1)

firejail.1.gz: firejail.txt
	$(call build,firejail.txt,firejail.1)

firejail-login.5.gz: firejail-login.txt
	$(call build,firejail-login.txt,firejail-login.5)

firejail-users.5.gz: firejail-users.txt
	$(call build,firejail-users.txt,firejail-users.5)

firejail-profile.5.gz: firejail-profile.txt
	$(call build,firejail-profile.txt,firejail-profile.5)

firemon.1.gz: firemon.txt
	$(call build,firemon.txt,firemon.1)

jailcheck.1.gz: jailcheck.txt
	$(call build,jailcheck.txt,jailcheck.1)


.PHONY: clean
clean:; rm -fr *.1 *.5 *.gz

.PHONY: distclean
distclean: clean

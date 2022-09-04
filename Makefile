-include config.mk

ifneq ($(HAVE_MAN),no)
MAN_TARGET = man
MAN_SRC = src/man
endif

COMPLETIONDIRS = src/zsh_completion src/bash_completion

.PHONY: all
all: all_items mydirs $(MAN_TARGET) filters
APPS = src/firecfg/firecfg src/firejail/firejail src/firemon/firemon src/profstats/profstats src/jailcheck/jailcheck
SBOX_APPS = src/fbuilder/fbuilder src/ftee/ftee src/fids/fids
SBOX_APPS_NON_DUMPABLE = src/fcopy/fcopy src/fldd/fldd src/fnet/fnet src/fnetfilter/fnetfilter src/fzenity/fzenity
SBOX_APPS_NON_DUMPABLE += src/fsec-optimize/fsec-optimize src/fsec-print/fsec-print src/fseccomp/fseccomp
SBOX_APPS_NON_DUMPABLE += src/fnettrace/fnettrace src/fnettrace-dns/fnettrace-dns src/fnettrace-sni/fnettrace-sni
MYDIRS = src/lib $(MAN_SRC) $(COMPLETIONDIRS)
MYLIBS = src/libpostexecseccomp/libpostexecseccomp.so src/libtrace/libtrace.so src/libtracelog/libtracelog.so
COMPLETIONS = src/zsh_completion/_firejail src/bash_completion/firejail.bash_completion
MANPAGES = firejail.1 firemon.1 firecfg.1 firejail-profile.5 firejail-login.5 firejail-users.5 jailcheck.1
SECCOMP_FILTERS = seccomp seccomp.debug seccomp.32 seccomp.block_secondary seccomp.mdwx seccomp.mdwx.32
ALL_ITEMS = $(APPS) $(SBOX_APPS) $(SBOX_APPS_NON_DUMPABLE) $(MYLIBS)

config.mk config.sh:
	printf 'run ./configure to generate %s\n' "$@" >&2
	false

.PHONY: all_items $(ALL_ITEMS)
all_items: $(ALL_ITEMS)
$(ALL_ITEMS): $(MYDIRS)
	$(MAKE) -C $(dir $@)

.PHONY: mydirs $(MYDIRS)
mydirs: $(MYDIRS)
$(MYDIRS):
	$(MAKE) -C $@

$(MANPAGES): src/man config.mk
	./mkman.sh $(VERSION) src/man/$(basename $@).man $@

man: $(MANPAGES)

filters: $(SECCOMP_FILTERS) $(SBOX_APPS_NON_DUMPABLE)
seccomp: src/fseccomp/fseccomp src/fsec-optimize/fsec-optimize
	src/fseccomp/fseccomp default seccomp
	src/fsec-optimize/fsec-optimize seccomp

seccomp.debug: src/fseccomp/fseccomp src/fsec-optimize/fsec-optimize
	src/fseccomp/fseccomp default seccomp.debug allow-debuggers
	src/fsec-optimize/fsec-optimize seccomp.debug

seccomp.32: src/fseccomp/fseccomp src/fsec-optimize/fsec-optimize
	src/fseccomp/fseccomp secondary 32 seccomp.32
	src/fsec-optimize/fsec-optimize seccomp.32

seccomp.block_secondary: src/fseccomp/fseccomp
	src/fseccomp/fseccomp secondary block seccomp.block_secondary

seccomp.mdwx: src/fseccomp/fseccomp
	src/fseccomp/fseccomp memory-deny-write-execute seccomp.mdwx

seccomp.mdwx.32: src/fseccomp/fseccomp
	src/fseccomp/fseccomp memory-deny-write-execute.32 seccomp.mdwx.32

.PHONY: clean
clean:
	for dir in $$(dirname $(ALL_ITEMS)) $(MYDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	$(MAKE) -C test clean
	rm -f $(MANPAGES) $(MANPAGES:%=%.gz) firejail*.rpm
	rm -f $(SECCOMP_FILTERS)
	rm -f test/utils/index.html*
	rm -f test/utils/wget-log
	rm -f test/utils/firejail-test-file*
	rm -f test/utils/lstesting
	rm -f test/environment/index.html*
	rm -f test/environment/wget-log*
	rm -fr test/environment/-testdir
	rm -f test/environment/logfile*
	rm -f test/environment/index.html
	rm -f test/environment/wget-log
	rm -f test/sysutils/firejail_t*
	cd test/compile; ./compile.sh --clean; cd ../..

.PHONY: distclean
distclean: clean
	for dir in $$(dirname $(ALL_ITEMS)) $(MYDIRS); do \
		$(MAKE) -C $$dir distclean; \
	done
	$(MAKE) -C test distclean
	rm -fr autom4te.cache config.log config.mk config.sh config.status

realinstall: config.mk
	# firejail executable
	install -m 0755 -d $(DESTDIR)$(bindir)
	install -m 0755 src/firejail/firejail $(DESTDIR)$(bindir)
ifeq ($(HAVE_SUID),-DHAVE_SUID)
	chmod u+s $(DESTDIR)$(bindir)/firejail
endif
	# firemon executable
	install -m 0755 src/firemon/firemon $(DESTDIR)$(bindir)
	# firecfg executable
	install -m 0755 src/firecfg/firecfg $(DESTDIR)$(bindir)
	# jailcheck executable
	install -m 0755 src/jailcheck/jailcheck $(DESTDIR)$(bindir)
	# libraries and plugins
	install -m 0755 -d $(DESTDIR)$(libdir)/firejail
	install -m 0755 -t $(DESTDIR)$(libdir)/firejail src/firecfg/firejail-welcome.sh
	install -m 0644 -t $(DESTDIR)$(libdir)/firejail $(MYLIBS) $(SECCOMP_FILTERS)
	install -m 0755 -t $(DESTDIR)$(libdir)/firejail $(SBOX_APPS)
	install -m 0755 -t $(DESTDIR)$(libdir)/firejail src/profstats/profstats
	# plugins w/o read permission (non-dumpable)
	install -m 0711 -t $(DESTDIR)$(libdir)/firejail $(SBOX_APPS_NON_DUMPABLE)
	install -m 0711 -t $(DESTDIR)$(libdir)/firejail src/fshaper/fshaper.sh
	install -m 0644 -t $(DESTDIR)$(libdir)/firejail src/fnettrace/static-ip-map
ifeq ($(HAVE_CONTRIB_INSTALL),yes)
	# contrib scripts
	install -m 0755 -t $(DESTDIR)$(libdir)/firejail contrib/*.py contrib/*.sh
	# vim syntax
	install -m 0755 -d $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect
	install -m 0755 -d $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax
	install -m 0644 contrib/vim/ftdetect/firejail.vim $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect
	install -m 0644 contrib/vim/syntax/firejail.vim $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax
endif
	# documents
	install -m 0755 -d $(DESTDIR)$(docdir)
	install -m 0644 -t $(DESTDIR)$(docdir) COPYING README RELNOTES etc/templates/*
	# profiles and settings
	install -m 0755 -d $(DESTDIR)$(sysconfdir)/firejail
	install -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail src/firecfg/firecfg.config
	install -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail etc/profile-a-l/*.profile etc/profile-m-z/*.profile etc/inc/*.inc etc/net/*.net etc/firejail.config
	sh -c "if [ ! -f $(DESTDIR)/$(sysconfdir)/firejail/login.users ]; then install -c -m 0644 etc/login.users $(DESTDIR)/$(sysconfdir)/firejail/.; fi;"
ifeq ($(HAVE_IDS),-DHAVE_IDS)
	install -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail etc/ids.config
endif
ifeq ($(BUSYBOX_WORKAROUND),yes)
	./mketc.sh $(DESTDIR)$(sysconfdir)/firejail/disable-common.inc
endif
ifeq ($(HAVE_APPARMOR),-DHAVE_APPARMOR)
	# install apparmor profile
	sh -c "if [ ! -d $(DESTDIR)/$(sysconfdir)/apparmor.d ]; then install -d -m 755 $(DESTDIR)/$(sysconfdir)/apparmor.d; fi;"
	install -m 0644 etc/apparmor/firejail-default $(DESTDIR)$(sysconfdir)/apparmor.d
	# install apparmor profile customization file
	sh -c "if [ ! -d $(DESTDIR)/$(sysconfdir)/apparmor.d/local ]; then install -d -m 755 $(DESTDIR)/$(sysconfdir)/apparmor.d/local; fi;"
	sh -c "if [ ! -f $(DESTDIR)/$(sysconfdir)/apparmor.d/local/firejail-default ]; then install -c -m 0644 etc/apparmor/firejail-local $(DESTDIR)/$(sysconfdir)/apparmor.d/local/firejail-default; fi;"
	# install apparmor base abstraction drop-in
	sh -c "if [ ! -d $(DESTDIR)/$(sysconfdir)/apparmor.d/abstractions ]; then install -d -m 755 $(DESTDIR)/$(sysconfdir)/apparmor.d/abstractions; fi;"
	sh -c "if [ ! -d $(DESTDIR)/$(sysconfdir)/apparmor.d/abstractions/base.d ]; then install -d -m 755 $(DESTDIR)/$(sysconfdir)/apparmor.d/abstractions/base.d; fi;"
	install -m 0644 etc/apparmor/firejail-base $(DESTDIR)$(sysconfdir)/apparmor.d/abstractions/base.d
endif
ifneq ($(HAVE_MAN),no)
	# man pages
	install -m 0755 -d $(DESTDIR)$(mandir)/man1 $(DESTDIR)$(mandir)/man5
	for man in $(MANPAGES); do \
		rm -f $$man.gz; \
		gzip -9n $$man; \
		case "$$man" in \
			*.1) install -m 0644 $$man.gz $(DESTDIR)$(mandir)/man1/; ;; \
			*.5) install -m 0644 $$man.gz $(DESTDIR)$(mandir)/man5/; ;; \
		esac; \
	done
	rm -f $(MANPAGES) $(MANPAGES:%=%.gz)
endif
	# bash completion
	install -m 0755 -d $(DESTDIR)$(datarootdir)/bash-completion/completions
	install -m 0644 src/bash_completion/firejail.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firejail
	install -m 0644 src/bash_completion/firemon.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firemon
	install -m 0644 src/bash_completion/firecfg.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firecfg
	# zsh completion
	install -m 0755 -d $(DESTDIR)$(datarootdir)/zsh/site-functions
	install -m 0644 src/zsh_completion/_firejail $(DESTDIR)$(datarootdir)/zsh/site-functions/

install: all
	$(MAKE) realinstall

install-strip: all
	strip $(ALL_ITEMS)
	$(MAKE) realinstall

uninstall: config.mk
	rm -f $(DESTDIR)$(bindir)/firejail
	rm -f $(DESTDIR)$(bindir)/firemon
	rm -f $(DESTDIR)$(bindir)/firecfg
	rm -f $(DESTDIR)$(bindir)/jailcheck
	rm -fr $(DESTDIR)$(libdir)/firejail
	rm -fr $(DESTDIR)$(datarootdir)/doc/firejail
	for man in $(MANPAGES); do \
		rm -f $(DESTDIR)$(mandir)/man5/$$man*; \
		rm -f $(DESTDIR)$(mandir)/man1/$$man*; \
	done
	rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/firejail
	rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/firemon
	rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/firecfg
	rm -f $(DESTDIR)$(datarootdir)/zsh/site-functions/_firejail
	rm -f $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect/firejail.vim
	rm -f $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax/firejail.vim
	@echo "If you want to install a different version of firejail, you might also need to run 'rm -fr $(DESTDIR)$(sysconfdir)/firejail', see #2038."

DISTFILES = \
COPYING \
Makefile \
README \
RELNOTES \
config.mk.in \
config.sh.in \
configure \
configure.ac \
contrib \
etc \
install.sh \
m4 \
mkdeb.sh \
mketc.sh \
mkman.sh \
platform \
src

DISTFILES_TEST = test/Makefile test/apps test/apps-x11 test/apps-x11-xorg test/root test/private-lib test/fnetfilter test/fcopy test/environment test/profiles test/utils test/compile test/filters test/network test/fs test/sysutils test/chroot

dist: config.mk
	mv config.sh config.sh.old
	mv config.status config.status.old
	make distclean
	mv config.status.old config.status
	mv config.sh.old config.sh
	rm -fr $(TARNAME)-$(VERSION) $(TARNAME)-$(VERSION).tar.xz
	mkdir -p $(TARNAME)-$(VERSION)/test
	cp -a $(DISTFILES) $(TARNAME)-$(VERSION)
	cp -a $(DISTFILES_TEST) $(TARNAME)-$(VERSION)/test
	rm -rf $(TARNAME)-$(VERSION)/src/tools
	find $(TARNAME)-$(VERSION) -name .svn -delete
	tar -cJvf $(TARNAME)-$(VERSION).tar.xz $(TARNAME)-$(VERSION)
	rm -fr $(TARNAME)-$(VERSION)

asc: config.mk
	./mkasc.sh $(VERSION)

deb: dist config.sh
	./mkdeb.sh

deb-apparmor: dist config.sh
	./mkdeb.sh -apparmor --enable-apparmor

test-compile: dist config.mk
	cd test/compile; ./compile.sh $(TARNAME)-$(VERSION)

.PHONY: rpms
rpms: src/man config.mk
	./platform/rpm/mkrpm.sh $(TARNAME) $(VERSION)

extras: all
	$(MAKE) -C extras/firetools

cppcheck: clean
	cppcheck --force --error-exitcode=1 --enable=warning,performance .

scan-build: clean
	NO_EXTRA_CFLAGS="yes" scan-build make

#
# make test
#

TESTS=profiles private-lib apps apps-x11 apps-x11-xorg sysutils utils environment filters fs fcopy fnetfilter
TEST_TARGETS=$(patsubst %,test-%,$(TESTS))

$(TEST_TARGETS):
	$(MAKE) -C test $(subst test-,,$@)

test: test-profiles test-private-lib test-fcopy test-fnetfilter test-fs test-utils test-sysutils test-environment test-apps test-apps-x11 test-apps-x11-xorg test-filters
	echo "TEST COMPLETE"

test-noprofiles: test-private-lib test-fcopy test-fnetfilter test-fs test-utils test-sysutils test-environment test-apps test-apps-x11 test-apps-x11-xorg test-filters
	echo "TEST COMPLETE"

test-github: test-profiles test-fcopy test-fnetfilter test-fs test-utils test-sysutils test-environment
	echo "TEST COMPLETE"

##########################################
# Individual tests, some of them require root access
# The tests are very intrusive, by the time you are done
# with them you will need to restart your computer.
##########################################

# a firejail-test account is required, public/private key setup
test-ssh:
	$(MAKE) -C test $(subst test-,,$@)

# requires root access
test-chroot:
	$(MAKE) -C test $(subst test-,,$@)

# Huge appimage files, not included in "make dist" archive
test-appimage:
	$(MAKE) -C test $(subst test-,,$@)

# Root access, network devices are created before the test
# restart your computer to get rid of these devices
test-network:
	$(MAKE) -C test $(subst test-,,$@)

# requires the same setup as test-network
test-stress:
	$(MAKE) -C test $(subst test-,,$@)

# Tests running a root user
test-root:
	$(MAKE) -C test $(subst test-,,$@)

# OverlayFS is not available on all platforms
test-overlay:
	$(MAKE) -C test $(subst test-,,$@)

# For testing hidepid system, the command to set it up is "mount -o remount,rw,hidepid=2 /proc"

test-all: test-root test-chroot test-network test-appimage test-overlay
	echo "TEST COMPLETE"

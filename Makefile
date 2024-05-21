.SUFFIXES:
ROOT = .
-include config.mk

# Default programs (in configure.ac).
CC ?= cc
CODESPELL ?= codespell
CPPCHECK ?= cppcheck
GAWK ?= gawk
GZIP ?= gzip
SCAN_BUILD ?= scan-build
STRIP ?= strip
TAR ?= tar

# Default programs (not in configure.ac).
INSTALL ?= install
RM ?= rm -f

ifneq ($(HAVE_MAN),no)
MAN_TARGET = man
endif

ifneq ($(HAVE_CONTRIB_INSTALL),no)
CONTRIB_TARGET = contrib
endif

COMPLETIONDIRS = src/zsh_completion src/bash_completion

APPS = src/firecfg/firecfg src/firejail/firejail src/firemon/firemon src/profstats/profstats src/jailcheck/jailcheck src/etc-cleanup/etc-cleanup
SBOX_APPS = src/fbuilder/fbuilder src/ftee/ftee src/fids/fids
SBOX_APPS_NON_DUMPABLE = src/fcopy/fcopy src/fldd/fldd src/fnet/fnet src/fnetfilter/fnetfilter src/fzenity/fzenity
SBOX_APPS_NON_DUMPABLE += src/fsec-optimize/fsec-optimize src/fsec-print/fsec-print src/fseccomp/fseccomp
SBOX_APPS_NON_DUMPABLE += src/fnettrace/fnettrace src/fnettrace-dns/fnettrace-dns src/fnettrace-sni/fnettrace-sni
SBOX_APPS_NON_DUMPABLE += src/fnettrace-icmp/fnettrace-icmp src/fnetlock/fnetlock
MYDIRS = src/lib $(COMPLETIONDIRS)
MYLIBS = src/libpostexecseccomp/libpostexecseccomp.so src/libtrace/libtrace.so src/libtracelog/libtracelog.so
COMPLETIONS = src/zsh_completion/_firejail src/bash_completion/firejail.bash_completion
SECCOMP_FILTERS = seccomp seccomp.debug seccomp.32 seccomp.block_secondary seccomp.mdwx seccomp.mdwx.32 seccomp.namespaces seccomp.namespaces.32

MANPAGES1_IN := $(sort $(wildcard src/man/*.1.in))
MANPAGES5_IN := $(sort $(wildcard src/man/*.5.in))
MANPAGES1_GZ := $(MANPAGES1_IN:.in=.gz)
MANPAGES5_GZ := $(MANPAGES5_IN:.in=.gz)

SYSCALL_HEADERS := $(sort $(wildcard src/include/syscall*.h))

# Lists of keywords used in profiles; used for generating syntax files.
SYNTAX_LISTS = \
	contrib/syntax/lists/profile_commands_arg0.list \
	contrib/syntax/lists/profile_commands_arg1.list \
	contrib/syntax/lists/profile_conditionals.list \
	contrib/syntax/lists/profile_macros.list \
	contrib/syntax/lists/syscall_groups.list \
	contrib/syntax/lists/syscalls.list \
	contrib/syntax/lists/system_errnos.list

SYNTAX_FILES_IN := $(sort $(wildcard contrib/syntax/files/*.in))
SYNTAX_FILES := $(SYNTAX_FILES_IN:.in=)

ALL_ITEMS = $(APPS) $(SBOX_APPS) $(SBOX_APPS_NON_DUMPABLE) $(MYLIBS)

.PHONY: all
all: all_items mydirs filters $(MAN_TARGET) $(CONTRIB_TARGET)

config.mk config.sh:
	@printf 'error: run ./configure to generate %s\n' "$@" >&2
	@false

.PHONY: all_items
all_items: $(ALL_ITEMS)
$(ALL_ITEMS): $(MYDIRS)
	$(MAKE) -C $(dir $@)

.PHONY: mydirs $(MYDIRS)
mydirs: $(MYDIRS)
$(MYDIRS):
	$(MAKE) -C $@

.PHONY: strip
strip: all
	$(STRIP) $(ALL_ITEMS)

.PHONY: filters
filters: $(SECCOMP_FILTERS)
seccomp: src/fseccomp/fseccomp src/fsec-optimize/fsec-optimize Makefile
	src/fseccomp/fseccomp default seccomp
	src/fsec-optimize/fsec-optimize seccomp

seccomp.debug: src/fseccomp/fseccomp src/fsec-optimize/fsec-optimize Makefile
	src/fseccomp/fseccomp default seccomp.debug allow-debuggers
	src/fsec-optimize/fsec-optimize seccomp.debug

seccomp.32: src/fseccomp/fseccomp src/fsec-optimize/fsec-optimize Makefile
	src/fseccomp/fseccomp secondary 32 seccomp.32
	src/fsec-optimize/fsec-optimize seccomp.32

seccomp.block_secondary: src/fseccomp/fseccomp Makefile
	src/fseccomp/fseccomp secondary block seccomp.block_secondary

seccomp.mdwx: src/fseccomp/fseccomp Makefile
	src/fseccomp/fseccomp memory-deny-write-execute seccomp.mdwx

seccomp.mdwx.32: src/fseccomp/fseccomp Makefile
	src/fseccomp/fseccomp memory-deny-write-execute.32 seccomp.mdwx.32

seccomp.namespaces: src/fseccomp/fseccomp Makefile
	src/fseccomp/fseccomp restrict-namespaces seccomp.namespaces cgroup,ipc,net,mnt,pid,time,user,uts

seccomp.namespaces.32: src/fseccomp/fseccomp Makefile
	src/fseccomp/fseccomp restrict-namespaces seccomp.namespaces.32 cgroup,ipc,net,mnt,pid,time,user,uts

.PHONY: man
man:
	$(MAKE) -C src/man

# Makes all targets in contrib/
.PHONY: contrib
contrib: syntax

.PHONY: syntax
syntax: $(SYNTAX_FILES)

# TODO: include/rlimit are false positives
contrib/syntax/lists/profile_commands_arg0.list: src/firejail/profile.c Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@sed -En 's/.*strn?cmp\(ptr, "([^ "]*[^ ])".*/\1/p' $< | \
	grep -Ev '^(include|rlimit)$$' | LC_ALL=C sort -u >$@

# TODO: private-lib is special-cased in the code and doesn't match the regex
contrib/syntax/lists/profile_commands_arg1.list: src/firejail/profile.c Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@{ sed -En 's/.*strn?cmp\(ptr, "([^"]+) .*/\1/p' $<; \
	   echo private-lib; } | LC_ALL=C sort -u >$@

contrib/syntax/lists/profile_conditionals.list: src/firejail/profile.c Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@awk -- 'BEGIN {process=0;} /^Cond conditionals\[\] = \{$$/ {process=1;} \
		/\t*\{"[^"]+".*/ \
		{ if (process) {print gensub(/^\t*\{"([^"]+)".*$$/, "\\1", 1);} } \
		/^\t\{ NULL, NULL \}$$/ {process=0;}' \
		$< | LC_ALL=C sort -u >$@

contrib/syntax/lists/profile_macros.list: src/firejail/macros.c Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@sed -En 's/.*\$$\{([^}]+)\}.*/\1/p' $< | LC_ALL=C sort -u >$@

contrib/syntax/lists/syscall_groups.list: src/lib/syscall.c Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@sed -En 's/.*"@([^",]+).*/\1/p' $< | LC_ALL=C sort -u >$@

contrib/syntax/lists/syscalls.list: $(SYSCALL_HEADERS) Makefile
	@printf 'Generating %s\n' $@
	@sed -n 's/{\s\+"\([^"]\+\)",.*},/\1/p' $(SYSCALL_HEADERS) | \
	LC_ALL=C sort -u >$@

contrib/syntax/lists/system_errnos.list: src/lib/errno.c Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@sed -En 's/.*"(E[^"]+).*/\1/p' $< | LC_ALL=C sort -u >$@

regex_fromlf = { tr '\n' '|' | sed -e 's/|$$//' -e 's/\./\\\\./g'; }
space_fromlf = { tr '\n' ' ' | sed -e 's/ $$//'; }
edit_syntax_file = sed \
	-e "s/@make_input@/$$(basename $@).  Generated from $$(basename $<) by make./" \
	-e "s/@FJ_PROFILE_COMMANDS_ARG0@/$$($(regex_fromlf) <contrib/syntax/lists/profile_commands_arg0.list)/" \
	-e "s/@FJ_PROFILE_COMMANDS_ARG1@/$$($(regex_fromlf) <contrib/syntax/lists/profile_commands_arg1.list)/" \
	-e "s/@FJ_PROFILE_CONDITIONALS@/$$($(regex_fromlf) <contrib/syntax/lists/profile_conditionals.list)/" \
	-e "s/@FJ_PROFILE_MACROS@/$$($(regex_fromlf) <contrib/syntax/lists/profile_macros.list)/" \
	-e "s/@FJ_SYSCALLS@/$$($(space_fromlf) <contrib/syntax/lists/syscalls.list)/" \
	-e "s/@FJ_SYSCALL_GROUPS@/$$($(regex_fromlf) <contrib/syntax/lists/syscall_groups.list)/" \
	-e "s/@FJ_SYSTEM_ERRNOS@/$$($(regex_fromlf) <contrib/syntax/lists/system_errnos.list)/"

contrib/syntax/files/example: contrib/syntax/files/example.in $(SYNTAX_LISTS) Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@$(edit_syntax_file) $< >$@

# gtksourceview language-specs
contrib/syntax/files/%.lang: contrib/syntax/files/%.lang.in $(SYNTAX_LISTS) Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@$(edit_syntax_file) $< >$@

# vim syntax files
contrib/syntax/files/%.vim: contrib/syntax/files/%.vim.in $(SYNTAX_LISTS) Makefile
	@printf 'Generating %s from %s\n' $@ $<
	@$(edit_syntax_file) $< >$@

.PHONY: clean
clean:
	for dir in $$(dirname $(ALL_ITEMS)) $(MYDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	$(MAKE) -C src/man clean
	$(MAKE) -C test clean
	$(RM) $(SECCOMP_FILTERS)
	$(RM) $(SYNTAX_FILES)
	$(RM) -r ./$(TARNAME)-$(VERSION) ./$(TARNAME)-$(VERSION).tar.xz
	$(RM) ./$(TARNAME)*.deb
	$(RM) ./$(TARNAME)*.rpm

.PHONY: distclean
distclean: clean
	$(RM) -r autom4te.cache config.log config.mk config.sh config.status

.PHONY: install
install: all config.mk
	# firejail executable
	$(INSTALL) -m 0755 -d $(DESTDIR)$(bindir)
	$(INSTALL) -m 0755 -t $(DESTDIR)$(bindir) src/firejail/firejail
ifeq ($(HAVE_SUID),-DHAVE_SUID)
	chmod u+s $(DESTDIR)$(bindir)/firejail
endif
	# firemon executable
	$(INSTALL) -m 0755 -t $(DESTDIR)$(bindir) src/firemon/firemon
	# firecfg executable
	$(INSTALL) -m 0755 -t $(DESTDIR)$(bindir) src/firecfg/firecfg
	# jailcheck executable
	$(INSTALL) -m 0755 -t $(DESTDIR)$(bindir) src/jailcheck/jailcheck
	# libraries and plugins
	$(INSTALL) -m 0755 -d $(DESTDIR)$(libdir)/firejail
	$(INSTALL) -m 0755 -t $(DESTDIR)$(libdir)/firejail src/firecfg/firejail-welcome.sh
	$(INSTALL) -m 0644 -t $(DESTDIR)$(libdir)/firejail $(MYLIBS) $(SECCOMP_FILTERS)
	$(INSTALL) -m 0755 -t $(DESTDIR)$(libdir)/firejail $(SBOX_APPS)
	$(INSTALL) -m 0755 -t $(DESTDIR)$(libdir)/firejail src/profstats/profstats
	$(INSTALL) -m 0755 -t $(DESTDIR)$(libdir)/firejail src/etc-cleanup/etc-cleanup
	# plugins w/o read permission (non-dumpable)
	$(INSTALL) -m 0711 -t $(DESTDIR)$(libdir)/firejail $(SBOX_APPS_NON_DUMPABLE)
	$(INSTALL) -m 0711 -t $(DESTDIR)$(libdir)/firejail src/fshaper/fshaper.sh
	$(INSTALL) -m 0644 -t $(DESTDIR)$(libdir)/firejail src/fnettrace/static-ip-map
ifeq ($(HAVE_CONTRIB_INSTALL),yes)
	# contrib scripts
	$(INSTALL) -m 0755 -t $(DESTDIR)$(libdir)/firejail contrib/*.py contrib/*.sh
	# vim syntax
	$(INSTALL) -m 0755 -d $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect
	$(INSTALL) -m 0755 -d $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax
	$(INSTALL) -m 0644 -t $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect contrib/vim/ftdetect/firejail.vim
	$(INSTALL) -m 0644 -t $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax contrib/syntax/files/firejail.vim
	# gtksourceview language-specs
	$(INSTALL) -m 0755 -d $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs
	$(INSTALL) -m 0644 -t $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs contrib/syntax/files/firejail-profile.lang
endif
	# documents
	$(INSTALL) -m 0755 -d $(DESTDIR)$(docdir)
	$(INSTALL) -m 0644 -t $(DESTDIR)$(docdir) COPYING README RELNOTES etc/templates/*
	# profiles and settings
	$(INSTALL) -m 0755 -d $(DESTDIR)$(sysconfdir)/firejail
	$(INSTALL) -m 0755 -d $(DESTDIR)$(sysconfdir)/firejail/firecfg.d
	$(INSTALL) -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail src/firecfg/firecfg.config
	$(INSTALL) -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail etc/profile-a-l/*.profile etc/profile-m-z/*.profile etc/inc/*.inc etc/net/*.net etc/firejail.config
	sh -c "if [ ! -f $(DESTDIR)$(sysconfdir)/firejail/login.users ]; then \
		$(INSTALL) -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail etc/login.users; \
	fi"
ifeq ($(HAVE_IDS),-DHAVE_IDS)
	$(INSTALL) -m 0644 -t $(DESTDIR)$(sysconfdir)/firejail etc/ids.config
endif
ifeq ($(BUSYBOX_WORKAROUND),yes)
	./mketc.sh $(DESTDIR)$(sysconfdir)/firejail/disable-common.inc
endif
ifeq ($(HAVE_APPARMOR),-DHAVE_APPARMOR)
	# install apparmor profile
	$(INSTALL) -m 0755 -d $(DESTDIR)$(sysconfdir)/apparmor.d
	$(INSTALL) -m 0644 -t $(DESTDIR)$(sysconfdir)/apparmor.d etc/apparmor/firejail-default
	# install apparmor profile customization file
	$(INSTALL) -m 0755 -d $(DESTDIR)$(sysconfdir)/apparmor.d/local
	sh -c "if [ ! -f $(DESTDIR)$(sysconfdir)/apparmor.d/local/firejail-default ]; then \
		$(INSTALL) -m 0644 etc/apparmor/firejail-local $(DESTDIR)$(sysconfdir)/apparmor.d/local/firejail-default; \
	fi"
	# install apparmor base abstraction drop-in
	$(INSTALL) -m 0755 -d $(DESTDIR)$(sysconfdir)/apparmor.d/abstractions/base.d
	$(INSTALL) -m 0644 -t $(DESTDIR)$(sysconfdir)/apparmor.d/abstractions/base.d etc/apparmor/firejail-base
endif
ifneq ($(HAVE_MAN),no)
	# man pages
	$(INSTALL) -m 0755 -d $(DESTDIR)$(mandir)/man1 $(DESTDIR)$(mandir)/man5
	$(INSTALL) -m 0644 -t $(DESTDIR)$(mandir)/man1 $(MANPAGES1_GZ)
	$(INSTALL) -m 0644 -t $(DESTDIR)$(mandir)/man5 $(MANPAGES5_GZ)
endif
	# bash completion
	$(INSTALL) -m 0755 -d $(DESTDIR)$(datarootdir)/bash-completion/completions
	$(INSTALL) -m 0644 src/bash_completion/firejail.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firejail
	$(INSTALL) -m 0644 src/bash_completion/firemon.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firemon
	$(INSTALL) -m 0644 src/bash_completion/firecfg.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firecfg
	# zsh completion
	$(INSTALL) -m 0755 -d $(DESTDIR)$(datarootdir)/zsh/site-functions
	$(INSTALL) -m 0644 -t $(DESTDIR)$(datarootdir)/zsh/site-functions src/zsh_completion/_firejail

.PHONY: install-strip
install-strip: strip install

.PHONY: uninstall
uninstall: config.mk
	$(RM) $(DESTDIR)$(bindir)/firejail
	$(RM) $(DESTDIR)$(bindir)/firemon
	$(RM) $(DESTDIR)$(bindir)/firecfg
	$(RM) $(DESTDIR)$(bindir)/jailcheck
	$(RM) -r $(DESTDIR)$(libdir)/firejail
	$(RM) -r $(DESTDIR)$(datarootdir)/doc/firejail
	$(RM) $(addprefix $(DESTDIR)$(mandir)/man1/,$(notdir $(MANPAGES1_GZ)))
	$(RM) $(addprefix $(DESTDIR)$(mandir)/man5/,$(notdir $(MANPAGES5_GZ)))
	$(RM) $(DESTDIR)$(datarootdir)/bash-completion/completions/firejail
	$(RM) $(DESTDIR)$(datarootdir)/bash-completion/completions/firemon
	$(RM) $(DESTDIR)$(datarootdir)/bash-completion/completions/firecfg
	$(RM) $(DESTDIR)$(datarootdir)/zsh/site-functions/_firejail
	$(RM) $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect/firejail.vim
	$(RM) $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax/firejail.vim
	$(RM) $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs/firejail-profile.lang
	@echo "If you want to install a different version of firejail, you might also need to run 'rm -fr $(DESTDIR)$(sysconfdir)/firejail', see #2038."

# Note: Keep this list in sync with `paths` in .github/workflows/build.yml.
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
	platform \
	src

DISTFILES_TEST = \
	test/Makefile \
	test/apps \
	test/apps-x11 \
	test/apps-x11-xorg \
	test/capabilities \
	test/compile \
	test/environment \
	test/fcopy \
	test/filters \
	test/fnetfilter \
	test/fs \
	test/network \
	test/private-lib \
	test/profiles \
	test/sysutils \
	test/utils

.PHONY: dist
dist: clean config.mk
	mkdir -p $(TARNAME)-$(VERSION)/test
	cp -a $(DISTFILES) $(TARNAME)-$(VERSION)
	cp -a $(DISTFILES_TEST) $(TARNAME)-$(VERSION)/test
	$(RM) -r $(TARNAME)-$(VERSION)/src/tools
	$(TAR) -cJvf $(TARNAME)-$(VERSION).tar.xz $(TARNAME)-$(VERSION)
	$(RM) -r $(TARNAME)-$(VERSION)

.PHONY: asc
asc: config.sh
	./mkasc.sh

.PHONY: deb
deb: dist config.sh
	./mkdeb.sh

.PHONY: test-compile
test-compile: dist config.sh
	cd test/compile; ./compile.sh

.PHONY: rpms
rpms: src/man config.sh
	./platform/rpm/mkrpm.sh

.PHONY: extras
extras: all
	$(MAKE) -C extras/firetools

.PHONY: cppcheck
cppcheck:
	$(CPPCHECK) --force --error-exitcode=1 --enable=warning,performance \
	  -i src/firejail/checkcfg.c -i src/firejail/main.c .

# For cppcheck 1.x; see .github/workflows/check-c.yml
.PHONY: cppcheck-old
cppcheck-old:
	$(CPPCHECK) --force --error-exitcode=1 --enable=warning,performance .

.PHONY: scan-build
scan-build: clean
	$(SCAN_BUILD) --status-bugs $(MAKE)

# TODO: Old codespell versions (such as v2.1.0 in CI) have issues with
# contrib/syscalls.sh
.PHONY: codespell
codespell:
	@printf 'Running %s...\n' $@
	@$(CODESPELL) --ignore-regex 'Manuel|UE|als|chage|creat|doas|ether|isplay|readby|[Ss]hotcut' \
	  -S *.d,*.gz,*.o,*.so \
	  -S COPYING,m4 \
	  -S ./contrib/syscalls.sh \
	  .

.PHONY: print-env
print-env:
	./ci/printenv.sh

.PHONY: print-version
print-version: config.mk
	command -V $(TARNAME) && $(TARNAME) --version

#
# make test
#

TESTS=profiles capabilities apps apps-x11 apps-x11-xorg sysutils utils environment filters fs fcopy fnetfilter private-etc seccomp-extra
TEST_TARGETS=$(patsubst %,test-%,$(TESTS))

$(TEST_TARGETS):
	$(MAKE) -C test $(subst test-,,$@)


# extract some data about the testing setup: kernel, network connectivity, user
.PHONY: lab-setup
lab-setup:; uname -r; ldd --version | grep GLIBC; pwd; whoami; ip addr show; cat /etc/resolv.conf; cat /etc/hosts; ls /etc

.PHONY: test
test: lab-setup test-profiles test-fcopy test-fnetfilter test-fs test-private-etc test-utils test-sysutils test-environment test-apps test-apps-x11 test-apps-x11-xorg test-filters test-seccomp-extra
	echo "TEST COMPLETE"

.PHONY: test-noprofiles
test-noprofiles: lab-setup test-fcopy test-fnetfilter test-fs test-utils test-sysutils test-environment test-apps test-apps-x11 test-apps-x11-xorg test-filters
	echo "TEST COMPLETE"

# not included in "make dist" and "make test"
.PHONY: test-appimage
test-appimage:
	$(MAKE) -C test $(subst test-,,$@)

# using sudo; not included in "make dist" and "make test"
.PHONY: test-chroot
test-chroot:
	$(MAKE) -C test $(subst test-,,$@)

# using sudo; not included in "make dist" and "make test"
.PHONY: test-network
test-network:
	$(MAKE) -C test $(subst test-,,$@)

# using sudo; not included in "make dist" and "make test"
.PHONY: test-apparmor
test-apparmor:
	$(MAKE) -C test $(subst test-,,$@)

# using sudo; not included in "make dist" and "make test"
.PHONY: test-firecfg
test-firecfg:
	$(MAKE) -C test $(subst test-,,$@)


# old gihub test; the new test is driven directly from .github/workflows/build.yml
.PHONY: test-github
test-github: lab-setup test-profiles test-fcopy test-fnetfilter test-fs test-utils test-sysutils test-environment
	echo "TEST COMPLETE"

##########################################
# Individual tests, some of them require root access
# The tests are very intrusive, by the time you are done
# with them you will need to restart your computer.
##########################################
# private-lib is disabled by default in /etc/firejail/firejail.config
.PHONY: test-private-lib
test-private-lib:
	$(MAKE) -C test $(subst test-,,$@)

# Root access, network devices are created before the test
# restart your computer to get rid of these devices

# For testing hidepid system, the command to set it up is "mount -o remount,rw,hidepid=2 /proc"

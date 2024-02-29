.SUFFIXES:
ROOT = .
-include config.mk

# Default programs
CC ?= cc
CODESPELL ?= codespell
CPPCHECK ?= cppcheck
GAWK ?= gawk
SCAN_BUILD ?= scan-build

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
	rm -f $(SECCOMP_FILTERS)
	rm -f $(SYNTAX_FILES)
	rm -fr ./$(TARNAME)-$(VERSION) ./$(TARNAME)-$(VERSION).tar.xz
	rm -f ./$(TARNAME)*.deb
	rm -f ./$(TARNAME)*.rpm

.PHONY: distclean
distclean: clean
	rm -fr autom4te.cache config.log config.mk config.sh config.status

.PHONY: realinstall
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
	install -m 0755 -t $(DESTDIR)$(libdir)/firejail src/etc-cleanup/etc-cleanup
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
	install -m 0644 contrib/syntax/files/firejail.vim $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax
	# gtksourceview language-specs
	install -m 0755 -d $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs
	install -m 0644 contrib/syntax/files/firejail-profile.lang $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs
endif
	# documents
	install -m 0755 -d $(DESTDIR)$(docdir)
	install -m 0644 -t $(DESTDIR)$(docdir) COPYING README RELNOTES etc/templates/*
	# profiles and settings
	install -m 0755 -d $(DESTDIR)$(sysconfdir)/firejail
	install -m 0755 -d $(DESTDIR)$(sysconfdir)/firejail/firecfg.d
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
	install -m 0644 $(MANPAGES1_GZ) $(DESTDIR)$(mandir)/man1/
	install -m 0644 $(MANPAGES5_GZ) $(DESTDIR)$(mandir)/man5/
endif
	# bash completion
	install -m 0755 -d $(DESTDIR)$(datarootdir)/bash-completion/completions
	install -m 0644 src/bash_completion/firejail.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firejail
	install -m 0644 src/bash_completion/firemon.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firemon
	install -m 0644 src/bash_completion/firecfg.bash_completion $(DESTDIR)$(datarootdir)/bash-completion/completions/firecfg
	# zsh completion
	install -m 0755 -d $(DESTDIR)$(datarootdir)/zsh/site-functions
	install -m 0644 src/zsh_completion/_firejail $(DESTDIR)$(datarootdir)/zsh/site-functions/

.PHONY: install
install: all
	$(MAKE) realinstall

.PHONY: install-strip
install-strip: all
	strip $(ALL_ITEMS)
	$(MAKE) realinstall

.PHONY: uninstall
uninstall: config.mk
	rm -f $(DESTDIR)$(bindir)/firejail
	rm -f $(DESTDIR)$(bindir)/firemon
	rm -f $(DESTDIR)$(bindir)/firecfg
	rm -f $(DESTDIR)$(bindir)/jailcheck
	rm -fr $(DESTDIR)$(libdir)/firejail
	rm -fr $(DESTDIR)$(datarootdir)/doc/firejail
	rm -f $(addprefix $(DESTDIR)$(mandir)/man1/,$(notdir $(MANPAGES1_GZ)))
	rm -f $(addprefix $(DESTDIR)$(mandir)/man5/,$(notdir $(MANPAGES5_GZ)))
	rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/firejail
	rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/firemon
	rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/firecfg
	rm -f $(DESTDIR)$(datarootdir)/zsh/site-functions/_firejail
	rm -f $(DESTDIR)$(datarootdir)/vim/vimfiles/ftdetect/firejail.vim
	rm -f $(DESTDIR)$(datarootdir)/vim/vimfiles/syntax/firejail.vim
	rm -f $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs/firejail-profile.lang
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
	rm -rf $(TARNAME)-$(VERSION)/src/tools
	tar -cJvf $(TARNAME)-$(VERSION).tar.xz $(TARNAME)-$(VERSION)
	rm -fr $(TARNAME)-$(VERSION)

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
cppcheck: clean
	$(CPPCHECK) --force --error-exitcode=1 --enable=warning,performance \
	  -i src/firejail/checkcfg.c -i src/firejail/main.c .

# For cppcheck 1.x; see .github/workflows/check-c.yml
.PHONY: cppcheck-old
cppcheck-old: clean
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

.SUFFIXES:
ROOT = .
-include config.mk

ifneq ($(HAVE_CONTRIB_INSTALL),no)
CONTRIB_TARGET = contrib
endif

COMPLETIONDIRS = src/zsh_completion src/bash_completion

APPS = src/firecfg/firecfg src/firejail/firejail src/firemon/firemon src/profstats/profstats src/jailcheck/jailcheck src/etc-cleanup/etc-cleanup
SBOX_APPS = src/fbuilder/fbuilder src/ftee/ftee src/fids/fids
SBOX_APPS_NON_DUMPABLE = src/fcopy/fcopy src/fldd/fldd src/fnet/fnet src/fnetfilter/fnetfilter src/fzenity/fzenity
SBOX_APPS_NON_DUMPABLE += src/fsec-optimize/fsec-optimize src/fsec-print/fsec-print src/fseccomp/fseccomp
SBOX_APPS_NON_DUMPABLE += src/fnettrace/fnettrace src/fnettrace-dns/fnettrace-dns src/fnettrace-sni/fnettrace-sni
SBOX_APPS_NON_DUMPABLE += src/fnettrace-icmp/fnettrace-icmp
MYDIRS = src/lib src/man $(COMPLETIONDIRS)
MYLIBS = src/libpostexecseccomp/libpostexecseccomp.so src/libtrace/libtrace.so src/libtracelog/libtracelog.so
COMPLETIONS = src/zsh_completion/_firejail src/bash_completion/firejail.bash_completion
SECCOMP_FILTERS = seccomp seccomp.debug seccomp.32 seccomp.block_secondary seccomp.mdwx seccomp.mdwx.32 seccomp.namespaces seccomp.namespaces.32

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
all: all_items mydirs $(CONTRIB_TARGET)

config.mk config.sh:
	@printf 'error: run ./configure to generate %s\n' "$@" >&2
	@false

.PHONY: all_items $(ALL_ITEMS)
all_items: $(ALL_ITEMS)
$(ALL_ITEMS): $(MYDIRS)
	$(MAKE) -C $(dir $@)

.PHONY: mydirs $(MYDIRS)
mydirs: $(MYDIRS)
$(MYDIRS):
	$(MAKE) -C $@

define build_filters
	src/fseccomp/fseccomp default seccomp
	src/fsec-optimize/fsec-optimize seccomp
	src/fseccomp/fseccomp default seccomp.debug allow-debuggers
	src/fsec-optimize/fsec-optimize seccomp.debug
	src/fseccomp/fseccomp secondary 32 seccomp.32
	src/fsec-optimize/fsec-optimize seccomp.32
	src/fseccomp/fseccomp secondary block seccomp.block_secondary
	src/fseccomp/fseccomp memory-deny-write-execute seccomp.mdwx
	src/fseccomp/fseccomp memory-deny-write-execute.32 seccomp.mdwx.32
	src/fseccomp/fseccomp restrict-namespaces seccomp.namespaces cgroup,ipc,net,mnt,pid,time,user,uts
	src/fseccomp/fseccomp restrict-namespaces seccomp.namespaces.32 cgroup,ipc,net,mnt,pid,time,user,uts
endef



# Makes all targets in contrib/
.PHONY: contrib
contrib: syntax

.PHONY: syntax
syntax: $(SYNTAX_FILES)

# TODO: include/rlimit are false positives
contrib/syntax/lists/profile_commands_arg0.list: src/firejail/profile.c
	@sed -En 's/.*strn?cmp\(ptr, "([^ "]*[^ ])".*/\1/p' $< | \
	grep -Ev '^(include|rlimit)$$' | sed 's/\./\\./' | LC_ALL=C sort -u >$@

# TODO: private-lib is special-cased in the code and doesn't match the regex
contrib/syntax/lists/profile_commands_arg1.list: src/firejail/profile.c
	@{ sed -En 's/.*strn?cmp\(ptr, "([^"]+) ".*/\1/p' $<; echo private-lib; } | \
	LC_ALL=C sort -u >$@

contrib/syntax/lists/profile_conditionals.list: src/firejail/profile.c
	@awk -- 'BEGIN {process=0;} /^Cond conditionals\[\] = \{$$/ {process=1;} \
		/\t*\{"[^"]+".*/ \
		{ if (process) {print gensub(/^\t*\{"([^"]+)".*$$/, "\\1", 1);} } \
		/^\t\{ NULL, NULL \}$$/ {process=0;}' \
		$< | LC_ALL=C sort -u >$@

contrib/syntax/lists/profile_macros.list: src/firejail/macros.c
	@sed -En 's/.*\$$\{([^}]+)\}.*/\1/p' $< | LC_ALL=C sort -u >$@

contrib/syntax/lists/syscall_groups.list: src/lib/syscall.c
	@sed -En 's/.*"@([^",]+).*/\1/p' $< | LC_ALL=C sort -u >$@

contrib/syntax/lists/syscalls.list: $(SYSCALL_HEADERS)
	@sed -n 's/{\s\+"\([^"]\+\)",.*},/\1/p' $(SYSCALL_HEADERS) | \
	LC_ALL=C sort -u >$@

contrib/syntax/lists/system_errnos.list: src/lib/errno.c
	@sed -En 's/.*"(E[^"]+).*/\1/p' $< | LC_ALL=C sort -u >$@

pipe_fromlf = { tr '\n' '|' | sed 's/|$$//'; }
space_fromlf = { tr '\n' ' ' | sed 's/ $$//'; }
edit_syntax_file = sed \
	-e "s/@make_input@/$$(basename $@).  Generated from $$(basename $<) by make./" \
	-e "s/@FJ_PROFILE_COMMANDS_ARG0@/$$($(pipe_fromlf) <contrib/syntax/lists/profile_commands_arg0.list)/" \
	-e "s/@FJ_PROFILE_COMMANDS_ARG1@/$$($(pipe_fromlf) <contrib/syntax/lists/profile_commands_arg1.list)/" \
	-e "s/@FJ_PROFILE_CONDITIONALS@/$$($(pipe_fromlf) <contrib/syntax/lists/profile_conditionals.list)/" \
	-e "s/@FJ_PROFILE_MACROS@/$$($(pipe_fromlf) <contrib/syntax/lists/profile_macros.list)/" \
	-e "s/@FJ_SYSCALLS@/$$($(space_fromlf) <contrib/syntax/lists/syscalls.list)/" \
	-e "s/@FJ_SYSCALL_GROUPS@/$$($(pipe_fromlf) <contrib/syntax/lists/syscall_groups.list)/" \
	-e "s/@FJ_SYSTEM_ERRNOS@/$$($(pipe_fromlf) <contrib/syntax/lists/system_errnos.list)/"

contrib/syntax/files/example: contrib/syntax/files/example.in $(SYNTAX_LISTS)
	@printf 'Generating %s from %s\n' $@ $<
	@$(edit_syntax_file) $< >$@

# gtksourceview language-specs
contrib/syntax/files/%.lang: contrib/syntax/files/%.lang.in $(SYNTAX_LISTS)
	@printf 'Generating %s from %s\n' $@ $<
	@$(edit_syntax_file) $< >$@

# vim syntax files
contrib/syntax/files/%.vim: contrib/syntax/files/%.vim.in $(SYNTAX_LISTS)
	@printf 'Generating %s from %s\n' $@ $<
	@$(edit_syntax_file) $< >$@

.PHONY: clean
clean:
	for dir in $$(dirname $(ALL_ITEMS)) $(MYDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	$(MAKE) -C test clean
	rm -f $(SECCOMP_FILTERS)
	rm -f firejail*.rpm
	rm -f $(SYNTAX_FILES)
	rm -f src/fnettrace/static-ip-map
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
	$(call build_filters)
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
	install -m 0644 src/man/firejail.1.gz $(DESTDIR)$(mandir)/man1/
	install -m 0644 src/man/firemon.1.gz $(DESTDIR)$(mandir)/man1/
	install -m 0644 src/man/firecfg.1.gz $(DESTDIR)$(mandir)/man1/
	install -m 0644 src/man/jailcheck.1.gz $(DESTDIR)$(mandir)/man1/
	install -m 0644 src/man/firejail-login.5.gz $(DESTDIR)$(mandir)/man5/
	install -m 0644 src/man/firejail-users.5.gz $(DESTDIR)$(mandir)/man5/
	install -m 0644 src/man/firejail-profile.5.gz $(DESTDIR)$(mandir)/man5/
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
	rm -f $(DESTDIR)$(datarootdir)/gtksourceview-5/language-specs/firejail-profile.lang
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
platform \
src

DISTFILES_TEST = test/Makefile test/apps test/apps-x11 test/apps-x11-xorg test/capabilities test/private-lib test/fnetfilter test/fcopy test/environment test/profiles test/utils test/compile test/filters test/network test/fs test/sysutils

.PHONY: dist
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

.PHONY: asc
asc: config.mk
	./mkasc.sh $(VERSION)

.PHONY: deb
deb: dist config.sh
	./mkdeb.sh

.PHONY: test-compile
test-compile: dist config.mk
	cd test/compile; ./compile.sh $(TARNAME)-$(VERSION)

.PHONY: rpms
rpms: src/man config.mk
	./platform/rpm/mkrpm.sh $(TARNAME) $(VERSION)

.PHONY: extras
extras: all
	$(MAKE) -C extras/firetools

.PHONY: cppcheck
cppcheck: clean
	cppcheck --force --error-exitcode=1 --enable=warning,performance .

.PHONY: scan-build
scan-build: clean
	scan-build make

.PHONY: codespell
codespell: clean
	codespell --ignore-regex "UE|creat|shotcut|ether" src test

.PHONY: print-env
print-env:
	./ci/printenv.sh

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

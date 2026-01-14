#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

# GCOV test setup
# required: sudo, gcov (apt-get install gcovr)
# Compile and install
#    $ ./configure --prefix=/usr --enable-apparmor --enable-gcov
#    $ make
#    $ sudo make install
# run as regular user: ./gcov.sh
# result in gcov-dir/index.html

gcov_generate() {
    rm -fr gcov-dir
    sleep 1
    mkdir gcov-dir
    USER="$(whoami)"
    find . -exec sudo chown "$USER:$USER" '{}' +
    sleep 1
    gcovr --html-nested gcov-dir/index.html \
	  src/firejail src/firemon src/firecfg src/jailcheck \
	  src/etc-cleanup \
	  src/fbuilder \
	  src/fbwrap \
	  src/fcopy \
	  src/fnet \
	  src/fnetfilter \
	  src/fnetlock \
	  src/fnettrace \
	  src/fnettrace-dns \
	  src/fnettrace-icmp \
	  src/fnettrace-sni \
	  src/fseccomp \
	  src/fsec-optimize \
	  src/fsec-print \
	  src/ftee \
	  src/fzenity \
	  src/lib \
	  src/profstats
}

# --help - main programs
/usr/bin/firejail --help
/usr/bin/firemon --help
/usr/bin/firecfg --help
/usr/bin/jailcheck --help
gcov_generate

# --help -secondary programs
/usr/lib/firejail/etc-cleanup --help
/usr/lib/firejail/fbuilder --help
/usr/lib/firejail/fbwrap --help
/usr/lib/firejail/fcopy --help
/usr/lib/firejail/fnet --help
/usr/lib/firejail/fnetfilter --help
/usr/lib/firejail/fnetlock --help
/usr/lib/firejail/fnettrace --help
/usr/lib/firejail/fnettrace-dns --help
/usr/lib/firejail/fnettrace-icmp --help
/usr/lib/firejail/fnettrace-sni --help
/usr/lib/firejail/fseccomp --help
/usr/lib/firejail/fseccomp-optimize --help
/usr/lib/firejail/fseccomp-print --help
/usr/lib/firejail/ftee --help
/usr/lib/firejail/fzenity --help
/usr/lib/firejail/profstats --help
gcov_generate

# test-main: .github/workflows/test.yml#L50
make test-seccomp-extra
make test-firecfg
make test-capabilities
make test-apparmor
make test-appimage
make test-chroot
make test-fcopy
gcov_generate

# test-fs: .github/workflows/test.yml#L99
make test-private-etc
gcov_generate
make test-fs
gcov_generate

# test-environment: .github/workflows/test.yml#L139
make test-environment
gcov_generate
make test-profiles
gcov_generate

# test-utils: .github/workflows/test.yml#L179
make test-utils
gcov_generate

# test-network: .github/workflows/test.yml#L221
make test-fnetfilter
make test-sysutils
gcov_generate
make test-network
gcov_generate







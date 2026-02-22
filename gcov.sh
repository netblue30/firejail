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
    sleep 2
    printf "TESTING "; gcovr | grep TOTAL
    sleep 2
}

# --help - main programs
/usr/bin/firejail --help
/usr/bin/firemon --help
/usr/bin/firecfg --help
/usr/bin/jailcheck --help
sleep 2

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
/usr/lib/firejail/fsec-optimize --help
/usr/lib/firejail/fsec-print --help
/usr/lib/firejail/ftee --help
/usr/lib/firejail/fzenity --help
sleep 2

make test-apps
gcov_generate
make test-chroot
gcov_generate
make test-profiles
gcov_generate
make test-capabilities
gcov_generate
make test-firecfg
gcov_generate
make test-network
gcov_generate
make test-apparmor
gcov_generate
make test-appimage
gcov_generate
make test-utils
gcov_generate
make test-environment
gcov_generate
make test-filters
gcov_generate
make test-fs
gcov_generate
make test-fcopy
gcov_generate
make test-fnettrace
gcov_generate
make test-fnetfilter
gcov_generate
make test-private-etc
gcov_generate
make test-seccomp-extra
gcov_generate

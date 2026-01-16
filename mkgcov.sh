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



if test -f ../../src/firejail/main.gcno; then
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
	  src/lib
fi








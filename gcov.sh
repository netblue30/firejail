#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# GCOV test setup
# required: sudo, lcov (apt-get install lcov)
# setup: modify ./configure line below if necessary
# run as regular user: ./gcov.sh
# result in gcov-dir/index.html

gcov_generate() {
	USER="$(whoami)"
	find . -exec sudo chown "$USER:$USER" '{}' +
	lcov -q --capture \
		-d src/firejail -d src/lib -d src/firecfg -d src/firemon \
		-d src/fnet -d src/fnetfilter -d src/fcopy \
		-d src/fseccomp --output-file gcov-file

	genhtml -q gcov-file --output-directory gcov-dir
}

make distclean &&
./configure --prefix=/usr --enable-fatal-warnings \
  --enable-apparmor --enable-gcov &&
make -j "$(nproc)" &&
sudo make install

rm -fr gcov-dir gcov-file
make print-version
gcov_generate

make test-firecfg | grep TESTING
gcov_generate
make test-capabilities | grep TESTING
gcov_generate
make test-seccomp-extra | grep TESTING
gcov_generate
make test-apparmor | grep TESTING
gcov_generate
make test-network | grep TESTING
gcov_generate
make test-appimage | grep TESTING
gcov_generate
make test-chroot | grep TESTING
gcov_generate
make test-sysutils | grep TESTING
gcov_generate
make test-private-etc | grep TESTING
gcov_generate
make test-profiles | grep TESTING
gcov_generate
make test-fcopy | grep TESTING
gcov_generate
make test-fnetfilter | grep TESTING
gcov_generate
make test-fs | grep TESTING
gcov_generate
make test-utils | grep TESTING
gcov_generate
make test-environment | grep TESTING
gcov_generate

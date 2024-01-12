#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

gcov_init() {
	USER="$(whoami)"
	firejail --help > /dev/null
	firemon --help > /dev/null
	/usr/lib/firejail/fnet --help > /dev/null
	/usr/lib/firejail/fseccomp --help > /dev/null
	/usr/lib/firejail/ftee --help > /dev/null
	/usr/lib/firejail/fcopy --help > /dev/null
	/usr/lib/firejail/fldd --help > /dev/null
	firecfg --help > /dev/null

	/usr/lib/firejail/fnetfilter --help > /dev/null
	/usr/lib/firejail/fsec-print --help > /dev/null
	/usr/lib/firejail/fsec-optimize --help > /dev/null
	/usr/lib/firejail/faudit --help > /dev/null
	/usr/lib/firejail/fbuilder --help > /dev/null

	find . -exec sudo chown "$USER:$USER" '{}' +
}

rm -fr gcov-dir
gcov_init
lcov -q --capture -d src/firejail -d src/firemon -d src/faudit -d src/fbuilder \
	-d src/fcopy -d src/fnetfilter -d src/fsec-print -d src/fsec-optimize -d src/fseccomp \
	-d src/fnet -d src/ftee -d src/lib -d src/firecfg -d src/fldd --output-file gcov-file
genhtml -q gcov-file --output-directory gcov-dir

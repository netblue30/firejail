#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

if [[ -f /etc/debian_version ]]; then
	libdir=$(dirname "$(dpkg -L firejail | grep fcopy)")
	export PATH="$PATH:$libdir"
fi

export PATH="$PATH:/usr/lib/firejail:/usr/lib64/firejail"

chmod 400 outlocked

echo "TESTING: fnetfilter cmdline (test/fnetfilter/cmdline.exp)"
./cmdline.exp

echo "TESTING: fnetfilter default (test/fnetfilter/default.exp)"
./default.exp

echo "TESTING: fnetfilter copy (test/fnetfilter/copy.exp)"
./copy.exp

echo "TESTING: fnetfilter template (test/fnetfilter/template.exp)"
./template.exp

rm -f outfile

#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2018 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

if [ -f /etc/debian_version ]; then
	libdir=$(dirname "$(dpkg -L firejail | grep fcopy)")
	export PATH="$PATH:$libdir"
fi

export PATH="$PATH:/usr/lib/firejail:/usr/lib64/firejail"

mkdir dest

echo "TESTING: fcopy cmdline (test/fcopy/cmdline.exp)"
./cmdline.exp

echo "TESTING: fcopy directory (test/fcopy/dircopy.exp)"
./dircopy.exp

echo "TESTING: fcopy file (test/fcopy/filecopy.exp)"
./filecopy.exp

echo "TESTING: fcopy link (test/fcopy/linkcopy.exp)"
./linkcopy.exp

echo "TESTING: fcopy trailing char (test/copy/trailing.exp)"
./trailing.exp

rm -fr dest/*

#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2022 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

if command -v cpio
then
	echo "TESTING: cpio"
	./cpio.exp
else
	echo "TESTING SKIP: cpio not found"
fi

#if command -v strings
#then
#	echo "TESTING: strings"
#	./strings.exp
#else
#	echo "TESTING SKIP: strings not found"
#fi

if command -v gzip
then
	echo "TESTING: gzip"
	./gzip.exp
else
	echo "TESTING SKIP: gzip not found"
fi

if command -v xzdec
then
	echo "TESTING: xzdec"
	./xzdec.exp
else
	echo "TESTING SKIP: xzdec not found"
fi

if command -v xz
then
	echo "TESTING: xz"
	./xz.exp
else
	echo "TESTING SKIP: xz not found"
fi

if command -v less
then
	echo "TESTING: less"
	./less.exp
else
	echo "TESTING SKIP: less not found"
fi

if command -v file
then
	echo "TESTING: file"
	./file.exp
else
	echo "TESTING SKIP: file not found"
fi

if command -v tar
then
	echo "TESTING: tar"
	./tar.exp
else
	echo "TESTING SKIP: tar not found"
fi

if command -v ping
then
	echo "TESTING: ping"
	./ping.exp
else
	echo "TESTING SKIP: ping not found"
fi

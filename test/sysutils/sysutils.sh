#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

which cpio 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: cpio"
	./cpio.exp
else
	echo "TESTING SKIP: cpio not found"
fi

#which strings
#if [ "$?" -eq 0 ];
#then
#	echo "TESTING: strings"
#	./strings.exp
#else
#	echo "TESTING SKIP: strings not found"
#fi

which gzip 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: gzip"
	./gzip.exp
else
	echo "TESTING SKIP: gzip not found"
fi

which xzdec 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: xzdec"
	./xzdec.exp
else
	echo "TESTING SKIP: xzdec not found"
fi

which xz 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: xz"
	./xz.exp
else
	echo "TESTING SKIP: xz not found"
fi

which less 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: less"
	./less.exp
else
	echo "TESTING SKIP: less not found"
fi

which file 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: file"
	./file.exp
else
	echo "TESTING SKIP: file not found"
fi

which tar 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: tar"
	./tar.exp
else
	echo "TESTING SKIP: tar not found"
fi

which ping 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: ping"
	./ping.exp
else
	echo "TESTING SKIP: ping not found"
fi

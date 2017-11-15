#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2017 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

which cpio
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

which gzip
if [ "$?" -eq 0 ];
then
	echo "TESTING: gzip"
	./gzip.exp
else
	echo "TESTING SKIP: gzip not found"
fi

which xzdec
if [ "$?" -eq 0 ];
then
	echo "TESTING: xzdec"
	./xzdec.exp
else
	echo "TESTING SKIP: xzdec not found"
fi

which xz
if [ "$?" -eq 0 ];
then
	echo "TESTING: xz"
	./xz.exp
else
	echo "TESTING SKIP: xz not found"
fi

which less
if [ "$?" -eq 0 ];
then
	echo "TESTING: less"
	./less.exp
else
	echo "TESTING SKIP: less not found"
fi

which file
if [ "$?" -eq 0 ];
then
	echo "TESTING: file"
	./file.exp
else
	echo "TESTING SKIP: file not found"
fi

which tar
if [ "$?" -eq 0 ];
then
	echo "TESTING: tar"
	./tar.exp
else
	echo "TESTING SKIP: tar not found"
fi

which ping
if [ "$?" -eq 0 ];
then
	echo "TESTING: ping"
	./ping.exp
else
	echo "TESTING SKIP: ping not found"
fi

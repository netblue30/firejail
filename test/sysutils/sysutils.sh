#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
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

which strings
if [ "$?" -eq 0 ];
then
	echo "TESTING: strings"
	./strings.exp
else
	echo "TESTING SKIP: strings not found"
fi

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


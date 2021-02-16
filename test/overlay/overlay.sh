#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: overlay fs (test/overlay/fs.exp)"
rm -fr ~/_firejail_test_*
./fs.exp
rm -fr ~/_firejail_test_*

echo "TESTING: overlay named fs (test/overlay/fs-named.exp)"
rm -fr ~/_firejail_test_*
./fs-named.exp
rm -fr ~/_firejail_test_*

echo "TESTING: overlay tmpfs fs (test/overlay/fs-tmpfs.exp)"
rm -fr ~/_firejail_test_*
./fs-tmpfs.exp
rm -fr ~/_firejail_test_*

which firefox 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: overlay firefox"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

which firefox 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: overlay firefox x11 xorg"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi


# check xpra/xephyr
which xpra 2>/dev/null
if [ "$?" -eq 0 ];
then
        echo "xpra found"
else
        echo "xpra not found"
	which Xephyr 2>/dev/null
	if [ "$?" -eq 0 ];
	then
        	echo "Xephyr found"
	else
        	echo "TESTING SKIP: xpra and/or Xephyr not found"
		exit
	fi
fi

which firefox 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: overlay firefox x11"
	./firefox-x11.exp
else
	echo "TESTING SKIP: firefox not found"
fi

#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2022 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

which firefox 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox x11 xorg"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

which transmission-gtk 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk x11 xorg"
	./transmission-gtk.exp
else
	echo "TESTING SKIP: transmission-gtk not found"
fi

which transmission-qt 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-qt x11 xorg"
	./transmission-qt.exp
else
	echo "TESTING SKIP: transmission-qt not found"
fi

which thunderbird 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: thunderbird x11 xorg"
	./thunderbird.exp
else
	echo "TESTING SKIP: thunderbird not found"
fi

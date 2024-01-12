#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

if command -v firefox
then
	echo "TESTING: firefox x11 xorg"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

if command -v transmission-gtk
then
	echo "TESTING: transmission-gtk x11 xorg"
	./transmission-gtk.exp
else
	echo "TESTING SKIP: transmission-gtk not found"
fi

if command -v transmission-qt
then
	echo "TESTING: transmission-qt x11 xorg"
	./transmission-qt.exp
else
	echo "TESTING SKIP: transmission-qt not found"
fi

if command -v thunderbird
then
	echo "TESTING: thunderbird x11 xorg"
	./thunderbird.exp
else
	echo "TESTING SKIP: thunderbird not found"
fi

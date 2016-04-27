#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

which xterm
if [ "$?" -eq 0 ];
then
	echo "TESTING: xterm x11"
	./xterm.exp
else
	echo "TESTING: xterm not found"
fi

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox x11"
	./firefox.exp
else
	echo "TESTING: firefox not found"
fi

which chromium
if [ "$?" -eq 0 ];
then
	echo "TESTING: chromium x11"
	./chromium.exp
else
	echo "TESTING: chromium not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk x11"
	./transmission-gtk.exp
else
	echo "TESTING: transmission-gtk not found"
fi

which icedove
if [ "$?" -eq 0 ];
then
	echo "TESTING: icedove x11"
	./icedove.exp
else
	echo "TESTING: icedove not found"
fi


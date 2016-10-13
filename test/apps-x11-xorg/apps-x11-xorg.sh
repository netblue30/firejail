#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox x11 xorg"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk x11 xorg"
	./transmission-gtk.exp
else
	echo "TESTING SKIP: transmission-gtk not found"
fi

which icedove
if [ "$?" -eq 0 ];
then
	echo "TESTING: icedove x11 xorg"
	./icedove.exp
else
	echo "TESTING SKIP: icedove not found"
fi


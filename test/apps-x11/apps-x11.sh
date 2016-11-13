#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

echo "TESTING: no x11 (test/apps-x11/x11-none.exp)"
./x11-none.exp


which xterm
if [ "$?" -eq 0 ];
then
	echo "TESTING: xterm x11 xorg"
	./xterm-xorg.exp

	which xpra
	if [ "$?" -eq 0 ];
	then
	echo "TESTING: xterm x11 xpra"
	./xterm-xpra.exp
	fi
	
	which Xephyr
	if [ "$?" -eq 0 ];
	then
	echo "TESTING: xterm x11 xephyr"
	./xterm-xephyr.exp
	fi
else
	echo "TESTING SKIP: xterm not found"
fi

# check xpra/xephyr
which xpra
if [ "$?" -eq 0 ];
then
        echo "xpra found"
else
        echo "xpra not found"
	which Xephyr
	if [ "$?" -eq 0 ];
	then
        	echo "Xephyr found"
	else
        	echo "TESTING SKIP: xpra and/or Xephyr not found"
		exit
	fi
fi

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox x11"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

which chromium
if [ "$?" -eq 0 ];
then
	echo "TESTING: chromium x11"
	./chromium.exp
else
	echo "TESTING SKIP: chromium not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk x11"
	./transmission-gtk.exp
else
	echo "TESTING SKIP: transmission-gtk not found"
fi

which icedove
if [ "$?" -eq 0 ];
then
	echo "TESTING: icedove x11"
	./icedove.exp
else
	echo "TESTING SKIP: icedove not found"
fi


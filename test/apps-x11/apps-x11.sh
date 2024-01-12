#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: no x11 (test/apps-x11/x11-none.exp)"
./x11-none.exp

if command -v xterm
then
	echo "TESTING: xterm x11 xorg"
	./xterm-xorg.exp

	if command -v xpra
	then
		echo "TESTING: xterm x11 xpra"
		./xterm-xpra.exp
	fi

	if command -v Xephyr
	then
		echo "TESTING: xterm x11 xephyr"
		./xterm-xephyr.exp
	fi
else
	echo "TESTING SKIP: xterm not found"
fi

# check xpra/xephyr
if command -v xpra
then
	echo "xpra found"
else
	echo "xpra not found"
	if command -v Xephyr
	then
		echo "Xephyr found"
	else
		echo "TESTING SKIP: xpra and/or Xephyr not found"
		exit
	fi
fi

if command -v firefox
then
	echo "TESTING: firefox x11"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

if command -v chromium
then
	echo "TESTING: chromium x11"
	./chromium.exp
else
	echo "TESTING SKIP: chromium not found"
fi

if command -v transmission-gtk
then
	echo "TESTING: transmission-gtk x11"
	./transmission-gtk.exp
else
	echo "TESTING SKIP: transmission-gtk not found"
fi

if command -v thunderbird
then
	echo "TESTING: thunderbird x11"
	./thunderbird.exp
else
	echo "TESTING SKIP: thunderbird not found"
fi

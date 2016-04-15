#!/bin/bash

which xterm
if [ "$?" -eq 0 ];
then
	echo "TESTING: xterm x11"
	./xterm-x11.exp
else
	echo "TESTING: xterm not found"
fi

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox x11"
	./firefox-x11.exp
else
	echo "TESTING: firefox not found"
fi

which chromium
if [ "$?" -eq 0 ];
then
	echo "TESTING: chromium x11"
	./chromium-x11.exp
else
	echo "TESTING: chromium not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk x11"
	./transmission-gtk-x11.exp
else
	echo "TESTING: transmission-gtk not found"
fi

which icedove
if [ "$?" -eq 0 ];
then
	echo "TESTING: icedove x11"
	./icedove-x11.exp
else
	echo "TESTING: chromium not found"
fi


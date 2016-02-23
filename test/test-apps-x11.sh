#!/bin/bash

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
	./transmission-gtk.exp
else
	echo "TESTING: transmission-gtk not found"
fi


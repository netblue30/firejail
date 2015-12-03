#!/bin/bash

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox"
	./firefox.exp
else
	echo "TESTING: firefox not found"
fi

which midori
if [ "$?" -eq 0 ];
then
	echo "TESTING: midori"
	./midori.exp
else
	echo "TESTING: midori not found"
fi

which chromium
if [ "$?" -eq 0 ];
then
	echo "TESTING: chromium"
	./chromium.exp
else
	echo "TESTING: chromium not found"
fi

which google-chrome
if [ "$?" -eq 0 ];
then
	echo "TESTING: google-chrome"
	./chromium.exp
else
	echo "TESTING: google-chrome not found"
fi

which opera
if [ "$?" -eq 0 ];
then
	echo "TESTING: opera"
	./opera.exp
else
	echo "TESTING: opera not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk"
	./transmission-gtk.exp
else
	echo "TESTING: transmission-gtk not found"
fi

which transmission-qt
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-qt"
	./transmission-qt.exp
else
	echo "TESTING: transmission-qt not found"
fi

which evince
if [ "$?" -eq 0 ];
then
	echo "TESTING: evince"
	./evince.exp
else
	echo "TESTING: evince not found"
fi

which icedove
if [ "$?" -eq 0 ];
then
	echo "TESTING: icedove"
	./icedove.exp
else
	echo "TESTING: icedove not found"
fi

which vlc
if [ "$?" -eq 0 ];
then
	echo "TESTING: vlc"
	./vlc.exp
else
	echo "TESTING: vlc not found"
fi

which fbreader
if [ "$?" -eq 0 ];
then
	echo "TESTING: fbreader"
	./fbreader.exp
else
	echo "TESTING: fbreader not found"
fi

which deluge
if [ "$?" -eq 0 ];
then
	echo "TESTING: deluge"
	./deluge.exp
else
	echo "TESTING: deluge not found"
fi

which gnome-mplayer
if [ "$?" -eq 0 ];
then
	echo "TESTING: gnome-mplayer"
	./gnome-mplayer.exp
else
	echo "TESTING: gnome-mplayer not found"
fi

which xchat
if [ "$?" -eq 0 ];
then
	echo "TESTING: xchat"
	./xchat.exp
else
	echo "TESTING: xchat not found"
fi

which hexchat
if [ "$?" -eq 0 ];
then
	echo "TESTING: hexchat"
	./hexchat.exp
else
	echo "TESTING: hexchat not found"
fi

which weechat-curses
if [ "$?" -eq 0 ];
then
	echo "TESTING: weechat"
	./weechat.exp
else
	echo "TESTING: weechat not found"
fi

which wine
if [ "$?" -eq 0 ];
then
	echo "TESTING: wine"
	./wine.exp
else
	echo "TESTING: wine not found"
fi


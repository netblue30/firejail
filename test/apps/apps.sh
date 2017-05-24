#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2017 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox"
	./firefox.exp
else
	echo "TESTING SKIP: firefox not found"
fi

which midori
if [ "$?" -eq 0 ];
then
	echo "TESTING: midori"
	./midori.exp
else
	echo "TESTING SKIP: midori not found"
fi

which chromium
if [ "$?" -eq 0 ];
then
	echo "TESTING: chromium"
	./chromium.exp
else
	echo "TESTING SKIP: chromium not found"
fi

which opera
if [ "$?" -eq 0 ];
then
	echo "TESTING: opera"
	./opera.exp
else
	echo "TESTING SKIP: opera not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk"
	./transmission-gtk.exp
else
	echo "TESTING SKIP: transmission-gtk not found"
fi

which transmission-qt
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-qt"
	./transmission-qt.exp
else
	echo "TESTING SKIP: transmission-qt not found"
fi

which qbittorrent
if [ "$?" -eq 0 ];
then
	echo "TESTING: qbittorrent"
	./qbittorrent.exp
else
	echo "TESTING SKIP: qbittorrent not found"
fi

which uget-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: uget"
	./uget-gtk.exp
else
	echo "TESTING SKIP: uget-gtk not found"
fi

which filezilla
if [ "$?" -eq 0 ];
then
	echo "TESTING: filezilla"
	./filezilla.exp
else
	echo "TESTING SKIP: filezilla not found"
fi

which evince
if [ "$?" -eq 0 ];
then
	echo "TESTING: evince"
	./evince.exp
else
	echo "TESTING SKIP: evince not found"
fi


which gthumb
if [ "$?" -eq 0 ];
then
	echo "TESTING: gthumb"
	./gthumb.exp
else
	echo "TESTING SKIP: gthumb not found"
fi

which thunderbird
if [ "$?" -eq 0 ];
then
	echo "TESTING: thunderbird"
	./thunderbird.exp
else
	echo "TESTING SKIP: thunderbird not found"
fi

which vlc
if [ "$?" -eq 0 ];
then
	echo "TESTING: vlc"
	./vlc.exp
else
	echo "TESTING SKIP: vlc not found"
fi

which fbreader
if [ "$?" -eq 0 ];
then
	echo "TESTING: fbreader"
	./fbreader.exp
else
	echo "TESTING SKIP: fbreader not found"
fi

which deluge
if [ "$?" -eq 0 ];
then
	echo "TESTING: deluge"
	./deluge.exp
else
	echo "TESTING SKIP: deluge not found"
fi

which gnome-mplayer
if [ "$?" -eq 0 ];
then
	echo "TESTING: gnome-mplayer"
	./gnome-mplayer.exp
else
	echo "TESTING SKIP: gnome-mplayer not found"
fi

which xchat
if [ "$?" -eq 0 ];
then
	echo "TESTING: xchat"
	./xchat.exp
else
	echo "TESTING SKIP: xchat not found"
fi

which hexchat
if [ "$?" -eq 0 ];
then
	echo "TESTING: hexchat"
	./hexchat.exp
else
	echo "TESTING SKIP: hexchat not found"
fi

which wine
if [ "$?" -eq 0 ];
then
	echo "TESTING: wine"
	./wine.exp
else
	echo "TESTING SKIP: wine not found"
fi

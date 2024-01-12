#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

apps=(firefox midori chromium opera transmission-qt qbittorrent uget-gtk filezilla gthumb thunderbird vlc fbreader deluge gnome-mplayer xchat wine kcalc ktorrent hexchat)

for app in "${apps[@]}"; do
	if command -v "$app"
	then
		echo "TESTING: $app"
		./$app.exp
	else
		echo "TESTING SKIP: $app not found"
	fi
done

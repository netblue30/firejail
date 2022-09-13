#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2022 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3g
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

LIST="gnome-logs gnome-system-log gnome-nettool pavucontrol dig evince whois galculator gnome-calculator gedit leafpad mousepad pluma transmission-gtk xcalc atril gpicview eom eog"


for app in $LIST; do
	if command -v "$app"
	then
		echo "TESTING: private-lib $app"
		./$app.exp
	else
		echo "TESTING SKIP: $app not found"
	fi
done

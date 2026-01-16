#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

apps=(firefox qbittorrent firefox-xephyr galculator lowriter firefox-xorg \
     x11-none xterm-xorg xterm-xephyr)

for app in "${apps[@]}"; do
	if file -v "$app".exp
	then
		echo "TESTING: $app"
		./"$app".exp
	else
		echo "TESTING SKIP: $app not found"
	fi
	sleep 1
done

cd ../../
./mkgcov.sh

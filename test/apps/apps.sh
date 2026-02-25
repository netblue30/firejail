#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2
#
# quic test for several applications
#
export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

# keeping sudo available
sudo ls

# console apps
apps=(ping dig wget curl)
for app in "${apps[@]}"; do
    if command -v "$app"
    then
	echo "TESTING: $app"
	./$app.exp
    else
	echo "TESTING SKIP: $app not found"
    fi
done
rm -f index.html
rm wget-log*
sudo ls

# testing seccomp @clock group
echo "TESTING: seccomp @clock group (test/apps/seccomp-clock.exp)"
./seccomp-clock.exp

echo "TESTING: pid 1 functionality (test/apps/pid1.exp)"
./pid1.exp

# X11 apps
x11apps=(firefox qbittorrent firefox-xephyr galculator libreoffice firefox-xorg \
		 lowriter gimp inkscape firefox-neteth emacs okular kdiff3 gpicview audacity \
		 pauvcontrol mpv dosbox gnome-screenshot \
		 xterm x11-none xterm-xorg xterm-xephyr xterm-xpra firefox-xpra)

for app in "${x11apps[@]}"; do
    sudo ls
    if file -v "$app".exp
    then
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
    else
	echo "TESTING SKIP: $app not found"
    fi
    sleep 1
done

cd ../../
./mkgcov.sh

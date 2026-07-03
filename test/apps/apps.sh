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
echo "TESTING: console apps **************************"
apps=(ping dig wget curl ftp telnet ffmpeg)
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
sudo true

# testing seccomp @clock group
echo "TESTING: firejail problems **************************"
echo "TESTING: seccomp @clock group (test/apps/seccomp-clock.exp)"
./seccomp-clock.exp

echo "TESTING: pid 1 functionality (test/apps/pid1.exp)"
./pid1.exp

# x11 sandboxing
echo "TESTING: x11 sandboxing *********************************"
x11apps=(firefox-xephyr x11-none firefox-xorg xterm-xorg xterm-xephyr \
			xterm-xpra firefox-xpra)
for app in "${x11apps[@]}"; do
    sudo true
    echo "TESTING: $app (test/apps/$app.exp)"
    ./"$app".exp
    sleep 1
done

# browsers
echo "TESTING: browsers ***************************************"
browsers=(firefox brave chromium vivaldi)
for app in "${browsers[@]}"; do
    sudo true
    echo "TESTING: $app (test/apps/$app.exp)"
    ./"$app".exp
    sleep 1
done

# multimedia apps
echo "TESTING: multimedia apps ************************************"
multimedia=(vlc mpv rhythmbox totem showtime audacious smplayer mplayer \
	   cmus strawberry amarok quodlibet qmmp)
for app in "${multimedia[@]}"; do
    sudo true
    echo "TESTING: $app (test/apps/$app.exp)"
    ./"$app".exp
    sleep 1
done

echo "TESTING: games ************************************"
games=(warzone2100 dosbox)
for app in "${games[@]}"; do
    sudo true
    echo "TESTING: $app (test/apps/$app.exp)"
    ./"$app".exp
    sleep 1
done

# dektop apps
echo "TESTING: desktop apps ************************************"
desktopapps=(xterm qbittorrent galculator libreoffice \
		 lowriter gimp inkscape firefox-neteth emacs okular kdiff3 \
		 gpicview audacity meld \
		 pauvcontrol gnome-screenshot \
		 flameshot ghb kdenlive krita \
		 evince atril kate eom eog \
		 gwenview oupe gnome-calculator \
		 darktable brasero \
		 transmission-qt transmission-gtk \
		 thunderbird kmail xpdf zathura)

for app in "${desktopapps[@]}"; do
    sudo true
    echo "TESTING: $app (test/apps/$app.exp)"
    ./"$app".exp
    sleep 1
done

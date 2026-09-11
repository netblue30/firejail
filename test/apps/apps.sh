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
apps=(
	curl
	dig
	ffmpeg
	ftp
	less
	ping
	ssh
	telnet
	wget
	yt-dlp
)
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
x11apps=(
	firefox-xephyr
	firefox-xorg
	x11-none
	xterm-xephyr
	xterm-xorg
)
for app in "${x11apps[@]}"; do
	sudo true
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
	sleep 1
done

# browsers
echo "TESTING: browsers ***************************************"
browsers=(
	brave
	chromium
	firefox
	tor-browser
	vivaldi
)
for app in "${browsers[@]}"; do
	sudo true
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
	sleep 1
done

# multimedia apps
echo "TESTING: multimedia apps ************************************"
multimedia=(
	amarok
	audacious
	cmus
	mplayer
	mpv
	qmmp
	quodlibet
	rhythmbox
	shortwave
	showtime
	smplayer
	strawberry
	totem
	vlc
)
for app in "${multimedia[@]}"; do
	sudo true
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
	sleep 1
done

echo "TESTING: games ************************************"
games=(
	dosbox
	lutris
	warzone2100
)
for app in "${games[@]}"; do
	sudo true
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
	sleep 1
done

# desktop apps
echo "TESTING: desktop apps ************************************"
desktopapps=(
	atril
	audacity
	blender
	brasero
	darktable
	digikam
	emacs
	eog
	eom
	evince
	firefox-neteth
	flameshot
	galculator
	ghb
	gimp
	gnome-calculator
	gnome-screenshot
	gpicview
	gwenview
	inkscape
	kate
	kdenlive
	kdiff3
	kmail
	krita
	libreoffice
	loupe
	lowriter
	meld
	mtpaint
	okular
	pavucontrol
	qbittorrent
	thunderbird
	transmission-gtk
	transmission-qt
	xpdf
	xterm
	zathura
)

for app in "${desktopapps[@]}"; do
	sudo true
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
	sleep 1
done

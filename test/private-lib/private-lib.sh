#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3g
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

apps=(
	atril
	dig
	eog
	eom
	evince
	galculator
	gedit
	gnome-calculator
	gnome-logs
	gnome-nettool
	gnome-system-log
	gpicview
	leafpad
	mousepad
	pavucontrol
	pluma
	transmission-gtk
	whois
	xcalc
)

for app in "${apps[@]}"; do
	if command -v "$app"
	then
		echo "TESTING: private-lib $app"
		./$app.exp
	else
		echo "TESTING SKIP: $app not found"
	fi
done

if [[ $(uname -m) == "x86_64" ]]; then
	fjconfig=/etc/firejail/firejail.config
	printf 'private-lib yes\n' | sudo tee -a "$fjconfig" >/dev/null
	echo "TESTING: private-lib (test/fs/private-lib.exp)"
	./private-lib.exp
	printf '%s\n' "$(sed '/^private-lib yes$/d' "$fjconfig")" |
		sudo tee "$fjconfig" >/dev/null
else
	echo "TESTING SKIP: private-lib test implemented only for x86_64."
fi

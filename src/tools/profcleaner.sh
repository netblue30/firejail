#!/bin/bash

# Copyright (C) 2021 Firejail Authors
#
# This file is part of firejail project
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

if [[ $1 == --help ]]; then
	cat <<-EOM
	USAGE:
	  profcleaner.sh --help        Show this help message and exit
	  profcleaner.sh --all         Clean all profiles in /etc/firejail
	  profcleaner.sh --user        Clean all profiles in ~/.config/firejail
	  profcleaner.sh /path/to/profile1 /path/to/profile2 ...
	EOM
	exit 0
fi

if [[ $1 == --all ]]; then
	profiles=(/etc/firejail/*.{inc,local,profile})
elif [[ $1 == --user ]]; then
	profiles=("$HOME"/.config/firejail/*.{inc,local,profile})
else
	profiles=("$@")
fi

sed -i \
	-e "s/^blacklist/deny/" \
	-e "s/^noblacklist/nodeny/" \
	-e "s/^whitelist/allow/" \
	-e "s/^nowhitelist/noallow/" \
	"${profiles[@]}"

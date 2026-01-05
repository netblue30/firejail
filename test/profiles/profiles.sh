#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: profile comments (test/profiles/profile_comment.exp)"
./profile_comment.exp

echo "TESTING: profile build (test/profiles/profile_build.exp)"
./profile_build.exp

echo "TESTING: profile conditional (test/profiles/profile_conditional.exp)"
./profile_conditional.exp

echo "TESTING: profile recursivity (test/profiles/profile_recursivity.exp)"
./profile_recursivity.exp

echo "TESTING: profile application name (test/profiles/profile_appname.exp)"
./profile_appname.exp

echo "TESTING: profile syntax (test/profiles/profile_syntax.exp)"
./profile_syntax.exp

echo "TESTING: profile syntax 2 (test/profiles/profile_syntax2.exp)"
./profile_syntax2.exp

echo "TESTING: profile ignore command (test/profiles/profile_ignore.exp)"
./profile_ignore.exp

echo "TESTING: profile read-only (test/profiles/profile_readonly.exp)"
./profile_readonly.exp

echo "TESTING: profile read-only links (test/profiles/profile_followlnk.exp)"
./profile_followlnk.exp

echo "TESTING: profile no permissions (test/profiles/profile_noperm.exp)"
./profile_noperm.exp

echo "TESTING: multiple profiles (test/profiles/profile_multiple.exp)"
./profile_multiple.exp

echo "TESTING: profiles bad appname (test/profiles/profile_app_name.exp)"
./profile_bad_appname.exp

echo "TESTING: profiles nopprofilee (test/profiles/profile_noprofile.exp)"
./profile_noprofile.exp

profiles=( transmission-gtk transmission-qt firefox mpv vlc ping warzone2100 galculator )
profiles+=( gimp inkscape qbittorrent chromium-browser ssh evince pdftotext audacity okular)

for profile in "${profiles[@]}"
do
	echo "TESTING: profile $profile"
	./test-profile.exp "$profile"
done

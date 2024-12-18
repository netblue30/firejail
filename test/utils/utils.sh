#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

if [[ -f /etc/debian_version ]]; then
	libdir=$(dirname "$(dpkg -L firejail | grep fcopy)")
	export PATH="$PATH:$libdir"
fi
export PATH="$PATH:/usr/lib/firejail:/usr/lib64/firejail"

echo "TESTING: build (test/utils/build.exp)"
./build.exp
rm -f ~/_firejail-test-file
rm -f _firejail-test-file

echo "TESTING: name (test/utils/name.exp)"
./name.exp

echo "TESTING: command (test/utils/command.exp)"
./command.exp

echo "TESTING: profile.print (test/utils/profile_print.exp)"
./profile_print.exp

echo "TESTING: version (test/utils/version.exp)"
./version.exp

echo "TESTING: help (test/utils/help.exp)"
./help.exp

if command -v man
then
	echo "TESTING: man (test/utils/man.exp)"
	./man.exp
else
	echo "TESTING SKIP: man not found"
fi

echo "TESTING: list (test/utils/list.exp)"
./list.exp

echo "TESTING: tree (test/utils/tree.exp)"
./tree.exp

if [[ $(grep -c ^processor /proc/cpuinfo) -gt 1 ]]
then
	echo "TESTING: cpu.print (test/utils/cpu-print.exp)"
	./cpu-print.exp
else
	echo "TESTING SKIP: cpu.print, not enough CPUs"
fi

echo "TESTING: fs.print (test/utils/fs-print.exp)"
./fs-print.exp

echo "TESTING: dns.print (test/utils/dns-print.exp)"
./dns-print.exp

echo "TESTING: seccomp.print (test/utils/seccomp-print.exp)"
./seccomp-print.exp

echo "TESTING: shutdown (test/utils/shutdown.exp)"
./shutdown.exp

echo "TESTING: shutdown2 (test/utils/shutdown2.exp)"
./shutdown2.exp

echo "TESTING: shutdown3 (test/utils/shutdown3.exp)"
./shutdown3.exp

echo "TESTING: shutdown4 (test/utils/shutdown4.exp)"
./shutdown4.exp

echo "TESTING: join (test/utils/join.exp)"
./join.exp

echo "TESTING: join4 (test/utils/join4.exp)"
./join4.exp

echo "TESTING: join5 (test/utils/join5.exp)"
./join5.exp

echo "TESTING: join profile (test/utils/join-profile.exp)"
./join-profile.exp

echo "TESTING: trace (test/utils/trace.exp)"
rm -f index.html*
./trace.exp
rm -f index.html*

echo "TESTING: top (test/utils/top.exp)"
./top.exp

echo "TESTING: file transfer (test/utils/ls.exp)"
./ls.exp

if grep -q "^Seccomp.*0" /proc/self/status; then
	echo "TESTING: firemon seccomp (test/utils/firemon-seccomp.exp)"
	./firemon-seccomp.exp
else
	echo "TESTING SKIP: seccomp already active (test/utils/firemon-seccomp.exp)"
fi

echo "TESTING: firemon cpu (test/utils/firemon-cpu.exp)"
./firemon-cpu.exp

echo "TESTING: firemon version (test/utils/firemon-version.exp)"
./firemon-version.exp

echo "TESTING: firemon name (test/utils/firemon-name.exp)"
./firemon-name.exp

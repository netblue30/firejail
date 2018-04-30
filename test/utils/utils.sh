#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2018 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

if [ -f /etc/debian_version ]; then
	libdir=$(dirname "$(dpkg -L firejail | grep faudit)")
	export PATH="$PATH:$libdir"
fi
export PATH="$PATH:/usr/lib/firejail:/usr/lib64/firejail"

echo "testing" > ~/firejail-test-file-7699
echo "testing" > /tmp/firejail-test-file-7699
echo "testing" > /var/tmp/firejail-test-file-7699
echo "TESTING: build (test/utils/build.exp)"
./build.exp
rm -f ~/firejail-test-file-7699
rm -f /tmp/firejail-test-file-7699
rm -f /var/tmp/firejail-test-file-7699

echo "TESTING: audit (test/utils/audit.exp)"
./audit.exp

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

which man 2>/dev/null
if [ "$?" -eq 0 ];
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

if [ $(grep -c ^processor /proc/cpuinfo) -gt 1 ];
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

echo "TESTING: caps.print (test/utils/caps-print.exp)"
./caps-print.exp

echo "TESTING: seccomp.print (test/utils/seccomp-print.exp)"
./seccomp-print.exp

echo "TESTING: protocol.print (test/utils/protocol-print.exp)"
./protocol-print.exp

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

echo "TESTING: join2 (test/utils/join2.exp)"
./join2.exp

echo "TESTING: join3 (test/utils/join3.exp)"
./join3.exp

echo "TESTING: join3 (test/utils/join4.exp)"
./join4.exp

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

echo "TESTING: firemon seccomp (test/utils/firemon-seccomp.exp)"
./firemon-seccomp.exp

echo "TESTING: firemon caps (test/utils/firemon-caps.exp)"
./firemon-caps.exp

echo "TESTING: firemon cpu (test/utils/firemon-cpu.exp)"
./firemon-cpu.exp

echo "TESTING: firemon cgroup (test/utils/firemon-cgroup.exp)"
./firemon-cgroup.exp

echo "TESTING: firemon version (test/utils/firemon-version.exp)"
./firemon-version.exp

echo "TESTING: firemon interface (test/utils/firemon-interface.exp)"
./firemon-interface.exp

echo "TESTING: firemon name (test/utils/firemon-name.exp)"
./firemon-name.exp

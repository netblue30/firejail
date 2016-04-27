#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

echo "TESTING: version (test/utils/version.exp)"
./version.exp

echo "TESTING: help (test/utils/help.exp)"
./help.exp

which man
if [ "$?" -eq 0 ];
then
        echo "TESTING: man (test/utils/man.exp)"
        ./man.exp
else
        echo "TESTING: man not found"
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
        echo "TESTING: cpu.print, not enough CPUs"
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
pushd /home
./shutdown.exp
popd

echo "TESTING: shutdown2 (test/utils/shutdown2.exp)"
./shutdown2.exp

echo "TESTING: shutdown3 (test/utils/shutdown3.exp)"
./shutdown3.exp

echo "TESTING: shutdown4 (test/utils/shutdown4.exp)"
./shutdown4.exp

echo "TESTING: join (test/utils/join.exp)"
pushd /home
./join.exp
popd

echo "TESTING: join2 (test/utils/join2.exp)"
pushd /home
./join2.exp
popd

echo "TESTING: join3 (test/utils/join3.exp)"
pushd /home
./join3.exp
popd

echo "TESTING: join profile (test/utils/join-profile.exp)"
pushd /home
./join-profile.exp
popd

echo "TESTING: trace (test/utils/trace.exp)"
rm -f index.html*
./trace.exp
rm -f index.html*

echo "TESTING: firemon --seccomp (test/utils/seccomp.exp)"
./seccomp.exp

echo "TESTING: firemon --caps (test/utils/caps.exp)"
./caps.exp

echo "TESTING: file transfer (test/utils/ls.exp)"
./ls.exp


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

echo "TESTING: man (test/utils/man.exp)"
./man.exp

echo "TESTING: list (test/utils/list.exp)"
./list.exp

echo "TESTING: tree (test/utils/tree.exp)"
./tree.exp

echo "TESTING: cpu.print (test/utils/cpu-print.exp)"
echo "TESTING:    failing under VirtualBox where there is only one CPU"
./cpu-print.exp

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

echo "TESTING: join test/utils/(join.exp)"
./join.exp

echo "TESTING: join2 (test/utils/join2.exp)"
./join2.exp

echo "TESTING: join3 (test/utils/join3.exp)"
./join3.exp

echo "TESTING: join profile (test/utils/join-profile.exp)"
./join-profile.exp

echo "TESTING: trace (test/utils/trace.exp)"
rm -f index.html*
./trace.exp
rm -f index.html*

echo "TESTING: firemon --seccomp (test/utils/seccomp.exp)"
./seccomp.exp

echo "TESTING: firemon --caps (test/ustil/caps.exp)"
./caps.exp

echo "TESTING: file transfer (test/ustil/ls.exp)"
./ls.exp


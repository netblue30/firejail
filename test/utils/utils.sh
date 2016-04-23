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


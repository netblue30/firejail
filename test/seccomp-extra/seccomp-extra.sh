#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: protocol (test/seccomp-extras/protocol-print.exp)"
./protocol.exp

echo "TESTING: protocol.print (test/seccomp-extras/protocol-print.exp)"
./protocol-print.exp

echo "TESTING: noroot (test/seccomp-extras/noroot.exp)"
./noroot.exp

echo "TESTING: mrwx (test/seccomp-extras/mrwx.exp)"
./mrwx.exp

echo "TESTING: mrwx2 (test/seccomp-extras/mrwx.exp)"
./mrwx2.exp

echo "TESTING: block-secondary (test/seccomp-extras/block-secondary.exp)"
./block-secondary.exp

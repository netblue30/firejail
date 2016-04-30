#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

echo "TESTING: noroot (test/filters/noroot.exp)"
./noroot.exp

echo "TESTING: capabilities (test/filters/caps.exp)"
./caps.exp

echo "TESTING: protocol (test/filters/protocol.exp)"
./protocol.exp

echo "TESTING: seccomp bad empty (test/filters/seccomp-bad-empty.exp)"
./seccomp-bad-empty.exp

echo "TESTING: seccomp debug  (test/filters/seccomp-debug.exp)"
./seccomp-debug.exp

echo "TESTING: seccomp errno (test/filters/seccomp-errno.exp)"
./seccomp-errno.exp

echo "TESTING: seccomp su (test/filters/seccomp-su.exp)"
./seccomp-su.exp

echo "TESTING: seccomp ptrace (seccomp-ptrace.exp)"
./seccomp-ptrace.exp

# todo: fix pwd
#echo "TESTING: seccomp chmod - seccomp lists (test/filters/seccomp-chmod.exp)"
#./seccomp-chmod.exp

# todo: fix pwd
#echo "TESTING: seccomp chmod profile - seccomp lists (test/filters/seccomp-chmod-profile.exp)"
#./seccomp-chmod-profile.exp

# todo:  fix pwd and add seccomp-chown.exp and seccomp-umount.exp


echo "TESTING: seccomp empty (test/filters/seccomp-empty.exp)"
./seccomp-empty.exp

echo "TESTING: seccomp bad empty (test/filters/seccomp-bad-empty.exp)"
./seccomp-bad-empty.exp

echo "TESTING: seccomp dual filter (test/filters/seccomp-dualfilter.exp)"
./seccomp-dualfilter.exp



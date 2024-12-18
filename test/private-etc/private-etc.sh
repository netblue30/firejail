#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: private-etc (test/private-etc/private-etc.exp)"
./private-etc.exp

echo "TESTING: profile (test/private-etc/profile.exp)"
./private-etc.exp

echo "TESTING: groups (test/private-etc/groups.exp)"
./groups.exp

echo "TESTING: etc-cleanup (test/private-etc/etc-cleanup.exp)"
./etc-cleanup.exp

echo "TESTING: hostname (test/private-etc/hostname.exp)"
./hostname.exp

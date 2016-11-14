#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

echo "TESTING: rlimit (test/rlimit/rlimit.exp)"
./rlimit.exp

echo "TESTING: rlimit profile (test/rlimit/rlimit-profile.exp)"
./rlimit-profile.exp


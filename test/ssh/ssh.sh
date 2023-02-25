#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2023 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: ssh login (test/ssh/login.exp)"
./login.exp

echo "TESTING: sftp (test/ssh/sftp.exp)"
./sftp.exp

echo "TESTING: scp (test/ssh/scp.exp)"
./scp.exp

#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2023 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

sudo cat /sys/kernel/security/apparmor/profiles
sudo firecfg
file /usr/local/bin/ping
ls -l /usr/local/bin
sudo cat /sys/kernel/security/apparmor/profiles

#if [[ -f /sys/kernel/security/apparmor/profiles ]]; then
#
#else
#	echo "TESTING SKIP: no apparmor support in Linux kernel (test/filters/apparmor.exp)"
#fi
#
#echo "TESTING: firecfg (test/firecfg/firecfg.exp)"
#./firecfg.exp.exp

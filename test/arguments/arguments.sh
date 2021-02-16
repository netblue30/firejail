#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

export LC_ALL=C

if [ -f /etc/debian_version ]; then
	libdir=$(dirname "$(dpkg -L firejail | grep faudit)")
	export PATH="$PATH:$libdir"
fi
export PATH="$PATH:/usr/lib/firejail:/usr/lib64/firejail"

echo "TESTING: 1. regular bash session"
./bashrun.exp
sleep 1

echo "TESTING: 2. symbolic link to firejail"
./symrun.exp
rm -fr symtest
sleep 1

echo "TESTING: 3. --join option"
./joinrun.exp
sleep 1

echo "TESTING: 4. --output option"
./outrun.exp
rm out
rm out.*

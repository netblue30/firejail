#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

echo "TESTING: default profiles installed in /etc"
PROFILES=`ls /etc/firejail/*.profile`
for PROFILE in $PROFILES
do
	echo "TESTING: $PROFILE"
	./test-profile.exp $PROFILE
done

echo "TESTING: profile syntax (profiles/profile_syntax.exp)"
./profile_syntax.exp

echo "TESTING: profile syntax 2 (profiles/profile_syntax2.exp)"
./profile_syntax2.exp


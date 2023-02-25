#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2023 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C


# blacklist testing
rm -fr ~/fj-stress-test
mkdir ~/fj-stress-test
rm blacklist.profile
rm noblacklist.profile
rm env.profile
for i in {1..100}
do
	echo "hello" > ~/fj-stress-test/testfile$i
	echo "blacklist ~/fj-stress-test/testfile$i" >> blacklist.profile
	echo "blacklist \${PATH}/sh" >> blacklist.profile
	echo "noblacklist ~/fj-stress-test/testfile$i" >> noblacklist.profile
	echo "noblacklist \${PATH}/sh" >> noblacklist.profile
	echo "env FJSTRESS$i=stress" >> env.profile
done
echo "include blacklist.profile" >> noblacklist.profile

echo "TESTING: stress blacklist/noblacklist (/test/stress/blacklist.exp)"
./blacklist.exp

echo "TESTING: stress env (/test/stress/env.exp)"
./env.exp

rm -fr ~/fj-stress-test

rm blacklist.profile
rm noblacklist.profile
rm env.profile

# network arp testing
echo "TESTING: macvlan (test/stress/net_macvlan.exp)"
./net_macvlan.exp

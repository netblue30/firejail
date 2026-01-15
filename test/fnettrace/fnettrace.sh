#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

#echo "TESTING: fnettrace (test/utils/fnettrace.exp)"
#rm -f /tmp/output
#sudo timeout 5 /usr/lib/firejail/fnettrace 2>&1 | tee /tmp/output &
#ping -c 3 yahoo.com
#sleep 3
#./fnettrace.exp
#cat /tmp/output
#rm -f /tmp/output
#exit

echo "TESTING: fnettrace-sni (test/utils/fnettrace-sni.exp)"
rm -f /tmp/output
sudo timeout 5 /usr/lib/firejail/fnettrace-sni 2>&1 | tee /tmp/output &
wget https://debian.org
sleep 5
./fnettrace-sni.exp
cat /tmp/output
rm -f /tmp/output
rm index.html
echo "all done"

echo "TESTING: fnettrace-dns (test/utils/fnettrace-dns.exp)"
rm -f /tmp/output
sudo timeout 5 /usr/lib/firejail/fnettrace-dns 2>&1 | tee /tmp/output &
ping -c 3 yahoo.com
sleep 3
./fnettrace-dns.exp
cat /tmp/output
rm -f /tmp/output
echo "all done"

echo "TESTING: fnettrace-icmp (test/utils/fnettrace-icmp.exp)"
rm -f /tmp/output
sudo timeout 5 /usr/lib/firejail/fnettrace-icmp 2>&1 | tee /tmp/output &
ping -c 3 1.1.1.1
sleep 3
./fnettrace-icmp.exp
cat /tmp/output
rm -f /tmp/output
echo "all done"


#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

sudo brctl addbr br0
sudo ip link set br0 up
sudo ip addr add 10.10.20.1/24 dev br0
ip addr show

echo "TESTING: no network (net_none.exp)"
./net_none.exp

echo "TESTING: network IP (net_ip.exp)"
./net_ip.exp

echo "TESTING: network MAC (net_mac.exp)"
./net_mac.exp

echo "TESTING: network scan (net_scan.exp)"
./net_scan.exp

echo "TESTING: netfilter (net_netfilter.exp)"
./net_netfilter.exp

echo "TESTING: print network (net-print.exp)"
./net-print.exp

echo "TESTING: print dns (dns-print.exp)"
./dns-print.exp

echo "TESTING: bandwidth (net_bandwidth.exp)"
./net_bandwidth.exp

echo "TESTING: ipv6 (ip6.exp)"
./ip6.exp

echo "TESTING: ipv6 netfilter (ip6_netfilter.exp)"
./ip6_netfilter.exp

# this test will fail on github!
USER=`whoami`
if [[ $USER == "runner" ]]; then
	echo "TESTING: skip over netstats test"
else
	echo "TESTING: netstats (netstats.exp)"
	./netstats.exp
fi

echo "TESTING: firemon arp (firemon-arp.exp)"
./firemon-arp.exp

echo "TESTING: firemon route (firemon-route.exp)"
./firemon-route.exp

echo "TESTING: netfilter-template (netfilter-template.exp)"
./netfilter-template.exp

sudo ip link set br0 down
sudo brctl delbr br0

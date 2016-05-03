#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

echo "TESTING: network profile (net_profile.exp)"
./net_profile.exp

echo "TESTING: bandwidth (bandwidth.exp)"
./bandwidth.exp

echo "TESTING: IPv6 support (ip6.exp)"
./ip6.exp

echo "TESTING: local network (net_local.exp)"
./net_local.exp

echo "TESTING: no network (net_none.exp)"
./net_none.exp

echo "TESTING: network IP (net_ip.exp)"
./net_ip.exp

echo "TESTING: network MAC (net_mac.exp)"
sleep 2
./net_mac.exp

echo "TESTING: network MTU (net_mtu.exp)"
./net_mtu.exp

echo "TESTING: network hostname (hostname.exp)"
./hostname.exp

echo "TESTING: network bad IP (net_badip.exp)"
./net_badip.exp

echo "TESTING: network no IP test 1 (net_noip.exp)"
./net_noip.exp

echo "TESTING: network no IP test 2 (net_noip2.exp)"
./net_noip2.exp

echo "TESTING: network default gateway test 1 (net_defaultgw.exp)"
./net_defaultgw.exp

echo "TESTING: network default gateway test 2 (net_defaultgw2.exp)"
./net_defaultgw2.exp

echo "TESTING: network default gateway test 3 (net_defaultgw3.exp)"
./net_defaultgw3.exp

echo "TESTING: netfilter (net_netfilter.exp)"
./net_netfilter.exp

echo "TESTING: 4 bridges ARP (4bridges_arp.exp)"
./4bridges_arp.exp

echo "TESTING: 4 bridges IP (4bridges_ip.exp)"
./4bridges_ip.exp

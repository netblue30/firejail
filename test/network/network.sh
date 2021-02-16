#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

sudo ./configure

echo "TESTING: unconfigured network (net_unconfigured.exp)"
./net_unconfigured.exp

echo "TESTING: netfilter template (netfilter-template.exp)"
rm -f ./tcpserver
gcc -o tcpserver tcpserver.c
./netfilter-template.exp
rm ./tcpserver

echo "TESTING: firemon interface (firemon-interfaces.exp)"
sudo ./firemon-interfaces.exp

echo "TESTING: netns (netns.exp)"
./netns.exp

echo "TESTING: print dns (dns-print.exp)"
./dns-print.exp

echo "TESTING: firemon arp (firemon-arp.exp)"
./firemon-arp.exp

echo "TESTING: firemon netstats (netstats.exp)"
./netstats.exp

echo "TESTING: firemon route (firemon-route.exp)"
./firemon-route.exp

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

echo "TESTING: scan (net_scan.exp)"
./net_scan.exp

echo "TESTING: interface (interface.exp)"
./interface.exp

echo "TESTING: veth (net_veth.exp)"
./net_veth.exp

echo "TESTING: netfilter (net_netfilter.exp)"
./net_netfilter.exp

echo "TESTING: iprange (iprange.exp)"
./iprange.exp

echo "TESTING: veth-name (veth-name.exp)"
./veth-name.exp

echo "TESTING: macvlan2 (net_macvlan2.exp)"
./net_macvlan2.exp

echo "TESTING: 4 bridges ARP (4bridges_arp.exp)"
./4bridges_arp.exp

echo "TESTING: 4 bridges IP (4bridges_ip.exp)"
./4bridges_ip.exp

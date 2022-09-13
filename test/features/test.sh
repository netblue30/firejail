#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2022 Firejail Authors
# License GPL v2

export LC_ALL=C
OVERLAY="overlay"
CHROOT="chroot"
NETWORK="network"

while [ $# -gt 0 ]; do    # Until you run out of parameters . . .
    case "$1" in
    --nooverlay)
    	OVERLAY="none"
	;;
    --nochroot)
    	CHROOT="none"
	;;
    --nonetwork)
        NETWORK="none"
        ;;
    --help)
    	echo "./test.sh [--nooverlay|--nochroot|--nonetwork|--help] | grep TESTING"
    	exit
    	;;
    esac
    shift       # Check next set of parameters.
done




#
# Feature testing
#

####################
# Default features
####################
echo "TESTING: 1.1 disable /boot"
./1.1.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.2 new /proc"
./1.2.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.4 mask other users"
./1.4.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.5 PID namespace"
./1.5.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.6 new /var/log"
./1.6.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.7 new /var/tmp"
./1.7.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.8 disable firejail config and run time information"
./1.8.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 1.10 disable /selinux"
./1.10.exp "$OVERLAY" "$CHROOT"

####################
# networking features
####################
if [ $NETWORK == "network" ]
then
	echo "TESTING: 2.1 hostname"
	./2.1.exp "$OVERLAY" "$CHROOT"

	echo "TESTING: 2.2 DNS"
	./2.2.exp "$OVERLAY" "$CHROOT"

	echo "TESTING: 2.3 mac-vlan"
	./2.3.exp "$OVERLAY" "$CHROOT"

	echo "TESTING: 2.4 bridge"
	./2.4.exp "$OVERLAY" "$CHROOT"

	echo "TESTING: 2.5 interface"
	./2.5.exp "$OVERLAY" "$CHROOT"

	echo "TESTING: 2.6 Default gateway"
	./2.6.exp "$OVERLAY" "$CHROOT"
fi

####################
# filesystem features
####################
echo "TESTING: 3.1 private (fails on OpenSUSE)"
./3.1.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.2 read-only"
./3.2.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.3 blacklist"
./3.3.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.4 whitelist home (fails on OpenSUSE)"
./3.4.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.5 private-dev"
./3.5.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.6 private-etc"
./3.6.exp notworking "$CHROOT"

echo "TESTING: 3.7 private-tmp"
./3.7.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.8 private-bin"
./3.8.exp notworking notworking

echo "TESTING: 3.9 whitelist dev"
./3.9.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.10 whitelist tmp"
./3.10.exp "$OVERLAY" "$CHROOT"

echo "TESTING: 3.11 mkdir"
./3.11.exp "$OVERLAY" "$CHROOT"

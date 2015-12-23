#!/bin/bash
OVERLAY="overlay"
CHROOT="chroot"

while [ $# -gt 0 ]; do    # Until you run out of parameters . . .
    case "$1" in
    --nooverlay)
    	OVERLAY="none"
	;;
    --nochroot)
    	CHROOT="none"
	;;
    --help)
    	echo "./test.sh [--nooverlay|--nochroot|--help] | grep TESTING"
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
./1.1.exp $OVERLAY $CHROOT

echo "TESTING: 1.2 new /proc"
./1.2.exp $OVERLAY $CHROOT

echo "TESTING: 1.4 mask other users"
./1.4.exp $OVERLAY $CHROOT

echo "TESTING: 1.5 PID namespace"
./1.5.exp $OVERLAY $CHROOT

echo "TESTING: 1.6 new /var/log"
./1.6.exp $OVERLAY $CHROOT

echo "TESTING: 1.7 new /var/tmp"
./1.7.exp $OVERLAY $CHROOT

echo "TESTING: 1.8 disable /etc/firejail and ~/.config/firejail"
./1.8.exp $OVERLAY $CHROOT

echo "TESTING: 1.10 disable /selinux"
./1.10.exp $OVERLAY $CHROOT

####################
# networking features
####################
echo "TESTING: 2.1 hostname"
./2.1.exp $OVERLAY $CHROOT

echo "TESTING: 2.2 DNS"
./2.2.exp $OVERLAY $CHROOT

echo "TESTING: 2.3 mac-vlan"
./2.3.exp $OVERLAY $CHROOT

echo "TESTING: 2.4 bridge"
./2.4.exp $OVERLAY $CHROOT

echo "TESTING: 2.5 interface"
./2.5.exp $OVERLAY $CHROOT

echo "TESTING: 2.6 Default gateway"
./2.6.exp $OVERLAY $CHROOT

####################
# filesystem features
####################
echo "TESTING: 3.1 tmpfs"
./3.1.exp $OVERLAY $CHROOT

echo "TESTING: 3.2 read-only"
./3.2.exp $OVERLAY $CHROOT

echo "TESTING: 3.3 blacklist"
./3.3.exp $OVERLAY $CHROOT

echo "TESTING: 3.4 whitelist"
./3.4.exp $OVERLAY $CHROOT


#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

TCFILE=""
if [ -x "/usr/sbin/tc" ]; then
	TCFILE="/usr/sbin/tc"
elif [ -x "/sbin/tc" ]; then
	TCFILE="/sbin/tc";
else
	echo "Error: traffic control utility (tc) not found";
	exit 1
fi

usage() {
	echo "Usage:"
	echo "     fshaper.sh --status"
	echo "     fshaper.sh --clear device"
	echo "     fshaper.sh --set device download-speed upload-speed"
}

if [ "$1" = "--status" ]; then
	$TCFILE -s qdisc ls
	$TCFILE -s class ls
	exit
fi

if [ "$1" = "--clear" ]; then
	if [ $# -ne 2 ]; then
		echo "Error: invalid command"
		usage
		exit
	fi

	DEV=$2
	echo "Removing bandwidth limits"
	$TCFILE qdisc del dev $DEV root  2> /dev/null > /dev/null
	$TCFILE qdisc del dev $DEV ingress 2> /dev/null > /dev/null
	exit

fi

if [ "$1" = "--set" ]; then
	DEV=$2
	echo "Removing bandwidth limit"
	$TCFILE qdisc del dev $DEV ingress #2> /dev/null > /dev/null

	if [ $# -ne 4 ]; then
		echo "Error: missing parameters"
		usage
		exit
	fi

	DEV=$2
	echo "Configuring interface $DEV "

	IN=$3
	IN=$((${IN} * 8))
	echo "Download speed  ${IN}kbps"

	OUT=$4
	OUT=$((${OUT} * 8))
	echo "Upload speed  ${OUT}kbps"

	echo "cleaning limits"
	$TCFILE qdisc del dev $DEV root  2> /dev/null > /dev/null
	$TCFILE qdisc del dev $DEV ingress 2> /dev/null > /dev/null

	echo "configuring tc ingress"
	$TCFILE qdisc add dev $DEV handle ffff: ingress #2> /dev/null > /dev/null
	$TCFILE filter add dev $DEV parent ffff: protocol ip prio 50 u32 match ip src \
	   0.0.0.0/0 police rate ${IN}kbit burst 10k drop flowid :1 #2> /dev/null > /dev/null

	echo "configuring tc egress"
	$TCFILE qdisc add dev $DEV root tbf rate ${OUT}kbit latency 25ms burst 10k #2> /dev/null > /dev/null
	exit
fi

echo "Error: missing parameters"
usage
exit 1

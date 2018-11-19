#!/bin/bash

usage() {
	echo "Usage:"
	echo "     fshaper.sh --status"
	echo "     fshaper.sh --clear device"
	echo "     fshaper.sh --set device download-speed upload-speed"
}

if [ "$1" = "--status" ]; then
	/sbin/tc -s qdisc ls
	/sbin/tc -s class ls
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
	/sbin/tc qdisc del dev $DEV root  2> /dev/null > /dev/null
	/sbin/tc qdisc del dev $DEV ingress 2> /dev/null > /dev/null
	exit

fi

if [ "$1" = "--set" ]; then
	DEV=$2
	echo "Removing bandwidth limit"
	/sbin/tc qdisc del dev $DEV ingress #2> /dev/null > /dev/null

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
	/sbin/tc qdisc del dev $DEV root  2> /dev/null > /dev/null
	/sbin/tc qdisc del dev $DEV ingress 2> /dev/null > /dev/null

	echo "configuring tc ingress"
	/sbin/tc qdisc add dev $DEV handle ffff: ingress #2> /dev/null > /dev/null
	/sbin/tc filter add dev $DEV parent ffff: protocol ip prio 50 u32 match ip src \
	   0.0.0.0/0 police rate ${IN}kbit burst 10k drop flowid :1 #2> /dev/null > /dev/null

	echo "configuring tc egress"
	/sbin/tc qdisc add dev $DEV root tbf rate ${OUT}kbit latency 25ms burst 10k #2> /dev/null > /dev/null
	exit
fi

echo "Error: missing parameters"
usage
exit 1

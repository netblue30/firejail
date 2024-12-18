#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

_term() {
	echo "Caught Signal"
	echo 1
	sleep 1
	echo 2
	sleep 1
	echo 3
	sleep 1
	echo 4
	sleep 1
	echo 5
	sleep 1

	kill $pid
	exit
}

trap _term SIGTERM
trap _term SIGINT

echo "Sleeping..."

sleep inf &
pid=$!
wait $pid

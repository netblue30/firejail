#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C


#if grep -q "^CapBnd:\\s0000003fffffffff" /proc/self/status; then
	echo "TESTING: capabilities (test/filters/caps.exp)"
	./caps.exp
#else
#	echo "TESTING SKIP: other capabilities than expected (test/filters/caps.exp)"
#fi

echo "TESTING: capabilities print (test/filters/caps-print.exp)"
./caps-print.exp

echo "TESTING: capabilities join (test/filters/caps-join.exp)"
./caps-join.exp

echo "TESTING: firemon caps (test/utils/firemon-caps.exp)"
./firemon-caps.exp


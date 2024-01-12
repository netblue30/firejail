#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C


#	sudo /usr/sbin/apparmor_parser -r /etc/apparmor.d/firejail-default


if [[ -f /sys/kernel/security/apparmor/profiles ]]; then
	# setup
	cp test-profile /tmp/.
	sudo /usr/sbin/apparmor_parser -r /tmp/test-profile
	cp /usr/bin/pwd a.out

	echo "TESTING: apparmor firemon (test/filters/apparmor.exp)"
	./apparmor.exp

	echo "TESTING: apparmor norun test (test/filters/apparmor-norun.exp)"
	./apparmor-norun.exp

	echo "TESTING: apparmor run test (test/filters/apparmor-run.exp)"
	./apparmor-run.exp

	# cleanup
	rm -f a.out
	sudo /usr/sbin/apparmor_parser -R /tmp/test-profile

else
	echo "TESTING SKIP: no apparmor support in Linux kernel (test/filters/apparmor.exp)"
fi


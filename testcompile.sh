#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

# A simple script testing all compile-time config options.

# shellcheck source=config.sh

output=/tmp/testcompile-output.tmp
result=/tmp/testcompile-result.tmp
total_errors=0

testconfigure() {
	msg="$1"
	shift

	printf '%s...' "$msg" >> "$result"
	make distclean
	./configure "$@" 2>&1 | tee -a "$output"

	errors="$(grep -E '(WARNING|ERROR)' "$output" | wc -l)"
	printf '%s\n' "$errors"
	if test "$errors" -gt "$total_errors"; then
		total_errors="$errors"
		printf 'TESTING ERROR - %s\n' "$msg"
		echo " FAIL configure" >> "$result"
	fi
}

testmake() {
	msg="$1"
	shift

	make "$@" 2>&1 | tee -a "$output"

	errors="$(grep -E -i 'error:' "$output" | wc -l)"
	printf '%s\n' "$errors"
	if test "$errors" -gt "$total_errors"; then
		total_errors="$errors"
		printf 'TESTING ERROR - %s\n' "$msg"
		echo " FAIL make" >> "$result"
	else
		echo " OK" >> "$result"
	fi
}

: > "$output"
: > "$result"

msg='default'
testconfigure "$msg" --enable-fatal-warnings &&
testmake "$msg" -j4

msg='disable dbus proxy configuration'
testconfigure "$msg" --enable-fatal-warnings --disable-dbusproxy &&
testmake "$msg" -j4

msg='disable chroot configuration'
testconfigure "$msg" --enable-fatal-warnings --enable-chroot &&
testmake "$msg" -j4

msg='disable user namespace configuration'
testconfigure "$msg" --enable-fatal-warnings --disable-userns &&
testmake "$msg" -j4

msg='disable network namespace configuration'
testconfigure "$msg" --enable-fatal-warnings --disable-network &&
testmake "$msg" -j4

msg='disable X11 support'
testconfigure "$msg" --enable-fatal-warnings --disable-x11 &&
testmake "$msg" -j4

msg='enable selinux'
testconfigure "$msg" --enable-fatal-warnings --enable-selinux &&
testmake "$msg" -j4

msg='disable file transfer'
testconfigure "$msg" --enable-fatal-warnings --disable-file-transfer &&
testmake "$msg" -j4

msg='enable apparmor'
testconfigure "$msg" --enable-fatal-warnings --enable-apparmor &&
testmake "$msg" -j4

msg='disable landlock'
testconfigure "$msg" --enable-fatal-warnings --disable-landlock &&
testmake "$msg" -j4

msg='disable output logging'
testconfigure "$msg" --enable-fatal-warnings --disable-output &&
testmake "$msg" -j4

msg='disable private-lib'
testconfigure "$msg" --enable-fatal-warnings --disable-private-lib &&
testmake "$msg" -j4

msg='enable-only-syscfg-profiles'
testconfigure "$msg" --enable-fatal-warnings --enable-only-syscfg-profiles &&
testmake "$msg" -j4

msg='enable force nonewprivs'
testconfigure "$msg" --enable-fatal-warnings --enable-force-nonewprivs &&
testmake "$msg" -j4

echo "cleanup" >> "$result"
make distclean

echo "*******************************************"
echo "All fine!!!" >> "$result"
cat "$result"

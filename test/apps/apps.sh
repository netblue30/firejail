#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2
#
# quick test for several applications
#
export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

# shellcheck source=test/apps/applist.sh
. "$(dirname "$0")"/applist.sh || exit 1

testapp() {
	app="$1"

	sudo true
	echo "TESTING: $app (test/apps/$app.exp)"
	./"$app".exp
	sleep 1
}

# keeping sudo available
sudo ls

# console apps
for app in "${apps[@]}"; do
	if command -v "$app"
	then
		echo "TESTING: $app"
		./"$app".exp
	else
		echo "TESTING SKIP: $app not found"
	fi
done
rm -f index.html
rm wget-log*
sudo true

# testing seccomp @clock group
echo "TESTING: firejail problems **************************"
echo "TESTING: seccomp @clock group (test/apps/seccomp-clock.exp)"
./seccomp-clock.exp

echo "TESTING: pid 1 functionality (test/apps/pid1.exp)"
./pid1.exp

# x11 sandboxing
echo "TESTING: x11 sandboxing *********************************"
for app in "${x11apps[@]}"; do
	testapp "$app"
done

# browsers
echo "TESTING: browsers ***************************************"
for app in "${browsers[@]}"; do
	testapp "$app"
done

# multimedia apps
echo "TESTING: multimedia apps ************************************"
for app in "${multimedia[@]}"; do
	testapp "$app"
done

echo "TESTING: games ************************************"
for app in "${games[@]}"; do
	testapp "$app"
done

# desktop apps
echo "TESTING: desktop apps ************************************"
for app in "${desktopapps[@]}"; do
	testapp "$app"
done

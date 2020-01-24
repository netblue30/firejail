#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2020 Firejail Authors
# License GPL v2
#
# Purpose: Fetch, compile, and install firejail from GitHub source. Package-manager agnostic.
#

set -e		# exit immediately if one of the commands fails
cd /tmp		# by the time we start this, we should have a tmpfs mounted on top of /tmp
git clone --depth=1 https://www.github.com/netblue30/firejail.git
cd firejail
./configure --enable-git-install
sudo make uninstall
echo "**********************************************************************"
echo "Firejail mainline git version uninstalled from /usr/local"
echo
echo "**********************************************************************"
cd ..
rm -rf firejail

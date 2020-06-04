#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2020 Firejail Authors
# License GPL v2

# Purpose: Fetch, compile, and install firejail from GitHub source. For
# Debian-based distros only (Ubuntu, Mint, etc).
set -e
git clone --depth=1 https://github.com/netblue30/firejail.git
cd firejail
./configure --enable-apparmor --prefix=/usr
make deb
sudo dpkg -i firejail*.deb
echo "Firejail was updated!"
cd ..
rm -rf firejail

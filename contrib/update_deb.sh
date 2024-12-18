#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# Purpose: Fetch, compile, and install firejail from GitHub source. For
# Debian-based distros only (Ubuntu, Mint, etc).
set -e

git clone --depth=1 https://github.com/netblue30/firejail.git
cd firejail
./configure

# Fix https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=916920
sed -i "s/# restricted-network .*/restricted-network yes/" \
    etc/firejail.config

make deb
sudo dpkg -i ./*.deb
echo "Firejail updated."
cd ..
rm -rf firejail

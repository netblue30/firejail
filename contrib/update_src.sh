#!/bin/sh
# Purpose: Fetch, compile, and install firejail from GitHub source. Package-manager agnostic.
set -e
git clone --depth=1 https://www.github.com/netblue30/firejail.git
cd firejail
./configure
make
sudo make install-strip
echo "Firejail was updated!"
cd ..
rm -rf firejail

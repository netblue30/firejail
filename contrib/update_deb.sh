#!/bin/bash
# Purpose: Fetch, compile, and install firejail from GitHub source. For 
#			Debian-based distros only (Ubuntu, Mint, etc).
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

git clone https://www.github.com/netblue30/firejail.git
cd firejail
./configure --prefix=/usr
make deb
dpkg -i firejail*.deb
echo "Firejail was updated!"
sleep 3
cd ..
rm -rf firejail

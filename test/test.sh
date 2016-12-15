#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

./chk_config.exp

./fscheck.sh

echo "TESTING: tty (tty.exp)"
./tty.exp

sleep 1
rm -fr dir\ with\ space
mkdir dir\ with\ space
echo "TESTING: blacklist (blacklist.exp)"
./blacklist.exp
sleep 1
rm -fr dir\ with\ space

ln -s auto auto2
ln -s /bin auto3
ln -s /usr/bin auto4
echo "TESTING: blacklist directory link (blacklist-link.exp)"
./blacklist-link.exp
rm -fr auto2
rm -fr auto3
rm -fr auto4

echo "TESTING: chroot overlay (option_chroot_overlay.exp)"
./option_chroot_overlay.exp

echo "TESTING: chroot as user (fs_chroot.exp)"
./fs_chroot.exp

echo "TESTING: /sys (fs_sys.exp)"
./fs_sys.exp

echo "TESTING: readonly (option_readonly.exp)"
ls -al > tmpreadonly
./option_readonly.exp
sleep 5
rm -f tmpreadonly



echo "TESTING: private directory (private_dir.exp)"
rm -fr dirprivate
mkdir dirprivate
./private_dir.exp
rm -fr dirprivate

echo "TESTING: private directory profile (private_dir_profile.exp)"
rm -fr dirprivate
mkdir dirprivate
./private_dir_profile.exp
rm -fr dirprivate

echo "TESTING: overlayfs (fs_overlay.exp)"
./fs_overlay.exp

echo "TESTING: login SSH (login_ssh.exp)"
./login_ssh.exp

echo "TESTING: firemon --arp (firemon-arp.exp)"
./firemon-arp.exp

echo "TESTING: firemon --route (firemon-route.exp)"
./firemon-route.exp



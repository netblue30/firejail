#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

rm -f unchroot
gcc -o unchroot unchroot.c
sudo ./configure


echo "TESTING: chroot disabled (test/chroot/fs_chroot_disabled.exp)"
sudo sed -i s/"chroot yes"/"# chroot no"/g /etc/firejail/firejail.config
./fs_chroot_disabled.exp


echo "TESTING: chroot (test/chroot/fs_chroot.exp)"
sudo sed -i s/"# chroot no"/"chroot yes"/g /etc/firejail/firejail.config
./fs_chroot.exp

echo "TESTING: unchroot as root (test/chroot/unchroot-as-root.exp)"
sudo ./unchroot-as-root.exp

rm -f unchroot

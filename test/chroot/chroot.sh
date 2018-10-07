#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2018 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

rm -f unchroot
gcc -o unchroot unchroot.c
sudo ./configure

echo "TESTING: chroot (test/chroot/fs_chroot.exp)"
./fs_chroot.exp

echo "TESTING: unchroot as root (test/chroot/unchroot-as-root.exp)"
sudo ./unchroot-as-root.exp



rm -f unchroot

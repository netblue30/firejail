#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

sudo mkdir /tmp/ttt
sudo firecfg
sudo firecfg --bindir=/tmp/ttt

echo "TESTING: firecfg (test/firecfg/firecfg.exp)"
./firecfg.exp

sudo rm -fr /tmp/ttt

sudo cp -f firejail-program-args.sh /usr/bin/firejail-program-args
sudo printf 'firejail-program-args\n' >/etc/firejail/firecfg.d/firejail-program-args.conf
sudo firecfg
echo "TESTING: firejail-program-args (test/firecfg/firejail-program-args.exp)"
./firejail-program-args.exp
sudo rm -f /etc/firejail/firecfg.d/firejail-program-args.conf
sudo rm -f /usr/bin/firejail-program-args

cd ../../
./mkgcov.sh

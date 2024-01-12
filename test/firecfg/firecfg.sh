#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
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

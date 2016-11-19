#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

mkdir dest

echo "TESTING: fcopy cmdline (test/fcopy/cmdline.exp)"
./cmdline.exp

echo "TESTING: fcopy directory (test/fcopy/dircopy.exp)"
./dircopy.exp

echo "TESTING: fcopy file (test/fcopy/filecopy.exp)"
./filecopy.exp

echo "TESTING: fcopy link (test/fcopy/linkcopy.exp)"
./linkcopy.exp

rm -fr dest/*

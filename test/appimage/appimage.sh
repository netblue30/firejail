#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

echo "TESTING: AppImage v2 (test/appimage/appimage-v2.exp)"
./appimage-v2.exp

echo "TESTING: AppImage file name (test/appimage/filename.exp)"
./filename.exp

echo "TESTING: AppImage args (test/appimage/appimage-args.exp)"
./appimage-args.exp

echo "TESTING: AppImage trace (test/appimage/appimage-trace.exp)"
./appimage-trace.exp

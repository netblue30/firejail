#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License MIT

FIREJAIL_SYMLINK=1
export FIREJAIL_SYMLINK

bindir="/usr/bin"
basename="$(basename "$0")"

exec firejail "$bindir/$basename" "$@"

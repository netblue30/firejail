#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

echo "extracting UID_MIN and GID_MIN"
echo "#ifndef FIREJAIL_UIDS_H" > uids.h
echo "#define FIREJAIL_UIDS_H" >> uids.h

if [ -r /etc/login.defs ]
then
	UID_MIN="$(awk '/^\s*UID_MIN\s*([0-9]*).*?$/ {print $2}' /etc/login.defs)"
	GID_MIN="$(awk '/^\s*GID_MIN\s*([0-9]*).*?$/ {print $2}' /etc/login.defs)"
fi

# use default values if not found
[ -z "$UID_MIN" ] && UID_MIN="1000"
[ -z "$GID_MIN" ] && GID_MIN="1000"

echo "#define UID_MIN $UID_MIN" >> uids.h
echo "#define GID_MIN $GID_MIN" >> uids.h

echo "#endif" >> uids.h

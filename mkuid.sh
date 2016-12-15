#!/bin/sh

echo "extracting UID_MIN and GID_MIN"
echo "#ifndef FIREJAIL_UIDS_H" > uids.h
echo "#define FIREJAIL_UIDS_H" >> uids.h

if [ -r /etc/login.defs ]
then
	echo "// using values extracted from /etc/login.defs" >> uids.h
	UID_MIN=`awk '/^\s*UID_MIN\s*([0-9]*).*?$/ {print $2}' /etc/login.defs`
	GID_MIN=`awk '/^\s*GID_MIN\s*([0-9]*).*?$/ {print $2}' /etc/login.defs`
	echo "#define UID_MIN $UID_MIN" >> uids.h
	echo "#define GID_MIN $GID_MIN" >> uids.h
else
	echo "// using default values" >> uids.h
	echo "#define UID_MIN 1000" >> uids.h
	echo "#define GID_MIN 1000" >> uids.h
fi

echo "#endif" >> uids.h

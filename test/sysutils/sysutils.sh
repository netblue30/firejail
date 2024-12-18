#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

if command -v gzip
then
	echo "TESTING: gzip"
	./gzip.exp
else
	echo "TESTING SKIP: md5sum not found"
fi

if command -v md5sum
then
	echo "TESTING: md5sum"
	./md5sum.exp
else
	echo "TESTING SKIP: md5sum not found"
fi

if command -v sha512sum
then
	echo "TESTING: sha512sum"
	./sha512sum.exp
else
	echo "TESTING SKIP: sha512sum not found"
fi

if command -v cpio
then
	echo "TESTING: cpio"
	./cpio.exp
else
	echo "TESTING SKIP: cpio not found"
fi

if command -v gzip
then
	echo "TESTING: gzip"
	./gzip.exp
else
	echo "TESTING SKIP: gzip not found"
fi

if command -v xz
then
	echo "TESTING: xz"
	./xz.exp
else
	echo "TESTING SKIP: xz not found"
fi

if command -v less
then
	echo "TESTING: less"
	./less.exp
else
	echo "TESTING SKIP: less not found"
fi

if command -v file
then
	echo "TESTING: file"
	./file.exp
else
	echo "TESTING SKIP: file not found"
fi

if command -v tar
then
	echo "TESTING: tar"
	./tar.exp
else
	echo "TESTING SKIP: tar not found"
fi

if command -v ping
then
	echo "TESTING: ping"
	./ping.exp
else
	echo "TESTING SKIP: ping not found"
fi

if command -v dig
then
	echo "TESTING: dig"
	./dig.exp
else
	echo "TESTING SKIP: dig not found"
fi

if command -v host
then
	echo "TESTING: host"
	./host.exp
else
	echo "TESTING SKIP: host not found"
fi

if command -v nslookup
then
	echo "TESTING: nslookup"
	./host.exp
else
	echo "TESTING SKIP: nslookup not found"
fi

if command -v man
then
	echo "TESTING: man"
	./man.exp
else
	echo "TESTING SKIP: man not found"
fi

if command -v wget
then
	echo "TESTING: FIXME: wget"
	#./wget.exp # FIXME: Broken in CI
else
	echo "TESTING SKIP: wget not found"
fi

if command -v curl
then
	echo "TESTING: curl"
	./curl.exp
else
	echo "TESTING SKIP: curl not found"
fi

if command -v strings
then
	echo "TESTING: FIXME: strings"
	#./strings.exp # FIXME: Broken since commit 3077b2d1f
else
	echo "TESTING SKIP: strings not found"
fi

if command -v whois
then
	echo "TESTING: whois"
	./whois.exp
else
	echo "TESTING SKIP: whois not found"
fi

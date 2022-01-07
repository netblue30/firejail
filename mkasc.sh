#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2022 Firejail Authors
# License GPL v2

echo "Calculating SHA256 for all files in /transfer - firejail version $1"

cd /transfer || exit 1
sha256sum ./* > "firejail-$1-unsigned"
gpg --clearsign --digest-algo SHA256 < "firejail-$1-unsigned" > "firejail-$1.asc"
gpg --verify "firejail-$1.asc"
gpg --detach-sign --armor "firejail-$1.tar.xz"
rm "firejail-$1-unsigned"

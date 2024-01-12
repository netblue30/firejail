#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

. "$(dirname "$0")/config.sh" || exit 1

printf 'Calculating SHA256 for all files in /transfer - %s version %s' "$TARNAME" "$VERSION"

cd /transfer || exit 1
sha256sum ./* > "$TARNAME-$VERSION-unsigned"
gpg --clearsign --digest-algo SHA256 < "$TARNAME-$VERSION-unsigned" > "$TARNAME-$VERSION.asc"
gpg --verify "$TARNAME-$VERSION.asc"
gpg --detach-sign --armor "$TARNAME-$VERSION.tar.xz"
rm "$TARNAME-$VERSION-unsigned"

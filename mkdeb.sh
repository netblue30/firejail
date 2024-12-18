#!/bin/sh
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# based on http://tldp.org/HOWTO/html_single/Debian-Binary-Package-Building-HOWTO/
# a code archive should already be available

set -e

. "$(dirname "$0")/config.sh"

CODE_ARCHIVE="$TARNAME-$VERSION.tar.xz"
CODE_DIR="$TARNAME-$VERSION"
INSTALL_DIR="${INSTALL_DIR}${CODE_DIR}/debian"
DEBIAN_CTRL_DIR="${DEBIAN_CTRL_DIR}${CODE_DIR}/debian/DEBIAN"

echo "*****************************************"
echo "code archive: $CODE_ARCHIVE"
echo "code directory: $CODE_DIR"
echo "install directory: $INSTALL_DIR"
echo "debian control directory: $DEBIAN_CTRL_DIR"
echo "*****************************************"

tar -xJvf "$CODE_ARCHIVE"
#mkdir -p "$INSTALL_DIR"
cd "$CODE_DIR"
./configure --prefix=/usr --enable-apparmor "$@"
make -j "$(nproc)"
mkdir debian
DESTDIR=debian make install-strip

cd ..
echo "*****************************************"
SIZE="$(du -s "$INSTALL_DIR")"
echo "install size $SIZE"
echo "*****************************************"

mv "$INSTALL_DIR/usr/share/doc/firejail/RELNOTES" "$INSTALL_DIR/usr/share/doc/firejail/changelog.Debian"
gzip -9 -n "$INSTALL_DIR/usr/share/doc/firejail/changelog.Debian"
rm "$INSTALL_DIR/usr/share/doc/firejail/COPYING"
install -m644 "$CODE_DIR/platform/debian/copyright" "$INSTALL_DIR/usr/share/doc/firejail/."
mkdir -p "$DEBIAN_CTRL_DIR"
sed "s/FIREJAILVER/$VERSION/g" "$CODE_DIR/platform/debian/control.$(dpkg-architecture -qDEB_HOST_ARCH)" > "$DEBIAN_CTRL_DIR/control"

mkdir -p "$INSTALL_DIR/usr/share/lintian/overrides/"
install -m644 "$CODE_DIR/platform/debian/firejail.lintian-overrides" "$INSTALL_DIR/usr/share/lintian/overrides/firejail"

find "$INSTALL_DIR/etc" -type f | sed "s,^$INSTALL_DIR,," | LC_ALL=C sort > "$DEBIAN_CTRL_DIR/conffiles"
chmod 644 "$DEBIAN_CTRL_DIR/conffiles"
find "$INSTALL_DIR" -type d -exec chmod 755 '{}' +
cd "$CODE_DIR"
fakeroot dpkg-deb --build debian
lintian --no-tag-display-limit debian.deb
mv debian.deb "../firejail_${VERSION}${EXTRA_VERSION}_1_$(dpkg-architecture -qDEB_HOST_ARCH).deb"
cd ..
rm -fr "$CODE_DIR"

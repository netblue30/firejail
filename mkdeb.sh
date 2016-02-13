#!/bin/sh
# based on http://tldp.org/HOWTO/html_single/Debian-Binary-Package-Building-HOWTO/
# a code archive should already be available

TOP=`pwd`
CODE_ARCHIVE="$1-$2.tar.bz2"
CODE_DIR="$1-$2"
INSTALL_DIR="${INSTALL_DIR}${CODE_DIR}/debian"
DEBIAN_CTRL_DIR="${DEBIAN_CTRL_DIR}${CODE_DIR}/debian/DEBIAN"

echo "*****************************************"
echo "code archive: $CODE_ARCHIVE"
echo "code directory: $CODE_DIR"
echo "install directory: $INSTALL_DIR"
echo "debian control directory: $DEBIAN_CTRL_DIR"
echo "*****************************************"

tar -xjvf $CODE_ARCHIVE
#mkdir -p $INSTALL_DIR
cd $CODE_DIR
./configure --prefix=/usr
make
mkdir debian
DESTDIR=debian make install-strip

cd ..
echo "*****************************************"
SIZE=`du -s $INSTALL_DIR`
echo "install size $SIZE"
echo "*****************************************"

mv $INSTALL_DIR/usr/share/doc/firejail/RELNOTES $INSTALL_DIR/usr/share/doc/firejail/changelog.Debian
gzip -9 $INSTALL_DIR/usr/share/doc/firejail/changelog.Debian
rm $INSTALL_DIR/usr/share/doc/firejail/COPYING
cp platform/debian/copyright $INSTALL_DIR/usr/share/doc/firejail/.
mkdir -p $DEBIAN_CTRL_DIR
sed "s/FIREJAILVER/$2/g"  platform/debian/control > $DEBIAN_CTRL_DIR/control

mkdir -p $INSTALL_DIR/usr/share/lintian/overrides/
cp platform/debian/firejail.lintian-overrides $INSTALL_DIR/usr/share/lintian/overrides/firejail

cp platform/debian/conffiles $DEBIAN_CTRL_DIR/.
find $INSTALL_DIR  -type d | xargs chmod 755
cd $CODE_DIR
fakeroot dpkg-deb --build debian
lintian debian.deb
mv debian.deb ../firejail_$2_1_amd64.deb
echo "if building a 32bit package, rename the deb file manually"
cd ..
rm -fr $CODE_DIR








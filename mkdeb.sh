#!/bin/bash

# a code archive should already be available

TOP=`pwd`
CODE_ARCHIVE="$1-$2.tar.bz2"
CODE_DIR="$1-$2"
INSTALL_DIR=$TOP
INSTALL_DIR+="/debian/usr"
DEBIAN_CTRL_DIR=$TOP
DEBIAN_CTRL_DIR+="/debian/DEBIAN"

echo "*****************************************"
echo "code archive: $CODE_ARCHIVE"
echo "code directory: $CODE_DIR"
echo "install directory: $INSTALL_DIR"
echo "debian control directory: $DEBIAN_CTRL_DIR"
echo "*****************************************"
tar -xjvf $CODE_ARCHIVE
mkdir -p $INSTALL_DIR
cd $CODE_DIR
./configure --prefix=$INSTALL_DIR
make && make install

# second compilation - the path to libtrace.so is hardcoded in firejail executable
# pointing according to --prefix=$INSTALL_DIR. We need it to point to /usr/lib 
make distclean
./configure --prefix=/usr
make
# install firejail executable in $TOP/$INSTALL_DIR
strip src/firejail/firejail
install -c -m 0755 src/firejail/firejail $INSTALL_DIR/bin/.
chmod u+s $INSTALL_DIR/bin/firejail


cd ..
echo "*****************************************"
SIZE=`du -s debian/usr`
echo "install size $SIZE"
echo "*****************************************"

mv $INSTALL_DIR/share/doc/firejail/RELNOTES $INSTALL_DIR/share/doc/firejail/changelog.Debian
gzip -9 $INSTALL_DIR/share/doc/firejail/changelog.Debian
rm $INSTALL_DIR/share/doc/firejail/COPYING
cp platform/debian/copyright $INSTALL_DIR/share/doc/firejail/.
mkdir -p $DEBIAN_CTRL_DIR
sed "s/FIREJAILVER/$2/g"  platform/debian/control > $DEBIAN_CTRL_DIR/control
mkdir -p debian/etc/firejail
cp etc/chromium.profile debian/etc/firejail/.
cp etc/chromium-browser.profile debian/etc/firejail/.
cp etc/disable-mgmt.inc debian/etc/firejail/.
cp etc/disable-secret.inc debian/etc/firejail/.
cp etc/dropbox.profile debian/etc/firejail/.
cp etc/evince.profile debian/etc/firejail/.
cp etc/firefox.profile debian/etc/firejail/.
cp etc/iceweasel.profile debian/etc/firejail/.
cp etc/icedove.profile debian/etc/firejail/.
cp etc/login* debian/etc/firejail/.
cp etc/midori.profile debian/etc/firejail/.
cp etc/opera.profile debian/etc/firejail/.
cp etc/thunderbird.profile debian/etc/firejail/.
cp etc/transmission-gtk.profile debian/etc/firejail/.
cp etc/transmission-qt.profile debian/etc/firejail/.
cp etc/vlc.profile debian/etc/firejail/.
cp etc/audacious.profile debian/etc/firejail/.
cp etc/clementine.profile debian/etc/firejail/.
cp etc/gnome-mplayer.profile debian/etc/firejail/.
cp etc/rhythmbox.profile debian/etc/firejail/.
cp etc/totem.profile debian/etc/firejail/.
cp etc/deluge.profile debian/etc/firejail/.
cp etc/qbittorrent.profile debian/etc/firejail/.
cp etc/generic.profile debian/etc/firejail/.
cp etc/xchat.profile debian/etc/firejail/.
cp etc/server.profile debian/etc/firejail/.
cp etc/quassel.profile debian/etc/firejail/.
cp etc/pidgin.profile debian/etc/firejail/.
cp etc/filezilla.profile debian/etc/firejail/.
cp etc/empathy.profile debian/etc/firejail/.
cp etc/disable-common.inc debian/etc/firejail/.
cp etc/deadbeef.profile debian/etc/firejail/.
cp etc/icecat.profile debian/etc/firejail/.
cp platform/debian/conffiles $DEBIAN_CTRL_DIR/.
find ./debian -type d | xargs chmod 755
dpkg-deb --build debian
lintian debian.deb
mv debian.deb firejail_$2_1_amd64.deb
echo "if building a 32bit package, rename the deb file manually"
rm -fr debian
rm -fr $CODE_DIR








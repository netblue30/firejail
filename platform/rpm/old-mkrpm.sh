#!/bin/bash
VERSION="0.9.44"
rm -fr ~/rpmbuild
rm -f firejail-$VERSION-1.x86_64.rpm

mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}
cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

cd ~/rpmbuild
echo "building directory tree"

mkdir -p firejail-$VERSION/usr/bin
install -m 755 /usr/bin/firejail firejail-$VERSION/usr/bin/.
install -m 755 /usr/bin/firemon firejail-$VERSION/usr/bin/.
install -m 755 /usr/bin/firecfg firejail-$VERSION/usr/bin/.

mkdir -p  firejail-$VERSION/usr/lib/firejail
install -m 755 /usr/lib/firejail/faudit  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/firecfg.config  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fshaper.sh  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/ftee  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/libtrace.so  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/libtracelog.so  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/libconnect.so  firejail-$VERSION/usr/lib/firejail/.

mkdir -p firejail-$VERSION/usr/share/man/man1
install -m 644 /usr/share/man/man1/firejail.1.gz firejail-$VERSION/usr/share/man/man1/.
install -m 644 /usr/share/man/man1/firemon.1.gz firejail-$VERSION/usr/share/man/man1/.
install -m 644 /usr/share/man/man1/firecfg.1.gz firejail-$VERSION/usr/share/man/man1/.

mkdir -p firejail-$VERSION/usr/share/man/man5
install -m 644 /usr/share/man/man5/firejail-profile.5.gz firejail-$VERSION/usr/share/man/man5/.
install -m 644 /usr/share/man/man5/firejail-login.5.gz firejail-$VERSION/usr/share/man/man5/.

mkdir -p firejail-$VERSION/usr/share/doc/packages/firejail
install -m 644 /usr/share/doc/firejail/COPYING firejail-$VERSION/usr/share/doc/packages/firejail/.
install -m 644 /usr/share/doc/firejail/README firejail-$VERSION/usr/share/doc/packages/firejail/.
install -m 644 /usr/share/doc/firejail/RELNOTES firejail-$VERSION/usr/share/doc/packages/firejail/.

mkdir -p firejail-$VERSION/etc/firejail
install -m 644 /etc/firejail/0ad.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/abrowser.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/atom-beta.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/atom.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/atril.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/audacious.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/audacity.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/aweather.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/bitlbee.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/brave.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/cherrytree.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/chromium-browser.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/chromium.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/clementine.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/cmus.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/conkeror.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/corebird.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/cpio.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/cyberfox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/Cyberfox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/deadbeef.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/default.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/deluge.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/dillo.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/disable-common.inc firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/disable-devel.inc firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/disable-passwdmgr.inc firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/disable-programs.inc firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/dnscrypt-proxy.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/dnsmasq.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/dosbox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/dropbox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/empathy.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/eom.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/epiphany.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/evince.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/fbreader.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/file.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/filezilla.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/firefox-esr.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/firefox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/firejail.config firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/flashpeak-slimjet.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/franz.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gajim.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gitter.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gnome-chess.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gnome-mplayer.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/google-chrome-beta.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/google-chrome.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/google-chrome-stable.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/google-chrome-unstable.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/google-play-music-desktop-player.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gpredict.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gtar.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gthumb.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gwenview.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gzip.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/hedgewars.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/hexchat.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/icecat.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/icedove.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/iceweasel.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/inox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/jitsi.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/kmail.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/konversation.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/less.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/libreoffice.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/localc.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/lodraw.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/loffice.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/lofromtemplate.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/login.users firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/loimpress.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/lomath.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/loweb.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/lowriter.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/lxterminal.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/mathematica.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/Mathematica.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/mcabber.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/midori.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/mpv.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/mupen64plus.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/netsurf.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/nolocal.net firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/okular.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/openbox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/opera-beta.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/opera.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/palemoon.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/parole.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/pidgin.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/pix.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/polari.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/psi-plus.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/qbittorrent.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/qtox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/quassel.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/quiterss.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/qutebrowser.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/rhythmbox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/rtorrent.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/seamonkey-bin.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/seamonkey.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/server.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/skypeforlinux.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/skype.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/slack.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/snap.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/soffice.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/spotify.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/ssh.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/steam.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/stellarium.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/strings.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/tar.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/telegram.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/Telegram.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/thunderbird.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/totem.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/transmission-gtk.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/transmission-qt.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/uget-gtk.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/unbound.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/unrar.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/unzip.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/uudeview.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/vivaldi-beta.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/vivaldi.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/vlc.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/warzone2100.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/webserver.net firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/weechat-curses.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/weechat.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/wesnoth.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/whitelist-common.inc firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/wine.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xchat.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xplayer.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xreader.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xviewer.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xzdec.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xz.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/zathura.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/7z.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/keepass.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/keepassx.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/claws-mail.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/mutt.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/git.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/emacs.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/vim.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/xpdf.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/virtualbox.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/openshot.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/flowblade.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/eog.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/evolution.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/feh.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/gimp.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/inkscape.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/luminance-hdr.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/mupdf.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/qpdfview.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/ranger.profile firejail-$VERSION/etc/firejail/.
install -m 644 /etc/firejail/synfigstudio.profile firejail-$VERSION/etc/firejail/.


mkdir -p firejail-$VERSION/usr/share/bash-completion/completions
install -m 644 /usr/share/bash-completion/completions/firejail  firejail-$VERSION/usr/share/bash-completion/completions/.
install -m 644 /usr/share/bash-completion/completions/firemon  firejail-$VERSION/usr/share/bash-completion/completions/.
install -m 644 /usr/share/bash-completion/completions/firecfg  firejail-$VERSION/usr/share/bash-completion/completions/.

echo "building tar.gz archive"
tar -czvf firejail-$VERSION.tar.gz firejail-$VERSION

cp firejail-$VERSION.tar.gz SOURCES/.

echo "building config spec"
cat <<EOF > SPECS/firejail.spec
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: Linux namepaces sandbox program
Name: firejail
Version: $VERSION
Release: 1
License: GPL+
Group: Development/Tools
SOURCE0 : %{name}-%{version}.tar.gz
URL: http://firejail.wordpress.com

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
Firejail  is  a  SUID sandbox program that reduces the risk of security
breaches by restricting the running environment of untrusted applications
using Linux namespaces. It includes a sandbox profile for Mozilla Firefox.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
%config(noreplace) %{_sysconfdir}/%{name}/0ad.profile
%config(noreplace) %{_sysconfdir}/%{name}/abrowser.profile
%config(noreplace) %{_sysconfdir}/%{name}/atom-beta.profile
%config(noreplace) %{_sysconfdir}/%{name}/atom.profile
%config(noreplace) %{_sysconfdir}/%{name}/atril.profile
%config(noreplace) %{_sysconfdir}/%{name}/audacious.profile
%config(noreplace) %{_sysconfdir}/%{name}/audacity.profile
%config(noreplace) %{_sysconfdir}/%{name}/aweather.profile
%config(noreplace) %{_sysconfdir}/%{name}/bitlbee.profile
%config(noreplace) %{_sysconfdir}/%{name}/brave.profile
%config(noreplace) %{_sysconfdir}/%{name}/cherrytree.profile
%config(noreplace) %{_sysconfdir}/%{name}/chromium-browser.profile
%config(noreplace) %{_sysconfdir}/%{name}/chromium.profile
%config(noreplace) %{_sysconfdir}/%{name}/clementine.profile
%config(noreplace) %{_sysconfdir}/%{name}/cmus.profile
%config(noreplace) %{_sysconfdir}/%{name}/conkeror.profile
%config(noreplace) %{_sysconfdir}/%{name}/corebird.profile
%config(noreplace) %{_sysconfdir}/%{name}/cpio.profile
%config(noreplace) %{_sysconfdir}/%{name}/cyberfox.profile
%config(noreplace) %{_sysconfdir}/%{name}/Cyberfox.profile
%config(noreplace) %{_sysconfdir}/%{name}/deadbeef.profile
%config(noreplace) %{_sysconfdir}/%{name}/default.profile
%config(noreplace) %{_sysconfdir}/%{name}/deluge.profile
%config(noreplace) %{_sysconfdir}/%{name}/dillo.profile
%config(noreplace) %{_sysconfdir}/%{name}/disable-common.inc
%config(noreplace) %{_sysconfdir}/%{name}/disable-devel.inc
%config(noreplace) %{_sysconfdir}/%{name}/disable-passwdmgr.inc
%config(noreplace) %{_sysconfdir}/%{name}/disable-programs.inc
%config(noreplace) %{_sysconfdir}/%{name}/dnscrypt-proxy.profile
%config(noreplace) %{_sysconfdir}/%{name}/dnsmasq.profile
%config(noreplace) %{_sysconfdir}/%{name}/dosbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/dropbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/empathy.profile
%config(noreplace) %{_sysconfdir}/%{name}/eom.profile
%config(noreplace) %{_sysconfdir}/%{name}/epiphany.profile
%config(noreplace) %{_sysconfdir}/%{name}/evince.profile
%config(noreplace) %{_sysconfdir}/%{name}/fbreader.profile
%config(noreplace) %{_sysconfdir}/%{name}/file.profile
%config(noreplace) %{_sysconfdir}/%{name}/filezilla.profile
%config(noreplace) %{_sysconfdir}/%{name}/firefox-esr.profile
%config(noreplace) %{_sysconfdir}/%{name}/firefox.profile
%config(noreplace) %{_sysconfdir}/%{name}/firejail.config
%config(noreplace) %{_sysconfdir}/%{name}/flashpeak-slimjet.profile
%config(noreplace) %{_sysconfdir}/%{name}/franz.profile
%config(noreplace) %{_sysconfdir}/%{name}/gajim.profile
%config(noreplace) %{_sysconfdir}/%{name}/gitter.profile
%config(noreplace) %{_sysconfdir}/%{name}/gnome-chess.profile
%config(noreplace) %{_sysconfdir}/%{name}/gnome-mplayer.profile
%config(noreplace) %{_sysconfdir}/%{name}/google-chrome-beta.profile
%config(noreplace) %{_sysconfdir}/%{name}/google-chrome.profile
%config(noreplace) %{_sysconfdir}/%{name}/google-chrome-stable.profile
%config(noreplace) %{_sysconfdir}/%{name}/google-chrome-unstable.profile
%config(noreplace) %{_sysconfdir}/%{name}/google-play-music-desktop-player.profile
%config(noreplace) %{_sysconfdir}/%{name}/gpredict.profile
%config(noreplace) %{_sysconfdir}/%{name}/gtar.profile
%config(noreplace) %{_sysconfdir}/%{name}/gthumb.profile
%config(noreplace) %{_sysconfdir}/%{name}/gwenview.profile
%config(noreplace) %{_sysconfdir}/%{name}/gzip.profile
%config(noreplace) %{_sysconfdir}/%{name}/hedgewars.profile
%config(noreplace) %{_sysconfdir}/%{name}/hexchat.profile
%config(noreplace) %{_sysconfdir}/%{name}/icecat.profile
%config(noreplace) %{_sysconfdir}/%{name}/icedove.profile
%config(noreplace) %{_sysconfdir}/%{name}/iceweasel.profile
%config(noreplace) %{_sysconfdir}/%{name}/inox.profile
%config(noreplace) %{_sysconfdir}/%{name}/jitsi.profile
%config(noreplace) %{_sysconfdir}/%{name}/kmail.profile
%config(noreplace) %{_sysconfdir}/%{name}/konversation.profile
%config(noreplace) %{_sysconfdir}/%{name}/less.profile
%config(noreplace) %{_sysconfdir}/%{name}/libreoffice.profile
%config(noreplace) %{_sysconfdir}/%{name}/localc.profile
%config(noreplace) %{_sysconfdir}/%{name}/lodraw.profile
%config(noreplace) %{_sysconfdir}/%{name}/loffice.profile
%config(noreplace) %{_sysconfdir}/%{name}/lofromtemplate.profile
%config(noreplace) %{_sysconfdir}/%{name}/login.users
%config(noreplace) %{_sysconfdir}/%{name}/loimpress.profile
%config(noreplace) %{_sysconfdir}/%{name}/lomath.profile
%config(noreplace) %{_sysconfdir}/%{name}/loweb.profile
%config(noreplace) %{_sysconfdir}/%{name}/lowriter.profile
%config(noreplace) %{_sysconfdir}/%{name}/lxterminal.profile
%config(noreplace) %{_sysconfdir}/%{name}/mathematica.profile
%config(noreplace) %{_sysconfdir}/%{name}/Mathematica.profile
%config(noreplace) %{_sysconfdir}/%{name}/mcabber.profile
%config(noreplace) %{_sysconfdir}/%{name}/midori.profile
%config(noreplace) %{_sysconfdir}/%{name}/mpv.profile
%config(noreplace) %{_sysconfdir}/%{name}/mupen64plus.profile
%config(noreplace) %{_sysconfdir}/%{name}/netsurf.profile
%config(noreplace) %{_sysconfdir}/%{name}/nolocal.net
%config(noreplace) %{_sysconfdir}/%{name}/okular.profile
%config(noreplace) %{_sysconfdir}/%{name}/openbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/opera-beta.profile
%config(noreplace) %{_sysconfdir}/%{name}/opera.profile
%config(noreplace) %{_sysconfdir}/%{name}/palemoon.profile
%config(noreplace) %{_sysconfdir}/%{name}/parole.profile
%config(noreplace) %{_sysconfdir}/%{name}/pidgin.profile
%config(noreplace) %{_sysconfdir}/%{name}/pix.profile
%config(noreplace) %{_sysconfdir}/%{name}/polari.profile
%config(noreplace) %{_sysconfdir}/%{name}/psi-plus.profile
%config(noreplace) %{_sysconfdir}/%{name}/qbittorrent.profile
%config(noreplace) %{_sysconfdir}/%{name}/qtox.profile
%config(noreplace) %{_sysconfdir}/%{name}/quassel.profile
%config(noreplace) %{_sysconfdir}/%{name}/quiterss.profile
%config(noreplace) %{_sysconfdir}/%{name}/qutebrowser.profile
%config(noreplace) %{_sysconfdir}/%{name}/rhythmbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/rtorrent.profile
%config(noreplace) %{_sysconfdir}/%{name}/seamonkey-bin.profile
%config(noreplace) %{_sysconfdir}/%{name}/seamonkey.profile
%config(noreplace) %{_sysconfdir}/%{name}/server.profile
%config(noreplace) %{_sysconfdir}/%{name}/skypeforlinux.profile
%config(noreplace) %{_sysconfdir}/%{name}/skype.profile
%config(noreplace) %{_sysconfdir}/%{name}/slack.profile
%config(noreplace) %{_sysconfdir}/%{name}/snap.profile
%config(noreplace) %{_sysconfdir}/%{name}/soffice.profile
%config(noreplace) %{_sysconfdir}/%{name}/spotify.profile
%config(noreplace) %{_sysconfdir}/%{name}/ssh.profile
%config(noreplace) %{_sysconfdir}/%{name}/steam.profile
%config(noreplace) %{_sysconfdir}/%{name}/stellarium.profile
%config(noreplace) %{_sysconfdir}/%{name}/strings.profile
%config(noreplace) %{_sysconfdir}/%{name}/tar.profile
%config(noreplace) %{_sysconfdir}/%{name}/telegram.profile
%config(noreplace) %{_sysconfdir}/%{name}/Telegram.profile
%config(noreplace) %{_sysconfdir}/%{name}/thunderbird.profile
%config(noreplace) %{_sysconfdir}/%{name}/totem.profile
%config(noreplace) %{_sysconfdir}/%{name}/transmission-gtk.profile
%config(noreplace) %{_sysconfdir}/%{name}/transmission-qt.profile
%config(noreplace) %{_sysconfdir}/%{name}/uget-gtk.profile
%config(noreplace) %{_sysconfdir}/%{name}/unbound.profile
%config(noreplace) %{_sysconfdir}/%{name}/unrar.profile
%config(noreplace) %{_sysconfdir}/%{name}/unzip.profile
%config(noreplace) %{_sysconfdir}/%{name}/uudeview.profile
%config(noreplace) %{_sysconfdir}/%{name}/vivaldi-beta.profile
%config(noreplace) %{_sysconfdir}/%{name}/vivaldi.profile
%config(noreplace) %{_sysconfdir}/%{name}/vlc.profile
%config(noreplace) %{_sysconfdir}/%{name}/warzone2100.profile
%config(noreplace) %{_sysconfdir}/%{name}/webserver.net
%config(noreplace) %{_sysconfdir}/%{name}/weechat-curses.profile
%config(noreplace) %{_sysconfdir}/%{name}/weechat.profile
%config(noreplace) %{_sysconfdir}/%{name}/wesnoth.profile
%config(noreplace) %{_sysconfdir}/%{name}/whitelist-common.inc
%config(noreplace) %{_sysconfdir}/%{name}/wine.profile
%config(noreplace) %{_sysconfdir}/%{name}/xchat.profile
%config(noreplace) %{_sysconfdir}/%{name}/xplayer.profile
%config(noreplace) %{_sysconfdir}/%{name}/xreader.profile
%config(noreplace) %{_sysconfdir}/%{name}/xviewer.profile
%config(noreplace) %{_sysconfdir}/%{name}/xzdec.profile
%config(noreplace) %{_sysconfdir}/%{name}/xz.profile
%config(noreplace) %{_sysconfdir}/%{name}/zathura.profile
%config(noreplace) %{_sysconfdir}/%{name}/7z.profile
%config(noreplace) %{_sysconfdir}/%{name}/keepass.profile
%config(noreplace) %{_sysconfdir}/%{name}/keepassx.profile
%config(noreplace) %{_sysconfdir}/%{name}/claws-mail.profile
%config(noreplace) %{_sysconfdir}/%{name}/mutt.profile
%config(noreplace) %{_sysconfdir}/%{name}/git.profile
%config(noreplace) %{_sysconfdir}/%{name}/emacs.profile
%config(noreplace) %{_sysconfdir}/%{name}/vim.profile
%config(noreplace) %{_sysconfdir}/%{name}/xpdf.profile
%config(noreplace) %{_sysconfdir}/%{name}/virtualbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/openshot.profile
%config(noreplace) %{_sysconfdir}/%{name}/flowblade.profile
%config(noreplace) %{_sysconfdir}/%{name}/eog.profile
%config(noreplace) %{_sysconfdir}/%{name}/evolution.profile
%config(noreplace) %{_sysconfdir}/%{name}/feh.profile
%config(noreplace) %{_sysconfdir}/%{name}/inkscape.profile
%config(noreplace) %{_sysconfdir}/%{name}/gimp.profile
%config(noreplace) %{_sysconfdir}/%{name}/luminance-hdr.profile
%config(noreplace) %{_sysconfdir}/%{name}/mupdf.profile
%config(noreplace) %{_sysconfdir}/%{name}/qpdfview.profile
%config(noreplace) %{_sysconfdir}/%{name}/ranger.profile
%config(noreplace) %{_sysconfdir}/%{name}/synfigstudio.profile

/usr/bin/firejail
/usr/bin/firemon
/usr/bin/firecfg

/usr/lib/firejail/libtrace.so
/usr/lib/firejail/libtracelog.so
/usr/lib/firejail/libconnect.so
/usr/lib/firejail/faudit
/usr/lib/firejail/ftee
/usr/lib/firejail/firecfg.config
/usr/lib/firejail/fshaper.sh

/usr/share/doc/packages/firejail/COPYING
/usr/share/doc/packages/firejail/README
/usr/share/doc/packages/firejail/RELNOTES
/usr/share/man/man1/firejail.1.gz
/usr/share/man/man1/firemon.1.gz
/usr/share/man/man1/firecfg.1.gz
/usr/share/man/man5/firejail-profile.5.gz
/usr/share/man/man5/firejail-login.5.gz
/usr/share/bash-completion/completions/firejail
/usr/share/bash-completion/completions/firemon
/usr/share/bash-completion/completions/firecfg
 
%post
chmod u+s /usr/bin/firejail

%changelog
* Fri Oct 21 2016  netblue30 <netblue30@yahoo.com> 0.9.44-1
  - CVE-2016-7545 submitted by Aleksey Manevich
  - modifs: removed man firejail-config
  - modifs: --private-tmp whitelists /tmp/.X11-unix directory
  - modifs: Nvidia drivers added to --private-dev
  - modifs: /srv supported by --whitelist
  - feature: allow user access to /sys/fs (--noblacklist=/sys/fs)
  - feature: support starting/joining sandbox is a single command
    (--join-or-start)
  - feature: X11 detection support for --audit
  - feature: assign a name to the interface connected to the bridge 
    (--veth-name)
  - feature: all user home directories are visible (--allusers)
  - feature: add files to sandbox container (--put)
  - feature: blocking x11 (--x11=block)
  - feature: X11 security extension (--x11=xorg)
  - feature: disable 3D hardware acceleration (--no3d)
  - feature: x11 xpra, x11 xephyr, x11 block, allusers, no3d profile commands
  - feature: move files in sandbox (--put)
  - feature: accept wildcard patterns in user  name field of restricted
    shell login feature
  - new profiles: qpdfview, mupdf, Luminance HDR, Synfig Studio, Gimp, Inkscape
  - new profiles: feh, ranger, zathura, 7z, keepass, keepassx,
  - new profiles: claws-mail, mutt, git, emacs, vim, xpdf, VirtualBox, OpenShot
  - new profiles: Flowblade, Eye of GNOME (eog), Evolution
  - bugfixes

* Thu Sep 8 2016 netblue30 <netblue30@yahoo.com> 0.9.42-1
  - security: --whitelist deleted files, submitted by Vasya Novikov
  - security: disable x32 ABI in seccomp, submitted by Jann Horn
  - security: tighten --chroot, submitted by Jann Horn
  - security: terminal sandbox escape, submitted by Stephan Sokolow
  - security: several TOCTOU fixes submitted by Aleksey Manevich
  - modifs: bringing back --private-home option
  - modifs: deprecated --user option, please use "sudo -u username firejail"
  - modifs: allow symlinks in home directory for --whitelist option
  - modifs: Firejail prompt is enabled by env variable FIREJAIL_PROMPT="yes"
  - modifs: recursive mkdir
  - modifs: include /dev/snd in --private-dev
  - modifs: seccomp filter update
  - modifs: release archives moved to .xz format
  - feature: AppImage support (--appimage)
  - feature: AppArmor support (--apparmor)
  - feature: Ubuntu snap support (/etc/firejail/snap.profile)
  - feature: Sandbox auditing support (--audit)
  - feature: remove environment variable (--rmenv)
  - feature: noexec support (--noexec)
  - feature: clean local overlay storage directory (--overlay-clean)
  - feature: store and reuse overlay (--overlay-named)
  - feature: allow debugging inside the sandbox with gdb and strace
         (--allow-debuggers)
  - feature: mkfile profile command
  - feature: quiet profile command
  - feature: x11 profile command
  - feature: option to fix desktop files (firecfg --fix)
  - compile time: Busybox support (--enable-busybox-workaround)
  - compile time: disable overlayfs (--disable-overlayfs)
  - compile time: disable whitlisting (--disable-whitelist)
  - compile time: disable global config (--disable-globalcfg)
  - run time: enable/disable overlayfs (overlayfs yes/no)
  - run time: enable/disable  quiet as default (quiet-by-default yes/no)
  - run time: user-defined network filter (netfilter-default)
  - run time: enable/disable whitelisting (whitelist yes/no)
  - run time: enable/disable remounting of /proc and /sys
          (remount-proc-sys yes/no)
  - run time: enable/disable chroot desktop features (chroot-desktop yes/no)
  - profiles: Gitter, gThumb, mpv, Franz messenger, LibreOffice
  - profiles: pix, audacity, xz, xzdec, gzip, cpio, less
  - profiles: Atom Beta, Atom, jitsi, eom, uudeview
  - profiles: tar (gtar), unzip, unrar, file, skypeforlinux,
  - profiles: inox, Slack, gnome-chess. Gajim IM client, DOSBox
  - bugfixes

EOF

echo "building rpm"
rpmbuild -ba SPECS/firejail.spec
rpm -qpl RPMS/x86_64/firejail-$VERSION-1.x86_64.rpm
cd ..
rm -f firejail-$VERSION-1.x86_64.rpm
cp rpmbuild/RPMS/x86_64/firejail-$VERSION-1.x86_64.rpm .


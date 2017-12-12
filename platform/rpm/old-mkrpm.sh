#!/bin/bash
VERSION="0.9.52"
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
install -m 755 /usr/lib/firejail/fcopy  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fgit-install.sh  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fgit-uninstall.sh  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/firecfg.config  firejail-$VERSION/usr/lib/firejail/.
# Python 3  is not available on CentOS
#install -m 755 /usr/lib/firejail/fix_private-bin.py  firejail-$VERSION/usr/lib/firejail/.
#install -m 755 /usr/lib/firejail/fjclip.py  firejail-$VERSION/usr/lib/firejail/.
#install -m 755 /usr/lib/firejail/fjdisplay.py  firejail-$VERSION/usr/lib/firejail/.
#install -m 755 /usr/lib/firejail/fjresize.py  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fldd  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fnet  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fseccomp  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fshaper.sh  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/ftee  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fbuilder  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/libtracelog.so  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/libtrace.so  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/libpostexecseccomp.so  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/seccomp  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/seccomp.64  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/seccomp.debug  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/seccomp.32  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/seccomp.block_secondary  firejail-$VERSION/usr/lib/firejail/.
install -m 644 /usr/lib/firejail/seccomp.mdwx  firejail-$VERSION/usr/lib/firejail/.

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
install -m 644 /etc/firejail/* firejail-$VERSION/etc/firejail/.

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
%{_sysconfdir}/%{name}/0ad.profile
%{_sysconfdir}/%{name}/abrowser.profile
%{_sysconfdir}/%{name}/atom-beta.profile
%{_sysconfdir}/%{name}/atom.profile
%{_sysconfdir}/%{name}/atril.profile
%{_sysconfdir}/%{name}/audacious.profile
%{_sysconfdir}/%{name}/audacity.profile
%{_sysconfdir}/%{name}/aweather.profile
%{_sysconfdir}/%{name}/bitlbee.profile
%{_sysconfdir}/%{name}/brave.profile
%{_sysconfdir}/%{name}/cherrytree.profile
%{_sysconfdir}/%{name}/chromium-browser.profile
%{_sysconfdir}/%{name}/chromium.profile
%{_sysconfdir}/%{name}/clementine.profile
%{_sysconfdir}/%{name}/cmus.profile
%{_sysconfdir}/%{name}/conkeror.profile
%{_sysconfdir}/%{name}/corebird.profile
%{_sysconfdir}/%{name}/cpio.profile
%{_sysconfdir}/%{name}/cyberfox.profile
%{_sysconfdir}/%{name}/Cyberfox.profile
%{_sysconfdir}/%{name}/deadbeef.profile
%{_sysconfdir}/%{name}/default.profile
%{_sysconfdir}/%{name}/deluge.profile
%{_sysconfdir}/%{name}/dillo.profile
%{_sysconfdir}/%{name}/disable-common.inc
%{_sysconfdir}/%{name}/disable-devel.inc
%{_sysconfdir}/%{name}/disable-passwdmgr.inc
%{_sysconfdir}/%{name}/disable-programs.inc
%{_sysconfdir}/%{name}/dnscrypt-proxy.profile
%{_sysconfdir}/%{name}/dnsmasq.profile
%{_sysconfdir}/%{name}/dosbox.profile
%{_sysconfdir}/%{name}/dropbox.profile
%{_sysconfdir}/%{name}/empathy.profile
%{_sysconfdir}/%{name}/eom.profile
%{_sysconfdir}/%{name}/epiphany.profile
%{_sysconfdir}/%{name}/evince.profile
%{_sysconfdir}/%{name}/fbreader.profile
%{_sysconfdir}/%{name}/file.profile
%{_sysconfdir}/%{name}/filezilla.profile
%{_sysconfdir}/%{name}/firefox-esr.profile
%{_sysconfdir}/%{name}/firefox.profile
%config(noreplace) %{_sysconfdir}/%{name}/firejail.config
%{_sysconfdir}/%{name}/flashpeak-slimjet.profile
%{_sysconfdir}/%{name}/franz.profile
%{_sysconfdir}/%{name}/gajim.profile
%{_sysconfdir}/%{name}/gitter.profile
%{_sysconfdir}/%{name}/gnome-chess.profile
%{_sysconfdir}/%{name}/gnome-mplayer.profile
%{_sysconfdir}/%{name}/google-chrome-beta.profile
%{_sysconfdir}/%{name}/google-chrome.profile
%{_sysconfdir}/%{name}/google-chrome-stable.profile
%{_sysconfdir}/%{name}/google-chrome-unstable.profile
%{_sysconfdir}/%{name}/google-play-music-desktop-player.profile
%{_sysconfdir}/%{name}/gpredict.profile
%{_sysconfdir}/%{name}/gtar.profile
%{_sysconfdir}/%{name}/gthumb.profile
%{_sysconfdir}/%{name}/gwenview.profile
%{_sysconfdir}/%{name}/gzip.profile
%{_sysconfdir}/%{name}/hedgewars.profile
%{_sysconfdir}/%{name}/hexchat.profile
%{_sysconfdir}/%{name}/icecat.profile
%{_sysconfdir}/%{name}/icedove.profile
%{_sysconfdir}/%{name}/iceweasel.profile
%{_sysconfdir}/%{name}/inox.profile
%{_sysconfdir}/%{name}/jitsi.profile
%{_sysconfdir}/%{name}/kmail.profile
%{_sysconfdir}/%{name}/konversation.profile
%{_sysconfdir}/%{name}/less.profile
%{_sysconfdir}/%{name}/libreoffice.profile
%{_sysconfdir}/%{name}/localc.profile
%{_sysconfdir}/%{name}/lodraw.profile
%{_sysconfdir}/%{name}/loffice.profile
%{_sysconfdir}/%{name}/lofromtemplate.profile
%config(noreplace) %{_sysconfdir}/%{name}/login.users
%{_sysconfdir}/%{name}/loimpress.profile
%{_sysconfdir}/%{name}/lomath.profile
%{_sysconfdir}/%{name}/loweb.profile
%{_sysconfdir}/%{name}/lowriter.profile
%{_sysconfdir}/%{name}/mathematica.profile
%{_sysconfdir}/%{name}/Mathematica.profile
%{_sysconfdir}/%{name}/mcabber.profile
%{_sysconfdir}/%{name}/midori.profile
%{_sysconfdir}/%{name}/mpv.profile
%{_sysconfdir}/%{name}/mupen64plus.profile
%{_sysconfdir}/%{name}/netsurf.profile
%{_sysconfdir}/%{name}/nolocal.net
%{_sysconfdir}/%{name}/okular.profile
%{_sysconfdir}/%{name}/openbox.profile
%{_sysconfdir}/%{name}/opera-beta.profile
%{_sysconfdir}/%{name}/opera.profile
%{_sysconfdir}/%{name}/palemoon.profile
%{_sysconfdir}/%{name}/parole.profile
%{_sysconfdir}/%{name}/pidgin.profile
%{_sysconfdir}/%{name}/pix.profile
%{_sysconfdir}/%{name}/polari.profile
%{_sysconfdir}/%{name}/psi-plus.profile
%{_sysconfdir}/%{name}/qbittorrent.profile
%{_sysconfdir}/%{name}/qtox.profile
%{_sysconfdir}/%{name}/quassel.profile
%{_sysconfdir}/%{name}/quiterss.profile
%{_sysconfdir}/%{name}/qutebrowser.profile
%{_sysconfdir}/%{name}/rhythmbox.profile
%{_sysconfdir}/%{name}/rtorrent.profile
%{_sysconfdir}/%{name}/seamonkey-bin.profile
%{_sysconfdir}/%{name}/seamonkey.profile
%{_sysconfdir}/%{name}/server.profile
%{_sysconfdir}/%{name}/skypeforlinux.profile
%{_sysconfdir}/%{name}/skype.profile
%{_sysconfdir}/%{name}/slack.profile
%{_sysconfdir}/%{name}/snap.profile
%{_sysconfdir}/%{name}/soffice.profile
%{_sysconfdir}/%{name}/spotify.profile
%{_sysconfdir}/%{name}/ssh.profile
%{_sysconfdir}/%{name}/steam.profile
%{_sysconfdir}/%{name}/stellarium.profile
%{_sysconfdir}/%{name}/strings.profile
%{_sysconfdir}/%{name}/tar.profile
%{_sysconfdir}/%{name}/telegram.profile
%{_sysconfdir}/%{name}/Telegram.profile
%{_sysconfdir}/%{name}/thunderbird.profile
%{_sysconfdir}/%{name}/totem.profile
%{_sysconfdir}/%{name}/transmission-gtk.profile
%{_sysconfdir}/%{name}/transmission-qt.profile
%{_sysconfdir}/%{name}/uget-gtk.profile
%{_sysconfdir}/%{name}/unbound.profile
%{_sysconfdir}/%{name}/unrar.profile
%{_sysconfdir}/%{name}/unzip.profile
%{_sysconfdir}/%{name}/uudeview.profile
%{_sysconfdir}/%{name}/vivaldi-beta.profile
%{_sysconfdir}/%{name}/vivaldi.profile
%{_sysconfdir}/%{name}/vlc.profile
%{_sysconfdir}/%{name}/warzone2100.profile
%{_sysconfdir}/%{name}/webserver.net
%{_sysconfdir}/%{name}/weechat-curses.profile
%{_sysconfdir}/%{name}/weechat.profile
%{_sysconfdir}/%{name}/wesnoth.profile
%{_sysconfdir}/%{name}/whitelist-common.inc
%{_sysconfdir}/%{name}/wine.profile
%{_sysconfdir}/%{name}/xchat.profile
%{_sysconfdir}/%{name}/xplayer.profile
%{_sysconfdir}/%{name}/xreader.profile
%{_sysconfdir}/%{name}/xviewer.profile
%{_sysconfdir}/%{name}/xzdec.profile
%{_sysconfdir}/%{name}/xz.profile
%{_sysconfdir}/%{name}/zathura.profile
%{_sysconfdir}/%{name}/7z.profile
%{_sysconfdir}/%{name}/keepass.profile
%{_sysconfdir}/%{name}/keepassx.profile
%{_sysconfdir}/%{name}/claws-mail.profile
%{_sysconfdir}/%{name}/mutt.profile
%{_sysconfdir}/%{name}/git.profile
%{_sysconfdir}/%{name}/emacs.profile
%{_sysconfdir}/%{name}/vim.profile
%{_sysconfdir}/%{name}/xpdf.profile
%{_sysconfdir}/%{name}/virtualbox.profile
%{_sysconfdir}/%{name}/openshot.profile
%{_sysconfdir}/%{name}/flowblade.profile
%{_sysconfdir}/%{name}/eog.profile
%{_sysconfdir}/%{name}/evolution.profile
%{_sysconfdir}/%{name}/feh.profile
%{_sysconfdir}/%{name}/inkscape.profile
%{_sysconfdir}/%{name}/gimp.profile
%{_sysconfdir}/%{name}/luminance-hdr.profile
%{_sysconfdir}/%{name}/mupdf.profile
%{_sysconfdir}/%{name}/qpdfview.profile
%{_sysconfdir}/%{name}/ranger.profile
%{_sysconfdir}/%{name}/synfigstudio.profile
# 0.9.45
%{_sysconfdir}/%{name}/Cryptocat.profile
%{_sysconfdir}/%{name}/FossaMail.profile
%{_sysconfdir}/%{name}/Thunar.profile
%{_sysconfdir}/%{name}/VirtualBox.profile
%{_sysconfdir}/%{name}/Wire.profile
%{_sysconfdir}/%{name}/amarok.profile
%{_sysconfdir}/%{name}/ark.profile
%{_sysconfdir}/%{name}/atool.profile
%{_sysconfdir}/%{name}/bleachbit.profile
%{_sysconfdir}/%{name}/bless.profile
%{_sysconfdir}/%{name}/brasero.profile
%{_sysconfdir}/%{name}/cryptocat.profile
%{_sysconfdir}/%{name}/cvlc.profile
%{_sysconfdir}/%{name}/display.profile
%{_sysconfdir}/%{name}/dolphin.profile
%{_sysconfdir}/%{name}/dragon.profile
%{_sysconfdir}/%{name}/elinks.profile
%{_sysconfdir}/%{name}/enchant.profile
%{_sysconfdir}/%{name}/engrampa.profile
%{_sysconfdir}/%{name}/exiftool.profile
%{_sysconfdir}/%{name}/file-roller.profile
%{_sysconfdir}/%{name}/fossamail.profile
%{_sysconfdir}/%{name}/gedit.profile
%{_sysconfdir}/%{name}/geeqie.profile
%{_sysconfdir}/%{name}/gjs.profile
%{_sysconfdir}/%{name}/gnome-2048.profile
%{_sysconfdir}/%{name}/gnome-books.profile
%{_sysconfdir}/%{name}/gnome-calculator.profile
%{_sysconfdir}/%{name}/gnome-clocks.profile
%{_sysconfdir}/%{name}/gnome-contacts.profile
%{_sysconfdir}/%{name}/gnome-documents.profile
%{_sysconfdir}/%{name}/gnome-maps.profile
%{_sysconfdir}/%{name}/gnome-music.profile
%{_sysconfdir}/%{name}/gnome-photos.profile
%{_sysconfdir}/%{name}/gnome-weather.profile
%{_sysconfdir}/%{name}/goobox.profile
%{_sysconfdir}/%{name}/gpa.profile
%{_sysconfdir}/%{name}/gpg-agent.profile
%{_sysconfdir}/%{name}/gpg.profile
%{_sysconfdir}/%{name}/gpicview.profile
%{_sysconfdir}/%{name}/guayadeque.profile
%{_sysconfdir}/%{name}/highlight.profile
%{_sysconfdir}/%{name}/img2txt.profile
%{_sysconfdir}/%{name}/iridium-browser.profile
%{_sysconfdir}/%{name}/iridium.profile
%{_sysconfdir}/%{name}/jd-gui.profile
%{_sysconfdir}/%{name}/k3b.profile
%{_sysconfdir}/%{name}/kate.profile
%{_sysconfdir}/%{name}/keepass2.profile
%{_sysconfdir}/%{name}/keepassx2.profile
%{_sysconfdir}/%{name}/keepassxc.profile
%{_sysconfdir}/%{name}/kino.profile
%{_sysconfdir}/%{name}/lollypop.profile
%{_sysconfdir}/%{name}/lynx.profile
%{_sysconfdir}/%{name}/mediainfo.profile
%{_sysconfdir}/%{name}/mediathekview.profile
%{_sysconfdir}/%{name}/mousepad.profile
%{_sysconfdir}/%{name}/multimc5.profile
%{_sysconfdir}/%{name}/mumble.profile
%{_sysconfdir}/%{name}/nautilus.profile
%{_sysconfdir}/%{name}/odt2txt.profile
%{_sysconfdir}/%{name}/pdfsam.profile
%{_sysconfdir}/%{name}/pdftotext.profile
%{_sysconfdir}/%{name}/pithos.profile
%{_sysconfdir}/%{name}/pluma.profile
%{_sysconfdir}/%{name}/qemu-launcher.profile
%{_sysconfdir}/%{name}/qemu-system-x86_64.profile
%{_sysconfdir}/%{name}/qupzilla.profile
%{_sysconfdir}/%{name}/scribus.profile
%{_sysconfdir}/%{name}/simple-scan.profile
%{_sysconfdir}/%{name}/skanlite.profile
%{_sysconfdir}/%{name}/ssh-agent.profile
%{_sysconfdir}/%{name}/start-tor-browser.profile
%{_sysconfdir}/%{name}/thunar.profile
%{_sysconfdir}/%{name}/tracker.profile
%{_sysconfdir}/%{name}/transmission-cli.profile
%{_sysconfdir}/%{name}/transmission-show.profile
%{_sysconfdir}/%{name}/uzbl-browser.profile
%{_sysconfdir}/%{name}/vivaldi-stable.profile
%{_sysconfdir}/%{name}/w3m.profile
%{_sysconfdir}/%{name}/wget.profile
%{_sysconfdir}/%{name}/wire.profile
%{_sysconfdir}/%{name}/wireshark.profile
%{_sysconfdir}/%{name}/xed.profile
%{_sysconfdir}/%{name}/xfburn.profile
%{_sysconfdir}/%{name}/xiphos.profile
%{_sysconfdir}/%{name}/xmms.profile
%{_sysconfdir}/%{name}/xonotic-glx.profile
%{_sysconfdir}/%{name}/xonotic-sdl.profile
%{_sysconfdir}/%{name}/xonotic.profile
%{_sysconfdir}/%{name}/xpra.profile
%{_sysconfdir}/%{name}/zoom.profile
%{_sysconfdir}/%{name}/2048-qt.profile
%{_sysconfdir}/%{name}/Xephyr.profile
%{_sysconfdir}/%{name}/Xvfb.profile
%{_sysconfdir}/%{name}/akregator.profile
%{_sysconfdir}/%{name}/arduino.profile
%{_sysconfdir}/%{name}/baloo_file.profile
%{_sysconfdir}/%{name}/bibletime.profile
%{_sysconfdir}/%{name}/blender.profile
%{_sysconfdir}/%{name}/caja.profile
%{_sysconfdir}/%{name}/clipit.profile
%{_sysconfdir}/%{name}/dia.profile
%{_sysconfdir}/%{name}/dino.profile
%{_sysconfdir}/%{name}/fontforge.profile
%{_sysconfdir}/%{name}/galculator.profile
%{_sysconfdir}/%{name}/geany.profile
%{_sysconfdir}/%{name}/gimp-2.8.profile
%{_sysconfdir}/%{name}/globaltime.profile
%{_sysconfdir}/%{name}/gnome-font-viewer.profile
%{_sysconfdir}/%{name}/gucharmap.profile
%{_sysconfdir}/%{name}/hugin.profile
%{_sysconfdir}/%{name}/kcalc.profile
%{_sysconfdir}/%{name}/knotes.profile
%{_sysconfdir}/%{name}/kodi.profile
%{_sysconfdir}/%{name}/ktorrent.profile
%{_sysconfdir}/%{name}/leafpad.profile
%{_sysconfdir}/%{name}/lximage-qt.profile
%{_sysconfdir}/%{name}/lxmusic.profile
%{_sysconfdir}/%{name}/mate-calc.profile
%{_sysconfdir}/%{name}/mate-calculator.profile
%{_sysconfdir}/%{name}/mate-color-select.profile
%{_sysconfdir}/%{name}/mate-dictionary.profile
%{_sysconfdir}/%{name}/meld.profile
%{_sysconfdir}/%{name}/nemo.profile
%{_sysconfdir}/%{name}/nylas.profile
%{_sysconfdir}/%{name}/orage.profile
%{_sysconfdir}/%{name}/pcmanfm.profile
%{_sysconfdir}/%{name}/qlipper.profile
%{_sysconfdir}/%{name}/ristretto.profile
%{_sysconfdir}/%{name}/viewnior.profile
%{_sysconfdir}/%{name}/viking.profile
%{_sysconfdir}/%{name}/xfce4-dict.profile
%{_sysconfdir}/%{name}/xfce4-notes.profile
%{_sysconfdir}/%{name}/youtube-dl.profile
%{_sysconfdir}/%{name}/catfish.profile
%{_sysconfdir}/%{name}/darktable.profile
%{_sysconfdir}/%{name}/digikam.profile
%{_sysconfdir}/%{name}/handbrake.profile
%{_sysconfdir}/%{name}/vym.profile
%{_sysconfdir}/%{name}/waterfox.profile
# 0.9.49
%{_sysconfdir}/%{name}/Gitter.profile
%{_sysconfdir}/%{name}/android-studio.profile
%{_sysconfdir}/%{name}/apktool.profile
%{_sysconfdir}/%{name}/arm.profile
%{_sysconfdir}/%{name}/baobab.profile
%{_sysconfdir}/%{name}/calibre.profile
%{_sysconfdir}/%{name}/curl.profile
%{_sysconfdir}/%{name}/dex2jar.profile
%{_sysconfdir}/%{name}/ebook-viewer.profile
%{_sysconfdir}/%{name}/electron.profile
%{_sysconfdir}/%{name}/etr.profile
%{_sysconfdir}/%{name}/firefox-nightly.profile
%{_sysconfdir}/%{name}/frozen-bubble.profile
%{_sysconfdir}/%{name}/geary.profile
%{_sysconfdir}/%{name}/ghb.profile
%{_sysconfdir}/%{name}/gitg.profile
%{_sysconfdir}/%{name}/gnome-twitch.profile
%{_sysconfdir}/%{name}/handbrake-gtk.profile
%{_sysconfdir}/%{name}/hashcat.profile
%{_sysconfdir}/%{name}/idea.sh.profile
%{_sysconfdir}/%{name}/kwrite.profile
%{_sysconfdir}/%{name}/liferea.profile
%{_sysconfdir}/%{name}/mplayer.profile
%{_sysconfdir}/%{name}/musescore.profile
%{_sysconfdir}/%{name}/neverball.profile
%{_sysconfdir}/%{name}/obs.profile
%{_sysconfdir}/%{name}/open-invaders.profile
%{_sysconfdir}/%{name}/peek.profile
%{_sysconfdir}/%{name}/picard.profile
%{_sysconfdir}/%{name}/pingus.profile
%{_sysconfdir}/%{name}/rambox.profile
%{_sysconfdir}/%{name}/remmina.profile
%{_sysconfdir}/%{name}/riot-web.profile
%{_sysconfdir}/%{name}/sdat2img.profile
%{_sysconfdir}/%{name}/silentarmy.profile
%{_sysconfdir}/%{name}/simutrans.profile
%{_sysconfdir}/%{name}/smplayer.profile
%{_sysconfdir}/%{name}/soundconverter.profile
%{_sysconfdir}/%{name}/sqlitebrowser.profile
%{_sysconfdir}/%{name}/supertux2.profile
%{_sysconfdir}/%{name}/telegram-desktop.profile
%{_sysconfdir}/%{name}/torbrowser-launcher.profile
%{_sysconfdir}/%{name}/truecraft.profile
%{_sysconfdir}/%{name}/tuxguitar.profile
%{_sysconfdir}/%{name}/unknown-horizons.profile
%{_sysconfdir}/%{name}/wireshark-gtk.profile
%{_sysconfdir}/%{name}/wireshark-qt.profile
%{_sysconfdir}/%{name}/itch.profile
%{_sysconfdir}/%{name}/minetest.profile
%{_sysconfdir}/%{name}/yandex-browser.profile
# 0.9.52
%{_sysconfdir}/%{name}/Natron.profile
%{_sysconfdir}/%{name}/Viber.profile
%{_sysconfdir}/%{name}/amule.profile
%{_sysconfdir}/%{name}/arch-audit.profile
%{_sysconfdir}/%{name}/ardour4.profile
%{_sysconfdir}/%{name}/ardour5.profile
%{_sysconfdir}/%{name}/bluefish.profile
%{_sysconfdir}/%{name}/brackets.profile
%{_sysconfdir}/%{name}/calligra.profile
%{_sysconfdir}/%{name}/calligraauthor.profile
%{_sysconfdir}/%{name}/calligraconverter.profile
%{_sysconfdir}/%{name}/calligraflow.profile
%{_sysconfdir}/%{name}/calligraplan.profile
%{_sysconfdir}/%{name}/calligraplanwork.profile
%{_sysconfdir}/%{name}/calligrasheets.profile
%{_sysconfdir}/%{name}/calligrastage.profile
%{_sysconfdir}/%{name}/calligrawords.profile
%{_sysconfdir}/%{name}/cin.profile
%{_sysconfdir}/%{name}/cinelerra.profile
%{_sysconfdir}/%{name}/clamav.profile
%{_sysconfdir}/%{name}/clamdscan.profile
%{_sysconfdir}/%{name}/clamdtop.profile
%{_sysconfdir}/%{name}/clamscan.profile
%{_sysconfdir}/%{name}/cliqz.profile
%{_sysconfdir}/%{name}/conky.profile
%{_sysconfdir}/%{name}/dooble-qt4.profile
%{_sysconfdir}/%{name}/dooble.profile
%{_sysconfdir}/%{name}/fetchmail.profile
%{_sysconfdir}/%{name}/ffmpeg.profile
%{_sysconfdir}/%{name}/freecad.profile
%{_sysconfdir}/%{name}/freecadcmd.profile
%{_sysconfdir}/%{name}/freshclam.profile
%{_sysconfdir}/%{name}/google-earth.profile
%{_sysconfdir}/%{name}/imagej.profile
%{_sysconfdir}/%{name}/karbon.profile
%{_sysconfdir}/%{name}/kdenlive.profile
%{_sysconfdir}/%{name}/krita.profile
%{_sysconfdir}/%{name}/linphone.profile
%{_sysconfdir}/%{name}/lmms.profile
%{_sysconfdir}/%{name}/macrofusion.profile
%{_sysconfdir}/%{name}/mpd.profile
%{_sysconfdir}/%{name}/natron.profile
%{_sysconfdir}/%{name}/openshot-qt.profile
%{_sysconfdir}/%{name}/pinta.profile
%{_sysconfdir}/%{name}/ricochet.profile
%{_sysconfdir}/%{name}/rocketchat.profile
%{_sysconfdir}/%{name}/shotcut.profile
%{_sysconfdir}/%{name}/smtube.profile
%{_sysconfdir}/%{name}/surf.profile
%{_sysconfdir}/%{name}/teamspeak3.profile
%{_sysconfdir}/%{name}/terasology.profile
%{_sysconfdir}/%{name}/tor-browser-en.profile
%{_sysconfdir}/%{name}/tor.profile
%{_sysconfdir}/%{name}/uefitool.profile
%{_sysconfdir}/%{name}/whitelist-var-common.inc
%{_sysconfdir}/%{name}/x-terminal-emulator.profile
%{_sysconfdir}/%{name}/xmr-stak-cpu.profile
%{_sysconfdir}/%{name}/zart.profile
%{_sysconfdir}/%{name}/aosp.profile
%{_sysconfdir}/%{name}/archaudit-report.profile
%{_sysconfdir}/%{name}/bnox.profile
%{_sysconfdir}/%{name}/bsdtar.profile
%{_sysconfdir}/%{name}/cower.profile
%{_sysconfdir}/%{name}/dnox.profile
%{_sysconfdir}/%{name}/enpass.profile
%{_sysconfdir}/%{name}/gnome-ring.profile
%{_sysconfdir}/%{name}/kdeinit4.profile
%{_sysconfdir}/%{name}/kget.profile
%{_sysconfdir}/%{name}/kopete.profile
%{_sysconfdir}/%{name}/krunner.profile
%{_sysconfdir}/%{name}/kwin_x11.profile
%{_sysconfdir}/%{name}/makepkg.profile
%{_sysconfdir}/%{name}/nheko.profile
%{_sysconfdir}/%{name}/pdfmod.profile
%{_sysconfdir}/%{name}/ping.profile
%{_sysconfdir}/%{name}/runenpass.sh.profile
%{_sysconfdir}/%{name}/signal-desktop.profile
%{_sysconfdir}/%{name}/tcpserver.net
%{_sysconfdir}/%{name}/xcalc.profile
%{_sysconfdir}/%{name}/zaproxy.profile
 
/usr/bin/firejail
/usr/bin/firemon
/usr/bin/firecfg

/usr/lib/firejail/libtrace.so
/usr/lib/firejail/libtracelog.so
/usr/lib/firejail/libpostexecseccomp.so
/usr/lib/firejail/faudit
/usr/lib/firejail/ftee
/usr/lib/firejail/fbuilder
/usr/lib/firejail/firecfg.config
/usr/lib/firejail/fshaper.sh
/usr/lib/firejail/fcopy
/usr/lib/firejail/fgit-install.sh
/usr/lib/firejail/fgit-uninstall.sh
#/usr/lib/firejail/fix_private-bin.py
#/usr/lib/firejail/fjclip.py
#/usr/lib/firejail/fjdisplay.py
#/usr/lib/firejail/fjresize.py
/usr/lib/firejail/fnet
/usr/lib/firejail/fldd
/usr/lib/firejail/fseccomp
/usr/lib/firejail/seccomp
/usr/lib/firejail/seccomp.64
/usr/lib/firejail/seccomp.debug
/usr/lib/firejail/seccomp.32
/usr/lib/firejail/seccomp.block_secondary
/usr/lib/firejail/seccomp.mdwx

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
* Tue Dec 12 2017  netblue30 <netblue30@yahoo.com> 0.9.52-1

* Fri Sep 8 2017  netblue30 <netblue30@yahoo.com> 0.9.50-1

* Mon Jun 12 2017  netblue30 <netblue30@yahoo.com> 0.9.48-1

* Mon May 15 2017  netblue30 <netblue30@yahoo.com> 0.9.46-1

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
  - compile time: disable whitelisting (--disable-whitelist)
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

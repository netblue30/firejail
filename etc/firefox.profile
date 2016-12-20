# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ~/.mozilla
noblacklist ~/.cache/mozilla
noblacklist ~/.config/qpdfview
noblacklist ~/.local/share/qpdfview
noblacklist ~/.kde/share/apps/okular
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.mozilla
whitelist ~/.mozilla
mkdir ~/.cache/mozilla/firefox
whitelist ~/.cache/mozilla/firefox
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.keysnail.js
whitelist ~/.config/gnome-mplayer
whitelist ~/.cache/gnome-mplayer/plugin
whitelist ~/.pki
whitelist ~/.config/qpdfview
whitelist ~/.local/share/qpdfview
whitelist ~/.kde/share/apps/okular

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass

#silverlight
whitelist ~/.wine-pipelight
whitelist ~/.wine-pipelight64
whitelist ~/.config/pipelight-widevine
whitelist ~/.config/pipelight-silverlight5.1

include /etc/firejail/whitelist-common.inc

# experimental features
#private-bin firefox,which,sh,dbus-launch,dbus-send,env
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,firefox,mime.types,mailcap,asound.conf,pulse
private-dev
private-tmp

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/firefox.local

# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ~/.mozilla
noblacklist ~/.config/qpdfview
noblacklist ~/.local/share/qpdfview
noblacklist ~/.kde/share/apps/okular
noblacklist ~/.pki
noblacklist ~/.lastpass
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
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.keysnail.js
whitelist ~/.config/gnome-mplayer
mkdir ~/.pki
whitelist ~/.pki
whitelist ~/.lastpass
whitelist ~/.config/qpdfview
whitelist ~/.local/share/qpdfview
whitelist ~/.kde/share/apps/okular

# silverlight
whitelist ~/.wine-pipelight
whitelist ~/.wine-pipelight64
whitelist ~/.config/pipelight-widevine
whitelist ~/.config/pipelight-silverlight5.1

include /etc/firejail/whitelist-common.inc

# experimental features
#private-bin firefox,which,sh,dbus-launch,dbus-send,env
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,firefox,mime.types,mailcap,asound.conf,pulse
private-dev 
#private-tmp

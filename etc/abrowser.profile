# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/abrowser.local

# Firejail profile for Abrowser
noblacklist ~/.mozilla
noblacklist ~/.cache/mozilla
noblacklist ~/.pki
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
mkdir ~/.cache/mozilla/abrowser
whitelist ~/.cache/mozilla/abrowser
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
whitelist ~/.lastpass

# silverlight
whitelist ~/.wine-pipelight
whitelist ~/.wine-pipelight64
whitelist ~/.config/pipelight-widevine
whitelist ~/.config/pipelight-silverlight5.1

include /etc/firejail/whitelist-common.inc

# experimental features
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse

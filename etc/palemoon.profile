# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/palemoon.local

# Firejail profile for Pale Moon
noblacklist ~/.moonchild productions/pale moon
noblacklist ~/.cache/moonchild productions/pale moon
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/whitelist-common.inc

whitelist ${DOWNLOADS}
mkdir ~/.moonchild productions
whitelist ~/.moonchild productions
mkdir ~/.cache/moonchild productions/pale moon
whitelist ~/.cache/moonchild productions/pale moon

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin palemoon
private-opt palemoon
private-tmp

# These are uncommented in the Firefox profile. If you run into trouble you may
# want to uncomment (some of) them.
#whitelist ~/dwhelper
#whitelist ~/.zotero
#whitelist ~/.vimperatorrc
#whitelist ~/.vimperator
#whitelist ~/.pentadactylrc
#whitelist ~/.pentadactyl
#whitelist ~/.keysnail.js
#whitelist ~/.config/gnome-mplayer
#whitelist ~/.cache/gnome-mplayer/plugin
#whitelist ~/.pki
#whitelist ~/.lastpass

# For silverlight
#whitelist ~/.wine-pipelight
#whitelist ~/.wine-pipelight64
#whitelist ~/.config/pipelight-widevine
#whitelist ~/.config/pipelight-silverlight5.1

# experimental features
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
#private-dev (disabled for now as it will interfere with webcam use in palemoon)

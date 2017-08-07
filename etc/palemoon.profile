# Firejail profile for palemoon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/palemoon.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/moonchild productions/pale moon
noblacklist ~/.moonchild productions/pale moon

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/moonchild productions/pale moon
mkdir ~/.moonchild productions
whitelist ${DOWNLOADS}
whitelist ~/.cache/moonchild productions/pale moon
whitelist ~/.moonchild productions
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

# private-bin palemoon
# private-dev (disabled for now as it will interfere with webcam use in palemoon)
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
# private-opt palemoon
private-tmp

# CLOBBERED COMMENTS
# For silverlight
# want to uncomment (some of) them.
# whitelist ~/.cache/gnome-mplayer/plugin
# whitelist ~/.config/gnome-mplayer
# whitelist ~/.config/pipelight-silverlight5.1
# whitelist ~/.config/pipelight-widevine
# whitelist ~/.keysnail.js
# whitelist ~/.lastpass
# whitelist ~/.pentadactyl
# whitelist ~/.pentadactylrc
# whitelist ~/.pki
# whitelist ~/.vimperator
# whitelist ~/.vimperatorrc
# whitelist ~/.wine-pipelight
# whitelist ~/.wine-pipelight64
# whitelist ~/.zotero
# whitelist ~/dwhelper

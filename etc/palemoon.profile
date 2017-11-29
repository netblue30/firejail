# Firejail profile for palemoon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/palemoon.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/moonchild productions/pale moon
noblacklist ${HOME}/.moonchild productions/pale moon

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

# These are uncommented in the Firefox profile. If you run into trouble you may
# want to uncomment (some of) them.
#whitelist ${HOME}/dwhelper
#whitelist ${HOME}/.zotero
#whitelist ${HOME}/.vimperatorrc
#whitelist ${HOME}/.vimperator
#whitelist ${HOME}/.pentadactylrc
#whitelist ${HOME}/.pentadactyl
#whitelist ${HOME}/.keysnail.js
#whitelist ${HOME}/.config/gnome-mplayer
#whitelist ${HOME}/.cache/gnome-mplayer/plugin
#whitelist ${HOME}/.pki
#whitelist ${HOME}/.lastpass

# For silverlight
#whitelist ${HOME}/.wine-pipelight
#whitelist ${HOME}/.wine-pipelight64
#whitelist ${HOME}/.config/pipelight-widevine
#whitelist ${HOME}/.config/pipelight-silverlight5.1

mkdir ${HOME}/.cache/moonchild productions/pale moon
mkdir ${HOME}/.moonchild productions
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/moonchild productions/pale moon
whitelist ${HOME}/.moonchild productions
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

# private-bin palemoon
# private-dev (disabled for now as it will interfere with webcam use in palemoon)
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
# private-opt palemoon
private-tmp

disable-mnt

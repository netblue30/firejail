# Firejail profile for basilisk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/basilisk.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/moonchild productions/basilisk
noblacklist ${HOME}/.moonchild productions/basilisk

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
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

mkdir ${HOME}/.cache/moonchild productions/basilisk
mkdir ${HOME}/.moonchild productions
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/moonchild productions/basilisk
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

# private-bin basilisk
# private-dev (disabled for now as it will interfere with webcam use in basilisk)
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
# private-opt basilisk
private-tmp

disable-mnt

# Firejail profile for seamonkey
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/seamonkey.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/mozilla
mkdir ${HOME}/.mozilla
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/gnome-mplayer/plugin
whitelist ${HOME}/.cache/mozilla
whitelist ${HOME}/.config/gnome-mplayer
whitelist ${HOME}/.config/pipelight-silverlight5.1
whitelist ${HOME}/.config/pipelight-widevine
whitelist ${HOME}/.keysnail.js
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.pentadactyl
whitelist ${HOME}/.pentadactylrc
whitelist ${HOME}/.pki
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.wine-pipelight
whitelist ${HOME}/.wine-pipelight64
whitelist ${HOME}/.zotero
whitelist ${HOME}/dwhelper
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse

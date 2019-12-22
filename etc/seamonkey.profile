# Firejail profile for seamonkey
# Description: SeaMonkey internet suite
# This file is overwritten after every install/update
# Persistent local customizations
include seamonkey.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/mozilla
mkdir ${HOME}/.mozilla
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
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
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.wine-pipelight
whitelist ${HOME}/.wine-pipelight64
whitelist ${HOME}/.zotero
whitelist ${HOME}/dwhelper
include whitelist-common.inc

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
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg

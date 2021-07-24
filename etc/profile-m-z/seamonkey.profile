# Firejail profile for seamonkey
# Description: SeaMonkey internet suite
# This file is overwritten after every install/update
# Persistent local customizations
include seamonkey.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/mozilla
nodeny  ${HOME}/.mozilla
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/mozilla
mkdir ${HOME}/.mozilla
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/gnome-mplayer/plugin
allow  ${HOME}/.cache/mozilla
allow  ${HOME}/.config/gnome-mplayer
allow  ${HOME}/.config/pipelight-silverlight5.1
allow  ${HOME}/.config/pipelight-widevine
allow  ${HOME}/.keysnail.js
allow  ${HOME}/.lastpass
allow  ${HOME}/.mozilla
allow  ${HOME}/.pentadactyl
allow  ${HOME}/.pentadactylrc
allow  ${HOME}/.pki
allow  ${HOME}/.local/share/pki
allow  ${HOME}/.vimperator
allow  ${HOME}/.vimperatorrc
allow  ${HOME}/.wine-pipelight
allow  ${HOME}/.wine-pipelight64
allow  ${HOME}/.zotero
allow  ${HOME}/dwhelper
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
# private-etc adobe,alternatives,asound.conf,ca-certificates,crypto-policies,firefox,fonts,group,gtk-2.0,hostname,hosts,iceweasel,localtime,machine-id,mailcap,mime.types,nsswitch.conf,pango,passwd,pki,pulse,resolv.conf,ssl

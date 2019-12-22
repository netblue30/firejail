# Firejail profile for polari
# Description: Internet Relay Chat (IRC) client
# This file is overwritten after every install/update
# Persistent local customizations
include polari.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/telepathy
mkdir ${HOME}/.config/telepathy-account-widgets
mkdir ${HOME}/.local/share/Empathy
mkdir ${HOME}/.local/share/TpLogger
mkdir ${HOME}/.local/share/telepathy
mkdir ${HOME}/.purple
whitelist ${HOME}/.cache/telepathy
whitelist ${HOME}/.config/telepathy-account-widgets
whitelist ${HOME}/.local/share/Empathy
whitelist ${HOME}/.local/share/TpLogger
whitelist ${HOME}/.local/share/telepathy
whitelist ${HOME}/.purple
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-dev
#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp


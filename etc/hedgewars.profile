# Firejail profile for hedgewars
# Description: Funny turn-based artillery game, featuring fighting hedgehogs
# This file is overwritten after every install/update
# Persistent local customizations
include hedgewars.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.hedgewars

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.hedgewars
whitelist ${HOME}/.hedgewars
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
seccomp
tracelog

disable-mnt
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

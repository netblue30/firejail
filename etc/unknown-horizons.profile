# Firejail profile for unknown-horizons
# Description: 2D realtime strategy simulation
# This file is overwritten after every install/update
# Persistent local customizations
include unknown-horizons.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.unknown-horizons

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.unknown-horizons
whitelist ${HOME}/.unknown-horizons
include whitelist-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

# private-bin unknown-horizons
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

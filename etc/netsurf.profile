# Firejail profile for netsurf
# Description: Lightweight and fast web browser
# This file is overwritten after every install/update
# Persistent local customizations
include netsurf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/netsurf
noblacklist ${HOME}/.config/netsurf

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/netsurf
mkdir ${HOME}/.config/netsurf
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/netsurf
whitelist ${HOME}/.config/netsurf
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

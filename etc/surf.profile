# Firejail profile for surf
# Description: Simple web browser by suckless community
# This file is overwritten after every install/update
# Persistent local customizations
include surf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.surf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.surf
whitelist ${HOME}/.surf
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,curl,dmenu,ls,printf,sed,sh,sleep,st,stterm,surf,xargs,xprop
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp


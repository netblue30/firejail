# Firejail profile for Musixmatch
# This file is overwritten after every install/update
# Persistent local customizations
include musixmatch.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nogroups
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg


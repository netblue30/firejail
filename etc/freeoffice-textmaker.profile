# Firejail profile for freeoffice-textmaker
# This file is overwritten after every install/update
# Persistent local customizations
include freeoffice-textmaker.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/SoftMaker

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

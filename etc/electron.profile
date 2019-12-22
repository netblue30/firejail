# Firejail profile for electron
# Description: Build cross platform desktop apps with web technologies
# This file is overwritten after every install/update
# Persistent local customizations
include electron.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}

apparmor
caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg

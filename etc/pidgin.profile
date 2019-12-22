# Firejail profile for pidgin
# Description: Graphical multi-protocol instant messaging client
# This file is overwritten after every install/update
# Persistent local customizations
include pidgin.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
ignore noexec ${RUNUSER}
ignore noexec /dev/shm

noblacklist ${HOME}/.purple

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.purple
whitelist ${HOME}/.purple
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
# shell none
tracelog

# private-bin pidgin
private-cache
private-dev
private-tmp

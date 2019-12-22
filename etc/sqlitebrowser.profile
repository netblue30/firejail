# Firejail profile for sqlitebrowser
# Description: GUI editor for SQLite databases
# This file is overwritten after every install/update
# Persistent local customizations
include sqlitebrowser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/sqlitebrowser
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
# nodbus - breaks proxy creation
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin sqlitebrowser
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

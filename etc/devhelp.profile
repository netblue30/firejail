# Firejail profile for devhelp
# Description: API documentation browser for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include devhelp.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/devhelp
include whitelist-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
# net none - makes settings immutable
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin devhelp
private-cache
private-dev
private-etc X11,alternatives,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

read-only ${HOME}

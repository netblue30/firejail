# Firejail profile for file-roller
# Description: Archive manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include file-roller.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/file-roller
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#ipc-namespace - causing issues launching on archlinux
machine-id
# net none - breaks on older Ubuntu versions
no3d
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

# private-bin file-roller
private-dev
#private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
# private-tmp

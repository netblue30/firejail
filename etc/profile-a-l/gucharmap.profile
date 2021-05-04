# Firejail profile for gucharmap
# Description: Unicode character picker and font browser
# This file is overwritten after every install/update
# Persistent local customizations
include gucharmap.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
#net none - breaks dbus
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin gnome-character-map,gucharmap
private-cache
private-dev
private-etc alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,X11,xdg
private-lib
private-tmp

# breaks state saving
# dbus-user none
# dbus-system none

read-only ${HOME}

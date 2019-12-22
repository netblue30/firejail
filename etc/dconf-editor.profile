# Firejail profile for dconf-editor
# Description: dconf configuration editor
# This file is overwritten after every install/update
# Persistent local customizations
include dconf-editor.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.local/share/glib-2.0
include whitelist-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
# net none - breaks application on older versions
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

disable-mnt
private-bin dconf-editor
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,tor,xdg
private-lib
private-tmp

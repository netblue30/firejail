# Firejail profile for easystroke
# Description: Control your desktop using mouse gestures
# This file is overwritten after every install/update
# Persistent local customizations
include easystroke.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.easystroke

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
# nodbus
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

disable-mnt
# breaks custom shell command functionality
#private-bin bash,easystroke,sh
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
# breaks custom shell command functionality
#private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp

memory-deny-write-execute

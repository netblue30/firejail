# Firejail profile for gnome-pie
# Description: Alternative AppMenu
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-pie.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-pie

#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
include disable-passwdmgr.inc
#include disable-programs.inc

caps.drop all
ipc-namespace
# net none - breaks dbus
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

disable-mnt
private-cache
private-dev
private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp

memory-deny-write-execute

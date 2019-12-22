# Firejail profile for gnome-chess
# Description: Simple chess game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-chess.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-chess

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
private-bin fairymax,gnome-chess,gnuchess,hoichess
private-cache
private-dev
private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gnome-chess,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

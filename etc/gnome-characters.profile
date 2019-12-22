# Firejail profile for gnome-characters
# Description: Character map application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-characters.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/org.gnome.Characters
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
# Uncomment the next line (or add it to your gnome-characters.local)
# if you don't need recently used chars
#nodbus
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
# Uncomment the next line (or add it to your gnome-characters.local)
# if you don't need recently used chars
#private
private-bin gjs,gnome-characters
private-cache
private-dev
private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

read-only ${HOME}

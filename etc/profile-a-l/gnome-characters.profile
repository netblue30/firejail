# Firejail profile for gnome-characters
# Description: Character map application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-characters.local
# Persistent global definitions
include globals.local

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/org.gnome.Characters
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
# Add the next line to your gnome-characters.local if you don't need access to recently used chars.
#private
private-bin gjs,gnome-characters
private-cache
private-dev
private-etc alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,pango,X11,xdg
private-tmp

# Add the next lines to your gnome-characters.local if you don't need access to recently used chars.
# dbus-user none
# dbus-system none

read-only ${HOME}

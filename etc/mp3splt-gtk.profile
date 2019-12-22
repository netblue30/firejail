# Firejail profile for mp3splt-gtk
# Description: Gtk utility for mp3/ogg splitting without decoding
# This file is overwritten after every install/update
# Persistent local customizations
include mp3splt-gtk.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mp3splt-gtk

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin mp3splt-gtk
private-cache
private-dev
private-etc X11,alsa,alternatives,asound.conf,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

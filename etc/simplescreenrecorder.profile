# Firejail profile for simplescreenrecorder
# Description: A feature-rich screen recorder that supports X11 and OpenGL
# This file is overwritten after every install/update
# Persistent local customizations
include simplescreenrecorder.local
# Persistent global definitions
include globals.local

noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/simplescreenrecorder
include whitelist-usr-share-common.inc

apparmor
caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none
tracelog

private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

memory-deny-write-execute

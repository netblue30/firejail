# Firejail profile for gthumb
# Description: Image viewer and browser
# This file is overwritten after every install/update
# Persistent local customizations
include gthumb.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gthumb
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
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

private-bin gthumb
private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

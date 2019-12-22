# Firejail profile for masterpdfeditor
# Description: A complete solution for creating and editing PDF files
# This file is overwritten after every install/update
# Persistent local customizations
include masterpdfeditor.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Code Industry
noblacklist ${HOME}/.masterpdfeditor

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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

private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp


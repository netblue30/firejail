# Firejail profile for pinta
# Description: Simple drawing/painting program
# This file is overwritten after every install/update
# Persistent local customizations
include pinta.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Pinta
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
net none
nodbus
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

private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-cache
private-tmp


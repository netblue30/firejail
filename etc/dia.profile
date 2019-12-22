# Firejail profile for dia
# Description: Diagram editor
# This file is overwritten after every install/update
# Persistent local customizations
include dia.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dia
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include allow-python2.inc
include allow-python3.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
net none
no3d
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

disable-mnt
#private-bin dia
private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp


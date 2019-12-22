# Firejail profile for viewnior
# Description: Simple, fast and elegant image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include viewnior.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/viewnior
noblacklist ${HOME}/.steam

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

apparmor
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
tracelog

private-bin viewnior
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

#memory-deny-write-execute - breaks on Arch (see issues #1803 and #1808)

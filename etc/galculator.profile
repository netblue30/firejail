# Firejail profile for galculator
# Description: Scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include galculator.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/galculator

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/galculator
whitelist ${HOME}/.config/galculator
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#hostname galculator - breaks Arch Linux
#ipc-namespace
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
tracelog

private-bin galculator
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,tor,xdg
private-lib
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

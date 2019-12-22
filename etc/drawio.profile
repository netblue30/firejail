# Firejail profile for drawio
# Description: Diagram drawing application built on web technology - desktop version
# This file is overwritten after every install/update
# Persistent local customizations
include drawio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/draw.io

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/draw.io
whitelist ${HOME}/.config/draw.io
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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
seccomp !chroot
shell none
# tracelog - breaks on Arch

private-bin drawio
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

# memory-deny-write-execute - breaks on Arch

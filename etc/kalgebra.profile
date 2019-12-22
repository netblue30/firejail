# Firejail profile for kalgebra
# Description: 2D and 3D Graph Calculator
# This file is overwritten after every install/update
# Persistent local customizations
include kalgebra.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kalgebrarc
noblacklist ${HOME}/.local/share/kalgebra

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/kalgebramobile
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
protocol unix,netlink
seccomp !chroot
shell none
# tracelog

disable-mnt
private-bin kalgebra,kalgebramobile
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

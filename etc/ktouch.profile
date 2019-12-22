# Firejail profile for KTouch
# Description: a typing tutor by KDE
# This file is overwritten after every install/update
# Persistent local customizations
include ktouch.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ktouch2rc
noblacklist ${HOME}/.local/share/ktouch

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.config/ktouch2rc
mkdir ${HOME}/.local/share/ktouch
whitelist ${HOME}/.config/ktouch2rc
whitelist ${HOME}/.local/share/ktouch
include whitelist-common.inc
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
seccomp
shell none
tracelog

disable-mnt
private-bin ktouch
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

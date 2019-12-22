# Firejail profile for pcmanfm
# Description: Extremely fast and lightweight file manager
# This file is overwritten after every install/update
# Persistent local customizations
include pcmanfm.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.config/libfm - disable-programs.inc is disabled, see below
# noblacklist ${HOME}/.config/pcmanfm

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

allusers
caps.drop all
# net none - see issue #1467, computer:/// location broken
no3d
# nodbus
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

#private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,group,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg

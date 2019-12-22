# Firejail profile for xfburn
# Description: CD-burner application for Xfce Desktop Environment
# This file is overwritten after every install/update
# Persistent local customizations
include xfburn.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfburn

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin xfburn
# private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
# private-tmp

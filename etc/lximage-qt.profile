# Firejail profile for lximage-qt
# Description: Image viewer for LXQt
# This file is overwritten after every install/update
# Persistent local customizations
include lximage-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/lximage-qt

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
no3d
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

private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,dbus-1,fonts,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp


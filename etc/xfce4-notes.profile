# Firejail profile for xfce4-notes
# Description: Notes application for the Xfce4 desktop
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-notes.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfce4/xfce4-notes.gtkrc
noblacklist ${HOME}/.config/xfce4/xfce4-notes.rc
noblacklist ${HOME}/.local/share/notes

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

disable-mnt
private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp


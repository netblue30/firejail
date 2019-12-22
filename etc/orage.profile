# Firejail profile for orage
# Description: Calendar for Xfce Desktop Environment
# This file is overwritten after every install/update
# Persistent local customizations
include orage.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/orage
noblacklist ${HOME}/.local/share/orage

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
# nosound - calendar application, It must be able to play sound to wake you up.
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,timezone,xdg
private-tmp


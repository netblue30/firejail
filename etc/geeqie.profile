# Firejail profile for geeqie
# Description: Image viewer using GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include geeqie.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/geeqie
noblacklist ${HOME}/.config/geeqie
noblacklist ${HOME}/.local/share/geeqie

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
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

# private-bin geeqie
private-dev
#private-etc X11,alternatives,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg

# Firejail profile for kino
# Description: Non-linear editor for Digital Video data
# This file is overwritten after every install/update
# Persistent local customizations
include kino.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kino-history
noblacklist ${HOME}/.kinorc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp


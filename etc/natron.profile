# Firejail profile for natron
# This file is overwritten after every install/update
# Persistent local customizations
include natron.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Natron
noblacklist ${HOME}/.cache/INRIA/Natron
noblacklist ${HOME}/.config/INRIA

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none

private-bin natron,Natron,NatronRenderer
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg

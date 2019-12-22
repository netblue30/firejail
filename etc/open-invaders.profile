# Firejail profile for open-invaders
# Description: Space Invaders clone
# This file is overwritten after every install/update
# Persistent local customizations
include open-invaders.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openinvaders

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.openinvaders
whitelist ${HOME}/.openinvaders
include whitelist-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none

# private-bin open-invaders
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

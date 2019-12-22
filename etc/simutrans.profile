# Firejail profile for simutrans
# Description: Transportation simulator
# This file is overwritten after every install/update
# Persistent local customizations
include simutrans.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.simutrans

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.simutrans
whitelist ${HOME}/.simutrans
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
protocol unix
seccomp
shell none

# private-bin simutrans
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

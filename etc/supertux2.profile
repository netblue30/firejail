# Firejail profile for supertux2
# Description: Jump'n run like game
# This file is overwritten after every install/update
# Persistent local customizations
include supertux2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/supertux2

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/supertux2
whitelist ${HOME}/.local/share/supertux2
include whitelist-common.inc
include whitelist-var-common.inc

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

disable-mnt
# private-bin supertux2
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

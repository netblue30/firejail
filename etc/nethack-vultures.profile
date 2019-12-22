# Firejail profile for nethack-vultures
# Description: A rogue-like single player dungeon exploration game
# This file is overwritten after every install/update
# Persistent local customizations
include nethack.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vultures

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.vultures
whitelist ${HOME}/.vultures
whitelist /var/log/vultures
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
nogroups
#nonewprivs
#noroot
notv
novideo
#protocol unix,netlink
#seccomp
shell none

disable-mnt
#private
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp
writable-var

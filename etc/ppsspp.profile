# Firejail profile for ppsspp
# Description: A PSP emulator written in C++
# This file is overwritten after every install/update
# Persistent local customizations
include ppsspp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ppsspp
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,netlink
seccomp
shell none

# private-dev is disabled to allow controller support
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
#private-dev
private-opt ppsspp
private-tmp


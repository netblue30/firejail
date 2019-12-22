# Firejail profile for mupen64plus
# Description: Nintendo64 Emulator
# This file is overwritten after every install/update
# Persistent local customizations
include mupen64plus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mupen64plus
noblacklist ${HOME}/.local/share/mupen64plus

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-passwdmgr.inc
include disable-programs.inc

# you'll need to manually whitelist ROM files
mkdir ${HOME}/.config/mupen64plus
mkdir ${HOME}/.local/share/mupen64plus
whitelist ${HOME}/.config/mupen64plus
whitelist ${HOME}/.local/share/mupen64plus
include whitelist-common.inc

caps.drop all
net none
nodbus
nodvd
nonewprivs
noroot
notv
novideo
seccomp

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg

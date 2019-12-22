# Firejail profile for frozen-bubble
# Description: Cool game where you pop out the bubbles
# This file is overwritten after every install/update
# Persistent local customizations
include frozen-bubble.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.frozen-bubble

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.frozen-bubble
whitelist ${HOME}/.frozen-bubble
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
# private-bin frozen-bubble
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

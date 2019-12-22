# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include sol.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# all necessary files in $HOME are in whitelist-common.inc
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
# no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin sol
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

# memory-deny-write-execute

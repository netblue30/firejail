# Firejail profile for cin
# This file is overwritten after every install/update
# Persistent local customizations
include cin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bcast5

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
#nogroups
nonewprivs
notv
nou2f
noroot
protocol unix

# if an 1-1.2% gap per thread hurts you, comment seccomp
seccomp
shell none

#private-bin cin,ffmpeg
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg


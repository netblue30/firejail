# Firejail profile for peek
# This file is overwritten after every install/update
# Persistent local customizations
include peek.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/peek
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

# private-bin breaks gif mode, mp4 and webm mode work fine however
# private-bin convert,ffmpeg,peek
private-dev
#private-etc Trolltech.conf,X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

memory-deny-write-execute

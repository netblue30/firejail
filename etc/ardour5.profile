# Firejail profile for ardour5
# This file is overwritten after every install/update
# Persistent local customizations
include ardour5.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ardour4
noblacklist ${HOME}/.config/ardour5
noblacklist ${HOME}/.lv2
noblacklist ${HOME}/.vst
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none

#private-bin ardour4,ardour5,ardour5-copy-mixer,ardour5-export,ardour5-fix_bbtppq,grep,ldd,nm,sed,sh
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,ardour4,ardour5,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp


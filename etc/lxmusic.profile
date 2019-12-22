# Firejail profile for lxmusic
# Description: LXDE music player
# This file is overwritten after every install/update
# Persistent local customizations
include lxmusic.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/xmms2
noblacklist ${HOME}/.config/xmms2
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
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

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp


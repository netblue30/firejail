# Firejail profile for clementine
# Description: Modern music player and library organizer
# This file is overwritten after every install/update
# Persistent local customizations
include clementine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Clementine
noblacklist ${HOME}/.config/Clementine
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# blacklisting of ioprio_set system calls breaks clementine
seccomp !ioprio_set

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

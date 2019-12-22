# Firejail profile for wine
# Description: A compatibility layer for running Windows programs
# This file is overwritten after every install/update
# Persistent local customizations
include wine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.wine

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

# some applications don't need allow-debuggers, comment the next line
# if it is not necessary (or put 'ignore allow-debuggers' in your wine.local)
allow-debuggers
caps.drop all
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
# novideo
seccomp

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg

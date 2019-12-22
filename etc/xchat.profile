# Firejail profile for xchat
# Description: IRC client for X similar to AmIRC
# This file is overwritten after every install/update
# Persistent local customizations
include xchat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xchat

include disable-common.inc
include disable-devel.inc
include disable-programs.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

# private-bin requires perl, python*, etc.
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg

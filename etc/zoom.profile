# Firejail profile for zoom
# This file is overwritten after every install/update
# Persistent local customizations
include zoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/zoomus.conf
noblacklist ${HOME}/.zoom

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/zoom
mkfile ${HOME}/.config/zoomus.conf
mkdir ${HOME}/.zoom
whitelist ${HOME}/.cache/zoom
whitelist ${HOME}/.config/zoomus.conf
whitelist ${HOME}/.zoom
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

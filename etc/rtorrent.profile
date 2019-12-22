# Firejail profile for rtorrent
# Description: Ncurses BitTorrent client based on LibTorrent from rakshasa
# This file is overwritten after every install/update
# Persistent local customizations
include rtorrent.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin rtorrent
private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-tmp

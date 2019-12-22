# Firejail profile for aria2c
# Description: Download utility that supports HTTP(S), FTP, BitTorrent and Metalink
# This file is overwritten after every install/update
# Persistent local customizations
include aria2c.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.aria2

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
ipc-namespace
netfilter
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
protocol unix,inet,inet6,netlink
seccomp
shell none

# disable-mnt
private-bin aria2c,gzip
# Uncomment the next line (or put 'private-cache' in your aria2c.local) if you don't use Lutris/winetricks (see issue #2772)
#private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-lib libreadline.so.*
private-tmp

memory-deny-write-execute

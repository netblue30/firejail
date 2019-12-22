# Firejail profile for transmission-common
# Description: Fast, easy and free BitTorrent client
# This file is overwritten after every install/update
# Persistent local customizations
include transmission-common.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/transmission
mkdir ${HOME}/.config/transmission
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/transmission
whitelist ${HOME}/.config/transmission
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
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
tracelog

private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-lib
private-tmp

memory-deny-write-execute

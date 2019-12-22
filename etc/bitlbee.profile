# Firejail profile for bitlbee
# Description: IRC to other chat networks gateway
# This file is overwritten after every install/update
# Persistent local customizations
include bitlbee.local
# Persistent global definitions
include globals.local

#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,group,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
ignore noexec ${HOME}

noblacklist /sbin
noblacklist /usr/sbin
# noblacklist /var/log

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

netfilter
no3d
nodvd
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private
private-cache
private-dev
private-tmp

read-write /var/lib/bitlbee

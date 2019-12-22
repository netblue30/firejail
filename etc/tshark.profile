# Firejail profile for tshark
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tshark.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/wireshark
include whitelist-common.inc
include whitelist-usr-share-common.inc

#caps.keep net_raw
caps.keep dac_override,net_admin,net_raw
ipc-namespace
#net tun0
netfilter
no3d
nodvd
# nogroups - breaks network traffic capture for unprivileged users
# nonewprivs - breaks network traffic capture for unprivileged users
# noroot
nosound
notv
nou2f
novideo
#protocol unix,inet,inet6,netlink,packet
#seccomp

disable-mnt
#private
private-cache
#private-bin tshark
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,group,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

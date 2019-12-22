# Firejail profile for dnsmasq
# Description: Small caching DNS proxy and DHCP/TFTP server
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dnsmasq.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.keep net_admin,net_bind_service,net_raw,setgid,setuid
no3d
nodvd
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,default,dnsmasq.conf,dnsmasq.conf.d,dnsmasq.d,ethers,group,hosts,host.conf,hostname,hosts,insserv.conf.d,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,resolvconf,rpc,services,ssl,xdg

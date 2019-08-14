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

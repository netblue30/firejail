# Firejail profile for dnsmasq
# Description: Small caching DNS proxy and DHCP/TFTP server
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dnsmasq.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.keep net_admin,net_bind_service,net_raw,setgid,setuid
no3d
nodvd
nonewprivs
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private
private-cache
private-dev

# Firejail profile for dnsmasq
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dnsmasq.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin
noblacklist /var/log

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps
# caps.keep net_admin,net_bind_service,net_raw,setgid,setuid
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
private-dev

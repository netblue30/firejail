# Firejail profile for server
# This file is overwritten after every install/update
# Persistent local customizations
include fdns.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

caps.keep kill,net_bind_service,setgid,setuid,sys_admin,sys_chroot
ipc-namespace
# netfilter /etc/firejail/webserver.net
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
#seccomp
#shell none

disable-mnt
private
private-bin bash,fdns,sh
private-cache
#private-dev
private-etc ca-certificates,crypto-policies,fdns,ld.so.cache,ld.so.preload,localtime,nsswitch.conf,passwd,pki,ssl
# private-lib
private-tmp

memory-deny-write-execute

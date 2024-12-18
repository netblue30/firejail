# Firejail profile for server
# This file is overwritten after every install/update
# Persistent local customizations
include fdns.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

apparmor /usr/bin/fdns
caps.keep kill,net_bind_service,setgid,setuid,sys_admin,sys_chroot
ipc-namespace
#netfilter /etc/firejail/webserver.net
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

disable-mnt
private
private-bin bash,fdns,sh
private-cache
#private-dev
private-etc @tls-ca,fdns
#private-lib
private-tmp

memory-deny-write-execute

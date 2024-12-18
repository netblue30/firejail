# Firejail profile for unbound
# Description: Validating, recursive, caching DNS resolver
# This file is overwritten after every install/update
# Persistent local customizations
include unbound.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

whitelist /usr/share/dns
include whitelist-usr-share-common.inc

whitelist /var/lib/ca-certificates
read-only /var/lib/ca-certificates
whitelist /var/lib/unbound
whitelist /var/run

caps.keep net_admin,net_bind_service,setgid,setuid,sys_chroot,sys_resource
ipc-namespace
machine-id
netfilter
no3d
nodvd
noinput
nonewprivs
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp !chroot

disable-mnt
private
private-dev
private-tmp
writable-var

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

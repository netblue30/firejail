# Firejail profile for host
# Description: DNS lookup utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include host.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
noblacklist ${PATH}/host

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private
private-bin bash,host,sh
private-etc alternatives,ld.so.cache,ld.so.preload,login.defs,passwd,resolv.conf
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

# Firejail profile for ssh
# Description: Secure shell client and server
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh.local
# Persistent global definitions
include globals.local

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ${HOME}/.ssh
# nc can be used as ProxyCommand, e.g. when using tor
noblacklist ${PATH}/nc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
# noroot - see issue #1543
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssh,ssl,system-fips,xdg
# private-tmp # Breaks when exiting
writable-run-user

memory-deny-write-execute

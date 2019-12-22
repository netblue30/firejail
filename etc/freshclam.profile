# Firejail profile for freshclam
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include clamav.local
# Persistent global definitions
include globals.local

include disable-exec.inc

caps.keep setgid,setuid
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private
private-cache
private-dev
#private-etc alternatives,ca-certificates,clamav,clamd.d,crypto-policies,dbus-1,freshclam.conf,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mail,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,whitelisted_addresses,xdg
private-tmp
writable-var
writable-var-log

memory-deny-write-execute

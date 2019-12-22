# Firejail profile for arch-audit
# Description: A utility like pkg-audit based on Arch CVE Monitoring Team data
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include arch-audit.local
# Persistent global definitions
include globals.local

noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/arch-audit
include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
private
private-bin arch-audit
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pacman.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute

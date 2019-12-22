# Firejail profile for curl
# Description: Command line tool for transferring data with URL syntax
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include curl.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.curlrc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

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

# private-bin curl
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

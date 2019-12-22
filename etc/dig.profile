# Firejail profile for dig
# Description: DNS lookup utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dig.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.digrc

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

#mkfile ${HOME}/.digrc -- see #903
whitelist ${HOME}/.digrc
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
# ipc-namespace
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
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin bash,dig,sh
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,trusted-key.key,xdg
# Uncomment the next line (or put 'private-lib' in your dig.local) on non Debian/Ubuntu OS (see issue #3038)
#private-lib
private-tmp

memory-deny-write-execute

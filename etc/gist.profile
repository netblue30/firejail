# Firejail profile for gist
# Description: Potentially the best command line gister
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gist.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.gist

# Allow ruby (blacklisted by disable-interpreters.inc)
include allow-ruby.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.gist
whitelist ${HOME}/.gist
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute

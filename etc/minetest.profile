# Firejail profile for minetest
# Description: Multiplayer infinite-world block sandbox
# This file is overwritten after every install/update
# Persistent local customizations
include minetest.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.minetest

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.minetest
whitelist ${HOME}/.minetest
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin minetest
private-dev
# private-etc needs to be updated, see #1702
#private-etc alternatives,asound.conf,ca-certificates,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,nsswitch.conf,passwd,pulse,resolv.conf,ssl,pki,crypto-policies,machine-id
private-tmp

noexec ${HOME}
noexec /tmp

# Firejail profile for cower
# Description: a simple AUR agent with a pretentious name
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cower.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/cower
noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# This profile could be significantly strengthened by adding the following to cower.local
# whitelist ${HOME}/<Your Build Folder>
# whitelist ${HOME}/.config/cower

caps.drop all
ipc-namespace
netfilter
no3d
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
private-bin cower
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute

read-only ${HOME}/.config/cower/config

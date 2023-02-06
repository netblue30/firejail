# Firejail profile for utox
# Description: Lightweight Tox client
# This file is overwritten after every install/update
# Persistent local customizations
include utox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Tox
noblacklist ${HOME}/.config/tox

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/tox
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/tox
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin utox
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.preload,localtime,machine-id,openal,pki,pulse,resolv.conf,ssl
private-tmp

memory-deny-write-execute
restrict-namespaces

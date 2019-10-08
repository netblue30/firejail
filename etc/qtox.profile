# Firejail profile for qtox
# Description: Powerful Tox client written in C++/Qt that follows the Tox design guidelines
# This file is overwritten after every install/update
# Persistent local customizations
include qtox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Tox
noblacklist ${HOME}/.config/tox

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
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
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin qtox
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,pulse,resolv.conf,ssl
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

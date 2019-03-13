# Firejail profile for arm
# Description: Terminal status monitor for Tor relays
# This file is overwritten after every install/update
# Persistent local customizations
include arm.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.arm

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.arm
whitelist ${HOME}/.arm
include whitelist-common.inc

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
tracelog

disable-mnt
private-bin arm,tor,sh,bash,python*,ps,lsof,ldconfig
private-dev
private-etc alternatives,tor,passwd,ca-certificates,ssl,pki,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp

# Firejail profile for arm
# Description: Terminal status monitor for Tor relays
# This file is overwritten after every install/update
# Persistent local customizations
include arm.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.arm

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.arm
allow  ${HOME}/.arm
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
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
private-bin arm,bash,ldconfig,lsof,ps,python*,sh,tor
private-dev
private-etc alternatives,ca-certificates,crypto-policies,passwd,pki,ssl,tor
private-tmp


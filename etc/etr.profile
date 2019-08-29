# Firejail profile for etr
# Description: High speed arctic racing game
# This file is overwritten after every install/update
# Persistent local customizations
include etr.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.etr

include disable-common.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.etr
whitelist ${HOME}/.etr
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin etr
private-cache
private-dev
# private-etc alternatives,drirc,machine-id,openal
private-tmp

# Firejail profile for torcs
# Description: The Open Racing Car Simulator
# This file is overwritten after every install/update
# Persistent local customizations
include torcs.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.torcs

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.torcs
whitelist ${HOME}/.torcs
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-tmp

# Firejail profile for teeworlds
# Description: Online multi-player platform 2D shooter
# This file is overwritten after every install/update
# Persistent local customizations
include teeworlds.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.teeworlds

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.teeworlds
whitelist ${HOME}/.teeworlds
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
tracelog

disable-mnt
private-bin teeworlds
private-cache
private-dev
private-tmp

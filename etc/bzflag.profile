# Firejail profile for bzflag
# Description: 3D multi-player tank battle game
# This file is overwritten after every install/update
# Persistent local customizations
include bzflag.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bzf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.bzf
whitelist ${HOME}/.bzf
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
private-bin bzflag,bzflag-wrapper,bzfs,bzadmin
private-cache
private-dev
private-tmp

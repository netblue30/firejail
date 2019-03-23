# Firejail profile for scorched3d
# Description: Game based loosely on the classic DOS game Scorched Earth
# This file is overwritten after every install/update
# Persistent local customizations
include scorched3d.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.scorched3d

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.scorched3d
whitelist ${HOME}/.scorched3d
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
private-bin scorched3d,scorched3d-wrapper,scorched3dc,scorched3ds
private-cache
private-dev
private-tmp

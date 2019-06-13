# Firejail profile for viewnior
# Description: Simple, fast and elegant image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include viewnior.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/viewnior
noblacklist ${HOME}/.steam

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin viewnior
private-cache
private-dev
private-etc alternatives,fonts,machine-id
private-tmp

#memory-deny-write-execute - breaks on Arch (see issues #1803 and #1808)

# Firejail profile for Newsboat
# Description: RSS program
# This file is overwritten after every install/update
# Persistent local customizations
include newsboat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.newsboat
whitelist ${HOME}/.newsboat

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
# private
# private-bin newsboat bash
private-cache
private-dev
# private-etc none
#private-lib
private-tmp

memory-deny-write-execute
#noexec ${HOME}
#noexec /tmp

# Firejail profile for devilspie2
# Description: Window matching daemon (Lua)
# This file is overwritten after every install/update
# Persistent local customizations
include devilspie2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/devilspie2

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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

disable-mnt
private-bin devilspie2
private-cache
private-dev
private-etc alternatives
private-lib gconv
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# devilspie2 will never write anything
read-only ${HOME}

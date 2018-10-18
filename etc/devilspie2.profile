# Firejail profile for devilspie2
# Description: Window matching daemon (Lua)
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/devilspie2.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/devilspie2

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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
private-etc none
private-lib gconv
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# devilspie2 will never write anything
read-only ${HOME}

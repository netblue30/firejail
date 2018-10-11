# Firejail profile for devilspie
# Description: Window matching daemon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/devilspie.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.devilspie

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
private-bin devilspie
private-cache
private-dev
private-etc none
private-lib gconv
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# devilspie will never write anything
read-only ${HOME}

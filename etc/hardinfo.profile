# Firejail profile for hardinfo
# Description: A system information and benchmark tool
# This file is overwritten after every install/update
# Persistent local customizations
include hardinfo.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
machine-id
ipc-namespace
netfilter
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
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-cache
private-dev
private-tmp

# memory-deny-write-execute - Breaks on Arch
noexec ${HOME}
noexec /tmp

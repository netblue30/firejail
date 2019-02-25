# Firejail profile for cpio
# Description: A program to manage archives of files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cpio.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

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

private-cache
private-dev

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

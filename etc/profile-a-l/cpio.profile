# Firejail profile for cpio
# Description: A program to manage archives of files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cpio.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist /sbin
noblacklist /usr/sbin

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname cpio
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
nosound
notv
nou2f
novideo
seccomp
shell none
tracelog
x11 none

private-cache
private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

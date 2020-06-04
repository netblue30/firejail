# Firejail profile for ar
# Description: Create, modify, and extract from archives
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ar.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

apparmor
caps.drop all
hostname ar
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin ar
private-cache
private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

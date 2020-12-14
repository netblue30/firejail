# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include archiver-common.local

# common settings for all archiver/compression tool profiles

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
hostname archiver
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

private-cache
private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

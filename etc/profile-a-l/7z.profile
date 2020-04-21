# Firejail profile for 7z
# Description: File archiver with high compression ratio
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include 7z.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname 7z
ipc-namespace
machine-id
net none
no3d
nodvd
#nogroups
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

#private-bin 7z,7z*,p7zip
private-cache
private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

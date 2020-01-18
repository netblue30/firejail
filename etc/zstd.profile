# Firejail profile for zstd
# Description: Zstandard - Fast real-time compression algorithm
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include zstd.local
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
hostname zstd
ipc-namespace
machine-id
net none
no3d
nodbus
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

memory-deny-write-execute

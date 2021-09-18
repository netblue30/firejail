# Firejail profile for mediainfo
# Description: Command-line utility for reading information from audio/video files
# This file is overwritten after every install/update
# Persistent local customizations
include mediainfo.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
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
x11 none

private-bin mediainfo
private-cache
private-dev
private-etc alternatives,ld.so.preload
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

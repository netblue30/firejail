# Firejail profile for clamav
# Description: Anti-virus utility for Unix
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include clamav.local
# Persistent global definitions
include globals.local

deny  ${RUNUSER}/wayland-*

include disable-exec.inc

caps.drop all
ipc-namespace
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

private-dev

dbus-user none
dbus-system none

read-only ${HOME}

memory-deny-write-execute

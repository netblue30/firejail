# Firejail profile for gdu
# Description: Fast disk usage analyzer with console interface
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gdu.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

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
x11 none

private-dev
# private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

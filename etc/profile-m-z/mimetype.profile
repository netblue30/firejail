# Firejail profile for mimetype
# Description: Determines the file type
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mimetype.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-exec.inc
include disable-proc.inc
include disable-x11.inc

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
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog
x11 none

private-dev

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-only ${RUNUSER}
read-only /tmp

restrict-namespaces

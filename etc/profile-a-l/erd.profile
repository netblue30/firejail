# Firejail profile for erd
# Description: Multi-threaded file-tree visualizer and disk usage analyzer
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include erd.local
# Persistent global definitions
include globals.local

include disable-exec.inc
#include disable-x11.inc # x11 none

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
seccomp socket
seccomp.block-secondary
x11 none

# private-bin erd does work but defeats the purpose of this app
#private-bin erd
private-dev

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-only ${RUNUSER}
restrict-namespaces

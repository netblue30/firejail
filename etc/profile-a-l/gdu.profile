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
# block the socket syscall to simulate an be empty protocol line, see #639
seccomp socket
seccomp.block-secondary
x11 none

private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

# gdu has built-in delete (d), empty (e) dir/file support and shell spawning (b) features.
# Depending on workflow and use case the sandbox can be hardened by adding the
# lines below to your gdu.local if you don't need/want these functionalities.
#include disable-shell.inc
#private-bin gdu
#read-only ${HOME}

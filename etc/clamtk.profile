# Firejail profile for clamtk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/clamtk.local
# Persistent global definitions
include /etc/firejail/globals.local

caps.drop all
ipc-namespace
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-dev

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

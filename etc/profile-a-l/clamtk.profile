# Firejail profile for clamtk
# This file is overwritten after every install/update
# Persistent local customizations
include clamtk.local
# Persistent global definitions
include globals.local

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

private-dev

dbus-user none
dbus-system none

# Firejail profile for clamav
# Description: Anti-virus utility for Unix
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include clamav.local
# Persistent global definitions
include globals.local

include disable-exec.inc

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
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-dev
read-only ${HOME}

memory-deny-write-execute

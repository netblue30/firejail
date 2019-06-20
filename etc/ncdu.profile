# Firejail profile for ncdu
# Description: Ncurses disk usage viewer
# This file is overwritten after every install/update
# Persistent local customizations
include ncdu.local
# Persistent global definitions
include globals.local

include disable-exec.inc

caps.drop all
ipc-namespace
nodbus
net none
no3d
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
x11 none

private-dev
# private-tmp

memory-deny-write-execute

# Firejail profile for gzip
# Description: GNU compression utilities
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gzip.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

apparmor
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
nogroups
nosound
notv
nou2f
novideo
protocol unix
shell none
tracelog

private-cache
private-dev

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

include default.profile

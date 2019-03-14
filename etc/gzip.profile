# Firejail profile for gzip
# Description: GNU compression utilities
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gzip.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

include disable-exec.inc
include disable-interpreters.inc

ignore noroot

apparmor
hostname gzip
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
nosound
notv
nou2f
novideo
shell none
tracelog

private-cache
private-dev

memory-deny-write-execute

include default.profile

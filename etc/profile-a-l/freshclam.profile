# Firejail profile for freshclam
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include clamav.local
# Persistent global definitions
include globals.local

include disable-exec.inc

caps.keep setgid,setuid
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private
private-cache
private-dev
private-tmp
writable-var
writable-var-log

memory-deny-write-execute

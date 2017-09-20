# Firejail profile for freshclam
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/clamav.local
# Persistent global definitions
include /etc/firejail/globals.local


caps.keep setgid,setuid
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private
private-dev
private-tmp
writable-var
writable-var-log

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

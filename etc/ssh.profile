# Firejail profile for ssh
# Description: Secure shell client and server
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/ssh.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ${HOME}/.ssh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
# noroot - see issue #1543
nosound
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
# private-tmp # Breaks when exiting

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
writable-run-user

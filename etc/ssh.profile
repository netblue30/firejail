# Firejail profile for ssh
# Description: Secure shell client and server
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh.local
# Persistent global definitions
include globals.local

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ${HOME}/.ssh

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
# private-tmp # Breaks when exiting

memory-deny-write-execute
writable-run-user

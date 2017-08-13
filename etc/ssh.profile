# Firejail profile for ssh
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/ssh.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ~/.ssh

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
noroot
nosound
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
# private-tmp # Breaks when exiting

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

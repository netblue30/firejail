# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/ssh.local

# ssh client
quiet
noblacklist ~/.ssh
noblacklist /tmp/ssh-*
noblacklist /etc/ssh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
#private-tmp #Breaks when exiting

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp

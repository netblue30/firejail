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
# nc can be used as ProxyCommand, e.g. when using tor
noblacklist ${PATH}/nc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${RUNUSER}/keyring/ssh
#FIXME: whitelist ${RUNUSER}/gnupg/?????
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
# noroot - see issue #1543
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
# private-tmp # Breaks when exiting
writable-run-user

memory-deny-write-execute

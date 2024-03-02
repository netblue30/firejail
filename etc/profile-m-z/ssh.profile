# Firejail profile for ssh
# Description: Secure shell client and server
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh.local
# Persistent global definitions
include globals.local

# nc can be used as ProxyCommand, e.g. when using tor
noblacklist ${PATH}/nc
noblacklist ${PATH}/ncat

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-exec.inc
include disable-programs.inc

whitelist ${RUNUSER}/gcr/ssh
whitelist ${RUNUSER}/gnupg/S.gpg-agent.ssh
whitelist ${RUNUSER}/keyring/ssh
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
#noroot # see issue #1543
nosound
notv
#nou2f # OpenSSH >= 8.2 supports U2F
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-cache
private-dev
#private-tmp # Breaks when exiting
writable-run-user

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute
restrict-namespaces

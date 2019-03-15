# Firejail profile for ssh-agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh-agent.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ${HOME}/.ssh

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none

writable-run-user

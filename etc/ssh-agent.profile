# Firejail profile for ssh-agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/ssh-agent.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ~/.ssh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

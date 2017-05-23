# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/ssh-agent.local

# ssh-agent
quiet
noblacklist ~/.ssh
noblacklist /tmp/ssh-*
noblacklist /etc/ssh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
no3d
protocol unix,inet,inet6
seccomp

blacklist /tmp/.X11-unix

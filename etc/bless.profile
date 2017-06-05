# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/bless.local

#
#Profile for bless
#

#No Blacklist Paths
noblacklist ${HOME}/.config/bless

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

#Options
caps.drop all
#ipc-namespace
net none
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none

private-dev
private-etc fonts,mono
private-tmp

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp

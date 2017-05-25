# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/lollypop.local

#
#Profile for lollypop
#

#No Blacklist Paths
noblacklist ${HOME}/.local/share/lollypop

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

#Options
caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp

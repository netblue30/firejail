# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-calculator.local

#
#Profile for gnome-calculator
#

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

include /etc/firejail/whitelist-common.inc

#Options
caps.drop all
ipc-namespace
netfilter
#net none                                     
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-bin gnome-calculator
private-dev
#private-etc fonts
private-tmp

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp

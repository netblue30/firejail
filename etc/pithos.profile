# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/pithos.local

#
#Profile for pithos
#

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

include /etc/firejail/whitelist-common.inc

#Options
caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp

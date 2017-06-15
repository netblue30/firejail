# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/audacity.local

# Audacity profile
noblacklist ~/.audacity-data

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
#ipc-namespace
net none
netfilter
no3d
nogroups
nonewprivs
noroot
novideo
protocol unix
seccomp
shell none
tracelog

private-bin audacity
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

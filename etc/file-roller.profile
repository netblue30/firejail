# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/file-roller.local

# file-roller profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
no3d
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin file-roller
# private-tmp
private-dev
# private-etc fonts

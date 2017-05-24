# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/dia.local

noblacklist ~/.dia
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

#
# depending on your usage, you can enable some of the commands below:
#
nogroups
shell none
# private-bin program
# private-etc none
private-dev
private-tmp

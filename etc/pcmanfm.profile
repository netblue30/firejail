# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/pcmanfm.local

noblacklist ~/.config/pcmanfm
noblacklist ~/.config/libfm
include /etc/firejail/disable-common.inc
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

#
# depending on your usage, you can enable some of the commands below: 
#
# private-bin program
# private-etc none
# private-dev
# private-tmp


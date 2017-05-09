# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/blender.local

noblacklist ~/.config/blender
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp

#
# depending on your usage, you can enable some of the commands below: 
#
nogroups
shell none
# private-bin program
# private-etc none
# private-dev
# private-tmp

# blender uses the sound system
# nosound

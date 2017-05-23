# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/k3b.local

# k3b profile
noblacklist ~/.kde4/share/config/k3brc
noblacklist ~/.kde/share/config/k3brc
noblacklist ~/.config/k3brc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
no3d
nonewprivs
noroot
nosound
shell none
seccomp
protocol unix
tracelog

# private-bin 
# private-tmp
# private-etc

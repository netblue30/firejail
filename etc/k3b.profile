# Firejail profile for k3b
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/k3b.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/k3brc
noblacklist ~/.kde/share/config/k3brc
noblacklist ~/.kde4/share/config/k3brc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
no3d
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin
# private-etc
# private-tmp

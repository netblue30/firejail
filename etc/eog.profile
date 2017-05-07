# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/eog.local

# eog (gnome image viewer) profile
noblacklist ~/.config/eog
noblacklist ~/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
net none
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none

private-bin eog
private-dev
private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp

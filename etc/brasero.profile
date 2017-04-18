# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/brasero.local

# brasero profile
noblacklist ~/.config/brasero

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
net none
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin brasero
# private-dev
# private-etc fonts
# private-tmp

noexec ${HOME}
noexec /tmp

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/keepassxc.local

# Firejail profile for KeepassXC
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.keepassxc
noblacklist ${HOME}/.*kdbx
noblacklist ${HOME}/.*kdb

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
#protocol unix
seccomp
shell none

private-bin keepassxc
#private-etc fonts
#private-dev
private-tmp

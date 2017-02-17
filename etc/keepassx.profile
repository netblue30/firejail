# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/keepassx2.local

# keepassx password manager profile
noblacklist ${HOME}/.config/keepassx
noblacklist ${HOME}/.keepassx
noblacklist ${HOME}/keepassx.kdbx
 
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
protocol unix
seccomp
shell none
tracelog

private-bin keepassx
private-etc fonts
private-dev
private-tmp

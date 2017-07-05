# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/keepassx2.local

# keepassx password manager profile
noblacklist ${HOME}/.config/keepassx
noblacklist ${HOME}/.keepassx
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/*.kdb

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none

private-bin keepassx2
private-dev
private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp

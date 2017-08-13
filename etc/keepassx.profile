# Firejail profile for keepassx
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/keepassx.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassx
noblacklist ${HOME}/.keepassx

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin keepassx,keepassx2
private-dev
private-etc fonts,machine-id
private-tmp

noexec ${HOME}
noexec /tmp

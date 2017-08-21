# Firejail profile for audacity
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/audacity.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.audacity-data

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin audacity
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

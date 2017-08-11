# Firejail profile for pluma
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pluma.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/pluma

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
seccomp
shell none
tracelog

private-bin pluma
private-dev
private-tmp
notv

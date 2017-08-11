# Firejail profile for gpicview
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gpicview.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/gpicview

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
protocol unix
seccomp
shell none
tracelog

private-bin gpicview
private-dev
private-etc fonts
private-tmp
notv

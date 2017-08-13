# Firejail profile for display
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/display.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none
x11 xorg

private-bin display
private-dev
private-etc none
private-tmp

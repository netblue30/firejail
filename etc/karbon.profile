# Firejail profile for karbon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/karbon.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
net none
nogroups
noroot
seccomp
shell none

private-dev

noexec /home
noexec /tmp

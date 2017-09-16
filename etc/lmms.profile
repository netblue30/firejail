# Firejail profile for lmms
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lmms.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.lmmsrc.xml

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
private-etc fonts,pulse

noexec /home
noexec /tmp

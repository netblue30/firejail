# Firejail profile for freecad
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/freecad.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.config/FreeCAD

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
net none
nogroups
noroot
nosound
protocol unix
seccomp
shell none

private-bin freecad,freecadcmd
private-dev
#private-etc fonts,passwd,alternatives,X11
private-tmp

noexec ${HOME}
noexec /tmp

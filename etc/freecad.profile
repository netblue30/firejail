# Firejail profile for freecad
# Description: Extensible Open Source CAx program
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/freecad.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/FreeCAD
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
ipc-namespace
net none
nodbus
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

private-bin freecad,freecadcmd
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

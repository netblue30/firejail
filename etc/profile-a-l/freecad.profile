# Firejail profile for freecad
# Description: Extensible Open Source CAx program
# This file is overwritten after every install/update
# Persistent local customizations
include freecad.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/FreeCAD
noblacklist ${DOCUMENTS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin freecad,freecadcmd,python*
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

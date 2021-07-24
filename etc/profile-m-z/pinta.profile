# Firejail profile for pinta
# Description: Simple drawing/painting program
# This file is overwritten after every install/update
# Persistent local customizations
include pinta.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/Pinta
nodeny  ${DOCUMENTS}
nodeny  ${PICTURES}

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

private-dev
private-cache
private-tmp

dbus-user none
dbus-system none

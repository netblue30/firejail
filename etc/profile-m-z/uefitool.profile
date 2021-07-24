# Firejail profile for uefitool
# This file is overwritten after every install/update
# Persistent local customizations
include uefitool.local
# Persistent global definitions
include globals.local

nodeny  ${DOCUMENTS}

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
no3d
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

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

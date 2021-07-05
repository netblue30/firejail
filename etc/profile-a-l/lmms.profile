# Firejail profile for lmms
# Description: Linux Multimedia Studio
# This file is overwritten after every install/update
# Persistent local customizations
include lmms.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.lmmsrc.xml
nodeny  ${DOCUMENTS}
nodeny  ${MUSIC}

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
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

dbus-user none
dbus-system none

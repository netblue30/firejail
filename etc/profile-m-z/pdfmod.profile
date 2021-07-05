# Firejail profile for pdfmod
# Description: Simple tool for modifying PDF documents
# This file is overwritten after every install/update
# Persistent local customizations
include pdfmod.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/pdfmod
nodeny  ${HOME}/.config/pdfmod
nodeny  ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
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

private-dev
private-tmp

dbus-user none
dbus-system none

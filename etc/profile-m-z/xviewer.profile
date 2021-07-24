# Firejail profile for xviewer
# This file is overwritten after every install/update
# Persistent local customizations
include xviewer.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.Steam
nodeny  ${HOME}/.config/xviewer
nodeny  ${HOME}/.local/share/Trash
nodeny  ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
# net none - makes settings immutable
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
tracelog

private-bin xviewer
private-dev
private-lib
private-tmp

# makes settings immutable
# dbus-user none
# dbus-system none

memory-deny-write-execute

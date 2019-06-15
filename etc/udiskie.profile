# Firejail profile for udiskie
# Description: Removable disk automounter using udisks
# This file is overwritten after every install/update
# quiet
# Persistent local customizations
include udiskie.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc include disable-programs.inc
include disable-xdg.inc

caps.drop all
machine-id
net none
nogroups
nonewprivs
noroot
notv
nou2f
novideo
seccomp
shell none
tracelog

private-cache
private-dev
private-tmp

# Firejail profile for d-feet
# Description: D-Bus debugger for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include d-feet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/d-feet

# Allow python (disabled by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/d-feet
whitelist ${HOME}/.config/d-feet
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
# net none - breaks on Ubuntu
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin d-feet,python*
private-cache
private-dev
private-etc alternatives,dbus-1,fonts,machine-id
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

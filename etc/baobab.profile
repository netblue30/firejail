# Firejail profile for baobab
# Description: GNOME disk usage analyzer
# This file is overwritten after every install/update
# Persistent local customizations
include baobab.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

caps.drop all
net none
no3d
nodbus
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

private-bin baobab
private-dev
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

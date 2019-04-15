# Firejail profile for freeoffice-textmaker
# This file is overwritten after every install/update
# Persistent local customizations
include freeoffice-textmaker.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# include disable-xdg.inc

noblacklist ${HOME}/SoftMaker

apparmor
caps.drop all
ipc-namespace
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# disable-mnt
# private
private-cache
private-dev
# private-etc alternatives
# private-lib
private-tmp

#memory-deny-write-execute

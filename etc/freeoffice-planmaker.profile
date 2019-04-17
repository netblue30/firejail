# Firejail profile for freeoffice-planmaker
# This file is overwritten after every install/update
# Persistent local customizations
include freeoffice-planmaker.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/SoftMaker

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# include disable-xdg.inc

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
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
private-tmp

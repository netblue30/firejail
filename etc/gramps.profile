# Firejail profile for gramps
# Description: genealogy program
# This file is overwritten after every install/update
# Persistent local customizations
include gramps.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
#noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
#noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
#noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

noblacklist ${HOME}/.gramps
whitelist ${HOME}/.gramps

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
netfilter
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
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
# private-bin gramps
private-cache
private-dev
# private-etc alternatives
# private-lib
private-tmp

#memory-deny-write-execute

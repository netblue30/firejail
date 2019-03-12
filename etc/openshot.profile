# Firejail profile for openshot
# Description: Create and edit videos and movies
# This file is overwritten after every install/update
# Persistent local customizations
include openshot.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openshot
noblacklist ${HOME}/.openshot_qt

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp


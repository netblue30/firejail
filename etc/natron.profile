# Firejail profile for natron
# This file is overwritten after every install/update
# Persistent local customizations
include natron.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

noblacklist ${HOME}/.Natron
noblacklist ${HOME}/.cache/INRIA/Natron
noblacklist ${HOME}/.config/INRIA
noblacklist /opt/natron

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none

private-bin natron,Natron,NatronRenderer

noexec ${HOME}
noexec /tmp

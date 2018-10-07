# Firejail profile for natron
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/natron.local
# Persistent global definitions
include /etc/firejail/globals.local

# Allow access to python
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

noblacklist ${HOME}/.Natron
noblacklist ${HOME}/.cache/INRIA/Natron
noblacklist ${HOME}/.config/INRIA
noblacklist /opt/natron

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

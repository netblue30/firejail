# Firejail profile for natron
# This file is overwritten after every install/update
# Persistent local customizations
include natron.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Natron
noblacklist ${HOME}/.cache/INRIA/Natron
noblacklist ${HOME}/.config/INRIA

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp

private-bin Natron,NatronRenderer,natron

dbus-user none
dbus-system none

restrict-namespaces

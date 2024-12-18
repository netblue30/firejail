# Firejail profile for xed
# This file is overwritten after every install/update
# Persistent local customizations
include xed.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xed
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.python_history
noblacklist ${HOME}/.pythonhist

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

#apparmor # makes settings immutable
caps.drop all
machine-id
#net none # makes settings immutable
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin xed
private-dev
private-tmp

# makes settings immutable
#dbus-user none
#dbus-system none

# xed uses python plugins, memory-deny-write-execute breaks python
#memory-deny-write-execute
restrict-namespaces

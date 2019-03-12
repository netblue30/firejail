# Firejail profile for xed
# This file is overwritten after every install/update
# Persistent local customizations
include xed.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xed

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

# apparmor - makes settings immutable
caps.drop all
machine-id
# net none - makes settings immutable
no3d
# nodbus - makes settings immutable
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
tracelog

private-bin xed
private-dev
# private-etc alternatives,fonts
private-tmp

# xed uses python plugins, memory-deny-write-execute breaks python
# memory-deny-write-execute

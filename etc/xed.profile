# Firejail profile for xed
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xed.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/xed

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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
novideo
protocol unix
seccomp
shell none
tracelog

private-bin xed
private-dev
# private-etc fonts
private-tmp

# xed uses python plugins, memory-deny-write-execute breaks python
# memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# Firejail profile for xed
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xed.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus - makes settings immutable

noblacklist ${HOME}/.config/xed

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
# net none - makes settings immutable
machine-id
no3d
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

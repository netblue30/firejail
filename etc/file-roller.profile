# Firejail profile for file-roller
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/file-roller.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus - makes settings immutable

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
# net none - makes settings immutable
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

# private-bin file-roller
private-dev
# private-etc fonts
# private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# Firejail profile for engrampa
# Description: Archive manager for MATE
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/engrampa.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodbus
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

# private-bin engrampa
private-dev
# private-etc fonts
# private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

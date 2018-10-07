# Firejail profile for patch
# Description: Apply a diff file to an original
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/patch.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
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

private-bin patch,red
private-dev
private-lib

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

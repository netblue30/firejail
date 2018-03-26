# Firejail profile for xviewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xviewer.local
# Persistent global definitions
include /etc/firejail/globals.local

# following line makes settings immutable
blacklist /run/user/*/bus

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/xviewer
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

# following line makes settings immutable
apparmor
caps.drop all
# following line makes settings immutable
net none
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

private-bin xviewer
private-dev
private-etc fonts
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

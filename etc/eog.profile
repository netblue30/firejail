# Firejail profile for eog
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/eog.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus - makes settings immutable

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/eog
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.steam

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

private-bin eog
private-dev
private-etc fonts
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

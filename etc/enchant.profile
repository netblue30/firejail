# Firejail profile for enchant
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/enchant.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/enchant

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
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

# private-bin enchant, enchant-*
private-dev
private-etc none
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp

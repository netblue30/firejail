# Firejail profile for conky
# Description: Highly configurable system monitor
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/conky.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${PICTURES}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-cache
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

quiet
# Firejail profile for dig
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dig.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-xdg.inc

whitelist ~/.digrc
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
# ipc-namespace
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
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin sh,bash,dig
private-cache
private-dev
# private-etc resolv.conf
private-lib
private-tmp

memory-deny-write-execute
# noexec ${HOME}
# noexec /tmp

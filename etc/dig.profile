# Firejail profile for dig
# Description: DNS lookup utility
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include dig.local
# Persistent global definitions
include globals.local

include disable-common.inc
# include disable-devel.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
#include disable-xdg.inc

whitelist ${HOME}/.digrc
include whitelist-common.inc
include whitelist-var-common.inc

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
nou2f
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

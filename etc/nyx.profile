# Firejail profile for nyx
# This file is overwritten after every install/update
# Persistent local customizations
include nyx.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/python3*
noblacklist /usr/include/python3*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python3*
noblacklist /usr/share/python3*

noblacklist ${HOME}/.nyx

mkdir ${HOME}/.nyx

whitelist ${HOME}/.nyx

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# apparmor
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
# tracelog

disable-mnt
private-bin nyx,python
private-cache
private-dev
private-etc passwd,tor
# private-lib
private-opt none
private-srv none
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp

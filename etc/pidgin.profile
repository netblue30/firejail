# Firejail profile for pidgin
# Description: Graphical multi-protocol instant messaging client
# This file is overwritten after every install/update
# Persistent local customizations
include pidgin.local
# Persistent global definitions
include globals.local

ignore noexec ${RUNUSER}
ignore noexec /dev/shm

noblacklist ${HOME}/.purple

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.purple
whitelist ${HOME}/.purple
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
# shell none
tracelog

# private-bin pidgin
private-cache
private-dev
private-tmp

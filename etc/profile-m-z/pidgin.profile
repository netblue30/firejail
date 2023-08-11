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
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.purple
whitelist ${HOME}/.purple
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
tracelog

#private-bin pidgin
private-cache
private-dev
private-tmp

restrict-namespaces

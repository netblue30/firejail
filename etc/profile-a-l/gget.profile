# Firejail profile for gget
# Description: a cli. to get things. from git repos
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gget.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin gget
private-cache
private-dev
private-etc @tls-ca
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

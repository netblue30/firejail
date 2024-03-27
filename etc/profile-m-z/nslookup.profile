# Firejail profile for nslookup
# Description: DNS lookup utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include nslookup.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${PATH}/nslookup

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${HOME}/.nslookuprc
include whitelist-common.inc
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
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin bash,nslookup,sh
private-etc
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

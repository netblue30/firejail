# Firejail profile for googler clones
# Description: common profile for googler clones
# This file is overwritten after every install/update
# Persistent local customizations
include googler-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

blacklist ${RUNUSER}

noblacklist ${HOME}/.w3m

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc
# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${HOME}/.w3m
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin env,python3*,sh,w3m
private-cache
private-dev
private-etc @tls-ca,host.conf,rpc,services
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

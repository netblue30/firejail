# Firejail profile for axel
# Description: Lightweight CLI download accelerator
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include axel.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.axelrc
noblacklist ${HOME}/.netrc

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-x11.inc # x11 none
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog
x11 none

#disable-mnt
private-bin axel
private-cache
private-dev
private-etc @network,@tls-ca,axelrc
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

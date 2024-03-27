# Firejail profile for cloneit
# Description: A CLI tool to download specific GitHub directories or files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cloneit.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

include whitelist-run-common.inc
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

disable-mnt
private-bin cloneit
private-cache
private-dev
private-etc @network,@tls-ca,rpc,services
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

# Firejail profile for url-eater
# Description: Clean unnecessary parameters from URLs copied to clipboard
# This file is overwritten after every install/update
# Persistent local customizations
include url-eater.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin url-eater
private-cache
private-dev
private-etc url-eater.kdl
private-lib
#private-tmp # breaks on Arch

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces

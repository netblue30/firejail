# Firejail profile for reader
# Description: Better readability of web pages on the CLI
# This file is overwritten after every install/update
# Persistent local customizations
include reader.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

#include whitelist-common.inc # see #903
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
protocol inet
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private
private-bin reader
private-cache
private-dev
private-etc @network,@tls-ca
private-lib
private-opt none
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces

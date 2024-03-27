# Firejail profile for bpftop
# Description: Dynamic real-time view of running eBPF programs
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bpftop.local
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

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.keep sys_admin
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
noprinters
#noroot
nosound
notv
nou2f
novideo
seccomp.drop socket
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private-bin bpftop
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
read-only ${HOME}

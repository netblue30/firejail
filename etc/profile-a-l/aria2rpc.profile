quiet
# Persistent local customizations
include aria2rpc.local
# Persistent global definitions
include globals.local

include allow-ruby.inc

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-write-mnt.inc
include disable-X11.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
#include whitelist-runuser-common.inc
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
protocol inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private
private-bin aria2rpc,env,ruby*
private-dev
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute

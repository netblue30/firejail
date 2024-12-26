# Persistent local customizations
include cryptonote-wallet-cli-common.local
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
# Superseded by disable-mnt
#include disable-write-mnt.inc
include disable-X11.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute

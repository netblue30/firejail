# Persistent local customizations
include hledger-common.local
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
# Superseded by x11 none
#include disable-X11.inc
include disable-xdg.inc

whitelist ${HOME}/.hledger.journal
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
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
#memory-deny-write-execute causes the following error
#error while loading shared libraries: libHSrts_thr-ghc9.0.2.so:
#cannot enable executable stack as shared object requires:
#Operation not permitted

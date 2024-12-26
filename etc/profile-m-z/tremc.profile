quiet
# Persistent local customizations
include tremc.local
# Persistent global definitions
include globals.local

include allow-python2.inc
include allow-python3.inc

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

# I want to add torrent files from various places in ${HOME}
#include whitelist-common.inc
include whitelist-run-common.inc
# blacklist ${RUNUSER} makes this ineffective
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
# private hides ${HOME}. I want to add torrent files in ${HOME}.
# /usr/bin/env is used in gentoo linux python scripts.
private-bin env,python*,tremc
private-cache
private-dev
# private-etc seems fragile and incomprehensible.
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute

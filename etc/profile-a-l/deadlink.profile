# Firejail profile for deadlink
# Description: Checks and fixes URLs in code and documentation
# This file is overwritten after every install/update
# Persistent local customizations
include deadlink.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

noblacklist ${HOME}/.config/deadlink

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
include allow-python3.inc

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
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
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
protocol unix,inet
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private-bin deadlink,python*
private-cache
private-dev
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

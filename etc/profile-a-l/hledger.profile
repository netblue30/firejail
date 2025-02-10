# Firejail profile for hledger
# Description: Plain text accounting software (CLI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include hledger.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.hledger.journal

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

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
notpm
notv
nou2f
novideo
seccomp
seccomp.block-secondary
x11 none

disable-mnt
private-cache
private-dev
private-etc terminfo
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
#memory-deny-write-execute # breaks haskell (ghc)

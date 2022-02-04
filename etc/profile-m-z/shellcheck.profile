# Firejail profile for shellcheck
# Description: Lint tool for shell scripts
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include shellcheck.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/shellcheck
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
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog
x11 none

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

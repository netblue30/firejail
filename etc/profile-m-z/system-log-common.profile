# Firejail profile for system-log-common
# Description: Common profile for GUI system log viewers
# This file is overwritten after every install/update
# Persistent local customizations
include system-log-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /run/log/journal
whitelist /var/log/journal
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
no3d
nodvd
#nogroups
noinput
nonewprivs
noprinters
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-cache
private-dev
private-etc machine-id
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
# Add 'ignore read-only ${HOME}' to your system-log-common.local
# if you export logs to a file under your ${HOME}.
read-only ${HOME}
writable-var-log

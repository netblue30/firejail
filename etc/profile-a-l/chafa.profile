# Firejail profile for chafa
# Description: A terminal-based image viewer and image-to-text converter.
# This file is overwritten after every install/update
# Persistent local customizations
include chafa.local
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
include disable-write-mnt.inc

include whitelist-run-common.inc
include whitelist-runuser-common.inc
# Add the following to your chafa.local if you do not need to view images in
# /usr/share.
#include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
seccomp socket
seccomp.block-secondary
tracelog
x11 none

private-bin chafa
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}

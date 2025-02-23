# Firejail profile for nsxiv
# Description: Neo Simple X Image Viewer
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include nsxiv.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/nsxiv
noblacklist ${HOME}/.config/nsxiv

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

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

apparmor
caps.drop all
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

private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute
read-only ${HOME}

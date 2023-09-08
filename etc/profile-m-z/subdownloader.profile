# Firejail profile for subdownloader
# Description: Automatic download/upload of subtitles using fast hashing
# This file is overwritten after every install/update
# Persistent local customizations
include subdownloader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/SubDownloader
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

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
noroot
nosound
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute # breaks on Arch (see issue #1803)
restrict-namespaces

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include archiver-common.local

# common profile for archiver/compression tools

blacklist ${RUNUSER}

# Comment/uncomment the relevant include file(s) in your archiver-common.local
# to (un)restrict file access for **all** archivers. Another option is to do this **per archiver**
# in the relevant <archiver>.local. Beware that things tend to break when overtightening
# profiles. For example, because you only need to (un)compress files in ${DOWNLOADS},
# other applications may need access to ${HOME}/.local/share.

# Add the next line to your archiver-common.local if you don't need to compress files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# Add the next line to your archiver-common.local if you don't need to compress files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc

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
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog
x11 none

private-cache
private-dev
private-etc mkinitcpio*

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

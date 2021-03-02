# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include archiver-common.local

# common profile for archiver/compression tools

blacklist ${RUNUSER}

# WARNING: Users can (un)restrict file access for **all** archivers by
# commenting/uncommenting the needed include file(s) here or by putting those
# into archiver-common.local.
#
# Another option is to do this **per archiver** in the relevant
# <archiver>.local. Just beware that things tend to break when overtightening
# profiles. For example, because you only need to (un)compress files in
# ${DOWNLOADS}, other applications may need access to ${HOME}/.local/share.

# Uncomment the next line (or put it into your archiver-common.local) if you
# don't need to compress files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Uncomment the next line (or put it into your archiver-common.local) if you
# don't need to compress files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc

apparmor
caps.drop all
hostname archiver
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-cache
private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

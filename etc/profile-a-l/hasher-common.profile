# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include hasher-common.local

# common profile for hasher/checksum tools

# If you use nvm, add the following to hasher-common.local:
#noblacklist ${HOME}/.nvm

blacklist ${RUNUSER}

# Comment/uncomment the relevant include file(s) in your hasher-common.local
# to (un)restrict file access for **all** hashers. Another option is to do this **per hasher**
# in the relevant <hasher>.local. Beware that things tend to break when overtightening
# profiles. For example, because you only need to hash/check files in ${DOWNLOADS},
# other applications may need access to ${HOME}/.local/share.

# Add the next line to your hasher-common.local if you don't need to hash files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# Add the next line to your hasher-common.local if you don't need to hash files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
# Add the next line to your hasher-common.local if you don't need to hash files in disable-xdg.inc.
#include disable-xdg.inc

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
tracelog
x11 none

# Add the next line to your hasher-common.local if you don't need to hash files in ~/.cache.
#private-cache
private-dev
private-etc
# Add the next line to your hasher-common.local if you don't need to hash files in /tmp.
#private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include hasher-common.local

# common profile for hasher/checksum tools

blacklist ${RUNUSER}

# WARNING:
# Users can (un)restrict file access for **all** hashers by commenting/uncommenting the needed
# include file(s) here or by putting those into hasher-common.local.
# Another option is to do this **per hasher** in the relevant <hasher>.local.
# Just beware that things tend to break when overtightening profiles. For example, because you only
# need to hash/check files in ${DOWNLOADS}, other applications may need access to ${HOME}/.local/share.

# Uncomment the next line (or put it into your hasher-common.local) if you don't need to hash files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Uncomment the next line (or put it into your hasher-common.local) if you don't need to hash files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
# Uncomment the next line (or put it into your hasher-common.local) if you don't need to hash files in disable-xdg.inc.
#include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
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

# Uncomment the next line (or put it into your hasher-common.local) if you don't need to hash files in /tmp.
#private-cache
private-dev
# Uncomment the next line (or put it into your hasher-common.local) if you don't need to hash files in /tmp.
#private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}

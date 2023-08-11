# Firejail profile for less
# Description: Pager program similar to more
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include less.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${HOME}/.lesshst

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
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

# The user can have a custom coloring script configured in ${HOME}/.lessfilter.
# Enable private-bin and private-lib if you are not using any filter.
#private-bin less
#private-lib
private-cache
private-dev
writable-var-log

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-write ${HOME}/.lesshst
restrict-namespaces

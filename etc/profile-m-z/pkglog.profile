# Firejail profile for pklog
# Description: Reports log of package updates
# This file is overwritten after every install/update
# Persistent local customizations
include pkglog.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
#include disable-x11.inc # x11 none
include disable-xdg.inc

whitelist /var/log/apt/history.log
whitelist /var/log/dnf.rpm.log
whitelist /var/log/pacman.log

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
seccomp
tracelog
x11 none

disable-mnt
private
private-bin pkglog,python*
private-cache
private-dev
private-etc
private-opt none
private-tmp
writable-var-log

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-only /var/log/apt/history.log
read-only /var/log/dnf.rpm.log
read-only /var/log/pacman.log
restrict-namespaces

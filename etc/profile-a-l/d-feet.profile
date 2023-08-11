# Firejail profile for d-feet
# Description: D-Bus debugger for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include d-feet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/d-feet

# Allow python (disabled by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/d-feet
whitelist ${HOME}/.config/d-feet
whitelist /usr/share/d-feet
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
#net none # breaks on Ubuntu
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

disable-mnt
private-bin d-feet,python*
private-cache
private-dev
private-etc dbus-1
private-tmp

#memory-deny-write-execute # breaks on Arch (see issue #1803)
restrict-namespaces

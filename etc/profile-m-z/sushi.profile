# Firejail profile for sushi
# Description: A quick previewer for Nautilus
# This file is overwritten after every install/update
# Persistent local customizations
include sushi.local
# Persistent global definitions
include globals.local

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
#include disable-programs.inc
include disable-shell.inc

include whitelist-runuser-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin gjs,sushi
private-dev
private-tmp

dbus-system none

read-only /
read-only /mnt
read-only /media
read-only /run/mount
read-only /run/media
read-only ${HOME}
restrict-namespaces

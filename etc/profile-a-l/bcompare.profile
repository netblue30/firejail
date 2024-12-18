# Firejail profile for Beyond Compare by Scooter Software
# Description: directory and file compare utility
# Disables the network, which only impacts checking for updates.
# This file is overwritten after every install/update
# Persistent local customizations
include bcompare.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/bcompare
# In case the user decides to include disable-programs.inc, still allow
# KDE's Gwenview to view images via right click -> Open With -> Associated Application
noblacklist ${HOME}/.config/gwenviewrc

# Add the next line to your bcompare.local if you don't need to compare files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# Add the next line to your bcompare.local if you don't need to compare files in disable-programs.inc.
#include disable-programs.inc
#include disable-shell.inc # breaks launch
include disable-write-mnt.inc

apparmor
caps.drop all
net none
no3d
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

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

# Firejail profile for gramps
# Description: genealogy program
# This file is overwritten after every install/update
# Persistent local customizations
include gramps.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gramps
noblacklist ${HOME}/.gramps

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/gramps
mkdir ${HOME}/.gramps
whitelist ${HOME}/.config/gramps
whitelist ${HOME}/.gramps
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

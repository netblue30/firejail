# Firejail profile for engrampa
# Description: Archive manager for MATE
# This file is overwritten after every install/update
# Persistent local customizations
include engrampa.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
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
tracelog

# private-bin engrampa
private-dev
# private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces

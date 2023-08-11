# Firejail profile for simutrans
# Description: Transportation simulator
# This file is overwritten after every install/update
# Persistent local customizations
include simutrans.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.simutrans

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.simutrans
whitelist ${HOME}/.simutrans
include whitelist-common.inc
include whitelist-var-common.inc

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

#private-bin simutrans
private-dev
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

# Firejail profile for galculator
# Description: Scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include galculator.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/galculator

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/galculator
whitelist ${HOME}/.config/galculator
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#ipc-namespace
net none
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

private-bin galculator
private-cache
private-dev
private-etc
private-lib
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute # breaks on Arch (see issue #1803)
restrict-namespaces

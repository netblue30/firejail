# Firejail profile for lincity-ng
# Description: City simulation game
# This file is overwritten after every install/update
# Persistent local customizations
include lincity-ng.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.lincity-ng

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.lincity-ng
whitelist ${HOME}/.lincity-ng
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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

disable-mnt
private-bin lincity-ng
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

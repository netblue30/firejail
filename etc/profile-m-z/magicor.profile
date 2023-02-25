# Firejail profile for magicor
# Description: Push ice blocks around to extinguish all fires
# This file is overwritten after every install/update
# Persistent local customizations
include magicor.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.magicor

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.magicor
whitelist ${HOME}/.magicor
whitelist /usr/share/magicor
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin magicor,python2*
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

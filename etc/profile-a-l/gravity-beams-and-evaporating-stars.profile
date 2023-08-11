# Firejail profile for gravity-beams-and-evaporating-stars
# Description: a game about hurling asteroids into the sun
# This file is overwritten after every install/update
# Persistent local customizations
include gravity-beams-and-evaporating-stars.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/gravity-beams-and-evaporating-stars
#include whitelist-common.inc # see #903
include whitelist-usr-share-common.inc
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
tracelog

disable-mnt
private
private-bin gravity-beams-and-evaporating-stars
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

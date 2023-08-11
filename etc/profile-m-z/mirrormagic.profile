# Firejail profile for mirrormagic
# Description: Puzzle game where you steer a beam of light using mirrors
# This file is overwritten after every install/update
# Persistent local customizations
include mirrormagic.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mirrormagic

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.mirrormagic
whitelist ${HOME}/.mirrormagic
whitelist /usr/share/mirrormagic
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
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
tracelog

disable-mnt
private-bin mirrormagic
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

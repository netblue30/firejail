# Firejail profile for jumpnbump
# Description: Cute multiplayer platform game with bunnies
# This file is overwritten after every install/update
# Persistent local customizations
include jumpnbump.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.jumpnbump

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.jumpnbump
whitelist ${HOME}/.jumpnbump
whitelist /usr/share/jumpnbump
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
tracelog

disable-mnt
private-bin jumpnbump
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

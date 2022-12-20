# Firejail profile for freeciv
# Description: A multi-player strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include freeciv.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.freeciv

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.freeciv
whitelist ${HOME}/.freeciv
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin freeciv-gtk3,freeciv-manual,freeciv-mp-gtk3,freeciv-server
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

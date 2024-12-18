# Firejail profile for openclonk
# Description: Multiplayer action, tactics and skill game
# This file is overwritten after every install/update
# Persistent local customizations
include openclonk.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.clonk

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.clonk
whitelist ${HOME}/.clonk
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
#net none # networked game
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin c4group,openclonk
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

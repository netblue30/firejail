# Firejail profile for widelands
# Description: Open source realtime-strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include widelands.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.widelands

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.widelands
allow  ${HOME}/.widelands
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
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin widelands
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

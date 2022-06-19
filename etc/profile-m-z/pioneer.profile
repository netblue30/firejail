# Firejail profile for pioneer
# Description: A game of lonely space adventure
# This file is overwritten after every install/update
# Persistent local customizations
include pioneer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.pioneer

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.pioneer
whitelist ${HOME}/.pioneer
include whitelist-common.inc
include whitelist-var-common.inc

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
protocol unix,netlink
seccomp
tracelog

disable-mnt
private-bin modelcompiler,pioneer,savegamedump
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

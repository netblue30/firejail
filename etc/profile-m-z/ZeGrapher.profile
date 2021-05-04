# Firejail profile for ZeGrapher
# Description: Free and opensource math graphing software
# This file is overwritten after every install/update
# Persistent local customizations
include ZeGrapher.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ZeGrapher Project

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

whitelist /usr/share/ZeGrapher
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
protocol unix,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin ZeGrapher
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

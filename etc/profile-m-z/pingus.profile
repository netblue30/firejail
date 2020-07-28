# Firejail profile for pingus
# Description: Free Lemmings(TM) clone
# This file is overwritten after every install/update
# Persistent local customizations
include pingus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.pingus

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.pingus
whitelist ${HOME}/.pingus
whitelist /usr/share/pingus
include whitelist-common.inc
include whitelist-runuser-common.inc
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
shell none
tracelog

disable-mnt
private-bin pingus,pingus.bin,sh
private-cache
private-dev
private-etc machine-id
private-tmp

dbus-user none
dbus-system none

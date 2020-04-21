# Firejail profile for ostrichriders
# Description: Knights flying on ostriches compete against other riders
# This file is overwritten after every install/update
# Persistent local customizations
include ostrichriders.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ostrichriders

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.ostrichriders
whitelist ${HOME}/.ostrichriders
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
private-bin ostrichriders
private-cache
# private-dev should be commented for controllers
private-dev
private-tmp

dbus-user none
dbus-system none

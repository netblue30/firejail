# Firejail profile for ostrichriders
# Description: Knights flying on ostriches compete against other riders
# This file is overwritten after every install/update
# Persistent local customizations
include ostrichriders.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.ostrichriders

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.ostrichriders
allow  ${HOME}/.ostrichriders
allow  /usr/share/ostrichriders
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
# Add 'ignore noinput' to your ostrichriders.local if you need controller support.
noinput
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
private-dev
private-tmp

dbus-user none
dbus-system none

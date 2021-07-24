# Firejail profile for blobwars
# Description: Mission and Objective based 2D Platform Game
# This file is overwritten after every install/update
# Persistent local customizations
include blobwars.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.parallelrealities/blobwars

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.parallelrealities/blobwars
allow  ${HOME}/.parallelrealities/blobwars
allow  /usr/share/blobwars
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
shell none
tracelog

disable-mnt
private-bin blobwars
private-cache
private-dev
private-etc machine-id
private-tmp

dbus-user none
dbus-system none

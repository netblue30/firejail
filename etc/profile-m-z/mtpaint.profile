# Firejail profile for mtpaint
# Description: Simple painting and editing program
# This file is overwritten after every install/update
# Persistent local customizations
include mtpaint.local
# Persistent global definitions
include globals.local

nodeny  ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
no3d
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin mtpaint
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

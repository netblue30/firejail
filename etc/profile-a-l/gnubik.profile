# Firejail profile for gnubik
# Description: DESCRIPTION
# This file is overwritten after every install/update
# Persistent local customizations
include gnubik.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/gnubik
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
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
private
private-bin gnubik
private-cache
private-dev
private-etc drirc,fonts,gtk-2.0
private-tmp

dbus-user none
dbus-system none

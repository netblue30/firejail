# Firejail profile for baobab
# Description: GNOME disk usage analyzer
# This file is overwritten after every install/update
# Persistent local customizations
include baobab.local
# Persistent global definitions
include globals.local

#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
#include disable-programs.inc
include disable-shell.inc
#include disable-xdg.inc

include whitelist-runuser-common.inc

caps.drop all
net none
no3d
nodvd
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
seccomp.block-secondary
tracelog

private-bin baobab
private-dev
private-tmp

#dbus-user none
#dbus-system none

read-only ${HOME}
restrict-namespaces

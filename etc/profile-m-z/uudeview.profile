# Firejail profile for uudeview
# Description: Smart multi-file multi-part decoder
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include uudeview.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-usr-share-common.inc

caps.drop all
ipc-namespace
machine-id
net none
nodvd
#nogroups
noinput
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog
x11 none

private-bin uudeview
private-cache
private-dev
private-etc

dbus-user none
dbus-system none

restrict-namespaces

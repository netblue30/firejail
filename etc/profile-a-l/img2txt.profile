# Firejail profile for img2txt
# This file is overwritten after every install/update
# Persistent local customizations
include img2txt.local
# Persistent global definitions
include globals.local

deny  ${RUNUSER}/wayland-*

nodeny  ${DOCUMENTS}
nodeny  ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

allow  /usr/share/imlib2
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
protocol unix
seccomp
shell none
tracelog
x11 none

# private-bin img2txt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

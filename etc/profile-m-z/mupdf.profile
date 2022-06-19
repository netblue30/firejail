# Firejail profile for mupdf
# Description: Lightweight PDF viewer
# This file is overwritten after every install/update
# Persistent local customizations
include mupdf.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
tracelog

private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}

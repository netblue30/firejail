# Firejail profile for qrencode
# Description: Encode input data in a QR Code and save as a PNG or EPS image.
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include qrencode.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
shell none
tracelog
x11 none

disable-mnt
private-bin qrencode
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload
private-lib libpcre*
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

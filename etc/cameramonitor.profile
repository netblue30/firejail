# Firejail profile for cameramonitor
# Description: A little monitor to check your webcam status
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cameramonitor.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/cameramonitor
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
#nodbus
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
private-bin cameramonitor,python*
private-cache
private-etc alternatives,fonts
private-tmp

# memory-deny-write-execute - breaks on Arch

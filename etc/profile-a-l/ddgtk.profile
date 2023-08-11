# Firejail profile for ddgtk
# Description: A frontend GUI to dd for making bootable USB disks
# This file is overwritten after every install/update
# Persistent local customizations
include ddgtk.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
whitelist /usr/share/ddgtk
include whitelist-common.inc
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
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin bash,dd,ddgtk,grep,lsblk,python*,sed,sh,tr
private-cache
private-etc
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute # breaks on Arch
restrict-namespaces

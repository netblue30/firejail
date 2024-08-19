# Firejail profile for koi
# Description: Theme scheduling for the KDE Plasma Desktop
# This file is overwritten after every install/update
# Persistent local customizations
include koi.local
# Persistent global definitions
include globals.local

# Restriction below breaks program on Arch.
#include disable-common.inc

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
machine-id
# Add 'net none' to your koi.local if you don't use Sunset/Sunrise feature.
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary

disable-mnt
private-cache
private-dev
private-etc @network,@tls-ca,@X11,mime.types
private-tmp

dbus-user filter
dbus-user.talk org.kde.*
dbus-user.talk org.kde.KWin
dbus-user.talk org.kde.StatusNotifierItem
dbus-system none

deterministic-shutdown
memory-deny-write-execute
restrict-namespaces cgroup,ipc,net,mnt,pid,time,user,uts

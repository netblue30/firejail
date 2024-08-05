# Firejail profile for koi
# Description: Theme scheduling for the KDE Plasma Desktop
# This file is overwritten after every install/update
# Persistent local customizations
include koi.local
# Persistent global definitions
include globals.local

noexec ${HOME}
noexec /tmp

# Restriction below breaks the program on Arch.
#include disable-common.inc

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
#include disable-shell.inc
#include disable-x11.inc
include disable-xdg.inc

apparmor
caps.drop all
#ipc-namespace
machine-id

# Uncomment the restriction below if you don't use Sunset/Sunrise feature.
#net none

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
#private
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,xdg
private-tmp

dbus-system none

deterministic-shutdown
memory-deny-write-execute
restrict-namespaces cgroup,ipc,net,mnt,pid,time,user,uts

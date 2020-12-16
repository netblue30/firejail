# Firejail profile for drill
# Description: DNS lookup utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include drill.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/drill

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private
private-bin bash,drill,sh
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

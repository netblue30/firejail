# Firejail profile for xbill
# Description: save your computers from Wingdows [TM] virus
# This file is overwritten after every install/update
# Persistent local customizations
include xbill.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/xbill
whitelist /var/games/xbill/scores
#include whitelist-common.inc # see #903
include whitelist-usr-share-common.inc
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

disable-mnt
private
private-bin xbill
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces

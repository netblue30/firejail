# Firejail profile for frogatto
# Description: 2D platformer game starring a quixotic frog
# This file is overwritten after every install/update
# Persistent local customizations
include frogatto.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.frogatto

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.frogatto
whitelist ${HOME}/.frogatto
whitelist /usr/libexec/frogatto
whitelist /usr/share/frogatto
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin frogatto,sh
private-cache
private-dev
private-etc ld.so.preload,machine-id
private-tmp

dbus-user none
dbus-system none

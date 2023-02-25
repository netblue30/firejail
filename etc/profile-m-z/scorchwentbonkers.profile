# Firejail profile for scorchwentbonkers
# Description: Realtime remake of Scorched Earth
# This file is overwritten after every install/update
# Persistent local customizations
include scorchwentbonkers.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.swb.ini

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.swb.ini
whitelist ${HOME}/.swb.ini
whitelist /usr/share/scorchwentbonkers
include whitelist-common.inc
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
tracelog

disable-mnt
private-bin scorchwentbonkers
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

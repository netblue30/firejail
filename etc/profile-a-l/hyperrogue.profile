# Firejail profile for hyperrogue
# Description: An SDL roguelike in a non-euclidean world
# This file is overwritten after every install/update
# Persistent local customizations
include hyperrogue.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/hyperrogue.ini

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/hyperrogue.ini
whitelist ${HOME}/hyperrogue.ini
whitelist /usr/share/hyperrogue
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
private-bin hyperrogue
private-cache
private-cwd
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

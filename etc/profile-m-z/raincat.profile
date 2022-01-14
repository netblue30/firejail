# Firejail profile for raincat
# This file is overwritten after every install/update
# Persistent local customizations
include raincat.local
# Persistent global definitions
include globals.local

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/games
whitelist /usr/share/timidity
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
net none
seccomp
shell none
tracelog

disable-mnt
private
private-bin raincat
private-cache
private-dev
private-etc drirc,machine-id,passwd,pulse,timidity,timidity.cfg
#private-lib
private-tmp

dbus-user none
dbus-system none


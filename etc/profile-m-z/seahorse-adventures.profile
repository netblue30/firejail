# Firejail profile for seahorse-adventures
# Description: Help barbie the seahorse float on bubbles to the moon
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse-adventures.local
# Persistent global definitions
include globals.local

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/seahorse-adventures
whitelist /usr/share/games/seahorse-adventures
#include whitelist-common.inc # see #903
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
private
private-bin bash,dash,python*,seahorse-adventures,sh
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

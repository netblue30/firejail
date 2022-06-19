# Firejail profile for mpDris2
# Description: MPRIS2 support for MPD
# This file is overwritten after every install/update
# Persistent local customizations
include mpDris2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpDris2

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${MUSIC}

mkdir ${HOME}/.config/mpDris2
whitelist ${HOME}/.config/mpDris2
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
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
protocol unix,inet,inet6
seccomp

private-bin mpDris2,notify-send,python*
private-cache
private-dev
private-etc alternatives,hosts,ld.so.cache,ld.so.preload,nsswitch.conf
private-lib libdbus-1.so.*,libdbus-glib-1.so.*,libgirepository-1.0.so.*,libnotify.so.*,libpython*,python2*,python3*
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

read-only ${HOME}

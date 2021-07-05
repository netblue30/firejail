# Firejail profile for mpDris2
# Description: MPRIS2 support for MPD
# This file is overwritten after every install/update
# Persistent local customizations
include mpDris2.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/mpDris2

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

nodeny  ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

allow  ${MUSIC}

mkdir ${HOME}/.config/mpDris2
allow  ${HOME}/.config/mpDris2
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
shell none

private-bin mpDris2,notify-send,python*
private-cache
private-dev
private-etc alternatives,hosts,nsswitch.conf
private-lib libdbus-1.so.*,libdbus-glib-1.so.*,libgirepository-1.0.so.*,libnotify.so.*,libpython*,python2*,python3*
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

read-only ${HOME}

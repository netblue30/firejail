# Firejail profile for mpDris2
# Description: MPRIS2 support for MPD
# This file is overwritten after every install/update
# Persistent local customizations
include mpDris2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpDris2

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
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

private-bin mpDris2,notify-send,python*
private-cache
private-dev
private-etc alternatives,hosts,nsswitch.conf
private-lib libdbus-1.so.*,libdbus-glib-1.so.*,libgirepository-1.0.so.*,libnotify.so.*,libpython*,python2*,python3*
private-tmp

# memory-deny-write-execute - Breaks on Arch
noexec ${HOME}
noexec /tmp

# mpDris2 will never write anything
read-only ${HOME}

# Firejail profile for mpg123
# Description: MPEG audio player/decoder
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mpg123.local
# Persistent global definitions
include globals.local

nodeny  ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

#private-bin mpg123*
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

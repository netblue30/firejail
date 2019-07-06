# Firejail profile for mpg123
# Description: MPEG audio player/decoder
# This file is overwritten after every install/update
# Persistent local customizations
include mpg123.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

#private-bin mpg123*
private-dev
private-tmp

memory-deny-write-execute

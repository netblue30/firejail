# Firejail profile for atool
# Description: Tool for managing file archives of various types
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include atool.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

# Allow perl (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/cpan*
noblacklist ${PATH}/core_perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname atool
ipc-namespace
machine-id
net none
netfilter
no3d
nodvd
nodbus
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-cache
# private-bin atool,perl
private-dev
# without login.defs atool complains and uses UID/GID 1000 by default
private-etc alternatives,passwd,group,login.defs
private-tmp

memory-deny-write-execute

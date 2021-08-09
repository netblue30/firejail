# Firejail profile for Cryptocat
# This file is overwritten after every install/update
# Persistent local customizations
include Cryptocat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Cryptocat

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp

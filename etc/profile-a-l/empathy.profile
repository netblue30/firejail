# Firejail profile for empathy
# Description: GNOME multi-protocol chat and call client
# This file is overwritten after every install/update
# Persistent local customizations
include empathy.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

private-cache
private-tmp

restrict-namespaces

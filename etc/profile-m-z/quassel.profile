# Firejail profile for quassel
# Description: Distributed IRC client
# This file is overwritten after every install/update
# Persistent local customizations
include quassel.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
# QtWebengine needs chroot to set up its own sandbox
seccomp !chroot

private-cache
private-tmp

#restrict-namespaces

# Firejail profile for quassel
# Description: Distributed IRC client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/quassel.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

private-cache
private-tmp

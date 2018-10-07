# Firejail profile for empathy
# Description: GNOME multi-protocol chat and call client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/empathy.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

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

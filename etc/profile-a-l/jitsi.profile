# Firejail profile for jitsi
# This file is overwritten after every install/update
# Persistent local customizations
include jitsi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.jitsi

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-tmp

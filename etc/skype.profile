# Firejail profile for skype
# This file is overwritten after every install/update
# Persistent local customizations
include skype.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Skype

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
#private-bin skype,bash
private-cache
private-dev
private-tmp


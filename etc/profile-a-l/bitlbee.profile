# Firejail profile for bitlbee
# Description: IRC to other chat networks gateway
# This file is overwritten after every install/update
# Persistent local customizations
include bitlbee.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist /sbin
noblacklist /usr/sbin
#noblacklist /var/log

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

netfilter
no3d
nodvd
noinput
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private
private-cache
private-dev
private-tmp

read-write /var/lib/bitlbee
restrict-namespaces

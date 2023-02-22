# Firejail profile for tilp
# This file is overwritten after every install/update
# Persistent local customizations
include tilp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.tilp

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,netlink
seccomp
tracelog

disable-mnt
private-bin tilp
private-cache
private-etc alternatives,fonts,ld.so.cache,ld.so.preload
private-tmp

restrict-namespaces

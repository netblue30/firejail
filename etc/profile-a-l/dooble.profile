# Firejail profile for dooble
# This file is overwritten after every install/update
# Persistent local customizations
include dooble.local
# Backward compatibility
include dooble-qt4.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dooble

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.dooble
whitelist ${DOWNLOADS}
whitelist ${HOME}/.dooble
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-dev
private-tmp

restrict-namespaces

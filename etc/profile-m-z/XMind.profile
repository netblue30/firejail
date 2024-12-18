# Firejail profile for XMind
# This file is overwritten after every install/update
# Persistent local customizations
include XMind.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xmind

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.xmind
whitelist ${HOME}/.xmind
whitelist ${DOWNLOADS}
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
protocol unix,inet,inet6
seccomp

disable-mnt
private-bin XMind,cp,sh
private-tmp
private-dev

restrict-namespaces

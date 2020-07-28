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
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.xmind
whitelist ${HOME}/.xmind
whitelist ${DOWNLOADS}
include whitelist-common.inc

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
private-bin cp,sh,XMind
private-tmp
private-dev


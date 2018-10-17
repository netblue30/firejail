# Firejail profile for pidgin
# Description: Graphical multi-protocol instant messaging client
# This file is overwritten after every install/update
# Persistent local customizations
include pidgin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.purple

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
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
tracelog

private-bin pidgin
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

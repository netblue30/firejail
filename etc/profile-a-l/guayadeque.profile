# Firejail profile for guayadeque
# This file is overwritten after every install/update
# Persistent local customizations
include guayadeque.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.guayadeque
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin guayadeque
private-dev
private-tmp


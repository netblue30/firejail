# Firejail profile for xmms
# This file is overwritten after every install/update
# Persistent local customizations
include xmms.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xmms
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin xmms
private-dev

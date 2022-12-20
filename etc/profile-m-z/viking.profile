# Firejail profile for viking
# Description: GPS data editor, analyzer and viewer
# This file is overwritten after every install/update
# Persistent local customizations
include viking.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.viking
noblacklist ${HOME}/.viking-maps
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6
seccomp

private-dev
private-tmp

restrict-namespaces

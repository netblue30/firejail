# Firejail profile for rawtherapee
# Description: Free cross-platform raw image processing program
# This file is overwritten after every install/update
# Persistent local customizations
include rawtherapee.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/RawTherapee
noblacklist ${HOME}/.config/RawTherapee
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-bin rawtherapee
private-dev
private-tmp

restrict-namespaces

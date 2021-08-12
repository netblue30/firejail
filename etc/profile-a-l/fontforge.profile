# Firejail profile for fontforge
# Description: Font editor
# This file is overwritten after every install/update
# Persistent local customizations
include fontforge.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.FontForge
noblacklist ${DOCUMENTS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
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
protocol unix
seccomp
shell none

private-cache
private-dev
private-tmp


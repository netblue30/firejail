# Firejail profile for clementine
# Description: Modern music player and library organizer
# This file is overwritten after every install/update
# Persistent local customizations
include clementine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Clementine
noblacklist ${HOME}/.config/Clementine
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# blacklisting of ioprio_set system calls breaks clementine
seccomp !ioprio_set

private-dev
private-tmp

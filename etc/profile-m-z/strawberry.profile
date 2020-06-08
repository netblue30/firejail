# Firejail profile for strawberry
# Description: A music player and music collection organizer
# This file is overwritten after every install/update
# Persistent local customizations
include strawberry.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/strawberry
noblacklist ${HOME}/.config/strawberry
noblacklist ${HOME}/.local/share/strawberry
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
# blacklisting of ioprio_set system calls breaks strawberry
seccomp !ioprio_set

private-dev
private-tmp

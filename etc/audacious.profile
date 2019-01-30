# Firejail profile for audacious
# Description: Small and fast audio player which supports lots of formats
# This file is overwritten after every install/update
# Persistent local customizations
include audacious.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Audaciousrc
noblacklist ${HOME}/.config/audacious
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
# private-bin audacious
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

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
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

# private-bin audacious
private-cache
private-dev
private-tmp

# dbus needed for MPRIS
# dbus-user none
# dbus-system none

restrict-namespaces

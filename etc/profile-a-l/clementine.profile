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
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc

apparmor
caps.drop all
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# blacklisting of ioprio_set system calls breaks clementine
seccomp !ioprio_set

private-dev
private-tmp

dbus-system none
#dbus-user none

restrict-namespaces

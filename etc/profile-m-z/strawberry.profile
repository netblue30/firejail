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
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# blacklisting of ioprio_set system calls breaks strawberry
seccomp !ioprio_set
tracelog

disable-mnt
private-bin strawberry,strawberry-tagreader
private-cache
private-dev
private-etc @tls-ca,host.conf
private-tmp

dbus-system none

restrict-namespaces

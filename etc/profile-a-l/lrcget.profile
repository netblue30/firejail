# Firejail profile for lrcget
# Description: Mass-downloading LRC synced lyrics for offline music
# This file is overwritten after every install/update
# Persistent local customizations
include lrcget.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/net.lrclib.lrcget
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
# blacklisting of ioprio_set system calls breaks lrcget
seccomp !ioprio_set

disable-mnt
private-bin lrcget
private-cache
private-dev
private-etc @tls-ca,host.conf
private-tmp

dbus-system none

restrict-namespaces

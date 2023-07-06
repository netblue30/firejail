# Firejail profile for nomacs
# Description: a fast and small image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include nomacs.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nomacs
noblacklist ${HOME}/.local/share/nomacs
noblacklist ${HOME}/.local/share/data/nomacs
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
protocol unix,inet,inet6,netlink
seccomp
tracelog

#private-bin nomacs
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

restrict-namespaces

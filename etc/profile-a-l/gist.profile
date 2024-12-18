# Firejail profile for gist
# Description: Potentially the best command line gister
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gist.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist ${HOME}/.gist

# Allow ruby (blacklisted by disable-interpreters.inc)
include allow-ruby.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

mkdir ${HOME}/.gist
whitelist ${HOME}/.gist
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
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
tracelog

disable-mnt
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

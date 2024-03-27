# Firejail profile for mocp
# Description: A powerful & easy to use console audio player
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mocp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.moc
noblacklist ${MUSIC}

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

mkdir ${HOME}/.moc
whitelist ${HOME}/.moc
whitelist ${MUSIC}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

private-bin mocp
private-cache
private-dev
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-write ${HOME}/.moc
restrict-namespaces

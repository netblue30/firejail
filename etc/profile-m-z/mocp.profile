# Firejail profile for mocp
# Description: A powerful & easy to use console audio player
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mocp.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.moc
nodeny  ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
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
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin mocp
private-cache
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,group,machine-id,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-write ${HOME}/.moc

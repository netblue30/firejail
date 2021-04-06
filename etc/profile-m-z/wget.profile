# Firejail profile for wget
# Description: Retrieves files from the web
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include wget.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.netrc
noblacklist ${HOME}/.wget-hsts
noblacklist ${HOME}/.wgetrc

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
# Depending on workflow you can add the next line to your wget.local.
#include disable-xdg.inc

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
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin wget
private-cache
private-dev
# Depending on workflow you can add the next line to your wget.local.
#private-etc alternatives,ca-certificates,crypto-policies,pki,resolv.conf,ssl,wgetrc
#private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

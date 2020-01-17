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

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# depending on workflow you can uncomment the below or put 'include disable-xdg.inc' in your wget.local
#include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
nodbus
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
shell none
tracelog

private-bin wget
private-cache
private-dev
# depending on workflow you can uncomment the below or put this private-etc in your wget.local
#private-etc alternatives,ca-certificates,crypto-policies,pki,resolv.conf,ssl,wgetrc
#private-tmp

memory-deny-write-execute

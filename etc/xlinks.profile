# Firejail profile for xlinks
# Description: Text WWW browser (X11)
# This file is overwritten after every install/update
# Persistent local customizations
include xlinks.local
# Persistent global definitions
# include globals.local

noblacklist ${HOME}/.links

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.links
whitelist ${HOME}/.links
whitelist ${DOWNLOADS}

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-tmp
private-etc ca-certificates,crypto-policies,resolv.conf,ssl
# uncomment if you want to allow access only to user-configured associated programs
# private-bin xlinks,sh,PROGRAM1,PROGRAM2,PROGRAM3

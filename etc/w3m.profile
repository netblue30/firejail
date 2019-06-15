# Firejail profile for w3m
# Description: WWW browsable pager with excellent tables/frames support
# This file is overwritten after every install/update
# Persistent local customizations
include w3m.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.w3m

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
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

# private-bin w3m
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,pki,resolv.conf,ssl
private-tmp

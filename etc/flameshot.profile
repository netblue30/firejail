# Firejail profile for flameshot
# Description: Powerful yet simple-to-use screenshot software
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include flameshot.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
# nodbus
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

disable-mnt
private-bin flameshot
private-cache
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.conf,pki,resolv.conf,ssl
private-dev
private-tmp


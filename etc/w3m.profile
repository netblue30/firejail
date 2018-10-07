# Firejail profile for w3m
# Description: WWW browsable pager with excellent tables/frames support
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/w3m.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.w3m

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin w3m
private-cache
private-dev
private-etc resolv.conf,ssl,pki,ca-certificates,crypto-policies
private-tmp

# Firejail profile for Beyond All Reason
# Description: Open source real time strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include beyondallreason.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/Beyond All Reason
noblacklist ${HOME}/Downloads

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/Beyond All Reason
whitelist ${HOME}/Beyond All Reason
whitelist ${HOME}/Downloads

caps.drop all
ipc-namespace
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
#seccomp # crashes the launcher
shell none

disable-mnt
private-cache
private-dev
private-etc ca-certificates,crypto-policies,pki,resolv.conf,ssl
private-tmp

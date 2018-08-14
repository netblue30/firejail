# Firejail profile for electrum
# Description: Lightweight Bitcoin wallet
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/electrum.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.electrum

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

mkdir ${HOME}/.electrum
whitelist ${HOME}/.electrum
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
#nodbus
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

disable-mnt
private-bin electrum,python*
private-cache
private-dev
private-etc fonts,dconf,ca-certificates,ssl,pki,crypto-policies,machine-id
private-tmp

noexec ${HOME}
noexec /tmp

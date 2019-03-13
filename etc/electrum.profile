# Firejail profile for electrum
# Description: Lightweight Bitcoin wallet
# This file is overwritten after every install/update
# Persistent local customizations
include electrum.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.electrum

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.electrum
whitelist ${HOME}/.electrum
include whitelist-common.inc
include whitelist-var-common.inc

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
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin electrum,python*
private-cache
private-dev
private-etc alternatives,fonts,dconf,ca-certificates,ssl,pki,crypto-policies,machine-id
private-tmp

noexec ${HOME}
noexec /tmp

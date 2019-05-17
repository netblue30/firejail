# Firejail profile for xiphos
# Description: Environment for Bible reading, study, and research
# This file is overwritten after every install/update
# Persistent local customizations
include xiphos.local
# Persistent global definitions
include globals.local

blacklist ${HOME}/.bashrc

noblacklist ${HOME}/.sword
noblacklist ${HOME}/.xiphos

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${HOME}/.sword
whitelist ${HOME}/.xiphos
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
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

disable-mnt
private-bin xiphos
private-cache
private-dev
private-etc alternatives,fonts,resolv.conf,sword,ca-certificates,ssli,sword.conf,pki,crypto-policies
private-tmp

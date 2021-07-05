# Firejail profile for xiphos
# Description: Environment for Bible reading, study, and research
# This file is overwritten after every install/update
# Persistent local customizations
include xiphos.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.sword
nodeny  ${HOME}/.xiphos

deny  ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.sword
mkdir ${HOME}/.xiphos
allow  ${HOME}/.sword
allow  ${HOME}/.xiphos
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
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
private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,resolv.conf,ssli,sword,sword.conf
private-tmp

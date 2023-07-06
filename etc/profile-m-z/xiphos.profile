# Firejail profile for xiphos
# Description: Environment for Bible reading, study, and research
# This file is overwritten after every install/update
# Persistent local customizations
include xiphos.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.sword
noblacklist ${HOME}/.xiphos

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.sword
mkdir ${HOME}/.xiphos
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
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin xiphos
private-cache
private-dev
private-etc @tls-ca,sword,sword.conf
private-tmp

restrict-namespaces

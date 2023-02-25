# Firejail profile for bitcoin-qt
# Description: Bitcoin is a peer-to-peer network based digital currency
# This file is overwritten after every install/update
# Persistent local customizations
include bitcoin-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bitcoin
noblacklist ${HOME}/.config/Bitcoin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.bitcoin
mkdir ${HOME}/.config/Bitcoin
whitelist ${HOME}/.bitcoin
whitelist ${HOME}/.config/Bitcoin
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
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

private-bin bitcoin-qt
private-dev
# Causes problem with loading of libGL.so
#private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
private-tmp

memory-deny-write-execute
restrict-namespaces

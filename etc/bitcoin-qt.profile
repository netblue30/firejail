# Firejail profile for bitcoin-qt
# Description: Bitcoin is a peer-to-peer network based digital currency
# This file is overwritten after every install/update
# Persistent local customizations
include bitcoin-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bitcoin

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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

private-bin bitcoin-qt
private-dev
# Causes problem with loading of libGL.so
#private-etc alternatives,fonts,ca-certificates,ssl,pki,crypto-policies
# Works, but QT complains about OpenSSL a bit.
#private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

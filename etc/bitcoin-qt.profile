# Firejail profile for bitcoin-qt
# Description: Bitcoin is a peer-to-peer network based digital currency
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bitcoin-qt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.bitcoin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.bitcoin
mkdir ${HOME}/.config/Bitcoin
whitelist ${HOME}/.bitcoin
whitelist ${HOME}/.config/Bitcoin

include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

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
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin bitcoin-qt
private-dev
# Causes problem with loading of libGL.so
#private-etc fonts,ca-certificates,ssl,pki,crypto-policies
# Works, but QT complains about OpenSSL a bit.
#private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

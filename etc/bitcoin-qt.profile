# Firejail profile for bitcoin-qt
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bitcoin-qt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.bitcoin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.bitcoin
whitelist ${HOME}/.bitcoin

whitelist ${HOME}/.bitcoin-testnet

mkdir ${HOME}/.config/Bitcoin
whitelist ${HOME}/.config/Bitcoin

include /etc/firejail/whitelist-common.inc

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
#private-etc fonts  # Causes problem with loading of libGL.so
#private-lib  # Works, but QT complains about OpenSSL a bit.
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

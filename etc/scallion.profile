# Firejail profile for scallion
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/scallion.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${PATH}/llvm*
noblacklist /usr/lib/llvm*
noblacklist ${PATH}/openssl
noblacklist ${PATH}/openssl-1.0
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

disable-mnt
private
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

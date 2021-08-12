# Firejail profile for scallion
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include scallion.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/llvm*
noblacklist ${PATH}/openssl
noblacklist ${PATH}/openssl-1.0
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private
private-dev
private-tmp

dbus-user none
dbus-system none

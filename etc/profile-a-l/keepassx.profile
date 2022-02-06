# Firejail profile for keepassx
# Description: Cross Platform Password Manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepassx.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassx
noblacklist ${HOME}/.keepassx
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin keepassx,keepassx2
# Note: private-dev prevents the program from seeing new devices (such as
# hardware keys) on /dev after it has already started; add "ignore nou2f" to
# keepassxc.local if this is an issue (see #4883).
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.preload,machine-id
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

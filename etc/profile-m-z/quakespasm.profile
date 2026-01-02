# Firejail profile for quakespasm
# Description: Modern Quake engine preserving classic gameplay and graphics
# This file is overwritten after every install/update
# Persistent local customizations
include quakespasm.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.quakespasm

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.quakespasm
whitelist ${HOME}/.quakespasm
include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin quakespasm
private-cache
private-dev
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

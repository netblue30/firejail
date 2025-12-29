# Firejail profile for openra
# Description: Classic RTS game engine for Command & Conquer and Dune 2000
# This file is overwritten after every install/update
# Persistent local customizations
include openra.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/openra

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/openra
whitelist ${HOME}/.config/openra
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
private-bin bash,dash,sh,python*,openra-ra
private-cache
private-dev
private-etc @games,@tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

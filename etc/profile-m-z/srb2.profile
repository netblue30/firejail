# Firejail profile for srb2
# Description: Sonic Robo Blast 2, a 3D Sonic fan game
# This file is overwritten after every install/update
# Persistent local customizations
include srb2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.srb2

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.srb2
whitelist ${HOME}/.srb2
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
noinput
nogroups
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
private-bin srb2
private-cache
private-dev
private-etc @tls-ca,@games,@x11
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

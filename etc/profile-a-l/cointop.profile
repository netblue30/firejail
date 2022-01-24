# Firejail profile for cointop
# Description: TUI for tracking cryptocurrency stats
# This file is overwritten after every install/update
# Persistent local customizations
include cointop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/cointop

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

mkdir ${HOME}/.config/cointop
whitelist ${HOME}/.config/cointop
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin cointop
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

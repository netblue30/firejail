# Firejail profile for warmux
# Description: a convivial mass murder game
# This file is overwritten after every install/update
# Persistent local customizations
include warmux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/wormux
noblacklist ${HOME}/.local/share/wormux
noblacklist ${HOME}/.wormux

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/wormux
mkdir ${HOME}/.local/share/wormux
mkdir ${HOME}/.wormux
whitelist ${HOME}/.config/wormux
whitelist ${HOME}/.local/share/wormux
whitelist ${HOME}/.wormux
whitelist /usr/share/warmux
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin warmux
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,machine-id,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl
private-tmp

dbus-user none
dbus-system none

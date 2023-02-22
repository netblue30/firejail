# Firejail profile for coyim
# Description: GTK Jabber client written in Go
# This file is overwritten after every install/update
# Persistent local customizations
include coyim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/coyim

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/coyim
whitelist ${HOME}/.config/coyim
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.preload,machine-id,pki,ssl
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
restrict-namespaces

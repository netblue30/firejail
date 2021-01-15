# Firejail profile for Node.js
# Description: Common profile for npm/yarn
# This file is overwritten after every install/update
# Persistent local customizations
include nodejs-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

ignore noexec ${HOME}

include allow-bin-sh.inc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none

disable-mnt
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,login.defs,mime.types,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

dbus-user none
dbus-system none

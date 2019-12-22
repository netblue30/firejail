# Firejail profile for geekbench
# Description: A cross-platform benchmark that measures processor and memory performance
# This file is overwritten after every install/update
# Persistent local customizations
include geekbench.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
hostname geekbench
ipc-namespace
machine-id
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin bash,geekbenc*,sh
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-lib libstdc++.so.*
private-opt none
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

read-only ${HOME}

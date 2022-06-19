# Firejail profile for cawbird
# Description: Open-source Twitter client for Linux
# This file is overwritten after every install/update
# Persistent local customizations
include cawbird.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/cawbird

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin cawbird
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,mime.types,nsswitch.conf,pki,resolv.conf,ssl,X11,xdg
private-tmp

# dbus-user none
dbus-system none

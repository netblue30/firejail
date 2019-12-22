# Firejail profile for netactview
# Description: A graphical network connections viewer similar in functionality to netstat
# This file is overwritten after every install/update
# Persistent local customizations
include netactview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.netactview

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.netactview
whitelist ${HOME}/.netactview
whitelist /usr/share/netactview
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
seccomp
shell none

disable-mnt
private-bin netactview,netactview_polkit
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-lib
private-tmp

memory-deny-write-execute

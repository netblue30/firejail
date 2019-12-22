# Firejail profile for zeal
# Description: Offline documentation browser
# This file is overwritten after every install/update
# Persistent local customizations
include zeal.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Zeal
noblacklist ${HOME}/.cache/Zeal
noblacklist ${HOME}/.local/share/Zeal

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Zeal
mkdir ${HOME}/.cache/Zeal
mkdir ${HOME}/.local/share/Zeal
whitelist ${HOME}/.config/Zeal
whitelist ${HOME}/.cache/Zeal
whitelist ${HOME}/.local/share/Zeal
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
private-bin zeal
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute

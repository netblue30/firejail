# Firejail profile for xiphos
# Description: Environment for Bible reading, study, and research
# This file is overwritten after every install/update
# Persistent local customizations
include xiphos.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.sword
noblacklist ${HOME}/.xiphos

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.sword
mkdir ${HOME}/.xiphos
whitelist ${HOME}/.sword
whitelist ${HOME}/.xiphos
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
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
private-bin xiphos
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,sword,sword.conf,xdg
private-tmp

# Firejail profile for shortwave
# Description: Listen to internet radio
# This file is overwritten after every install/update
# Persistent local customizations
include shortwave.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/Shortwave
nodeny  ${HOME}/.local/share/Shortwave

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Shortwave
mkdir ${HOME}/.local/share/Shortwave
allow  ${HOME}/.cache/Shortwave
allow  ${HOME}/.local/share/Shortwave
allow  /usr/share/shortwave
include whitelist-common.inc
include whitelist-runuser-common.inc
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
private-bin shortwave
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gconf,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

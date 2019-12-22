# Firejail profile for bibletime
# Description: Bible study tool
# This file is overwritten after every install/update
# Persistent local customizations
include bibletime.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bibletime
noblacklist ${HOME}/.sword
noblacklist ${HOME}/.local/share/bibletime

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.bibletime
mkdir ${HOME}/.sword
mkdir ${HOME}/.local/share/bibletime
whitelist ${HOME}/.bibletime
whitelist ${HOME}/.sword
whitelist ${HOME}/.local/share/bibletime
whitelist /usr/share/bibletime
whitelist /usr/share/sword
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
# private-bin bibletime,qt5ct
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,sword,sword.conf,xdg
private-tmp

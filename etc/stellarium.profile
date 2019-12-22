# Firejail profile for stellarium
# Description: Real-time photo-realistic sky generator
# This file is overwritten after every install/update
# Persistent local customizations
include stellarium.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/stellarium
noblacklist ${HOME}/.stellarium

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/stellarium
mkdir ${HOME}/.stellarium
whitelist ${HOME}/.config/stellarium
whitelist ${HOME}/.stellarium
include whitelist-common.inc
include whitelist-var-common.inc

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
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin stellarium
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp


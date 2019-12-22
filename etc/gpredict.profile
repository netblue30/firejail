# Firejail profile for gpredict
# Description: Satellite tracking program
# This file is overwritten after every install/update
# Persistent local customizations
include gpredict.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Gpredict

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Gpredict
whitelist ${HOME}/.config/Gpredict
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin gpredict
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp


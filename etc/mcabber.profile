# Firejail profile for mcabber
# Description: Small Jabber (XMPP) console client
# This file is overwritten after every install/update
# Persistent local customizations
include mcabber.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mcabber
noblacklist ${HOME}/.mcabberrc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

private-bin mcabber
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg

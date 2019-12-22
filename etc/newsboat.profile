# Firejail profile for Newsboat
# Description: RSS program
# This file is overwritten after every install/update
# Persistent local customizations
include newsboat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.newsboat

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.newsboat
whitelist ${HOME}/.newsboat
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
private-bin newsboat
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute

# Firejail profile for utox
# Description: Lightweight Tox client
# This file is overwritten after every install/update
# Persistent local customizations
include utox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Tox
noblacklist ${HOME}/.config/tox

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/tox
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/tox
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin utox
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute

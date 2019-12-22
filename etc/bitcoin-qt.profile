# Firejail profile for bitcoin-qt
# Description: Bitcoin is a peer-to-peer network based digital currency
# This file is overwritten after every install/update
# Persistent local customizations
include bitcoin-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bitcoin
noblacklist ${HOME}/.config/Bitcoin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.bitcoin
mkdir ${HOME}/.config/Bitcoin
whitelist ${HOME}/.bitcoin
whitelist ${HOME}/.config/Bitcoin
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
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

private-bin bitcoin-qt
private-dev
#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,fonts,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
# Causes problem with loading of libGL.so
private-tmp

memory-deny-write-execute

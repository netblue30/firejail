# Firejail profile for keepass
# Description: An easy-to-use password manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepass.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/KeePass
noblacklist ${HOME}/.config/keepass
noblacklist ${HOME}/.keepass
noblacklist ${HOME}/.local/share/KeePass
noblacklist ${HOME}/.local/share/keepass
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
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

private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp


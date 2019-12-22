# Firejail profile for simple-scan
# Description: Simple Scanning Utility
# This file is overwritten after every install/update
# Persistent local customizations
include simple-scan.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/simple-scan
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/simple-scan
include whitelist-usr-share-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
# novideo
protocol unix,inet,inet6,netlink
# blacklisting of ioperm system calls breaks simple-scan
seccomp !ioperm
shell none
tracelog

# private-bin simple-scan
# private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
# private-tmp

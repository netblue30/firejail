# Firejail profile for skanlite
# Description: Image scanner based on the KSane backend
# This file is overwritten after every install/update
# Persistent local customizations
include skanlite.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
# novideo
protocol unix,inet,inet6,netlink
# blacklisting of ioperm system calls breaks skanlite
seccomp !ioperm
shell none

# private-bin kbuildsycoca4,kdeinit4,skanlite
# private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
# private-tmp

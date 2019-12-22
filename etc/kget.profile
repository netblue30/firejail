# Firejail profile for kget
# Description: Download manager
# This file is overwritten after every install/update
# Persistent local customizations
include kget.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kgetrc
noblacklist ${HOME}/.kde/share/apps/kget
noblacklist ${HOME}/.kde/share/config/kgetrc
noblacklist ${HOME}/.kde4/share/apps/kget
noblacklist ${HOME}/.kde4/share/config/kgetrc
noblacklist ${HOME}/.local/share/kget

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
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

private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

# memory-deny-write-execute

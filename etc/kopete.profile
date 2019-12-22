# Firejail profile for kopete
# Description: Instant messaging and chat application
# This file is overwritten after every install/update
# Persistent local customizations
include kopete.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kde/share/apps/kopete
noblacklist ${HOME}/.kde/share/config/kopeterc
noblacklist ${HOME}/.kde4/share/apps/kopete
noblacklist ${HOME}/.kde4/share/config/kopeterc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /var/lib/winpopup
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
writable-var


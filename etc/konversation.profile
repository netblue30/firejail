# Firejail profile for konversation
# Description: User friendly Internet Relay Chat (IRC) client for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include konversation.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/konversationrc
noblacklist ${HOME}/.kde/share/config/konversationrc
noblacklist ${HOME}/.kde4/share/config/konversationrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin kbuildsycoca4,konversation
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

# memory-deny-write-execute

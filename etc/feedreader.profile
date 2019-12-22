# Firejail profile for feedreader
# Description: RSS client
# This file is overwritten after every install/update
# Persistent local customizations
include feedreader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/feedreader
noblacklist ${HOME}/.local/share/feedreader

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/feedreader
mkdir ${HOME}/.local/share/feedreader
whitelist ${HOME}/.cache/feedreader
whitelist ${HOME}/.local/share/feedreader
whitelist /usr/share/feedreader
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp


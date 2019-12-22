# Firejail profile for dillo
# Description: Small and fast web browser
# This file is overwritten after every install/update
# Persistent local customizations
include dillo.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dillo

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.dillo
mkdir ${HOME}/.fltk
whitelist ${DOWNLOADS}
whitelist ${HOME}/.dillo
whitelist ${HOME}/.fltk
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,dillo,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

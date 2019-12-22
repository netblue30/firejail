# Firejail profile for xonotic
# Description: A free, fast-paced crossplatform first-person shooter
# This file is overwritten after every install/update
# Persistent local customizations
include xonotic.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xonotic

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.xonotic
whitelist ${HOME}/.xonotic
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin bash,blind-id,darkplaces-glx,darkplaces-sdl,dirname,grep,ldd,netstat,ps,readlink,sh,uname,xonotic,xonotic-glx,xonotic-linux32-dedicated,xonotic-linux32-glx,xonotic-linux32-sdl,xonotic-linux64-dedicated,xonotic-linux64-glx,xonotic-linux64-sdl,xonotic-sdl
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp


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
include disable-xdg.inc

mkdir ${HOME}/.xonotic
whitelist ${HOME}/.xonotic
whitelist /usr/share/xonotic
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
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
tracelog

disable-mnt
private-cache
private-bin basename,bash,blind-id,cut,darkplaces-glx,darkplaces-sdl,dirname,glxinfo,grep,head,ldd,netstat,ps,readlink,sed,sh,uname,xonotic,xonotic-glx,xonotic-linux32-dedicated,xonotic-linux32-glx,xonotic-linux32-sdl,xonotic-linux64-dedicated,xonotic-linux64-glx,xonotic-linux64-sdl,xonotic-sdl,xonotic-sdl-wrapper,zenity
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,machine-id,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.xonotic

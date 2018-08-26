# Firejail profile for xonotic
# Description: A free, fast-paced crossplatform first-person shooter
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xonotic.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.xonotic

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.xonotic
whitelist ${HOME}/.xonotic
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin bash,blind-id,darkplaces-glx,darkplaces-sdl,dirname,grep,ldd,netstat,ps,readlink,sh,uname,xonotic,xonotic-glx,xonotic-linux32-dedicated,xonotic-linux32-glx,xonotic-linux32-sdl,xonotic-linux64-dedicated,xonotic-linux64-glx,xonotic-linux64-sdl,xonotic-sdl
private-dev
private-etc asound.conf,ca-certificates,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,nsswitch.conf,passwd,pulse,resolv.conf,ssl,pki,crypto-policies,machine-id
private-tmp

noexec ${HOME}
noexec /tmp

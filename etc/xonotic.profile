# Firejail profile for xonotic
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xonotic.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.xonotic

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.xonotic
whitelist ${HOME}/.xonotic
include /etc/firejail/whitelist-common.inc

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
private-bin xonotic-sdl,xonotic-glx,blind-id
private-dev
private-etc asound.conf,ca-certificates,drirc,fonts,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,nsswitch.conf,pulse,resolv.conf,ssl
private-tmp

noexec ${HOME}
noexec /tmp

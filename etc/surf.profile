# Firejail profile for surf
# Description: Simple web browser by suckless community
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/surf.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.surf

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.surf
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin ls,surf,sh,bash,curl,dmenu,printf,sed,sleep,st,stterm,xargs,xprop
private-dev
private-etc passwd,group,hosts,resolv.conf,fonts,ssl,pki,ca-certificates,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp

# Firejail profile for surf
# Description: Simple web browser by suckless community
# This file is overwritten after every install/update
# Persistent local customizations
include surf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.surf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc

mkdir ${HOME}/.surf
whitelist ${HOME}/.surf
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
netfilter
nodvd
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,curl,dmenu,ls,printf,sed,sh,sleep,st,stterm,surf,xargs,xprop
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,group,hosts,machine-id,passwd,pki,resolv.conf,ssl
private-tmp


# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include discord-common.local
# Persistent global definitions
# already included by caller profile
#include globals.local

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}

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

private-bin sh,xdg-mime,tr,sed,echo,head,cut,xdg-open,grep,egrep,bash,zsh
private-dev
private-etc alternatives,fonts,machine-id,localtime,ld.so.cache,ca-certificates,ssl,pki,crypto-policies,resolv.conf
private-tmp

noexec ${HOME}
noexec /tmp

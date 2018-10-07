# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/discord-common.local
# Persistent global definitions
# already included by caller profile
#include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp

private-bin sh,xdg-mime,tr,sed,echo,head,cut,xdg-open,grep,egrep,bash,zsh
private-dev
private-etc fonts,machine-id,localtime,ld.so.cache,ca-certificates,ssl,pki,crypto-policies,resolv.conf
private-tmp

noexec ${HOME}
noexec /tmp

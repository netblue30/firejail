# Firejail profile for teams-for-linux
# Description: Teams for Linux is an Electron application for Microsoft's team collaboration and chat program
# This file is overwritten after every install/update
# Persistent local customizations
include teams-for-linux.local
# Persistent global definitions
include globals.local

caps.drop all
whitelist ${HOME}/.config/teams-for-linux
noblacklist ${HOME}/.config/teams-for-linux
include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-interpreters.inc
include disable-exec.inc
include disable-programs.inc

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
shell none

private-bin sh,xdg-mime,tr,sed,echo,head,cut,xdg-open,grep,egrep,bash,zsh,teams-for-linux
private-dev
private-etc fonts,machine-id,localtime,ld.so.cache,ca-certificates,ssl,pki,crypto-policies,resolv.conf
private-tmp
private-cache
disable-mnt



# Firejail profile for teams-for-linux
# Description: Teams for Linux is an Electron application for Microsoft's team collaboration and chat program
# This file is overwritten after every install/update
# Persistent local customizations
include teams-for-linux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/teams-for-linux

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/teams-for-linux
whitelist ${HOME}/.config/teams-for-linux
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

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
shell none

disable-mnt
private-bin bash,cut,echo,egrep,grep,head,sed,sh,teams-for-linux,tr,xdg-mime,xdg-open,zsh
private-cache
private-dev
private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,resolv.conf,ssl
private-tmp

# Firejail profile for Discord
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/discord.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord

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

private-bin discord,sh,xdg-mime,tr,sed,echo,head,cut,xdg-open,grep,egrep
private-dev
private-etc fonts,machine-id
private-tmp

noexec ${HOME}
noexec /tmp

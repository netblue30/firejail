# Firejail profile for teams-for-linux
# Description: Unofficial Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Persistent local customizations
include teams-for-linux.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/teams-for-linux

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/teams-for-linux
whitelist ${HOME}/.config/teams-for-linux
include whitelist-common.inc
include whitelist-var-common.inc

ignore nodbus
nou2f
novideo
shell none

disable-mnt
private-bin bash,cut,echo,egrep,grep,head,sed,sh,teams-for-linux,tr,xdg-mime,xdg-open,zsh
private-cache
private-dev
private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,resolv.conf,ssl
private-tmp

# Redirect
include electron.profile

# Firejail profile for teams-for-linux
# Description: Unofficial Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Persistent local customizations
include teams-for-linux.local
# Persistent global definitions
include globals.local

# See ABC.XYZ.ADD.A.NOTE
ignore include disable-xdg.inc

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/teams-for-linux

mkdir ${HOME}/.config/teams-for-linux
whitelist ${HOME}/.config/teams-for-linux
include whitelist-var-common.inc

disable-mnt
private-bin bash,cut,echo,egrep,grep,head,sed,sh,teams-for-linux,tr,xdg-mime,xdg-open,zsh
private-cache
private-dev
private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,resolv.conf,ssl
private-tmp

# Redirect
include electron.profile
